--[[
    Skelly Hub Rivals Script v8.0
    COMPLETE WORKING MENU
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
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

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
local menuGui = nil
local espActive = false
local aimbotActive = false
local silentAimActive = false
local currentTab = 1
local tabs = {"Aimbot", "ESP", "Player", "Misc"}
local menuLoaded = false

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
    return false
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

-- ======================================================================
-- ESP (Drawing Library)
-- ======================================================================

local espDrawings = {}
local espObjects = {}
local drawingAvailable = pcall(function() return Drawing.new("Square") end)

if not drawingAvailable then
    print("[SkellyHub] Drawing library not available. ESP disabled.")
end

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
-- COMPLETE WORKING MENU
-- ======================================================================

local function CreateMenu()
    if menuGui then
        pcall(function() menuGui:Destroy() end)
        menuGui = nil
    end
    
    print("[SkellyHub] Creating menu...")
    
    menuGui = Instance.new("ScreenGui")
    menuGui.Name = "SkellyHubMenu"
    menuGui.Parent = CoreGui
    menuGui.ResetOnSpawn = false
    menuGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    menuGui.DisplayOrder = 999
    
    -- Main Frame
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 450, 0, 480)
    main.Position = UDim2.new(0.5, -225, 0.5, -240)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel = 1
    main.BorderColor3 = Color3.fromRGB(40, 40, 60)
    main.Parent = menuGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = main
    
    -- Title
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
    titleBar.BackgroundTransparency = 0.3
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "💀 SKELLY HUB"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.Parent = titleBar
    
    -- Tabs
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 30)
    tabBar.Position = UDim2.new(0, 0, 0, 45)
    tabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
    tabBar.BackgroundTransparency = 0.3
    tabBar.BorderSizePixel = 0
    tabBar.Parent = main
    
    local tabButtons = {}
    
    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.25, 0, 1, 0)
        btn.Position = UDim2.new((i - 1) * 0.25, 0, 0, 0)
        btn.BackgroundColor3 = (currentTab == i) and Color3.fromRGB(40, 40, 60) or Color3.fromRGB(20, 20, 35)
        btn.BackgroundTransparency = (currentTab == i) and 0.3 or 0.6
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold
        btn.Text = tabName
        btn.Parent = tabBar
        
        tabButtons[i] = btn
        
        btn.MouseButton1Click:Connect(function()
            currentTab = i
            for j, button in pairs(tabButtons) do
                if j == i then
                    button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                    button.BackgroundTransparency = 0.3
                else
                    button.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
                    button.BackgroundTransparency = 0.6
                end
            end
            RefreshContent()
        end)
    end
    
    -- Content Container
    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.Size = UDim2.new(1, -20, 1, -105)
    contentContainer.Position = UDim2.new(0, 10, 0, 80)
    contentContainer.BackgroundTransparency = 1
    contentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentContainer.ScrollBarThickness = 6
    contentContainer.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)
    contentContainer.Parent = main
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = contentContainer
    layout.Spacing = 6
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0.2, 0, 0, 32)
    closeBtn.Position = UDim2.new(0.4, 0, 1, -38)
    closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 13
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "CLOSE"
    closeBtn.Parent = main
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        menuOpen = false
        if menuGui then menuGui.Enabled = false end
    end)
    
    -- ======================================================================
    -- CONTENT HELPERS
    -- ======================================================================
    
    local function AddToggle(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 32)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 13
        btn.Font = Enum.Font.Gotham
        btn.Text = text .. " [OFF]"
        btn.Parent = contentContainer
        
        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text .. (state and " [ON]" or " [OFF]")
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(30, 30, 50)
            if callback then callback(state) end
        end)
        return btn
    end
    
    local function AddLabel(text, color)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 22)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = color or Color3.fromRGB(180, 180, 200)
        label.TextSize = 12
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = contentContainer
        return label
    end
    
    local function AddSlider(labelText, value, min, max, step, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -10, 0, 55)
        container.BackgroundTransparency = 1
        container.Parent = contentContainer
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 22)
        label.BackgroundTransparency = 1
        label.Text = labelText .. ": " .. tostring(value)
        label.TextColor3 = Color3.fromRGB(180, 180, 200)
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local btnContainer = Instance.new("Frame")
        btnContainer.Size = UDim2.new(1, 0, 0, 28)
        btnContainer.Position = UDim2.new(0, 0, 0, 24)
        btnContainer.BackgroundTransparency = 1
        btnContainer.Parent = container
        
        local downBtn = Instance.new("TextButton")
        downBtn.Size = UDim2.new(0.08, 0, 1, 0)
        downBtn.Position = UDim2.new(0, 0, 0, 0)
        downBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        downBtn.TextColor3 = Color3.new(1, 1, 1)
        downBtn.TextSize = 16
        downBtn.Font = Enum.Font.GothamBold
        downBtn.Text = "-"
        downBtn.Parent = btnContainer
        
        downBtn.MouseButton1Click:Connect(function()
            local newVal = math.max(min, value - step)
            value = math.floor(newVal / step) * step
            label.Text = labelText .. ": " .. tostring(value)
            if callback then callback(value) end
        end)
        
        local upBtn = Instance.new("TextButton")
        upBtn.Size = UDim2.new(0.08, 0, 1, 0)
        upBtn.Position = UDim2.new(0.12, 0, 0, 0)
        upBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        upBtn.TextColor3 = Color3.new(1, 1, 1)
        upBtn.TextSize = 16
        upBtn.Font = Enum.Font.GothamBold
        upBtn.Text = "+"
        upBtn.Parent = btnContainer
        
        upBtn.MouseButton1Click:Connect(function()
            local newVal = math.min(max, value + step)
            value = math.floor(newVal / step) * step
            label.Text = labelText .. ": " .. tostring(value)
            if callback then callback(value) end
        end)
    end
    
    -- ======================================================================
    -- REFRESH CONTENT
    -- ======================================================================
    
    function RefreshContent()
        print("[SkellyHub] Refreshing content for tab: " .. tabs[currentTab])
        
        -- Clear existing content
        for _, child in pairs(contentContainer:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") or child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        if currentTab == 1 then -- Aimbot
            AddLabel("💀 AIMBOT SETTINGS")
            
            -- Head/Body
            local selectorLabel = AddLabel("Aim Part: " .. Config.Aimbot.AimPart)
            
            local btnContainer = Instance.new("Frame")
            btnContainer.Size = UDim2.new(1, -10, 0, 30)
            btnContainer.BackgroundTransparency = 1
            btnContainer.Parent = contentContainer
            
            local headBtn = Instance.new("TextButton")
            headBtn.Size = UDim2.new(0.45, 0, 1, 0)
            headBtn.Position = UDim2.new(0.02, 0, 0, 0)
            headBtn.BackgroundColor3 = Config.Aimbot.AimPart == "Head" and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(30, 30, 50)
            headBtn.TextColor3 = Color3.new(1, 1, 1)
            headBtn.TextSize = 13
            headBtn.Font = Enum.Font.Gotham
            headBtn.Text = "Head"
            headBtn.Parent = btnContainer
            
            headBtn.MouseButton1Click:Connect(function()
                Config.Aimbot.AimPart = "Head"
                selectorLabel.Text = "Aim Part: Head"
                headBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                bodyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
                UpdateFOVCircle()
                RefreshContent()
            end)
            
            local bodyBtn = Instance.new("TextButton")
            bodyBtn.Size = UDim2.new(0.45, 0, 1, 0)
            bodyBtn.Position = UDim2.new(0.53, 0, 0, 0)
            bodyBtn.BackgroundColor3 = Config.Aimbot.AimPart == "Body" and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(30, 30, 50)
            bodyBtn.TextColor3 = Color3.new(1, 1, 1)
            bodyBtn.TextSize = 13
            bodyBtn.Font = Enum.Font.Gotham
            bodyBtn.Text = "Body"
            bodyBtn.Parent = btnContainer
            
            bodyBtn.MouseButton1Click:Connect(function()
                Config.Aimbot.AimPart = "Body"
                selectorLabel.Text = "Aim Part: Body"
                bodyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                headBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
                UpdateFOVCircle()
                RefreshContent()
            end)
            
            -- FOV Slider
            AddSlider("FOV", Config.Aimbot.FOV, 10, 360, 5, function(val)
                Config.Aimbot.FOV = val
                UpdateFOVCircle()
            end)
            
            -- Smoothness Slider
            AddSlider("Smoothness", Config.Aimbot.Smoothness, 0, 1, 0.05, function(val)
                Config.Aimbot.Smoothness = val
            end)
            
            -- Max Distance Slider
            AddSlider("Max Distance", Config.Aimbot.MaxDistance, 100, 1000, 50, function(val)
                Config.Aimbot.MaxDistance = val
            end)
            
            -- Toggles
            AddToggle("Show FOV Circle", function(s)
                Config.Aimbot.ShowFOVCircle = s
                UpdateFOVCircle()
            end)
            
            AddToggle("Aimbot", function(s)
                Config.Aimbot.Enabled = s
                aimbotActive = s
                UpdateFOVCircle()
            end)
            
            AddToggle("Silent Aim", function(s)
                Config.Aimbot.Silent = s
                silentAimActive = s
            end)
            
            AddToggle("Team Check", function(s)
                Config.Aimbot.TeamCheck = s
            end)
            
            AddToggle("Visible Check", function(s)
                Config.Aimbot.VisibleCheck = s
            end)
            
        elseif currentTab == 2 then -- ESP
            AddLabel("💀 ESP SETTINGS")
            
            AddToggle("ESP Enabled", function(s)
                Config.ESP.Enabled = s
                espActive = s
            end)
            
            AddToggle("Boxes", function(s)
                Config.ESP.ShowBoxes = s
            end)
            
            AddToggle("Names", function(s)
                Config.ESP.ShowNames = s
            end)
            
            AddToggle("Health Bars", function(s)
                Config.ESP.ShowHealth = s
            end)
            
            AddToggle("Distance", function(s)
                Config.ESP.ShowDistance = s
            end)
            
            AddToggle("Tracers", function(s)
                Config.ESP.ShowTracers = s
            end)
            
            AddToggle("Team Check", function(s)
                Config.ESP.TeamCheck = s
            end)
            
            AddSlider("Max Distance", Config.ESP.MaxDistance, 100, 2000, 50, function(val)
                Config.ESP.MaxDistance = val
            end)
            
        elseif currentTab == 3 then -- Player
            AddLabel("💀 PLAYER MODS")
            
            AddToggle("Infinite Jump", function(s)
                Config.Player.InfiniteJump = s
            end)
            
            AddToggle("Fly", function(s)
                Config.Player.Fly = s
            end)
            
            AddSlider("Fly Speed", Config.Player.FlySpeed, 10, 200, 5, function(val)
                Config.Player.FlySpeed = val
            end)
            
            AddToggle("God Mode", function(s)
                Config.Player.GodMode = s
            end)
            
            AddToggle("No Fall Damage", function(s)
                Config.Player.NoFallDamage = s
            end)
            
            AddToggle("Full Bright", function(s)
                Config.Player.FullBright = s
            end)
            
            AddToggle("No Clip", function(s)
                Config.Player.NoClip = s
            end)
            
            AddSlider("Walk Speed", Config.Player.WalkSpeed, 10, 100, 1, function(val)
                Config.Player.WalkSpeed = val
            end)
            
            AddSlider("Jump Power", Config.Player.JumpPower, 10, 200, 5, function(val)
                Config.Player.JumpPower = val
            end)
            
            AddToggle("Anti AFK", function(s)
                Config.Player.AntiAFK = s
            end)
            
            AddToggle("Auto Farm", function(s)
                Config.Player.AutoFarm = s
            end)
            
        elseif currentTab == 4 then -- Misc
            AddLabel("💀 MISC SETTINGS")
            
            -- Credits
            AddLabel("", Color3.fromRGB(80, 80, 100))
            AddLabel("💀 Skelly Hub v8.0", Color3.fromRGB(150, 150, 170))
            AddLabel("Developed by Skelly Hub Team", Color3.fromRGB(120, 120, 140))
            AddLabel("", Color3.fromRGB(80, 80, 100))
            AddLabel("⚙️ Features:", Color3.fromRGB(180, 180, 200))
            AddLabel("  • Aimbot with FOV & Smoothness", Color3.fromRGB(150, 150, 170))
            AddLabel("  • ESP (Boxes, Names, Health, Distance)", Color3.fromRGB(150, 150, 170))
            AddLabel("  • Player Mods (Fly, God Mode, etc.)", Color3.fromRGB(150, 150, 170))
            AddLabel("  • Auto Farm & Anti AFK", Color3.fromRGB(150, 150, 170))
            AddLabel("", Color3.fromRGB(80, 80, 100))
            AddLabel("📱 Support:", Color3.fromRGB(180, 180, 200))
            AddLabel("  • Discord: https://discord.gg/XJtYWy9jgU", Color3.fromRGB(150, 150, 170))
            AddLabel("  • Website: skelly-hub.lol", Color3.fromRGB(150, 150, 170))
            AddLabel("", Color3.fromRGB(80, 80, 100))
            AddLabel("💀 SKELLY HUB v8.0", Color3.fromRGB(200, 100, 100))
        end
        
        -- Update canvas
        task.wait(0.05)
        local totalH = 0
        for _, child in pairs(contentContainer:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") or child:IsA("Frame") then
                totalH = totalH + child.Size.Y.Offset + 6
            end
        end
        contentContainer.CanvasSize = UDim2.new(0, 0, 0, totalH + 20)
        print("[SkellyHub] Canvas height: " .. totalH)
    end
    
    -- Load initial content
    RefreshContent()
    
    print("[SkellyHub] Menu created successfully!")
end

-- ======================================================================
-- MENU TOGGLE
-- ======================================================================

local function ToggleMenu()
    menuOpen = not menuOpen
    print("[SkellyHub] Menu: " .. tostring(menuOpen))
    
    if menuOpen then
        CreateMenu()
        if menuGui then
            menuGui.Enabled = true
        end
    else
        if menuGui then
            menuGui.Enabled = false
        end
    end
end

-- ======================================================================
-- AUTO-OPEN MENU
-- ======================================================================

local function AutoOpenMenu()
    print("[SkellyHub] Auto-opening menu in 1.5 seconds...")
    task.wait(1.5)
    if not menuOpen then
        ToggleMenu()
        print("[SkellyHub] Menu auto-opened!")
    end
end

-- ======================================================================
-- START
-- ======================================================================

print("[SkellyHub] Rivals Script v8.0 Loading...")
print("[SkellyHub] Press Right Shift to toggle menu.")
print("[SkellyHub] Menu will auto-open shortly...")

-- Start core loops
RunService.RenderStepped:Connect(UpdateFOVCircle)
RunService.RenderStepped:Connect(DoAimbot)
RunService.RenderStepped:Connect(DoSilentAim)
RunService.RenderStepped:Connect(UpdateESP)

-- Auto-open menu
AutoOpenMenu()

print("[SkellyHub] Loaded successfully!")
