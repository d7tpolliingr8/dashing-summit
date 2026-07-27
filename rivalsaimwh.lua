-- // Raven Utility Framework | Solara Compatible (Target Select + Custom Offset Millisecond TP)
-- // Rebranded from Rotex | Full Controller + KBM Support

-- ================================================
--  STUBS
-- ================================================
if not checkcaller        then checkcaller        = function() return true end end
if not getnamecallmethod then getnamecallmethod = function() return ""    end end
if not hookmetamethod    then hookmetamethod    = nil end

-- ================================================
--  SERVICES
-- ================================================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace        = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")
local StarterGui       = game:GetService("StarterGui")
local CoreGui          = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")

local Camera           = Workspace.CurrentCamera
local LP               = Players.LocalPlayer

-- ================================================
--  INPUT HANDLER (Controller + KBM)
-- ================================================
local InputHandler = {
    -- Controller button states
    GamepadConnected = false,
    Gamepad = nil,
    
    -- Key states
    Keys = {},
    MouseButtons = {},
    GamepadButtons = {},
    
    -- Bindings
    Bindings = {},
}

-- Detect gamepad
local function CheckGamepad()
    for i = 0, 7 do
        local gamepad = UserInputService:GetGamepadConnected(i)
        if gamepad then
            InputHandler.GamepadConnected = true
            InputHandler.Gamepad = gamepad
            return true
        end
    end
    InputHandler.GamepadConnected = false
    InputHandler.Gamepad = nil
    return false
end

-- Check gamepad periodically
task.spawn(function()
    while task.wait(2) do
        CheckGamepad()
    end
end)

-- Input state checking
function InputHandler.IsKeyDown(key)
    if typeof(key) == "EnumItem" then
        if key.EnumType == Enum.KeyCode then
            return UserInputService:IsKeyDown(key)
        elseif key.EnumType == Enum.UserInputType then
            return UserInputService:IsMouseButtonPressed(key)
        end
    elseif typeof(key) == "string" then
        -- Check keyboard keys
        local success, keyCode = pcall(function() return Enum.KeyCode[key] end)
        if success and keyCode then
            return UserInputService:IsKeyDown(keyCode)
        end
        
        -- Check mouse buttons
        if key == "MouseButton1" then
            return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        elseif key == "MouseButton2" then
            return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        elseif key == "MouseButton3" then
            return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton3)
        end
        
        -- Check gamepad buttons
        if InputHandler.GamepadConnected then
            local success, button = pcall(function() return Enum.KeyCode[key] end)
            if success and button then
                return UserInputService:IsGamepadButtonDown(InputHandler.Gamepad, button)
            end
        end
    end
    return false
end

function InputHandler.IsControllerConnected()
    return InputHandler.GamepadConnected
end

function InputHandler.GetGamepad()
    return InputHandler.Gamepad
end

-- Register a key binding with ContextActionService for reliable detection
function InputHandler.RegisterBinding(name, key, callback, downCallback, upCallback)
    InputHandler.Bindings[name] = {
        Key = key,
        Callback = callback,
        DownCallback = downCallback,
        UpCallback = upCallback,
        Active = false,
    }
    
    ContextActionService:BindAction(name, function(actionName, inputState, inputObject)
        if inputState == Enum.UserInputState.Begin then
            if downCallback then downCallback() end
            if callback then callback(true) end
            InputHandler.Bindings[name].Active = true
        elseif inputState == Enum.UserInputState.End then
            if upCallback then upCallback() end
            if callback then callback(false) end
            InputHandler.Bindings[name].Active = false
        end
    end, false, key)
end

function InputHandler.UnregisterBinding(name)
    ContextActionService:UnbindAction(name)
    InputHandler.Bindings[name] = nil
end

-- Get mouse/aim position (works with controller)
function InputHandler.GetAimPosition()
    if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        local vp = Camera.ViewportSize
        return Vector2.new(vp.X * 0.5, vp.Y * 0.5)
    end
    return UserInputService:GetMouseLocation()
end

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
    warn("[Raven Framework] Failed to load UI library")
    StarterGui:SetCore("SendNotification", {
        Title = "Raven Framework",
        Text = "Failed to load UI library. Please try again.",
        Duration = 5,
    })
    return
end

pcall(function()
    SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua"))()
end)
pcall(function()
    ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()
end)

-- Accent Theme (Raven Dark Purple)
local RAVEN_PURPLE  = Color3.fromRGB(120, 80, 220)
local RAVEN_PURPLE_DARK = Color3.fromRGB(70, 40, 160)
local WHITE     = Color3.fromRGB(255, 255, 255)
local BLACK     = Color3.fromRGB(0, 0, 0)
local GREEN     = Color3.fromRGB(75, 195, 95)
local RED       = Color3.fromRGB(255, 50, 50)

local function ApplyTheme()
    if not Library then return end
    pcall(function()
        Library.AccentColor     = RAVEN_PURPLE
        Library.AccentColorDark = RAVEN_PURPLE_DARK
        Library.FontColor       = Color3.fromRGB(240, 240, 240)
        Library.MainColor       = Color3.fromRGB(22, 22, 26)
        Library.BackgroundColor = Color3.fromRGB(16, 16, 20)
        Library.OutlineColor    = Color3.fromRGB(40, 40, 48)
        Library:UpdateColorsUsingRegistry()
        
        if ThemeManager then
            ThemeManager:ApplyTheme("Custom")
        end
    end)
end

-- ================================================
--  CONFIG
-- ================================================
local Cfg = {
    ESP = {
        On = false, 
        MaxDist = 1000,
        Skel = true, 
        SkelColor = WHITE,
        Names = true, 
        NameColor = WHITE,
        Dist = true, 
        DistColor = Color3.fromRGB(200, 200, 200),
        HP = true,
        Tracers = false, 
        TraceColor = WHITE,
        Chams = true, 
        ChamsColor = RAVEN_PURPLE, 
        ChamsTrans = 0.4, 
        ChamsOut = Color3.fromRGB(0, 0, 0), 
        ChamsOutT = 1, 
        Box = false,
        BoxColor = WHITE,
        CornerBox = false,
        CornerColor = WHITE,
        OffscreenArrows = false,
        OffscreenArrowColor = WHITE,
    },
    Aim = {
        On = false, 
        Part = "Head",
        FOV = 200, 
        ShowFOV = true, 
        FOVColor = WHITE,
        Smoothness = 0.3, 
        YOffset = 0, 
        Prediction = 0.5,
        WallCheck = false,
        AimKey = "MouseButton2",
        MaxDistance = 500,
        -- Controller specific
        ControllerAimAssist = false,
        ControllerAimStrength = 0.5,
        ControllerDeadzone = 0.15,
    },
    Visuals = {
        FullBright = false,
        NoFog = false,
        Crosshair = false,
        CrosshairColor = WHITE,
        CrosshairSize = 12,
        CrosshairGap = 4,
        CrosshairSpinSpeed = 2.0,
    },
    Movement = {
        Fly = false,
        FlySpeed = 50,
        Noclip = false,
        FlyKeybind = Enum.KeyCode.F,
        SpeedHack = false,
        SpeedValue = 24,
        -- Controller movement
        ControllerSensitivity = 0.3,
        InvertY = false,
    },
    TargetUtility = {
        StickyTP = false,
        SelectedTarget = "None",
        HeightOffset = 5,
    },
    Input = {
        -- Input device mode: "Auto", "Keyboard", "Controller"
        InputMode = "Auto",
    }
}

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
    return InputHandler.GetAimPosition()
end

local function Parts(char)
    if not char then return end
    local h = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    local m = char:FindFirstChildOfClass("Humanoid")
    local d = char:FindFirstChild("Head")
    if h and m and d then return h, m, d end
end

local function BBox(char)
    local hrp, _, head = Parts(char)
    if not hrp then return end
    local top = head.Position + Vector3.new(0, 0.7, 0)
    local bot = hrp.Position - Vector3.new(0, 3.2, 0)
    local ts, ton = W2S(top)
    local bs, bon = W2S(bot)
    if not ton and not bon then return end
    local ls = W2S(hrp.Position - hrp.CFrame.RightVector * 1.5)
    local rs = W2S(hrp.Position + hrp.CFrame.RightVector * 1.5)
    local x = math.min(ts.X, bs.X, ls.X, rs.X)
    local x2 = math.max(ts.X, bs.X, ls.X, rs.X)
    local h2 = bs.Y - ts.Y
    if h2 < 5 then return end
    return { X = x, Y = ts.Y, W = x2 - x, H = h2, CX = (x + x2) / 2, BS = bs, TS = ts }
end

local function isR6(char)
    return char:FindFirstChild("Torso") ~= nil and char:FindFirstChild("HumanoidRootPart") == nil
end

local SKEL_R15 = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
}

local SKEL_R6 = {
    {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
    {"Torso", "Left Leg"}, {"Torso", "Right Leg"},
}

-- ================================================
--  ESP SYSTEM
-- ================================================
local ESPs = {}
local OffscreenArrows = {}

local function CreateOffscreenArrows(player)
    if OffscreenArrows[player] then return end
    local arrowGroup = {}
    for i = 1, 3 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 1.5
        line.Color = WHITE
        line.ZIndex = 8
        arrowGroup[i] = line
    end
    OffscreenArrows[player] = arrowGroup
end

local function DestroyOffscreenArrows(player)
    local arrowGroup = OffscreenArrows[player]
    if arrowGroup then
        for _, line in ipairs(arrowGroup) do
            pcall(function() line:Remove() end)
        end
        OffscreenArrows[player] = nil
    end
end

local function CreateESPObjects(player)
    if ESPs[player] then return end
    local o = {}
    
    o.S = {}
    o.SO = {}
    for i = 1, 14 do
        o.SO[i] = L{ Color = BLACK, Thickness = 3, ZIndex = 3 }
        o.S[i] = L{ Color = WHITE, Thickness = 1.5, ZIndex = 4 }
    end
    
    o.HB = {
        L{ Color = Color3.fromRGB(15,15,15), Thickness = 2, ZIndex = 5 },
        L{ Color = GREEN, Thickness = 2, ZIndex = 6 },
    }
    
    o.Name = T{ Color = WHITE, Size = 13, ZIndex = 6 }
    o.Dist = T{ Color = Color3.fromRGB(200,200,200), Size = 11, ZIndex = 6 }
    
    o.Tr = L{ Color = WHITE, ZIndex = 3 }
    o.TrO = L{ Color = BLACK, Thickness = 2.5, ZIndex = 2 }
    
    o.Box = {}
    for i = 1, 4 do
        o.Box[i] = L{ Color = WHITE, Thickness = 1.5, ZIndex = 5 }
    end
    o.BoxO = {}
    for i = 1, 4 do
        o.BoxO[i] = L{ Color = BLACK, Thickness = 3, ZIndex = 4 }
    end
    
    o.Corner = {}
    for i = 1, 8 do
        o.Corner[i] = L{ Color = WHITE, Thickness = 2, ZIndex = 5 }
    end
    
    o.Chams = nil
    
    ESPs[player] = o
    CreateOffscreenArrows(player)
end

local function DestroyESP(player)
    local o = ESPs[player]
    if not o then return end
    for _, l in ipairs(o.SO or {}) do pcall(function() l:Remove() end) end
    for _, l in ipairs(o.S) do pcall(function() l:Remove() end) end
    for _, l in ipairs(o.HB) do pcall(function() l:Remove() end) end
    for _, l in ipairs(o.Box or {}) do pcall(function() l:Remove() end) end
    for _, l in ipairs(o.BoxO or {}) do pcall(function() l:Remove() end) end
    for _, l in ipairs(o.Corner or {}) do pcall(function() l:Remove() end) end
    pcall(function() o.Name:Remove() end)
    pcall(function() o.Dist:Remove() end)
    pcall(function() o.Tr:Remove() end)
    pcall(function() o.TrO:Remove() end)
    if o.Chams then pcall(function() o.Chams:Destroy() end) end
    ESPs[player] = nil
    DestroyOffscreenArrows(player)
end

local function HideESP(o)
    for _, l in ipairs(o.SO or {}) do l.Visible = false end
    for _, l in ipairs(o.S) do l.Visible = false end
    for _, l in ipairs(o.HB) do l.Visible = false end
    for _, l in ipairs(o.Box or {}) do l.Visible = false end
    for _, l in ipairs(o.BoxO or {}) do l.Visible = false end
    for _, l in ipairs(o.Corner or {}) do l.Visible = false end
    o.Name.Visible = false
    o.Dist.Visible = false
    o.Tr.Visible = false
    if o.TrO then o.TrO.Visible = false end
    if o.Chams then o.Chams.Enabled = false end
end

local function SetOutlinedLine(front, back, from, to, color, thickness, show)
    if not show then
        front.Visible = false
        back.Visible = false
        return
    end
    back.From = from
    back.To = to
    back.Visible = true
    front.From = from
    front.To = to
    front.Color = color
    front.Thickness = thickness
    front.Visible = true
end

local function UpdateOffscreenArrows()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end
        local arrowGroup = OffscreenArrows[player]
        if not arrowGroup then continue end
        
        local char = player.Character
        if not char then 
            for _, l in ipairs(arrowGroup) do l.Visible = false end
            continue 
        end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then 
            for _, l in ipairs(arrowGroup) do l.Visible = false end
            continue 
        end
        
        if not Cfg.ESP.On or not Cfg.ESP.OffscreenArrows then
            for _, l in ipairs(arrowGroup) do l.Visible = false end
            continue
        end
        
        local _, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if onScreen then
            for _, l in ipairs(arrowGroup) do l.Visible = false end
            continue
        end
        
        local vp = Camera.ViewportSize
        local center = Vector2.new(vp.X / 2, vp.Y / 2)
        local camCFrame = Camera.CFrame
        local playerPos = hrp.Position
        
        local relPos = camCFrame:PointToObjectSpace(playerPos)
        local angle = math.atan2(relPos.X, relPos.Z)
        local radius = math.clamp(vp.X * 0.35, 100, 350)
        
        local arrowPos = Vector2.new(
            center.X + math.sin(angle) * radius,
            center.Y - math.cos(angle) * (radius * 0.75)
        )
        
        local size = 14
        local rot = angle
        
        local p1 = arrowPos + Vector2.new(math.sin(rot), -math.cos(rot)) * size
        local p2 = arrowPos + Vector2.new(math.sin(rot + math.rad(140)), -math.cos(rot + math.rad(140))) * (size * 0.7)
        local p3 = arrowPos + Vector2.new(math.sin(rot - math.rad(140)), -math.cos(rot - math.rad(140))) * (size * 0.7)
        
        arrowGroup[1].From = p1
        arrowGroup[1].To = p2
        arrowGroup[2].From = p2
        arrowGroup[2].To = p3
        arrowGroup[3].From = p3
        arrowGroup[3].To = p1
        
        local col = Cfg.ESP.OffscreenArrowColor or WHITE
        for _, l in ipairs(arrowGroup) do
            l.Color = col
            l.Visible = true
        end
    end
end

local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end
        CreateESPObjects(player)
        local o = ESPs[player]
        local char = player.Character
        if not char then HideESP(o); continue end
        
        local hrp, hum = Parts(char)
        if not hrp or not hum then HideESP(o); continue end
        
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local dist = myRoot and (hrp.Position - myRoot.Position).Magnitude or 0
        if dist > Cfg.ESP.MaxDist then HideESP(o); continue end
        
        local bb = BBox(char)
        if not bb then HideESP(o); continue end
        if not Cfg.ESP.On then HideESP(o); continue end
        
        local x, y, w, h = bb.X, bb.Y, bb.W, bb.H
        
        local skel = isR6(char) and SKEL_R6 or SKEL_R15
        for i, bones in ipairs(skel) do
            local p1 = char:FindFirstChild(bones[1])
            local p2 = char:FindFirstChild(bones[2])
            if Cfg.ESP.Skel and p1 and p2 then
                local s1, on1 = W2S(p1.Position)
                local s2, on2 = W2S(p2.Position)
                if on1 or on2 then
                    o.S[i].From = s1
                    o.S[i].To = s2
                    o.S[i].Color = Cfg.ESP.SkelColor
                    o.S[i].Visible = true
                    o.SO[i].From = s1
                    o.SO[i].To = s2
                    o.SO[i].Visible = true
                else
                    o.S[i].Visible = false
                    o.SO[i].Visible = false
                end
            else
                o.S[i].Visible = false
                o.SO[i].Visible = false
            end
        end
        
        if Cfg.ESP.Names then
            o.Name.Position = Vector2.new(bb.CX, bb.Y - 16)
            o.Name.Text = player.DisplayName or player.Name
            o.Name.Color = Cfg.ESP.NameColor
            o.Name.Visible = true
        else
            o.Name.Visible = false
        end
        
        if Cfg.ESP.Dist then
            o.Dist.Position = Vector2.new(bb.CX, bb.Y + bb.H + 3)
            o.Dist.Text = string.format("[%dm]", math.floor(dist))
            o.Dist.Color = Cfg.ESP.DistColor
            o.Dist.Visible = true
        else
            o.Dist.Visible = false
        end
        
        if Cfg.ESP.HP then
            local ratio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local bx = bb.X - 5
            local bh = math.max(bb.H, 1)
            local fh = math.max(bh * ratio, 0)
            o.HB[1].From = Vector2.new(bx, bb.Y)
            o.HB[1].To = Vector2.new(bx, bb.Y + bh)
            o.HB[1].Visible = true
            o.HB[2].From = Vector2.new(bx, bb.Y + bh - fh)
            o.HB[2].To = Vector2.new(bx, bb.Y + bh)
            o.HB[2].Color = ratio > 0.5 and GREEN or RED
            o.HB[2].Visible = fh > 0
        else
            for _, l in ipairs(o.HB) do l.Visible = false end
        end
        
        if Cfg.ESP.Box then
            SetOutlinedLine(o.Box[1], o.BoxO[1], Vector2.new(x, y), Vector2.new(x + w, y), Cfg.ESP.BoxColor, 1.5, true)
            SetOutlinedLine(o.Box[2], o.BoxO[2], Vector2.new(x, y + h), Vector2.new(x + w, y + h), Cfg.ESP.BoxColor, 1.5, true)
            SetOutlinedLine(o.Box[3], o.BoxO[3], Vector2.new(x, y), Vector2.new(x, y), Cfg.ESP.BoxColor, 1.5, true)
            SetOutlinedLine(o.Box[4], o.BoxO[4], Vector2.new(x + w, y), Vector2.new(x + w, y + h), Cfg.ESP.BoxColor, 1.5, true)
        else
            for i = 1, 4 do
                o.Box[i].Visible = false
                o.BoxO[i].Visible = false
            end
        end
        
        if Cfg.ESP.CornerBox then
            local len = math.min(w, h) * 0.25
            o.Corner[1].From = Vector2.new(x, y + len)
            o.Corner[1].To = Vector2.new(x, y)
            o.Corner[1].Visible = true
            o.Corner[2].From = Vector2.new(x, y)
            o.Corner[2].To = Vector2.new(x + len, y)
            o.Corner[2].Visible = true
            o.Corner[3].From = Vector2.new(x + w - len, y)
            o.Corner[3].To = Vector2.new(x + w, y)
            o.Corner[3].Visible = true
            o.Corner[4].From = Vector2.new(x + w, y)
            o.Corner[4].To = Vector2.new(x + w, y + len)
            o.Corner[4].Visible = true
            o.Corner[5].From = Vector2.new(x, y + h - len)
            o.Corner[5].To = Vector2.new(x, y + h)
            o.Corner[5].Visible = true
            o.Corner[6].From = Vector2.new(x, y + h)
            o.Corner[6].To = Vector2.new(x + len, y + h)
            o.Corner[6].Visible = true
            o.Corner[7].From = Vector2.new(x + w - len, y + h)
            o.Corner[7].To = Vector2.new(x + w, y + h)
            o.Corner[7].Visible = true
            o.Corner[8].From = Vector2.new(x + w, y + h - len)
            o.Corner[8].To = Vector2.new(x + w, y + h)
            o.Corner[8].Visible = true
            for i = 1, 8 do
                o.Corner[i].Color = Cfg.ESP.CornerColor
            end
        else
            for i = 1, 8 do
                o.Corner[i].Visible = false
            end
        end
        
        if Cfg.ESP.Tracers then
            local vp = Camera.ViewportSize
            local from = Vector2.new(vp.X / 2, vp.Y)
            o.Tr.From = from
            o.Tr.To = bb.BS
            o.Tr.Color = Cfg.ESP.TraceColor
            o.Tr.Visible = true
            o.TrO.From = from
            o.TrO.To = bb.BS
            o.TrO.Visible = true
        else
            o.Tr.Visible = false
            o.TrO.Visible = false
        end
        
        if Cfg.ESP.Chams then
            if not o.Chams or o.Chams.Parent ~= char then
                if o.Chams then o.Chams:Destroy() end
                local h = Instance.new("Highlight")
                h.Adornee = char
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Parent = char
                o.Chams = h
            end
            o.Chams.Enabled = true
            o.Chams.FillColor = Cfg.ESP.ChamsColor
            o.Chams.FillTransparency = Cfg.ESP.ChamsTrans
            o.Chams.OutlineColor = Cfg.ESP.ChamsOut
            o.Chams.OutlineTransparency = 1
        elseif o.Chams then
            o.Chams.Enabled = false
        end
    end
end

-- ================================================
--  TARGET LOCK (Enhanced for Controller)
-- ================================================
local FOVCIRC = C{ Color = WHITE, ZIndex = 10 }
local CurrentTarget = nil

local function GetAimPart(char)
    if Cfg.Aim.Part == "Head" then
        return char:FindFirstChild("Head")
    elseif Cfg.Aim.Part == "HumanoidRootPart" then
        return char:FindFirstChild("HumanoidRootPart")
    elseif Cfg.Aim.Part == "UpperTorso" then
        return char:FindFirstChild("UpperTorso")
    end
    return char:FindFirstChild("Torso") or char:FindFirstChild("Head")
end

local function GetTargetPosition(char, part, predict)
    local pos = part.Position + Vector3.new(0, Cfg.Aim.YOffset, 0)
    if predict and Cfg.Aim.Prediction > 0 then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local vel = hrp.AssemblyLinearVelocity
            local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
            local time = math.min(dist / 500, 1) * Cfg.Aim.Prediction
            pos = pos + vel * time
        end
    end
    return pos
end

local function IsVisible(targetPos)
    if not Cfg.Aim.WallCheck then return true end

    local origin = Camera.CFrame.Position
    local direction = (targetPos - origin).Unit
    local distance = (targetPos - origin).Magnitude

    local ignoreList = {LP.Character}

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = ignoreList
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local rayResult = workspace:Raycast(origin, direction * distance, raycastParams)

    if rayResult then
        return false
    end
    return true
end

local function IsValidTarget(player)
    if not player or player == LP then return false end
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local part = GetAimPart(char)
    if not part then return false end

    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if myRoot then
        local dist = (part.Position - myRoot.Position).Magnitude
        if dist > Cfg.Aim.MaxDistance then return false end
    end

    return true, char, part
end

local function GetClosestTarget()
    local center = AimPoint()
    local best, bestDist = nil, Cfg.Aim.FOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end
        local valid, char, part = IsValidTarget(player)
        if not valid then continue end

        local pos = GetTargetPosition(char, part, false)

        if not IsVisible(pos) then continue end

        local screen, onScreen = W2S(pos)
        if not onScreen then continue end

        local dist = (screen - center).Magnitude
        if dist < bestDist then
            bestDist = dist
            best = { Player = player, Char = char, Part = part, Screen = screen, Pos = pos }
        end
    end
    return best
end

local function UpdateFOV()
    if Cfg.Aim.ShowFOV and Cfg.Aim.On then
        FOVCIRC.Visible = true
        FOVCIRC.Position = AimPoint()
        FOVCIRC.Radius = Cfg.Aim.FOV
        FOVCIRC.Color = Cfg.Aim.FOVColor
    else
        FOVCIRC.Visible = false
    end
end

-- Improved key check with controller support
local function IsAimKeyPressed()
    local key = Cfg.Aim.AimKey
    
    -- If in controller mode, check gamepad triggers/sticks
    if InputHandler.IsControllerConnected() then
        local gamepad = InputHandler.GetGamepad()
        if gamepad then
            -- Check for common controller aim buttons
            if UserInputService:IsGamepadButtonDown(gamepad, Enum.KeyCode.ButtonR2) then -- Right Trigger
                return true
            end
            if UserInputService:IsGamepadButtonDown(gamepad, Enum.KeyCode.ButtonL2) then -- Left Trigger
                return true
            end
            if UserInputService:IsGamepadButtonDown(gamepad, Enum.KeyCode.ButtonR1) then -- Right Bumper
                return true
            end
        end
    end
    
    -- Standard key check
    if typeof(key) == "EnumItem" then
        if key.EnumType == Enum.UserInputType then
            return UserInputService:IsMouseButtonPressed(key)
        elseif key.EnumType == Enum.KeyCode then
            return UserInputService:IsKeyDown(key)
        end
    elseif typeof(key) == "string" then
        if key == "MouseButton2" then
            return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        elseif key == "MouseButton1" then
            return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        elseif key == "ControllerR2" then
            if InputHandler.IsControllerConnected() then
                return UserInputService:IsGamepadButtonDown(InputHandler.GetGamepad(), Enum.KeyCode.ButtonR2)
            end
        elseif key == "ControllerL2" then
            if InputHandler.IsControllerConnected() then
                return UserInputService:IsGamepadButtonDown(InputHandler.GetGamepad(), Enum.KeyCode.ButtonL2)
            end
        else
            local success, keyCode = pcall(function() return Enum.KeyCode[key] end)
            if success and keyCode then
                return UserInputService:IsKeyDown(keyCode)
            end
        end
    end
    return false
end

local function DoAim()
    if not Cfg.Aim.On then
        CurrentTarget = nil
        return
    end

    local holding = IsAimKeyPressed()
    if not holding then
        CurrentTarget = nil
        return
    end

    local target = GetClosestTarget()
    if not target then
        CurrentTarget = nil
        return
    end

    CurrentTarget = target

    local aimPos = GetTargetPosition(target.Char, target.Part, true)
    local currentCF = Camera.CFrame
    local targetCF = CFrame.lookAt(currentCF.Position, aimPos)

    -- Controller aim assist with deadzone and strength
    if InputHandler.IsControllerConnected() and Cfg.Aim.ControllerAimAssist then
        local smooth = 1 - (Cfg.Aim.Smoothness * Cfg.Aim.ControllerAimStrength)
        smooth = math.clamp(smooth, 0.01, 1)
        Camera.CFrame = currentCF:Lerp(targetCF, smooth)
    elseif Cfg.Aim.Smoothness <= 0 then
        Camera.CFrame = targetCF
    else
        local smooth = math.clamp(1 - Cfg.Aim.Smoothness, 0.01, 1)
        Camera.CFrame = currentCF:Lerp(targetCF, smooth)
    end
end

-- ================================================
--  TARGET UTILITIES (SPEED & TELEPORT MODS)
-- ================================================
local function GetPlayerNames()
    local names = {"None"}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            table.insert(names, player.Name)
        end
    end
    return names
end

RunService.RenderStepped:Connect(function()
    if Cfg.Movement.SpeedHack then
        local char = LP.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Cfg.Movement.SpeedValue / 50))
            end
        end
    end

    if Cfg.TargetUtility.StickyTP and Cfg.TargetUtility.SelectedTarget ~= "None" then
        local targetPlayer = Players:FindFirstChild(Cfg.TargetUtility.SelectedTarget)
        if targetPlayer and targetPlayer.Character then
            local enemyRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local myChar = LP.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if enemyRoot and myRoot then
                local offsetPos = enemyRoot.CFrame + Vector3.new(0, Cfg.TargetUtility.HeightOffset, 0)
                myRoot.CFrame = offsetPos
                myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if Cfg.TargetUtility.StickyTP and Cfg.TargetUtility.SelectedTarget ~= "None" then
        local targetPlayer = Players:FindFirstChild(Cfg.TargetUtility.SelectedTarget)
        if targetPlayer and targetPlayer.Character then
            local enemyRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local myChar = LP.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if enemyRoot and myRoot then
                myRoot.CFrame = enemyRoot.CFrame + Vector3.new(0, Cfg.TargetUtility.HeightOffset, 0)
            end
        end
    end
end)

-- ================================================
--  CROSSHAIR SYSTEM
-- ================================================
local CrosshairLines = {}
local CenterDot = nil
local CrosshairAngle = 0

local function CreateCrosshair()
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Cfg.Visuals.CrosshairColor
        line.Thickness = 1.5
        line.ZIndex = 15
        CrosshairLines[i] = line
    end
    
    CenterDot = Drawing.new("Circle")
    CenterDot.Visible = false
    CenterDot.Filled = true
    CenterDot.Radius = 1.5
    CenterDot.Color = Cfg.Visuals.CrosshairColor
    CenterDot.ZIndex = 16
    CenterDot.NumSides = 12
end

local function UpdateCrosshair()
    if not Cfg.Visuals.Crosshair then
        for _, line in ipairs(CrosshairLines) do
            line.Visible = false
        end
        if CenterDot then CenterDot.Visible = false end
        return
    end
    
    local center = AimPoint()
    local size = Cfg.Visuals.CrosshairSize
    local gap = Cfg.Visuals.CrosshairGap
    local col = Cfg.Visuals.CrosshairColor
    
    CrosshairAngle = CrosshairAngle + (0.03 * Cfg.Visuals.CrosshairSpinSpeed)
    if CrosshairAngle > math.pi * 2 then
        CrosshairAngle = CrosshairAngle - math.pi * 2
    end
    
    for i = 1, 4 do
        local line = CrosshairLines[i]
        local angleOffset = (i - 1) * (math.pi / 2) + CrosshairAngle
        
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
    
    if CenterDot then
        CenterDot.Position = center
        CenterDot.Color = col
        CenterDot.Visible = true
    end
end

-- ================================================
--  FLIGHT SYSTEM (Fixed Keybind Engine + Controller)
-- ================================================
local flyConnection = nil
local flyEnabled = false

local function StartFly()
    if flyConnection then return end
    local char = LP.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
    end
    
    flyConnection = RunService:BindToRenderStep("FlySystem", Enum.RenderPriority.Last.Value, function()
        if not flyEnabled then
            StopFly()
            return
        end
        
        local speed = Cfg.Movement.FlySpeed
        local camLook = Camera.CFrame.LookVector
        local camRight = Camera.CFrame.RightVector
        local camUp = Camera.CFrame.UpVector
        
        local moveDirection = Vector3.new()
        
        -- Check keyboard input
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
        
        -- Check controller input
        if InputHandler.IsControllerConnected() then
            local gamepad = InputHandler.GetGamepad()
            if gamepad then
                local moveX = UserInputService:GetGamepadState(gamepad, Enum.KeyCode.Thumbstick1)
                local moveY = UserInputService:GetGamepadState(gamepad, Enum.KeyCode.Thumbstick2)
                
                -- Left stick for movement
                if math.abs(moveX) > 0.15 then
                    moveDirection = moveDirection + camRight * moveX
                end
                if math.abs(moveY) > 0.15 then
                    moveDirection = moveDirection - (Cfg.Movement.InvertY and camLook or -camLook) * moveY
                end
            end
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
        if humanoid then
            humanoid.PlatformStand = false
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

local function ToggleFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        StartFly()
        StarterGui:SetCore("SendNotification", {
            Title = "Raven Flight",
            Text = "Flight enabled",
            Duration = 1,
        })
    else
        StopFly()
        StarterGui:SetCore("SendNotification", {
            Title = "Raven Flight",
            Text = "Flight disabled",
            Duration = 1,
        })
    end
    Cfg.Movement.Fly = flyEnabled
    if Toggles and Toggles.FlyToggle then
        pcall(function() Toggles.FlyToggle:SetValue(flyEnabled) end)
    end
end

-- Fixed Fly Input Listener supporting KeyCodes, Mouse, and Controller
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local keybind = Cfg.Movement.FlyKeybind
    if not keybind then return end
    
    if typeof(keybind) == "EnumItem" then
        if input.KeyCode == keybind or input.UserInputType == keybind then
            ToggleFly()
        end
    elseif typeof(keybind) == "string" then
        if keybind == "MouseButton2" and input.UserInputType == Enum.UserInputType.MouseButton2 then
            ToggleFly()
        elseif keybind == "MouseButton1" and input.UserInputType == Enum.UserInputType.MouseButton1 then
            ToggleFly()
        else
            -- Check if it's a controller button
            if InputHandler.IsControllerConnected() then
                local success, button = pcall(function() return Enum.KeyCode[keybind] end)
                if success and button and input.KeyCode == button then
                    ToggleFly()
                    return
                end
            end
            -- Check keyboard
            pcall(function()
                local kc = Enum.KeyCode[keybind]
                if kc and input.KeyCode == kc then
                    ToggleFly()
                end
            end)
        end
    end
end)

-- ContextActionService binding for reliable controller support
InputHandler.RegisterBinding("FlyToggle", Enum.KeyCode.ButtonF, nil, ToggleFly, nil)

-- ================================================
--  NOCLIP SYSTEM
-- ================================================
local noclipConnection = nil

local function StartNoclip()
    if noclipConnection then return end
    
    noclipConnection = RunService:BindToRenderStep("NoclipSystem", Enum.RenderPriority.Last.Value, function()
        if not Cfg.Movement.Noclip then
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

-- ================================================
--  VISUALS
-- ================================================
local function UpdateVisuals()
    if Cfg.Visuals.FullBright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    else
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
    
    if Cfg.Visuals.NoFog then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
    else
        Lighting.FogEnd = 1000
        Lighting.FogStart = 0
    end
end

-- ================================================
--  PLAYER MANAGEMENT
-- ================================================
local function OnPlayerAdded(player)
    CreateESPObjects(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        local o = ESPs[player]
        if o and o.Chams then
            o.Chams:Destroy()
            o.Chams = nil
        end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LP then OnPlayerAdded(player) end
end
Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(DestroyESP)

-- ================================================
--  RENDER LOOPS
-- ================================================
RunService.RenderStepped:Connect(function()
    Camera = Workspace.CurrentCamera
    pcall(UpdateFOV)
    pcall(UpdateESP)
    pcall(UpdateOffscreenArrows)
    pcall(UpdateVisuals)
    pcall(UpdateCrosshair)
end)

RunService:BindToRenderStep("RavenAim", Enum.RenderPriority.Last.Value, function()
    Camera = Workspace.CurrentCamera
    pcall(DoAim)
end)

-- ================================================
--  USER INTERFACE
-- ================================================
local Window = Library:CreateWindow({
    Title = "Raven Framework",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
})

-- Raven Branding Logo Component (Bottom Left)
pcall(function()
    if Window and Window.Holder then
        local logoContainer = Instance.new("Frame")
        logoContainer.Name = "RavenLogoContainer"
        logoContainer.BackgroundTransparency = 1
        logoContainer.AnchorPoint = Vector2.new(0, 1)
        logoContainer.Position = UDim2.new(0, 12, 1, -12)
        logoContainer.Size = UDim2.new(0, 155, 0, 46)
        logoContainer.ZIndex = 5
        
        local glassBg = Instance.new("Frame")
        glassBg.Name = "GlassBackground"
        glassBg.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        glassBg.BackgroundTransparency = 0.35
        glassBg.BorderSizePixel = 0
        glassBg.Size = UDim2.new(1, 0, 1, 0)
        glassBg.ZIndex = 5
        glassBg.Parent = logoContainer
        
        local cornerGlass = Instance.new("UICorner")
        cornerGlass.CornerRadius = UDim.new(0, 8)
        cornerGlass.Parent = glassBg
        
        local strokeGlass = Instance.new("UIStroke")
        strokeGlass.Color = RAVEN_PURPLE
        strokeGlass.Transparency = 0.4
        strokeGlass.Thickness = 1.2
        strokeGlass.Parent = glassBg
        
        local iconFrame = Instance.new("Frame")
        iconFrame.Name = "IconFrame"
        iconFrame.BackgroundTransparency = 1
        iconFrame.Position = UDim2.new(0, 5, 0.5, -18)
        iconFrame.Size = UDim2.new(0, 36, 0, 36)
        iconFrame.ZIndex = 6
        iconFrame.Parent = logoContainer
        
        local logoLabel = Instance.new("ImageLabel")
        logoLabel.Name = "RavenLogoImage"
        logoLabel.BackgroundTransparency = 1
        logoLabel.Size = UDim2.new(1, 0, 1, 0)
        logoLabel.Image = "rbxassetid://73575987788416" -- Replace with Raven logo if available
        logoLabel.ScaleType = Enum.ScaleType.Fit
        logoLabel.ZIndex = 6
        logoLabel.Parent = iconFrame
        
        local textHolder = Instance.new("Frame")
        textHolder.Name = "TextHolder"
        textHolder.BackgroundTransparency = 1
        textHolder.Position = UDim2.new(0, 46, 0, 4)
        textHolder.Size = UDim2.new(1, -50, 1, -8)
        textHolder.ZIndex = 6
        textHolder.Parent = logoContainer
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "BrandTitle"
        titleLabel.BackgroundTransparency = 1
        titleLabel.Size = UDim2.new(1, 0, 0, 18)
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.Text = "RAVEN"
        titleLabel.TextColor3 = WHITE
        titleLabel.TextSize = 13
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.ZIndex = 6
        titleLabel.Parent = textHolder
        
        local subLabel = Instance.new("TextLabel")
        subLabel.Name = "BrandSubtitle"
        subLabel.BackgroundTransparency = 1
        subLabel.Position = UDim2.new(0, 0, 0, 17)
        subLabel.Size = UDim2.new(1, 0, 0, 16)
        subLabel.Font = Enum.Font.GothamMedium
        subLabel.Text = "UTILITY SUITE"
        subLabel.TextColor3 = RAVEN_PURPLE
        subLabel.TextSize = 9
        subLabel.TextXAlignment = Enum.TextXAlignment.Left
        subLabel.ZIndex = 6
        subLabel.Parent = textHolder
        
        logoContainer.Parent = Window.Holder
    end
end)

local Tabs = {
    ESP = Window:AddTab("ESP"),
    Aim = Window:AddTab("Aim"),
    Util = Window:AddTab("Utils"),
    Move = Window:AddTab("Move"),
    Vis = Window:AddTab("Visuals"),
    Settings = Window:AddTab("Settings"),
}

ApplyTheme()
CreateCrosshair()

task.spawn(function()
    task.wait(0.2)
    ApplyTheme()
end)

-- =============================================
-- ESP TAB
-- =============================================
local ESPGroup = Tabs.ESP:AddLeftGroupbox("ESP Controls")

ESPGroup:AddToggle("ESPOn", { Text = "Enable", Default = Cfg.ESP.On })
Toggles.ESPOn:OnChanged(function(v) Cfg.ESP.On = v end)

ESPGroup:AddSlider("ESPDist", { Text = "Max Dist", Default = Cfg.ESP.MaxDist, Min = 50, Max = 5000, Rounding = 0 })
Options.ESPDist:OnChanged(function(v) Cfg.ESP.MaxDist = v end)

ESPGroup:AddToggle("ESPSkel", { Text = "Skeleton", Default = Cfg.ESP.Skel })
Toggles.ESPSkel:OnChanged(function(v) Cfg.ESP.Skel = v end)
Toggles.ESPSkel:AddColorPicker("ESPSkelCol", { Default = Cfg.ESP.SkelColor, Title = "Color" })
Options.ESPSkelCol:OnChanged(function(v) Cfg.ESP.SkelColor = v end)

ESPGroup:AddToggle("ESPChams", { Text = "Chams", Default = Cfg.ESP.Chams })
Toggles.ESPChams:OnChanged(function(v) Cfg.ESP.Chams = v end)
Toggles.ESPChams:AddColorPicker("ESPChamsCol", { Default = Cfg.ESP.ChamsColor, Title = "Color" })
Options.ESPChamsCol:OnChanged(function(v) Cfg.ESP.ChamsColor = v end)

ESPGroup:AddToggle("ESPOffscreen", { Text = "Arrows", Default = Cfg.ESP.OffscreenArrows })
Toggles.ESPOffscreen:OnChanged(function(v) Cfg.ESP.OffscreenArrows = v end)
Toggles.ESPOffscreen:AddColorPicker("ESPOffscreenCol", { Default = Cfg.ESP.OffscreenArrowColor, Title = "Color" })
Options.ESPOffscreenCol:OnChanged(function(v) Cfg.ESP.OffscreenArrowColor = v end)

-- =============================================
-- AIM TAB
-- =============================================
local AimGroup = Tabs.Aim:AddLeftGroupbox("Aimbot Controls")

AimGroup:AddToggle("AimOn", { Text = "Enable", Default = Cfg.Aim.On })
Toggles.AimOn:OnChanged(function(v) Cfg.Aim.On = v end)
Toggles.AimOn:AddKeyPicker("AimKeyPicker", { Default = "MouseButton2", Text = "Aimbot Key", NoUI = false })
Options.AimKeyPicker:OnChanged(function(v)
    Cfg.Aim.AimKey = Options.AimKeyPicker.Value
end)

AimGroup:AddToggle("AimWall", { Text = "Wall Check", Default = Cfg.Aim.WallCheck })
Toggles.AimWall:OnChanged(function(v) Cfg.Aim.WallCheck = v end)

AimGroup:AddDropdown("AimPart", { Values = {"Head", "HumanoidRootPart", "UpperTorso"}, Default = 1, Text = "Hitbox" })
Options.AimPart:OnChanged(function(v) Cfg.Aim.Part = v end)

AimGroup:AddToggle("ShowFOV", { Text = "Show FOV", Default = Cfg.Aim.ShowFOV })
Toggles.ShowFOV:OnChanged(function(v) Cfg.Aim.ShowFOV = v end)
Toggles.ShowFOV:AddColorPicker("FOVCol", { Default = Cfg.Aim.FOVColor, Title = "Color" })
Options.FOVCol:OnChanged(function(v) Cfg.Aim.FOVColor = v end)

AimGroup:AddSlider("AimFOV", { Text = "FOV Radius", Default = Cfg.Aim.FOV, Min = 10, Max = 800, Rounding = 0 })
Options.AimFOV:OnChanged(function(v) Cfg.Aim.FOV = v end)

AimGroup:AddSlider("AimSmooth", { Text = "Smooth", Default = Cfg.Aim.Smoothness, Min = 0, Max = 1, Rounding = 2 })
Options.AimSmooth:OnChanged(function(v) Cfg.Aim.Smoothness = v end)

AimGroup:AddSlider("AimPred", { Text = "Prediction", Default = Cfg.Aim.Prediction, Min = 0, Max = 2, Rounding = 2 })
Options.AimPred:OnChanged(function(v) Cfg.Aim.Prediction = v end)

-- Controller Aim Settings
local ControllerAimGroup = Tabs.Aim:AddRightGroupbox("Controller Aim Assist")

ControllerAimGroup:AddToggle("ControllerAimToggle", { Text = "Enable Aim Assist", Default = Cfg.Aim.ControllerAimAssist })
Toggles.ControllerAimToggle:OnChanged(function(v) Cfg.Aim.ControllerAimAssist = v end)

ControllerAimGroup:AddSlider("ControllerAimStr", { Text = "Strength", Default = Cfg.Aim.ControllerAimStrength, Min = 0.1, Max = 1, Rounding = 2 })
Options.ControllerAimStr:OnChanged(function(v) Cfg.Aim.ControllerAimStrength = v end)

ControllerAimGroup:AddSlider("ControllerDeadzone", { Text = "Deadzone", Default = Cfg.Aim.ControllerDeadzone, Min = 0.05, Max = 0.4, Rounding = 2 })
Options.ControllerDeadzone:OnChanged(function(v) Cfg.Aim.ControllerDeadzone = v end)

-- =============================================
-- UTILS TAB
-- =============================================
local UtilGroup = Tabs.Util:AddLeftGroupbox("Target Teleportation")

UtilGroup:AddDropdown("TargetDropdown", { Values = GetPlayerNames(), Default = 1, Text = "Target", Multi = false })
Options.TargetDropdown:OnChanged(function(v) Cfg.TargetUtility.SelectedTarget = v end)

UtilGroup:AddButton("Refresh List", function()
    Options.TargetDropdown:SetValues(GetPlayerNames())
    StarterGui:SetCore("SendNotification", {
        Title = "Raven",
        Text = "Player list updated.",
        Duration = 2,
    })
end)

UtilGroup:AddSlider("HeightOffsetSlider", { Text = "Height Offset", Default = Cfg.TargetUtility.HeightOffset, Min = 0, Max = 20, Rounding = 1 })
Options.HeightOffsetSlider:OnChanged(function(v) Cfg.TargetUtility.HeightOffset = v end)

UtilGroup:AddToggle("StickyTP", { Text = "Enable TP", Default = Cfg.TargetUtility.StickyTP })
Toggles.StickyTP:OnChanged(function(v) Cfg.TargetUtility.StickyTP = v end)

-- =============================================
-- MOVE TAB
-- =============================================
local MoveGroup = Tabs.Move:AddLeftGroupbox("Locomotion Controls")

MoveGroup:AddToggle("FlyToggle", { Text = "Flight", Default = Cfg.Movement.Fly })
Toggles.FlyToggle:OnChanged(function(v)
    if flyEnabled ~= v then
        ToggleFly()
    end
end)
Toggles.FlyToggle:AddKeyPicker("FlyKeybindPicker", { Default = "F", Text = "Flight Hotkey", NoUI = false })
Options.FlyKeybindPicker:OnChanged(function(v)
    Cfg.Movement.FlyKeybind = Options.FlyKeybindPicker.Value
end)

MoveGroup:AddSlider("FlySpeed", { Text = "Flight Speed", Default = Cfg.Movement.FlySpeed, Min = 10, Max = 300, Rounding = 0 })
Options.FlySpeed:OnChanged(function(v) Cfg.Movement.FlySpeed = v end)

MoveGroup:AddToggle("SpeedToggle", { Text = "Speed Hack", Default = Cfg.Movement.SpeedHack })
Toggles.SpeedToggle:OnChanged(function(v) Cfg.Movement.SpeedHack = v end)

MoveGroup:AddSlider("SpeedVal", { Text = "Speed Factor", Default = Cfg.Movement.SpeedValue, Min = 16, Max = 100, Rounding = 0 })
Options.SpeedVal:OnChanged(function(v) Cfg.Movement.SpeedValue = v end)

MoveGroup:AddToggle("NoclipToggle", { Text = "Noclip", Default = Cfg.Movement.Noclip })
Toggles.NoclipToggle:OnChanged(function(v)
    Cfg.Movement.Noclip = v
    if v then StartNoclip() else StopNoclip() end
end)

-- Controller Movement Settings
local ControllerMoveGroup = Tabs.Move:AddRightGroupbox("Controller Movement")

ControllerMoveGroup:AddToggle("InvertY", { Text = "Invert Y-Axis", Default = Cfg.Movement.InvertY })
Toggles.InvertY:OnChanged(function(v) Cfg.Movement.InvertY = v end)

ControllerMoveGroup:AddSlider("ControllerSens", { Text = "Sensitivity", Default = Cfg.Movement.ControllerSensitivity, Min = 0.1, Max = 1, Rounding = 2 })
Options.ControllerSens:OnChanged(function(v) Cfg.Movement.ControllerSensitivity = v end)

-- =============================================
-- VISUALS TAB
-- =============================================
local VisGroup = Tabs.Vis:AddLeftGroupbox("Environment & Crosshair")

VisGroup:AddToggle("FullBright", { Text = "Fullbright", Default = Cfg.Visuals.FullBright })
Toggles.FullBright:OnChanged(function(v) Cfg.Visuals.FullBright = v end)

VisGroup:AddToggle("NoFog", { Text = "No Fog", Default = Cfg.Visuals.NoFog })
Toggles.NoFog:OnChanged(function(v) Cfg.Visuals.NoFog = v end)

VisGroup:AddToggle("CrosshairToggle", { Text = "Crosshair", Default = Cfg.Visuals.Crosshair })
Toggles.CrosshairToggle:OnChanged(function(v) Cfg.Visuals.Crosshair = v end)
Toggles.CrosshairToggle:AddColorPicker("CrosshairCol", { Default = Cfg.Visuals.CrosshairColor, Title = "Color" })
Options.CrosshairCol:OnChanged(function(v) Cfg.Visuals.CrosshairColor = v end)

VisGroup:AddSlider("CrosshairSize", { Text = "Length", Default = Cfg.Visuals.CrosshairSize, Min = 4, Max = 30, Rounding = 0 })
Options.CrosshairSize:OnChanged(function(v) Cfg.Visuals.CrosshairSize = v end)

VisGroup:AddSlider("CrosshairGap", { Text = "Spacing", Default = Cfg.Visuals.CrosshairGap, Min = 1, Max = 15, Rounding = 0 })
Options.CrosshairGap:OnChanged(function(v) Cfg.Visuals.CrosshairGap = v end)

VisGroup:AddSlider("CrosshairSpin", { Text = "Spin Speed", Default = Cfg.Visuals.CrosshairSpinSpeed, Min = 0.1, Max = 5, Rounding = 1 })
Options.CrosshairSpin:OnChanged(function(v) Cfg.Visuals.CrosshairSpinSpeed = v end)

-- =============================================
-- SETTINGS TAB
-- =============================================
local SettingsGroup = Tabs.Settings:AddLeftGroupbox("Input Settings")

SettingsGroup:AddLabel("Input Mode")
SettingsGroup:AddDropdown("InputModeDropdown", { 
    Values = {"Auto", "Keyboard & Mouse", "Controller"}, 
    Default = 1, 
    Text = "Input Mode" 
})
Options.InputModeDropdown:OnChanged(function(v)
    Cfg.Input.InputMode = v
    if v == "Controller" then
        CheckGamepad()
    end
end)

SettingsGroup:AddLabel("Detected Controller: " .. (InputHandler.IsControllerConnected() and "Connected" or "Not Detected"))
SettingsGroup:AddButton("Refresh Controller", function()
    CheckGamepad()
    StarterGui:SetCore("SendNotification", {
        Title = "Raven",
        Text = InputHandler.IsControllerConnected() and "Controller detected!" or "No controller found.",
        Duration = 2,
    })
end)

-- Watermark and Theme
Library:SetWatermark("Raven Framework | Solara Compatible | " .. (InputHandler.IsControllerConnected() and "🎮" : "⌨️"))
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

-- ================================================
--  CONTROLLER RUMBLE / FEEDBACK (Optional)
-- ================================================
function ControllerRumble(intensity, duration)
    if InputHandler.IsControllerConnected() then
        local gamepad = InputHandler.GetGamepad()
        if gamepad then
            pcall(function()
                UserInputService:SetGamepadVibration(gamepad, intensity, intensity, duration)
            end)
        end
    end
end

-- Rumble on target lock
local oldDoAim = DoAim
DoAim = function()
    if not Cfg.Aim.On then
        CurrentTarget = nil
        return
    end

    local holding = IsAimKeyPressed()
    if not holding then
        CurrentTarget = nil
        return
    end

    local target = GetClosestTarget()
    if not target then
        CurrentTarget = nil
        return
    end

    CurrentTarget = target

    local aimPos = GetTargetPosition(target.Char, target.Part, true)
    local currentCF = Camera.CFrame
    local targetCF = CFrame.lookAt(currentCF.Position, aimPos)

    if InputHandler.IsControllerConnected() and Cfg.Aim.ControllerAimAssist then
        local smooth = 1 - (Cfg.Aim.Smoothness * Cfg.Aim.ControllerAimStrength)
        smooth = math.clamp(smooth, 0.01, 1)
        Camera.CFrame = currentCF:Lerp(targetCF, smooth)
        -- Subtle rumble feedback
        ControllerRumble(0.15, 0.05)
    elseif Cfg.Aim.Smoothness <= 0 then
        Camera.CFrame = targetCF
    else
        local smooth = math.clamp(1 - Cfg.Aim.Smoothness, 0.01, 1)
        Camera.CFrame = currentCF:Lerp(targetCF, smooth)
    end
end

print("Raven Framework loaded successfully!")
print("Controller Support: " .. (InputHandler.IsControllerConnected() and "Connected" or "Not detected"))
