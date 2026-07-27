--[[
    DarkSide Loader v7.0
    Professional Edition
    Discord Purchase System
]]

-- ==================== CONFIGURATION ====================
local SCRIPT_URL = "https://raw.githubusercontent.com/jabu62012-commits/rivals-free-script/main/rivalsaimwh.lua"
local LOADER_VERSION = "v7.0"
local LOADER_NAME = "DarkSide"
local DISCORD_INVITE = "https://discord.gg/XJtYWy9jgU"  -- ← CHANGE THIS TO YOUR DISCORD!

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

-- ==================== UI ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkSideLoader"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999

-- ==================== BACKGROUND ====================
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(5, 5, 12)
background.BackgroundTransparency = 0.02
background.Parent = screenGui

-- ==================== ANIMATED PARTICLES ====================
local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.Parent = background

local particles = {}
for i = 1, 40 do
    local particle = Instance.new("Frame")
    local size = math.random(2, 5)
    particle.Size = UDim2.new(0, size, 0, size)
    particle.Position = UDim2.new(math.random() / 2, 0, math.random() / 2, 0)
    particle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    particle.BackgroundTransparency = math.random(60, 90) / 100
    particle.BorderSizePixel = 0
    particle.Parent = particleContainer
    table.insert(particles, {frame = particle, speed = math.random(3, 8) / 100})
end

task.spawn(function()
    while task.wait(0.05) do
        for _, p in pairs(particles) do
            local x = p.frame.Position.X.Scale + p.speed * 0.01
            local y = p.frame.Position.Y.Scale + p.speed * 0.005
            if x > 1 then x = 0 end
            if y > 1 then y = 0 end
            p.frame.Position = UDim2.new(x, 0, y, 0)
        end
    end
end)

-- ==================== MAIN CONTAINER ====================
local container = Instance.new("Frame")
container.Size = UDim2.new(0, 520, 0, 520)
container.Position = UDim2.new(0.5, -260, 0.5, -260)
container.BackgroundColor3 = Color3.fromRGB(10, 10, 22)
container.BackgroundTransparency = 0.05
container.BorderSizePixel = 2
container.BorderColor3 = Color3.fromRGB(180, 0, 0)
container.Parent = background

local borderGlow = Instance.new("Frame")
borderGlow.Size = UDim2.new(1.02, 0, 1.02, 0)
borderGlow.Position = UDim2.new(-0.01, 0, -0.01, 0)
borderGlow.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
borderGlow.BackgroundTransparency = 0.85
borderGlow.BorderSizePixel = 0
borderGlow.Parent = container

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = container

local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0, 20)
innerCorner.Parent = borderGlow

-- ==================== HEADER ====================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 90)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = container

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 20)
headerCorner.Parent = header

-- ==================== ANIMATED GLOW LINES ====================
for i = 1, 2 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0.9, 0, 0, 2)
    line.Position = UDim2.new(0.05, 0, 0.05 + (i - 1) * 0.025, 0)
    line.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    line.BackgroundTransparency = 0.7
    line.BorderSizePixel = 0
    line.Parent = container
    
    task.spawn(function()
        while task.wait(0.05) do
            local t = tick() % 2
            local alpha = 0.3 + (math.sin(t * math.pi + i) * 0.5)
            line.BackgroundTransparency = 1 - alpha
        end
    end)
end

-- ==================== LOGO ====================
local logoContainer = Instance.new("Frame")
logoContainer.Size = UDim2.new(0, 75, 0, 75)
logoContainer.Position = UDim2.new(0.05, 0, 0.05, 0)
logoContainer.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
logoContainer.BackgroundTransparency = 0.15
logoContainer.BorderSizePixel = 2
logoContainer.BorderColor3 = Color3.fromRGB(255, 50, 50)
logoContainer.Parent = header

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 16)
logoCorner.Parent = logoContainer

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "DS"
logoText.TextColor3 = Color3.new(1, 1, 1)
logoText.TextSize = 34
logoText.Font = Enum.Font.GothamBold
logoText.Parent = logoContainer

-- ==================== TITLE ====================
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 0, 35)
title.Position = UDim2.new(0.2, 0, 0.15, 0)
title.BackgroundTransparency = 1
title.Text = "DARK SIDE"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 38
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local titleGlow = Instance.new("TextLabel")
titleGlow.Size = UDim2.new(0.5, 0, 0, 35)
titleGlow.Position = UDim2.new(0.2, 0, 0.15, 0)
titleGlow.BackgroundTransparency = 1
titleGlow.Text = "DARK SIDE"
titleGlow.TextColor3 = Color3.fromRGB(200, 0, 0)
titleGlow.TextSize = 38
titleGlow.Font = Enum.Font.GothamBold
titleGlow.TextXAlignment = Enum.TextXAlignment.Left
titleGlow.TextTransparency = 0.4
titleGlow.Parent = header

-- ==================== SUBTITLE ====================
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0.5, 0, 0, 20)
subtitle.Position = UDim2.new(0.2, 0, 0.5, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "RIVALS SCRIPT"
subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitle.TextSize = 14
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

-- ==================== DIVIDER ====================
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0, 2)
divider.Position = UDim2.new(0.05, 0, 0.19, 0)
divider.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
divider.BackgroundTransparency = 0.5
divider.BorderSizePixel = 0
divider.Parent = container

-- ==================== DISCORD MESSAGE ====================
local discordMessage = Instance.new("TextLabel")
discordMessage.Size = UDim2.new(0.9, 0, 0, 50)
discordMessage.Position = UDim2.new(0.05, 0, 0.22, 0)
discordMessage.BackgroundTransparency = 1
discordMessage.Text = "Please follow this link into our Discord where you can purchase a key"
discordMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
discordMessage.TextSize = 16
discordMessage.Font = Enum.Font.Gotham
discordMessage.TextWrapped = true
discordMessage.TextXAlignment = Enum.TextXAlignment.Center
discordMessage.Parent = container

-- ==================== DISCORD BUTTON ====================
local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0.5, 0, 0, 50)
discordBtn.Position = UDim2.new(0.25, 0, 0.32, 0)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.TextColor3 = Color3.new(1, 1, 1)
discordBtn.TextSize = 18
discordBtn.Font = Enum.Font.GothamBold
discordBtn.Text = "💬 JOIN DISCORD"
discordBtn.Parent = container

local discCorner = Instance.new("UICorner")
discCorner.CornerRadius = UDim.new(0, 10)
discCorner.Parent = discordBtn

discordBtn.MouseEnter:Connect(function()
    discordBtn.BackgroundColor3 = Color3.fromRGB(100, 115, 255)
end)
discordBtn.MouseLeave:Connect(function()
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
end)

discordBtn.MouseButton1Click:Connect(function()
    setclipboard(DISCORD_INVITE)
    statusText.Text = "✅ Discord invite copied to clipboard!"
    statusText.TextColor3 = Color3.fromRGB(0, 255, 100)
    task.wait(2)
    statusText.Text = "Paste the link in your browser to join"
    statusText.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

-- ==================== KEY INPUT SECTION ====================
local keySection = Instance.new("Frame")
keySection.Size = UDim2.new(0.9, 0, 0, 55)
keySection.Position = UDim2.new(0.05, 0, 0.45, 0)
keySection.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
keySection.BackgroundTransparency = 0.3
keySection.BorderSizePixel = 1
keySection.BorderColor3 = Color3.fromRGB(80, 0, 0)
keySection.Parent = container

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 10)
keyCorner.Parent = keySection

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0.15, 0, 1, 0)
keyLabel.Position = UDim2.new(0.02, 0, 0, 0)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "KEY"
keyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
keyLabel.TextSize = 14
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextXAlignment = Enum.TextXAlignment.Center
keyLabel.Parent = keySection

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.5, 0, 0.7, 0)
keyBox.Position = UDim2.new(0.2, 0, 0.15, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.TextSize = 16
keyBox.Font = Enum.Font.Gotham
keyBox.PlaceholderText = "Enter your key..."
keyBox.ClearTextOnFocus = false
keyBox.Text = ""
keyBox.Parent = keySection

local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0, 6)
keyBoxCorner.Parent = keyBox

local activateBtn = Instance.new("TextButton")
activateBtn.Size = UDim2.new(0.15, 0, 0.7, 0)
activateBtn.Position = UDim2.new(0.75, 0, 0.15, 0)
activateBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
activateBtn.TextColor3 = Color3.new(1, 1, 1)
activateBtn.TextSize = 14
activateBtn.Font = Enum.Font.GothamBold
activateBtn.Text = "ACTIVATE"
activateBtn.Parent = keySection

local actCorner = Instance.new("UICorner")
actCorner.CornerRadius = UDim.new(0, 6)
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
statusText.Position = UDim2.new(0.05, 0, 0.56, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Enter your key to activate"
statusText.TextColor3 = Color3.fromRGB(180, 180, 180)
statusText.TextSize = 13
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Center
statusText.Parent = container

-- ==================== LOADING BAR ====================
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.9, 0, 0, 10)
barBg.Position = UDim2.new(0.05, 0, 0.62, 0)
barBg.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
barBg.BackgroundTransparency = 0.3
barBg.BorderSizePixel = 1
barBg.BorderColor3 = Color3.fromRGB(80, 0, 0)
barBg.Parent = container

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 6)
barCorner.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
barFill.BackgroundTransparency = 0.1
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(0, 6)
barFillCorner.Parent = barFill

local barGlow = Instance.new("Frame")
barGlow.Size = UDim2.new(1, 0, 1, 8)
barGlow.Position = UDim2.new(0, 0, 0, -4)
barGlow.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
barGlow.BackgroundTransparency = 0.8
barGlow.BorderSizePixel = 0
barGlow.Parent = barFill

local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(0, 60, 0, 25)
percentText.Position = UDim2.new(0.8, 0, 0.6, 0)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(200, 200, 200)
percentText.TextSize = 14
percentText.Font = Enum.Font.GothamBold
percentText.TextXAlignment = Enum.TextXAlignment.Right
percentText.Parent = container

-- ==================== FEATURES ====================
local features = {
    "🎯 Aimbot | Silent Aim",
    "👁️ ESP | Boxes | Names",
    "🚀 Fly | Infinite Jump",
    "🛡️ God Mode | Full Bright",
}

local featureContainer = Instance.new("Frame")
featureContainer.Size = UDim2.new(0.9, 0, 0, 70)
featureContainer.Position = UDim2.new(0.05, 0, 0.7, 0)
featureContainer.BackgroundTransparency = 1
featureContainer.Parent = container

for i, feature in ipairs(features) do
    local yPos = (i - 1) * 20
    local fText = Instance.new("TextLabel")
    fText.Size = UDim2.new(0.5, 0, 0, 20)
    fText.Position = UDim2.new(i % 2 == 1 and 0 or 0.5, 0, 0, yPos)
    fText.BackgroundTransparency = 1
    fText.Text = feature
    fText.TextColor3 = Color3.fromRGB(180, 180, 180)
    fText.TextSize = 13
    fText.Font = Enum.Font.Gotham
    fText.TextXAlignment = Enum.TextXAlignment.Left
    fText.TextTransparency = 0.2
    fText.Parent = featureContainer
end

-- ==================== VERSION & WATERMARK ====================
local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(0.3, 0, 0, 20)
versionText.Position = UDim2.new(0.05, 0, 0.92, 0)
versionText.BackgroundTransparency = 1
versionText.Text = "v" .. LOADER_VERSION
versionText.TextColor3 = Color3.fromRGB(80, 80, 80)
versionText.TextSize = 11
versionText.Font = Enum.Font.Gotham
versionText.TextXAlignment = Enum.TextXAlignment.Left
versionText.Parent = container

local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0.4, 0, 0, 20)
watermark.Position = UDim2.new(0.6, 0, 0.92, 0)
watermark.BackgroundTransparency = 1
watermark.Text = "dark-side.lol"
watermark.TextColor3 = Color3.fromRGB(60, 0, 0)
watermark.TextSize = 12
watermark.Font = Enum.Font.GothamBold
watermark.TextXAlignment = Enum.TextXAlignment.Right
watermark.Parent = container

-- ==================== ANIMATION FUNCTIONS ====================
local function AnimateBar(progress)
    local targetSize = UDim2.new(progress, 0, 1, 0)
    local tween = TweenService:Create(barFill, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
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
    
    -- Celebration sparkles
    for i = 1, 10 do
        local sparkle = Instance.new("Frame")
        local size = math.random(10, 30)
        sparkle.Size = UDim2.new(0, size, 0, size)
        sparkle.Position = UDim2.new(math.random() / 2, 0, math.random() / 2, 0)
        sparkle.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        sparkle.BackgroundTransparency = 0.5
        sparkle.BorderSizePixel = 0
        sparkle.Parent = container
        
        local sparkleCorner = Instance.new("UICorner")
        sparkleCorner.CornerRadius = UDim.new(0, 12)
        sparkleCorner.Parent = sparkle
        
        TweenService:Create(sparkle, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, math.random(-200, 200), 0.5, math.random(-200, 200)),
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        
        task.wait(0.05)
    end
    
    task.wait(2)
    local fadeTween = TweenService:Create(background, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
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
print("[DarkSide] Loader v7.0")
print("[DarkSide] Ready for activation...")

task.wait(0.5)
keyBox:CaptureFocus()
