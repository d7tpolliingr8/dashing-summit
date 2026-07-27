--[[
    Raven Cheats Loader v9.0
    DEBUG - Shows exact error
    Discord: https://discord.gg/FnKfhZ7Fb6
]]

-- ======================================================================
--  CONFIGURATION
-- ======================================================================

local SCRIPT_URL = "https://raw.githubusercontent.com/d7tpolliingr8/dashing-summit/main/rivalsaimwh.lua"
local LOADER_VERSION = "v9.0"
local DISCORD_INVITE = "https://discord.gg/FnKfhZ7Fb6"

-- ======================================================================
--  SERVICES
-- ======================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

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

-- Simple particles
local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.Parent = background

for i = 1, 20 do
    local particle = Instance.new("Frame")
    local size = math.random(2, 4)
    particle.Size = UDim2.new(0, size, 0, size)
    particle.Position = UDim2.new(math.random() / 2, 0, math.random() / 2, 0)
    particle.BackgroundColor3 = i % 2 == 0 and Color3.fromRGB(220, 20, 20) or Color3.fromRGB(255, 215, 0)
    particle.BackgroundTransparency = math.random(50, 90) / 100
    particle.BorderSizePixel = 0
    particle.Parent = particleContainer
end

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
loadingSection.Size = UDim2.new(0.85, 0, 0, 130)
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
--  STATUS & DEBUG INFO
-- ======================================================================

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.8, 0, 0, 25)
statusText.Position = UDim2.new(0.1, 0, 0.50, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Initializing..."
statusText.TextColor3 = Color3.fromRGB(180, 180, 180)
statusText.TextSize = 13
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Center
statusText.Parent = container

-- Debug text (shows what's happening)
local debugText = Instance.new("TextLabel")
debugText.Size = UDim2.new(0.8, 0, 0, 40)
debugText.Position = UDim2.new(0.1, 0, 0.58, 0)
debugText.BackgroundTransparency = 1
debugText.Text = ""
debugText.TextColor3 = Color3.fromRGB(255, 215, 0)
debugText.TextSize = 11
debugText.Font = Enum.Font.Gotham
debugText.TextXAlignment = Enum.TextXAlignment.Center
debugText.TextWrapped = true
debugText.Parent = container

-- ======================================================================
--  DISCORD BUTTON
-- ======================================================================

local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0.3, 0, 0, 35)
discordBtn.Position = UDim2.new(0.35, 0, 0.70, 0)
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
featureContainer.Position = UDim2.new(0.05, 0, 0.78, 0)
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

local function UpdateDebug(text)
    debugText.Text = text
    print("[Raven DEBUG] " .. text)
end

-- ======================================================================
--  MAIN LOADER (DEBUG)
-- ======================================================================

local function LoadScript()
    UpdateStatus("Downloading script...")
    UpdateDebug("Fetching: " .. SCRIPT_URL)
    AnimateBar(0.2)
    
    task.spawn(function()
        -- STEP 1: Download
        local success, result = pcall(function()
            return game:HttpGet(SCRIPT_URL)
        end)
        
        if not success then
            UpdateStatus("❌ Download failed")
            UpdateDebug("Error: " .. tostring(result))
            AnimateBar(0)
            StarterGui:SetCore("SendNotification", {
                Title = "Raven Cheats",
                Text = "❌ Download failed: " .. tostring(result),
                Duration = 5,
            })
            return
        end
        
        UpdateDebug("Downloaded " .. tostring(#result) .. " bytes")
        AnimateBar(0.4)
        task.wait(0.3)
        
        -- STEP 2: Check if empty
        if not result or #result < 10 then
            UpdateStatus("❌ Script is empty")
            UpdateDebug("File is empty or too small")
            AnimateBar(0)
            return
        end
        
        -- STEP 3: Check if it's HTML (GitHub error page)
        local isHTML = result:match("^%s*<!DOCTYPE") or result:match("^%s*<html")
        if isHTML then
            UpdateStatus("❌ Invalid response (HTML)")
            UpdateDebug("Got HTML instead of Lua. Check URL.")
            AnimateBar(0)
            StarterGui:SetCore("SendNotification", {
                Title = "Raven Cheats",
                Text = "❌ Invalid response. Check the script URL.",
                Duration = 5,
            })
            return
        end
        
        -- STEP 4: Check if it's Lua
        local isLua = result:match("^%s*%-%-") or result:match("^%s*local") or result:match("function") or result:match("loadstring")
        if not isLua then
            UpdateStatus("❌ Not valid Lua")
            UpdateDebug("First 100 chars: " .. string.sub(result, 1, 100))
            AnimateBar(0)
            StarterGui:SetCore("SendNotification", {
                Title = "Raven Cheats",
                Text = "❌ Not a valid Lua script.",
                Duration = 5,
            })
            return
        end
        
        UpdateDebug("Script looks like Lua ✓")
        AnimateBar(0.6)
        task.wait(0.3)
        
        -- STEP 5: Compile
        UpdateStatus("Compiling script...")
        local compileSuccess, compiled = pcall(function()
            return loadstring(result)
        end)
        
        if not compileSuccess then
            UpdateStatus("❌ Compilation failed")
            UpdateDebug("Error: " .. tostring(compiled))
            AnimateBar(0)
            StarterGui:SetCore("SendNotification", {
                Title = "Raven Cheats",
                Text = "❌ Compilation error: " .. tostring(compiled),
                Duration = 5,
            })
            return
        end
        
        if type(compiled) ~= "function" then
            UpdateStatus("❌ Not a function")
            UpdateDebug("loadstring returned: " .. type(compiled))
            AnimateBar(0)
            return
        end
        
        UpdateDebug("Compiled successfully ✓")
        AnimateBar(0.8)
        task.wait(0.3)
        
        -- STEP 6: Execute
        UpdateStatus("Executing Raven Cheats...")
        local execSuccess, execResult = pcall(function()
            return compiled()
        end)
        
        if not execSuccess then
            UpdateStatus("❌ Execution failed")
            UpdateDebug("Error: " .. tostring(execResult))
            AnimateBar(0)
            StarterGui:SetCore("SendNotification", {
                Title = "Raven Cheats",
                Text = "❌ Execution error: " .. tostring(execResult),
                Duration = 5,
            })
            return
        end
        
        UpdateStatus("✅ Raven Cheats Loaded!")
        UpdateDebug("Execution successful ✓")
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
--  START
-- ======================================================================

local function StartLoading()
    print("[Raven] Loader v9.0 - DEBUG")
    print("[Raven] Discord: https://discord.gg/FnKfhZ7Fb6")
    
    UpdateStatus("Initializing...")
    AnimateBar(0.05)
    task.wait(0.3)
    
    UpdateStatus("Ready!")
    AnimateBar(0.1)
    task.wait(0.3)
    
    LoadScript()
end

task.wait(0.5)
StartLoading()
