--[[
    Raven Cheats Loader v7.0
    FIXED - No 100% Hang
    Red/Black/Yellow Theme
    Discord: https://discord.gg/FnKfhZ7Fb6
]]

-- ======================================================================
--  CONFIGURATION
-- ======================================================================

local SCRIPT_URL = "https://raw.githubusercontent.com/d7tpolliingr8/dashing-summit/main/rivalsaimwh.lua"
local LOADER_VERSION = "v7.0"
local DISCORD_INVITE = "https://discord.gg/FnKfhZ7Fb6"

-- ======================================================================
--  SERVICES
-- ======================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

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
--  BACKGROUND
-- ======================================================================

local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
background.BackgroundTransparency = 0.03
background.Parent = screenGui

-- Subtle particles
local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.Parent = background

local particles = {}
for i = 1, 30 do
    local particle = Instance.new("Frame")
    local size = math.random(2, 4)
    particle.Size = UDim2.new(0, size, 0, size)
    particle.Position = UDim2.new(math.random() / 2, 0, math.random() / 2, 0)
    particle.BackgroundColor3 = i % 2 == 0 and Color3.fromRGB(220, 20, 20) or Color3.fromRGB(255, 215, 0)
    particle.BackgroundTransparency = math.random(50, 90) / 100
    particle.BorderSizePixel = 0
    particle.Parent = particleContainer
    table.insert(particles, {
        frame = particle,
        speed = math.random(2, 6) / 100,
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
--  MAIN CONTAINER
-- ======================================================================

local container = Instance.new("Frame")
container.Size = UDim2.new(0, 450, 0, 480)
container.Position = UDim2.new(0.5, -225, 0.5, -240)
container.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
container.BackgroundTransparency = 0.05
container.BorderSizePixel = 2
container.BorderColor3 = Color3.fromRGB(220, 20, 20)
container.Parent = background

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 14)
containerCorner.Parent = container

-- ======================================================================
--  HEADER
-- ======================================================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 80)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = container

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

-- Raven Icon
local iconFrame = Instance.new("Frame")
iconFrame.Size = UDim2.new(0, 60, 0, 60)
iconFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
iconFrame.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
iconFrame.BackgroundTransparency = 0.1
iconFrame.BorderSizePixel = 2
iconFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
iconFrame.Parent = header

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 12)
iconCorner.Parent = iconFrame

local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(1, 0, 1, 0)
iconText.BackgroundTransparency = 1
iconText.Text = "🦅"
iconText.TextColor3 = Color3.fromRGB(255, 215, 0)
iconText.TextSize = 34
iconText.Font = Enum.Font.Gotham
iconText.Parent = iconFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 0, 35)
title.Position = UDim2.new(0.22, 0, 0.1, 0)
title.BackgroundTransparency = 1
title.Text = "RAVEN CHEATS"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 30
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local titleGlow = Instance.new("TextLabel")
titleGlow.Size = UDim2.new(0.6, 0, 0, 35)
titleGlow.Position = UDim2.new(0.22, 0, 0.1, 0)
titleGlow.BackgroundTransparency = 1
titleGlow.Text = "RAVEN CHEATS"
titleGlow.TextColor3 = Color3.fromRGB(220, 20, 20)
titleGlow.TextSize = 30
titleGlow.Font = Enum.Font.GothamBold
titleGlow.TextXAlignment = Enum.TextXAlignment.Left
titleGlow.TextTransparency = 0.4
titleGlow.Parent = header

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0.6, 0, 0, 22)
subtitle.Position = UDim2.new(0.22, 0, 0.55, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "RIVALS SCRIPT"
subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitle.TextSize = 14
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

-- ======================================================================
--  DIVIDER
-- ======================================================================

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0, 2)
divider.Position = UDim2.new(0.05, 0, 0.18, 0)
divider.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
divider.BackgroundTransparency = 0.5
divider.BorderSizePixel = 0
divider.Parent = container

-- ======================================================================
--  LOADING SECTION
-- ======================================================================

local loadingSection = Instance.new("Frame")
loadingSection.Size = UDim2.new(0.85, 0, 0, 120)
loadingSection.Position = UDim2.new(0.075, 0, 0.22, 0)
loadingSection.BackgroundTransparency = 1
loadingSection.Parent = container

local loadingLabel = Instance.new("TextLabel")
loadingLabel.Size = UDim2.new(1, 0, 0, 30)
loadingLabel.Position = UDim2.new(0, 0, 0, 0)
loadingLabel.BackgroundTransparency = 1
loadingLabel.Text = "Loading Raven Cheats..."
loadingLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
loadingLabel.TextSize = 18
loadingLabel.Font = Enum.Font.GothamBold
loadingLabel.TextXAlignment = Enum.TextXAlignment.Center
loadingLabel.Parent = loadingSection

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(1, 0, 0, 14)
barBg.Position = UDim2.new(0, 0, 0, 35)
barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
barBg.BackgroundTransparency = 0.3
barBg.BorderSizePixel = 2
barBg.BorderColor3 = Color3.fromRGB(60, 60, 80)
barBg.Parent = loadingSection

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
barFill.BackgroundTransparency = 0.1
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = barFill

local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(1, 0, 0, 22)
percentText.Position = UDim2.new(0, 0, 0, 53)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(150, 150, 170)
percentText.TextSize = 14
percentText.Font = Enum.Font.Gotham
percentText.TextXAlignment = Enum.TextXAlignment.Center
percentText.Parent = loadingSection

-- ======================================================================
--  STATUS
-- ======================================================================

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.8, 0, 0, 25)
statusText.Position = UDim2.new(0.1, 0, 0.48, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Initializing..."
statusText.TextColor3 = Color3.fromRGB(180, 180, 180)
statusText.TextSize = 13
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Center
statusText.Parent = container

-- ======================================================================
--  DISCORD BUTTON
-- ======================================================================

local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0.3, 0, 0, 35)
discordBtn.Position = UDim2.new(0.35, 0, 0.57, 0)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.BackgroundTransparency = 0.1
discordBtn.TextColor3 = Color3.new(1, 1, 1)
discordBtn.TextSize = 13
discordBtn.Font = Enum.Font.GothamBold
discordBtn.Text = "💬 DISCORD"
discordBtn.Parent = container

local discCorner = Instance.new("UICorner")
discCorner.CornerRadius = UDim.new(0, 10)
discCorner.Parent = discordBtn

discordBtn.MouseEnter:Connect(function()
    discordBtn.BackgroundTransparency = 0.3
end)
discordBtn.MouseLeave:Connect(function()
    discordBtn.BackgroundTransparency = 0.1
end)

discordBtn.MouseButton1Click:Connect(function()
    setclipboard(DISCORD_INVITE)
    statusText.Text = "✅ Discord link copied!"
    statusText.TextColor3 = Color3.fromRGB(0, 255, 100)
    task.wait(1.5)
    statusText.Text = "Loading Raven Cheats..."
    statusText.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

-- ======================================================================
--  FEATURES
-- ======================================================================

local featureContainer = Instance.new("Frame")
featureContainer.Size = UDim2.new(0.9, 0, 0, 20)
featureContainer.Position = UDim2.new(0.05, 0, 0.65, 0)
featureContainer.BackgroundTransparency = 1
featureContainer.Parent = container

local features = {"🎯 Aimbot", "👁️ ESP", "🚀 Fly", "🛡️ Mods"}
for i, feature in ipairs(features) do
    local fText = Instance.new("TextLabel")
    fText.Size = UDim2.new(0.25, 0, 1, 0)
    fText.Position = UDim2.new((i - 1) * 0.25, 0, 0, 0)
    fText.BackgroundTransparency = 1
    fText.Text = feature
    fText.TextColor3 = Color3.fromRGB(180, 180, 180)
    fText.TextSize = 11
    fText.Font = Enum.Font.Gotham
    fText.TextXAlignment = Enum.TextXAlignment.Center
    fText.TextTransparency = 0.2
    fText.Parent = featureContainer
end

-- ======================================================================
--  FOOTER
-- ======================================================================

local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(0.4, 0, 0, 20)
versionText.Position = UDim2.new(0.05, 0, 0.93, 0)
versionText.BackgroundTransparency = 1
versionText.Text = "v" .. LOADER_VERSION
versionText.TextColor3 = Color3.fromRGB(60, 60, 80)
versionText.TextSize = 11
versionText.Font = Enum.Font.Gotham
versionText.TextXAlignment = Enum.TextXAlignment.Left
versionText.Parent = container

local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0.4, 0, 0, 20)
watermark.Position = UDim2.new(0.55, 0, 0.93, 0)
watermark.BackgroundTransparency = 1
watermark.Text = "🦅 raven-cheats.lol"
watermark.TextColor3 = Color3.fromRGB(40, 0, 0)
watermark.TextSize = 11
watermark.Font = Enum.Font.Gotham
watermark.TextXAlignment = Enum.TextXAlignment.Right
watermark.Parent = container

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

local function UpdateStatus(text)
    statusText.Text = text
    print("[Raven] " .. text)
end

-- ======================================================================
--  MAIN LOADER (FIXED - No Hang)
-- ======================================================================

local function LoadScript()
    UpdateStatus("Downloading Raven Cheats...")
    AnimateBar(0.3)
    
    -- Use spawn to prevent blocking
    task.spawn(function()
        local success, scriptContent = pcall(function()
            return game:HttpGet(SCRIPT_URL)
        end)
        
        if not success then
            UpdateStatus("❌ Download failed - Check connection")
            AnimateBar(0)
            StarterGui:SetCore("SendNotification", {
                Title = "Raven Cheats",
                Text = "❌ Download failed. Check your connection.",
                Duration = 3,
            })
            return
        end
        
        if not scriptContent or #scriptContent < 10 then
            UpdateStatus("❌ Script corrupted - Contact support")
            AnimateBar(0)
            StarterGui:SetCore("SendNotification", {
                Title = "Raven Cheats",
                Text = "❌ Script corrupted. Contact support.",
                Duration = 3,
            })
            return
        end
        
        UpdateStatus("Compiling script...")
        AnimateBar(0.6)
        task.wait(0.2)
        
        local compileSuccess, compiled = pcall(function()
            return loadstring(scriptContent)
        end)
        
        if not compileSuccess or type(compiled) ~= "function" then
            UpdateStatus("❌ Validation failed - Contact support")
            AnimateBar(0)
            StarterGui:SetCore("SendNotification", {
                Title = "Raven Cheats",
                Text = "❌ Validation failed. Contact support.",
                Duration = 3,
            })
            return
        end
        
        UpdateStatus("Executing Raven Cheats...")
        AnimateBar(0.8)
        task.wait(0.2)
        
        local execSuccess, execResult = pcall(function()
            return compiled()
        end)
        
        if not execSuccess then
            UpdateStatus("❌ Execution failed - Try again")
            AnimateBar(0)
            StarterGui:SetCore("SendNotification", {
                Title = "Raven Cheats",
                Text = "❌ Execution failed. Try again.",
                Duration = 3,
            })
            return
        end
        
        UpdateStatus("✅ Raven Cheats Loaded! Press Right Shift for menu")
        AnimateBar(1)
        StarterGui:SetCore("SendNotification", {
            Title = "Raven Cheats",
            Text = "✅ Loaded! Press Right Shift for menu.",
            Duration = 2,
        })
        
        task.wait(1.5)
        local fadeTween = TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        })
        fadeTween:Play()
        fadeTween.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)
end

-- ======================================================================
--  LOADING SEQUENCE
-- ======================================================================

local function StartLoading()
    print("[Raven] Starting loading sequence...")
    
    UpdateStatus("Initializing Raven Cheats...")
    AnimateBar(0.05)
    task.wait(0.2)
    
    UpdateStatus("Loading assets...")
    AnimateBar(0.15)
    task.wait(0.2)
    
    UpdateStatus("Connecting to servers...")
    AnimateBar(0.25)
    task.wait(0.2)
    
    UpdateStatus("Loading scripts...")
    AnimateBar(0.4)
    task.wait(0.2)
    
    UpdateStatus("Preparing Raven Cheats...")
    AnimateBar(0.6)
    task.wait(0.2)
    
    UpdateStatus("Ready! Loading...")
    AnimateBar(0.8)
    task.wait(0.3)
    
    LoadScript()
end

-- ======================================================================
--  START
-- ======================================================================

print("[Raven] Loader v7.0 - Fixed")
print("[Raven] Discord: https://discord.gg/FnKfhZ7Fb6")
print("[Raven] Ready")

task.wait(0.3)
StartLoading()
