--[[
    DarkSide Rivals Script v1.2
    Fixed Menu & ESP
    Press INSERT to open menu
]]

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ==================== CONFIG ====================
local Config = {
    Aimbot = {Enabled = false, FOV = 120, Smoothness = 0.3, AimPart = "Head", MaxDistance = 500, TeamCheck = true},
    ESP = {Enabled = false, ShowBoxes = true, ShowNames = true, ShowHealth = true, ShowDistance = true, MaxDistance = 1000, TeamCheck = true},
    Player = {InfiniteJump = false, Fly = false, FlySpeed = 50, WalkSpeed = 16, GodMode = false, FullBright = false},
    Menu = {Key = Enum.KeyCode.Insert}
}

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
    return character:FindFirstChild(partName) or GetRootPart(character)
end

local function IsTeammate(player)
    if not LocalPlayer or not player then return false end
    if LocalPlayer.Team and player.Team then return LocalPlayer.Team == player.Team end
    return false
end

-- ==================== AIMBOT ====================
local aimbotActive = false

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

-- ==================== ESP (Safe Mode - No Drawing Library) ====================
-- ESP uses Drawing library, which may not work on all executors.
-- If Drawing is not available, ESP will be disabled with a warning.

local espActive = false
local espDrawings = {}
local espObjects = {}
local drawingAvailable = pcall(function() return Drawing.new("Square") end)

if not drawingAvailable then
    warn("[DarkSide] Drawing library not available. ESP disabled.")
end

local function CreateDrawing(drawType, props)
    if not drawingAvailable then return nil end
    local success, d = pcall(function()
        local drawing = Drawing.new(drawType)
        for k, v in pairs(props or {}) do drawing[k] = v end
        return drawing
    end)
    if success and d then
        table.insert(espDrawings, d)
        return d
    end
    return nil
end

local function ClearESP()
    for _, d in pairs(espDrawings) do
        pcall(function() d:Remove() end)
    end
    espDrawings = {}
    espObjects = {}
end

local function DrawESP(player)
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
            esp.Box = CreateDrawing("Square", {Color = Color3.new(1,0,0), Thickness = 2, Filled = false, Transparency = 1})
        end
        if esp.Box then
            esp.Box.Position = Vector2.new(sp.X - size*0.3, sp.Y - size*0.5)
            esp.Box.Size = Vector2.new(size*0.6, size)
            esp.Box.Visible = true
        end
    end
    
    if Config.ESP.ShowNames then
        if not esp.Name then
            esp.Name = CreateDrawing("Text", {Color = Color3.new(1,1,1), Size = 14, Center = true, Outline = true, OutlineColor = Color3.new(0,0,0), Font = Drawing.Fonts.UI})
        end
        if esp.Name then
            esp.Name.Text = player.DisplayName or player.Name
            esp.Name.Position = Vector2.new(sp.X, sp.Y - size*0.55 - 20)
            esp.Name.Visible = true
        end
    end
    
    if Config.ESP.ShowHealth then
        if not esp.Health then
            esp.Health = CreateDrawing("Square", {Color = Color3.new(0,1,0), Thickness = 2, Filled = true})
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
            esp.Dist = CreateDrawing("Text", {Color = Color3.new(0.5,0.5,1), Size = 12, Center = true, Outline = true, OutlineColor = Color3.new(0,0,0), Font = Drawing.Fonts.UI})
        end
        if esp.Dist then
            esp.Dist.Text = string.format("%.0fm", distance / 3)
            esp.Dist.Position = Vector2.new(sp.X, sp.Y + size*0.55 + 5)
            esp.Dist.Visible = true
        end
    end
end

local function UpdateESP()
    if not espActive or not Config.ESP.Enabled or not drawingAvailable then 
        ClearESP() 
        return 
    end
    ClearESP()
    espObjects = {}
    for _, player in pairs(Players:GetPlayers()) do DrawESP(player) end
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
    if Config.Player.FullBright then
        game.Lighting.Brightness = 2
        game.Lighting.Ambient = Color3.new(1,1,1)
        game.Lighting.OutdoorAmbient = Color3.new(1,1,1)
    end
    if Config.Player.WalkSpeed ~= 16 then
        local h = character:FindFirstChild("Humanoid")
        if h then h.WalkSpeed = Config.Player.WalkSpeed end
    end
end)

-- ==================== MENU (Simplified & Reliable) ====================
local menuVisible = false
local screenGui = nil
local menuFrame = nil

local function CreateMenu()
    -- Clean up any existing menu
    if screenGui then 
        pcall(function() screenGui:Destroy() end)
        screenGui = nil
    end
    
    -- Create new ScreenGui
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DarkSideMenu"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    
    -- Main Frame
    menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0, 350, 0, 420)
    menuFrame.Position = UDim2.new(0.5, -175, 0.5, -210)
    menuFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    menuFrame.BackgroundTransparency = 0.1
    menuFrame.BorderSizePixel = 2
    menuFrame.BorderColor3 = Color3.fromRGB(200, 0, 0)
    menuFrame.Parent = screenGui
    
    -- Corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = menuFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = menuFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "DARK SIDE"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.Parent = titleBar
    
    -- Scroll Container
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -85)
    scroll.Position = UDim2.new(0, 10, 0, 55)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = Color3.fromRGB(200, 0, 0)
    scroll.Parent = menuFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = scroll
    layout.Spacing = 6
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Button Creation Function
    local function AddToggle(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 38)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
        btn.BackgroundTransparency = 0.3
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 16
        btn.Font = Enum.Font.Gotham
        btn.Text = text .. "  [OFF]"
        btn.Parent = scroll
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text .. (state and "  [ON]" or "  [OFF]")
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(40, 40, 70)
            if callback then callback(state) end
        end)
        return btn
    end
    
    -- Add Buttons
    AddToggle("Aimbot", function(s) 
        Config.Aimbot.Enabled = s
        aimbotActive = s
        print("[DarkSide] Aimbot: " .. (s and "ON" or "OFF"))
    end)
    
    AddToggle("ESP", function(s) 
        Config.ESP.Enabled = s
        espActive = s
        print("[DarkSide] ESP: " .. (s and "ON" or "OFF"))
    end)
    
    AddToggle("Infinite Jump", function(s) 
        Config.Player.InfiniteJump = s
        print("[DarkSide] Infinite Jump: " .. (s and "ON" or "OFF"))
    end)
    
    AddToggle("Fly", function(s) 
        Config.Player.Fly = s
        print("[DarkSide] Fly: " .. (s and "ON" or "OFF"))
    end)
    
    AddToggle("God Mode", function(s) 
        Config.Player.GodMode = s
        print("[DarkSide] God Mode: " .. (s and "ON" or "OFF"))
    end)
    
    AddToggle("Full Bright", function(s) 
        Config.Player.FullBright = s
        print("[DarkSide] Full Bright: " .. (s and "ON" or "OFF"))
    end)
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0.4, 0, 0, 35)
    closeBtn.Position = UDim2.new(0.3, 0, 1, -45)
    closeBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "CLOSE"
    closeBtn.Parent = menuFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        menuVisible = false
        if screenGui then screenGui.Enabled = false end
    end)
    
    -- Update Canvas Size
    task.wait(0.1)
    local totalH = 0
    for _, child in pairs(scroll:GetChildren()) do
        if child:IsA("TextButton") then
            totalH = totalH + 38 + 6
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, totalH + 20)
    
    print("[DarkSide] Menu created successfully!")
end

local function ToggleMenu()
    menuVisible = not menuVisible
    
    if menuVisible then
        print("[DarkSide] Opening menu...")
        CreateMenu()
        if screenGui then 
            screenGui.Enabled = true
            print("[DarkSide] Menu should be visible now.")
        end
    else
        if screenGui then 
            screenGui.Enabled = false
        end
    end
end

-- ==================== START ====================
print("[DarkSide] Rivals Script v1.2 Loading...")
print("[DarkSide] Drawing library available: " .. tostring(drawingAvailable))

-- Keybind: INSERT
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Config.Menu.Key then
        print("[DarkSide] INSERT pressed! Toggling menu...")
        ToggleMenu()
    end
end)

-- Start loops
RunService.RenderStepped:Connect(DoAimbot)
RunService.RenderStepped:Connect(UpdateESP)

print("[DarkSide] Rivals Script Loaded! Press INSERT to open menu.")
