--[[
    Skelly Hub Rivals Script v5.0
    Drawing-Based Menu (ImGui Style)
    Press Right Shift to toggle
]]

-- ======================================================================
-- SERVICES
-- ======================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

-- ======================================================================
-- CONFIGURATION
-- ======================================================================

local Config = {
    Aimbot = {
        Enabled = false,
        Silent = false,
        AimKey = Enum.UserInputType.MouseButton2,
        FOV = 120,
        Smoothness = 0.3,
        AimPart = "Head",
        MaxDistance = 500,
        TeamCheck = true,
        VisibleCheck = false,
        ShowFOVCircle = true,
        Prediction = false,
        PredictionAmount = 0.2,
        HitChance = 100,
    },
    ESP = {
        Enabled = false,
        ShowBoxes = true,
        ShowNames = true,
        ShowHealth = true,
        ShowDistance = true,
        ShowTracers = false,
        TeamCheck = true,
        MaxDistance = 1000,
    },
    Player = {
        InfiniteJump = false,
        Fly = false,
        FlySpeed = 50,
        WalkSpeed = 16,
        JumpPower = 50,
        GodMode = false,
        NoFallDamage = false,
        FullBright = false,
        AntiAFK = false,
        AutoFarm = false,
        NoClip = false,
    },
    Visual = {
        MenuKey = Enum.KeyCode.RightShift,
        Watermark = "💀 skelly-hub.lol",
    }
}

-- ======================================================================
-- STATE VARIABLES
-- ======================================================================

local aimKeyHeld = false
local fovCircle = nil
local menuOpen = false
local espActive = false
local aimbotActive = false
local silentAimActive = false

-- Drawing objects for menu
local menuDrawings = {}
local menuClickAreas = {}
local currentTab = 1
local tabs = {"Aimbot", "ESP", "Player", "Misc"}

-- ======================================================================
-- UTILITY FUNCTIONS
-- ======================================================================

local function IsAlive(player)
    if not player or not player.Character then return false end
    local h = player.Character:FindFirstChild("Humanoid")
    return h and h.Health > 0
end

local function GetRootPart(character)
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart") or 
           character:FindFirstChild("Torso") or 
           character:FindFirstChild("UpperTorso")
end

local function GetAimPart(character, partName)
    if not character then return nil end
    if partName == "Head" then return character:FindFirstChild("Head") end
    if partName == "Body" then return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") end
    return character:FindFirstChild(partName) or GetRootPart(character)
end

local function IsTeammate(player)
    if not LocalPlayer or not player then return false end
    if LocalPlayer.Team and player.Team then return LocalPlayer.Team == player.Team end
    if LocalPlayer.TeamColor and player.TeamColor then return LocalPlayer.TeamColor == player.TeamColor end
    return false
end

-- ======================================================================
-- DRAWING HELPERS
-- ======================================================================

local function CreateDrawing(dType, props)
    local success, d = pcall(function()
        local drawing = Drawing.new(dType)
        for k, v in pairs(props or {}) do
            drawing[k] = v
        end
        return drawing
    end)
    if success and d then
        table.insert(menuDrawings, d)
        return d
    end
    return nil
end

local function ClearMenu()
    for _, d in pairs(menuDrawings) do
        pcall(function() d:Remove() end)
    end
    menuDrawings = {}
    menuClickAreas = {}
end

local function CreateText(text, position, color, size, center)
    return CreateDrawing("Text", {
        Text = text,
        Position = position,
        Color = color or Color3.fromRGB(220, 220, 220),
        Size = size or 14,
        Center = center or false,
        Outline = true,
        OutlineColor = Color3.new(0,0,0),
        Font = Drawing.Fonts.UI,
    })
end

local function CreateRect(position, size, color, thickness, filled)
    return CreateDrawing("Square", {
        Position = position,
        Size = size,
        Color = color or Color3.fromRGB(40, 40, 60),
        Thickness = thickness or 1,
        Filled = filled or false,
        Transparency = 0.8,
    })
end

local function CreateLine(from, to, color, thickness)
    return CreateDrawing("Line", {
        From = from,
        To = to,
        Color = color or Color3.fromRGB(100, 100, 140),
        Thickness = thickness or 1,
    })
end

-- ======================================================================
-- FOV CIRCLE
-- ======================================================================

local function UpdateFOVCircle()
    if Config.Aimbot.ShowFOVCircle and Config.Aimbot.Enabled then
        if not fovCircle then
            fovCircle = Drawing.new("Circle")
            fovCircle.Thickness = 2
            fovCircle.NumSides = 64
            fovCircle.Color = Color3.fromRGB(100, 100, 140)
            fovCircle.Transparency = 0.6
            fovCircle.Visible = true
            fovCircle.Filled = false
        end
        local viewport = Camera.ViewportSize
        local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
        fovCircle.Position = center
        fovCircle.Radius = Config.Aimbot.FOV
        fovCircle.Visible = true
    else
        if fovCircle then
            fovCircle.Visible = false
        end
    end
end

-- ======================================================================
-- AIMBOT CORE
-- ======================================================================

local function GetBestTarget()
    local best = nil
    local bestScore = math.huge
    local fov = Config.Aimbot.FOV
    local maxDist = Config.Aimbot.MaxDistance
    local camPos = Camera.CFrame.Position
    local cx, cy = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then
            if Config.Aimbot.TeamCheck and IsTeammate(player) then continue end
            
            local aimPart = GetAimPart(player.Character, Config.Aimbot.AimPart)
            if not aimPart then continue end
            
            if Config.Aimbot.VisibleCheck then
                local ray = Ray.new(camPos, (aimPart.Position - camPos).Unit * maxDist)
                local hit = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
                if hit and hit.Parent ~= player.Character then continue end
            end
            
            local sp, onScreen = Camera:WorldToScreenPoint(aimPart.Position)
            if not onScreen then continue end
            
            local d = math.sqrt((sp.X - cx)^2 + (sp.Y - cy)^2)
            if d > fov then continue end
            
            local wd = (camPos - aimPart.Position).Magnitude
            if wd > maxDist then continue end
            
            if Config.Aimbot.HitChance < 100 then
                local chance = math.random(1, 100)
                if chance > Config.Aimbot.HitChance then continue end
            end
            
            if d < bestScore then
                bestScore = d
                best = {Player = player, AimPart = aimPart}
            end
        end
    end
    return best
end

local function DoAimbot()
    if not aimbotActive or not Config.Aimbot.Enabled or not aimKeyHeld then return end
    
    local target = GetBestTarget()
    if not target then return end
    
    local targetPos = target.AimPart.Position
    
    if Config.Aimbot.Prediction then
        local velocity = target.AimPart.Velocity
        if velocity then
            targetPos = targetPos + (velocity * Config.Aimbot.PredictionAmount)
        end
    end
    
    local camPos = Camera.CFrame.Position
    local dir = (targetPos - camPos).Unit
    
    local smooth = Config.Aimbot.Smoothness
    if smooth > 0 then
        local curr = Camera.CFrame.LookVector
        local newLook = curr + (dir - curr) * (1 - smooth)
        if newLook.Magnitude > 0 then dir = newLook.Unit end
    end
    
    Camera.CFrame = CFrame.lookAt(camPos, camPos + dir)
end

local function DoSilentAim()
    if not silentAimActive or not Config.Aimbot.Silent or not aimKeyHeld then return end
    local target = GetBestTarget()
    if not target then return end
    local mouse = LocalPlayer:GetMouse()
    if mouse then mouse.Hit = CFrame.new(target.AimPart.Position) end
end

-- ======================================================================
-- INPUT HANDLING
-- ======================================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Config.Aimbot.AimKey then
        aimKeyHeld = true
    end
    
    if input.KeyCode == Config.Visual.MenuKey then
        ToggleMenu()
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Config.Aimbot.AimKey then
        aimKeyHeld = false
    end
end)

-- Mouse click handler for menu
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not menuOpen then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    
    local pos = input.Position
    for _, area in pairs(menuClickAreas) do
        if pos.X >= area.x1 and pos.X <= area.x2 and pos.Y >= area.y1 and pos.Y <= area.y2 then
            if area.callback then
                area.callback()
            end
        end
    end
end)

-- ======================================================================
-- ESP
-- ======================================================================

local espDrawings = {}
local espObjects = {}
local drawingAvailable = pcall(function() return Drawing.new("Square") end)

local function CreateESPDrawing(dType, props)
    if not drawingAvailable then return nil end
    local success, d = pcall(function()
        local drawing = Drawing.new(dType)
        for k, v in pairs(props or {}) do drawing[k] = v end
        return drawing
    end)
    if success and d then table.insert(espDrawings, d); return d end
    return nil
end

local function ClearESP()
    for _, d in pairs(espDrawings) do pcall(function() d:Remove() end) end
    espDrawings = {}; espObjects = {}
end

local function DrawESPPlayer(player)
    if not drawingAvailable then return end
    if not player or player == LocalPlayer then return end
    if Config.ESP.TeamCheck and IsTeammate(player) then return end
    
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    local rootPart = GetRootPart(character)
    if not rootPart then return end
    
    local rootPos = rootPart.Position
    local sp, onScreen = Camera:WorldToScreenPoint(rootPos)
    if not onScreen then return end
    local distance = (Camera.CFrame.Position - rootPos).Magnitude
    if distance > Config.ESP.MaxDistance then return end
    
    local playerId = player.UserId
    if not espObjects[playerId] then espObjects[playerId] = {} end
    local esp = espObjects[playerId]
    
    local head = character:FindFirstChild("Head")
    local size = 3
    if head then
        local hp = Camera:WorldToScreenPoint(head.Position)
        size = math.abs(sp.Y - hp.Y) * 2 or 3
    end
    
    if Config.ESP.ShowBoxes then
        if not esp.Box then
            esp.Box = CreateESPDrawing("Square", {Color = Color3.fromRGB(100, 100, 140), Thickness = 2, Filled = false, Transparency = 1})
        end
        if esp.Box then
            esp.Box.Position = Vector2.new(sp.X - size*0.3, sp.Y - size*0.5)
            esp.Box.Size = Vector2.new(size*0.6, size)
            esp.Box.Visible = true
        end
    end
    
    if Config.ESP.ShowNames then
        if not esp.Name then
            esp.Name = CreateESPDrawing("Text", {Color = Color3.new(1,1,1), Size = 14, Center = true, Outline = true, OutlineColor = Color3.new(0,0,0), Font = Drawing.Fonts.UI})
        end
        if esp.Name then
            esp.Name.Text = player.DisplayName or player.Name
            esp.Name.Position = Vector2.new(sp.X, sp.Y - size*0.55 - 20)
            esp.Name.Visible = true
        end
    end
    
    if Config.ESP.ShowHealth then
        if not esp.Health then
            esp.Health = CreateESPDrawing("Square", {Color = Color3.fromRGB(0, 200, 0), Thickness = 2, Filled = true})
        end
        if esp.Health then
            local hp = humanoid.Health / humanoid.MaxHealth
            local bh = size * 0.8
            esp.Health.Position = Vector2.new(sp.X + size*0.35, sp.Y - size*0.5 + (size - bh*hp))
            esp.Health.Size = Vector2.new(4, bh*hp)
            esp.Health.Visible = true
            if hp < 0.3 then esp.Health.Color = Color3.new(1,0,0)
            elseif hp < 0.6 then esp.Health.Color = Color3.new(1,1,0) end
        end
    end
    
    if Config.ESP.ShowDistance then
        if not esp.Dist then
            esp.Dist = CreateESPDrawing("Text", {Color = Color3.fromRGB(100, 100, 140), Size = 12, Center = true, Outline = true, OutlineColor = Color3.new(0,0,0), Font = Drawing.Fonts.UI})
        end
        if esp.Dist then
            esp.Dist.Text = string.format("%.0fm", distance / 3)
            esp.Dist.Position = Vector2.new(sp.X, sp.Y + size*0.55 + 5)
            esp.Dist.Visible = true
        end
    end
    
    if Config.ESP.ShowTracers then
        if not esp.Tracer then
            esp.Tracer = CreateESPDrawing("Line", {Color = Color3.fromRGB(100, 100, 140), Thickness = 1})
        end
        if esp.Tracer then
            local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            esp.Tracer.From = center
            esp.Tracer.To = Vector2.new(sp.X, sp.Y)
            esp.Tracer.Visible = true
        end
    end
end

local function UpdateESP()
    if not espActive or not Config.ESP.Enabled or not drawingAvailable then ClearESP(); return end
    ClearESP()
    espObjects = {}
    for _, player in pairs(Players:GetPlayers()) do DrawESPPlayer(player) end
end

-- ======================================================================
-- PLAYER MODS
-- ======================================================================

UserInputService.JumpRequest:Connect(function()
    if Config.Player.InfiniteJump and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChild("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local flying = false
local flyVelocity, flyGyro

RunService.Heartbeat:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    if Config.Player.Fly then
        local root = GetRootPart(character)
        if root then
            if not flying then
                flying = true
                flyVelocity = Instance.new("BodyVelocity")
                flyVelocity.MaxForce = Vector3.new(1,1,1) * 100000
                flyVelocity.Parent = root
                flyGyro = Instance.new("BodyGyro")
                flyGyro.MaxTorque = Vector3.new(1,1,1) * 100000
                flyGyro.Parent = root
                local h = character:FindFirstChild("Humanoid")
                if h then h.PlatformStand = true end
            end
            if flyVelocity then
                flyVelocity.Velocity = Camera.CFrame.LookVector * Config.Player.FlySpeed
                flyGyro.CFrame = Camera.CFrame
            end
        end
    elseif flying then
        flying = false
        if flyVelocity then flyVelocity:Destroy() end
        if flyGyro then flyGyro:Destroy() end
        local h = character:FindFirstChild("Humanoid")
        if h then h.PlatformStand = false end
    end
end)

RunService.Heartbeat:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    if Config.Player.GodMode then
        local h = character:FindFirstChild("Humanoid")
        if h then h.Health = h.MaxHealth; h.BreakJointsOnDeath = false end
    end
    if Config.Player.NoFallDamage then
        local h = character:FindFirstChild("Humanoid")
        if h then h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end
    end
    if Config.Player.FullBright then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
    end
    local h = character:FindFirstChild("Humanoid")
    if h then
        if Config.Player.WalkSpeed ~= 16 then h.WalkSpeed = Config.Player.WalkSpeed end
        if Config.Player.JumpPower ~= 50 then h.JumpPower = Config.Player.JumpPower end
    end
end)

local function AntiAFK()
    if Config.Player.AntiAFK then
        local vu = VirtualUser
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end
end
RunService.Heartbeat:Connect(AntiAFK)

local function AutoFarm()
    if not Config.Player.AutoFarm then return end
    for _, item in pairs(Workspace:GetDescendants()) do
        if item:IsA("Part") and (item.Name:lower():find("collect") or item.Name:lower():find("coin") or item.Name:lower():find("resource")) then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local distance = (root.Position - item.Position).Magnitude
                if distance < 20 then
                    root.CFrame = CFrame.new(item.Position + Vector3.new(0, 3, 0))
                end
            end
        end
    end
end
RunService.Heartbeat:Connect(AutoFarm)

local function NoClip()
    if Config.Player.NoClip then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end
RunService.Heartbeat:Connect(NoClip)

-- ======================================================================
-- DRAWING MENU (IMGUI STYLE)
-- ======================================================================

local function DrawMenu()
    ClearMenu()
    
    local viewport = Camera.ViewportSize
    local menuWidth = 450
    local menuHeight = 420
    local menuX = (viewport.X - menuWidth) / 2
    local menuY = (viewport.Y - menuHeight) / 2
    
    -- Background
    local bg = CreateRect(Vector2.new(menuX, menuY), Vector2.new(menuWidth, menuHeight), Color3.fromRGB(10, 10, 22), 0, true)
    bg.Transparency = 0.05
    
    -- Border
    local border = CreateRect(Vector2.new(menuX, menuY), Vector2.new(menuWidth, menuHeight), Color3.fromRGB(40, 40, 60), 1, false)
    border.Transparency = 0.3
    
    -- Title Bar
    local titleBg = CreateRect(Vector2.new(menuX + 2, menuY + 2), Vector2.new(menuWidth - 4, 40), Color3.fromRGB(15, 15, 28), 0, true)
    titleBg.Transparency = 0.3
    
    local title = CreateText("💀 SKELLY HUB", Vector2.new(menuX + 20, menuY + 10), Color3.new(1, 1, 1), 20, false)
    local version = CreateText("v5.0", Vector2.new(menuX + menuWidth - 50, menuY + 13), Color3.fromRGB(100, 100, 120), 12, false)
    
    -- Tab Bar
    local tabY = menuY + 42
    local tabWidth = menuWidth / #tabs
    for i, tabName in ipairs(tabs) do
        local tabX = menuX + (i - 1) * tabWidth
        local isSelected = (i == currentTab)
        
        local tabBg = CreateRect(Vector2.new(tabX, tabY), Vector2.new(tabWidth, 30), isSelected and Color3.fromRGB(40, 40, 60) or Color3.fromRGB(20, 20, 35), 0, true)
        tabBg.Transparency = isSelected and 0.3 or 0.6
        
        local tabText = CreateText(tabName, Vector2.new(tabX + tabWidth/2, tabY + 7), isSelected and Color3.new(1, 1, 1) or Color3.fromRGB(150, 150, 170), 12, true)
        
        table.insert(menuClickAreas, {
            x1 = tabX, y1 = tabY,
            x2 = tabX + tabWidth, y2 = tabY + 30,
            callback = function()
                currentTab = i
                DrawMenu()
            end
        })
    end
    
    -- Divider
    local divider = CreateLine(Vector2.new(menuX + 10, tabY + 32), Vector2.new(menuX + menuWidth - 10, tabY + 32), Color3.fromRGB(60, 60, 80), 1)
    divider.Transparency = 0.5
    
    -- Content Area
    local contentX = menuX + 15
    local contentY = tabY + 40
    local contentWidth = menuWidth - 30
    local rowY = contentY
    
    -- ======================================================================
    -- TAB CONTENT
    -- ======================================================================
    
    local function DrawToggle(text, state, callback)
        local toggleX = contentX + 150
        local toggleWidth = 40
        local toggleHeight = 20
        
        local label = CreateText(text, Vector2.new(contentX, rowY), state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 200, 200), 13, false)
        
        local bg = CreateRect(Vector2.new(toggleX, rowY), Vector2.new(toggleWidth, toggleHeight), state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 80), 0, true)
        bg.Transparency = 0.3
        
        local border = CreateRect(Vector2.new(toggleX, rowY), Vector2.new(toggleWidth, toggleHeight), state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 120), 1, false)
        border.Transparency = 0.3
        
        local dotX = state and toggleX + toggleWidth - 18 or toggleX + 2
        local dot = CreateRect(Vector2.new(dotX, rowY + 2), Vector2.new(16, 16), Color3.new(1, 1, 1), 0, true)
        dot.Transparency = 0.2
        
        table.insert(menuClickAreas, {
            x1 = toggleX, y1 = rowY,
            x2 = toggleX + toggleWidth, y2 = rowY + toggleHeight,
            callback = function()
                callback(not state)
                DrawMenu()
            end
        })
        
        rowY = rowY + 28
    end
    
    local function DrawSlider(text, value, min, max, step, callback)
        local sliderWidth = 180
        local sliderX = contentX + 120
        
        local label = CreateText(text .. ": " .. tostring(value), Vector2.new(contentX, rowY), Color3.fromRGB(200, 200, 200), 13, false)
        rowY = rowY + 22
        
        local bg = CreateRect(Vector2.new(sliderX, rowY), Vector2.new(sliderWidth, 4), Color3.fromRGB(60, 60, 80), 0, true)
        bg.Transparency = 0.5
        
        local fillWidth = ((value - min) / (max - min)) * sliderWidth
        local fill = CreateRect(Vector2.new(sliderX, rowY), Vector2.new(fillWidth, 4), Color3.fromRGB(100, 100, 140), 0, true)
        fill.Transparency = 0.3
        
        local handleX = sliderX + fillWidth - 6
        local handle = CreateRect(Vector2.new(handleX, rowY - 4), Vector2.new(12, 12), Color3.fromRGB(100, 100, 140), 1, true)
        handle.Transparency = 0.2
        
        table.insert(menuClickAreas, {
            x1 = sliderX, y1 = rowY - 6,
            x2 = sliderX + sliderWidth, y2 = rowY + 6,
            callback = function()
                -- Simplified: just increase by step
                local newVal = math.min(max, value + step)
                callback(math.floor(newVal / step) * step)
                DrawMenu()
            end
        })
        
        rowY = rowY + 20
    end
    
    local function DrawLabel(text, color)
        local label = CreateText(text, Vector2.new(contentX, rowY), color or Color3.fromRGB(150, 150, 170), 12, false)
        rowY = rowY + 22
    end
    
    -- ======================================================================
    -- TAB: AIMBOT
    -- ======================================================================
    
    if currentTab == 1 then
        -- Head/Body
        local headX = contentX
        local bodyX = contentX + 75
        
        local headBg = CreateRect(Vector2.new(headX, rowY), Vector2.new(65, 22), Config.Aimbot.AimPart == "Head" and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(30, 30, 50), 0, true)
        headBg.Transparency = 0.3
        local headText = CreateText("Head", Vector2.new(headX + 32, rowY + 4), Config.Aimbot.AimPart == "Head" and Color3.new(1, 1, 1) or Color3.fromRGB(150, 150, 170), 12, true)
        
        local bodyBg = CreateRect(Vector2.new(bodyX, rowY), Vector2.new(65, 22), Config.Aimbot.AimPart == "Body" and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(30, 30, 50), 0, true)
        bodyBg.Transparency = 0.3
        local bodyText = CreateText("Body", Vector2.new(bodyX + 32, rowY + 4), Config.Aimbot.AimPart == "Body" and Color3.new(1, 1, 1) or Color3.fromRGB(150, 150, 170), 12, true)
        
        table.insert(menuClickAreas, {
            x1 = headX, y1 = rowY, x2 = headX + 65, y2 = rowY + 22,
            callback = function()
                Config.Aimbot.AimPart = "Head"
                DrawMenu()
            end
        })
        table.insert(menuClickAreas, {
            x1 = bodyX, y1 = rowY, x2 = bodyX + 65, y2 = rowY + 22,
            callback = function()
                Config.Aimbot.AimPart = "Body"
                DrawMenu()
            end
        })
        
        rowY = rowY + 30
        
        -- FOV
        DrawSlider("FOV", Config.Aimbot.FOV, 10, 360, 5, function(val)
            Config.Aimbot.FOV = val
            UpdateFOVCircle()
        end)
        
        -- Smoothness
        DrawSlider("Smoothness", Config.Aimbot.Smoothness, 0, 1, 0.05, function(val)
            Config.Aimbot.Smoothness = val
        end)
        
        -- Max Distance
        DrawSlider("Max Distance", Config.Aimbot.MaxDistance, 100, 1000, 50, function(val)
            Config.Aimbot.MaxDistance = val
        end)
        
        -- Toggles
        DrawToggle("Show FOV Circle", Config.Aimbot.ShowFOVCircle, function(s)
            Config.Aimbot.ShowFOVCircle = s
            UpdateFOVCircle()
        end)
        
        DrawToggle("Aimbot", Config.Aimbot.Enabled, function(s)
            Config.Aimbot.Enabled = s
            aimbotActive = s
            UpdateFOVCircle()
        end)
        
        DrawToggle("Silent Aim", Config.Aimbot.Silent, function(s)
            Config.Aimbot.Silent = s
            silentAimActive = s
        end)
        
        DrawToggle("Team Check", Config.Aimbot.TeamCheck, function(s)
            Config.Aimbot.TeamCheck = s
        end)
        
        DrawToggle("Visible Check", Config.Aimbot.VisibleCheck, function(s)
            Config.Aimbot.VisibleCheck = s
        end)
        
        DrawToggle("Prediction", Config.Aimbot.Prediction, function(s)
            Config.Aimbot.Prediction = s
        end)
        
    -- ======================================================================
    -- TAB: ESP
    -- ======================================================================
    
    elseif currentTab == 2 then
        DrawToggle("ESP Enabled", Config.ESP.Enabled, function(s)
            Config.ESP.Enabled = s
            espActive = s
        end)
        
        DrawToggle("Boxes", Config.ESP.ShowBoxes, function(s)
            Config.ESP.ShowBoxes = s
        end)
        
        DrawToggle("Names", Config.ESP.ShowNames, function(s)
            Config.ESP.ShowNames = s
        end)
        
        DrawToggle("Health Bars", Config.ESP.ShowHealth, function(s)
            Config.ESP.ShowHealth = s
        end)
        
        DrawToggle("Distance", Config.ESP.ShowDistance, function(s)
            Config.ESP.ShowDistance = s
        end)
        
        DrawToggle("Tracers", Config.ESP.ShowTracers, function(s)
            Config.ESP.ShowTracers = s
        end)
        
        DrawToggle("Team Check", Config.ESP.TeamCheck, function(s)
            Config.ESP.TeamCheck = s
        end)
        
        DrawSlider("Max Distance", Config.ESP.MaxDistance, 100, 2000, 50, function(val)
            Config.ESP.MaxDistance = val
        end)
        
    -- ======================================================================
    -- TAB: PLAYER
    -- ======================================================================
    
    elseif currentTab == 3 then
        DrawToggle("Infinite Jump", Config.Player.InfiniteJump, function(s)
            Config.Player.InfiniteJump = s
        end)
        
        DrawToggle("Fly", Config.Player.Fly, function(s)
            Config.Player.Fly = s
        end)
        
        DrawSlider("Fly Speed", Config.Player.FlySpeed, 10, 200, 5, function(val)
            Config.Player.FlySpeed = val
        end)
        
        DrawToggle("God Mode", Config.Player.GodMode, function(s)
            Config.Player.GodMode = s
        end)
        
        DrawToggle("No Fall Damage", Config.Player.NoFallDamage, function(s)
            Config.Player.NoFallDamage = s
        end)
        
        DrawToggle("Full Bright", Config.Player.FullBright, function(s)
            Config.Player.FullBright = s
        end)
        
        DrawToggle("No Clip", Config.Player.NoClip, function(s)
            Config.Player.NoClip = s
        end)
        
        DrawSlider("Walk Speed", Config.Player.WalkSpeed, 10, 100, 1, function(val)
            Config.Player.WalkSpeed = val
        end)
        
        DrawSlider("Jump Power", Config.Player.JumpPower, 10, 200, 5, function(val)
            Config.Player.JumpPower = val
        end)
        
    -- ======================================================================
    -- TAB: MISC
    -- ======================================================================
    
    elseif currentTab == 4 then
        DrawToggle("Anti AFK", Config.Player.AntiAFK, function(s)
            Config.Player.AntiAFK = s
        end)
        
        DrawToggle("Auto Farm", Config.Player.AutoFarm, function(s)
            Config.Player.AutoFarm = s
        end)
        
        rowY = rowY + 10
        DrawLabel("💀 Skelly Hub v5.0", Color3.fromRGB(150, 150, 170))
        DrawLabel("skelly-hub.lol", Color3.fromRGB(80, 80, 100))
    end
    
    -- Watermark at bottom
    local watermark = CreateText("💀 skelly-hub.lol", Vector2.new(menuX + menuWidth - 80, menuY + menuHeight - 18), Color3.fromRGB(40, 40, 60), 10, false)
end

-- ======================================================================
-- MENU TOGGLE
-- ======================================================================

local function ToggleMenu()
    menuOpen = not menuOpen
    print("[SkellyHub] Menu: " .. tostring(menuOpen))
    
    if menuOpen then
        DrawMenu()
    else
        ClearMenu()
    end
end

-- ======================================================================
-- START
-- ======================================================================

print("[SkellyHub] Rivals Script v5.0 Loading...")
print("[SkellyHub] Press Right Shift to open menu.")
print("[SkellyHub] Menu is Drawing-based (ImGui style)")

RunService.RenderStepped:Connect(UpdateFOVCircle)
RunService.RenderStepped:Connect(DoAimbot)
RunService.RenderStepped:Connect(DoSilentAim)
RunService.RenderStepped:Connect(UpdateESP)

print("[SkellyHub] Loaded!")
