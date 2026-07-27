--[[
    DarkSide Loader
    Ather Hub Style - Clean & Modern
    Press Right Shift to open menu after loading
]]

-- ==================== CONFIGURATION ====================
local SCRIPT_URL = "https://raw.githubusercontent.com/d7tpolliingr8/dashing-summit/main/rivalsaimwh.lua"
local LOADER_VERSION = "v1.0"
local DISCORD_INVITE = "https://discord.gg/XJtYWy9jgU"  -- ← CHANGE THIS!

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
background.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
background.BackgroundTransparency = 0.03
background.Parent = screenGui

-- ==================== MAIN CONTAINER (Clean & Compact) ====================
local container = Instance.new("Frame")
container.Size = UDim2.new(0, 380, 0, 380)
container.Position = UDim2.new(0.5, -190, 0.5, -190)
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
header.Size = UDim2.new(1, 0, 0, 60)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = container

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Logo Text
local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "DARK SIDE"
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.TextSize = 26
logoText.Font = Enum.Font.GothamBold
logoText.Parent = header

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 35)
subtitle.BackgroundTransparency = 1
subtitle.Text = "RIVALS SCRIPT"
subtitle.TextColor3 = Color3.fromRGB(120, 120, 140)
subtitle.TextSize = 12
subtitle.Font = Enum.Font.Gotham
subtitle.TextTransparency = 0.3
subtitle.Parent = header

-- ==================== DIVIDER ====================
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.85, 0, 0, 1)
divider.Position = UDim2.new(0.075, 0, 0.16, 0)
divider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
divider.BackgroundTransparency = 0.5
divider.BorderSizePixel = 0
divider.Parent = container

-- ==================== KEY SECTION ====================
local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0.8, 0, 0, 25)
keyLabel.Position = UDim2.new(0.1, 0, 0.22, 0)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "Enter Key"
keyLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
keyLabel.TextSize = 14
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = container

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.8, 0, 0, 40)
keyBox.Position = UDim2.new(0.1, 0, 0.29, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.TextSize = 16
keyBox.Font = Enum.Font.Gotham
keyBox.PlaceholderText = "Paste your key here..."
keyBox.ClearTextOnFocus = false
keyBox.Text = ""
keyBox.Parent = container

local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0, 8)
keyBoxCorner.Parent = keyBox

-- ==================== BUTTONS ====================
local activateBtn = Instance.new("TextButton")
activateBtn.Size = UDim2.new(0.8, 0, 0, 42)
activateBtn.Position = UDim2.new(0.1, 0, 0.42, 0)
activateBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
activateBtn.BackgroundTransparency = 0.1
activateBtn.TextColor3 = Color3.new(1, 1, 1)
activateBtn.TextSize = 16
activateBtn.Font = Enum.Font.GothamBold
activateBtn.Text = "ACTIVATE"
activateBtn.Parent = container

local actCorner = Instance.new("UICorner")
actCorner.CornerRadius = UDim.new(0, 8)
actCorner.Parent = activateBtn

-- Hover effect
activateBtn.MouseEnter:Connect(function()
    activateBtn.BackgroundTransparency = 0.3
end)
activateBtn.MouseLeave:Connect(function()
    activateBtn.BackgroundTransparency = 0.1
end)

-- ==================== DISCORD BUTTON ====================
local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0.35, 0, 0, 32)
discordBtn.Position = UDim2.new(0.325, 0, 0.55, 0)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.BackgroundTransparency = 0.1
discordBtn.TextColor3 = Color3.new(1, 1, 1)
discordBtn.TextSize = 13
discordBtn.Font = Enum.Font.GothamBold
discordBtn.Text = "JOIN DISCORD"
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
    statusText.Text = "Ready"
    statusText.TextColor3 = Color3.fromRGB(150, 150, 170)
end)

-- ==================== STATUS ====================
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.8, 0, 0, 25)
statusText.Position = UDim2.new(0.1, 0, 0.63, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Ready"
statusText.TextColor3 = Color3.fromRGB(150, 150, 170)
statusText.TextSize = 13
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Center
statusText.Parent = container

-- ==================== LOADING BAR ====================
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.8, 0, 0, 3)
barBg.Position = UDim2.new(0.1, 0, 0.7, 0)
barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
barBg.BackgroundTransparency = 0.3
barBg.BorderSizePixel = 0
barBg.Parent = container

local barCorner2 = Instance.new("UICorner")
barCorner2.CornerRadius = UDim.new(0, 2)
barCorner2.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
barFill.BackgroundTransparency = 0.1
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(0, 2)
barFillCorner.Parent = barFill

local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(0.8, 0, 0, 20)
percentText.Position = UDim2.new(0.1, 0, 0.73, 0)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(100, 100, 120)
percentText.TextSize = 12
percentText.Font = Enum.Font.Gotham
percentText.TextXAlignment = Enum.TextXAlignment.Center
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
watermark.Text = "dark-side.lol"
watermark.TextColor3 = Color3.fromRGB(40, 0, 0)
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
    print("[DarkSide] " .. text)
end

-- ==================== MAIN LOADER ====================
local function LoadScript()
    UpdateStatus("Downloading...")
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
    if inputKey and #inputKey > 3 then
        UpdateStatus("✅ Key accepted")
        activateBtn.Text = "✓"
        activateBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        keyBox.Text = ""
        keyBox.PlaceholderText = "Key accepted!"
        task.wait(0.3)
        LoadScript()
    else
        UpdateStatus("❌ Invalid key")
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
print("[DarkSide] Loader v1.0")
print("[DarkSide] Ready")

task.wait(0.3)
keyBox:CaptureFocus()
