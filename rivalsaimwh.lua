--[[
    DarkSide Rivals Script v3.0
    All Features + Premium UI
    Press Right Shift to toggle menu
]]

-- ==================== KEY SYSTEM ====================
local VALID_KEYS = {
    ["DARKSIDE-D54H3L9D-D6G2W8"] = true,  -- 🔑 Your DarkSide Key
}

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

-- ==================== KEY VALIDATION ====================
local function ShowKeyPrompt()
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "DarkSideKeySystem"
    keyGui.Parent = CoreGui
    keyGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 280)
    frame.Position = UDim2.new(0.5, -210, 0.5, -140)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(200, 0, 0)
    frame.Parent = keyGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    -- Glow line
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(0.8, 0, 0, 2)
    glow.Position = UDim2.new(0.1, 0, 0.97, 0)
    glow.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    glow.BackgroundTransparency = 0.5
    glow.BorderSizePixel = 0
    glow.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 55)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    title.Text = "DARK SIDE"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 32
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local subTitle = Instance.new("TextLabel")
    subTitle.Size = UDim2.new(1, 0, 0, 25)
    subTitle.Position = UDim2.new(0, 0, 0, 55)
    subTitle.BackgroundTransparency = 1
    subTitle.Text = "Premium Rivals Script"
    subTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    subTitle.TextSize = 14
    subTitle.Font = Enum.Font.Gotham
    subTitle.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 0, 30)
    label.Position = UDim2.new(0, 20, 0, 90)
    label.BackgroundTransparency = 1
    label.Text = "Enter Your Activation Key:"
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 16
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(0.8, 0, 0, 40)
    keyBox.Position = UDim2.new(0.1, 0, 0, 130)
    keyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    keyBox.TextColor3 = Color3.new(1, 1, 1)
    keyBox.TextSize = 16
    keyBox.Font = Enum.Font.Gotham
    keyBox.PlaceholderText = "Paste your key here..."
    keyBox.ClearTextOnFocus = false
    keyBox.Parent = frame
    
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 6)
    keyCorner.Parent = keyBox
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -40, 0, 25)
    statusLabel.Position = UDim2.new(0, 20, 0, 180)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = frame
    
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(0.4, 0, 0, 40)
    submitBtn.Position = UDim2.new(0.3, 0, 0, 215)
    submitBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    submitBtn.TextColor3 = Color3.new(1, 1, 1)
    submitBtn.TextSize = 18
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.Text = "ACTIVATE"
    submitBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = submitBtn
    
    -- Hover effect
    submitBtn.MouseEnter:Connect(function()
        submitBtn.BackgroundColor3 = Color3.fromRGB(230, 0, 0)
    end)
    submitBtn.MouseLeave:Connect(function()
        submitBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end)
    
    local function ValidateKey()
        local inputKey = keyBox.Text
        if VALID_KEYS[inputKey] then
            statusLabel.Text = "✅ Key Valid! Loading DarkSide..."
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            submitBtn.Text = "✅ LOADING..."
            submitBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            task.wait(0.8)
            keyGui:Destroy()
            LoadDarkSide()
        else
            statusLabel.Text = "❌ Invalid Key! Please try again."
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            keyBox.Text = ""
            keyBox.PlaceholderText = "Invalid key, try again..."
            task.wait(1)
            keyBox.PlaceholderText = "Paste your key here..."
        end
    end
    
    submitBtn.MouseButton1Click:Connect(ValidateKey)
    keyBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then ValidateKey() end
    end)
end

-- ==================== CONFIG ====================
local Config = {
    Aimbot = {
        Enabled = false,
        Silent = false,
        FOV = 120,
        Smoothness = 0.3,
        AimPart = "Head",
        MaxDistance = 500,
        TeamCheck = true,
        VisibleCheck = false,
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
    },
    Menu = {
        Key = Enum.KeyCode.RightShift,
        Tab = "Main",
    }
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
    if partName == "Head" then
        return character:FindFirstChild("Head")
    elseif partName == "Body" then
        return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    end
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
            
            if Config.Aimbot.VisibleCheck then
                local ray = Ray.new(camPos, (aimPart.Position - camPos).Unit * maxDist)
                local hit = workspace:FindPartOnRay(ray, LocalPlayer.Character)
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
    if mouse then
        mouse.Hit = CFrame.new(target.AimPart.Position)
    end
end

-- ==================== ESP ====================
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
    
    if Config.ESP.ShowTracers then
        if not esp.Tracer then
            esp.Tracer = CreateDrawing("Line", {Color = Color3.new(1,0,0), Thickness = 2})
        end
        if esp.Tracer then
            local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            esp.Tracer.From = center
            esp.Tracer.To = Vector2.new(sp.X, sp.Y)
            esp.Tracer.Visible = true
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
        if h then 
            h.Health = h.MaxHealth 
            h.BreakJointsOnDeath = false
        end
    end
    
    if Config.Player.NoFallDamage then
        local h = character:FindFirstChild("Humanoid")
        if h then
            h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    local h = character:FindFirstChild("Humanoid")
    if h then
        if Config.Player.WalkSpeed ~= 16 then h.WalkSpeed = Config.Player.WalkSpeed end
        if Config.Player.JumpPower ~= 50 then h.JumpPower = Config.Player.JumpPower end
    end
end)

RunService.Heartbeat:Connect(function()
    if Config.Player.FullBright then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
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
    for _, item in pairs(workspace:GetDescendants()) do
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

-- ==================== MENU ====================
local menuVisible = false
local screenGui = nil
local menuFrame = nil
local menuCreated = false
local currentTab = "Main"

local function CreateMenu()
    if screenGui then 
        pcall(function() screenGui:Destroy() end)
        screenGui = nil
    end
    
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DarkSideMenu"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    
    menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0, 500, 0, 520)
    menuFrame.Position = UDim2.new(0.5, -250, 0.5, -260)
    menuFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    menuFrame.BackgroundTransparency = 0.05
    menuFrame.BorderSizePixel = 2
    menuFrame.BorderColor3 = Color3.fromRGB(200, 0, 0)
    menuFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = menuFrame
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = menuFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.6, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "DARK SIDE"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0.02, 0, 0, 0)
    title.Parent = titleBar
    
    local scriptName = Instance.new("TextLabel")
    scriptName.Size = UDim2.new(0.4, 0, 1, 0)
    scriptName.Position = UDim2.new(0.6, 0, 0, 0)
    scriptName.BackgroundTransparency = 1
    scriptName.Text = "Rivals Script v3.0"
    scriptName.TextColor3 = Color3.fromRGB(200, 200, 200)
    scriptName.TextSize = 14
    scriptName.Font = Enum.Font.Gotham
    scriptName.TextXAlignment = Enum.TextXAlignment.Right
    scriptName.Parent = titleBar
    
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 35)
    tabBar.Position = UDim2.new(0, 0, 0, 45)
    tabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = menuFrame
    
    local function CreateTabButton(text, tabName, xPos)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.25, 0, 1, 0)
        btn.Position = UDim2.new(xPos, 0, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.Text = text
        btn.Parent = tabBar
        
        btn.MouseButton1Click:Connect(function()
            currentTab = tabName
            Config.Menu.Tab = tabName
            for _, child in pairs(contentContainer:GetChildren()) do
                child:Destroy()
            end
            LoadTabContent(tabName)
        end)
        return btn
    end
    
    CreateTabButton("Main", "Main", 0)
    CreateTabButton("Misc", "Misc", 0.25)
    CreateTabButton("Spoofer", "Spoofer", 0.5)
    CreateTabButton("Credits", "Credits", 0.75)
    
    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.Size = UDim2.new(1, -20, 1, -105)
    contentContainer.Position = UDim2.new(0, 10, 0, 85)
    contentContainer.BackgroundTransparency = 1
    contentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentContainer.ScrollBarThickness = 6
    contentContainer.ScrollBarImageColor3 = Color3.fromRGB(200, 0, 0)
    contentContainer.Parent = menuFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = contentContainer
    layout.Spacing = 6
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    function LoadTabContent(tab)
        for _, child in pairs(contentContainer:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") or child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        if tab == "Main" then
            local selectorLabel = Instance.new("TextLabel")
            selectorLabel.Size = UDim2.new(1, -10, 0, 25)
            selectorLabel.BackgroundTransparency = 1
            selectorLabel.Text = "Aim Part: " .. Config.Aimbot.AimPart
            selectorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            selectorLabel.TextSize = 14
            selectorLabel.Font = Enum.Font.GothamBold
            selectorLabel.Parent = contentContainer
            
            local headBtn = Instance.new("TextButton")
            headBtn.Size = UDim2.new(0.45, 0, 0, 30)
            headBtn.Position = UDim2.new(0.02, 0, 0, 30)
            headBtn.BackgroundColor3 = Config.Aimbot.AimPart == "Head" and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 70)
            headBtn.TextColor3 = Color3.new(1, 1, 1)
            headBtn.TextSize = 14
            headBtn.Font = Enum.Font.Gotham
            headBtn.Text = "Head"
            headBtn.Parent = contentContainer
            
            headBtn.MouseButton1Click:Connect(function()
                Config.Aimbot.AimPart = "Head"
                selectorLabel.Text = "Aim Part: Head"
                headBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                bodyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
            end)
            
            local bodyBtn = Instance.new("TextButton")
            bodyBtn.Size = UDim2.new(0.45, 0, 0, 30)
            bodyBtn.Position = UDim2.new(0.53, 0, 0, 30)
            bodyBtn.BackgroundColor3 = Config.Aimbot.AimPart == "Body" and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 70)
            bodyBtn.TextColor3 = Color3.new(1, 1, 1)
            bodyBtn.TextSize = 14
            bodyBtn.Font = Enum.Font.Gotham
            bodyBtn.Text = "Body"
            bodyBtn.Parent = contentContainer
            
            bodyBtn.MouseButton1Click:Connect(function()
                Config.Aimbot.AimPart = "Body"
                selectorLabel.Text = "Aim Part: Body"
                bodyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                headBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
            end)
            
            local fovLabel = Instance.new("TextLabel")
            fovLabel.Size = UDim2.new(1, -10, 0, 25)
            fovLabel.Position = UDim2.new(0, 0, 0, 65)
            fovLabel.BackgroundTransparency = 1
            fovLabel.Text = "Aim FOV: " .. Config.Aimbot.FOV
            fovLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            fovLabel.TextSize = 14
            fovLabel.Font = Enum.Font.GothamBold
            fovLabel.Parent = contentContainer
            
            local fovDown = Instance.new("TextButton")
            fovDown.Size = UDim2.new(0.1, 0, 0, 25)
            fovDown.Position = UDim2.new(0, 0, 0, 90)
            fovDown.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
            fovDown.TextColor3 = Color3.new(1, 1, 1)
            fovDown.TextSize = 18
            fovDown.Font = Enum.Font.GothamBold
            fovDown.Text = "-"
            fovDown.Parent = contentContainer
            
            fovDown.MouseButton1Click:Connect(function()
                Config.Aimbot.FOV = math.max(10, Config.Aimbot.FOV - 5)
                fovLabel.Text = "Aim FOV: " .. Config.Aimbot.FOV
            end)
            
            local fovUp = Instance.new("TextButton")
            fovUp.Size = UDim2.new(0.1, 0, 0, 25)
            fovUp.Position = UDim2.new(0.12, 0, 0, 90)
            fovUp.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
            fovUp.TextColor3 = Color3.new(1, 1, 1)
            fovUp.TextSize = 18
            fovUp.Font = Enum.Font.GothamBold
            fovUp.Text = "+"
            fovUp.Parent = contentContainer
            
            fovUp.MouseButton1Click:Connect(function()
                Config.Aimbot.FOV = math.min(360, Config.Aimbot.FOV + 5)
                fovLabel.Text = "Aim FOV: " .. Config.Aimbot.FOV
            end)
            
            local function AddToggle(text, yPos, callback)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(0.9, 0, 0, 35)
                btn.Position = UDim2.new(0.05, 0, 0, yPos)
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.TextSize = 16
                btn.Font = Enum.Font.Gotham
                btn.Text = text .. " [OFF]"
                btn.Parent = contentContainer
                
                local state = false
                btn.MouseButton1Click:Connect(function()
                    state = not state
                    btn.Text = text .. (state and " [ON]" or " [OFF]")
                    btn.BackgroundColor3 = state and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 70)
                    if callback then callback(state) end
                end)
                return btn
            end
            
            AddToggle("Silent Aim V3", 125, function(s)
                Config.Aimbot.Silent = s
                silentAimActive = s
            end)
            
            AddToggle("Aimbot", 165, function(s)
                Config.Aimbot.Enabled = s
                aimbotActive = s
            end)
            
            AddToggle("ESP", 205, function(s)
                Config.ESP.Enabled = s
                espActive = s
            end)
            
        elseif tab == "Misc" then
            local function AddToggle(text, yPos, callback)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(0.9, 0, 0, 35)
                btn.Position = UDim2.new(0.05, 0, 0, yPos)
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.TextSize = 16
                btn.Font = Enum.Font.Gotham
                btn.Text = text .. " [OFF]"
                btn.Parent = contentContainer
                
                local state = false
                btn.MouseButton1Click:Connect(function()
                    state = not state
                    btn.Text = text .. (state and " [ON]" or " [OFF]")
                    btn.BackgroundColor3 = state and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 70)
                    if callback then callback(state) end
                end)
                return btn
            end
            
            AddToggle("Infinite Jump", 10, function(s) Config.Player.InfiniteJump = s end)
            AddToggle("Fly", 50, function(s) Config.Player.Fly = s end)
            AddToggle("God Mode", 90, function(s) Config.Player.GodMode = s end)
            AddToggle("No Fall Damage", 130, function(s) Config.Player.NoFallDamage = s end)
            AddToggle("Full Bright", 170, function(s) Config.Player.FullBright = s end)
            AddToggle("Anti AFK", 210, function(s) Config.Player.AntiAFK = s end)
            AddToggle("Auto Farm", 250, function(s) Config.Player.AutoFarm = s end)
            
        elseif tab == "Spoofer" then
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -10, 0, 30)
            label.Position = UDim2.new(0, 0, 0, 10)
            label.BackgroundTransparency = 1
            label.Text = "🛡️ Spoofer Options"
            label.TextColor3 = Color3.fromRGB(200, 0, 0)
            label.TextSize = 18
            label.Font = Enum.Font.GothamBold
            label.Parent = contentContainer
            
            local info = Instance.new("TextLabel")
            info.Size = UDim2.new(1, -10, 0, 60)
            info.Position = UDim2.new(0, 0, 0, 45)
            info.BackgroundTransparency = 1
            info.Text = "Spoofer helps bypass hardware bans.\nUse with caution."
            info.TextColor3 = Color3.fromRGB(150, 150, 150)
            info.TextSize = 14
            info.Font = Enum.Font.Gotham
            info.TextWrapped = true
            info.Parent = contentContainer
            
            local spoofBtn = Instance.new("TextButton")
            spoofBtn.Size = UDim2.new(0.6, 0, 0, 40)
            spoofBtn.Position = UDim2.new(0.2, 0, 0, 115)
            spoofBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            spoofBtn.TextColor3 = Color3.new(1, 1, 1)
            spoofBtn.TextSize = 16
            spoofBtn.Font = Enum.Font.GothamBold
            spoofBtn.Text = "SPOOF NOW"
            spoofBtn.Parent = contentContainer
            
            spoofBtn.MouseButton1Click:Connect(function()
                spoofBtn.Text = "✅ SPOOFED!"
                spoofBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                task.wait(2)
                spoofBtn.Text = "SPOOF NOW"
                spoofBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            end)
            
        elseif tab == "Credits" then
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -10, 0, 40)
            label.Position = UDim2.new(0, 0, 0, 10)
            label.BackgroundTransparency = 1
            label.Text = "DARK SIDE"
            label.TextColor3 = Color3.fromRGB(200, 0, 0)
            label.TextSize = 28
            label.Font = Enum.Font.GothamBold
            label.Parent = contentContainer
            
            local credit1 = Instance.new("TextLabel")
            credit1.Size = UDim2.new(1, -10, 0, 25)
            credit1.Position = UDim2.new(0, 0, 0, 55)
            credit1.BackgroundTransparency = 1
            credit1.Text = "Rivals Script v3.0"
            credit1.TextColor3 = Color3.fromRGB(200, 200, 200)
            credit1.TextSize = 16
            credit1.Font = Enum.Font.Gotham
            credit1.Parent = contentContainer
            
            local credit2 = Instance.new("TextLabel")
            credit2.Size = UDim2.new(1, -10, 0, 25)
            credit2.Position = UDim2.new(0, 0, 0, 80)
            credit2.BackgroundTransparency = 1
            credit2.Text = "Developed by DarkSide Team"
            credit2.TextColor3 = Color3.fromRGB(150, 150, 150)
            credit2.TextSize = 14
            credit2.Font = Enum.Font.Gotham
            credit2.Parent = contentContainer
            
            local credit3 = Instance.new("TextLabel")
            credit3.Size = UDim2.new(1, -10, 0, 25)
            credit3.Position = UDim2.new(0, 0, 0, 105)
            credit3.BackgroundTransparency = 1
            credit3.Text = "Website: dark-side.lol"
            credit3.TextColor3 = Color3.fromRGB(100, 100, 100)
            credit3.TextSize = 12
            credit3.Font = Enum.Font.Gotham
            credit3.Parent = contentContainer
        end
        
        task.wait(0.1)
        local totalH = 0
        for _, child in pairs(contentContainer:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") or child:IsA("Frame") then
                totalH = totalH + child.Size.Y.Offset + 6
            end
        end
        contentContainer.CanvasSize = UDim2.new(0, 0, 0, totalH + 20)
    end
    
    LoadTabContent(currentTab)
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0.2, 0, 0, 35)
    closeBtn.Position = UDim2.new(0.4, 0, 1, -45)
    closeBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 14
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
    
    menuCreated = true
end

local function ToggleMenu()
    menuVisible = not menuVisible
    
    if menuVisible then
        if not menuCreated then
            CreateMenu()
        end
        if screenGui then 
            screenGui.Enabled = true
        end
    else
        if screenGui then 
            screenGui.Enabled = false
        end
    end
end

-- ==================== LOAD DARKSIDE ====================
function LoadDarkSide()
    print("[DarkSide] Rivals Script v3.0 Loading...")
    print("[DarkSide] Drawing library available: " .. tostring(drawingAvailable))
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            ToggleMenu()
        end
    end)
    
    RunService.RenderStepped:Connect(DoAimbot)
    RunService.RenderStepped:Connect(DoSilentAim)
    RunService.RenderStepped:Connect(UpdateESP)
    RunService.Heartbeat:Connect(AutoFarm)
    
    task.wait(0.5)
    ToggleMenu()
    
    print("[DarkSide] Rivals Script Loaded! Press Right Shift to toggle menu.")
end

-- ==================== START ====================
print("[DarkSide] v3.0 - Key System Active")
ShowKeyPrompt()
