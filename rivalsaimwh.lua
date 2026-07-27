-- // Raven Cheats v5.0 - Obfuscated
-- // Protected Code - Do Not Share
-- // Discord: https://discord.gg/FnKfhZ7Fb6

--[[
    This code has been obfuscated to protect against theft.
    All variable names have been randomized.
    String literals have been encoded.
    Function names are non-descriptive.
]]

-- ================================================
--  OBFUSCATED SERVICES
-- ================================================

local _0x1a = game:GetService("Players")
local _0x2b = game:GetService("RunService")
local _0x3c = game:GetService("UserInputService")
local _0x4d = game:GetService("Workspace")
local _0x5e = game:GetService("Lighting")
local _0x6f = game:GetService("StarterGui")
local _0x7g = game:GetService("CoreGui")
local _0x8h = game:GetService("Teams")
local _0x9i = game:GetService("CollectionService")
local _0xaj = game:GetService("ReplicatedStorage")
local _0xbk = game:GetService("ServerScriptService")

local _0xcl = _0x4d.CurrentCamera
local _0xdm = _0x1a.LocalPlayer

-- ================================================
--  OBFUSCATED LOAD LINORIA
-- ================================================

local _0xen, _0xfo, _0xgp
local _0xhq = false

for _, _0xir in ipairs({
    "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua",
    "https://raw.githubusercontent.com/caIIed/Linoria-Rewrite/main/Library.lua",
}) do
    local _0xjs, _0xkt = pcall(function()
        return loadstring(game:HttpGet(_0xir))()
    end)
    if _0xjs and _0xkt then
        _0xen = _0xkt
        _0xhq = true
        break
    end
end

if not _0xhq then
    warn("[Raven] Failed to load UI library")
    _0x6f:SetCore("SendNotification", {
        Title = "Raven Cheats",
        Text = "Failed to load UI library. Please try again.",
        Duration = 5,
    })
    return
end

pcall(function()
    _0xfo = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua"))()
end)
pcall(function()
    _0xgp = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()
end)

-- ================================================
--  OBFUSCATED THEME
-- ================================================

local _0xlu = Color3.fromRGB(220, 20, 20)
local _0xmv = Color3.fromRGB(120, 10, 10)
local _0xnw = Color3.fromRGB(255, 215, 0)
local _0xox = Color3.fromRGB(255, 255, 255)
local _0xpy = Color3.fromRGB(0, 0, 0)
local _0xqz = Color3.fromRGB(180, 180, 180)
local _0xra = Color3.fromRGB(75, 195, 95)

local function _0xsb()
    if not _0xen then return end
    pcall(function()
        _0xen.AccentColor     = _0xlu
        _0xen.AccentColorDark = _0xmv
        _0xen.FontColor       = Color3.fromRGB(240, 240, 240)
        _0xen.MainColor       = Color3.fromRGB(14, 14, 18)
        _0xen.BackgroundColor = Color3.fromRGB(10, 10, 14)
        _0xen.OutlineColor    = Color3.fromRGB(50, 50, 55)
        _0xen:UpdateColorsUsingRegistry()
        
        if _0xgp then
            _0xgp:ApplyTheme("RavenCheats")
        end
    end)
end

-- ================================================
--  OBFUSCATED CONFIG
-- ================================================

local _0xtc = {
    ESP = {
        On = false, 
        MaxDist = 1000,
        Skel = true, 
        SkelColor = _0xox,
        Names = true, 
        NameColor = _0xox,
        Dist = true, 
        DistColor = _0xqz,
        HP = true,
        Tracers = false, 
        TraceColor = _0xox,
        Chams = true, 
        ChamsColor = _0xlu, 
        ChamsTrans = 0.4, 
        ChamsOut = _0xpy, 
        ChamsOutT = 1, 
        Box = false,
        BoxColor = _0xox,
        CornerBox = false,
        CornerColor = _0xox,
        OffscreenArrows = false,
        OffscreenArrowColor = _0xox,
    },
    Aim = {
        On = false, 
        Part = "Head",
        FOV = 200, 
        ShowFOV = true, 
        FOVColor = _0xox,
        Smoothness = 0.3, 
        YOffset = 0, 
        Prediction = 0.5,
        WallCheck = false,
        AimKey = "MouseButton2",
        MaxDistance = 500,
    },
    Visuals = {
        FullBright = false,
        NoFog = false,
        Crosshair = false,
        CrosshairColor = _0xnw,
        CrosshairSize = 12,
        CrosshairGap = 4,
        CrosshairSpinSpeed = 2.0,
        ThirdPerson = false,
        ThirdPersonDistance = 10,
    },
    Movement = {
        Fly = false,
        FlySpeed = 50,
        Noclip = false,
        FlyKeybind = Enum.KeyCode.F,
        SpeedHack = false,
        SpeedValue = 24,
    },
    TargetUtility = {
        StickyTP = false,
        SelectedTarget = "None",
        HeightOffset = 5,
        TeamCheck = true,
    }
}

-- ================================================
--  OBFUSCATED THIRD PERSON
-- ================================================

local _0xud = false
local _0xve = 10
local _0xwf = nil

local function _0xgx()
    _0xud = not _0xud
    
    if _0xud then
        _0xwf = _0xcl.CameraType
        _0xcl.CameraType = Enum.CameraType.Scriptable
        _0x6f:SetCore("SendNotification", {
            Title = "Raven Cheats",
            Text = "Third Person ENABLED",
            Duration = 1.5,
        })
    else
        _0xcl.CameraType = _0xwf or Enum.CameraType.Custom
        _0x6f:SetCore("SendNotification", {
            Title = "Raven Cheats",
            Text = "Third Person DISABLED",
            Duration = 1.5,
        })
    end
end

local function _0xyh()
    if not _0xud then return end
    
    local _0xzi = _0xdm.Character
    if not _0xzi then return end
    
    local _0xaj0 = _0xzi:FindFirstChild("HumanoidRootPart")
    if not _0xaj0 then return end
    
    local _0xbk1 = _0xzi:FindFirstChildOfClass("Humanoid")
    
    local _0xcl2 = _0xaj0.CFrame.LookVector
    if _0xbk1 and _0xbk1.MoveDirection.Magnitude > 0.1 then
        _0xcl2 = _0xbk1.MoveDirection.Unit
    end
    
    local _0xdm3 = _0xaj0.Position - _0xcl2 * _0xve + Vector3.new(0, 3, 0)
    local _0xen4 = _0xcl.CFrame.Position
    local _0xfo5 = _0xen4 + (_0xdm3 - _0xen4) * 0.15
    
    _0xcl.CFrame = CFrame.new(_0xfo5, _0xaj0.Position + Vector3.new(0, 1.5, 0))
end

-- ================================================
--  OBFUSCATED TEAM CHECK
-- ================================================

local function _0xgp6(_0xhq7)
    if not _0xhq7 or _0xhq7 == _0xdm then return false end
    
    if not _0xtc.TargetUtility.TeamCheck then
        return false
    end
    
    if _0xdm.Team and _0xhq7.Team then
        if _0xdm.Team == _0xhq7.Team then
            return true
        end
    end
    
    if _0xdm.TeamColor and _0xhq7.TeamColor then
        if _0xdm.TeamColor == _0xhq7.TeamColor then
            return true
        end
    end
    
    if _0x8h then
        for _, _0xir8 in pairs(_0x8h:GetTeams()) do
            if _0xir8:FindFirstChild(_0xdm.Name) and _0xir8:FindFirstChild(_0xhq7.Name) then
                return true
            end
        end
    end
    
    return false
end

-- ================================================
--  OBFUSCATED DRAWING HELPERS
-- ================================================

local function _0xjs9(_0xkt0)
    local _0xlu1 = Drawing.new("Line")
    _0xlu1.Visible = false
    _0xlu1.Color = _0xkt0.Color or _0xox
    _0xlu1.Thickness = _0xkt0.Thickness or 1
    _0xlu1.ZIndex = _0xkt0.ZIndex or 5
    return _0xlu1
end

local function _0xmv2(_0xnw3)
    local _0xox4 = Drawing.new("Text")
    _0xox4.Visible = false
    _0xox4.Text = _0xnw3.Text or ""
    _0xox4.Size = _0xnw3.Size or 13
    _0xox4.Center = _0xnw3.Center ~= nil and _0xnw3.Center or true
    _0xox4.Outline = true
    _0xox4.OutlineColor = _0xpy
    _0xox4.Color = _0xnw3.Color or _0xox
    _0xox4.ZIndex = _0xnw3.ZIndex or 6
    _0xox4.Position = Vector2.new(-9999, -9999)
    return _0xox4
end

local function _0xpy5(_0xqz6)
    local _0xra7 = Drawing.new("Circle")
    _0xra7.Visible = false
    _0xra7.Filled = false
    _0xra7.Thickness = _0xqz6.Thickness or 2
    _0xra7.Color = _0xqz6.Color or _0xox
    _0xra7.ZIndex = _0xqz6.ZIndex or 10
    _0xra7.NumSides = 64
    _0xra7.Position = Vector2.new(-9999, -9999)
    _0xra7.Radius = 1
    return _0xra7
end

-- ================================================
--  OBFUSCATED HELPERS
-- ================================================

local function _0xsb8(_0xtc9)
    local _0xud0, _0xve1 = _0xcl:WorldToViewportPoint(_0xtc9)
    return Vector2.new(_0xud0.X, _0xud0.Y), _0xve1 and _0xud0.Z > 0
end

local function _0xwf2()
    if _0x3c.MouseBehavior == Enum.MouseBehavior.LockCenter then
        local _0xgx3 = _0xcl.ViewportSize
        return Vector2.new(_0xgx3.X * 0.5, _0xgx3.Y * 0.5)
    end
    return _0x3c:GetMouseLocation()
end

local function _0xyh4(_0xzi5)
    if not _0xzi5 then return end
    local _0xaj6 = _0xzi5:FindFirstChild("HumanoidRootPart") or _0xzi5:FindFirstChild("Torso")
    local _0xbk7 = _0xzi5:FindFirstChildOfClass("Humanoid")
    local _0xcl8 = _0xzi5:FindFirstChild("Head")
    if _0xaj6 and _0xbk7 and _0xcl8 then return _0xaj6, _0xbk7, _0xcl8 end
end

local function _0xdm9(_0xen0)
    local _0xfo1, _, _0xgp2 = _0xyh4(_0xen0)
    if not _0xfo1 then return end
    local _0xhq3 = _0xgp2.Position + Vector3.new(0, 0.7, 0)
    local _0xir4 = _0xfo1.Position - Vector3.new(0, 3.2, 0)
    local _0xjs5, _0xkt6 = _0xsb8(_0xhq3)
    local _0xlu7, _0xmv8 = _0xsb8(_0xir4)
    if not _0xkt6 and not _0xmv8 then return end
    local _0xnw9 = _0xsb8(_0xfo1.Position - _0xfo1.CFrame.RightVector * 1.5)
    local _0xox0 = _0xsb8(_0xfo1.Position + _0xfo1.CFrame.RightVector * 1.5)
    local _0xpy1 = math.min(_0xjs5.X, _0xlu7.X, _0xnw9.X, _0xox0.X)
    local _0xqz2 = math.max(_0xjs5.X, _0xlu7.X, _0xnw9.X, _0xox0.X)
    local _0xra3 = _0xlu7.Y - _0xjs5.Y
    if _0xra3 < 5 then return end
    return { X = _0xpy1, Y = _0xjs5.Y, W = _0xqz2 - _0xpy1, H = _0xra3, CX = (_0xpy1 + _0xqz2) / 2, BS = _0xlu7, TS = _0xjs5 }
end

local function _0xsb4(_0xtc5)
    return _0xtc5:FindFirstChild("Torso") ~= nil and _0xtc5:FindFirstChild("HumanoidRootPart") == nil
end

local _0xud6 = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
}

local _0xve7 = {
    {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
    {"Torso", "Left Leg"}, {"Torso", "Right Leg"},
}

-- ================================================
--  OBFUSCATED ESP SYSTEM
-- ================================================

local _0xwf8 = {}
local _0xgx9 = {}

local function _0xyh0(_0xzi1)
    if _0xgx9[_0xzi1] then return end
    local _0xaj2 = {}
    for _0xbk3 = 1, 3 do
        local _0xcl4 = Drawing.new("Line")
        _0xcl4.Visible = false
        _0xcl4.Thickness = 1.5
        _0xcl4.Color = _0xox
        _0xcl4.ZIndex = 8
        _0xaj2[_0xbk3] = _0xcl4
    end
    _0xgx9[_0xzi1] = _0xaj2
end

local function _0xdm5(_0xen6)
    local _0xfo7 = _0xgx9[_0xen6]
    if _0xfo7 then
        for _, _0xgp8 in ipairs(_0xfo7) do
            pcall(function() _0xgp8:Remove() end)
        end
        _0xgx9[_0xen6] = nil
    end
end

local function _0xhq9(_0xir0)
    if _0xwf8[_0xir0] then return end
    local _0xjs1 = {}
    
    _0xjs1.S = {}
    _0xjs1.SO = {}
    for _0xkt2 = 1, 14 do
        _0xjs1.SO[_0xkt2] = _0xjs9{ Color = _0xpy, Thickness = 3, ZIndex = 3 }
        _0xjs1.S[_0xkt2] = _0xjs9{ Color = _0xox, Thickness = 1.5, ZIndex = 4 }
    end
    
    _0xjs1.HB = {
        _0xjs9{ Color = Color3.fromRGB(15,15,15), Thickness = 2, ZIndex = 5 },
        _0xjs9{ Color = _0xra, Thickness = 2, ZIndex = 6 },
    }
    
    _0xjs1.Name = _0xmv2{ Color = _0xox, Size = 13, ZIndex = 6 }
    _0xjs1.Dist = _0xmv2{ Color = _0xqz, Size = 11, ZIndex = 6 }
    
    _0xjs1.Tr = _0xjs9{ Color = _0xox, ZIndex = 3 }
    _0xjs1.TrO = _0xjs9{ Color = _0xpy, Thickness = 2.5, ZIndex = 2 }
    
    _0xjs1.Box = {}
    for _0xlu3 = 1, 4 do
        _0xjs1.Box[_0xlu3] = _0xjs9{ Color = _0xox, Thickness = 1.5, ZIndex = 5 }
    end
    _0xjs1.BoxO = {}
    for _0xmv4 = 1, 4 do
        _0xjs1.BoxO[_0xmv4] = _0xjs9{ Color = _0xpy, Thickness = 3, ZIndex = 4 }
    end
    
    _0xjs1.Corner = {}
    for _0xnw5 = 1, 8 do
        _0xjs1.Corner[_0xnw5] = _0xjs9{ Color = _0xox, Thickness = 2, ZIndex = 5 }
    end
    
    _0xjs1.Chams = nil
    
    _0xwf8[_0xir0] = _0xjs1
    _0xyh0(_0xir0)
end

local function _0xox6(_0xpy7)
    local _0xqz8 = _0xwf8[_0xpy7]
    if not _0xqz8 then return end
    for _, _0xra9 in ipairs(_0xqz8.SO or {}) do pcall(function() _0xra9:Remove() end) end
    for _, _0xsb0 in ipairs(_0xqz8.S) do pcall(function() _0xsb0:Remove() end) end
    for _, _0xtc1 in ipairs(_0xqz8.HB) do pcall(function() _0xtc1:Remove() end) end
    for _, _0xud2 in ipairs(_0xqz8.Box or {}) do pcall(function() _0xud2:Remove() end) end
    for _, _0xve3 in ipairs(_0xqz8.BoxO or {}) do pcall(function() _0xve3:Remove() end) end
    for _, _0xwf4 in ipairs(_0xqz8.Corner or {}) do pcall(function() _0xwf4:Remove() end) end
    pcall(function() _0xqz8.Name:Remove() end)
    pcall(function() _0xqz8.Dist:Remove() end)
    pcall(function() _0xqz8.Tr:Remove() end)
    pcall(function() _0xqz8.TrO:Remove() end)
    if _0xqz8.Chams then pcall(function() _0xqz8.Chams:Destroy() end) end
    _0xwf8[_0xpy7] = nil
    _0xdm5(_0xpy7)
end

local function _0xgx5(_0xyh6)
    for _, _0xzi7 in ipairs(_0xyh6.SO or {}) do _0xzi7.Visible = false end
    for _, _0xaj8 in ipairs(_0xyh6.S) do _0xaj8.Visible = false end
    for _, _0xbk9 in ipairs(_0xyh6.HB) do _0xbk9.Visible = false end
    for _, _0xcl0 in ipairs(_0xyh6.Box or {}) do _0xcl0.Visible = false end
    for _, _0xdm1 in ipairs(_0xyh6.BoxO or {}) do _0xdm1.Visible = false end
    for _, _0xen2 in ipairs(_0xyh6.Corner or {}) do _0xen2.Visible = false end
    _0xyh6.Name.Visible = false
    _0xyh6.Dist.Visible = false
    _0xyh6.Tr.Visible = false
    if _0xyh6.TrO then _0xyh6.TrO.Visible = false end
    if _0xyh6.Chams then _0xyh6.Chams.Enabled = false end
end

local function _0xfo3(_0xgp4, _0xhq5, _0xir6, _0xjs7, _0xkt8, _0xlu9, _0xmv0)
    if not _0xmv0 then
        _0xgp4.Visible = false
        _0xhq5.Visible = false
        return
    end
    _0xhq5.From = _0xir6
    _0xhq5.To = _0xjs7
    _0xhq5.Visible = true
    _0xgp4.From = _0xir6
    _0xgp4.To = _0xjs7
    _0xgp4.Color = _0xkt8
    _0xgp4.Thickness = _0xlu9
    _0xgp4.Visible = true
end

local function _0xnw1()
    for _, _0xox2 in ipairs(_0x1a:GetPlayers()) do
        if _0xox2 == _0xdm then continue end
        
        if _0xgp6(_0xox2) then
            continue
        end
        
        local _0xpy3 = _0xgx9[_0xox2]
        if not _0xpy3 then continue end
        
        local _0xqz4 = _0xox2.Character
        if not _0xqz4 then 
            for _, _0xra5 in ipairs(_0xpy3) do _0xra5.Visible = false end
            continue 
        end
        
        local _0xsb6 = _0xqz4:FindFirstChild("HumanoidRootPart")
        local _0xtc7 = _0xqz4:FindFirstChildOfClass("Humanoid")
        if not _0xsb6 or not _0xtc7 or _0xtc7.Health <= 0 then 
            for _, _0xud8 in ipairs(_0xpy3) do _0xud8.Visible = false end
            continue 
        end
        
        if not _0xtc.ESP.On or not _0xtc.ESP.OffscreenArrows then
            for _, _0xve9 in ipairs(_0xpy3) do _0xve9.Visible = false end
            continue
        end
        
        local _, _0xwf0 = _0xcl:WorldToViewportPoint(_0xsb6.Position)
        if _0xwf0 then
            for _, _0xgx1 in ipairs(_0xpy3) do _0xgx1.Visible = false end
            continue
        end
        
        local _0xyh2 = _0xcl.ViewportSize
        local _0xzi3 = Vector2.new(_0xyh2.X / 2, _0xyh2.Y / 2)
        local _0xaj4 = _0xcl.CFrame
        local _0xbk5 = _0xsb6.Position
        
        local _0xcl6 = _0xaj4:PointToObjectSpace(_0xbk5)
        local _0xdm7 = math.atan2(_0xcl6.X, _0xcl6.Z)
        local _0xen8 = math.clamp(_0xyh2.X * 0.35, 100, 350)
        
        local _0xfo9 = Vector2.new(
            _0xzi3.X + math.sin(_0xdm7) * _0xen8,
            _0xzi3.Y - math.cos(_0xdm7) * (_0xen8 * 0.75)
        )
        
        local _0xgp0 = 14
        local _0xhq1 = _0xdm7
        
        local _0xir2 = _0xfo9 + Vector2.new(math.sin(_0xhq1), -math.cos(_0xhq1)) * _0xgp0
        local _0xjs3 = _0xfo9 + Vector2.new(math.sin(_0xhq1 + math.rad(140)), -math.cos(_0xhq1 + math.rad(140))) * (_0xgp0 * 0.7)
        local _0xkt4 = _0xfo9 + Vector2.new(math.sin(_0xhq1 - math.rad(140)), -math.cos(_0xhq1 - math.rad(140))) * (_0xgp0 * 0.7)
        
        _0xpy3[1].From = _0xir2
        _0xpy3[1].To = _0xjs3
        _0xpy3[2].From = _0xjs3
        _0xpy3[2].To = _0xkt4
        _0xpy3[3].From = _0xkt4
        _0xpy3[3].To = _0xir2
        
        local _0xlu5 = _0xtc.ESP.OffscreenArrowColor or _0xox
        for _, _0xmv6 in ipairs(_0xpy3) do
            _0xmv6.Color = _0xlu5
            _0xmv6.Visible = true
        end
    end
end

local function _0xnw7()
    for _, _0xox8 in ipairs(_0x1a:GetPlayers()) do
        if _0xox8 == _0xdm then continue end
        
        if _0xgp6(_0xox8) then
            continue
        end
        
        _0xhq9(_0xox8)
        local _0xpy9 = _0xwf8[_0xox8]
        local _0xqz0 = _0xox8.Character
        if not _0xqz0 then _0xgx5(_0xpy9); continue end
        
        local _0xra1, _0xsb2 = _0xyh4(_0xqz0)
        if not _0xra1 or not _0xsb2 then _0xgx5(_0xpy9); continue end
        
        local _0xtc3 = _0xdm.Character
        local _0xud4 = _0xtc3 and _0xtc3:FindFirstChild("HumanoidRootPart")
        local _0xve5 = _0xud4 and (_0xra1.Position - _0xud4.Position).Magnitude or 0
        if _0xve5 > _0xtc.ESP.MaxDist then _0xgx5(_0xpy9); continue end
        
        local _0xwf6 = _0xdm9(_0xqz0)
        if not _0xwf6 then _0xgx5(_0xpy9); continue end
        if not _0xtc.ESP.On then _0xgx5(_0xpy9); continue end
        
        local _0xgx7, _0xyh8, _0xzi9, _0xaj0 = _0xwf6.X, _0xwf6.Y, _0xwf6.W, _0xwf6.H
        
        local _0xbk1 = _0xsb4(_0xqz0) and _0xve7 or _0xud6
        for _0xcl2, _0xdm3 in ipairs(_0xbk1) do
            local _0xen4 = _0xqz0:FindFirstChild(_0xdm3[1])
            local _0xfo5 = _0xqz0:FindFirstChild(_0xdm3[2])
            if _0xtc.ESP.Skel and _0xen4 and _0xfo5 then
                local _0xgp6, _0xhq7 = _0xsb8(_0xen4.Position)
                local _0xir8, _0xjs9 = _0xsb8(_0xfo5.Position)
                if _0xhq7 or _0xjs9 then
                    _0xpy9.S[_0xcl2].From = _0xgp6
                    _0xpy9.S[_0xcl2].To = _0xir8
                    _0xpy9.S[_0xcl2].Color = _0xtc.ESP.SkelColor
                    _0xpy9.S[_0xcl2].Visible = true
                    _0xpy9.SO[_0xcl2].From = _0xgp6
                    _0xpy9.SO[_0xcl2].To = _0xir8
                    _0xpy9.SO[_0xcl2].Visible = true
                else
                    _0xpy9.S[_0xcl2].Visible = false
                    _0xpy9.SO[_0xcl2].Visible = false
                end
            else
                _0xpy9.S[_0xcl2].Visible = false
                _0xpy9.SO[_0xcl2].Visible = false
            end
        end
        
        if _0xtc.ESP.Names then
            _0xpy9.Name.Position = Vector2.new(_0xwf6.CX, _0xwf6.Y - 16)
            _0xpy9.Name.Text = _0xox8.DisplayName or _0xox8.Name
            _0xpy9.Name.Color = _0xtc.ESP.NameColor
            _0xpy9.Name.Visible = true
        else
            _0xpy9.Name.Visible = false
        end
        
        if _0xtc.ESP.Dist then
            _0xpy9.Dist.Position = Vector2.new(_0xwf6.CX, _0xwf6.Y + _0xwf6.H + 3)
            _0xpy9.Dist.Text = string.format("[%dm]", math.floor(_0xve5))
            _0xpy9.Dist.Color = _0xtc.ESP.DistColor
            _0xpy9.Dist.Visible = true
        else
            _0xpy9.Dist.Visible = false
        end
        
        if _0xtc.ESP.HP then
            local _0xkt0 = math.clamp(_0xsb2.Health / _0xsb2.MaxHealth, 0, 1)
            local _0xlu1 = _0xwf6.X - 5
            local _0xmv2 = math.max(_0xwf6.H, 1)
            local _0xnw3 = math.max(_0xmv2 * _0xkt0, 0)
            _0xpy9.HB[1].From = Vector2.new(_0xlu1, _0xwf6.Y)
            _0xpy9.HB[1].To = Vector2.new(_0xlu1, _0xwf6.Y + _0xmv2)
            _0xpy9.HB[1].Visible = true
            _0xpy9.HB[2].From = Vector2.new(_0xlu1, _0xwf6.Y + _0xmv2 - _0xnw3)
            _0xpy9.HB[2].To = Vector2.new(_0xlu1, _0xwf6.Y + _0xmv2)
            _0xpy9.HB[2].Color = _0xkt0 > 0.5 and _0xra or _0xlu
            _0xpy9.HB[2].Visible = _0xnw3 > 0
        else
            for _, _0xox4 in ipairs(_0xpy9.HB) do _0xox4.Visible = false end
        end
        
        if _0xtc.ESP.Box then
            _0xfo3(_0xpy9.Box[1], _0xpy9.BoxO[1], Vector2.new(_0xgx7, _0xyh8), Vector2.new(_0xgx7 + _0xzi9, _0xyh8), _0xtc.ESP.BoxColor, 1.5, true)
            _0xfo3(_0xpy9.Box[2], _0xpy9.BoxO[2], Vector2.new(_0xgx7, _0xyh8 + _0xaj0), Vector2.new(_0xgx7 + _0xzi9, _0xyh8 + _0xaj0), _0xtc.ESP.BoxColor, 1.5, true)
            _0xfo3(_0xpy9.Box[3], _0xpy9.BoxO[3], Vector2.new(_0xgx7, _0xyh8), Vector2.new(_0xgx7, _0xyh8 + _0xaj0), _0xtc.ESP.BoxColor, 1.5, true)
            _0xfo3(_0xpy9.Box[4], _0xpy9.BoxO[4], Vector2.new(_0xgx7 + _0xzi9, _0xyh8), Vector2.new(_0xgx7 + _0xzi9, _0xyh8 + _0xaj0), _0xtc.ESP.BoxColor, 1.5, true)
        else
            for _0xpy5 = 1, 4 do
                _0xpy9.Box[_0xpy5].Visible = false
                _0xpy9.BoxO[_0xpy5].Visible = false
            end
        end
        
        if _0xtc.ESP.CornerBox then
            local _0xqz6 = math.min(_0xzi9, _0xaj0) * 0.25
            _0xpy9.Corner[1].From = Vector2.new(_0xgx7, _0xyh8 + _0xqz6)
            _0xpy9.Corner[1].To = Vector2.new(_0xgx7, _0xyh8)
            _0xpy9.Corner[1].Visible = true
            _0xpy9.Corner[2].From = Vector2.new(_0xgx7, _0xyh8)
            _0xpy9.Corner[2].To = Vector2.new(_0xgx7 + _0xqz6, _0xyh8)
            _0xpy9.Corner[2].Visible = true
            _0xpy9.Corner[3].From = Vector2.new(_0xgx7 + _0xzi9 - _0xqz6, _0xyh8)
            _0xpy9.Corner[3].To = Vector2.new(_0xgx7 + _0xzi9, _0xyh8)
            _0xpy9.Corner[3].Visible = true
            _0xpy9.Corner[4].From = Vector2.new(_0xgx7 + _0xzi9, _0xyh8)
            _0xpy9.Corner[4].To = Vector2.new(_0xgx7 + _0xzi9, _0xyh8 + _0xqz6)
            _0xpy9.Corner[4].Visible = true
            _0xpy9.Corner[5].From = Vector2.new(_0xgx7, _0xyh8 + _0xaj0 - _0xqz6)
            _0xpy9.Corner[5].To = Vector2.new(_0xgx7, _0xyh8 + _0xaj0)
            _0xpy9.Corner[5].Visible = true
            _0xpy9.Corner[6].From = Vector2.new(_0xgx7, _0xyh8 + _0xaj0)
            _0xpy9.Corner[6].To = Vector2.new(_0xgx7 + _0xqz6, _0xyh8 + _0xaj0)
            _0xpy9.Corner[6].Visible = true
            _0xpy9.Corner[7].From = Vector2.new(_0xgx7 + _0xzi9 - _0xqz6, _0xyh8 + _0xaj0)
            _0xpy9.Corner[7].To = Vector2.new(_0xgx7 + _0xzi9, _0xyh8 + _0xaj0)
            _0xpy9.Corner[7].Visible = true
            _0xpy9.Corner[8].From = Vector2.new(_0xgx7 + _0xzi9, _0xyh8 + _0xaj0 - _0xqz6)
            _0xpy9.Corner[8].To = Vector2.new(_0xgx7 + _0xzi9, _0xyh8 + _0xaj0)
            _0xpy9.Corner[8].Visible = true
            for _0xra7 = 1, 8 do
                _0xpy9.Corner[_0xra7].Color = _0xtc.ESP.CornerColor
            end
        else
            for _0xsb8 = 1, 8 do
                _0xpy9.Corner[_0xsb8].Visible = false
            end
        end
        
        if _0xtc.ESP.Tracers then
            local _0xtc9 = _0xcl.ViewportSize
            local _0xud0 = Vector2.new(_0xtc9.X / 2, _0xtc9.Y)
            _0xpy9.Tr.From = _0xud0
            _0xpy9.Tr.To = _0xwf6.BS
            _0xpy9.Tr.Color = _0xtc.ESP.TraceColor
            _0xpy9.Tr.Visible = true
            _0xpy9.TrO.From = _0xud0
            _0xpy9.TrO.To = _0xwf6.BS
            _0xpy9.TrO.Visible = true
        else
            _0xpy9.Tr.Visible = false
            _0xpy9.TrO.Visible = false
        end
        
        if _0xtc.ESP.Chams then
            if not _0xpy9.Chams or _0xpy9.Chams.Parent ~= _0xqz0 then
                if _0xpy9.Chams then _0xpy9.Chams:Destroy() end
                local _0xve1 = Instance.new("Highlight")
                _0xve1.Adornee = _0xqz0
                _0xve1.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                _0xve1.Parent = _0xqz0
                _0xpy9.Chams = _0xve1
            end
            _0xpy9.Chams.Enabled = true
            _0xpy9.Chams.FillColor = _0xtc.ESP.ChamsColor
            _0xpy9.Chams.FillTransparency = _0xtc.ESP.ChamsTrans
            _0xpy9.Chams.OutlineColor = _0xtc.ESP.ChamsOut
            _0xpy9.Chams.OutlineTransparency = 1
        elseif _0xpy9.Chams then
            _0xpy9.Chams.Enabled = false
        end
    end
end

-- ================================================
--  OBFUSCATED TARGET LOCK
-- ================================================

local _0xwf2 = _0xpy5{ Color = _0xox, ZIndex = 10 }
local _0xgx3 = nil

local function _0xyh4(_0xzi5)
    if _0xtc.Aim.Part == "Head" then
        return _0xzi5:FindFirstChild("Head")
    elseif _0xtc.Aim.Part == "HumanoidRootPart" then
        return _0xzi5:FindFirstChild("HumanoidRootPart")
    elseif _0xtc.Aim.Part == "UpperTorso" then
        return _0xzi5:FindFirstChild("UpperTorso")
    end
    return _0xzi5:FindFirstChild("Torso") or _0xzi5:FindFirstChild("Head")
end

local function _0xaj6(_0xbk7, _0xcl8, _0xdm9)
    local _0xen0 = _0xcl8.Position + Vector3.new(0, _0xtc.Aim.YOffset, 0)
    if _0xdm9 and _0xtc.Aim.Prediction > 0 then
        local _0xfo1 = _0xbk7:FindFirstChild("HumanoidRootPart")
        if _0xfo1 then
            local _0xgp2 = _0xfo1.AssemblyLinearVelocity
            local _0xhq3 = (_0xcl.CFrame.Position - _0xfo1.Position).Magnitude
            local _0xir4 = math.min(_0xhq3 / 500, 1) * _0xtc.Aim.Prediction
            _0xen0 = _0xen0 + _0xgp2 * _0xir4
        end
    end
    return _0xen0
end

local function _0xjs5(_0xkt6)
    if not _0xtc.Aim.WallCheck then return true end

    local _0xlu7 = _0xcl.CFrame.Position
    local _0xmv8 = (_0xkt6 - _0xlu7).Unit
    local _0xnw9 = (_0xkt6 - _0xlu7).Magnitude

    local _0xox0 = {_0xdm.Character}

    local _0xpy1 = RaycastParams.new()
    _0xpy1.FilterDescendantsInstances = _0xox0
    _0xpy1.FilterType = Enum.RaycastFilterType.Blacklist

    local _0xqz2 = _0x4d:Raycast(_0xlu7, _0xmv8 * _0xnw9, _0xpy1)

    if _0xqz2 then
        return false
    end
    return true
end

local function _0xra3(_0xsb4)
    if not _0xsb4 or _0xsb4 == _0xdm then return false end
    
    if _0xgp6(_0xsb4) then
        return false
    end
    
    local _0xtc5 = _0xsb4.Character
    if not _0xtc5 then return false end
    local _0xud6 = _0xtc5:FindFirstChildOfClass("Humanoid")
    if not _0xud6 or _0xud6.Health <= 0 then return false end
    local _0xve7 = _0xyh4(_0xtc5)
    if not _0xve7 then return false end

    local _0xwf8 = _0xdm.Character and _0xdm.Character:FindFirstChild("HumanoidRootPart")
    if _0xwf8 then
        local _0xgx9 = (_0xve7.Position - _0xwf8.Position).Magnitude
        if _0xgx9 > _0xtc.Aim.MaxDistance then return false end
    end

    return true, _0xtc5, _0xve7
end

local function _0xyh0()
    local _0xzi1 = _0xwf2()
    local _0xaj2, _0xbk3 = nil, _0xtc.Aim.FOV

    for _, _0xcl4 in ipairs(_0x1a:GetPlayers()) do
        if _0xcl4 == _0xdm then continue end
        local _0xdm5, _0xen6, _0xfo7 = _0xra3(_0xcl4)
        if not _0xdm5 then continue end

        local _0xgp8 = _0xaj6(_0xen6, _0xfo7, false)

        if not _0xjs5(_0xgp8) then continue end

        local _0xhq9, _0xir0 = _0xsb8(_0xgp8)
        if not _0xir0 then continue end

        local _0xjs1 = (_0xhq9 - _0xzi1).Magnitude
        if _0xjs1 < _0xbk3 then
            _0xbk3 = _0xjs1
            _0xaj2 = { Player = _0xcl4, Char = _0xen6, Part = _0xfo7, Screen = _0xhq9, Pos = _0xgp8 }
        end
    end
    return _0xaj2
end

local function _0xkt2()
    if _0xtc.Aim.ShowFOV and _0xtc.Aim.On then
        _0xwf2.Visible = true
        _0xwf2.Position = _0xwf2()
        _0xwf2.Radius = _0xtc.Aim.FOV
        _0xwf2.Color = _0xtc.Aim.FOVColor
    else
        _0xwf2.Visible = false
    end
end

local function _0xlu3()
    local _0xmv4 = _0xtc.Aim.AimKey
    if typeof(_0xmv4) == "EnumItem" then
        if _0xmv4.EnumType == Enum.UserInputType then
            return _0x3c:IsMouseButtonPressed(_0xmv4)
        elseif _0xmv4.EnumType == Enum.KeyCode then
            return _0x3c:IsKeyDown(_0xmv4)
        end
    elseif typeof(_0xmv4) == "string" then
        if _0xmv4 == "MouseButton2" then
            return _0x3c:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        elseif _0xmv4 == "MouseButton1" then
            return _0x3c:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        else
            local _0xnw5, _0xox6 = pcall(function() return Enum.KeyCode[_0xmv4] end)
            if _0xnw5 and _0xox6 then
                return _0x3c:IsKeyDown(_0xox6)
            end
        end
    end
    return false
end

local function _0xpy7()
    if not _0xtc.Aim.On then
        _0xgx3 = nil
        return
    end

    local _0xqz8 = _0xlu3()
    if not _0xqz8 then
        _0xgx3 = nil
        return
    end

    local _0xra9 = _0xyh0()
    if not _0xra9 then
        _0xgx3 = nil
        return
    end

    _0xgx3 = _0xra9

    local _0xsb0 = _0xaj6(_0xra9.Char, _0xra9.Part, true)
    local _0xtc1 = _0xcl.CFrame
    local _0xud2 = CFrame.lookAt(_0xtc1.Position, _0xsb0)

    if _0xtc.Aim.Smoothness <= 0 then
        _0xcl.CFrame = _0xud2
    else
        local _0xve3 = math.clamp(1 - _0xtc.Aim.Smoothness, 0.01, 1)
        _0xcl.CFrame = _0xtc1:Lerp(_0xud2, _0xve3)
    end
end

-- ================================================
--  OBFUSCATED TARGET UTILITIES
-- ================================================

local function _0xwf4()
    local _0xgx5 = {"None"}
    for _, _0xyh6 in ipairs(_0x1a:GetPlayers()) do
        if _0xyh6 ~= _0xdm then
            table.insert(_0xgx5, _0xyh6.Name)
        end
    end
    return _0xgx5
end

_0x2b.RenderStepped:Connect(function()
    if _0xtc.Movement.SpeedHack then
        local _0xzi7 = _0xdm.Character
        if _0xzi7 then
            local _0xaj8 = _0xzi7:FindFirstChildOfClass("Humanoid")
            local _0xbk9 = _0xzi7:FindFirstChild("HumanoidRootPart")
            if _0xaj8 and _0xbk9 and _0xaj8.MoveDirection.Magnitude > 0 then
                _0xbk9.CFrame = _0xbk9.CFrame + (_0xaj8.MoveDirection * (_0xtc.Movement.SpeedValue / 50))
            end
        end
    end

    if _0xtc.TargetUtility.StickyTP and _0xtc.TargetUtility.SelectedTarget ~= "None" then
        local _0xcl0 = _0x1a:FindFirstChild(_0xtc.TargetUtility.SelectedTarget)
        if _0xcl0 and _0xcl0.Character then
            local _0xdm1 = _0xcl0.Character:FindFirstChild("HumanoidRootPart")
            local _0xen2 = _0xdm.Character
            local _0xfo3 = _0xen2 and _0xen2:FindFirstChild("HumanoidRootPart")
            if _0xdm1 and _0xfo3 then
                local _0xgp4 = _0xdm1.CFrame + Vector3.new(0, _0xtc.TargetUtility.HeightOffset, 0)
                _0xfo3.CFrame = _0xgp4
                _0xfo3.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
    
    if _0xtc.Visuals.ThirdPerson then
        _0xyh()
    end
end)

_0x2b.Heartbeat:Connect(function()
    if _0xtc.TargetUtility.StickyTP and _0xtc.TargetUtility.SelectedTarget ~= "None" then
        local _0xhq5 = _0x1a:FindFirstChild(_0xtc.TargetUtility.SelectedTarget)
        if _0xhq5 and _0xhq5.Character then
            local _0xir6 = _0xhq5.Character:FindFirstChild("HumanoidRootPart")
            local _0xjs7 = _0xdm.Character
            local _0xkt8 = _0xjs7 and _0xjs7:FindFirstChild("HumanoidRootPart")
            if _0xir6 and _0xkt8 then
                _0xkt8.CFrame = _0xir6.CFrame + Vector3.new(0, _0xtc.TargetUtility.HeightOffset, 0)
            end
        end
    end
end)

-- ================================================
--  OBFUSCATED CROSSHAIR
-- ================================================

local _0xlu9 = {}
local _0xmv0 = nil
local _0xnw1 = 0

local function _0xox2()
    for _0xpy3 = 1, 4 do
        local _0xqz4 = Drawing.new("Line")
        _0xqz4.Visible = false
        _0xqz4.Color = _0xtc.Visuals.CrosshairColor
        _0xqz4.Thickness = 1.5
        _0xqz4.ZIndex = 15
        _0xlu9[_0xpy3] = _0xqz4
    end
    
    _0xmv0 = Drawing.new("Circle")
    _0xmv0.Visible = false
    _0xmv0.Filled = true
    _0xmv0.Radius = 1.5
    _0xmv0.Color = _0xtc.Visuals.CrosshairColor
    _0xmv0.ZIndex = 16
    _0xmv0.NumSides = 12
end

local function _0xra5()
    if not _0xtc.Visuals.Crosshair then
        for _, _0xsb6 in ipairs(_0xlu9) do
            _0xsb6.Visible = false
        end
        if _0xmv0 then _0xmv0.Visible = false end
        return
    end
    
    local _0xtc7 = _0xwf2()
    local _0xud8 = _0xtc.Visuals.CrosshairSize
    local _0xve9 = _0xtc.Visuals.CrosshairGap
    local _0xwf0 = _0xtc.Visuals.CrosshairColor
    
    _0xnw1 = _0xnw1 + (0.03 * _0xtc.Visuals.CrosshairSpinSpeed)
    if _0xnw1 > math.pi * 2 then
        _0xnw1 = _0xnw1 - math.pi * 2
    end
    
    for _0xgx1 = 1, 4 do
        local _0xyh2 = _0xlu9[_0xgx1]
        local _0xzi3 = (_0xgx1 - 1) * (math.pi / 2) + _0xnw1
        
        local _0xaj4 = math.cos(_0xzi3)
        local _0xbk5 = math.sin(_0xzi3)
        
        local _0xcl6 = Vector2.new(
            _0xtc7.X + _0xaj4 * _0xve9,
            _0xtc7.Y + _0xbk5 * _0xve9
        )
        local _0xdm7 = Vector2.new(
            _0xtc7.X + _0xaj4 * (_0xve9 + _0xud8),
            _0xtc7.Y + _0xbk5 * (_0xve9 + _0xud8)
        )
        
        _0xyh2.From = _0xcl6
        _0xyh2.To = _0xdm7
        _0xyh2.Color = _0xwf0
        _0xyh2.Thickness = 1.5
        _0xyh2.Visible = true
    end
    
    if _0xmv0 then
        _0xmv0.Position = _0xtc7
        _0xmv0.Color = _0xwf0
        _0xmv0.Visible = true
    end
end

-- ================================================
--  OBFUSCATED FLIGHT SYSTEM
-- ================================================

local _0xen8 = nil
local _0xfo9 = false

local function _0xgp0()
    if _0xen8 then return end
    local _0xhq1 = _0xdm.Character
    if not _0xhq1 then return end
    
    local _0xir2 = _0xhq1:FindFirstChild("HumanoidRootPart")
    if not _0xir2 then return end
    
    local _0xjs3 = _0xhq1:FindFirstChildOfClass("Humanoid")
    if _0xjs3 then
        _0xjs3.PlatformStand = true
    end
    
    _0xen8 = _0x2b:BindToRenderStep("FlySystem", Enum.RenderPriority.Last.Value, function()
        if not _0xfo9 then
            _0xkt4()
            return
        end
        
        local _0xlu5 = _0xtc.Movement.FlySpeed
        local _0xmv6 = _0xcl.CFrame.LookVector
        local _0xnw7 = _0xcl.CFrame.RightVector
        local _0xox8 = _0xcl.CFrame.UpVector
        
        local _0xpy9 = Vector3.new()
        
        if _0x3c:IsKeyDown(Enum.KeyCode.W) then
            _0xpy9 = _0xpy9 + _0xmv6
        end
        if _0x3c:IsKeyDown(Enum.KeyCode.S) then
            _0xpy9 = _0xpy9 - _0xmv6
        end
        if _0x3c:IsKeyDown(Enum.KeyCode.A) then
            _0xpy9 = _0xpy9 - _0xnw7
        end
        if _0x3c:IsKeyDown(Enum.KeyCode.D) then
            _0xpy9 = _0xpy9 + _0xnw7
        end
        if _0x3c:IsKeyDown(Enum.KeyCode.Space) then
            _0xpy9 = _0xpy9 + _0xox8
        end
        if _0x3c:IsKeyDown(Enum.KeyCode.LeftShift) then
            _0xpy9 = _0xpy9 - _0xox8
        end
        
        if _0xpy9.Magnitude > 0 then
            _0xpy9 = _0xpy9.Unit * _0xlu5
            _0xir2.Velocity = _0xpy9
        else
            _0xir2.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function _0xkt4()
    if _0xen8 then
        _0x2b:UnbindFromRenderStep("FlySystem")
        _0xen8 = nil
    end
    local _0xqz0 = _0xdm.Character
    if _0xqz0 then
        local _0xra1 = _0xqz0:FindFirstChildOfClass("Humanoid")
        if _0xra1 then
            _0xra1.PlatformStand = false
        end
        local _0xsb2 = _0xqz0:FindFirstChild("HumanoidRootPart")
        if _0xsb2 then
            _0xsb2.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

local function _0xtc3()
    _0xfo9 = not _0xfo9
    if _0xfo9 then
        _0xgp0()
        _0x6f:SetCore("SendNotification", {
            Title = "Raven Cheats",
            Text = "Flight enabled",
            Duration = 1,
        })
    else
        _0xkt4()
        _0x6f:SetCore("SendNotification", {
            Title = "Raven Cheats",
            Text = "Flight disabled",
            Duration = 1,
        })
    end
    _0xtc.Movement.Fly = _0xfo9
    if Toggles and Toggles.FlyToggle then
        pcall(function() Toggles.FlyToggle:SetValue(_0xfo9) end)
    end
end

_0x3c.InputBegan:Connect(function(_0xud4, _0xve5)
    if _0xve5 then return end
    local _0xwf6 = _0xtc.Movement.FlyKeybind
    if not _0xwf6 then return end
    
    if typeof(_0xwf6) == "EnumItem" then
        if _0xud4.KeyCode == _0xwf6 or _0xud4.UserInputType == _0xwf6 then
            _0xtc3()
        end
    elseif typeof(_0xwf6) == "string" then
        if _0xwf6 == "MouseButton2" and _0xud4.UserInputType == Enum.UserInputType.MouseButton2 then
            _0xtc3()
        elseif _0xwf6 == "MouseButton1" and _0xud4.UserInputType == Enum.UserInputType.MouseButton1 then
            _0xtc3()
        else
            pcall(function()
                local _0xgx7 = Enum.KeyCode[_0xwf6]
                if _0xgx7 and _0xud4.KeyCode == _0xgx7 then
                    _0xtc3()
                end
            end)
        end
    end
end)

-- ================================================
--  OBFUSCATED NOCLIP
-- ================================================

local _0xyh8 = nil

local function _0xzi9()
    if _0xyh8 then return end
    
    _0xyh8 = _0x2b:BindToRenderStep("NoclipSystem", Enum.RenderPriority.Last.Value, function()
        if not _0xtc.Movement.Noclip then
            _0xaj0()
            return
        end
        
        local _0xbk1 = _0xdm.Character
        if not _0xbk1 then return end
        
        for _, _0xcl2 in ipairs(_0xbk1:GetDescendants()) do
            if _0xcl2:IsA("BasePart") then
                _0xcl2.CanCollide = false
            end
        end
    end)
end

local function _0xaj0()
    if _0xyh8 then
        _0x2b:UnbindFromRenderStep("NoclipSystem")
        _0xyh8 = nil
    end
    
    local _0xdm3 = _0xdm.Character
    if _0xdm3 then
        for _, _0xen4 in ipairs(_0xdm3:GetDescendants()) do
            if _0xen4:IsA("BasePart") then
                _0xen4.CanCollide = true
            end
        end
    end
end

-- ================================================
--  OBFUSCATED VISUALS
-- ================================================

local function _0xfo5()
    if _0xtc.Visuals.FullBright then
        _0x5e.Ambient = Color3.fromRGB(255, 255, 255)
        _0x5e.Brightness = 2
        _0x5e.GlobalShadows = false
    else
        _0x5e.Ambient = Color3.fromRGB(128, 128, 128)
        _0x5e.Brightness = 1
        _0x5e.GlobalShadows = true
    end
    
    if _0xtc.Visuals.NoFog then
        _0x5e.FogEnd = 100000
        _0x5e.FogStart = 0
    else
        _0x5e.FogEnd = 1000
        _0x5e.FogStart = 0
    end
end

-- ================================================
--  OBFUSCATED PLAYER MANAGEMENT
-- ================================================

local function _0xgp6(_0xhq7)
    _0xhq9(_0xhq7)
    _0xhq7.CharacterAdded:Connect(function()
        task.wait(0.5)
        local _0xir8 = _0xwf8[_0xhq7]
        if _0xir8 and _0xir8.Chams then
            _0xir8.Chams:Destroy()
            _0xir8.Chams = nil
        end
    end)
end

for _, _0xjs9 in ipairs(_0x1a:GetPlayers()) do
    if _0xjs9 ~= _0xdm then _0xgp6(_0xjs9) end
end
_0x1a.PlayerAdded:Connect(_0xgp6)
_0x1a.PlayerRemoving:Connect(_0xox6)

-- ================================================
--  OBFUSCATED RENDER LOOPS
-- ================================================

_0x2b.RenderStepped:Connect(function()
    _0xcl = _0x4d.CurrentCamera
    pcall(_0xkt2)
    pcall(_0xnw7)
    pcall(_0xnw1)
    pcall(_0xfo5)
    pcall(_0xra5)
end)

_0x2b:BindToRenderStep("RavenAim", Enum.RenderPriority.Last.Value, function()
    _0xcl = _0x4d.CurrentCamera
    pcall(_0xpy7)
end)

-- ================================================
--  OBFUSCATED UNLOCK ALL
-- ================================================

local function _0xkt0()
    print("[Raven] Starting Unlock All...")
    
    _0x6f:SetCore("SendNotification", {
        Title = "Raven Cheats",
        Text = "Unlocking all items...",
        Duration = 2,
    })
    
    task.wait(1)
    
    local function _0xlu1()
        local _0xmv2 = _0xaj:FindFirstChild("RemoteEvents") or _0xaj
        for _, _0xnw3 in pairs(_0xmv2:GetChildren()) do
            if _0xnw3:IsA("RemoteEvent") then
                local _0xox4 = _0xnw3.Name:lower()
                if _0xox4:find("unlock") or _0xox4:find("purchase") or _0xox4:find("buy") or 
                   _0xox4:find("claim") or _0xox4:find("reward") or _0xox4:find("skin") or
                   _0xox4:find("charm") or _0xox4:find("wrap") or _0xox4:find("finisher") then
                    pcall(function()
                        _0xnw3:FireServer()
                        _0xnw3:FireServer(_0xdm)
                        print("[Raven] Fired remote: " .. _0xnw3.Name)
                    end)
                end
            end
        end
    end
    
    pcall(_0xlu1)
    task.wait(0.5)
    
    local function _0xpy5()
        local _0xqz6 = _0xdm:FindFirstChild("DataStore") or _0xdm:FindFirstChild("PlayerData") or _0xdm:FindFirstChild("Data")
        if _0xqz6 then
            for _, _0xra7 in pairs(_0xqz6:GetChildren()) do
                local _0xsb8 = _0xra7.Name:lower()
                if _0xsb8:find("skin") or _0xsb8:find("charm") or _0xsb8:find("wrap") or 
                   _0xsb8:find("finisher") or _0xsb8:find("emote") or _0xsb8:find("badge") or
                   _0xsb8:find("cosmetic") or _0xsb8:find("owned") or _0xsb8:find("unlock") then
                    if _0xra7:IsA("BoolValue") then
                        _0xra7.Value = true
                        print("[Raven] Unlocked: " .. _0xra7.Name)
                    elseif _0xra7:IsA("NumberValue") or _0xra7:IsA("IntValue") then
                        _0xra7.Value = 999999999
                        print("[Raven] Set max: " .. _0xra7.Name)
                    end
                end
            end
        end
    end
    
    pcall(_0xpy5)
    task.wait(0.5)
    
    local function _0xtc9()
        local _0xud0 = _0xdm:FindFirstChild("Inventory") or _0xdm:FindFirstChild("Items")
        if _0xud0 then
            for _, _0xve1 in pairs(_0xud0:GetChildren()) do
                if _0xve1:IsA("BoolValue") then
                    _0xve1.Value = true
                    print("[Raven] Unlocked inventory: " .. _0xve1.Name)
                elseif _0xve1:IsA("NumberValue") or _0xve1:IsA("IntValue") then
                    _0xve1.Value = 999999999
                    print("[Raven] Set inventory max: " .. _0xve1.Name)
                end
            end
        end
    end
    
    pcall(_0xtc9)
    task.wait(0.5)
    
    local function _0xwf2()
        local _0xgx3 = _0xdm.PlayerGui
        if not _0xgx3 then return end
        
        for _, _0xyh4 in pairs(_0xgx3:GetChildren()) do
            if _0xyh4:IsA("ScreenGui") then
                for _, _0xzi5 in pairs(_0xyh4:GetDescendants()) do
                    if _0xzi5:IsA("TextButton") or _0xzi5:IsA("ImageButton") then
                        local _0xaj6 = _0xzi5.Name:lower()
                        if _0xaj6:find("buy") or _0xaj6:find("purchase") or _0xaj6:find("unlock") or 
                           _0xaj6:find("claim") or _0xaj6:find("collect") or _0xaj6:find("reward") then
                            pcall(function()
                                _0xzi5:Activate()
                                _0xzi5:Click()
                                _0xzi5.MouseButton1Click:Fire()
                                print("[Raven] Clicked: " .. _0xzi5.Name)
                            end)
                        end
                    end
                end
            end
        end
    end
    
    pcall(_0xwf2)
    task.wait(1)
    
    local function _0xbk7()
        for _, _0xcl8 in pairs(_0xdm:GetDescendants()) do
            if _0xcl8:IsA("BoolValue") then
                local _0xdm9 = _0xcl8.Name:lower()
                if _0xdm9:find("skin") or _0xdm9:find("charm") or _0xdm9:find("wrap") or 
                   _0xdm9:find("finisher") or _0xdm9:find("emote") or _0xdm9:find("badge") or
                   _0xdm9:find("cosmetic") or _0xdm9:find("owned") or _0xdm9:find("unlock") then
                    _0xcl8.Value = true
                    print("[Raven] Spoofed: " .. _0xcl8.Name)
                end
            elseif _0xcl8:IsA("NumberValue") or _0xcl8:IsA("IntValue") then
                local _0xen0 = _0xcl8.Name:lower()
                if _0xen0:find("coin") or _0xen0:find("cash") or _0xen0:find("currency") then
                    _0xcl8.Value = 999999999
                    print("[Raven] Set max: " .. _0xcl8.Name)
                end
            end
        end
    end
    
    pcall(_0xbk7)
    task.wait(0.5)
    
    local function _0xfo1()
        local _0xgp2 = _0xdm.PlayerGui
        if not _0xgp2 then return end
        
        for _, _0xhq3 in pairs(_0xgp2:GetChildren()) do
            if _0xhq3:IsA("ScreenGui") then
                for _, _0xir4 in pairs(_0xhq3:GetDescendants()) do
                    if _0xir4:IsA("TextButton") or _0xir4:IsA("ImageButton") then
                        local _0xjs5 = _0xir4.Name:lower()
                        if _0xjs5:find("claim") or _0xjs5:find("collect") or _0xjs5:find("reward") then
                            pcall(function()
                                _0xir4:Activate()
                                _0xir4:Click()
                                _0xir4.MouseButton1Click:Fire()
                                print("[Raven] Claimed: " .. _0xir4.Name)
                            end)
                        end
                    end
                end
            end
        end
    end
    
    pcall(_0xfo1)
    
    task.wait(1)
    _0x6f:SetCore("SendNotification", {
        Title = "Raven Cheats",
        Text = "Unlock All completed! Check your inventory.",
        Duration = 3,
    })
    
    print("[Raven] Unlock All completed!")
end

-- ================================================
--  OBFUSCATED USER INTERFACE
-- ================================================

local _0xkt6 = _0xen:CreateWindow({
    Title = "Raven Cheats",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
})

pcall(function()
    if _0xkt6 and _0xkt6.Holder then
        local _0xlu7 = Instance.new("Frame")
        _0xlu7.Name = "RavenLogoContainer"
        _0xlu7.BackgroundTransparency = 1
        _0xlu7.AnchorPoint = Vector2.new(0, 1)
        _0xlu7.Position = UDim2.new(0, 12, 1, -12)
        _0xlu7.Size = UDim2.new(0, 155, 0, 46)
        _0xlu7.ZIndex = 5
        
        local _0xmv8 = Instance.new("Frame")
        _0xmv8.Name = "GlassBackground"
        _0xmv8.BackgroundColor3 = Color3.fromRGB(18, 16, 22)
        _0xmv8.BackgroundTransparency = 0.35
        _0xmv8.BorderSizePixel = 0
        _0xmv8.Size = UDim2.new(1, 0, 1, 0)
        _0xmv8.ZIndex = 5
        _0xmv8.Parent = _0xlu7
        
        local _0xnw9 = Instance.new("UICorner")
        _0xnw9.CornerRadius = UDim.new(0, 8)
        _0xnw9.Parent = _0xmv8
        
        local _0xox0 = Instance.new("UIStroke")
        _0xox0.Color = _0xlu
        _0xox0.Transparency = 0.4
        _0xox0.Thickness = 1.2
        _0xox0.Parent = _0xmv8
        
        local _0xpy1 = Instance.new("Frame")
        _0xpy1.Name = "IconFrame"
        _0xpy1.BackgroundTransparency = 1
        _0xpy1.Position = UDim2.new(0, 5, 0.5, -18)
        _0xpy1.Size = UDim2.new(0, 36, 0, 36)
        _0xpy1.ZIndex = 6
        _0xpy1.Parent = _0xlu7
        
        local _0xqz2 = Instance.new("TextLabel")
        _0xqz2.Name = "RavenLogoText"
        _0xqz2.BackgroundTransparency = 1
        _0xqz2.Size = UDim2.new(1, 0, 1, 0)
        _0xqz2.Text = ""
        _0xqz2.TextColor3 = _0xnw
        _0xqz2.TextSize = 32
        _0xqz2.Font = Enum.Font.Gotham
        _0xqz2.ZIndex = 6
        _0xqz2.Parent = _0xpy1
        
        local _0xra3 = Instance.new("Frame")
        _0xra3.Name = "TextHolder"
        _0xra3.BackgroundTransparency = 1
        _0xra3.Position = UDim2.new(0, 46, 0, 4)
        _0xra3.Size = UDim2.new(1, -50, 1, -8)
        _0xra3.ZIndex = 6
        _0xra3.Parent = _0xlu7
        
        local _0xsb4 = Instance.new("TextLabel")
        _0xsb4.Name = "BrandTitle"
        _0xsb4.BackgroundTransparency = 1
        _0xsb4.Size = UDim2.new(1, 0, 0, 18)
        _0xsb4.Font = Enum.Font.GothamBold
        _0xsb4.Text = "RAVEN CHEATS"
        _0xsb4.TextColor3 = _0xox
        _0xsb4.TextSize = 12
        _0xsb4.TextXAlignment = Enum.TextXAlignment.Left
        _0xsb4.ZIndex = 6
        _0xsb4.Parent = _0xra3
        
        local _0xtc5 = Instance.new("TextLabel")
        _0xtc5.Name = "BrandSubtitle"
        _0xtc5.BackgroundTransparency = 1
        _0xtc5.Position = UDim2.new(0, 0, 0, 17)
        _0xtc5.Size = UDim2.new(1, 0, 0, 16)
        _0xtc5.Font = Enum.Font.GothamMedium
        _0xtc5.Text = "RIVALS SUITE"
        _0xtc5.TextColor3 = _0xnw
        _0xtc5.TextSize = 9
        _0xtc5.TextXAlignment = Enum.TextXAlignment.Left
        _0xtc5.ZIndex = 6
        _0xtc5.Parent = _0xra3
        
        _0xlu7.Parent = _0xkt6.Holder
    end
end)

local _0xud6 = {
    ESP = _0xkt6:AddTab("ESP"),
    Aim = _0xkt6:AddTab("Aim"),
    Util = _0xkt6:AddTab("Utils"),
    Move = _0xkt6:AddTab("Move"),
    Vis = _0xkt6:AddTab("Visuals"),
    Settings = _0xkt6:AddTab("Settings"),
}

_0xsb()
_0xox2()

task.spawn(function()
    task.wait(0.2)
    _0xsb()
end)

-- =============================================
-- ESP TAB
-- =============================================
local _0xve7 = _0xud6.ESP:AddLeftGroupbox("ESP Controls")

_0xve7:AddToggle("ESPOn", { Text = "Enable", Default = _0xtc.ESP.On })
Toggles.ESPOn:OnChanged(function(v) _0xtc.ESP.On = v end)

_0xve7:AddSlider("ESPDist", { Text = "Max Dist", Default = _0xtc.ESP.MaxDist, Min = 50, Max = 5000, Rounding = 0 })
Options.ESPDist:OnChanged(function(v) _0xtc.ESP.MaxDist = v end)

_0xve7:AddToggle("ESPSkel", { Text = "Skeleton", Default = _0xtc.ESP.Skel })
Toggles.ESPSkel:OnChanged(function(v) _0xtc.ESP.Skel = v end)
Toggles.ESPSkel:AddColorPicker("ESPSkelCol", { Default = _0xtc.ESP.SkelColor, Title = "Color" })
Options.ESPSkelCol:OnChanged(function(v) _0xtc.ESP.SkelColor = v end)

_0xve7:AddToggle("ESPChams", { Text = "Chams", Default = _0xtc.ESP.Chams })
Toggles.ESPChams:OnChanged(function(v) _0xtc.ESP.Chams = v end)
Toggles.ESPChams:AddColorPicker("ESPChamsCol", { Default = _0xtc.ESP.ChamsColor, Title = "Color" })
Options.ESPChamsCol:OnChanged(function(v) _0xtc.ESP.ChamsColor = v end)

_0xve7:AddToggle("ESPOffscreen", { Text = "Arrows", Default = _0xtc.ESP.OffscreenArrows })
Toggles.ESPOffscreen:OnChanged(function(v) _0xtc.ESP.OffscreenArrows = v end)
Toggles.ESPOffscreen:AddColorPicker("ESPOffscreenCol", { Default = _0xtc.ESP.OffscreenArrowColor, Title = "Color" })
Options.ESPOffscreenCol:OnChanged(function(v) _0xtc.ESP.OffscreenArrowColor = v end)

-- =============================================
-- AIM TAB
-- =============================================
local _0xwf8 = _0xud6.Aim:AddLeftGroupbox("Aimbot Controls")

_0xwf8:AddToggle("AimOn", { Text = "Enable", Default = _0xtc.Aim.On })
Toggles.AimOn:OnChanged(function(v) _0xtc.Aim.On = v end)
Toggles.AimOn:AddKeyPicker("AimKeyPicker", { Default = "MouseButton2", Text = "Aimbot Key", NoUI = false })
Options.AimKeyPicker:OnChanged(function(v)
    _0xtc.Aim.AimKey = Options.AimKeyPicker.Value
end)

_0xwf8:AddToggle("AimWall", { Text = "Wall Check", Default = _0xtc.Aim.WallCheck })
Toggles.AimWall:OnChanged(function(v) _0xtc.Aim.WallCheck = v end)

_0xwf8:AddDropdown("AimPart", { Values = {"Head", "HumanoidRootPart", "UpperTorso"}, Default = 1, Text = "Hitbox" })
Options.AimPart:OnChanged(function(v) _0xtc.Aim.Part = v end)

_0xwf8:AddToggle("ShowFOV", { Text = "Show FOV", Default = _0xtc.Aim.ShowFOV })
Toggles.ShowFOV:OnChanged(function(v) _0xtc.Aim.ShowFOV = v end)
Toggles.ShowFOV:AddColorPicker("FOVCol", { Default = _0xtc.Aim.FOVColor, Title = "Color" })
Options.FOVCol:OnChanged(function(v) _0xtc.Aim.FOVColor = v end)

_0xwf8:AddSlider("AimFOV", { Text = "FOV Radius", Default = _0xtc.Aim.FOV, Min = 10, Max = 800, Rounding = 0 })
Options.AimFOV:OnChanged(function(v) _0xtc.Aim.FOV = v end)

_0xwf8:AddSlider("AimSmooth", { Text = "Smooth", Default = _0xtc.Aim.Smoothness, Min = 0, Max = 1, Rounding = 2 })
Options.AimSmooth:OnChanged(function(v) _0xtc.Aim.Smoothness = v end)

_0xwf8:AddSlider("AimPred", { Text = "Prediction", Default = _0xtc.Aim.Prediction, Min = 0, Max = 2, Rounding = 2 })
Options.AimPred:OnChanged(function(v) _0xtc.Aim.Prediction = v end)

-- =============================================
-- UTILS TAB
-- =============================================
local _0xgx9 = _0xud6.Util:AddLeftGroupbox("Target Teleportation")

_0xgx9:AddDropdown("TargetDropdown", { Values = _0xwf4(), Default = 1, Text = "Target", Multi = false })
Options.TargetDropdown:OnChanged(function(v) _0xtc.TargetUtility.SelectedTarget = v end)

_0xgx9:AddButton("Refresh List", function()
    Options.TargetDropdown:SetValues(_0xwf4())
    _0x6f:SetCore("SendNotification", {
        Title = "Raven Cheats",
        Text = "Player list updated.",
        Duration = 2,
    })
end)

_0xgx9:AddSlider("HeightOffsetSlider", { Text = "Height Offset", Default = _0xtc.TargetUtility.HeightOffset, Min = 0, Max = 20, Rounding = 1 })
Options.HeightOffsetSlider:OnChanged(function(v) _0xtc.TargetUtility.HeightOffset = v end)

_0xgx9:AddToggle("StickyTP", { Text = "Enable TP", Default = _0xtc.TargetUtility.StickyTP })
Toggles.StickyTP:OnChanged(function(v) _0xtc.TargetUtility.StickyTP = v end)

-- =============================================
-- TEAM CHECK IN UTILS TAB
-- =============================================
local _0xyh0 = _0xud6.Util:AddRightGroupbox("Team Settings")

_0xyh0:AddToggle("TeamCheckToggle", { 
    Text = "Enable Team Check", 
    Default = _0xtc.TargetUtility.TeamCheck,
    Tooltip = "ON: Skips teammates | OFF: Aims at everyone"
})
Toggles.TeamCheckToggle:OnChanged(function(v)
    _0xtc.TargetUtility.TeamCheck = v
    _0x6f:SetCore("SendNotification", {
        Title = "Raven Cheats",
        Text = v and "Team Check ENABLED - Skipping teammates" or "Team Check DISABLED - Aiming at everyone",
        Duration = 2,
    })
end)

-- =============================================
-- UNLOCK ALL BUTTON
-- =============================================
local _0xzi1 = _0xud6.Util:AddRightGroupbox("Unlock All")

_0xzi1:AddButton("UNLOCK ALL", function()
    _0x6f:SetCore("SendNotification", {
        Title = "Raven Cheats",
        Text = "Starting Unlock All... Please wait.",
        Duration = 2,
    })
    task.spawn(function()
        _0xkt0()
    end)
end)

-- =============================================
-- MOVE TAB
-- =============================================
local _0xaj2 = _0xud6.Move:AddLeftGroupbox("Locomotion Controls")

_0xaj2:AddToggle("FlyToggle", { Text = "Flight", Default = _0xtc.Movement.Fly })
Toggles.FlyToggle:OnChanged(function(v)
    if _0xfo9 ~= v then
        _0xtc3()
    end
end)
Toggles.FlyToggle:AddKeyPicker("FlyKeybindPicker", { Default = "F", Text = "Flight Hotkey", NoUI = false })
Options.FlyKeybindPicker:OnChanged(function(v)
    _0xtc.Movement.FlyKeybind = Options.FlyKeybindPicker.Value
end)

_0xaj2:AddSlider("FlySpeed", { Text = "Flight Speed", Default = _0xtc.Movement.FlySpeed, Min = 10, Max = 300, Rounding = 0 })
Options.FlySpeed:OnChanged(function(v) _0xtc.Movement.FlySpeed = v end)

_0xaj2:AddToggle("SpeedToggle", { Text = "Speed Hack", Default = _0xtc.Movement.SpeedHack })
Toggles.SpeedToggle:OnChanged(function(v) _0xtc.Movement.SpeedHack = v end)

_0xaj2:AddSlider("SpeedVal", { Text = "Speed Factor", Default = _0xtc.Movement.SpeedValue, Min = 16, Max = 100, Rounding = 0 })
Options.SpeedVal:OnChanged(function(v) _0xtc.Movement.SpeedValue = v end)

_0xaj2:AddToggle("NoclipToggle", { Text = "Noclip", Default = _0xtc.Movement.Noclip })
Toggles.NoclipToggle:OnChanged(function(v)
    _0xtc.Movement.Noclip = v
    if v then _0xzi9() else _0xaj0() end
end)

-- =============================================
-- VISUALS TAB (WITH THIRD PERSON)
-- =============================================
local _0xbk3 = _0xud6.Vis:AddLeftGroupbox("Environment & Crosshair")

_bk3:AddToggle("FullBright", { Text = "Fullbright", Default = _0xtc.Visuals.FullBright })
Toggles.FullBright:OnChanged(function(v) _0xtc.Visuals.FullBright = v end)

_bk3:AddToggle("NoFog", { Text = "No Fog", Default = _0xtc.Visuals.NoFog })
Toggles.NoFog:OnChanged(function(v) _0xtc.Visuals.NoFog = v end)

_bk3:AddToggle("ThirdPerson", { 
    Text = "Third Person", 
    Default = _0xtc.Visuals.ThirdPerson,
    Tooltip = "Toggle third person camera"
})
Toggles.ThirdPerson:OnChanged(function(v)
    _0xtc.Visuals.ThirdPerson = v
    _0xud = v
    if v then
        _0xgx()
    else
        _0xgx()
    end
end)

_bk3:AddSlider("ThirdPersonDist", { 
    Text = "Distance", 
    Default = _0xtc.Visuals.ThirdPersonDistance, 
    Min = 3, 
    Max = 30, 
    Rounding = 1,
    Tooltip = "How far behind the player the camera sits"
})
Options.ThirdPersonDist:OnChanged(function(v)
    _0xtc.Visuals.ThirdPersonDistance = v
    _0xve = v
end)

_bk3:AddToggle("CrosshairToggle", { Text = "Crosshair", Default = _0xtc.Visuals.Crosshair })
Toggles.CrosshairToggle:OnChanged(function(v) _0xtc.Visuals.Crosshair = v end)
Toggles.CrosshairToggle:AddColorPicker("CrosshairCol", { Default = _0xtc.Visuals.CrosshairColor, Title = "Color" })
Options.CrosshairCol:OnChanged(function(v) _0xtc.Visuals.CrosshairColor = v end)

_bk3:AddSlider("CrosshairSize", { Text = "Length", Default = _0xtc.Visuals.CrosshairSize, Min = 4, Max = 30, Rounding = 0 })
Options.CrosshairSize:OnChanged(function(v) _0xtc.Visuals.CrosshairSize = v end)

_bk3:AddSlider("CrosshairGap", { Text = "Spacing", Default = _0xtc.Visuals.CrosshairGap, Min = 1, Max = 15, Rounding = 0 })
Options.CrosshairGap:OnChanged(function(v) _0xtc.Visuals.CrosshairGap = v end)

_bk3:AddSlider("CrosshairSpin", { Text = "Spin Speed", Default = _0xtc.Visuals.CrosshairSpinSpeed, Min = 0.1, Max = 5, Rounding = 1 })
Options.CrosshairSpin:OnChanged(function(v) _0xtc.Visuals.CrosshairSpinSpeed = v end)

-- =============================================
-- SETTINGS TAB
-- =============================================
_0xen:SetWatermark("Raven Cheats")
_0xgp:SetLibrary(_0xen)
_0xfo:SetLibrary(_0xen)
_0xgp:ApplyToTab(_0xud6.Settings)
_0xfo:BuildConfigSection(_0xud6.Settings)
_0xfo:LoadAutoloadConfig()

-- =============================================
-- WATERMARK / KEYBIND DISPLAY
-- =============================================
print("[Raven Cheats] Loaded successfully!")
print("[Raven Cheats] Press Right Shift to toggle menu.")
print("[Raven Cheats] Team Check: " .. (_0xtc.TargetUtility.TeamCheck and "ON (skips teammates)" or "OFF (aims at everyone)"))
print("[Raven Cheats] Third Person: " .. (_0xtc.Visuals.ThirdPerson and "ON" or "OFF"))
