-- // Raven Software | Premium Beach Night Loader
-- // Yellow | Red | Black Edition
-- // With Key Authentication System
-- // Fixed: URLs, Authentication, and Execution

-- ================================================
--  LOADER CONFIGURATION
-- ================================================
local LoaderConfig = {
    Name = "Raven Software",
    Version = "2.0.0",
    Developer = "Raven",
    -- THIS IS THE URL TO YOUR ACTUAL SCRIPT - REPLACE WITH YOUR REAL URL
    MenuURL = "https://raw.githubusercontent.com/d7tpolliingr8/dashing-summit/main/rivalsaimwh.lua",
    -- THIS IS THE URL TO YOUR KEYS - CREATE A GIST OR PASTEBIN WITH YOUR KEYS
    KeyURL = "https://pastebin.com/raw/wf8AUinp",
    Key = "Insert",
}

-- ================================================
--  SERVICES
-- ================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local LP = Players.LocalPlayer

-- ================================================
--  KEY SYSTEM
-- ================================================
local KeySystem = {
    ValidKeys = {},
    IsAuthenticated = false,
    KeyStatus = "Waiting for key..."
}

function KeySystem:LoadKeys()
    local success, result = pcall(function()
        return game:HttpGet(LoaderConfig.KeyURL)
    end)
    
    if success and result and result ~= "" then
        for key in string.gmatch(result, "[^\r\n]+") do
            if key ~= "" then
                local cleanKey = key:match("^%s*(.-)%s*$")
                if cleanKey and #cleanKey > 5 then
                    table.insert(self.ValidKeys, cleanKey)
                end
            end
        end
        print("[KeySystem] Loaded " .. #self.ValidKeys .. " valid keys from URL")
        return true
    else
        print("[KeySystem] Failed to load keys from URL, using local fallback")
        -- FALLBACK KEYS (ONLY FOR TESTING - REMOVE FOR PRODUCTION)
        self.ValidKeys = {
            "RAVEN-LF0S-Y6Y4-HMJX-CD",
            "RAVEN-7H3W-K8Q2-LMNP-XY",
            "RAVEN-9V4B-N8M2-KJ6H-GF",
        }
        return true
    end
end

function KeySystem:ValidateKey(inputKey)
    if not inputKey or inputKey == "" then return false end
    inputKey = inputKey:match("^%s*(.-)%s*$")
    
    -- Check against valid keys
    for _, validKey in ipairs(self.ValidKeys) do
        if validKey and validKey ~= "" and validKey == inputKey then
            self.IsAuthenticated = true
            self.KeyStatus = "✅ Key validated successfully!"
            return true
        end
    end
    
    -- Also check if key matches pattern (RAVEN-XXXX-XXXX-XXXX-XX)
    if inputKey:match("^RAVEN%-[A-Z0-9]%-[A-Z0-9]%-[A-Z0-9]%-[A-Z0-9]$") then
        -- This is a valid format, but we need it in our list
        for _, validKey in ipairs(self.ValidKeys) do
            if validKey and validKey ~= "" and validKey == inputKey then
                self.IsAuthenticated = true
                self.KeyStatus = "✅ Key validated successfully!"
                return true
            end
        end
    end
    
    self.KeyStatus = "❌ Invalid key! Please try again."
    return false
end

-- ================================================
--  UI ELEMENTS STORE (for cleanup)
-- ================================================
local LoaderUI = {
    ScreenGui = nil,
    MainFrame = nil,
    Stars = {},
    Clouds = {},
    AuthButton = nil,
    InjectButton = nil,
    KeyInput = nil,
    KeyStatus = nil,
    ProgressFill = nil,
    ProgressText = nil,
    ProgressSection = nil,
    isAuthenticated = false,
}

-- ================================================
--  LOADER UI
-- ================================================
local function CreateLoaderUI()
    -- Create ScreenGui with proper parent
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RavenLoader"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try to parent to CoreGui, fallback to PlayerGui
    local success, err = pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not success then
        pcall(function()
            ScreenGui.Parent = LP:WaitForChild("PlayerGui")
        end)
    end
    
    LoaderUI.ScreenGui = ScreenGui

    -- ================================================
    --  NIGHT SKY BACKGROUND
    -- ================================================
    local SkyBg = Instance.new("Frame")
    SkyBg.Name = "SkyBackground"
    SkyBg.BackgroundColor3 = Color3.fromRGB(10, 8, 30)
    SkyBg.BackgroundTransparency = 0
    SkyBg.BorderSizePixel = 0
    SkyBg.Size = UDim2.new(1, 0, 1, 0)
    SkyBg.Parent = ScreenGui

    -- Gradient overlay
    local Gradient = Instance.new("Frame")
    Gradient.Name = "Gradient"
    Gradient.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Gradient.BackgroundTransparency = 0.3
    Gradient.BorderSizePixel = 0
    Gradient.Size = UDim2.new(1, 0, 1, 0)
    Gradient.Parent = SkyBg

    -- ================================================
    --  STARS
    -- ================================================
    local Stars = {}
    for i = 1, 100 do
        local star = Instance.new("ImageLabel")
        star.Name = "Star_" .. i
        star.BackgroundTransparency = 1
        star.Size = UDim2.new(0, math.random(1, 3), 0, math.random(1, 3))
        star.Position = UDim2.new(math.random() * 0.95, 0, math.random() * 0.7, 0)
        star.Image = "rbxassetid://9727280032" -- Star image
        star.ImageColor3 = Color3.fromRGB(255, 255, 255)
        star.ImageTransparency = 0.3 + math.random() * 0.5
        star.Parent = SkyBg
        
        -- Twinkle animation using TweenService
        task.spawn(function()
            local twinkleDuration = 1 + math.random() * 3
            while LoaderUI.ScreenGui and LoaderUI.ScreenGui.Parent do
                local tween = TweenService:Create(star, TweenInfo.new(
                    twinkleDuration,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut,
                    -1,
                    true
                ), {
                    ImageTransparency = 0.8 + math.random() * 0.2
                })
                tween:Play()
                task.wait(twinkleDuration)
            end
        end)
        
        table.insert(Stars, star)
    end
    LoaderUI.Stars = Stars

    -- ================================================
    --  MOON
    -- ================================================
    local Moon = Instance.new("Frame")
    Moon.Name = "Moon"
    Moon.BackgroundColor3 = Color3.fromRGB(255, 240, 200)
    Moon.BorderSizePixel = 0
    Moon.Size = UDim2.new(0, 70, 0, 70)
    Moon.Position = UDim2.new(0.85, 0, 0.08, 0)
    Moon.Parent = SkyBg
    
    local MoonCorner = Instance.new("UICorner")
    MoonCorner.CornerRadius = UDim.new(1, 0)
    MoonCorner.Parent = Moon
    
    -- Moon glow
    local MoonGlow = Instance.new("ImageLabel")
    MoonGlow.Name = "MoonGlow"
    MoonGlow.BackgroundTransparency = 1
    MoonGlow.Size = UDim2.new(1.8, 0, 1.8, 0)
    MoonGlow.Position = UDim2.new(-0.4, 0, -0.4, 0)
    MoonGlow.Image = "rbxassetid://9727280032"
    MoonGlow.ImageColor3 = Color3.fromRGB(255, 240, 200)
    MoonGlow.ImageTransparency = 0.7
    MoonGlow.Parent = Moon

    -- ================================================
    --  CLOUDS
    -- ================================================
    local Clouds = {}
    local cloudColors = {
        Color3.fromRGB(30, 30, 50),
        Color3.fromRGB(40, 40, 60),
        Color3.fromRGB(35, 35, 55),
    }
    
    for i = 1, 6 do
        local cloud = Instance.new("Frame")
        cloud.BackgroundColor3 = cloudColors[math.random(1, 3)]
        cloud.BackgroundTransparency = 0.4
        cloud.BorderSizePixel = 0
        local size = 150 + math.random() * 150
        local height = 30 + math.random() * 40
        cloud.Size = UDim2.new(0, size, 0, height)
        cloud.Position = UDim2.new(math.random() * 1.2 - 0.1, 0, 0.05 + math.random() * 0.25, 0)
        cloud.Parent = SkyBg
        
        local CloudCorner = Instance.new("UICorner")
        CloudCorner.CornerRadius = UDim.new(0, height/2)
        CloudCorner.Parent = cloud
        
        -- Additional cloud puffs
        for j = 1, 3 do
            local puff = Instance.new("Frame")
            puff.BackgroundColor3 = cloud.BackgroundColor3
            puff.BackgroundTransparency = 0.4
            puff.BorderSizePixel = 0
            puff.Size = UDim2.new(0, 40 + math.random() * 40, 0, 30 + math.random() * 20)
            puff.Position = UDim2.new(0.1 + (j * 0.2) + math.random() * 0.05, 0, 0.2 + math.random() * 0.2, 0)
            puff.Parent = cloud
            
            local PuffCorner = Instance.new("UICorner")
            PuffCorner.CornerRadius = UDim.new(0, 20)
            PuffCorner.Parent = puff
        end
        
        -- Cloud animation
        local startX = cloud.Position.X.Scale
        local speed = 0.2 + math.random() * 0.3
        task.spawn(function()
            while LoaderUI.ScreenGui and LoaderUI.ScreenGui.Parent do
                local newX = cloud.Position.X.Scale + (0.001 * speed)
                if newX > 1.2 then
                    newX = -0.2
                end
                cloud.Position = UDim2.new(newX, 0, cloud.Position.Y.Scale, 0)
                task.wait(0.05)
            end
        end)
        
        table.insert(Clouds, cloud)
    end
    LoaderUI.Clouds = Clouds

    -- ================================================
    --  MAIN FRAME (Glassmorphism)
    -- ================================================
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.BorderSizePixel = 0
    MainFrame.Size = UDim2.new(0, 480, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -200)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame

    -- Glass border
    local Border = Instance.new("UIStroke")
    Border.Color = Color3.fromRGB(255, 215, 0)
    Border.Transparency = 0.2
    Border.Thickness = 1.5
    Border.Parent = MainFrame
    
    LoaderUI.MainFrame = MainFrame

    -- ================================================
    --  HEADER
    -- ================================================
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 80)
    Header.Parent = MainFrame

    -- Raven Icon
    local IconLabel = Instance.new("TextLabel")
    IconLabel.BackgroundTransparency = 1
    IconLabel.Size = UDim2.new(0, 50, 0, 50)
    IconLabel.Position = UDim2.new(0.5, -25, 0, 10)
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Text = "⬡"
    IconLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    IconLabel.TextSize = 44
    IconLabel.TextXAlignment = Enum.TextXAlignment.Center
    IconLabel.TextYAlignment = Enum.TextYAlignment.Center
    IconLabel.Parent = Header

    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, 0, 0, 28)
    TitleLabel.Position = UDim2.new(0, 0, 0, 50)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "RAVEN SOFTWARE"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    TitleLabel.TextSize = 20
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    TitleLabel.Parent = Header

    -- Subtitle
    local SubLabel = Instance.new("TextLabel")
    SubLabel.BackgroundTransparency = 1
    SubLabel.Size = UDim2.new(1, 0, 0, 18)
    SubLabel.Position = UDim2.new(0, 0, 0, 75)
    SubLabel.Font = Enum.Font.GothamMedium
    SubLabel.Text = "Premium Utility Framework v" .. LoaderConfig.Version
    SubLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    SubLabel.TextSize = 10
    SubLabel.TextXAlignment = Enum.TextXAlignment.Center
    SubLabel.Parent = Header

    -- ================================================
    --  KEY INPUT SECTION
    -- ================================================
    local KeySection = Instance.new("Frame")
    KeySection.BackgroundTransparency = 1
    KeySection.Size = UDim2.new(1, -40, 0, 120)
    KeySection.Position = UDim2.new(0, 20, 0, 95)
    KeySection.Parent = MainFrame

    -- Key Label
    local KeyLabel = Instance.new("TextLabel")
    KeyLabel.BackgroundTransparency = 1
    KeyLabel.Size = UDim2.new(1, 0, 0, 25)
    KeyLabel.Font = Enum.Font.GothamMedium
    KeyLabel.Text = "ENTER LICENSE KEY"
    KeyLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    KeyLabel.TextSize = 13
    KeyLabel.TextXAlignment = Enum.TextXAlignment.Center
    KeyLabel.Parent = KeySection

    -- Key Input Box
    local KeyInput = Instance.new("TextBox")
    KeyInput.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    KeyInput.BackgroundTransparency = 0.5
    KeyInput.BorderSizePixel = 0
    KeyInput.Size = UDim2.new(0.85, 0, 0, 38)
    KeyInput.Position = UDim2.new(0.075, 0, 0.25, 0)
    KeyInput.Font = Enum.Font.GothamMedium
    KeyInput.PlaceholderText = "XXXX-XXXX-XXXX-XXXX"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(80, 80, 100)
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.TextSize = 15
    KeyInput.TextXAlignment = Enum.TextXAlignment.Center
    KeyInput.Parent = KeySection

    local KeyInputCorner = Instance.new("UICorner")
    KeyInputCorner.CornerRadius = UDim.new(0, 8)
    KeyInputCorner.Parent = KeyInput

    local KeyInputStroke = Instance.new("UIStroke")
    KeyInputStroke.Color = Color3.fromRGB(255, 215, 0)
    KeyInputStroke.Transparency = 0.3
    KeyInputStroke.Thickness = 1
    KeyInputStroke.Parent = KeyInput
    
    LoaderUI.KeyInput = KeyInput

    -- Key Status Label
    local KeyStatus = Instance.new("TextLabel")
    KeyStatus.BackgroundTransparency = 1
    KeyStatus.Size = UDim2.new(1, 0, 0, 20)
    KeyStatus.Position = UDim2.new(0, 0, 0.7, 0)
    KeyStatus.Font = Enum.Font.GothamMedium
    KeyStatus.Text = "🔑 Enter your license key to continue"
    KeyStatus.TextColor3 = Color3.fromRGB(150, 150, 170)
    KeyStatus.TextSize = 12
    KeyStatus.TextXAlignment = Enum.TextXAlignment.Center
    KeyStatus.Parent = KeySection
    
    LoaderUI.KeyStatus = KeyStatus

    -- ================================================
    --  BUTTON SECTION
    -- ================================================
    local ButtonSection = Instance.new("Frame")
    ButtonSection.BackgroundTransparency = 1
    ButtonSection.Size = UDim2.new(1, -40, 0, 50)
    ButtonSection.Position = UDim2.new(0, 20, 0, 225)
    ButtonSection.Parent = MainFrame

    -- Authenticate Button
    local AuthButton = Instance.new("TextButton")
    AuthButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    AuthButton.BackgroundTransparency = 0.15
    AuthButton.BorderSizePixel = 0
    AuthButton.Size = UDim2.new(0.8, 0, 1, 0)
    AuthButton.Position = UDim2.new(0.1, 0, 0, 0)
    AuthButton.Font = Enum.Font.GothamBold
    AuthButton.Text = "AUTHENTICATE"
    AuthButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    AuthButton.TextSize = 15
    AuthButton.Parent = ButtonSection

    local AuthCorner = Instance.new("UICorner")
    AuthCorner.CornerRadius = UDim.new(0, 8)
    AuthCorner.Parent = AuthButton

    local AuthStroke = Instance.new("UIStroke")
    AuthStroke.Color = Color3.fromRGB(255, 215, 0)
    AuthStroke.Transparency = 0.2
    AuthStroke.Thickness = 1.5
    AuthStroke.Parent = AuthButton
    
    LoaderUI.AuthButton = AuthButton

    -- Hover effects
    AuthButton.MouseEnter:Connect(function()
        AuthButton.BackgroundTransparency = 0
        AuthButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    AuthButton.MouseLeave:Connect(function()
        AuthButton.BackgroundTransparency = 0.15
        AuthButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    -- ================================================
    --  PROGRESS SECTION
    -- ================================================
    local ProgressSection = Instance.new("Frame")
    ProgressSection.BackgroundTransparency = 1
    ProgressSection.Size = UDim2.new(1, -40, 0, 55)
    ProgressSection.Position = UDim2.new(0, 20, 0, 285)
    ProgressSection.Parent = MainFrame
    ProgressSection.Visible = false
    
    LoaderUI.ProgressSection = ProgressSection

    -- Progress Bar Background
    local ProgressBg = Instance.new("Frame")
    ProgressBg.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    ProgressBg.BorderSizePixel = 0
    ProgressBg.Size = UDim2.new(1, 0, 0, 6)
    ProgressBg.Parent = ProgressSection

    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(0, 3)
    ProgressCorner.Parent = ProgressBg

    -- Progress Fill
    local ProgressFill = Instance.new("Frame")
    ProgressFill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    ProgressFill.BorderSizePixel = 0
    ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    ProgressFill.Parent = ProgressBg

    local ProgressFillCorner = Instance.new("UICorner")
    ProgressFillCorner.CornerRadius = UDim.new(0, 3)
    ProgressFillCorner.Parent = ProgressFill
    
    LoaderUI.ProgressFill = ProgressFill

    -- Progress Text
    local ProgressText = Instance.new("TextLabel")
    ProgressText.BackgroundTransparency = 1
    ProgressText.Size = UDim2.new(1, 0, 0, 20)
    ProgressText.Position = UDim2.new(0, 0, 0, 12)
    ProgressText.Font = Enum.Font.GothamMedium
    ProgressText.Text = "0% - Initializing..."
    ProgressText.TextColor3 = Color3.fromRGB(180, 180, 200)
    ProgressText.TextSize = 11
    ProgressText.TextXAlignment = Enum.TextXAlignment.Center
    ProgressText.Parent = ProgressSection
    
    LoaderUI.ProgressText = ProgressText

    -- ================================================
    --  INJECT BUTTON (Hidden until auth)
    -- ================================================
    local InjectButton = Instance.new("TextButton")
    InjectButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    InjectButton.BackgroundTransparency = 0.15
    InjectButton.BorderSizePixel = 0
    InjectButton.Size = UDim2.new(0.8, 0, 1, 0)
    InjectButton.Position = UDim2.new(0.1, 0, 0, 0)
    InjectButton.Font = Enum.Font.GothamBold
    InjectButton.Text = "INJECT RAVEN"
    InjectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    InjectButton.TextSize = 15
    InjectButton.Parent = ButtonSection
    InjectButton.Visible = false

    local InjectCorner = Instance.new("UICorner")
    InjectCorner.CornerRadius = UDim.new(0, 8)
    InjectCorner.Parent = InjectButton

    local InjectStroke = Instance.new("UIStroke")
    InjectStroke.Color = Color3.fromRGB(255, 0, 0)
    InjectStroke.Transparency = 0.2
    InjectStroke.Thickness = 1.5
    InjectStroke.Parent = InjectButton
    
    LoaderUI.InjectButton = InjectButton

    -- Hover effects for Inject
    InjectButton.MouseEnter:Connect(function()
        if LoaderUI.isAuthenticated then
            InjectButton.BackgroundTransparency = 0
            InjectButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        end
    end)
    InjectButton.MouseLeave:Connect(function()
        if LoaderUI.isAuthenticated then
            InjectButton.BackgroundTransparency = 0.15
            InjectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)

    -- ================================================
    --  FOOTER
    -- ================================================
    local Footer = Instance.new("TextLabel")
    Footer.BackgroundTransparency = 1
    Footer.Size = UDim2.new(1, -40, 0, 20)
    Footer.Position = UDim2.new(0, 20, 1, -28)
    Footer.Font = Enum.Font.GothamMedium
    Footer.Text = "© 2026 Raven Software | All Rights Reserved"
    Footer.TextColor3 = Color3.fromRGB(60, 60, 80)
    Footer.TextSize = 9
    Footer.TextXAlignment = Enum.TextXAlignment.Center
    Footer.Parent = MainFrame

    -- ================================================
    --  LOADER LOGIC
    -- ================================================
    
    -- Load valid keys from URL
    KeySystem:LoadKeys()
    
    -- Update status after loading
    KeyStatus.Text = "🔑 " .. (#KeySystem.ValidKeys > 0 and "Enter your license key" or "No keys loaded - contact support")
    
    -- Authenticate function
    local function Authenticate()
        local inputKey = KeyInput.Text
        if inputKey == "" then
            KeyStatus.Text = "⚠️ Please enter a license key!"
            KeyStatus.TextColor3 = Color3.fromRGB(255, 200, 0)
            return
        end
        
        if KeySystem:ValidateKey(inputKey) then
            LoaderUI.isAuthenticated = true
            
            KeyStatus.Text = "✅ Key authenticated! Welcome, Raven User!"
            KeyStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
            
            -- Hide auth elements
            AuthButton.Visible = false
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "✓ Authenticated"
            KeyInput.TextColor3 = Color3.fromRGB(0, 255, 100)
            KeyInput.BackgroundTransparency = 0.8
            
            -- Show inject and progress
            InjectButton.Visible = true
            ProgressSection.Visible = true
            
            -- Animate progress
            task.spawn(function()
                local steps = {
                    {percent = 10, text = "Loading modules..."},
                    {percent = 30, text = "Initializing framework..."},
                    {percent = 50, text = "Configuring settings..."},
                    {percent = 70, text = "Loading assets..."},
                    {percent = 90, text = "Finalizing..."},
                    {percent = 100, text = "Ready to inject!"},
                }
                
                for _, step in ipairs(steps) do
                    ProgressFill.Size = UDim2.new(step.percent / 100, 0, 1, 0)
                    ProgressText.Text = step.percent .. "% - " .. step.text
                    task.wait(0.2 + math.random() * 0.3)
                end
                
                -- Update inject button style
                InjectButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                InjectButton.BackgroundTransparency = 0
                InjectButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                InjectStroke.Color = Color3.fromRGB(255, 215, 0)
            end)
            
        else
            KeyStatus.Text = "❌ Invalid key! Please try again."
            KeyStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "Invalid key, retry..."
            KeyInput.BackgroundTransparency = 0.3
            
            task.wait(1)
            KeyInput.PlaceholderText = "XXXX-XXXX-XXXX-XXXX"
            KeyInput.BackgroundTransparency = 0.5
            KeyStatus.Text = "🔑 Enter your license key"
            KeyStatus.TextColor3 = Color3.fromRGB(150, 150, 170)
        end
    end
    
    -- Auth Button Click
    AuthButton.MouseButton1Click:Connect(Authenticate)
    
    -- Enter key in input field
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            Authenticate()
        end
    end)

    -- Inject Button Click
    InjectButton.MouseButton1Click:Connect(function()
        if not LoaderUI.isAuthenticated then return end
        
        InjectButton.Text = "INJECTING..."
        InjectButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        InjectButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        InjectButton.BackgroundTransparency = 0
        
        -- Execute main script
        task.spawn(function()
            local success, result = pcall(function()
                ProgressText.Text = "📥 Downloading framework..."
                return game:HttpGet(LoaderConfig.MenuURL)
            end)
            
            if success and result and result ~= "" then
                ProgressText.Text = "⚙️ Executing framework..."
                task.wait(0.3)
                
                local execSuccess, execResult = pcall(function()
                    return loadstring(result)()
                end)
                
                if execSuccess then
                    ProgressText.Text = "✅ Injection successful!"
                    InjectButton.Text = "✓ INJECTED"
                    InjectButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
                    InjectButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                    
                    task.wait(0.5)
                    
                    -- Close loader
                    pcall(function()
                        LoaderUI.ScreenGui:Destroy()
                    end)
                    
                    StarterGui:SetCore("SendNotification", {
                        Title = "Raven Software",
                        Text = "Framework loaded! Press Insert to toggle menu.",
                        Duration = 3,
                    })
                else
                    ProgressText.Text = "❌ Execution failed: " .. tostring(execResult)
                    InjectButton.Text = "RETRY"
                    InjectButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    InjectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            else
                ProgressText.Text = "❌ Download failed: " .. tostring(result or "Unknown error")
                InjectButton.Text = "RETRY"
                InjectButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                InjectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end)
    end)

    -- Keybind to toggle (Insert)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode[LoaderConfig.Key] then
            if LoaderUI.ScreenGui then
                LoaderUI.ScreenGui.Enabled = not LoaderUI.ScreenGui.Enabled
            end
        end
    end)

    return ScreenGui
end

-- ================================================
--  INITIALIZE LOADER
-- ================================================
local function InitLoader()
    -- Wait for services to be ready
    task.wait(0.5)
    
    -- Create the UI
    local success, err = pcall(CreateLoaderUI)
    if success then
        print("[Raven Software] Premium Beach Night Loader initialized!")
        print("[Raven Software] Press Insert to show/hide the loader.")
    else
        warn("[Raven Software] Failed to create loader: " .. tostring(err))
        -- Try fallback to PlayerGui
        pcall(function()
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "RavenLoader"
            screenGui.Parent = LP:WaitForChild("PlayerGui")
            print("[Raven Software] Created loader in PlayerGui (fallback)")
        end)
    end
end

-- Start loader
InitLoader()
