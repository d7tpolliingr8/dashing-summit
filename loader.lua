--[[
    DarkSide Premium Loader v4.0
    Lifetime Edition - $40 Value
    Ultra Premium UI
]]

-- ==================== CONFIGURATION ====================
local SCRIPT_URL = "https://raw.githubusercontent.com/jabu62012-commits/rivals-free-script/main/rivalsaimwh.lua"
local LOADER_VERSION = "v4.0"
local LOADER_NAME = "DarkSide"

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

-- ==================== PREMIUM UI ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkSidePremiumLoader"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999

-- ==================== BACKGROUND (Dark with gradient) ====================
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(8, 8, 15)
background.BackgroundTransparency = 0.05
background.Parent = screenGui

-- ==================== ANIMATED BACKGROUND PARTICLES ====================
local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.Parent = background

-- Create floating particles
for i = 1, 30 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
    particle.Position = UDim2.new(math.random() / 2, 0, math.random() / 2, 0)
    particle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    particle.BackgroundTransparency = math.random(50, 80) / 100
    particle.BorderSizePixel = 0
    particle.Parent = particleContainer
    
    -- Animate particles
    local speed = math.random(2, 8) / 10
    local direction = math.random(1, 4)
    local startPos = particle.Position
    local targetPos = UDim2.new(
        math.random() / 2,
        0,
        math.random() / 2,
        0
    )
    
    task.spawn(function()
        while task.wait(0.05) do
            local currentX = particle.Position.X.Scale
            local currentY = particle.Position.Y.Scale
            local newX = currentX + (targetPos.X.Scale - currentX) * 0.01
            local newY = currentY + (targetPos.Y.Scale - currentY) * 0.01
            particle.Position = UDim2.new(newX, 0, newY, 0)
            if math.abs(newX - targetPos.X.Scale) < 0.01 and math.abs(newY - targetPos.Y.Scale) < 0.01 then
                targetPos = UDim2.new(math.random() / 2, 0, math.random() / 2, 0)
            end
        end
    end)
end

-- ==================== MAIN CONTAINER ====================
local container = Instance.new("Frame")
container.Size = UDim2.new(0, 520, 0, 500)
container.Position = UDim2.new(0.5, -260, 0.5, -250)
container.BackgroundColor3 = Color3.fromRGB(12, 12, 25)
container.BackgroundTransparency = 0.1
container.BorderSizePixel = 2
container.BorderColor3 = Color3.fromRGB(180, 0, 0)
container.Parent = background

-- Glow border
local borderGlow = Instance.new("Frame")
borderGlow.Size = UDim2.new(1.02, 0, 1.02, 0)
borderGlow.Position = UDim2.new(-0.01, 0, -0.01, 0)
borderGlow.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
borderGlow.BackgroundTransparency = 0.9
borderGlow.BorderSizePixel = 0
borderGlow.Parent = container

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = container

-- Inner corner for glow
local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0, 16)
innerCorner.Parent = borderGlow

-- ==================== PREMIUM HEADER ====================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 80)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
header.Parent = container

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

-- ==================== ANIMATED GLOW LINE ====================
local glowLine = Instance.new("Frame")
glowLine.Size = UDim2.new(0.9, 0, 0, 2)
glowLine.Position = UDim2.new(0.05, 0, 0.98, 0)
glowLine.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
glowLine.BackgroundTransparency = 0.7
glowLine.BorderSizePixel = 0
glowLine.Parent = container

-- Animate glow line
task.spawn(function()
    while task.wait(0.05) do
        local t = tick() % 2
        local alpha = 0.3 + (math.sin(t * math.pi) * 0.5)
        glowLine.BackgroundTransparency = 1 - alpha
    end
end)

-- ==================== LOGO / ICON ====================
local logoIcon = Instance.new("Frame")
logoIcon.Size = UDim2.new(0, 60, 0, 60)
logoIcon.Position = UDim2.new(0.05, 0, 0.1, 0)
logoIcon.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
logoIcon.BackgroundTransparency = 0.2
logoIcon.BorderSizePixel = 2
logoIcon.BorderColor3 = Color3.fromRGB(255, 50, 50)
logoIcon.Parent = header

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 12)
logoCorner.Parent = logoIcon

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "DS"
logoText.TextColor3 = Color3.new(1, 1, 1)
logoText.TextSize = 28
logoText.Font = Enum.Font.GothamBold
logoText.Parent = logoIcon

-- ==================== TITLE ====================
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 0, 40)
title.Position = UDim2.new(0.2, 0, 0.1, 0)
title.BackgroundTransparency = 1
title.Text = "DARK SIDE"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 36
title.TextScaled = false
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Glow effect on title
local titleGlow = Instance.new("TextLabel")
titleGlow.Size = UDim2.new(0.6, 0, 0, 40)
titleGlow.Position = UDim2.new(0.2, 0, 0.1, 0)
titleGlow.BackgroundTransparency = 1
titleGlow.Text = "DARK SIDE"
titleGlow.TextColor3 = Color3.fromRGB(200, 0, 0)
titleGlow.TextSize = 36
titleGlow.TextScaled = false
titleGlow.Font = Enum.Font.GothamBold
titleGlow.TextXAlignment = Enum.TextXAlignment.Left
titleGlow.TextTransparency = 0.5
titleGlow.Parent = header

-- ==================== SUBTITLE ====================
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0.6, 0, 0, 25)
subtitle.Position = UDim2.new(0.2, 0, 0.6, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "PREMIUM RIVALS SCRIPT"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
subtitle.TextSize = 14
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

-- ==================== PREMIUM BADGE ====================
local badge = Instance.new("Frame")
badge.Size = UDim2.new(0, 100, 0, 25)
badge.Position = UDim2.new(0.82, 0, 0.6, 0)
badge.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
badge.BackgroundTransparency = 0.2
badge.BorderSizePixel = 1
badge.BorderColor3 = Color3.fromRGB(255, 200, 50)
badge.Parent = header

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(0, 6)
badgeCorner.Parent = badge

local badgeText = Instance.new("TextLabel")
badgeText.Size = UDim2.new(1, 0, 1, 0)
badgeText.BackgroundTransparency = 1
badgeText.Text = "★ LIFETIME"
badgeText.TextColor3 = Color3.fromRGB(255, 215, 0)
badgeText.TextSize = 12
badgeText.Font = Enum.Font.GothamBold
badgeText.Parent = badge

-- ==================== DIVIDER ====================
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0, 2)
divider.Position = UDim2.new(0.05, 0, 0.17, 0)
divider.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
divider.BackgroundTransparency = 0.6
divider.BorderSizePixel = 0
divider.Parent = container

-- ==================== LOADING SECTION ====================
-- Loading Text
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, -40, 0, 30)
loadingText.Position = UDim2.new(0, 20, 0, 120)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Initializing DarkSide Engine..."
loadingText.TextColor3 = Color3.fromRGB(220, 220, 220)
loadingText.TextSize = 18
loadingText.Font = Enum.Font.Gotham
loadingText.TextXAlignment = Enum.TextXAlignment.Left
loadingText.Parent = container

-- Loading Dots (animated)
local dotText = Instance.new("TextLabel")
dotText.Size = UDim2.new(0, 30, 0, 30)
dotText.Position = UDim2.new(0.85, 0, 120, 0)
dotText.BackgroundTransparency = 1
dotText.Text = "..."
dotText.TextColor3 = Color3.fromRGB(200, 0, 0)
dotText.TextSize = 24
dotText.Font = Enum.Font.GothamBold
dotText.Parent = container

-- Animate dots
task.spawn(function()
    local dots = 1
    while task.wait(0.3) do
        dots = (dots % 3) + 1
        dotText.Text = string.rep(".", dots)
    end
end)

-- ==================== LOADING BAR (Premium) ====================
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.9, 0, 0, 10)
barBg.Position = UDim2.new(0.05, 0, 0.35, 0)
barBg.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
barBg.BackgroundTransparency = 0.3
barBg.BorderSizePixel = 1
barBg.BorderColor3 = Color3.fromRGB(80, 0, 0)
barBg.Parent = container

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 5)
barCorner.Parent = barBg

-- Bar Fill with gradient
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
barFill.BackgroundTransparency = 0.1
barFill.BorderSizePixel = 0
barFill.Parent = barBg

-- Bar gradient overlay
local barGradient = Instance.new("UIListLayout")
barGradient.Parent = barFill

local barCorner2 = Instance.new("UICorner")
barCorner2.CornerRadius = UDim.new(0, 5)
barCorner2.Parent = barFill

-- Glow on bar
local barGlow = Instance.new("Frame")
barGlow.Size = UDim2.new(1, 0, 1, 6)
barGlow.Position = UDim2.new(0, 0, 0, -3)
barGlow.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
barGlow.BackgroundTransparency = 0.8
barGlow.BorderSizePixel = 0
barGlow.Parent = barFill

-- ==================== PROGRESS PERCENTAGE ====================
local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(0, 60, 0, 25)
percentText.Position = UDim2.new(0.8, 0, 0.32, 0)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(200, 200, 200)
percentText.TextSize = 14
percentText.Font = Enum.Font.GothamBold
percentText.TextXAlignment = Enum.TextXAlignment.Right
percentText.Parent = container

-- ==================== STATUS SECTION ====================
local statusIcon = Instance.new("Frame")
statusIcon.Size = UDim2.new(0, 12, 0, 12)
statusIcon.Position = UDim2.new(0.05, 0, 0.45, 0)
statusIcon.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
statusIcon.BackgroundTransparency = 0.3
statusIcon.BorderSizePixel = 1
statusIcon.BorderColor3 = Color3.fromRGB(255, 50, 50)
statusIcon.Parent = container

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(1, 0)
statusCorner.Parent = statusIcon

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.8, 0, 0, 25)
statusText.Position = UDim2.new(0.08, 0, 0.44, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Connecting to DarkSide servers..."
statusText.TextColor3 = Color3.fromRGB(180, 180, 180)
statusText.TextSize = 13
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = container

-- ==================== FEATURE LIST ====================
local features = {
    "🎯 Aimbot (Silent / Visible)",
    "👁️ ESP (Boxes, Names, Health)",
    "🚀 Fly & Infinite Jump",
    "🛡️ God Mode & No Fall Damage",
    "💡 Full Bright & Auto Farm",
}

local featureY = 250
for _, feature in ipairs(features) do
    local featureText = Instance.new("TextLabel")
    featureText.Size = UDim2.new(0.45, 0, 0, 20)
    featureText.Position = UDim2.new(0.05, 0, 0, featureY)
    featureText.BackgroundTransparency = 1
    featureText.Text = feature
    featureText.TextColor3 = Color3.fromRGB(150, 150, 150)
    featureText.TextSize = 13
    featureText.Font = Enum.Font.Gotham
    featureText.TextXAlignment = Enum.TextXAlignment.Left
    featureText.TextTransparency = 0.5
    featureText.Parent = container
    featureY = featureY + 25
end

-- ==================== VERSION & WATERMARK ====================
local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(0.3, 0, 0, 20)
versionText.Position = UDim2.new(0.05, 0, 0.9, 0)
versionText.BackgroundTransparency = 1
versionText.Text = "Version " .. LOADER_VERSION
versionText.TextColor3 = Color3.fromRGB(80, 80, 80)
versionText.TextSize = 11
versionText.Font = Enum.Font.Gotham
versionText.TextXAlignment = Enum.TextXAlignment.Left
versionText.Parent = container

local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0.4, 0, 0, 20)
watermark.Position = UDim2.new(0.6, 0, 0.9, 0)
watermark.BackgroundTransparency = 1
watermark.Text = "dark-side.lol"
watermark.TextColor3 = Color3.fromRGB(60, 0, 0)
watermark.TextSize = 12
watermark.Font = Enum.Font.GothamBold
watermark.TextXAlignment = Enum.TextXAlignment.Right
watermark.Parent = container

-- ==================== PRICE TAG ====================
local priceTag = Instance.new("Frame")
priceTag.Size = UDim2.new(0, 120, 0, 30)
priceTag.Position = UDim2.new(0.7, 0, 0.16, 0)
priceTag.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
priceTag.BackgroundTransparency = 0.2
priceTag.BorderSizePixel = 1
priceTag.BorderColor3 = Color3.fromRGB(255, 50, 50)
priceTag.Parent = container

local priceCorner = Instance.new("UICorner")
priceCorner.CornerRadius = UDim.new(0, 6)
priceCorner.Parent = priceTag

local priceText = Instance.new("TextLabel")
priceText.Size = UDim2.new(1, 0, 1, 0)
priceText.BackgroundTransparency = 1
priceText.Text = "💰 $40 LIFETIME"
priceText.TextColor3 = Color3.fromRGB(255, 215, 0)
priceText.TextSize = 13
priceText.Font = Enum.Font.GothamBold
priceText.Parent = priceTag

-- ==================== ANIMATION FUNCTIONS ====================
local function AnimateBar(progress)
    local targetSize = UDim2.new(progress, 0, 1, 0)
    local tween = TweenService:Create(barFill, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Size = targetSize
    })
    tween:Play()
    
    -- Update percentage
    local percent = math.floor(progress * 100)
    percentText.Text = percent .. "%"
    
    return tween
end

local function UpdateStatus(text, iconColor)
    statusText.Text = text
    if iconColor then
        statusIcon.BackgroundColor3 = iconColor
    end
    print("[DarkSide] " .. text)
end

-- ==================== MAIN LOADER FUNCTION ====================
local function LoadScript()
    UpdateStatus("Fetching DarkSide script from server...", Color3.fromRGB(200, 0, 0))
    AnimateBar(0.1)
    task.wait(0.3)
    
    UpdateStatus("Connecting to premium servers...", Color3.fromRGB(200, 150, 0))
    AnimateBar(0.2)
    task.wait(0.3)
    
    UpdateStatus("Downloading DarkSide v4.0...", Color3.fromRGB(200, 150, 0))
    AnimateBar(0.4)
    task.wait(0.3)
    
    local success, scriptContent = pcall(function()
        return game:HttpGet(SCRIPT_URL)
    end)
    
    if not success then
        UpdateStatus("Download failed! Check your connection.", Color3.fromRGB(255, 0, 0))
        AnimateBar(0)
        
        -- Retry button
        local retryBtn = Instance.new("TextButton")
        retryBtn.Size = UDim2.new(0.3, 0, 0, 40)
        retryBtn.Position = UDim2.new(0.35, 0, 0.55, 0)
        retryBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        retryBtn.TextColor3 = Color3.new(1, 1, 1)
        retryBtn.TextSize = 16
        retryBtn.Font = Enum.Font.GothamBold
        retryBtn.Text = "RETRY"
        retryBtn.Parent = container
        
        local retryCorner = Instance.new("UICorner")
        retryCorner.CornerRadius = UDim.new(0, 6)
        retryCorner.Parent = retryBtn
        
        retryBtn.MouseButton1Click:Connect(function()
            retryBtn:Destroy()
            statusText.TextColor3 = Color3.fromRGB(180, 180, 180)
            LoadScript()
        end)
        return
    end
    
    if not scriptContent or #scriptContent < 10 then
        UpdateStatus("Script is empty or corrupted!", Color3.fromRGB(255, 0, 0))
        AnimateBar(0)
        return
    end
    
    UpdateStatus("Verifying script integrity...", Color3.fromRGB(0, 200, 100))
    AnimateBar(0.6)
    task.wait(0.3)
    
    local compileSuccess, compiled = pcall(function()
        return loadstring(scriptContent)
    end)
    
    if not compileSuccess or type(compiled) ~= "function" then
        UpdateStatus("Script validation failed!", Color3.fromRGB(255, 0, 0))
        AnimateBar(0)
        return
    end
    
    UpdateStatus("Initiating DarkSide Engine...", Color3.fromRGB(0, 200, 100))
    AnimateBar(0.8)
    task.wait(0.3)
    
    local execSuccess, execResult = pcall(function()
        return compiled()
    end)
    
    if not execSuccess then
        UpdateStatus("Execution failed! Error: " .. tostring(execResult), Color3.fromRGB(255, 0, 0))
        AnimateBar(0)
        return
    end
    
    -- ==================== SUCCESS! ====================
    UpdateStatus("✅ DARK SIDE ACTIVATED! Press Right Shift for menu", Color3.fromRGB(0, 255, 0))
    AnimateBar(1)
    
    -- Success animation - golden glow
    local successGlow = Instance.new("Frame")
    successGlow.Size = UDim2.new(1.02, 0, 1.02, 0)
    successGlow.Position = UDim2.new(-0.01, 0, -0.01, 0)
    successGlow.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    successGlow.BackgroundTransparency = 0.9
    successGlow.BorderSizePixel = 0
    successGlow.Parent = container
    
    local glowTween = TweenService:Create(successGlow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    glowTween:Play()
    glowTween.Completed:Connect(function()
        successGlow:Destroy()
    end)
    
    -- Play success sound effect (optional)
    -- (You can add a sound here if you want)
    
    -- Fade out loader after 3 seconds
    task.wait(3)
    local fadeTween = TweenService:Create(background, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    fadeTween:Play()
    fadeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

-- ==================== START ====================
print("[DarkSide] Premium Loader v4.0 Initialized")
print("[DarkSide] Version: " .. LOADER_VERSION)
print("[DarkSide] Loading DarkSide script...")

-- Small delay before loading
task.wait(0.8)
LoadScript()
