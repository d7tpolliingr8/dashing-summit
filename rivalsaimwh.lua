--[[
    DarkSide Rivals Script v14.0
    With FOV Circle & Smoothing Slider
    Press Right Shift to toggle menu
]]

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

-- ==================== CONFIG ====================
local Config = {
    Aimbot = {
        Enabled = false,
        AimKey = Enum.UserInputType.MouseButton2,
        FOV = 120,
        Smoothness = 0.3,
        AimPart = "Head",
        MaxDistance = 500,
        TeamCheck = true,
        ShowFOVCircle = true,
    },
    ESP = {Enabled = false, ShowBoxes = true, ShowNames = true, ShowHealth = true, ShowDistance = true, TeamCheck = true, MaxDistance = 1000},
    Player = {InfiniteJump = false, Fly = false, FlySpeed = 50, WalkSpeed = 16, JumpPower = 50, GodMode = false, NoFallDamage = false, FullBright = false, AntiAFK = false},
    Menu = {Key = Enum.KeyCode.RightShift}
}

-- Aim key state
local aimKeyHeld = false

-- FOV Circle Drawing
local fovCircle = nil

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

-- ==================== FOV CIRCLE ====================
local function UpdateFOVCircle()
    if Config.Aimbot.ShowFOVCircle and Config.Aimbot.Enabled then
        if not fovCircle then
            fovCircle = Drawing.new("Circle")
            fovCircle.Thickness = 2
            fovCircle.NumSides = 64
            fovCircle.Color = Color3.fromRGB(200, 0, 0)
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
    -- Only aim if aimbot is enabled AND the aim key is held
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

-- ==================== AIM KEY INPUT HANDLING ====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Config.Aimbot.AimKey then
        aimKeyHeld = true
    end
    
    if input.KeyCode == Config.Menu.Key then
        ToggleMenu()
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Config.Aimbot.AimKey then
        aimKeyHeld = false
    end
end)

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

-- ==================== MENU ====================
local menuOpen = false
local menuGui = nil
local currentTab = "Aimbot"

-- ==================== MENU UI HELPERS ====================
local function CreateToggleButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 15
    btn.Font = Enum.Font.Gotham
    btn.Text = text .. " [OFF]"
    btn.Parent = parent
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 70)
        if callback then callback(state) end
    end)
    return btn
end

local function CreateLabel(parent, text, color, size)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9, 0, 0, 25)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    label.TextSize = size or 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

-- ==================== AIM KEY SELECTOR ====================
local aimKeyOptions = {
    {name = "Left Click (LMB)", value = Enum.UserInputType.MouseButton1},
    {name = "Right Click (RMB)", value = Enum.UserInputType.MouseButton2},
    {name = "Middle Click (MMB)", value = Enum.UserInputType.MouseButton3},
}

local function CreateAimKeySelector(parent)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 25)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "Aim Key: " .. getAimKeyName(Config.Aimbot.AimKey)
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(1, 0, 0, 30)
    btnContainer.Position = UDim2.new(0, 0, 0, 28)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = container
    
    for i, option in ipairs(aimKeyOptions) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.3, 0, 1, 0)
        btn.Position = UDim2.new((i - 1) * 0.33, 0, 0, 0)
        btn.BackgroundColor3 = (Config.Aimbot.AimKey == option.value) and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 70)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 13
        btn.Font = Enum.Font.Gotham
        btn.Text = option.name
        btn.Parent = btnContainer
        
        btn.MouseButton1Click:Connect(function()
            Config.Aimbot.AimKey = option.value
            label.Text = "Aim Key: " .. option.name
            for _, child in pairs(btnContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            print("[DarkSide] Aim key set to: " .. option.name)
        end)
    end
    
    return container
end

local function getAimKeyName(key)
    for _, option in ipairs(aimKeyOptions) do
        if option.value == key then
            return option.name
        end
    end
    return "Right Click (RMB)"
end

-- ==================== CREATE MENU ====================
local function CreateMenu()
    if menuGui then
        pcall(function() menuGui:Destroy() end)
        menuGui = nil
    end
    
    print("[DarkSide] Creating menu...")
    
    menuGui = Instance.new("ScreenGui")
    menuGui.Name = "DarkSideMenu"
    menuGui.Parent = CoreGui
    menuGui.ResetOnSpawn = false
    menuGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    menuGui.DisplayOrder = 999
    
    -- Main Frame
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 480, 0, 520)
    main.Position = UDim2.new(0.5, -240, 0.5, -260)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 22)
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel = 2
    main.BorderColor3 = Color3.fromRGB(200, 0, 0)
    main.Parent = menuGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = main
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    titleBar.BackgroundTransparency = 0.2
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 16)
    titleCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "DARK SIDE"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 28
    title.Font = Enum.Font.GothamBold
    title.Parent = titleBar
    
    -- Tab Bar
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 35)
    tabBar.Position = UDim2.new(0, 0, 0, 45)
    tabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    tabBar.BackgroundTransparency = 0.3
    tabBar.BorderSizePixel = 0
    tabBar.Parent = main
    
    local tabs = {"Aimbot", "ESP", "Player", "Misc"}
    local tabButtons = {}
    
    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.25, 0, 1, 0)
        btn.Position = UDim2.new((i - 1) * 0.25, 0, 0, 0)
        btn.BackgroundColor3 = (currentTab == tabName) and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 50)
        btn.BackgroundTransparency = (currentTab == tabName) and 0.3 or 0.6
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.Text = tabName
        btn.Parent = tabBar
        
        tabButtons[tabName] = btn
        
        btn.MouseButton1Click:Connect(function()
            currentTab = tabName
            for name, button in pairs(tabButtons) do
                if name == tabName then
                    button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
                    button.BackgroundTransparency = 0.3
                else
                    button.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
                    button.BackgroundTransparency = 0.6
                end
            end
            RefreshContent()
        end)
    end
    
    -- Content Container
    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.Size = UDim2.new(1, -20, 1, -115)
    contentContainer.Position = UDim2.new(0, 10, 0, 85)
    contentContainer.BackgroundTransparency = 1
    contentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentContainer.ScrollBarThickness = 6
    contentContainer.ScrollBarImageColor3 = Color3.fromRGB(200, 0, 0)
    contentContainer.Parent = main
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = contentContainer
    layout.Spacing = 6
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0.2, 0, 0, 35)
    closeBtn.Position = UDim2.new(0.4, 0, 1, -42)
    closeBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 14
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
    
    -- ==================== REFRESH CONTENT ====================
    function RefreshContent()
        print("[DarkSide] Refreshing content for tab: " .. currentTab)
        
        for _, child in pairs(contentContainer:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") or child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        if currentTab == "Aimbot" then
            print("[DarkSide] Loading Aimbot content")
            
            -- Aim Key Selector
            CreateAimKeySelector(contentContainer)
            
            -- Head/Body selector
            local selectorLabel = CreateLabel(contentContainer, "Aim Part: " .. Config.Aimbot.AimPart)
            
            local btnContainer = Instance.new("Frame")
            btnContainer.Size = UDim2.new(1, 0, 0, 35)
            btnContainer.BackgroundTransparency = 1
            btnContainer.Parent = contentContainer
            
            local headBtn = Instance.new("TextButton")
            headBtn.Size = UDim2.new(0.45, 0, 1, 0)
            headBtn.Position = UDim2.new(0.02, 0, 0, 0)
            headBtn.BackgroundColor3 = Config.Aimbot.AimPart == "Head" and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 70)
            headBtn.TextColor3 = Color3.new(1, 1, 1)
            headBtn.TextSize = 14
            headBtn.Font = Enum.Font.Gotham
            headBtn.Text = "Head"
            headBtn.Parent = btnContainer
            
            headBtn.MouseButton1Click:Connect(function()
                Config.Aimbot.AimPart = "Head"
                selectorLabel.Text = "Aim Part: Head"
                headBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                bodyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
                UpdateFOVCircle()
            end)
            
            local bodyBtn = Instance.new("TextButton")
            bodyBtn.Size = UDim2.new(0.45, 0, 1, 0)
            bodyBtn.Position = UDim2.new(0.53, 0, 0, 0)
            bodyBtn.BackgroundColor3 = Config.Aimbot.AimPart == "Body" and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 70)
            bodyBtn.TextColor3 = Color3.new(1, 1, 1)
            bodyBtn.TextSize = 14
            bodyBtn.Font = Enum.Font.Gotham
            bodyBtn.Text = "Body"
            bodyBtn.Parent = btnContainer
            
            bodyBtn.MouseButton1Click:Connect(function()
                Config.Aimbot.AimPart = "Body"
                selectorLabel.Text = "Aim Part: Body"
                bodyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                headBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
                UpdateFOVCircle()
            end)
            
            -- FOV Label + Slider
            local fovLabel = CreateLabel(contentContainer, "Aim FOV: " .. Config.Aimbot.FOV)
            
            local fovContainer = Instance.new("Frame")
            fovContainer.Size = UDim2.new(1, 0, 0, 30)
            fovContainer.BackgroundTransparency = 1
            fovContainer.Parent = contentContainer
            
            local fovDown = Instance.new("TextButton")
            fovDown.Size = UDim2.new(0.1, 0, 1, 0)
            fovDown.Position = UDim2.new(0.05, 0, 0, 0)
            fovDown.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
            fovDown.TextColor3 = Color3.new(1, 1, 1)
            fovDown.TextSize = 18
            fovDown.Font = Enum.Font.GothamBold
            fovDown.Text = "-"
            fovDown.Parent = fovContainer
            
            fovDown.MouseButton1Click:Connect(function()
                Config.Aimbot.FOV = math.max(10, Config.Aimbot.FOV - 5)
                fovLabel.Text = "Aim FOV: " .. Config.Aimbot.FOV
                UpdateFOVCircle()
            end)
            
            local fovUp = Instance.new("TextButton")
            fovUp.Size = UDim2.new(0.1, 0, 1, 0)
            fovUp.Position = UDim2.new(0.2, 0, 0, 0)
            fovUp.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
            fovUp.TextColor3 = Color3.new(1, 1, 1)
            fovUp.TextSize = 18
            fovUp.Font = Enum.Font.GothamBold
            fovUp.Text = "+"
            fovUp.Parent = fovContainer
            
            fovUp.MouseButton1Click:Connect(function()
                Config.Aimbot.FOV = math.min(360, Config.Aimbot.FOV + 5)
                fovLabel.Text = "Aim FOV: " .. Config.Aimbot.FOV
                UpdateFOVCircle()
            end)
            
            -- Smoothness Label + Slider
            local smoothLabel = CreateLabel(contentContainer, "Smoothness: " .. string.format("%.1f", Config.Aimbot.Smoothness))
            
            local smoothContainer = Instance.new("Frame")
            smoothContainer.Size = UDim2.new(1, 0, 0, 30)
            smoothContainer.BackgroundTransparency = 1
            smoothContainer.Parent = contentContainer
            
            local smoothDown = Instance.new("TextButton")
            smoothDown.Size = UDim2.new(0.1, 0, 1, 0)
            smoothDown.Position = UDim2.new(0.05, 0, 0, 0)
            smoothDown.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
            smoothDown.TextColor3 = Color3.new(1, 1, 1)
            smoothDown.TextSize = 18
            smoothDown.Font = Enum.Font.GothamBold
            smoothDown.Text = "-"
            smoothDown.Parent = smoothContainer
            
            smoothDown.MouseButton1Click:Connect(function()
                Config.Aimbot.Smoothness = math.max(0, Config.Aimbot.Smoothness - 0.05)
                smoothLabel.Text = "Smoothness: " .. string.format("%.1f", Config.Aimbot.Smoothness)
            end)
            
            local smoothUp = Instance.new("TextButton")
            smoothUp.Size = UDim2.new(0.1, 0, 1, 0)
            smoothUp.Position = UDim2.new(0.2, 0, 0, 0)
            smoothUp.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
            smoothUp.TextColor3 = Color3.new(1, 1, 1)
            smoothUp.TextSize = 18
            smoothUp.Font = Enum.Font.GothamBold
            smoothUp.Text = "+"
            smoothUp.Parent = smoothContainer
            
            smoothUp.MouseButton1Click:Connect(function()
                Config.Aimbot.Smoothness = math.min(1, Config.Aimbot.Smoothness + 0.05)
                smoothLabel.Text = "Smoothness: " .. string.format("%.1f", Config.Aimbot.Smoothness)
            end)
            
            -- Toggles
            CreateToggleButton(contentContainer, "Show FOV Circle", function(s)
                Config.Aimbot.ShowFOVCircle = s
                UpdateFOVCircle()
                print("[DarkSide] FOV Circle: " .. (s and "ON" or "OFF"))
            end)
            
            CreateToggleButton(contentContainer, "Aimbot", function(s)
                Config.Aimbot.Enabled = s
                aimbotActive = s
                UpdateFOVCircle()
                print("[DarkSide] Aimbot: " .. (s and "ON" or "OFF"))
            end)
            
            CreateToggleButton(contentContainer, "Silent Aim", function(s)
                Config.Aimbot.Silent = s
                silentAimActive = s
                print("[DarkSide] Silent Aim: " .. (s and "ON" or "OFF"))
            end)
            
            CreateToggleButton(contentContainer, "Team Check", function(s)
                Config.Aimbot.TeamCheck = s
            end)
            
        elseif currentTab == "ESP" then
            print("[DarkSide] Loading ESP content")
            
            CreateToggleButton(contentContainer, "ESP Enabled", function(s)
                Config.ESP.Enabled = s
                espActive = s
                print("[DarkSide] ESP: " .. (s and "ON" or "OFF"))
            end)
            
            CreateToggleButton(contentContainer, "Boxes", function(s)
                Config.ESP.ShowBoxes = s
            end)
            
            CreateToggleButton(contentContainer, "Names", function(s)
                Config.ESP.ShowNames = s
            end)
            
            CreateToggleButton(contentContainer, "Health Bars", function(s)
                Config.ESP.ShowHealth = s
            end)
            
            CreateToggleButton(contentContainer, "Distance", function(s)
                Config.ESP.ShowDistance = s
            end)
            
            CreateToggleButton(contentContainer, "Team Check", function(s)
                Config.ESP.TeamCheck = s
            end)
            
        elseif currentTab == "Player" then
            print("[DarkSide] Loading Player content")
            
            CreateToggleButton(contentContainer, "Infinite Jump", function(s)
                Config.Player.InfiniteJump = s
                print("[DarkSide] Infinite Jump: " .. (s and "ON" or "OFF"))
            end)
            
            CreateToggleButton(contentContainer, "Fly", function(s)
                Config.Player.Fly = s
                print("[DarkSide] Fly: " .. (s and "ON" or "OFF"))
            end)
            
            CreateToggleButton(contentContainer, "God Mode", function(s)
                Config.Player.GodMode = s
                print("[DarkSide] God Mode: " .. (s and "ON" or "OFF"))
            end)
            
            CreateToggleButton(contentContainer, "No Fall Damage", function(s)
                Config.Player.NoFallDamage = s
            end)
            
            CreateToggleButton(contentContainer, "Full Bright", function(s)
                Config.Player.FullBright = s
            end)
            
        elseif currentTab == "Misc" then
            print("[DarkSide] Loading Misc content")
            
            CreateToggleButton(contentContainer, "Anti AFK", function(s)
                Config.Player.AntiAFK = s
            end)
            
            CreateLabel(contentContainer, "─ Developed by DarkSide Team ─", Color3.fromRGB(150, 150, 150), 14)
            CreateLabel(contentContainer, "dark-side.lol", Color3.fromRGB(100, 100, 100), 12)
        end
        
        task.wait(0.05)
        local totalH = 0
        for _, child in pairs(contentContainer:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") or child:IsA("Frame") then
                totalH = totalH + child.Size.Y.Offset + 6
            end
        end
        contentContainer.CanvasSize = UDim2.new(0, 0, 0, totalH + 20)
        print("[DarkSide] Canvas height: " .. totalH)
    end
    
    RefreshContent()
    print("[DarkSide] Menu created successfully!")
end

local function ToggleMenu()
    menuOpen = not menuOpen
    print("[DarkSide] ToggleMenu called. menuOpen = " .. tostring(menuOpen))
    
    if menuOpen then
        CreateMenu()
        if menuGui then
            menuGui.Enabled = true
            print("[DarkSide] Menu should be visible now.")
        end
    else
        if menuGui then
            menuGui.Enabled = false
            print("[DarkSide] Menu hidden.")
        end
    end
end

-- ==================== START ====================
print("[DarkSide] Rivals Script v14.0 Loading...")
print("[DarkSide] Press Right Shift to open menu.")
print("[DarkSide] Hold Right Mouse Button (RMB) to aim.")

-- Update FOV circle on render
RunService.RenderStepped:Connect(function()
    UpdateFOVCircle()
end)

RunService.RenderStepped:Connect(DoAimbot)
RunService.RenderStepped:Connect(DoSilentAim)
RunService.RenderStepped:Connect(UpdateESP)

print("[DarkSide] Rivals Script Loaded!")
