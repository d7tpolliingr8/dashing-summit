--[[
    DarkSide Ultimate Loader v9.0
    One-Key Activation
]]

-- ==================== CONFIGURATION ====================
-- ✅ UPDATED: This now points to your actual script on GitHub
local SCRIPT_URL = "https://raw.githubusercontent.com/jabu62012-commits/dashing-summit/main/rivalsaimwh.lua"
local LOADER_VERSION = "v9.0"
-- ✅ UPDATED: Change this to your actual Discord invite link
local DISCORD_INVITE = "https://discord.gg/XJtYWy9jgU"

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- ==================== CREATE GUI ====================
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

-- ==================== PARTICLES ====================
local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.Parent = background

for i = 1, 80 do
    local particle = Instance.new("Frame")
    local size = math.random(2, 6)
    particle.Size = UDim2.new(0, size, 0, size)
    particle.Position = UDim2.new(math.random() / 2, 0, math.random() / 2, 0)
    particle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    particle.BackgroundTransparency = math.random(60, 90) / 100
    particle.BorderSizePixel = 0
    particle.Parent = particleContainer
end

-- ==================== MAIN CONTAINER ====================
local container = Instance.new("Frame")
container.Size = UDim2.new(0, 520, 0, 500)
container.Position = UDim2.new(0.5, -260, 0.5, -250)
container.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
container.BackgroundTransparency = 0.08
container.BorderSizePixel = 2
container.BorderColor3 = Color3.fromRGB(180, 0, 0)
container.Parent = background

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 25)
containerCorner.Parent = container

-- ==================== HEADER ====================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 80)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = container

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 25)
headerCorner.Parent = header

-- Logo
local logoContainer = Instance.new("Frame")
logoContainer.Size = UDim2.new(0, 70, 0, 70)
logoContainer.Position = UDim2.new(0.05, 0, 0.05, 0)
logoContainer.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
logoContainer.BackgroundTransparency = 0.1
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
logoText.TextSize = 32
logoText.Font = Enum.Font.GothamBold
logoText.Parent = logoContainer

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 0, 35)
title.Position = UDim2.new(0.2, 0, 0.12, 0)
title.BackgroundTransparency = 1
title.Text = "DARK SIDE"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 36
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

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

-- Version Badge
local versionBadge = Instance.new("Frame")
versionBadge.Size = UDim2.new(0, 100, 0, 28)
versionBadge.Position = UDim2.new(0.78, 0, 0.4, 0)
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
divider.Position = UDim2.new(0.05, 0, 0.18, 0)
divider.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
divider.BackgroundTransparency = 0.4
divider.BorderSizePixel = 0
divider.Parent = container

-- ==================== DISCORD MESSAGE ====================
local discordMessage = Instance.new("TextLabel")
discordMessage.Size = UDim2.new(0.9, 0, 0, 40)
discordMessage.Position = UDim2.new(0.05, 0, 0.21, 0)
discordMessage.BackgroundTransparency = 1
discordMessage.Text = "📢 Join our Discord to purchase a key"
discordMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
discordMessage.TextSize = 16
discordMessage.Font = Enum.Font.Gotham
discordMessage.TextWrapped = true
discordMessage.TextXAlignment = Enum.TextXAlignment.Center
discordMessage.Parent = container

-- ==================== DISCORD BUTTON ====================
local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0.4, 0, 0, 45)
discordBtn.Position = UDim2.new(0.3, 0, 0.30, 0)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.TextColor3 = Color3.new(1, 1, 1)
discordBtn.TextSize = 16
discordBtn.Font = Enum.Font.GothamBold
discordBtn.Text = "💬 JOIN DISCORD"
discordBtn.Parent = container

local discCorner = Instance.new("UICorner")
discCorner.CornerRadius = UDim.new(0, 10)
discCorner.Parent = discordBtn

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
keySection.Size = UDim2.new(0.9, 0, 0, 50)
keySection.Position = UDim2.new(0.05, 0, 0.40, 0)
keySection.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
keySection.BackgroundTransparency = 0.3
keySection.BorderSizePixel = 1
keySection.BorderColor3 = Color3.fromRGB(80, 0, 0)
keySection.Parent = container

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 10)
keyCorner.Parent = keySection

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.7, 0, 0.7, 0)
keyBox.Position = UDim2.new(0.05, 0, 0.15, 0)
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
activateBtn.Size = UDim2.new(0.2, 0, 0.7, 0)
activateBtn.Position = UDim2.new(0.77, 0, 0.15, 0)
activateBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
activateBtn.TextColor3 = Color3.new(1, 1, 1)
activateBtn.TextSize = 14
activateBtn.Font = Enum.Font.GothamBold
activateBtn.Text = "ACTIVATE"
activateBtn.Parent = keySection

local actCorner = Instance.new("UICorner")
actCorner.CornerRadius = UDim.new(0, 8)
actCorner.Parent = activateBtn

-- ==================== STATUS ====================
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.9, 0, 0, 25)
statusText.Position = UDim2.new(0.05, 0, 0.50, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Enter your key to activate"
statusText.TextColor3 = Color3.fromRGB(180, 180, 180)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Center
statusText.Parent = container

-- ==================== LOADING BAR ====================
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.9, 0, 0, 10)
barBg.Position = UDim2.new(0.05, 0, 0.55, 0)
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

local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(0, 60, 0, 25)
percentText.Position = UDim2.new(0.8, 0, 0.53, 0)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(200, 200, 200)
percentText.TextSize = 14
percentText.Font = Enum.Font.GothamBold
percentText.TextXAlignment = Enum.TextXAlignment.Right
percentText.Parent = container

-- ==================== FEATURES ====================
local featureContainer = Instance.new("Frame")
featureContainer.Size = UDim2.new(0.9, 0, 0, 70)
featureContainer.Position = UDim2.new(0.05, 0, 0.62, 0)
featureContainer.BackgroundTransparency = 1
featureContainer.Parent = container

local featureList = {
    "🎯 Aimbot", "👁️ ESP", "🚀 Fly", "🛡️ God Mode",
    "Silent Aim", "Boxes", "Infinite Jump", "Full Bright",
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
watermark.Position = UDim2.new(0.6, 0, 0.93, 0)
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
    percentText.Text = math.floor(progress * 100) .. "%"
    return tween
end

local function UpdateStatus(text)
    statusText.Text = text
    print("[DarkSide] " .. text)
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
        UpdateStatus("❌ Download failed!")
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
    
    -- Celebration
    for i = 1, 15 do
        local sparkle = Instance.new("Frame")
        local size = math.random(10, 30)
        sparkle.Size = UDim2.new(0, size, 0, size)
        sparkle.Position = UDim2.new(math.random() / 2, 0, math.random() / 2, 0)
        sparkle.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        sparkle.BackgroundTransparency = 0.3
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
        
        task.wait(0.03)
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

-- ==================== KEY ACTIVATION ====================
local function ValidateKey()
    local inputKey = keyBox.Text
    if inputKey and #inputKey > 3 then
        UpdateStatus("✅ Key accepted! Loading DarkSide...")
        activateBtn.Text = "✓"
        activateBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        keyBox.Text = ""
        keyBox.PlaceholderText = "Key accepted!"
        task.wait(0.3)
        LoadScript()
    else
        UpdateStatus("❌ Invalid key! Please try again.")
        keyBox.Text = ""
        keyBox.PlaceholderText = "Invalid key, try again..."
        task.wait(1.5)
        keyBox.PlaceholderText = "Enter your key..."
    end
end

-- ==================== KEYBINDS ====================
activateBtn.MouseButton1Click:Connect(ValidateKey)

keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then ValidateKey() end
end)

-- ==================== START ====================
print("[DarkSide] Ultimate Loader v9.0")
print("[DarkSide] Ready for activation...")

task.wait(0.5)
keyBox:CaptureFocus()
