--[[
    Rivals Script - Working Version
    Features: Aimbot, ESP, Fly, Infinite Jump
]]

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

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

-- ==================== ESP ====================
local espActive = false
local drawings = {}
local espObjects = {}

local function CreateDrawing(drawType, props)
    local d = Drawing.new(drawType)
    for k, v in pairs(props or {}) do d[k] = v end
    table.insert(drawings, d)
    return d
end

local function ClearESP()
    for _, d in pairs(drawings) do d:Remove() end
    drawings = {}
    espObjects = {}
end

local function DrawESP(player)
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
        esp.Box.Position = Vector2.new(sp.X - size*0.3, sp.Y - size*0.5)
        esp.Box.Size = Vector2.new(size*0.6, size)
        esp.Box.Visible = true
    end
    
    if Config.ESP.ShowNames then
        if not esp.Name then
            esp.Name = CreateDrawing("Text", {Color = Color3.new(1,1,1), Size = 14, Center = true, Outline = true, OutlineColor = Color3.new(0,0,0), Font = Drawing.Fonts.UI})
        end
        esp.Name.Text = player.DisplayName or player.Name
        esp.Name.Position = Vector2.new(sp.X, sp.Y - size*0.55 - 20)
        esp.Name.Visible = true
    end
    
    if Config.ESP.ShowHealth then
        if not esp.Health then
            esp.Health = CreateDrawing("Square", {Color = Color3.new(0,1,0), Thickness = 2, Filled = true})
        end
        local hp = humanoid.Health / humanoid.MaxHealth
        local bh = size * 0.8
        esp.Health.Position = Vector2.new(sp.X + size*0.35, sp.Y - size*0.5 + (size - bh*hp))
        esp.Health.Size = Vector2.new(4, bh*hp)
        esp.Health.Visible = true
        if hp < 0.3 then esp.Health.Color = Color3.new(1,0,0)
        elseif hp < 0.6 then esp.Health.Color = Color3.new(1,1,0)
        else esp.Health.Color = Color3.new(0,1,0) end
    end
    
    if Config.ESP.ShowDistance then
        if not esp.Dist then
            esp.Dist = CreateDrawing("Text", {Color = Color3.new(0.5,0.5,1), Size = 12, Center = true, Outline = true, OutlineColor = Color3.new(0,0,0), Font = Drawing.Fonts.UI})
        end
        esp.Dist.Text = string.format("%.0fm", distance / 3)
        esp.Dist.Position = Vector2.new(sp.X, sp.Y + size*0.55 + 5)
        esp.Dist.Visible = true
    end
end

local function UpdateESP()
    if not espActive or not Config.ESP.Enabled then ClearESP(); return end
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

-- ==================== MENU ====================
local menuVisible = false
local screenGui = nil

local function CreateMenu()
    if screenGui then screenGui:Destroy() end
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RivalsMenu"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 350, 0, 400)
    main.Position = UDim2.new(0.5, -175, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    main.BorderSizePixel = 2
    main.BorderColor3 = Color3.fromRGB(200, 0, 0)
    main.Parent = screenGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    title.Text = "DARK SIDE"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.Parent = main
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -80)
    scroll.Position = UDim2.new(0, 10, 0, 50)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 6
    scroll.Parent = main
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = scroll
    layout.Spacing = 5
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local function AddButton(parent, text, y, toggleVar, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 16
        btn.Font = Enum.Font.Gotham
        btn.Text = text .. " OFF"
        btn.Parent = parent
        
        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text .. (state and " ON" or " OFF")
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 70)
            if callback then callback(state) end
        end)
        return btn
    end
    
    AddButton(scroll, "Aimbot", 0, nil, function(s) Config.Aimbot.Enabled = s; aimbotActive = s end)
    AddButton(scroll, "ESP", 0, nil, function(s) Config.ESP.Enabled = s; espActive = s end)
    AddButton(scroll, "Infinite Jump", 0, nil, function(s) Config.Player.InfiniteJump = s end)
    AddButton(scroll, "Fly", 0, nil, function(s) Config.Player.Fly = s end)
    AddButton(scroll, "God Mode", 0, nil, function(s) Config.Player.GodMode = s end)
    AddButton(scroll, "Full Bright", 0, nil, function(s) Config.Player.FullBright = s end)
    
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0.4, 0, 0, 35)
    close.Position = UDim2.new(0.3, 0, 0, 340)
    close.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
    close.Text = "Close"
    close.TextColor3 = Color3.new(1, 1, 1)
    close.TextSize = 16
    close.Font = Enum.Font.GothamBold
    close.Parent = main
    close.MouseButton1Click:Connect(function()
        menuVisible = false
        if screenGui then screenGui.Enabled = false end
    end)
    
    task.wait(0.1)
    local totalH = 0
    for _, child in pairs(scroll:GetChildren()) do
        if child:IsA("TextButton") then totalH = totalH + 35 + 5 end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, totalH + 20)
end

local function ToggleMenu()
    menuVisible = not menuVisible
    if menuVisible then CreateMenu(); if screenGui then screenGui.Enabled = true end
    else if screenGui then screenGui.Enabled = false end end
end

-- ==================== START ====================
print("[DarkSide] Rivals Script Loading...")

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Config.Menu.Key then ToggleMenu() end
end)

RunService.RenderStepped:Connect(DoAimbot)
RunService.RenderStepped:Connect(UpdateESP)

print("[DarkSide] Rivals Script Loaded! Press INSERT for menu.")
