-- // RAVEN CHEATS - FULL FEATURE MENU
-- // Press Right Shift to open
-- // Works with any executor

-- ================================================
--  SERVICES
-- ================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local Camera = Workspace.CurrentCamera
local LP = Players.LocalPlayer

-- ================================================
--  LOAD LINORIA
-- ================================================
local Library, SaveManager, ThemeManager
local LibraryLoaded = false

for _, url in ipairs({
    "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua",
    "https://raw.githubusercontent.com/caIIed/Linoria-Rewrite/main/Library.lua",
}) do
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success and result then
        Library = result
        LibraryLoaded = true
        break
    end
end

if not LibraryLoaded then
    warn("[Raven] Failed to load UI library")
    StarterGui:SetCore("SendNotification", {
        Title = "Raven Cheats",
        Text = "Failed to load UI library.",
        Duration = 5,
    })
    return
end

-- ================================================
--  THEME
-- ================================================
local RED = Color3.fromRGB(220, 20, 20)
local RED_DARK = Color3.fromRGB(120, 10, 10)
local YELLOW = Color3.fromRGB(255, 215, 0)
local WHITE = Color3.fromRGB(255, 255, 255)
local BLACK = Color3.fromRGB(0, 0, 0)
local GRAY = Color3.fromRGB(180, 180, 180)

local function ApplyTheme()
    if not Library then return end
    pcall(function()
        Library.AccentColor = RED
        Library.AccentColorDark = RED_DARK
        Library.FontColor = Color3.fromRGB(240, 240, 240)
        Library.MainColor = Color3.fromRGB(14, 14, 18)
        Library.BackgroundColor = Color3.fromRGB(10, 10, 14)
        Library.OutlineColor = Color3.fromRGB(50, 50, 55)
        Library:UpdateColorsUsingRegistry()
    end)
end

-- ================================================
--  STATE VARIABLES
-- ================================================
local aimbotActive = false
local espActive = false
local flyEnabled = false
local noclipEnabled = false
local infiniteJumpEnabled = false
local godModeEnabled = false
local fullBrightEnabled = false
local speedHackEnabled = false
local crosshairEnabled = false

local aimKeyHeld = false
local flyConnection = nil
local noclipConnection = nil
local speedHackConnection = nil

-- ESP Drawing
local ESPs = {}
local espDrawings = {}

-- ================================================
--  DRAWING HELPERS
-- ================================================
local function L(props)
    local d = Drawing.new("Line")
    d.Visible = false
    d.Color = props.Color or WHITE
    d.Thickness = props.Thickness or 1
    d.ZIndex = props.ZIndex or 5
    return d
end

local function T(props)
    local d = Drawing.new("Text")
    d.Visible = false
    d.Text = props.Text or ""
    d.Size = props.Size or 13
    d.Center = props.Center ~= nil and props.Center or true
    d.Outline = true
    d.OutlineColor = BLACK
    d.Color = props.Color or WHITE
    d.ZIndex = props.ZIndex or 6
    d.Position = Vector2.new(-9999, -9999)
    return d
end

local function C(props)
    local d = Drawing.new("Circle")
    d.Visible = false
    d.Filled = false
    d.Thickness = props.Thickness or 2
    d.Color = props.Color or WHITE
    d.ZIndex = props.ZIndex or 10
    d.NumSides = 64
    d.Position = Vector2.new(-9999, -9999)
    d.Radius = 1
    return d
end

-- ================================================
--  HELPERS
-- ================================================
local function W2S(pos)
    local vp, on = Camera:WorldToViewportPoint(pos)
    return Vector2.new(vp.X, vp.Y), on and vp.Z > 0
end

local function AimPoint()
    if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        local vp = Camera.ViewportSize
        return Vector2.new(vp.X * 0.5, vp.Y * 0.5)
    end
    return UserInputService:GetMouseLocation()
end

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

-- ================================================
--  AIMBOT
-- ================================================
local FOVCIRC = C{ Color = WHITE, ZIndex = 10 }
local aimbotSettings = {
    FOV = 200,
    Smoothness = 0.3,
    Part = "Head",
    MaxDistance = 500,
}

local function GetBestTarget()
    local best = nil
    local bestScore = math.huge
    local fov = aimbotSettings.FOV
    local maxDist = aimbotSettings.MaxDistance
    local camPos = Camera.CFrame.Position
    local cx, cy = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LP then continue end
        if not IsAlive(player) then continue end
        
        local aimPart = GetAimPart(player.Character, aimbotSettings.Part)
        if not aimPart then continue end
        
        local sp, onScreen = Camera:WorldToScreenPoint(aimPart.Position)
        if not onScreen then continue end
        
        local d = math.sqrt((sp.X - cx)^2 + (sp.Y - cy)^2)
        if d > fov then continue end
        
        local wd = (camPos - aimPart.Position).Magnitude
        if wd > maxDist then continue end
        
        if d < bestScore then
            bestScore = d
            best = { Player = player, Character = player.Character, AimPart = aimPart }
        end
    end
    
    return best
end

local function DoAimbot()
    if not aimbotActive then return end
    if not aimKeyHeld then return end
    
    local target = GetBestTarget()
    if not target then return end
    
    local targetPos = target.AimPart.Position
    local camPos = Camera.CFrame.Position
    local dir = (targetPos - camPos).Unit
    
    local smooth = aimbotSettings.Smoothness
    if smooth > 0 then
        local curr = Camera.CFrame.LookVector
        local newLook = curr + (dir - curr) * (1 - smooth)
        if newLook.Magnitude > 0 then dir = newLook.Unit end
    end
    
    Camera.CFrame = CFrame.lookAt(camPos, camPos + dir)
end

local function UpdateFOV()
    if aimbotActive then
        FOVCIRC.Visible = true
        FOVCIRC.Position = AimPoint()
        FOVCIRC.Radius = aimbotSettings.FOV
        FOVCIRC.Color = WHITE
    else
        FOVCIRC.Visible = false
    end
end

-- ================================================
--  ESP
-- ================================================
local espObjects = {}

local function CreateESPObjects(player)
    if espObjects[player] then return end
    local o = {}
    
    o.Name = T{ Color = WHITE, Size = 13, ZIndex = 6 }
    o.Dist = T{ Color = GRAY, Size = 11, ZIndex = 6 }
    o.Box = {}
    for i = 1, 4 do
        o.Box[i] = L{ Color = WHITE, Thickness = 1.5, ZIndex = 5 }
    end
    
    espObjects[player] = o
end

local function DestroyESP(player)
    local o = espObjects[player]
    if not o then return end
    pcall(function() o.Name:Remove() end)
    pcall(function() o.Dist:Remove() end)
    for _, l in ipairs(o.Box) do pcall(function() l:Remove() end)
    espObjects[player] = nil
end

local function HideESP(o)
    if not o then return
    o.Name.Visible = false
    o.Dist.Visible = false
    for _, l in ipairs(o.Box) do l.Visible = false end
end

local function UpdateESP()
    if not espActive then
        for _, player in pairs(Players:GetPlayers()) do
            local o = espObjects[player]
            if o then HideESP(o) end
        end
        return
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end
        
        CreateESPObjects(player)
        local o = espObjects[player]
        local char = player.Character
        if not char then HideESP(o); continue end
        
        local hrp, hum = Parts(char)
        if not hrp or not hum then HideESP(o); continue end
        
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local dist = myRoot and (hrp.Position - myRoot.Position).Magnitude or 0
        if dist > 1000 then HideESP(o); continue end
        
        -- Get screen position
        local rootPos = hrp.Position
        local sp, onScreen = Camera:WorldToScreenPoint(rootPos)
        if not onScreen then HideESP(o); continue end
        
        -- Box
        local size = 3
        local head = char:FindFirstChild("Head")
        if head then
            local hp = Camera:WorldToScreenPoint(head.Position)
            size = math.abs(sp.Y - hp.Y) * 2 or 3
        end
        
        o.Box[1].From = Vector2.new(sp.X - size*0.3, sp.Y - size*0.5)
        o.Box[1].To = Vector2.new(sp.X + size*0.3, sp.Y - size*0.5)
        o.Box[1].Visible = true
        o.Box[2].From = Vector2.new(sp.X + size*0.3, sp.Y - size*0.5)
        o.Box[2].To = Vector2.new(sp.X + size*0.3, sp.Y + size*0.5)
        o.Box[2].Visible = true
        o.Box[3].From = Vector2.new(sp.X + size*0.3, sp.Y + size*0.5)
        o.Box[3].To = Vector2.new(sp.X - size*0.3, sp.Y + size*0.5)
        o.Box[3].Visible = true
        o.Box[4].From = Vector2.new(sp.X - size*0.3, sp.Y + size*0.5)
        o.Box[4].To = Vector2.new(sp.X - size*0.3, sp.Y - size*0.5)
        o.Box[4].Visible = true
        
        -- Name
        o.Name.Position = Vector2.new(sp.X, sp.Y - size*0.5 - 16)
        o.Name.Text = player.DisplayName or player.Name
        o.Name.Visible = true
        
        -- Distance
        o.Dist.Position = Vector2.new(sp.X, sp.Y + size*0.5 + 3)
        o.Dist.Text = string.format("[%dm]", math.floor(dist / 3))
        o.Dist.Visible = true
    end
end

-- Parts function for ESP
local function Parts(char)
    if not char then return end
    local h = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    local m = char:FindFirstChildOfClass("Humanoid")
    local d = char:FindFirstChild("Head")
    if h and m and d then return h, m, d end
end

-- ================================================
--  FLIGHT SYSTEM
-- ================================================
local function StartFly()
    if flyConnection then return end
    local char = LP.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.PlatformStand = true end
    
    flyConnection = RunService:BindToRenderStep("FlySystem", Enum.RenderPriority.Last.Value, function()
        if not flyEnabled then
            StopFly()
            return
        end
        
        local speed = 50
        local camLook = Camera.CFrame.LookVector
        local camRight = Camera.CFrame.RightVector
        local camUp = Camera.CFrame.UpVector
        
        local moveDirection = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camLook
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camLook
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camRight
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camRight
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + camUp
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - camUp
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * speed
            root.Velocity = moveDirection
        else
            root.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function StopFly()
    if flyConnection then
        RunService:UnbindFromRenderStep("FlySystem")
        flyConnection = nil
    end
    local char = LP.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then root.Velocity = Vector3.new(0, 0, 0) end
    end
end

local function ToggleFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        StartFly()
        StarterGui:SetCore("SendNotification", {
            Title = "Raven Cheats",
            Text = "🦅 Flight enabled",
            Duration = 1,
        })
    else
        StopFly()
        StarterGui:SetCore("SendNotification", {
            Title = "Raven Cheats",
            Text = "🦅 Flight disabled",
            Duration = 1,
        })
    end
end

-- ================================================
--  NOCLIP
-- ================================================
local function StartNoclip()
    if noclipConnection then return end
    
    noclipConnection = RunService:BindToRenderStep("NoclipSystem", Enum.RenderPriority.Last.Value, function()
        if not noclipEnabled then
            StopNoclip()
            return
        end
        
        local char = LP.Character
        if not char then return end
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function StopNoclip()
    if noclipConnection then
        RunService:UnbindFromRenderStep("NoclipSystem")
        noclipConnection = nil
    end
    
    local char = LP.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function ToggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        StartNoclip()
        StarterGui:SetCore("SendNotification", {
            Title = "Raven Cheats",
            Text = "🦅 Noclip enabled",
            Duration = 1,
        })
    else
        StopNoclip()
        StarterGui:SetCore("SendNotification", {
            Title = "Raven Cheats",
            Text = "🦅 Noclip disabled",
            Duration = 1,
        })
    end
end

-- ================================================
--  SPEED HACK
-- ================================================
local function ToggleSpeedHack()
    speedHackEnabled = not speedHackEnabled
    StarterGui:SetCore("SendNotification", {
        Title = "Raven Cheats",
        Text = speedHackEnabled and "🦅 Speed Hack enabled" or "🦅 Speed Hack disabled",
        Duration = 1,
    })
end

-- ================================================
--  INFINITE JUMP
-- ================================================
local function ToggleInfiniteJump()
    infiniteJumpEnabled = not infiniteJumpEnabled
    StarterGui:SetCore("SendNotification", {
        Title = "Raven Cheats",
        Text = infiniteJumpEnabled and "🦅 Infinite Jump enabled" or "🦅 Infinite Jump disabled",
        Duration = 1,
    })
end

-- ================================================
--  GOD MODE
-- ================================================
local function ToggleGodMode()
    godModeEnabled = not godModeEnabled
    StarterGui:SetCore("SendNotification", {
        Title = "Raven Cheats",
        Text = godModeEnabled and "🦅 God Mode enabled" or "🦅 God Mode disabled",
        Duration = 1,
    })
end

-- ================================================
--  FULL BRIGHT
-- ================================================
local function ToggleFullBright()
    fullBrightEnabled = not fullBrightEnabled
    if fullBrightEnabled then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    else
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
    StarterGui:SetCore("SendNotification", {
        Title = "Raven Cheats",
        Text = fullBrightEnabled and "🦅 Full Bright enabled" or "🦅 Full Bright disabled",
        Duration = 1,
    })
end

-- ================================================
--  CROSSHAIR
-- ================================================
local crosshairLines = {}
local crosshairDot = nil
local crosshairAngle = 0

local function CreateCrosshair()
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = YELLOW
        line.Thickness = 1.5
        line.ZIndex = 15
        crosshairLines[i] = line
    end
    
    crosshairDot = Drawing.new("Circle")
    crosshairDot.Visible = false
    crosshairDot.Filled = true
    crosshairDot.Radius = 1.5
    crosshairDot.Color = YELLOW
    crosshairDot.ZIndex = 16
    crosshairDot.NumSides = 12
end

local function UpdateCrosshair()
    if not crosshairEnabled then
        for _, line in ipairs(crosshairLines) do
            line.Visible = false
        end
        if crosshairDot then crosshairDot.Visible = false end
        return
    end
    
    local center = AimPoint()
    local size = 12
    local gap = 4
    local col = YELLOW
    
    crosshairAngle = crosshairAngle + 0.06
    if crosshairAngle > math.pi * 2 then
        crosshairAngle = crosshairAngle - math.pi * 2
    end
    
    for i = 1, 4 do
        local line = crosshairLines[i]
        local angleOffset = (i - 1) * (math.pi / 2) + crosshairAngle
        
        local cosVal = math.cos(angleOffset)
        local sinVal = math.sin(angleOffset)
        
        local fromPos = Vector2.new(
            center.X + cosVal * gap,
            center.Y + sinVal * gap
        )
        local toPos = Vector2.new(
            center.X + cosVal * (gap + size),
            center.Y + sinVal * (gap + size)
        )
        
        line.From = fromPos
        line.To = toPos
        line.Color = col
        line.Thickness = 1.5
        line.Visible = true
    end
    
    if crosshairDot then
        crosshairDot.Position = center
        crosshairDot.Color = col
        crosshairDot.Visible = true
    end
end

local function ToggleCrosshair()
    crosshairEnabled = not crosshairEnabled
    StarterGui:SetCore("SendNotification", {
        Title = "Raven Cheats",
        Text = crosshairEnabled and "🦅 Crosshair enabled" or "🦅 Crosshair disabled",
        Duration = 1,
    })
end

-- ================================================
--  UNLOCK ALL
-- ================================================
local function UnlockAll()
    print("[Raven] 🦅 Unlock All started...")
    
    StarterGui:SetCore("SendNotification", {
        Title = "Raven Cheats",
        Text = "🦅 Unlocking all items...",
        Duration = 2,
    })
    
    task.wait(1)
    
    -- Fire unlock remotes
    local remotes = ReplicatedStorage:FindFirstChild("RemoteEvents") or ReplicatedStorage
    for _, remote in pairs(remotes:GetChildren()) do
        if remote:IsA("RemoteEvent") then
            local name = remote.Name:lower()
            if name:find("unlock") or name:find("purchase") or name:find("buy") or 
               name:find("claim") or name:find("reward") or name:find("skin") then
                pcall(function()
                    remote:FireServer()
                    remote:FireServer(LP)
                    print("[Raven] Fired remote: " .. remote.Name)
                end)
            end
        end
    end
    
    -- Modify player data
    local dataStore = LP:FindFirstChild("DataStore") or LP:FindFirstChild("PlayerData") or LP:FindFirstChild("Data")
    if dataStore then
        for _, item in pairs(dataStore:GetChildren()) do
            local name = item.Name:lower()
            if name:find("skin") or name:find("charm") or name:find("wrap") or 
               name:find("finisher") or name:find("emote") or name:find("badge") or
               name:find("cosmetic") or name:find("owned") or name:find("unlock") then
                if item:IsA("BoolValue") then
                    item.Value = true
                    print("[Raven] Unlocked: " .. item.Name)
                elseif item:IsA("NumberValue") or item:IsA("IntValue") then
                    item.Value = 999999999
                    print("[Raven] Set max: " .. item.Name)
                end
            end
        end
    end
    
    -- Click shop buttons
    local playerGui = LP.PlayerGui
    if playerGui then
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, btn in pairs(gui:GetDescendants()) do
                    if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                        local name = btn.Name:lower()
                        if name:find("buy") or name:find("purchase") or name:find("unlock") or 
                           name:find("claim") or name:find("collect") or name:find("reward") then
                            pcall(function()
                                btn:Activate()
                                btn:Click()
                                btn.MouseButton1Click:Fire()
                                print("[Raven] Clicked: " .. btn.Name)
                            end)
                        end
                    end
                end
            end
        end
    end
    
    StarterGui:SetCore("SendNotification", {
        Title = "Raven Cheats",
        Text = "🦅 Unlock All completed! Check your inventory.",
        Duration = 3,
    })
    
    print("[Raven] 🦅 Unlock All completed!")
end

-- ================================================
--  PLAYER MODS LOOP
-- ================================================
-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and LP.Character then
        local h = LP.Character:FindFirstChild("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- God Mode
RunService.Heartbeat:Connect(function()
    if godModeEnabled then
        local char = LP.Character
        if char then
            local h = char:FindFirstChild("Humanoid")
            if h then
                h.Health = h.MaxHealth
                h.BreakJointsOnDeath = false
            end
        end
    end
end)

-- Speed Hack
RunService.RenderStepped:Connect(function()
    if speedHackEnabled then
        local char = LP.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * 0.4)
            end
        end
    end
end)

-- WalkSpeed (always 16 unless modified)
RunService.Heartbeat:Connect(function()
    local char = LP.Character
    if char then
        local h = char:FindFirstChild("Humanoid")
        if h and h.WalkSpeed ~= 16 then
            h.WalkSpeed = 16
        end
    end
end)

-- ================================================
--  KEY HANDLING
-- ================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimKeyHeld = true
    end
    
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

-- ================================================
--  RENDER LOOPS
-- ================================================
RunService.RenderStepped:Connect(function()
    pcall(UpdateFOV)
    pcall(UpdateESP)
    pcall(UpdateCrosshair)
    pcall(DoAimbot)
end)

-- ================================================
--  CREATE UI
-- ================================================
local Window = Library:CreateWindow({
    Title = "🦅 Raven Cheats",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
})

ApplyTheme()
CreateCrosshair()

-- ================================================
--  TABS
-- ================================================
local Tabs = {
    Main = Window:AddTab("🎯 Main"),
    Visuals = Window:AddTab("👁️ Visuals"),
    Misc = Window:AddTab("🛠️ Misc"),
}

-- ================================================
--  MAIN TAB
-- ================================================
local MainGroup = Tabs.Main:AddLeftGroupbox("Aimbot & ESP")

MainGroup:AddToggle("Aimbot", {
    Text = "Aimbot",
    Default = false,
    Callback = function(v)
        aimbotActive = v
        print("[Raven] Aimbot: " .. tostring(v))
    end
})

MainGroup:AddToggle("ESP", {
    Text = "ESP",
    Default = false,
    Callback = function(v)
        espActive = v
        print("[Raven] ESP: " .. tostring(v))
    end
})

MainGroup:AddSlider("FOV", {
    Text = "Aim FOV",
    Default = 200,
    Min = 10,
    Max = 800,
    Rounding = 0,
    Callback = function(v)
        aimbotSettings.FOV = v
    end
})

MainGroup:AddSlider("Smoothness", {
    Text = "Smoothness",
    Default = 0.3,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(v)
        aimbotSettings.Smoothness = v
    end
})

MainGroup:AddDropdown("Aim Part", {
    Text = "Aim Part",
    Values = {"Head", "Body", "HumanoidRootPart"},
    Default = 1,
    Callback = function(v)
        aimbotSettings.Part = v
    end
})

-- ================================================
--  VISUALS TAB
-- ================================================
local VisGroup = Tabs.Visuals:AddLeftGroupbox("Visuals")

VisGroup:AddToggle("Crosshair", {
    Text = "Crosshair",
    Default = false,
    Callback = function(v)
        crosshairEnabled = v
    end
})

VisGroup:AddToggle("Full Bright", {
    Text = "Full Bright",
    Default = false,
    Callback = function(v)
        fullBrightEnabled = v
        if v then
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            Lighting.Brightness = 1
            Lighting.Ambient = Color3.fromRGB(128, 128, 128)
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end
    end
})

-- ================================================
--  MISC TAB
-- ================================================
local MiscGroup = Tabs.Misc:AddLeftGroupbox("Player Mods")

MiscGroup:AddToggle("Infinite Jump", {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(v)
        infiniteJumpEnabled = v
        print("[Raven] Infinite Jump: " .. tostring(v))
    end
})

MiscGroup:AddToggle("Fly", {
    Text = "Fly",
    Default = false,
    Callback = function(v)
        flyEnabled = v
        if v then
            StartFly()
            StarterGui:SetCore("SendNotification", {
                Title = "Raven Cheats",
                Text = "🦅 Flight enabled",
                Duration = 1,
            })
        else
            StopFly()
            StarterGui:SetCore("SendNotification", {
                Title = "Raven Cheats",
                Text = "🦅 Flight disabled",
                Duration = 1,
            })
        end
    end
})

MiscGroup:AddToggle("Noclip", {
    Text = "Noclip",
    Default = false,
    Callback = function(v)
        noclipEnabled = v
        if v then
            StartNoclip()
            StarterGui:SetCore("SendNotification", {
                Title = "Raven Cheats",
                Text = "🦅 Noclip enabled",
                Duration = 1,
            })
        else
            StopNoclip()
            StarterGui:SetCore("SendNotification", {
                Title = "Raven Cheats",
                Text = "🦅 Noclip disabled",
                Duration = 1,
            })
        end
    end
})

MiscGroup:AddToggle("God Mode", {
    Text = "God Mode",
    Default = false,
    Callback = function(v)
        godModeEnabled = v
        print("[Raven] God Mode: " .. tostring(v))
    end
})

MiscGroup:AddToggle("Speed Hack", {
    Text = "Speed Hack",
    Default = false,
    Callback = function(v)
        speedHackEnabled = v
        print("[Raven] Speed Hack: " .. tostring(v))
    end
})

MiscGroup:AddButton("🦅 Unlock All", function()
    task.spawn(UnlockAll)
end)

-- ================================================
--  WATERMARK
-- ================================================
Library:SetWatermark("🦅 Raven Cheats")

-- ================================================
--  AUTO OPEN
-- ================================================
task.wait(0.5)
Library:Open()

print("[Raven] Menu loaded! Press Right Shift to toggle.")
