--[[
    DarkSide Loader v1.1
    Red & Black Theme
    Premium Script Loader for Rivals
]]

-- ==================== CONFIGURATION ====================
local SCRIPT_URL = "https://raw.githubusercontent.com/jabu62012-commits/rivals-free-script/main/rivalsaimwh.lua"
local LOADER_VERSION = "v1.1"
local LOADER_NAME = "DarkSide"

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local HttpEnabled = syn and syn.request or http and http.request or request

-- ==================== CREATE LOADING SCREEN ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkSideLoader"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
mainFrame.BackgroundTransparency = 0.05
mainFrame.Parent = screenGui

-- Center Container
local container = Instance.new("Frame")
container.Size = UDim2.new(0, 500, 0, 400)
container.Position = UDim2.new(0.5, -250, 0.5, -200)
container.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
container.BorderSizePixel = 3
container.BorderColor3 = Color3.fromRGB(200, 0, 0)
container.BackgroundTransparency = 0.1
container.Parent = mainFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = container

-- DarkSide Logo/Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 70)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "DARK SIDE"
title.TextColor3 = Color3.fromRGB(200, 0, 0)
title.TextSize = 48
title.TextScaled = false
title.Font = Enum.Font.GothamBold
title.TextStrokeColor3 = Color3.fromRGB(50, 0, 0)
title.TextStrokeTransparency = 0.5
title.Parent = container

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 30)
subtitle.Position = UDim2.new(0, 0, 0, 75)
subtitle.BackgroundTransparency = 1
subtitle.Text = "PREMIUM RIVALS SCRIPT"
subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitle.TextSize = 18
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = container

-- Loading Bar Background
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.8, 0, 0, 12)
barBg.Position = UDim2.new(0.1, 0, 0, 130)
barBg.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
barBg.BorderSizePixel = 1
barBg.BorderColor3 = Color3.fromRGB(100, 0, 0)
barBg.Parent = container

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 6)
barCorner.Parent = barBg

-- Loading Bar Fill
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(0, 6)
barFillCorner.Parent = barFill

-- Loading Text
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0, 30)
loadingText.Position = UDim2.new(0, 0, 0, 150)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Initializing..."
loadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
loadingText.TextSize = 16
loadingText.Font = Enum.Font.Gotham
loadingText.Parent = container

-- Status Details
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0, 25)
statusText.Position = UDim2.new(0, 0, 0, 180)
statusText.BackgroundTransparency = 1
statusText.Text = "Connecting to DarkSide servers..."
statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextTransparency = 0.5
statusText.Parent = container

-- Error Display (hidden initially)
local errorText = Instance.new("TextLabel")
errorText.Size = UDim2.new(0.9, 0, 0, 60)
errorText.Position = UDim2.new(0.05, 0, 0, 220)
errorText.BackgroundTransparency = 1
errorText.Text = ""
errorText.TextColor3 = Color3.fromRGB(255, 50, 50)
errorText.TextSize = 14
errorText.Font = Enum.Font.Gotham
errorText.TextWrapped = true
errorText.Visible = false
errorText.Parent = container

-- Version
local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(1, 0, 0, 25)
versionText.Position = UDim2.new(0, 0, 0, 350)
versionText.BackgroundTransparency = 1
versionText.Text = "Version " .. LOADER_VERSION
versionText.TextColor3 = Color3.fromRGB(100, 100, 100)
versionText.TextSize = 12
versionText.Font = Enum.Font.Gotham
versionText.TextTransparency = 0.5
versionText.Parent = container

-- Brand Watermark
local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(1, 0, 0, 25)
watermark.Position = UDim2.new(0, 0, 1, -30)
watermark.BackgroundTransparency = 1
watermark.Text = "dark-side.lol"
watermark.TextColor3 = Color3.fromRGB(80, 0, 0)
watermark.TextSize = 14
watermark.Font = Enum.Font.GothamBold
watermark.TextTransparency = 0.6
watermark.Parent = container

-- Glow Line
local glowLine = Instance.new("Frame")
glowLine.Size = UDim2.new(0.9, 0, 0, 2)
glowLine.Position = UDim2.new(0.05, 0, 0.95, 0)
glowLine.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
glowLine.BackgroundTransparency = 0.7
glowLine.BorderSizePixel = 0
glowLine.Parent = container

-- ==================== ANIMATION FUNCTIONS ====================
local function AnimateBar(progress)
    local targetSize = UDim2.new(progress, 0, 1, 0)
    local tween = TweenService:Create(barFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = targetSize
    })
    tween:Play()
    return tween
end

local function UpdateText(text, status)
    loadingText.Text = text
    if status then
        statusText.Text = status
    end
    print("[DarkSide] " .. text)
end

local function ShowError(msg)
    errorText.Text = "❌ " .. msg
    errorText.Visible = true
    statusText.TextColor3 = Color3.fromRGB(200, 0, 0)
    loadingText.TextColor3 = Color3.fromRGB(200, 0, 0)
end

-- ==================== PULSE GLOW ====================
local function PulseGlow()
    local tween = TweenService:Create(glowLine, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
        BackgroundTransparency = 0.3
    })
    tween:Play()
end
PulseGlow()

-- ==================== LOADING DOTS ====================
local dotCount = 0
local function AnimateDots()
    dotCount = (dotCount % 3) + 1
    local dots = string.rep(".", dotCount)
    loadingText.Text = loadingText.Text:gsub("%.+$", "") .. dots
end

-- ==================== MAIN LOADER FUNCTION ====================
local function LoadScript()
    UpdateText("Loading DarkSide Script", "Fetching from server...")
    AnimateBar(0.1)
    task.wait(0.3)
    
    UpdateText("Connecting to DarkSide servers", "Handshake in progress...")
    AnimateBar(0.2)
    task.wait(0.3)
    
    UpdateText("Downloading script", "Retrieving from repository...")
    AnimateBar(0.4)
    task.wait(0.3)
    
    -- Download the script
    local success, scriptContent = pcall(function()
        return game:HttpGet(SCRIPT_URL)
    end)
    
    if not success then
        ShowError("Download Failed!\nCheck your internet connection.")
        AnimateBar(0)
        return
    end
    
    -- Check if script is empty
    if not scriptContent or #scriptContent < 10 then
        ShowError("Script is empty or invalid!\nContact support.")
        AnimateBar(0)
        return
    end
    
    UpdateText("Verifying script", "Checking integrity...")
    AnimateBar(0.6)
    task.wait(0.3)
    
    -- Try to compile the script
    local compileSuccess, compiled = pcall(function()
        return loadstring(scriptContent)
    end)
    
    if not compileSuccess then
        ShowError("Script compilation failed!\nError: " .. tostring(compiled))
        AnimateBar(0)
        return
    end
    
    if type(compiled) ~= "function" then
        ShowError("Script is not a valid Lua script!")
        AnimateBar(0)
        return
    end
    
    UpdateText("Executing DarkSide Script", "Injecting into game...")
    AnimateBar(0.8)
    task.wait(0.3)
    
    -- Execute the script
    local execSuccess, execResult = pcall(function()
        return compiled()
    end)
    
    if not execSuccess then
        ShowError("Execution failed!\nError: " .. tostring(execResult))
        AnimateBar(0)
        return
    end
    
    -- Success!
    UpdateText("DarkSide Script Loaded!", "Press INSERT to open menu")
    AnimateBar(1)
    statusText.TextColor3 = Color3.fromRGB(0, 200, 0)
    loadingText.TextColor3 = Color3.fromRGB(0, 200, 0)
    
    -- Success animation
    local successGlow = Instance.new("Frame")
    successGlow.Size = UDim2.new(1, 0, 1, 0)
    successGlow.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    successGlow.BackgroundTransparency = 0.8
    successGlow.BorderSizePixel = 0
    successGlow.Parent = container
    
    local glowTween = TweenService:Create(successGlow, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    glowTween:Play()
    glowTween.Completed:Connect(function()
        successGlow:Destroy()
    end)
    
    task.wait(2)
    local fadeTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    fadeTween:Play()
    fadeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

-- ==================== START LOADER ====================
local dotTimer = 0
RunService.RenderStepped:Connect(function()
    dotTimer = dotTimer + 1
    if dotTimer % 30 == 0 then
        AnimateDots()
    end
end)

task.wait(0.5)
LoadScript()

print("[DarkSide] Loader initialized.")
print("[DarkSide] Version: " .. LOADER_VERSION)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F9 then
        screenGui.Enabled = not screenGui.Enabled
    end
end)
