--[[
    Raven Cheats Loader v3.1
    Fixed UI - Clean Red/Black/Yellow Theme
    License Key System - RAVEN-XXXXXX-XXXXXX
]]

-- ======================================================================
--  CONFIGURATION
-- ======================================================================

local SCRIPT_URL = "https://raw.githubusercontent.com/d7tpolliingr8/dashing-summit/main/rivalsaimwh.lua"
local LOADER_VERSION = "v3.1"
local DISCORD_INVITE = "https://discord.gg/XJtYWy9jgU"

-- ======================================================================
--  VALID KEYS (Add your keys here)
-- ======================================================================

local VALID_KEYS = {
    ["RAVEN-A7K2M9-4P8Q1R"] = true,
    ["RAVEN-B3X5N7-L2W6K9"] = true,
    ["RAVEN-C8V4R2-P6M9T3"] = true,
    ["RAVEN-D9W6S3-Q8N4M2"] = true,
}

-- ======================================================================
--  SERVICES
-- ======================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- ======================================================================
--  COLORS
-- ======================================================================

local RED = Color3.fromRGB(220, 20, 20)
local YELLOW = Color3.fromRGB(255, 215, 0)
local WHITE = Color3.fromRGB(255, 255, 255)
local BLACK = Color3.fromRGB(0, 0, 0)
local GRAY = Color3.fromRGB(180, 180, 180)
local DARK_BG = Color3.fromRGB(14, 14, 18)

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
background.BackgroundColor3 = BLACK
background.BackgroundTransparency = 0.3
background.Parent = screenGui

-- ======================================================================
--  MAIN CONTAINER
-- ======================================================================

local container = Instance.new("Frame")
container.Size = UDim2.new(0, 400, 0, 460)
container.Position = UDim2.new(0.5, -200, 0.5, -230)
container.BackgroundColor3 = DARK_BG
container.BackgroundTransparency = 0.05
container.BorderSizePixel = 2
container.BorderColor3 = RED
container.Parent = background

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 12)
containerCorner.Parent = container

-- ======================================================================
--  HEADER
-- ======================================================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 80)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = RED
header.BackgroundTransparency = 0.15
header.BorderSizePixel = 0
header.Parent = container

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- ======================================================================
--  RAVEN ICON
-- ======================================================================

local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(0, 60, 0, 60)
iconText.Position = UDim2.new(0.05, 0, 0.1, 0)
iconText.BackgroundTransparency = 1
iconText.Text = "🦅"
iconText.TextColor3 = YELLOW
iconText.TextSize = 34
iconText.Font = Enum.Font.Gotham
iconText.Parent = header

-- ======================================================================
--  TITLE
-- ======================================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 0, 35)
title.Position = UDim2.new(0.22, 0, 0.12, 0)
title.BackgroundTransparency = 1
title.Text = "RAVEN CHEATS"
title.TextColor3 = WHITE
title.TextSize = 28
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0.6, 0, 0, 20)
subtitle.Position = UDim2.new(0.22, 0, 0.55, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "RIVALS SCRIPT"
subtitle.TextColor3 = GRAY
subtitle.TextSize = 12
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

-- ======================================================================
--  DIVIDER
-- ======================================================================

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0, 2)
divider.Position = UDim2.new(0.05, 0, 0.18, 0)
divider.BackgroundColor3 = RED
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
formatLabel.TextColor3 = YELLOW
formatLabel.TextSize = 12
formatLabel.Font = Enum.Font.Gotham
formatLabel.TextXAlignment = Enum.TextXAlignment.Center
formatLabel.Parent = container

-- ======================================================================
--  KEY INPUT
-- ======================================================================

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0.8, 0, 0, 25)
keyLabel.Position = UDim2.new(0.1, 0, 0.27, 0)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "ENTER YOUR LICENSE KEY"
keyLabel.TextColor3 = WHITE
keyLabel.TextSize = 13
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextXAlignment = Enum.TextXAlignment.Center
keyLabel.Parent = container

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.8, 0, 0, 42)
keyBox.Position = UDim2.new(0.1, 0, 0.33, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
keyBox.TextColor3 = WHITE
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
activateBtn.Position = UDim2.new(0.3, 0, 0.47, 0)
activateBtn.BackgroundColor3 = RED
activateBtn.BackgroundTransparency = 0.15
activateBtn.TextColor3 = WHITE
activateBtn.TextSize = 16
activateBtn.Font = Enum.Font.GothamBold
activateBtn.Text = "▶ ACTIVATE"
activateBtn.Parent = container

local actCorner = Instance.new("UICorner")
actCorner.CornerRadius = UDim.new(0, 8)
actCorner.Parent = activateBtn

-- Hover effect
activateBtn.MouseEnter:Connect(function()
    activateBtn.BackgroundTransparency = 0.35
end)
activateBtn.MouseLeave:Connect(function()
    activateBtn.BackgroundTransparency = 0.15
end)

-- ======================================================================
--  DISCORD BUTTON
-- ======================================================================

local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0.35, 0, 0, 32)
discordBtn.Position = UDim2.new(0.325, 0, 0.59, 0)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.BackgroundTransparency = 0.15
discordBtn.TextColor3 = WHITE
discordBtn.TextSize = 12
discordBtn.Font = Enum.Font.GothamBold
discordBtn.Text = "💬 DISCORD"
discordBtn.Parent = container

local discCorner = Instance.new("UICorner")
discCorner.CornerRadius = UDim.new(0, 8)
discCorner.Parent = discordBtn

discordBtn.MouseEnter:Connect(function()
    discordBtn.BackgroundTransparency = 0.35
end)
discordBtn.MouseLeave:Connect(function()
    discordBtn.BackgroundTransparency = 0.15
end)

discordBtn.MouseButton1Click:Connect(function()
    setclipboard(DISCORD_INVITE)
    statusText.Text = "✅ Discord link copied!"
    statusText.TextColor3 = Color3.fromRGB(0, 255, 100)
    task.wait(1.5)
    statusText.Text = "Enter your key to activate"
    statusText.TextColor3 = GRAY
end)

-- ======================================================================
--  STATUS
-- ======================================================================

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.8, 0, 0, 25)
statusText.Position = UDim2.new(0.1, 0, 0.66, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Purchase a key on Discord"
statusText.TextColor3 = GRAY
statusText.TextSize = 12
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Center
statusText.Parent = container

-- ======================================================================
--  LOADING BAR
-- ======================================================================

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.8, 0, 0, 4)
barBg.Position = UDim2.new(0.1, 0, 0.73, 0)
barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
barBg.BackgroundTransparency = 0.3
barBg.BorderSizePixel = 0
barBg.Parent = container

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 2)
barCorner.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = RED
barFill.BackgroundTransparency = 0.1
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(0, 2)
barFillCorner.Parent = barFill

local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(0.8, 0, 0, 20)
percentText.Position = UDim2.new(0.1, 0, 0.77, 0)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = GRAY
percentText.TextSize = 11
percentText.Font = Enum.Font.Gotham
percentText.TextXAlignment = Enum.TextXAlignment.Center
percentText.Parent = container

-- ======================================================================
--  FOOTER
-- ======================================================================

local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, 25)
footer.Position = UDim2.new(0, 0, 1, -25)
footer.BackgroundTransparency = 1
footer.Parent = container

local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(0.4, 0, 1, 0)
versionText.Position = UDim2.new(0.05, 0, 0, 0)
versionText.BackgroundTransparency = 1
versionText.Text = "v" .. LOADER_VERSION
versionText.TextColor3 = Color3.fromRGB(60, 60, 80)
versionText.TextSize = 10
versionText.Font = Enum.Font.Gotham
versionText.TextXAlignment = Enum.TextXAlignment.Left
versionText.Parent = footer

local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0.4, 0, 1, 0)
watermark.Position = UDim2.new(0.55, 0, 0, 0)
watermark.BackgroundTransparency = 1
watermark.Text = "🦅 raven-cheats.lol"
watermark.TextColor3 = Color3.fromRGB(40, 0, 0)
watermark.TextSize = 10
watermark.Font = Enum.Font.Gotham
watermark.TextXAlignment = Enum.TextXAlignment.Right
watermark.Parent = footer

-- ======================================================================
--  ANIMATION FUNCTIONS
-- ======================================================================

local function AnimateBar(progress)
    local targetSize = UDim2.new(progress, 0, 1, 0)
    local tween = TweenService:Create(barFill, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
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
        statusText.TextColor3 = GRAY
    end
    print("[Raven] " .. text)
end

-- ======================================================================
--  MAIN LOADER
-- ======================================================================

local function LoadScript()
    UpdateStatus("Downloading Raven Cheats...", YELLOW)
    AnimateBar(0.15)
    task.wait(0.3)
    
    UpdateStatus("Connecting to server...")
    AnimateBar(0.35)
    task.wait(0.3)
    
    local success, scriptContent = pcall(function()
        return game:HttpGet(SCRIPT_URL)
    end)
    
    if not success then
        UpdateStatus("❌ Download failed - Check connection", RED)
        AnimateBar(0)
        return
    end
    
    if not scriptContent or #scriptContent < 10 then
        UpdateStatus("❌ Script corrupted - Contact support", RED)
        AnimateBar(0)
        return
    end
    
    UpdateStatus("Loading Raven Cheats...")
    AnimateBar(0.6)
    task.wait(0.3)
    
    local compileSuccess, compiled = pcall(function()
        return loadstring(scriptContent)
    end)
    
    if not compileSuccess or type(compiled) ~= "function" then
        UpdateStatus("❌ Validation failed - Contact support", RED)
        AnimateBar(0)
        return
    end
    
    UpdateStatus("Executing Raven Cheats...", YELLOW)
    AnimateBar(0.8)
    task.wait(0.3)
    
    local execSuccess, execResult = pcall(function()
        return compiled()
    end)
    
    if not execSuccess then
        UpdateStatus("❌ Execution failed - Try again", RED)
        AnimateBar(0)
        return
    end
    
    UpdateStatus("✅ Raven Cheats Loaded! Press Right Shift for menu", Color3.fromRGB(0, 255, 100))
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
    
    local function isValidFormat(key)
        local pattern = "^RAVEN%-%w+%-%w+$"
        return string.match(key, pattern) ~= nil
    end
    
    if not isValidFormat(inputKey) then
        UpdateStatus("❌ Invalid format! Use: RAVEN-XXXXXX-XXXXXX", RED)
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
        UpdateStatus("❌ Invalid key! Purchase one on Discord", RED)
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

print("[Raven] Loader v3.1 - Fixed UI")
print("[Raven] Discord: https://discord.gg/XJtYWy9jgU")
print("[Raven] Key format: RAVEN-XXXXXX-XXXXXX")
print("[Raven] Ready")

task.wait(0.3)
keyBox:CaptureFocus()
