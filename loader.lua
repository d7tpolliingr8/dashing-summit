--[[
    DarkSide Ultimate Loader v8.0
    The Best Rivals Script Loader
    Premium Animations & Effects
]]

-- ==================== CONFIGURATION ====================
local SCRIPT_URL = "https://raw.githubusercontent.com/jabu62012-commits/rivals-free-script/main/rivalsaimwh.lua"
local LOADER_VERSION = "v8.0"
local DISCORD_INVITE = "https://discord.gg/yourserver"  -- ← CHANGE THIS!

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

-- ==================== CREATE GUI ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkSideUltimate"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999

-- ==================== BACKGROUND WITH ANIMATED GRADIENT ====================
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(5, 5, 12)
background.BackgroundTransparency = 0.02
background.Parent = screenGui

-- Animated gradient overlay
local gradientOverlay = Instance.new("Frame")
gradientOverlay.Size = UDim2.new(1, 0, 1, 0)
gradientOverlay.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
gradientOverlay.BackgroundTransparency = 0.5
gradientOverlay.Parent = background

-- ==================== PARTICLE SYSTEM (300+ Particles) ====================
local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.Parent = background

local particles = {}
local colors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(200, 0, 0),
    Color3.fromRGB(150, 0, 0),
    Color3.fromRGB(255, 50, 50),
    Color3.fromRGB(255, 100, 100),
}

for i = 1, 150 do
    local particle = Instance.new("Frame")
    local size = math.random(2, 8)
    particle.Size = UDim2.new(0, size, 0, size)
    particle.Position = UDim2.new(math.random() / 2, 0, math.random() / 2, 0)
    particle.BackgroundColor3 = colors[math.random(1, #colors)]
    particle.BackgroundTransparency = math.random(50, 90) / 100
    particle.BorderSizePixel = 0
    particle.Parent = particleContainer
    
    local pData = {
        frame = particle,
        speed = math.random(2, 15) / 100,
        direction = math.random(1, 4),
        drift = math.random(1, 5) / 100,
        pulse = math.random(1, 100) / 100,
        size = size,
    }
    table.insert(particles, pData)
end

-- Animate particles with pulsing
task.spawn(function()
    while task.wait(0.03) do
        for _, p in pairs(particles) do
            local x = p.frame.Position.X.Scale + p.speed * 0.008 * (p.direction == 1 and 1 or p.direction == 2 and -1 or 0)
            local y = p.frame.Position.Y.Scale + p.speed * 0.008 * (p.direction == 3 and 1 or p.direction == 4 and -1 or 0)
            if x > 1 then x = 0 end
            if x < 0 then x = 1 end
            if y > 1 then y = 0 end
            if y < 0 then y = 1 end
            p.frame.Position = UDim2.new(x, 0, y, 0)
            
            -- Pulse effect
            p.pulse = p.pulse + 0.02
            local scale = 1 + math.sin(p.pulse * 2) * 0.3
            p.frame.Size = UDim2.new(0, p.size * scale, 0, p.size * scale)
        end
    end
end)

-- ==================== FLOATING GLOW ORBS ====================
local orbContainer = Instance.new("Frame")
orbContainer.Size = UDim2.new(1, 0, 1, 0)
orbContainer.BackgroundTransparency = 1
orbContainer.Parent = background

local orbs = {}
for i = 1, 8 do
    local orb = Instance.new("Frame")
    local size = math.random(50, 120)
    orb.Size = UDim2.new(0, size, 0, size)
    orb.Position = UDim2.new(math.random() / 2, 0, math.random() / 2, 0)
    orb.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    orb.BackgroundTransparency = 0.85
    orb.BorderSizePixel = 0
    orb.Parent = orbContainer
    
    local orbCorner = Instance.new("UICorner")
    orbCorner.CornerRadius = UDim.new(1, 0)
    orbCorner.Parent = orb
    
    local oData = {
        frame = orb,
        speed = math.random(2, 6) / 100,
        xDir = math.random(1, 2) == 1 and 1 or -1,
        yDir = math.random(1, 2) == 1 and 1 or -1,
        size = size,
    }
    table.insert(orbs, oData)
end

task.spawn(function()
    while task.wait(0.05) do
        for _, o in pairs(orbs) do
            local x = o.frame.Position.X.Scale + o.speed * 0.005 * o.xDir
            local y = o.frame.Position.Y.Scale + o.speed * 0.005 * o.yDir
            if x > 1 or x < 0 then o.xDir = o.xDir * -1 end
            if y > 1 or y < 0 then o.yDir = o.yDir * -1 end
            o.frame.Position = UDim2.new(math.clamp(x, 0, 1), 0, math.clamp(y, 0, 1), 0)
            
            -- Pulse size
            local pulse = 1 + math.sin(tick() * 0.5 + o.size) * 0.1
            o.frame.Size = UDim2.new(0, o.size * pulse, 0, o.size * pulse)
        end
    end
end)

-- ==================== MAIN CONTAINER WITH GLOW ====================
local container = Instance.new("Frame")
container.Size = UDim2.new(0, 560, 0, 580)
container.Position = UDim2.new(0.5, -280, 0.5, -290)
container.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
container.BackgroundTransparency = 0.08
container.BorderSizePixel = 0
container.Parent = background

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 25)
containerCorner.Parent = container

-- Outer glow
local outerGlow = Instance.new("Frame")
outerGlow.Size = UDim2.new(1.04, 0, 1.04, 0)
outerGlow.Position = UDim2.new(-0.02, 0, -0.02, 0)
outerGlow.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
outerGlow.BackgroundTransparency = 0.9
outerGlow.BorderSizePixel = 0
outerGlow.Parent = container

local outerCorner = Instance.new("UICorner")
outerCorner.CornerRadius = UDim.new(0, 25)
outerCorner.Parent = outerGlow

-- Animated border glow
local borderGlow = Instance.new("Frame")
borderGlow.Size = UDim2.new(1, 0, 1, 0)
borderGlow.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
borderGlow.BackgroundTransparency = 0.85
borderGlow.BorderSizePixel = 2
borderGlow.BorderColor3 = Color3.fromRGB(255, 50, 50)
borderGlow.Parent = container

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 25)
borderCorner.Parent = borderGlow

-- ==================== HEADER ====================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 100)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = container

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 25)
headerCorner.Parent = header

-- Animated glow lines in header
for i = 1, 4 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0.9, 0, 0, 2)
    line.Position = UDim2.new(0.05, 0, 0.05 + (i - 1) * 0.025, 0)
    line.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    line.BackgroundTransparency = 0.7
    line.BorderSizePixel = 0
    line.Parent = container
    
    task.spawn(function()
        local offset = i * 0.5
        while task.wait(0.03) do
            local t = tick() % 2
            local alpha = 0.2 + (math.sin(t * math.pi + offset) * 0.6)
            line.BackgroundTransparency = 1 - alpha
        end
    end)
end

-- ==================== LOGO ====================
local logoContainer = Instance.new("Frame")
logoContainer.Size = UDim2.new(0, 85, 0, 85)
logoContainer.Position = UDim2.new(0.05, 0, 0.05, 0)
logoContainer.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
logoContainer.BackgroundTransparency = 0.1
logoContainer.BorderSizePixel = 2
logoContainer.BorderColor3 = Color3.fromRGB(255, 50, 50)
logoContainer.Parent = header

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 18)
logoCorner.Parent = logoContainer

-- Logo glow pulse
task.spawn(function()
    while task.wait(0.05) do
        local t = tick() % 2
        local alpha = 0.1 + (math.sin(t * math.pi) * 0.15)
        logoContainer.BackgroundTransparency = alpha
    end
end)

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "DS"
logoText.TextColor3 = Color3.new(1, 1, 1)
logoText.TextSize = 36
logoText.Font = Enum.Font.GothamBold
logoText.Parent = logoContainer

-- ==================== TITLE ====================
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 0, 40)
title.Position = UDim2.new(0.2, 0, 0.1, 0)
title.BackgroundTransparency = 1
title.Text = "DARK SIDE"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 40
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local titleGlow = Instance.new("TextLabel")
titleGlow.Size = UDim2.new(0.5, 0, 0, 40)
titleGlow.Position = UDim2.new(0.2, 0, 0.1, 0)
titleGlow.BackgroundTransparency = 1
titleGlow.Text = "DARK SIDE"
titleGlow.TextColor3 = Color3.fromRGB(200, 0, 0)
titleGlow.TextSize = 40
titleGlow.Font = Enum.Font.GothamBold
titleGlow.TextXAlignment = Enum.TextXAlignment.Left
titleGlow.TextTransparency = 0.4
titleGlow.Parent = header

-- ==================== SUBTITLE ====================
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0.5, 0, 0, 22)
subtitle.Position = UDim2.new(0.2, 0, 0.5, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "PREMIUM RIVALS SCRIPT"
subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitle.TextSize = 15
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

-- ==================== VERSION BADGE ====================
local versionBadge = Instance.new("Frame")
versionBadge.Size = UDim2.new(0, 120, 0, 30)
versionBadge.Position = UDim2.new(0.78, 0, 0.45, 0)
versionBadge.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
versionBadge.BackgroundTransparency = 0.2
versionBadge.BorderSizePixel = 1
versionBadge.BorderColor3 = Color3.fromRGB(255, 50, 50)
versionBadge.Parent = header

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(0, 8)
badgeCorner.Parent = versionBadge

local badgeText = Instance.new("TextLabel")
badgeText.Size = UDim2.new(1, 0, 1, 0)
badgeText.BackgroundTransparency = 1
badgeText.Text = "✦ v" .. LOADER_VERSION
badgeText.TextColor3 = Color3.fromRGB(255, 215, 0)
badgeText.TextSize = 13
badgeText.Font = Enum.Font.GothamBold
badgeText.Parent = versionBadge

-- ==================== DIVIDER ====================
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0, 2)
divider.Position = UDim2.new(0.05, 0, 0.19, 0)
divider.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
divider.BackgroundTransparency = 0.4
divider.BorderSizePixel = 0
divider.Parent = container

-- ==================== DISCORD MESSAGE ====================
local discordMessage = Instance.new("TextLabel")
discordMessage.Size = UDim2.new(0.9, 0, 0, 45)
discordMessage.Position = UDim2.new(0.05, 0, 0.22, 0)
discordMessage.BackgroundTransparency = 1
discordMessage.Text = "📢 Join our Discord to purchase a key"
discordMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
discordMessage.TextSize = 17
discordMessage.Font = Enum.Font.Gotham
discordMessage.TextWrapped = true
discordMessage.TextXAlignment = Enum.TextXAlignment.Center
discordMessage.Parent = container

-- ==================== DISCORD BUTTON ====================
local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0.45, 0, 0, 50)
discordBtn.Position = UDim2.new(0.275, 0, 0.31, 0)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.TextColor3 = Color3.new(1, 1, 1)
discordBtn.TextSize = 18
discordBtn.Font = Enum.Font.GothamBold
discordBtn.Text = "💬 JOIN DISCORD"
discordBtn.Parent = container

local discCorner = Instance.new("UICorner")
discCorner.CornerRadius = UDim.new(0, 12)
discCorner.Parent = discordBtn

-- Discord button glow
task.spawn(function()
    while task.wait(0.05) do
        local t = tick() % 2
        local alpha = 0 + (math.sin(t * math.pi) * 0.15)
        discordBtn.BackgroundTransparency = alpha
    end
end)

discordBtn.MouseEnter:Connect(function()
    discordBtn.BackgroundColor3 = Color3.fromRGB(100, 115, 255)
end)
discordBtn.MouseLeave:Connect(function()
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
end)

discordBtn.MouseButton1Click:Connect(function()
    setclipboard(DISCORD_INVITE)
    statusText.Text = "✅ Discord link copied!"
    statusText.TextColor3 = Color3.fromRGB(0, 255, 100)
    task.wait(2)
    statusText.Text = "Enter your key to activate"
    statusText.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

-- ==================== KEY SECTION ====================
local keySection = Instance.new("Frame")
keySection.Size = UDim2.new(0.9, 0, 0, 55)
keySection.Position = UDim2.new(0.05, 0, 0.42, 0)
keySection.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
keySection.BackgroundTransparency = 0.3
keySection.BorderSizePixel = 1
keySection.BorderColor3 = Color3.fromRGB(80, 0, 0)
keySection.Parent = container

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 12)
keyCorner.Parent = keySection

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0.12, 0, 1, 0)
keyLabel.Position = UDim2.new(0.02, 0, 0, 0)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "🔑"
keyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
keyLabel.TextSize = 20
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextXAlignment = Enum.TextXAlignment.Center
keyLabel.Parent = keySection

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.55, 0, 0.7, 0)
keyBox.Position = UDim2.new(0.17, 0, 0.15, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.TextSize = 16
keyBox.Font = Enum.Font.Gotham
keyBox.PlaceholderText = "Enter your key..."
keyBox.ClearTextOnFocus = false
keyBox.Text = ""
keyBox.Parent = keySection

local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0, 8)
keyBoxCorner.Parent = keyBox

local activateBtn = Instance.new("TextButton")
activateBtn.Size = UDim2.new(0.16, 0, 0.7, 0)
activateBtn.Position = UDim2.new(0.77, 0, 0.15, 0)
activateBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
activateBtn.TextColor3 = Color3.new(1, 1, 1)
activateBtn.TextSize = 14
activateBtn.Font = Enum.Font.GothamBold
activateBtn.Text = "▶ ACTIVATE"
activateBtn.Parent = keySection

local actCorner = Instance.new("UICorner")
actCorner.CornerRadius = UDim.new(0, 8)
actCorner.Parent = activateBtn

activateBtn.MouseEnter:Connect(function()
    activateBtn.BackgroundColor3 = Color3.fromRGB(230, 0, 0)
end)
activateBtn.MouseLeave:Connect(function()
    activateBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
end)

-- ==================== STATUS ====================
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.9, 0, 0, 25)
statusText.Position = UDim2.new(0.05, 0, 0.52, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Enter your key to activate"
statusText.TextColor3 = Color3.fromRGB(180, 180, 180)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Center
statusText.Parent = container

-- ==================== LOADING BAR ====================
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.9, 0, 0, 12)
barBg.Position = UDim2.new(0.05, 0, 0.57, 0)
barBg.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
barBg.BackgroundTransparency = 0.3
barBg.BorderSizePixel = 1
barBg.BorderColor3 = Color3.fromRGB(80, 0, 0)
barBg.Parent = container

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 8)
barCorner.Parent = barBg

-- Bar Fill with gradient
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
barFill.BackgroundTransparency = 0.1
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(0, 8)
barFillCorner.Parent = barFill

-- Bar glow
local barGlow = Instance.new("Frame")
barGlow.Size = UDim2.new(1, 0, 1, 10)
barGlow.Position = UDim2.new(0, 0, 0, -5)
barGlow.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
barGlow.BackgroundTransparency = 0.8
barGlow.BorderSizePixel = 0
barGlow.Parent = barFill

local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(0, 60, 0, 25)
percentText.Position = UDim2.new(0.8, 0, 0.55, 0)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(200, 200, 200)
percentText.TextSize = 14
percentText.Font = Enum.Font.GothamBold
percentText.TextXAlignment = Enum.TextXAlignment.Right
percentText.Parent = container

-- ==================== FEATURES GRID ====================
local featureContainer = Instance.new("Frame")
featureContainer.Size = UDim2.new(0.9, 0, 0, 80)
featureContainer.Position = UDim2.new(0.05, 0, 0.65, 0)
featureContainer.BackgroundTransparency = 1
featureContainer.Parent = container

local featureList = {
    "🎯 Aimbot", "👁️ ESP", "🚀 Fly", "🛡️ God Mode",
    "Silent Aim", "Boxes", "Infinite Jump", "Full Bright",
    "FOV Control", "Names", "No Fall", "Auto Farm",
}

for i, feature in ipairs(featureList) do
    local row = math.floor((i - 1) / 4)
    local col = (i - 1) % 4
    local fText = Instance.new("TextLabel")
    fText.Size = UDim2.new(0.24, 0, 0, 20)
    fText.Position = UDim2.new(col * 0.25 + 0.01, 0, row * 22, 0)
    fText.BackgroundTransparency = 1
    fText.Text = feature
    fText.TextColor3 = Color3.fromRGB(180, 180, 180)
    fText.TextSize = 13
    fText.Font = Enum.Font.Gotham
    fText.TextXAlignment = Enum.TextXAlignment.Left
    fText.TextTransparency = 0.2
    fText.Parent = featureContainer
end

-- ==================== WATERMARK ====================
local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0.4, 0, 0, 20)
watermark.Position = UDim2.new(0.6, 0, 0.94, 0)
watermark.BackgroundTransparency = 1
watermark.Text = "dark-side.lol"
watermark.TextColor3 = Color3.fromRGB(60, 0, 0)
watermark.TextSize = 12
watermark.Font = Enum.Font.GothamBold
watermark.TextXAlignment = Enum.TextXAlignment.Right
watermark.Parent = container

local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(0.3, 0, 0, 20)
versionText.Position = UDim2.new(0.05, 0, 0.94, 0)
versionText.BackgroundTransparency = 1
versionText.Text = "v" .. LOADER_VERSION
versionText.TextColor3 = Color3.fromRGB(80, 80, 80)
versionText.TextSize = 11
versionText.Font = Enum.Font.Gotham
versionText.TextXAlignment = Enum.TextXAlignment.Left
versionText.Parent = container

-- ==================== ANIMATION FUNCTIONS ====================
local function AnimateBar(progress)
    local targetSize = UDim2.new(progress, 0, 1, 0)
    local tween = TweenService:Create(barFill, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Size = targetSize
    })
    tween:Play()
    local percent = math.floor(progress * 100)
    percentText.Text = percent .. "%"
    return tween
end

local function UpdateStatus(text)
    statusText.Text = text
    print("[DarkSide] " .. text)
end

-- ==================== KEY ACTIVATION ====================
local function ValidateKey()
    local inputKey = keyBox.Text
    if inputKey and #inputKey > 3 then
        UpdateStatus("✅ Key accepted! Loading DarkSide...")
        activateBtn.Text = "✓"
        activateBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        keyBox.Text = ""
        keyBox.PlaceholderText = "Key accepted!"
        task.wait(0.5)
        LoadScript()
    else
        UpdateStatus("❌ Invalid key! Please try again.")
        keyBox.Text = ""
        keyBox.PlaceholderText = "Invalid key, try again..."
        task.wait(1.5)
        keyBox.PlaceholderText = "Enter your key..."
    end
end

-- ==================== MAIN LOADER ====================
local function LoadScript()
    UpdateStatus("Connecting to DarkSide servers...")
    AnimateBar(0.1)
    task.wait(0.3)
    
    UpdateStatus("Downloading script...")
    AnimateBar(0.3)
    task.wait(0.3)
    
    local success, scriptContent = pcall(function()
        return game:HttpGet(SCRIPT_URL)
    end)
    
    if not success then
        UpdateStatus("❌ Download failed! Check your connection.")
        AnimateBar(0)
        return
    end
    
    if not scriptContent or #scriptContent < 10 then
        UpdateStatus("❌ Script is corrupted!")
        AnimateBar(0)
        return
    end
    
    UpdateStatus("Verifying integrity...")
    AnimateBar(0.6)
    task.wait(0.3)
    
    local compileSuccess, compiled = pcall(function()
        return loadstring(scriptContent)
    end)
    
    if not compileSuccess or type(compiled) ~= "function" then
        UpdateStatus("❌ Script validation failed!")
        AnimateBar(0)
        return
    end
    
    UpdateStatus("Initiating DarkSide Engine...")
    AnimateBar(0.8)
    task.wait(0.3)
    
    local execSuccess, execResult = pcall(function()
        return compiled()
    end)
    
    if not execSuccess then
        UpdateStatus("❌ Execution failed!")
        AnimateBar(0)
        return
    end
    
    UpdateStatus("✅ DarkSide Activated! Press Right Shift for menu")
    AnimateBar(1)
    
    -- Massive celebration effect
    for i = 1, 30 do
        local sparkle = Instance.new("Frame")
        local size = math.random(10, 40)
        sparkle.Size = UDim2.new(0, size, 0, size)
        sparkle.Position = UDim2.new(math.random() / 2, 0, math.random() / 2, 0)
        sparkle.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        sparkle.BackgroundTransparency = 0.3
        sparkle.BorderSizePixel = 0
        sparkle.Parent = container
        
        local sparkleCorner = Instance.new("UICorner")
        sparkleCorner.CornerRadius = UDim.new(0, 12)
        sparkleCorner.Parent = sparkle
        
        TweenService:Create(sparkle, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, math.random(-300, 300), 0.5, math.random(-300, 300)),
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        
        task.wait(0.03)
    end
    
    task.wait(2.5)
    local fadeTween = TweenService:Create(background, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    fadeTween:Play()
    fadeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

-- ==================== KEYBINDS ====================
activateBtn.MouseButton1Click:Connect(ValidateKey)

keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then ValidateKey() end
end)

-- ==================== START ====================
print("[DarkSide] Ultimate Loader v8.0")
print("[DarkSide] The Best Rivals Script Loader")
print("[DarkSide] Ready for activation...")

task.wait(0.5)
keyBox:CaptureFocus()
