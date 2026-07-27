--[[
    Skelly Hub Rivals Script
    Using LinoriaLib UI Library
    Press Right Shift to toggle
]]

-- ======================================================================
-- LOAD LINORIALIB
-- ======================================================================

local Library = nil

-- Try loading from first URL (violin-suzutsuki)
local success, lib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
end)

if success and lib then
    Library = lib
    print("[SkellyHub] ✅ Loaded LinoriaLib from violin-suzutsuki")
else
    -- Try second URL (caIIed)
    local success2, lib2 = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/caIIed/Linoria-Rewrite/main/Library.lua"))()
    end)
    
    if success2 and lib2 then
        Library = lib2
        print("[SkellyHub] ✅ Loaded LinoriaLib from caIIed")
    else
        print("[SkellyHub] ❌ Failed to load LinoriaLib!")
        print("[SkellyHub] Make sure you have an internet connection.")
        return
    end
end

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
        AimKey = "MouseButton2",
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
}

-- ======================================================================
-- STATE VARIABLES
-- ======================================================================

local aimbotActive = false
local silentAimActive = false
local espActive = false
local aimKeyHeld = false
local fovCircle = nil

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
    
    -- Aim key
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimKeyHeld = true
    end
    
    -- Menu key (Right Shift)
    if input.KeyCode == Enum.KeyCode.RightShift then
        if Library then
            Library:Toggle()
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimKeyHeld = false
    end
end)

-- ======================================================================
-- ESP
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
-- BUILD LINORIALIB UI
-- ======================================================================

if Library then
    -- Create Window
    local Window = Library:CreateWindow("💀 Skelly Hub", "Skelly Hub Rivals Script")
    
    -- ======================================================================
    -- AIMBOT TAB
    -- ======================================================================
    
    local AimbotTab = Window:CreateTab("Aimbot")
    local AimbotGroup = AimbotTab:CreateGroup("Aimbot Settings")
    
    AimbotGroup:AddToggle("Aimbot", {
        Text = "Enable Aimbot",
        Default = false,
        Tooltip = "Toggle the aimbot on/off",
        Callback = function(Value)
            Config.Aimbot.Enabled = Value
            aimbotActive = Value
            UpdateFOVCircle()
        end
    })
    
    AimbotGroup:AddToggle("Silent Aim", {
        Text = "Silent Aim",
        Default = false,
        Tooltip = "Aim without moving your camera",
        Callback = function(Value)
            Config.Aimbot.Silent = Value
            silentAimActive = Value
        end
    })
    
    AimbotGroup:AddToggle("Show FOV Circle", {
        Text = "Show FOV Circle",
        Default = true,
        Tooltip = "Show a circle on screen showing your FOV",
        Callback = function(Value)
            Config.Aimbot.ShowFOVCircle = Value
            UpdateFOVCircle()
        end
    })
    
    AimbotGroup:AddToggle("Team Check", {
        Text = "Team Check",
        Default = true,
        Tooltip = "Don't aim at teammates",
        Callback = function(Value)
            Config.Aimbot.TeamCheck = Value
        end
    })
    
    AimbotGroup:AddToggle("Visible Check", {
        Text = "Visible Check",
        Default = false,
        Tooltip = "Only aim at enemies you can see",
        Callback = function(Value)
            Config.Aimbot.VisibleCheck = Value
        end
    })
    
    AimbotGroup:AddSlider("FOV", {
        Text = "Aim FOV",
        Default = 120,
        Min = 10,
        Max = 360,
        Rounding = 1,
        Callback = function(Value)
            Config.Aimbot.FOV = Value
            UpdateFOVCircle()
        end
    })
    
    AimbotGroup:AddSlider("Smoothness", {
        Text = "Smoothness",
        Default = 0.3,
        Min = 0,
        Max = 1,
        Rounding = 2,
        Callback = function(Value)
            Config.Aimbot.Smoothness = Value
        end
    })
    
    AimbotGroup:AddSlider("Max Distance", {
        Text = "Max Distance",
        Default = 500,
        Min = 100,
        Max = 1000,
        Rounding = 1,
        Callback = function(Value)
            Config.Aimbot.MaxDistance = Value
        end
    })
    
    AimbotGroup:AddDropdown("Aim Part", {
        Text = "Aim Part",
        Values = {"Head", "Body", "HumanoidRootPart"},
        Default = 1,
        Callback = function(Value)
            Config.Aimbot.AimPart = Value
        end
    })
    
    -- ======================================================================
    -- AIM KEY TAB
    -- ======================================================================
    
    local KeyTab = Window:CreateTab("Keybinds")
    local KeyGroup = KeyTab:CreateGroup("Keybinds")
    
    KeyGroup:AddKeyPicker("Aim Key", {
        Text = "Aim Key",
        Default = "MouseButton2",
        Mode = "Hold",
        Callback = function(Value)
            Config.Aimbot.AimKey = Value
        end
    })
    
    -- ======================================================================
    -- ESP TAB
    -- ======================================================================
    
    local ESPTab = Window:CreateTab("ESP")
    local ESPGroup = ESPTab:CreateGroup("ESP Settings")
    
    ESPGroup:AddToggle("ESP Enabled", {
        Text = "Enable ESP",
        Default = false,
        Tooltip = "Toggle ESP on/off",
        Callback = function(Value)
            Config.ESP.Enabled = Value
            espActive = Value
        end
    })
    
    ESPGroup:AddToggle("Boxes", {
        Text = "Boxes",
        Default = true,
        Callback = function(Value)
            Config.ESP.ShowBoxes = Value
        end
    })
    
    ESPGroup:AddToggle("Names", {
        Text = "Names",
        Default = true,
        Callback = function(Value)
            Config.ESP.ShowNames = Value
        end
    })
    
    ESPGroup:AddToggle("Health Bars", {
        Text = "Health Bars",
        Default = true,
        Callback = function(Value)
            Config.ESP.ShowHealth = Value
        end
    })
    
    ESPGroup:AddToggle("Distance", {
        Text = "Distance",
        Default = true,
        Callback = function(Value)
            Config.ESP.ShowDistance = Value
        end
    })
    
    ESPGroup:AddToggle("Tracers", {
        Text = "Tracers",
        Default = false,
        Callback = function(Value)
            Config.ESP.ShowTracers = Value
        end
    })
    
    ESPGroup:AddToggle("Team Check", {
        Text = "Team Check",
        Default = true,
        Callback = function(Value)
            Config.ESP.TeamCheck = Value
        end
    })
    
    ESPGroup:AddSlider("Max Distance", {
        Text = "Max Distance",
        Default = 1000,
        Min = 100,
        Max = 2000,
        Rounding = 1,
        Callback = function(Value)
            Config.ESP.MaxDistance = Value
        end
    })
    
    -- ======================================================================
    -- PLAYER TAB
    -- ======================================================================
    
    local PlayerTab = Window:CreateTab("Player")
    local PlayerGroup = PlayerTab:CreateGroup("Player Mods")
    
    PlayerGroup:AddToggle("Infinite Jump", {
        Text = "Infinite Jump",
        Default = false,
        Callback = function(Value)
            Config.Player.InfiniteJump = Value
        end
    })
    
    PlayerGroup:AddToggle("Fly", {
        Text = "Fly",
        Default = false,
        Callback = function(Value)
            Config.Player.Fly = Value
        end
    })
    
    PlayerGroup:AddSlider("Fly Speed", {
        Text = "Fly Speed",
        Default = 50,
        Min = 10,
        Max = 200,
        Rounding = 1,
        Callback = function(Value)
            Config.Player.FlySpeed = Value
        end
    })
    
    PlayerGroup:AddToggle("God Mode", {
        Text = "God Mode",
        Default = false,
        Callback = function(Value)
            Config.Player.GodMode = Value
        end
    })
    
    PlayerGroup:AddToggle("No Fall Damage", {
        Text = "No Fall Damage",
        Default = false,
        Callback = function(Value)
            Config.Player.NoFallDamage = Value
        end
    })
    
    PlayerGroup:AddToggle("Full Bright", {
        Text = "Full Bright",
        Default = false,
        Callback = function(Value)
            Config.Player.FullBright = Value
        end
    })
    
    PlayerGroup:AddToggle("No Clip", {
        Text = "No Clip",
        Default = false,
        Callback = function(Value)
            Config.Player.NoClip = Value
        end
    })
    
    PlayerGroup:AddSlider("Walk Speed", {
        Text = "Walk Speed",
        Default = 16,
        Min = 10,
        Max = 100,
        Rounding = 1,
        Callback = function(Value)
            Config.Player.WalkSpeed = Value
        end
    })
    
    PlayerGroup:AddSlider("Jump Power", {
        Text = "Jump Power",
        Default = 50,
        Min = 10,
        Max = 200,
        Rounding = 1,
        Callback = function(Value)
            Config.Player.JumpPower = Value
        end
    })
    
    PlayerGroup:AddToggle("Anti AFK", {
        Text = "Anti AFK",
        Default = false,
        Callback = function(Value)
            Config.Player.AntiAFK = Value
        end
    })
    
    PlayerGroup:AddToggle("Auto Farm", {
        Text = "Auto Farm",
        Default = false,
        Callback = function(Value)
            Config.Player.AutoFarm = Value
        end
    })
    
    -- ======================================================================
    -- CREDITS TAB
    -- ======================================================================
    
    local CreditsTab = Window:CreateTab("Credits")
    local CreditsGroup = CreditsTab:CreateGroup("About")
    
    CreditsGroup:AddLabel("💀 Skelly Hub")
    CreditsGroup:AddLabel("Version: 10.0")
    CreditsGroup:AddLabel("")
    CreditsGroup:AddLabel("Developed by Skelly Hub Team")
    CreditsGroup:AddLabel("")
    CreditsGroup:AddLabel("💀 skelly-hub.lol")
    CreditsGroup:AddLabel("")
    CreditsGroup:AddLabel("Press Right Shift to toggle menu")
end

-- ======================================================================
-- AUTO-OPEN MENU
-- ======================================================================

local function AutoOpenMenu()
    print("[SkellyHub] Auto-opening menu in 1.5 seconds...")
    task.wait(1.5)
    if Library then
        Library:Open()
        print("[SkellyHub] Menu opened!")
    end
end

-- ======================================================================
-- START
-- ======================================================================

print("[SkellyHub] Rivals Script Loading...")
print("[SkellyHub] Press Right Shift to toggle menu.")

RunService.RenderStepped:Connect(UpdateFOVCircle)
RunService.RenderStepped:Connect(DoAimbot)
RunService.RenderStepped:Connect(DoSilentAim)
RunService.RenderStepped:Connect(UpdateESP)

AutoOpenMenu()

print("[SkellyHub] Loaded successfully!")
