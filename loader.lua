--[[
    Skelly Hub Loader v2.0
    Skeleton Theme - Split Text Reveal
    Only Valid Keys Work
]]

-- ==================== CONFIGURATION ====================
local SCRIPT_URL = "https://raw.githubusercontent.com/d7tpolliingr8/dashing-summit/main/rivalsaimwh.lua"
local LOADER_VERSION = "v2.0"
local DISCORD_INVITE = "https://discord.gg/yourserver"  -- ← CHANGE THIS!

-- ==================== VALID KEYS ====================
local VALID_KEYS = {
    ["SKELLY-F7D9S2-G3S9G5"] = true,
    ["SKELLY-F3G9H4-D3H6F7"] = true,
    ["SKELLY-D3G5F8-F4H7E8"] = true,
    ["SKELLY-D4G3F7-F2G7H3"] = true,
    -- Add more keys as you sell them
}

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- ==================== CREATE GUI ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SkellyHubLoader"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999

-- ==================== BACKGROUND ====================
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
background.BackgroundTransparency = 0.03
background.Parent = screenGui

-- ==================== MAIN CONTAINER ====================
local container = Instance.new("Frame")
container.Size = UDim2.new(0, 420, 0, 420)
container.Position = UDim2.new(0.5, -210, 0.5, -210)
container.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
container.BackgroundTransparency = 0.05
container.BorderSizePixel = 1
container.BorderColor3 = Color3.fromRGB(40, 40, 60)
container.Parent = background

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 12)
containerCorner.Parent = container

-- ==================== HEADER ====================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 80)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = container

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- ==================== SPLIT TEXT ANIMATION ====================
-- "SKELLY" - Left half
local leftText = Instance.new("TextLabel")
leftText.Size = UDim2.new(0.4, 0, 0, 45)
leftText.Position = UDim2.new(0.1, 0, 0.15, 0)
leftText.BackgroundTransparency = 1
leftText.Text = "SKELLY"
leftText.TextColor3 = Color3.fromRGB(255, 255, 255)
leftText.TextSize = 28
leftText.Font = Enum.Font.GothamBold
leftText.TextXAlignment = Enum.TextXAlignment.Right
leftText.Parent = header

-- "HUB" - Right half
local rightText = Instance.new("TextLabel")
rightText.Size = UDim2.new(0.4, 0, 0, 45)
rightText.Position = UDim2.new(0.5, 0, 0.15, 0)
rightText.BackgroundTransparency = 1
rightText.Text = "HUB"
rightText.TextColor3 = Color3.fromRGB(200, 200, 200)
rightText.TextSize = 28
rightText.Font = Enum.Font.GothamBold
rightText.TextXAlignment = Enum.TextXAlignment.Left
rightText.Parent = header

-- Subtitle (hidden initially)
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0.8, 0, 0, 20)
subtitle.Position = UDim2.new(0.1, 0, 0.7, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "ENTER KEY"
subtitle.TextColor3 = Color3.fromRGB(120, 120, 140)
subtitle.TextSize = 12
subtitle.Font = Enum.Font.Gotham
subtitle.TextTransparency = 1
subtitle.Parent = header

-- Skeleton icon
local skellyIcon = Instance.new("TextLabel")
skellyIcon.Size = UDim2.new(0, 30, 0, 30)
skellyIcon.Position = UDim2.new(0.47, 0, 0.05, 0)
skellyIcon.BackgroundTransparency = 1
skellyIcon.Text = "💀"
skellyIcon.TextColor3 = Color3.fromRGB(200, 200, 200)
skellyIcon.TextSize = 24
skellyIcon.Font = Enum.Font.Gotham
skellyIcon.Parent = header

-- ==================== DIVIDER ====================
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.85, 0, 0, 1)
divider.Position = UDim2.new(0.075, 0, 0.2, 0)
divider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
divider.BackgroundTransparency = 0.5
divider.BorderSizePixel = 0
divider.Parent = container

-- ==================== KEY SECTION ====================
local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0.8, 0, 0, 25)
keyLabel.Position = UDim2.new(0.1, 0, 0.26, 0)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "🔑 ENTER KEY"
keyLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
keyLabel.TextSize = 14
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.TextTransparency = 1
keyLabel.Parent = container

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.8, 0, 0, 40)
keyBox.Position = UDim2.new(0.1, 0, 0.32, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.TextSize = 16
keyBox.Font = Enum.Font.Gotham
keyBox.PlaceholderText = "Paste your key here..."
keyBox.ClearTextOnFocus = false
keyBox.Text = ""
keyBox.TextTransparency = 1
keyBox.Parent = container

local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0, 8)
keyBoxCorner.Parent = keyBox

-- ==================== BUTTONS ====================
local activateBtn = Instance.new("TextButton")
activateBtn.Size = UDim2.new(0.8, 0, 0, 42)
activateBtn.Position = UDim2.new(0.1, 0, 0.46, 0)
activateBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
activateBtn.BackgroundTransparency = 0.1
activateBtn.TextColor3 = Color3.new(1, 1, 1)
activateBtn.TextSize = 16
activateBtn.Font = Enum.Font.GothamBold
activateBtn.Text = "▶ ACTIVATE"
activateBtn.TextTransparency = 1
activateBtn.Parent = container

local actCorner = Instance.new("UICorner")
actCorner.CornerRadius = UDim.new(0, 8)
actCorner.Parent = activateBtn

activateBtn.MouseEnter:Connect(function()
    activateBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
end)
activateBtn.MouseLeave:Connect(function()
    activateBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
end)

-- ==================== DISCORD BUTTON ====================
local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0.35, 0, 0, 32)
discordBtn.Position = UDim2.new(0.325, 0, 0.58, 0)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.BackgroundTransparency = 0.1
discordBtn.TextColor3 = Color3.new(1, 1, 1)
discordBtn.TextSize = 13
discordBtn.Font = Enum.Font.GothamBold
discordBtn.Text = "💬 DISCORD"
discordBtn.TextTransparency = 1
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
    statusText.Text = "✅ Copied!"
    statusText.TextColor3 = Color3.fromRGB(0, 255, 100)
    task.wait(1.5)
    statusText.Text = "Enter your key"
    statusText.TextColor3 = Color3.fromRGB(150, 150, 170)
end)

-- ==================== STATUS ====================
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.8, 0, 0, 25)
statusText.Position = UDim2.new(0.1, 0, 0.66, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Enter your key"
statusText.TextColor3 = Color3.fromRGB(150, 150, 170)
statusText.TextSize = 13
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Center
statusText.TextTransparency = 1
statusText.Parent = container

-- ==================== LOADING BAR ====================
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.8, 0, 0, 3)
barBg.Position = UDim2.new(0.1, 0, 0.73, 0)
barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
barBg.BackgroundTransparency = 0.3
barBg.BorderSizePixel = 0
barBg.Parent = container

local barCorner2 = Instance.new("UICorner")
barCorner2.CornerRadius = UDim.new(0, 2)
barCorner2.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(100, 100, 140)
barFill.BackgroundTransparency = 0.1
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(0, 2)
barFillCorner.Parent = barFill

local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(0.8, 0, 0, 20)
percentText.Position = UDim2.new(0.1, 0, 0.76, 0)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(100, 100, 120)
percentText.TextSize = 12
percentText.Font = Enum.Font.Gotham
percentText.TextXAlignment = Enum.TextXAlignment.Center
percentText.TextTransparency = 1
percentText.Parent = container

-- ==================== FOOTER ====================
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
watermark.Text = "💀 skelly-hub.lol"
watermark.TextColor3 = Color3.fromRGB(40, 40, 60)
watermark.TextSize = 11
watermark.Font = Enum.Font.Gotham
watermark.TextXAlignment = Enum.TextXAlignment.Right
watermark.Parent = container

-- ==================== ANIMATION FUNCTIONS ====================
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
    print("[SkellyHub] " .. text)
end

-- ==================== SPLIT TEXT ANIMATION ====================
local function SplitTextReveal()
    print("[SkellyHub] Splitting text...")
    
    -- Move "SKELLY" left
    local leftTween = TweenService:Create(leftText, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.02, 0, 0.15, 0)
    })
    leftTween:Play()
    
    -- Move "HUB" right
    local rightTween = TweenService:Create(rightText, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.55, 0, 0.15, 0)
    })
    rightTween:Play()
    
    -- Fade in subtitle
    task.wait(0.4)
    local subTween = TweenService:Create(subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    subTween:Play()
    
    -- Fade in key elements
    task.wait(0.2)
    local keyLabelTween = TweenService:Create(keyLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    keyLabelTween:Play()
    
    local keyBoxTween = TweenService:Create(keyBox, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    keyBoxTween:Play()
    
    local activateTween = TweenService:Create(activateBtn, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    activateTween:Play()
    
    local discordTween = TweenService:Create(discordBtn, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    discordTween:Play()
    
    local statusTween = TweenService:Create(statusText, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    statusTween:Play()
    
    local percentTween = TweenService:Create(percentText, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    percentTween:Play()
end

-- ==================== MAIN LOADER ====================
local function LoadScript()
    UpdateStatus("Downloading script...")
    AnimateBar(0.2)
    task.wait(0.3)
    
    local success, scriptContent = pcall(function()
        return game:HttpGet(SCRIPT_URL)
    end)
    
    if not success then
        UpdateStatus("❌ Download failed")
        AnimateBar(0)
        return
    end
    
    if not scriptContent or #scriptContent < 10 then
        UpdateStatus("❌ Script corrupted")
        AnimateBar(0)
        return
    end
    
    UpdateStatus("Loading...")
    AnimateBar(0.6)
    task.wait(0.2)
    
    local compileSuccess, compiled = pcall(function()
        return loadstring(scriptContent)
    end)
    
    if not compileSuccess or type(compiled) ~= "function" then
        UpdateStatus("❌ Validation failed")
        AnimateBar(0)
        return
    end
    
    UpdateStatus("Executing...")
    AnimateBar(0.8)
    task.wait(0.2)
    
    local execSuccess, execResult = pcall(function()
        return compiled()
    end)
    
    if not execSuccess then
        UpdateStatus("❌ Execution failed")
        AnimateBar(0)
        return
    end
    
    UpdateStatus("✅ Loaded! Press Right Shift for menu")
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

-- ==================== KEY ACTIVATION ====================
local function ValidateKey()
    local inputKey = keyBox.Text
    
    if VALID_KEYS[inputKey] then
        UpdateStatus("✅ Key accepted! Loading Skelly Hub...")
        activateBtn.Text = "✓"
        activateBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        keyBox.Text = ""
        keyBox.PlaceholderText = "Key accepted!"
        task.wait(0.3)
        LoadScript()
    else
        UpdateStatus("❌ Invalid key! Please purchase a valid key.")
        keyBox.Text = ""
        keyBox.PlaceholderText = "Invalid key, try again..."
        task.wait(1.5)
        keyBox.PlaceholderText = "Paste your key here..."
    end
end

-- ==================== KEYBINDS ====================
activateBtn.MouseButton1Click:Connect(ValidateKey)

keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then ValidateKey() end
end)

-- ==================== START ====================
print("[SkellyHub] Loader v2.0")
print("[SkellyHub] Ready")

task.wait(0.5)
SplitTextReveal()
task.wait(0.3)
keyBox:CaptureFocus()
