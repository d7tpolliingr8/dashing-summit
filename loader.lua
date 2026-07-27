--[[
    Raven Cheats Loader v2.0
    License Key System - RAVEN-XXXXXX-XXXXXX
    Red/Black/Yellow Theme
]]

-- ======================================================================
--  CONFIGURATION
-- ======================================================================

local SCRIPT_URL = "https://raw.githubusercontent.com/d7tpolliingr8/dashing-summit/main/rivalsaimwh.lua"
local LOADER_VERSION = "v2.0"
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

-- ======================================================================
--  MAIN CONTAINER
-- ======================================================================

local container = Instance.new("Frame")
container.Size = UDim2.new(0, 450, 0, 500)
container.Position = UDim2.new(0.5, -225, 0.5, -250)
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
--  KEY FORMAT INFO
-- ======================================================================

local formatLabel = Instance.new("TextLabel")
formatLabel.Size = UDim2.new(0.8, 0, 0, 22)
formatLabel.Position = UDim2.new(0.1, 0, 0.22, 0)
formatLabel.BackgroundTransparency = 1
formatLabel.Text = "Format: RAVEN-XXXXXX-XXXXXX"
formatLabel.TextColor3 = Color3.fromRGB(180, 150, 0)
formatLabel.TextSize = 12
formatLabel.Font = Enum.Font.Gotham
formatLabel.TextXAlignment = Enum.TextXAlignment.Left
formatLabel.Parent = container

-- ======================================================================
--  KEY SECTION
-- ======================================================================

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0.8, 0, 0, 28)
keyLabel.Position = UDim2.new(0.1, 0, 0.26, 0)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "🔑 ENTER YOUR KEY"
keyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
keyLabel.TextSize = 14
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = container

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.8, 0, 0, 42)
keyBox.Position = UDim2.new(0.1, 0, 0.32, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.TextSize = 16
keyBox.Font = Enum.Font.Gotham
keyBox.PlaceholderText = "RAVEN-XXXXXX-XXXXXX"
keyBox.ClearTextOnFocus = false
keyBox.Text = ""
keyBox.Parent = container

local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0, 8)
keyBoxCorner.Parent = keyBox

-- ======================================================================
--  ACTIVATE BUTTON
-- ======================================================================

local activateBtn = Instance.new("TextButton")
activateBtn.Size = UDim2.new(0.4, 0, 0, 42)
activateBtn.Position = UDim2.new(0.3, 0, 0.44, 0)
activateBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
activateBtn.BackgroundTransparency = 0.1
activateBtn.TextColor3 = Color3.new(1, 1, 1)
activateBtn.TextSize = 16
activateBtn.Font = Enum.Font.GothamBold
activateBtn.Text = "▶ ACTIVATE"
activateBtn.Parent = container

local actCorner = Instance.new("UICorner")
actCorner.CornerRadius = UDim.new(0, 8)
actCorner.Parent = activateBtn

activateBtn.MouseEnter:Connect(function()
    activateBtn.BackgroundTransparency = 0.3
end)
activateBtn.MouseLeave:Connect(function()
    activateBtn.BackgroundTransparency = 0.1
end)

-- ======================================================================
--  DISCORD BUTTON
-- ======================================================================

local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0.35, 0, 0, 32)
discordBtn.Position = UDim2.new(0.325, 0, 0.56, 0)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.BackgroundTransparency = 0.1
discordBtn.TextColor3 = Color3.new(1, 1, 1)
discordBtn.TextSize = 13
discordBtn.Font = Enum.Font.GothamBold
discordBtn.Text = "💬 DISCORD"
discordBtn.Parent = container

local discCorner = Instance.new("UICorner")
discCorner.CornerRadius = UDim.new(0, 8)
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
    statusText.Text = "Enter your key to activate"
    statusText.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

-- ======================================================================
--  STATUS
-- ======================================================================

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.8, 0, 0, 25)
statusText.Position = UDim2.new(0.1, 0, 0.64, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Purchase a key on Discord"
statusText.TextColor3 = Color3.fromRGB(180, 180, 180)
statusText.TextSize = 13
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Center
statusText.Parent = container

-- ======================================================================
--  LOADING BAR
-- ======================================================================

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.8, 0, 0, 4)
barBg.Position = UDim2.new(0.1, 0, 0.71, 0)
barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
barBg.BackgroundTransparency = 0.3
barBg.BorderSizePixel = 0
barBg.Parent = container

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 2)
barCorner.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
barFill.BackgroundTransparency = 0.1
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(0, 2)
barFillCorner.Parent = barFill

local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(0.8, 0, 0, 20)
percentText.Position = UDim2.new(0.1, 0, 0.75, 0)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(100, 100, 120)
percentText.TextSize = 12
percentText.Font = Enum.Font.Gotham
percentText.TextXAlignment = Enum.TextXAlignment.Center
percentText.Parent = container

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
    local tween = TweenService:Create(barFill, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
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
--  MAIN LOADER
-- ======================================================================

local function LoadScript()
    UpdateStatus("Downloading Raven Cheats...")
    AnimateBar(0.2)
    task.wait(0.3)
    
    local success, scriptContent = pcall(function()
        return game:HttpGet(SCRIPT_URL)
    end)
    
    if not success then
        UpdateStatus("❌ Download failed - Check connection")
        AnimateBar(0)
        return
    end
    
    if not scriptContent or #scriptContent < 10 then
        UpdateStatus("❌ Script corrupted - Contact support")
        AnimateBar(0)
        return
    end
    
    UpdateStatus("Loading Raven Cheats...")
    AnimateBar(0.6)
    task.wait(0.2)
    
    local compileSuccess, compiled = pcall(function()
        return loadstring(scriptContent)
    end)
    
    if not compileSuccess or type(compiled) ~= "function" then
        UpdateStatus("❌ Validation failed - Contact support")
        AnimateBar(0)
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
        return
    end
    
    UpdateStatus("✅ Raven Cheats Loaded! Press Right Shift for menu")
    AnimateBar(1)
    
    task.wait(1.5)
    local fadeTween = TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
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
        UpdateStatus("❌ Invalid format! Use: RAVEN-XXXXXX-XXXXXX")
        keyBox.Text = ""
        keyBox.PlaceholderText = "RAVEN-XXXXXX-XXXXXX"
        return
    end
    
    if VALID_KEYS[inputKey] then
        UpdateStatus("✅ Key accepted! Loading Raven Cheats...")
        activateBtn.Text = "✓"
        activateBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        keyBox.Text = ""
        keyBox.PlaceholderText = "Key accepted!"
        task.wait(0.3)
        LoadScript()
    else
        UpdateStatus("❌ Invalid key! Purchase one on Discord")
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

print("[Raven] Loader v2.0")
print("[Raven] Discord: https://discord.gg/XJtYWy9jgU")
print("[Raven] Key format: RAVEN-XXXXXX-XXXXXX")
print("[Raven] Ready")

task.wait(0.3)
keyBox:CaptureFocus()
