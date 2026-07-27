--[[
    DarkSide Rivals Script v10.0
    Drawing-Based Menu (ImGui Style)
    Press Right Shift to toggle
]]

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

-- ==================== CONFIG ====================
local Config = {
    Aimbot = {Enabled = false, FOV = 120, Smoothness = 0.3, AimPart = "Head", MaxDistance = 500, TeamCheck = true},
    ESP = {Enabled = false, ShowBoxes = true, ShowNames = true, ShowHealth = true, ShowDistance = true, TeamCheck = true, MaxDistance = 1000},
    Player = {InfiniteJump = false, Fly = false, FlySpeed = 50, WalkSpeed = 16, JumpPower = 50, GodMode = false, NoFallDamage = false, FullBright = false, AntiAFK = false},
    Menu = {Key = Enum.KeyCode.RightShift}
}

-- ==================== DRAWING MENU ====================
local menuOpen = false
local menuDrawings = {}
local menuObjects = {}
local selectedTab = 1
local tabs = {"Aimbot", "ESP", "Player", "Misc"}

-- Colors
local colors = {
    bg = Color3.fromRGB(12, 12, 25),
    border = Color3.fromRGB(180, 0, 0),
    accent = Color3.fromRGB(200, 0, 0),
    text = Color3.fromRGB(220, 220, 220),
    textDim = Color3.fromRGB(150, 150, 150),
    green = Color3.fromRGB(0, 200, 0),
    red = Color3.fromRGB(200, 0, 0),
    gold = Color3.fromRGB(255, 215, 0),
}

-- ==================== DRAWING HELPERS ====================
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
    menuObjects = {}
end

local function CreateText(text, position, color, size, center)
    return CreateDrawing("Text", {
        Text = text,
        Position = position,
        Color = color or colors.text,
        Size = size or 16,
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
        Color = color or colors.border,
        Thickness = thickness or 2,
        Filled = filled or false,
        Transparency = 0.8,
    })
end

local function CreateLine(from, to, color, thickness)
    return CreateDrawing("Line", {
        From = from,
        To = to,
        Color = color or colors.border,
        Thickness = thickness or 2,
    })
end

-- ==================== MENU DRAWING ====================
local function DrawMenu()
    ClearMenu()
    
    local viewport = Camera.ViewportSize
    local menuWidth = 400
    local menuHeight = 420
    local menuX = (viewport.X - menuWidth) / 2
    local menuY = (viewport.Y - menuHeight) / 2
    
    -- Background
    local bg = CreateRect(Vector2.new(menuX, menuY), Vector2.new(menuWidth, menuHeight), colors.bg, 0, true)
    bg.Transparency = 0.05
    
    -- Border
    local border = CreateRect(Vector2.new(menuX, menuY), Vector2.new(menuWidth, menuHeight), colors.border, 2, false)
    border.Transparency = 0.3
    
    -- Title Bar
    local titleBg = CreateRect(Vector2.new(menuX + 2, menuY + 2), Vector2.new(menuWidth - 4, 40), colors.accent, 0, true)
    titleBg.Transparency = 0.2
    
    local title = CreateText("DARK SIDE", Vector2.new(menuX + 20, menuY + 8), Color3.new(1,1,1), 24, false)
    local subTitle = CreateText("RIVALS SCRIPT v10.0", Vector2.new(menuX + menuWidth - 150, menuY + 14), colors.textDim, 12, false)
    
    -- Tab Bar
    local tabY = menuY + 42
    local tabWidth = menuWidth / #tabs
    for i, tabName in ipairs(tabs) do
        local tabX = menuX + (i - 1) * tabWidth
        local isSelected = (i == selectedTab)
        
        local tabBg = CreateRect(Vector2.new(tabX, tabY), Vector2.new(tabWidth, 35), isSelected and colors.accent or colors.bg, 0, true)
        tabBg.Transparency = isSelected and 0.3 or 0.6
        
        local tabText = CreateText(tabName, Vector2.new(tabX + tabWidth/2, tabY + 8), isSelected and Color3.new(1,1,1) or colors.textDim, 14, true)
        
        -- Store click area
        table.insert(menuObjects, {
            type = "tab",
            index = i,
            x1 = tabX,
            y1 = tabY,
            x2 = tabX + tabWidth,
            y2 = tabY + 35,
        })
    end
    
    -- Divider
    local divider = CreateLine(Vector2.new(menuX + 10, tabY + 37), Vector2.new(menuX + menuWidth - 10, tabY + 37), colors.border, 1)
    divider.Transparency = 0.5
    
    -- Content Area
    local contentX = menuX + 15
    local contentY = tabY + 45
    local contentWidth = menuWidth - 30
    
    -- Draw content based on selected tab
    if selectedTab == 1 then -- Aimbot
        DrawAimbotContent(contentX, contentY, contentWidth)
    elseif selectedTab == 2 then -- ESP
        DrawESPContent(contentX, contentY, contentWidth)
    elseif selectedTab == 3 then -- Player
        DrawPlayerContent(contentX, contentY, contentWidth)
    elseif selectedTab == 4 then -- Misc
        DrawMiscContent(contentX, contentY, contentWidth)
    end
    
    -- Footer - Watermark
    local footer = CreateText("dark-side.lol", Vector2.new(menuX + menuWidth - 80, menuY + menuHeight - 22), Color3.fromRGB(60,0,0), 11, false)
end

-- ==================== TAB CONTENT ====================
local function DrawToggle(x, y, label, state, callback)
    local toggleX = x + 150
    local toggleWidth = 40
    local toggleHeight = 20
    
    -- Label
    local labelText = CreateText(label, Vector2.new(x, y), state and colors.green or colors.text, 14, false)
    
    -- Toggle background
    local toggleBg = CreateRect(Vector2.new(toggleX, y), Vector2.new(toggleWidth, toggleHeight), state and colors.green or colors.red, 0, true)
    toggleBg.Transparency = 0.3
    
    -- Toggle border
    local toggleBorder = CreateRect(Vector2.new(toggleX, y), Vector2.new(toggleWidth, toggleHeight), state and colors.green or colors.red, 1, false)
    toggleBorder.Transparency = 0.3
    
    -- Toggle indicator
    local dotX = state and toggleX + toggleWidth - 18 or toggleX + 2
    local dot = CreateRect(Vector2.new(dotX, y + 2), Vector2.new(16, 16), Color3.new(1,1,1), 0, true)
    dot.Transparency = 0.1
    
    -- Store click area
    table.insert(menuObjects, {
        type = "toggle",
        label = label,
        state = state,
        callback = callback,
        x1 = toggleX,
        y1 = y,
        x2 = toggleX + toggleWidth,
        y2 = y + toggleHeight,
    })
    
    return toggleBg
end

local function DrawSlider(x, y, label, value, min, max, step, callback)
    local sliderWidth = 150
    local sliderX = x + 120
    
    -- Label
    local labelText = CreateText(label .. ": " .. tostring(value), Vector2.new(x, y), colors.text, 14, false)
    
    -- Slider background
    local sliderBg = CreateRect(Vector2.new(sliderX, y + 8), Vector2.new(sliderWidth, 4), colors.textDim, 0, true)
    sliderBg.Transparency = 0.5
    
    -- Slider fill
    local fillWidth = ((value - min) / (max - min)) * sliderWidth
    local sliderFill = CreateRect(Vector2.new(sliderX, y + 8), Vector2.new(fillWidth, 4), colors.accent, 0, true)
    sliderFill.Transparency = 0.3
    
    -- Slider handle
    local handleX = sliderX + fillWidth - 6
    local handle = CreateRect(Vector2.new(handleX, y + 4), Vector2.new(12, 12), colors.accent, 1, true)
    handle.Transparency = 0.2
    
    -- Store click area
    table.insert(menuObjects, {
        type = "slider",
        label = label,
        value = value,
        min = min,
        max = max,
        step = step,
        callback = callback,
        x1 = sliderX,
        y1 = y + 4,
        x2 = sliderX + sliderWidth,
        y2 = y + 16,
    })
end

local function DrawAimbotContent(x, y, width)
    local yPos = y
    
    -- Head/Body selector
    local headBtnX = x
    local bodyBtnX = x + 80
    
    local headBg = CreateRect(Vector2.new(headBtnX, yPos), Vector2.new(70, 25), Config.Aimbot.AimPart == "Head" and colors.green or colors.bg, 1, true)
    headBg.Transparency = 0.2
    local headText = CreateText("Head", Vector2.new(headBtnX + 35, yPos + 5), Config.Aimbot.AimPart == "Head" and Color3.new(1,1,1) or colors.textDim, 13, true)
    
    local bodyBg = CreateRect(Vector2.new(bodyBtnX, yPos), Vector2.new(70, 25), Config.Aimbot.AimPart == "Body" and colors.green or colors.bg, 1, true)
    bodyBg.Transparency = 0.2
    local bodyText = CreateText("Body", Vector2.new(bodyBtnX + 35, yPos + 5), Config.Aimbot.AimPart == "Body" and Color3.new(1,1,1) or colors.textDim, 13, true)
    
    table.insert(menuObjects, {type = "headbody", x1 = headBtnX, y1 = yPos, x2 = headBtnX + 70, y2 = yPos + 25})
    table.insert(menuObjects, {type = "headbody", x1 = bodyBtnX, y1 = yPos, x2 = bodyBtnX + 70, y2 = yPos + 25})
    
    yPos = yPos + 35
    
    -- FOV Slider
    DrawSlider(x, yPos, "Aim FOV", Config.Aimbot.FOV, 10, 360, 5, function(val)
        Config.Aimbot.FOV = val
    end)
    yPos = yPos + 30
    
    -- Toggles
    DrawToggle(x, yPos, "Aimbot", Config.Aimbot.Enabled, function(s)
        Config.Aimbot.Enabled = s
        aimbotActive = s
    end)
    yPos = yPos + 30
    
    DrawToggle(x, yPos, "Silent Aim", Config.Aimbot.Silent, function(s)
        Config.Aimbot.Silent = s
        silentAimActive = s
    end)
    yPos = yPos + 30
    
    DrawToggle(x, yPos, "Team Check", Config.Aimbot.TeamCheck, function(s)
        Config.Aimbot.TeamCheck = s
    end)
end

local function DrawESPContent(x, y, width)
    local yPos = y
    
    DrawToggle(x, yPos, "ESP Enabled", Config.ESP.Enabled, function(s)
        Config.ESP.Enabled = s
        espActive = s
    end)
    yPos = yPos + 30
    
    DrawToggle(x, yPos, "Boxes", Config.ESP.ShowBoxes, function(s)
        Config.ESP.ShowBoxes = s
    end)
    yPos = yPos + 30
    
    DrawToggle(x, yPos, "Names", Config.ESP.ShowNames, function(s)
        Config.ESP.ShowNames = s
    end)
    yPos = yPos + 30
    
    DrawToggle(x, yPos, "Health Bars", Config.ESP.ShowHealth, function(s)
        Config.ESP.ShowHealth = s
    end)
    yPos = yPos + 30
    
    DrawToggle(x, yPos, "Distance", Config.ESP.ShowDistance, function(s)
        Config.ESP.ShowDistance = s
    end)
    yPos = yPos + 30
    
    DrawToggle(x, yPos, "Team Check", Config.ESP.TeamCheck, function(s)
        Config.ESP.TeamCheck = s
    end)
end

local function DrawPlayerContent(x, y, width)
    local yPos = y
    
    DrawToggle(x, yPos, "Infinite Jump", Config.Player.InfiniteJump, function(s)
        Config.Player.InfiniteJump = s
    end)
    yPos = yPos + 30
    
    DrawToggle(x, yPos, "Fly", Config.Player.Fly, function(s)
        Config.Player.Fly = s
    end)
    yPos = yPos + 30
    
    DrawToggle(x, yPos, "God Mode", Config.Player.GodMode, function(s)
        Config.Player.GodMode = s
    end)
    yPos = yPos + 30
    
    DrawToggle(x, yPos, "No Fall Damage", Config.Player.NoFallDamage, function(s)
        Config.Player.NoFallDamage = s
    end)
    yPos = yPos + 30
    
    DrawToggle(x, yPos, "Full Bright", Config.Player.FullBright, function(s)
        Config.Player.FullBright = s
    end)
end

local function DrawMiscContent(x, y, width)
    local yPos = y
    
    DrawToggle(x, yPos, "Anti AFK", Config.Player.AntiAFK, function(s)
        Config.Player.AntiAFK = s
    end)
    yPos = yPos + 30
    
    -- Credits
    yPos = yPos + 20
    local credit1 = CreateText("DarkSide Script v10.0", Vector2.new(x, yPos), colors.textDim, 14, false)
    yPos = yPos + 22
    local credit2 = CreateText("Developed by DarkSide Team", Vector2.new(x, yPos), colors.textDim, 12, false)
    yPos = yPos + 22
    local credit3 = CreateText("dark-side.lol", Vector2.new(x, yPos), Color3.fromRGB(60,0,0), 12, false)
end

-- ==================== CLICK HANDLING ====================
local function HandleClick(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    
    local pos = input.Position
    local handled = false
    
    for _, obj in pairs(menuObjects) do
        if pos.X >= obj.x1 and pos.X <= obj.x2 and pos.Y >= obj.y1 and pos.Y <= obj.y2 then
            if obj.type == "tab" then
                selectedTab = obj.index
                handled = true
            elseif obj.type == "toggle" and obj.callback then
                obj.callback(not obj.state)
                handled = true
            elseif obj.type == "headbody" then
                -- Check which button was clicked
                if obj.x1 < pos.X and obj.x1 + 35 > pos.X then
                    Config.Aimbot.AimPart = "Head"
                else
                    Config.Aimbot.AimPart = "Body"
                end
                handled = true
            elseif obj.type == "slider" and obj.callback then
                local percent = (pos.X - obj.x1) / (obj.x2 - obj.x1)
                local val = math.floor((percent * (obj.max - obj.min) + obj.min) / obj.step) * obj.step
                val = math.clamp(val, obj.min, obj.max)
                obj.callback(val)
                handled = true
            end
        end
    end
    
    if handled then
        DrawMenu()
    end
end

-- ==================== UTILITY ====================
local function IsAlive(player)
    if not player or not player.Character then return false end
    local h = player.Character:FindFirstChild("Humanoid")
    return h and h.Health > 0
end

local function GetRootPart(character)
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
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
    return false
end

-- ==================== AIMBOT ====================
local aimbotActive = false
local silentAimActive = false

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
            
            local sp, onScreen = Camera:WorldToScreenPoint(aimPart.Position)
            if not onScreen then continue end
            
            local d = math.sqrt((sp.X - cx)^2 + (sp.Y - cy)^2)
            if d > fov then continue end
            
            local wd = (camPos - aimPart.Position).Magnitude
            if wd > maxDist then continue end
            
            if d < bestScore then
                bestScore = d
                best = {Player = player, AimPart = aimPart}
            end
        end
    end
    return best
end

local function DoAimbot()
    if not aimbotActive or not Config.Aimbot.Enabled then return end
    local target = GetBestTarget()
    if not target then return end
    
    local targetPos = target.AimPart.Position
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
    if not silentAimActive or not Config.Aimbot.Silent then return end
    local target = GetBestTarget()
    if not target then return end
    local mouse = LocalPlayer:GetMouse()
    if mouse then mouse.Hit = CFrame.new(target.AimPart.Position) end
end

-- ==================== ESP ====================
local espActive = false
local espDrawings = {}
local espObjects = {}
local drawingAvailable = pcall(function() return Drawing.new("Square") end)

if not drawingAvailable then warn("[DarkSide] Drawing library not available. ESP disabled.") end

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
            esp.Box = CreateESPDrawing("Square", {Color = Color3.new(1,0,0), Thickness = 2, Filled = false, Transparency = 1})
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
            esp.Health = CreateESPDrawing("Square", {Color = Color3.new(0,1,0), Thickness = 2, Filled = true})
        end
        if esp.Health then
            local hp = humanoid.Health / humanoid.MaxHealth
            local bh = size * 0.8
            esp.Health.Position = Vector2.new(sp.X + size*0.35, sp.Y - size*0.5 + (size - bh*hp))
            esp.Health.Size = Vector2.new(4, bh*hp)
            esp.Health.Visible = true
            if hp < 0.3 then esp.Health.Color = Color3.new(1,0,0)
            elseif hp < 0.6 then esp.Health.Color = Color3.new(1,1,0)
            else esp.Health.Color = Color3.new(0,1,0) end
        end
    end
    
    if Config.ESP.ShowDistance then
        if not esp.Dist then
            esp.Dist = CreateESPDrawing("Text", {Color = Color3.new(0.5,0.5,1), Size = 12, Center = true, Outline = true, OutlineColor = Color3.new(0,0,0), Font = Drawing.Fonts.UI})
        end
        if esp.Dist then
            esp.Dist.Text = string.format("%.0fm", distance / 3)
            esp.Dist.Position = Vector2.new(sp.X, sp.Y + size*0.55 + 5)
            esp.Dist.Visible = true
        end
    end
end

local function UpdateESP()
    if not espActive or not Config.ESP.Enabled or not drawingAvailable then ClearESP(); return end
    ClearESP()
    espObjects = {}
    for _, player in pairs(Players:GetPlayers()) do DrawESPPlayer(player) end
end

-- ==================== PLAYER MODS ====================
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

-- ==================== MENU TOGGLE ====================
local function ToggleMenu()
    menuOpen = not menuOpen
    if menuOpen then
        DrawMenu()
    else
        ClearMenu()
    end
end

-- ==================== INPUT HANDLING ====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Config.Menu.Key then
        ToggleMenu()
        return
    end
    
    if menuOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
        HandleClick(input)
    end
end)

-- ==================== START ====================
print("[DarkSide] Rivals Script v10.0 Loading...")
print("[DarkSide] Drawing-based menu enabled.")

RunService.RenderStepped:Connect(DoAimbot)
RunService.RenderStepped:Connect(DoSilentAim)
RunService.RenderStepped:Connect(UpdateESP)

print("[DarkSide] Rivals Script Loaded! Press Right Shift for menu.")
