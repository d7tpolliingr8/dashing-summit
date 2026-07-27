--[[
    Raven Cheats Loader v3.0
    Premium UI - Red/Black/Yellow Theme
    License Key System - RAVEN-XXXXXX-XXXXXX
]]

-- ======================================================================
--  CONFIGURATION
-- ======================================================================

local SCRIPT_URL = "https://raw.githubusercontent.com/d7tpolliingr8/dashing-summit/main/rivalsaimwh.lua"
local LOADER_VERSION = "v3.0"
local DISCORD_INVITE = "https://discord.gg/XJtYWy9jgU"

-- ======================================================================
--  VALID KEYS (Add your keys here)
-- ======================================================================

local VALID_KEYS = {
    -- Format: ["RAVEN-XXXXXX-XXXXXX"] = true
    ["RAVEN-A7K2M9-4P8Q1R"] = true,
    ["RAVEN-B3X5N7-L2W6K9"] = true,
    ["RAVEN-C8V4R2-P6M9T3"] = true,
    ["RAVEN-D9W6S3-Q8N4M2"] = true,
    -- Add more keys as you sell them
}

-- ======================================================================
--  SERVICES
-- ======================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- ======================================================================
--  COLORS
-- ======================================================================

local Colors = {
    Red = Color3.fromRGB(220, 20, 20),
    RedDark = Color3.fromRGB(120, 10, 10),
    RedGlow = Color3.fromRGB(255, 50, 50),
    Yellow = Color3.fromRGB(255, 215, 0),
    YellowDim = Color3.fromRGB(180, 150, 0),
    White = Color3.fromRGB(255, 255, 255),
    Black = Color3.fromRGB(0, 0, 0),
    Gray = Color3.fromRGB(180, 180, 180),
    DarkGray = Color3.fromRGB(40, 40, 45),
    DarkBG = Color3.fromRGB(14, 14, 18),
    DarkerBG = Color3.fromRGB(10, 10, 14),
}

-- ======================================================================
--  CREATE GUI
-- ======================================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RavenLoader"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999

-- ======================================================================
--  ANIMATED BACKGROUND
-- ======================================================================

local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Colors.DarkerBG
background.BackgroundTransparency = 0.03
background.Parent = screenGui

-- Animated gradient overlay
local gradient = Instance.new("Frame")
gradient.Size = UDim2.new(1, 0, 1, 0)
gradient.BackgroundColor3 = Colors.Red
gradient.BackgroundTransparency = 0.95
gradient.BorderSizePixel = 0
gradient.Parent = background

-- Floating particles
local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.Parent = background

local particles = {}
for i = 1, 50 do
    local particle = Instance.new("Frame")
    local size = math.random(2, 4)
    particle.Size = UDim2.new(0, size, 0, size)
    particle.Position = UDim2.new(math.random() / 2, 0, math.random() / 2, 0)
    particle.BackgroundColor3 = Colors.Yellow
    particle.BackgroundTransparency = math.random(50, 90) / 100
    particle.BorderSizePixel = 0
    particle.Parent = particleContainer
    table.insert(particles, {
        frame = particle,
        speed = math.random(2, 8) / 100,
        dir = math.random(1, 4),
        alpha = math.random(50, 90) / 100
    })
end

task.spawn(function()
    while task.wait(0.05) do
        for _, p in pairs(particles) do
            local x = p.frame.Position.X.Scale + p.speed * 0.005
            local y = p.frame.Position.Y.Scale + p.speed * 0.003
            if x > 1 then x = 0 end
            if y > 1 then y = 0 end
            p.frame.Position = UDim2.new(x, 0, y, 0)
        end
    end
end)

-- ======================================================================
--  MAIN CONTAINER (Glassmorphism)
-- ======================================================================

local container = Instance.new("Frame")
container.Size = UDim2.new(0, 480, 0, 540)
container.Position = UDim2.new(0.5, -240, 0.5, -270)
container.BackgroundColor3 = Colors.DarkBG
container.BackgroundTransparency = 0.08
container.BorderSizePixel = 0
container.Parent = background

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 16)
containerCorner.Parent = container

-- Container Border Glow
local borderGlow = Instance.new("Frame")
borderGlow.Size = UDim2.new(1.02, 0, 1.02, 0)
borderGlow.Position = UDim2.new(-0.01, 0, -0.01, 0)
borderGlow.BackgroundColor3 = Colors.Red
borderGlow.BackgroundTransparency = 0.85
borderGlow.BorderSizePixel = 0
borderGlow.Parent = container

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 18)
borderCorner.Parent = borderGlow

-- Inner border
local innerBorder = Instance.new("Frame")
innerBorder.Size = UDim2.new(1, 0, 1, 0)
innerBorder.BackgroundTransparency = 1
innerBorder.BorderSizePixel = 1
innerBorder.BorderColor3 = Colors.Red
innerBorder.BorderColor3 = Colors.Red
innerBorder.BorderTransparency = 0.7
innerBorder.Parent = container

local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0, 16)
innerCorner.Parent = innerBorder

-- ======================================================================
--  HEADER
-- ======================================================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 100)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Colors.Red
header.BackgroundTransparency = 0.15
header.BorderSizePixel = 0
header.Parent = container

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

-- Animated header glow line
local glowLine = Instance.new("Frame")
glowLine.Size = UDim2.new(0.9, 0, 0, 2)
glowLine.Position = UDim2.new(0.05, 0, 0.95, 0)
glowLine.BackgroundColor3 = Colors.Yellow
glowLine.BackgroundTransparency = 0.5
glowLine.BorderSizePixel = 0
glowLine.Parent = header

task.spawn(function()
    while task.wait(0.05) do
        local t = tick() % 2
        local alpha = 0.3 + (math.sin(t * math.pi) * 0.5)
        glowLine.BackgroundTransparency = 1 - alpha
    end
end)

-- ======================================================================
--  RAVEN ICON
-- ======================================================================

local iconContainer = Instance.new("Frame")
iconContainer.Size = UDim2.new(0, 70, 0, 70)
iconContainer.Position = UDim2.new(0.04, 0, 0.15, 0)
iconContainer.BackgroundColor3 = Colors.Red
iconContainer.BackgroundTransparency = 0.15
iconContainer.BorderSizePixel = 2
iconContainer.BorderColor3 = Colors.Yellow
iconContainer.Parent = header

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 14)
iconCorner.Parent = iconContainer

-- Icon pulse animation
task.spawn(function()
    while task.wait(0.05) do
        local t = tick() % 2
        local alpha = 0.15 + (math.sin(t * math.pi) * 0.15)
        iconContainer.BackgroundTransparency = alpha
    end
end)

local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(1, 0, 1, 0)
iconText.BackgroundTransparency = 1
iconText.Text = "🦅"
iconText.TextColor3 = Colors.Yellow
iconText.TextSize = 36
iconText.Font = Enum.Font.Gotham
iconText.Parent = iconContainer

-- ======================================================================
--  TITLE
-- ======================================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 0, 38)
title.Position = UDim2.new(0.22, 0, 0.12, 0)
title.BackgroundTransparency = 1
title.Text = "RAVEN CHEATS"
title.TextColor3 = Colors.White
title.TextSize = 32
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local titleGlow = Instance.new("TextLabel")
titleGlow.Size = UDim2.new(0.6, 0, 0, 38)
titleGlow.Position = UDim2.new(0.22, 0, 0.12, 0)
titleGlow.BackgroundTransparency = 1
titleGlow.Text = "RAVEN CHEATS"
titleGlow.TextColor3 = Colors.Red
titleGlow.TextSize = 32
titleGlow.Font = Enum.Font.GothamBold
titleGlow.TextXAlignment = Enum.TextXAlignment.Left
titleGlow.TextTransparency = 0.4
titleGlow.Parent = header

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0.6, 0, 0, 22)
subtitle.Position = UDim2.new(0.22, 0, 0.55, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "RIVALS SCRIPT • PREMIUM"
subtitle.TextColor3 = Colors.Gray
subtitle.TextSize = 13
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

-- ======================================================================
--  DIVIDER
-- ======================================================================

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0, 2)
divider.Position = UDim2.new(0.05, 0, 0.19, 0)
divider.BackgroundColor3 = Colors.Red
divider.BackgroundTransparency = 0.4
divider.BorderSizePixel = 0
divider.Parent = container

-- ======================================================================
--  KEY FORMAT INFO
-- ======================================================================

local formatLabel = Instance.new("TextLabel")
formatLabel.Size = UDim2.new(0.8, 0, 0, 25)
formatLabel.Position = UDim2.new(0.1, 0, 0.23, 0)
formatLabel.BackgroundTransparency = 1
formatLabel.Text = "🔑 Format: RAVEN-XXXXXX-XXXXXX"
formatLabel.TextColor3 = Colors.YellowDim
formatLabel.TextSize = 13
formatLabel.Font = Enum.Font.Gotham
formatLabel.TextXAlignment = Enum.TextXAlignment.Center
formatLabel.Parent = container

-- ======================================================================
--  KEY SECTION
-- ======================================================================

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0.8, 0, 0, 28)
keyLabel.Position = UDim2.new(0.1, 0, 0.28, 0)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "ENTER YOUR LICENSE KEY"
keyLabel.TextColor3 = Colors.White
keyLabel.TextSize = 14
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextXAlignment = Enum.TextXAlignment.Center
keyLabel.Parent = container

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.8, 0, 0, 45)
keyBox.Position = UDim2.new(0.1, 0, 0.34, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
keyBox.TextColor3 = Colors.White
keyBox.TextSize = 16
keyBox.Font = Enum.Font.Gotham
keyBox.PlaceholderText = "RAVEN-XXXXXX-XXXXXX"
keyBox.ClearTextOnFocus = false
keyBox.Text = ""
keyBox.Parent = container

local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0, 10)
keyBoxCorner.Parent = keyBox

local keyBoxStroke = Instance.new("UIStroke")
keyBoxStroke.Color = Colors.Red
keyBoxStroke.Transparency = 0.5
keyBoxStroke.Thickness = 1
keyBoxStroke.Parent = keyBox

-- ======================================================================
--  ACTIVATE BUTTON
-- ======================================================================

local activateBtn = Instance.new("TextButton")
activateBtn.Size = UDim2.new(0.4, 0, 0, 45)
activateBtn.Position = UDim2.new(0.3, 0, 0.48, 0)
activateBtn.BackgroundColor3 = Colors.Red
activateBtn.BackgroundTransparency = 0.15
activateBtn.TextColor3 = Colors.White
activateBtn.TextSize = 16
activateBtn.Font = Enum.Font.GothamBold
activateBtn.Text = "▶ ACTIVATE"
activateBtn.Parent = container

local actCorner = Instance.new("UICorner")
actCorner.CornerRadius = UDim.new(0, 10)
actCorner.Parent = activateBtn

local actStroke = Instance.new("UIStroke")
actStroke.Color = Colors.Red
actStroke.Transparency = 0.3
actStroke.Thickness = 1
actStroke.Parent = activateBtn

-- Hover effect
activateBtn.MouseEnter:Connect(function()
    TweenService:Create(activateBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.3
    }):Play()
    TweenService:Create(actStroke, TweenInfo.new(0.2), {
        Transparency = 0.7
    }):Play()
end)
activateBtn.MouseLeave:Connect(function()
    TweenService:Create(activateBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.15
    }):Play()
    TweenService:Create(actStroke, TweenInfo.new(0.2), {
        Transparency = 0.3
    }):Play()
end)

-- ======================================================================
--  DISCORD BUTTON
-- ======================================================================

local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0.35, 0, 0, 35)
discordBtn.Position = UDim2.new(0.325, 0, 0.60, 0)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.BackgroundTransparency = 0.15
discordBtn.TextColor3 = Colors.White
discordBtn.TextSize = 13
discordBtn.Font = Enum.Font.GothamBold
discordBtn.Text = "💬 JOIN DISCORD"
discordBtn.Parent = container

local discCorner = Instance.new("UICorner")
discCorner.CornerRadius = UDim.new(0, 10)
discCorner.Parent = discordBtn

discordBtn.MouseEnter:Connect(function()
    TweenService:Create(discordBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.35
    }):Play()
end)
discordBtn.MouseLeave:Connect(function()
    TweenService:Create(discordBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.15
    }):Play()
end)

discordBtn.MouseButton1Click:Connect(function()
    setclipboard(DISCORD_INVITE)
    statusText.Text = "✅ Discord link copied!"
    statusText.TextColor3 = Color3.fromRGB(0, 255, 100)
    task.wait(1.5)
    statusText.Text = "Enter your key to activate"
    statusText.TextColor3 = Colors.Gray
end)

-- ======================================================================
--  STATUS
-- ======================================================================

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.8, 0, 0, 25)
statusText.Position = UDim2.new(0.1, 0, 0.68, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Purchase a key on Discord"
statusText.TextColor3 = Colors.Gray
statusText.TextSize = 13
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Center
statusText.Parent = container

-- ======================================================================
--  LOADING BAR
-- ======================================================================

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.8, 0, 0, 6)
barBg.Position = UDim2.new(0.1, 0, 0.74, 0)
barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
barBg.BackgroundTransparency = 0.3
barBg.BorderSizePixel = 0
barBg.Parent = container

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 3)
barCorner.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Colors.Red
barFill.BackgroundTransparency = 0.1
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(0, 3)
barFillCorner.Parent = barFill

-- Bar glow
local barGlow = Instance.new("Frame")
barGlow.Size = UDim2.new(1, 0, 1, 10)
barGlow.Position = UDim2.new(0, 0, 0, -5)
barGlow.BackgroundColor3 = Colors.RedGlow
barGlow.BackgroundTransparency = 0.85
barGlow.BorderSizePixel = 0
barGlow.Parent = barFill

local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(0.8, 0, 0, 20)
percentText.Position = UDim2.new(0.1, 0, 0.78, 0)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Colors.Gray
percentText.TextSize = 12
percentText.Font = Enum.Font.Gotham
percentText.TextXAlignment = Enum.TextXAlignment.Center
percentText.Parent = container

-- ======================================================================
--  FEATURES
-- ======================================================================

local featureContainer = Instance.new("Frame")
featureContainer.Size = UDim2.new(0.9, 0, 0, 25)
featureContainer.Position = UDim2.new(0.05, 0, 0.83, 0)
featureContainer.BackgroundTransparency = 1
featureContainer.Parent = container

local features = {"🎯 Aimbot", "👁️ ESP", "🚀 Fly", "🛡️ Team Check"}
for i, feature in ipairs(features) do
    local fText = Instance.new("TextLabel")
    fText.Size = UDim2.new(0.25, 0, 1, 0)
    fText.Position = UDim2.new((i - 1) * 0.25, 0, 0, 0)
    fText.BackgroundTransparency = 1
    fText.Text = feature
    fText.TextColor3 = Colors.Gray
    fText.TextSize = 12
    fText.Font = Enum.Font.Gotham
    fText.TextXAlignment = Enum.TextXAlignment.Center
    fText.TextTransparency = 0.2
    fText.Parent = featureContainer
end

-- ======================================================================
--  FOOTER
-- ======================================================================

local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 1, -30)
footer.BackgroundTransparency = 1
footer.Parent = container

local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(0.4, 0, 1, 0)
versionText.Position = UDim2.new(0.05, 0, 0, 0)
versionText.BackgroundTransparency = 1
versionText.Text = "v" .. LOADER_VERSION
versionText.TextColor3 = Color3.fromRGB(60, 60, 80)
versionText.TextSize = 11
versionText.Font = Enum.Font.Gotham
versionText.TextXAlignment = Enum.TextXAlignment.Left
versionText.Parent = footer

local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0.4, 0, 1, 0)
watermark.Position = UDim2.new(0.55, 0, 0, 0)
watermark.BackgroundTransparency = 1
watermark.Text = "🦅 raven-cheats.lol"
watermark.TextColor3 = Color3.fromRGB(40, 0, 0)
watermark.TextSize = 11
watermark.Font = Enum.Font.Gotham
watermark.TextXAlignment = Enum.TextXAlignment.Right
watermark.Parent = footer

-- ======================================================================
--  ANIMATION FUNCTIONS
-- ======================================================================

local function AnimateBar(progress)
    local targetSize = UDim2.new(progress, 0, 1, 0)
    local tween = TweenService:Create(barFill, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Size = targetSize
    })
    tween:Play()
    percentText.Text = math.floor(progress * 100) .. "%"
    return tween
end

local function UpdateStatus(text, color)
    statusText.Text = text
    if color then
        statusText.TextColor3 = color
    else
        statusText.TextColor3 = Colors.Gray
    end
    print("[Raven] " .. text)
end

-- ======================================================================
--  MAIN LOADER
-- ======================================================================

local function LoadScript()
    UpdateStatus("Downloading Raven Cheats...", Colors.Yellow)
    AnimateBar(0.1)
    task.wait(0.3)
    
    UpdateStatus("Connecting to server...", Colors.YellowDim)
    AnimateBar(0.25)
    task.wait(0.3)
    
    local success, scriptContent = pcall(function()
        return game:HttpGet(SCRIPT_URL)
    end)
    
    if not success then
        UpdateStatus("❌ Download failed - Check connection", Colors.Red)
        AnimateBar(0)
        return
    end
    
    if not scriptContent or #scriptContent < 10 then
        UpdateStatus("❌ Script corrupted - Contact support", Colors.Red)
        AnimateBar(0)
        return
    end
    
    UpdateStatus("Loading Raven Cheats...", Colors.YellowDim)
    AnimateBar(0.5)
    task.wait(0.3)
    
    local compileSuccess, compiled = pcall(function()
        return loadstring(scriptContent)
    end)
    
    if not compileSuccess or type(compiled) ~= "function" then
        UpdateStatus("❌ Validation failed - Contact support", Colors.Red)
        AnimateBar(0)
        return
    end
    
    UpdateStatus("Executing Raven Cheats...", Colors.Yellow)
    AnimateBar(0.75)
    task.wait(0.3)
    
    local execSuccess, execResult = pcall(function()
        return compiled()
    end)
    
    if not execSuccess then
        UpdateStatus("❌ Execution failed - Try again", Colors.Red)
        AnimateBar(0)
        return
    end
    
    UpdateStatus("✅ Raven Cheats Loaded! Press Right Shift for menu", Color3.fromRGB(0, 255, 100))
    AnimateBar(1)
    
    -- Success glow effect
    local successGlow = Instance.new("Frame")
    successGlow.Size = UDim2.new(1, 0, 1, 0)
    successGlow.BackgroundColor3 = Colors.Yellow
    successGlow.BackgroundTransparency = 0.9
    successGlow.BorderSizePixel = 0
    successGlow.Parent = container
    
    local glowTween = TweenService:Create(successGlow, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    glowTween:Play()
    glowTween.Completed:Connect(function()
        successGlow:Destroy()
    end)
    
    task.wait(1.5)
    local fadeTween = TweenService:Create(container, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    fadeTween:Play()
    fadeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

-- ======================================================================
--  KEY VALIDATION
-- ======================================================================

local function ValidateKey()
    local inputKey = keyBox.Text
    
    -- Check if key matches format: RAVEN-XXXXXX-XXXXXX
    local function isValidFormat(key)
        local pattern = "^RAVEN%-%w+%-%w+$"
        return string.match(key, pattern) ~= nil
    end
    
    if not isValidFormat(inputKey) then
        UpdateStatus("❌ Invalid format! Use: RAVEN-XXXXXX-XXXXXX", Colors.Red)
        keyBox.Text = ""
        keyBox.PlaceholderText = "RAVEN-XXXXXX-XXXXXX"
        return
    end
    
    if VALID_KEYS[inputKey] then
        UpdateStatus("✅ Key accepted! Loading Raven Cheats...", Color3.fromRGB(0, 255, 100))
        activateBtn.Text = "✓"
        activateBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        keyBox.Text = ""
        keyBox.PlaceholderText = "Key accepted!"
        task.wait(0.3)
        LoadScript()
    else
        UpdateStatus("❌ Invalid key! Purchase one on Discord", Colors.Red)
        keyBox.Text = ""
        keyBox.PlaceholderText = "Invalid key, try again..."
        task.wait(1.5)
        keyBox.PlaceholderText = "RAVEN-XXXXXX-XXXXXX"
    end
end

-- ======================================================================
--  KEYBINDS
-- ======================================================================

activateBtn.MouseButton1Click:Connect(ValidateKey)

keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then ValidateKey() end
end)

-- ======================================================================
--  START
-- ======================================================================

print("[Raven] Loader v3.0 - Premium UI")
print("[Raven] Discord: https://discord.gg/XJtYWy9jgU")
print("[Raven] Key format: RAVEN-XXXXXX-XXXXXX")
print("[Raven] Ready")

task.wait(0.3)
keyBox:CaptureFocus()
