--[[
    Skelly Hub Loader v6.0
    NO KEY REQUIRED - Auto Load
    Cartoon Theme - Loading Bar
]]

-- ======================================================================
-- CONFIGURATION
-- ======================================================================

local SCRIPT_URL = "https://raw.githubusercontent.com/d7tpolliingr8/dashing-summit/main/rivalsaimwh.lua"
local LOADER_VERSION = "v6.0"
local DISCORD_INVITE = "https://discord.gg/XJtYWy9jgU"

-- ======================================================================
-- SERVICES
-- ======================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- ======================================================================
-- CREATE GUI
-- ======================================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SkellyHubLoader"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999

-- ======================================================================
-- BACKGROUND (Sky Blue)
-- ======================================================================

local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(135, 206, 235)
background.BackgroundTransparency = 0.05
background.Parent = screenGui

-- ======================================================================
-- CLOUDS
-- ======================================================================

local function CreateCloud(x, y, size, speed)
    local cloud = Instance.new("Frame")
    cloud.Size = UDim2.new(0, size, 0, size * 0.4)
    cloud.Position = UDim2.new(x, 0, y, 0)
    cloud.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    cloud.BackgroundTransparency = 0.8
    cloud.BorderSizePixel = 2
    cloud.BorderColor3 = Color3.fromRGB(200, 200, 200)
    cloud.Parent = background
    
    local cloudCorner = Instance.new("UICorner")
    cloudCorner.CornerRadius = UDim.new(1, 0)
    cloudCorner.Parent = cloud
    
    for i = 1, 3 do
        local bump = Instance.new("Frame")
        bump.Size = UDim2.new(0, size * 0.25, 0, size * 0.35)
        bump.Position = UDim2.new(i * 0.2, 0, -0.2, 0)
        bump.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        bump.BackgroundTransparency = 0.8
        bump.BorderSizePixel = 2
        bump.BorderColor3 = Color3.fromRGB(200, 200, 200)
        bump.Parent = cloud
        
        local bumpCorner = Instance.new("UICorner")
        bumpCorner.CornerRadius = UDim.new(1, 0)
        bumpCorner.Parent = bump
    end
    
    task.spawn(function()
        local dir = math.random(1, 2) == 1 and 1 or -1
        while task.wait(0.05) do
            local newX = cloud.Position.X.Scale + 0.001 * dir * speed
            if newX > 1.1 then newX = -0.1 end
            if newX < -0.1 then newX = 1.1 end
            cloud.Position = UDim2.new(newX, 0, cloud.Position.Y.Scale, 0)
        end
    end)
    
    return cloud
end

CreateCloud(0.0, 0.05, 200, 1.0)
CreateCloud(0.3, 0.02, 150, 0.8)
CreateCloud(0.6, 0.08, 180, 0.9)
CreateCloud(0.8, 0.03, 120, 1.2)
CreateCloud(-0.1, 0.15, 160, 0.7)
CreateCloud(0.5, 0.15, 140, 1.1)

-- ======================================================================
-- FLOATING BONES
-- ======================================================================

local function CreateBone(x, y, size)
    local bone = Instance.new("TextLabel")
    bone.Size = UDim2.new(0, size, 0, size)
    bone.Position = UDim2.new(x, 0, y, 0)
    bone.BackgroundTransparency = 1
    bone.Text = "🦴"
    bone.TextColor3 = Color3.fromRGB(200, 200, 200)
    bone.TextSize = size
    bone.Font = Enum.Font.Gotham
    bone.Parent = background
    
    task.spawn(function()
        local yPos = y
        local dir = 1
        while task.wait(0.05) do
            yPos = yPos + 0.001 * dir
            if yPos > 0.9 then dir = -1 end
            if yPos < 0.1 then dir = 1 end
            bone.Position = UDim2.new(x, 0, yPos, 0)
            bone.Rotation = bone.Rotation + 1
        end
    end)
    
    return bone
end

CreateBone(0.02, 0.2, 30)
CreateBone(0.95, 0.5, 25)
CreateBone(0.03, 0.7, 35)
CreateBone(0.92, 0.3, 28)

-- ======================================================================
-- MAIN CONTAINER
-- ======================================================================

local container = Instance.new("Frame")
container.Size = UDim2.new(0, 500, 0, 550)
container.Position = UDim2.new(0.5, -250, 0.5, -275)
container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
container.BackgroundTransparency = 0.15
container.BorderSizePixel = 4
container.BorderColor3 = Color3.fromRGB(200, 200, 200)
container.Parent = background

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 20)
containerCorner.Parent = container

-- ======================================================================
-- CARTOON TITLE
-- ======================================================================

local titleContainer = Instance.new("Frame")
titleContainer.Size = UDim2.new(1, 0, 0, 120)
titleContainer.Position = UDim2.new(0, 0, 0, 20)
titleContainer.BackgroundTransparency = 1
titleContainer.Parent = container

local skellyBig = Instance.new("TextLabel")
skellyBig.Size = UDim2.new(0, 80, 0, 80)
skellyBig.Position = UDim2.new(0.03, 0, 0.1, 0)
skellyBig.BackgroundTransparency = 1
skellyBig.Text = "💀"
skellyBig.TextColor3 = Color3.fromRGB(100, 100, 120)
skellyBig.TextSize = 70
skellyBig.Font = Enum.Font.Gotham
skellyBig.Parent = titleContainer

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.7, 0, 0, 60)
titleText.Position = UDim2.new(0.2, 0, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Skelly Hub"
titleText.TextColor3 = Color3.fromRGB(50, 50, 70)
titleText.TextSize = 52
titleText.Font = Enum.Font.GothamBlack
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextStrokeTransparency = 0.3
titleText.Parent = titleContainer

local v2Badge = Instance.new("Frame")
v2Badge.Size = UDim2.new(0, 50, 0, 30)
v2Badge.Position = UDim2.new(0.75, 0, 0.15, 0)
v2Badge.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
v2Badge.BackgroundTransparency = 0.2
v2Badge.BorderSizePixel = 2
v2Badge.BorderColor3 = Color3.fromRGB(255, 200, 200)
v2Badge.Parent = titleContainer

local v2Corner = Instance.new("UICorner")
v2Corner.CornerRadius = UDim.new(0, 10)
v2Corner.Parent = v2Badge

local v2Text = Instance.new("TextLabel")
v2Text.Size = UDim2.new(1, 0, 1, 0)
v2Text.BackgroundTransparency = 1
v2Text.Text = "V2"
v2Text.TextColor3 = Color3.fromRGB(255, 255, 255)
v2Text.TextSize = 18
v2Text.Font = Enum.Font.GothamBold
v2Text.Parent = v2Badge

local subtitleText = Instance.new("TextLabel")
subtitleText.Size = UDim2.new(0.7, 0, 0, 25)
subtitleText.Position = UDim2.new(0.2, 0, 0.6, 0)
subtitleText.BackgroundTransparency = 1
subtitleText.Text = "RIVALS SCRIPT"
subtitleText.TextColor3 = Color3.fromRGB(150, 150, 170)
subtitleText.TextSize = 16
subtitleText.Font = Enum.Font.Gotham
subtitleText.TextXAlignment = Enum.TextXAlignment.Left
subtitleText.Parent = titleContainer

-- ======================================================================
-- LOADING BAR SECTION
-- ======================================================================

local loadingSection = Instance.new("Frame")
loadingSection.Size = UDim2.new(0.85, 0, 0, 100)
loadingSection.Position = UDim2.new(0.075, 0, 0.25, 0)
loadingSection.BackgroundTransparency = 1
loadingSection.Parent = container

local loadingLabel = Instance.new("TextLabel")
loadingLabel.Size = UDim2.new(1, 0, 0, 30)
loadingLabel.Position = UDim2.new(0, 0, 0, 0)
loadingLabel.BackgroundTransparency = 1
loadingLabel.Text = "Loading Skelly Hub..."
loadingLabel.TextColor3 = Color3.fromRGB(80, 80, 100)
loadingLabel.TextSize = 18
loadingLabel.Font = Enum.Font.GothamBold
loadingLabel.TextXAlignment = Enum.TextXAlignment.Center
loadingLabel.Parent = loadingSection

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(1, 0, 0, 16)
barBg.Position = UDim2.new(0, 0, 0, 35)
barBg.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
barBg.BackgroundTransparency = 0.3
barBg.BorderSizePixel = 2
barBg.BorderColor3 = Color3.fromRGB(180, 180, 190)
barBg.Parent = loadingSection

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
barFill.BackgroundTransparency = 0.1
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = barFill

local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(1, 0, 0, 25)
percentText.Position = UDim2.new(0, 0, 0, 55)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(100, 100, 120)
percentText.TextSize = 14
percentText.Font = Enum.Font.Gotham
percentText.TextXAlignment = Enum.TextXAlignment.Center
percentText.Parent = loadingSection

-- ======================================================================
-- DISCORD BUTTON
-- ======================================================================

local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0.35, 0, 0, 35)
discordBtn.Position = UDim2.new(0.325, 0, 0.45, 0)
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
    statusText.Text = "Loading Skelly Hub..."
    statusText.TextColor3 = Color3.fromRGB(80, 80, 100)
end)

-- ======================================================================
-- STATUS
-- ======================================================================

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.8, 0, 0, 25)
statusText.Position = UDim2.new(0.1, 0, 0.53, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Loading..."
statusText.TextColor3 = Color3.fromRGB(80, 80, 100)
statusText.TextSize = 13
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Center
statusText.Parent = container

-- ======================================================================
-- FOOTER
-- ======================================================================

local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(0.4, 0, 0, 20)
versionText.Position = UDim2.new(0.05, 0, 0.93, 0)
versionText.BackgroundTransparency = 1
versionText.Text = "v" .. LOADER_VERSION
versionText.TextColor3 = Color3.fromRGB(150, 150, 170)
versionText.TextSize = 11
versionText.Font = Enum.Font.Gotham
versionText.TextXAlignment = Enum.TextXAlignment.Left
versionText.Parent = container

local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0.4, 0, 0, 20)
watermark.Position = UDim2.new(0.55, 0, 0.93, 0)
watermark.BackgroundTransparency = 1
watermark.Text = "💀 skelly-hub.lol"
watermark.TextColor3 = Color3.fromRGB(150, 150, 170)
watermark.TextSize = 11
watermark.Font = Enum.Font.Gotham
watermark.TextXAlignment = Enum.TextXAlignment.Right
watermark.Parent = container

-- ======================================================================
-- ANIMATION FUNCTIONS
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
    print("[SkellyHub] " .. text)
end

-- ======================================================================
-- LOADING SEQUENCE
-- ======================================================================

local function StartLoading()
    print("[SkellyHub] Starting loading sequence...")
    
    UpdateStatus("Initializing Skelly Hub...")
    AnimateBar(0.1)
    task.wait(0.3)
    
    UpdateStatus("Loading assets...")
    AnimateBar(0.25)
    task.wait(0.3)
    
    UpdateStatus("Connecting to servers...")
    AnimateBar(0.4)
    task.wait(0.3)
    
    UpdateStatus("Loading scripts...")
    AnimateBar(0.6)
    task.wait(0.3)
    
    UpdateStatus("Preparing Skelly Hub...")
    AnimateBar(0.8)
    task.wait(0.3)
    
    UpdateStatus("Ready! Loading script...")
    AnimateBar(1)
    task.wait(0.5)
    
    LoadScript()
end

-- ======================================================================
-- MAIN LOADER
-- ======================================================================

local function LoadScript()
    UpdateStatus("Downloading Skelly Hub...")
    AnimateBar(0.1)
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
    
    UpdateStatus("Loading Skelly Hub...")
    AnimateBar(0.5)
    task.wait(0.3)
    
    local compileSuccess, compiled = pcall(function()
        return loadstring(scriptContent)
    end)
    
    if not compileSuccess or type(compiled) ~= "function" then
        UpdateStatus("❌ Validation failed - Contact support")
        AnimateBar(0)
        return
    end
    
    UpdateStatus("Executing Skelly Hub...")
    AnimateBar(0.75)
    task.wait(0.3)
    
    local execSuccess, execResult = pcall(function()
        return compiled()
    end)
    
    if not execSuccess then
        UpdateStatus("❌ Execution failed - Try again")
        AnimateBar(0)
        return
    end
    
    UpdateStatus("✅ Skelly Hub Loaded! Press Right Shift for menu")
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
-- START
-- ======================================================================

print("[SkellyHub] Loader v6.0 - No Key Required")
print("[SkellyHub] Discord: https://discord.gg/XJtYWy9jgU")

task.wait(0.5)
StartLoading()
