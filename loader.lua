-- // Raven Software | Premium Beach Night Loader
-- // Yellow | Red | Black Edition
-- // With Key Authentication System

-- ================================================
--  LOADER CONFIGURATION
-- ================================================
local LoaderConfig = {
    Name = "Raven Software",
    Version = "2.0.0",
    Developer = "Raven",
    MenuURL = "https://raw.githubusercontent.com/d7tpolliingr8/dashing-summit/main/rivalsaimwh.lua",
    KeyURL = "https://raw.githubusercontent.com/your-repo/keys/main/valid_keys.txt", -- Replace with your keys URL
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

local LP = Players.LocalPlayer

-- ================================================
--  KEY SYSTEM
-- ================================================
local KeySystem = {
    ValidKeys = {},
    IsAuthenticated = false,
}

function KeySystem:LoadKeys()
    local success, result = pcall(function()
        return game:HttpGet(LoaderConfig.KeyURL)
    end)
    
    if success and result then
        for key in string.gmatch(result, "[^\r\n]+") do
            if key ~= "" then
                table.insert(self.ValidKeys, key:match("^%s*(.-)%s*$"))
            end
        end
        print("[KeySystem] Loaded " .. #self.ValidKeys .. " valid keys")
        return true
    else
        print("[KeySystem] Failed to load keys, using local fallback")
        -- Fallback keys (for testing)
        self.ValidKeys = {
            "RAVEN-FREE-2026",
            "TEST-KEY-1234",
            "PREMIUM-USER-001",
        }
        return true
    end
end

function KeySystem:ValidateKey(inputKey)
    inputKey = inputKey:match("^%s*(.-)%s*$")
    for _, validKey in ipairs(self.ValidKeys) do
        if validKey == inputKey then
            self.IsAuthenticated = true
            return true
        end
    end
    return false
end

-- ================================================
--  LOADER UI
-- ================================================
local Loader = {}

function Loader:CreateUI()
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RavenLoader"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

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
    Gradient.BackgroundTransparency = 0.5
    Gradient.BorderSizePixel = 0
    Gradient.Size = UDim2.new(1, 0, 1, 0)
    Gradient.Parent = SkyBg

    -- ================================================
    --  STARS
    -- ================================================
    local Stars = {}
    for i = 1, 150 do
        local star = Instance.new("Frame")
        star.Name = "Star_" .. i
        star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        star.BackgroundTransparency = 0.3 + math.random() * 0.5
        star.BorderSizePixel = 0
        star.Size = UDim2.new(0, math.random(1, 3), 0, math.random(1, 3))
        star.Position = UDim2.new(math.random() * 0.95, 0, math.random() * 0.7, 0)
        star.Parent = SkyBg
        
        -- Twinkle animation
        local twinkle = TweenService:Create(star, TweenInfo.new(
            1 + math.random() * 2,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {
            BackgroundTransparency = 0.8 + math.random() * 0.2
        })
        twinkle:Play()
        table.insert(Stars, star)
    end

    -- ================================================
    --  MOON
    -- ================================================
    local Moon = Instance.new("Frame")
    Moon.Name = "Moon"
    Moon.BackgroundColor3 = Color3.fromRGB(255, 240, 200)
    Moon.BorderSizePixel = 0
    Moon.Size = UDim2.new(0, 80, 0, 80)
    Moon.Position = UDim2.new(0.85, 0, 0.1, 0)
    Moon.Parent = SkyBg
    
    local MoonCorner = Instance.new("UICorner")
    MoonCorner.CornerRadius = UDim.new(1, 0)
    MoonCorner.Parent = Moon
    
    -- Moon glow
    local MoonGlow = Instance.new("Frame")
    MoonGlow.Name = "MoonGlow"
    MoonGlow.BackgroundColor3 = Color3.fromRGB(255, 240, 200)
    MoonGlow.BackgroundTransparency = 0.7
    MoonGlow.BorderSizePixel = 0
    MoonGlow.Size = UDim2.new(2, 0, 2, 0)
    MoonGlow.Position = UDim2.new(-0.5, 0, -0.5, 0)
    MoonGlow.Parent = Moon
    
    local MoonGlowCorner = Instance.new("UICorner")
    MoonGlowCorner.CornerRadius = UDim.new(1, 0)
    MoonGlowCorner.Parent = MoonGlow

    -- ================================================
    --  CLOUDS
    -- ================================================
    local function CreateCloud(x, y, scale, speed)
        local cloud = Instance.new("Frame")
        cloud.Name = "Cloud"
        cloud.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        cloud.BackgroundTransparency = 0.3
        cloud.BorderSizePixel = 0
        cloud.Size = UDim2.new(0, 200 * scale, 0, 50 * scale)
        cloud.Position = UDim2.new(x, 0, y, 0)
        cloud.Parent = SkyBg
        cloud.ClipsDescendants = false
        
        local CloudCorner = Instance.new("UICorner")
        CloudCorner.CornerRadius = UDim.new(0, 25 * scale)
        CloudCorner.Parent = cloud
        
        -- Cloud puffs
        for i = 1, 5 do
            local puff = Instance.new("Frame")
            puff.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            puff.BackgroundTransparency = 0.3
            puff.BorderSizePixel = 0
            puff.Size = UDim2.new(0, 40 * scale, 0, 30 * scale)
            puff.Position = UDim2.new(0.1 + (i * 0.15), 0, 0.2 + (math.sin(i) * 0.2), 0)
            puff.Parent = cloud
            
            local PuffCorner = Instance.new("UICorner")
            PuffCorner.CornerRadius = UDim.new(0, 15 * scale)
            PuffCorner.Parent = puff
        end
        
        -- Cloud animation
        local startX = x
        task.spawn(function()
            while true do
                local newX = cloud.Position.X.Scale + (0.001 * speed)
                if newX > 1.2 then
                    newX = -0.2
                end
                cloud.Position = UDim2.new(newX, 0, y, 0)
                task.wait(0.05)
            end
        end)
        
        return cloud
    end

    -- Create multiple clouds
    local Clouds = {}
    table.insert(Clouds, CreateCloud(-0.1, 0.12, 1.2, 1))
    table.insert(Clouds, CreateCloud(0.3, 0.05, 0.8, 0.7))
    table.insert(Clouds, CreateCloud(0.6, 0.2, 1.0, 1.2))
    table.insert(Clouds, CreateCloud(0.9, 0.08, 0.6, 0.5))
    table.insert(Clouds, CreateCloud(0.0, 0.28, 0.9, 0.8))
    table.insert(Clouds, CreateCloud(0.4, 0.32, 0.7, 0.6))

    -- ================================================
    --  BEACH SCENE
    -- ================================================
    -- Ocean
    local Ocean = Instance.new("Frame")
    Ocean.Name = "Ocean"
    Ocean.BackgroundColor3 = Color3.fromRGB(15, 20, 50)
    Ocean.BackgroundTransparency = 0
    Ocean.BorderSizePixel = 0
    Ocean.Size = UDim2.new(1, 0, 0, 250)
    Ocean.Position = UDim2.new(0, 0, 0.7, 0)
    Ocean.Parent = SkyBg

    -- Ocean waves animation
    local Waves = Instance.new("Frame")
    Waves.Name = "Waves"
    Waves.BackgroundColor3 = Color3.fromRGB(20, 30, 60)
    Waves.BackgroundTransparency = 0.3
    Waves.BorderSizePixel = 0
    Waves.Size = UDim2.new(1.5, 0, 0, 30)
    Waves.Position = UDim2.new(-0.25, 0, 0, 0)
    Waves.Parent = Ocean

    task.spawn(function()
        while true do
            for i = 1, 100 do
                Waves.Position = UDim2.new(-0.25 + (i * 0.005), 0, 0, 0)
                task.wait(0.02)
            end
            for i = 1, 100 do
                Waves.Position = UDim2.new(0.25 - (i * 0.005), 0, 0, 0)
                task.wait(0.02)
            end
        end
    end)

    -- Beach Sand
    local Sand = Instance.new("Frame")
    Sand.Name = "Sand"
    Sand.BackgroundColor3 = Color3.fromRGB(60, 45, 30)
    Sand.BackgroundTransparency = 0
    Sand.BorderSizePixel = 0
    Sand.Size = UDim2.new(1, 0, 0, 50)
    Sand.Position = UDim2.new(0, 0, 0.9, 0)
    Sand.Parent = SkyBg

    -- Palm Trees
    local function CreatePalmTree(x, y, scale)
        local tree = Instance.new("Frame")
        tree.Name = "PalmTree"
        tree.BackgroundTransparency = 1
        tree.Size = UDim2.new(0, 50 * scale, 0, 80 * scale)
        tree.Position = UDim2.new(x, 0, y, 0)
        tree.Parent = SkyBg

        -- Trunk
        local trunk = Instance.new("Frame")
        trunk.BackgroundColor3 = Color3.fromRGB(40, 25, 15)
        trunk.BorderSizePixel = 0
        trunk.Size = UDim2.new(0, 8 * scale, 0, 60 * scale)
        trunk.Position = UDim2.new(0.42, 0, 0.3, 0)
        trunk.Parent = tree
        
        local TrunkCorner = Instance.new("UICorner")
        TrunkCorner.CornerRadius = UDim.new(0, 4 * scale)
        TrunkCorner.Parent = trunk

        -- Leaves
        local leafColors = {
            Color3.fromRGB(30, 60, 30),
            Color3.fromRGB(35, 70, 35),
            Color3.fromRGB(25, 55, 25),
        }
        
        for i = 1, 8 do
            local leaf = Instance.new("Frame")
            leaf.BackgroundColor3 = leafColors[math.random(1, 3)]
            leaf.BorderSizePixel = 0
            leaf.Size = UDim2.new(0, 25 * scale, 0, 10 * scale)
            local angle = (i / 8) * 2 * math.pi
            leaf.Position = UDim2.new(0.5 + math.cos(angle) * 0.3, 0, 0.1 + math.sin(angle) * 0.1, 0)
            leaf.Rotation = angle * 57.3 + 30
            leaf.Parent = tree
            
            local LeafCorner = Instance.new("UICorner")
            LeafCorner.CornerRadius = UDim.new(0, 5 * scale)
            LeafCorner.Parent = leaf
        end

        return tree
    end

    -- Create palm trees
    CreatePalmTree(0.05, 0.82, 1.2)
    CreatePalmTree(0.15, 0.85, 0.9)
    CreatePalmTree(0.85, 0.83, 1.1)
    CreatePalmTree(0.92, 0.86, 0.8)

    -- ================================================
    --  LOADER MAIN FRAME (Glassmorphism)
    -- ================================================
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 0
    MainFrame.Size = UDim2.new(0, 500, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -210)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame

    -- Glass border
    local Border = Instance.new("UIStroke")
    Border.Color = Color3.fromRGB(255, 215, 0)
    Border.Transparency = 0.3
    Border.Thickness = 2
    Border.Parent = MainFrame

    -- Blur effect (fake)
    local Blur = Instance.new("Frame")
    Blur.Name = "Blur"
    Blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Blur.BackgroundTransparency = 0.3
    Blur.BorderSizePixel = 0
    Blur.Size = UDim2.new(1, 0, 1, 0)
    Blur.Parent = MainFrame

    -- ================================================
    --  HEADER WITH LOGO
    -- ================================================
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 80)
    Header.Parent = MainFrame

    -- Raven Icon
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Name = "IconLabel"
    IconLabel.BackgroundTransparency = 1
    IconLabel.Size = UDim2.new(0, 60, 0, 60)
    IconLabel.Position = UDim2.new(0.5, -30, 0, 10)
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Text = "⬡"
    IconLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    IconLabel.TextSize = 50
    IconLabel.TextXAlignment = Enum.TextXAlignment.Center
    IconLabel.TextYAlignment = Enum.TextYAlignment.Center
    IconLabel.Parent = Header

    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.Position = UDim2.new(0, 0, 0, 50)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "RAVEN SOFTWARE"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    TitleLabel.TextSize = 22
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
    TitleLabel.Parent = Header

    -- Subtitle
    local SubLabel = Instance.new("TextLabel")
    SubLabel.Name = "SubLabel"
    SubLabel.BackgroundTransparency = 1
    SubLabel.Size = UDim2.new(1, 0, 0, 20)
    SubLabel.Position = UDim2.new(0, 0, 0, 78)
    SubLabel.Font = Enum.Font.GothamMedium
    SubLabel.Text = "Premium Utility Framework v" .. LoaderConfig.Version
    SubLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    SubLabel.TextSize = 11
    SubLabel.TextXAlignment = Enum.TextXAlignment.Center
    SubLabel.TextYAlignment = Enum.TextYAlignment.Center
    SubLabel.Parent = Header

    -- Red accent line
    local AccentLine = Instance.new("Frame")
    AccentLine.Name = "AccentLine"
    AccentLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    AccentLine.BorderSizePixel = 0
    AccentLine.Size = UDim2.new(0, 60, 0, 3)
    AccentLine.Position = UDim2.new(0.5, -30, 0, 96)
    AccentLine.Parent = Header

    -- ================================================
    --  KEY INPUT SECTION
    -- ================================================
    local KeySection = Instance.new("Frame")
    KeySection.Name = "KeySection"
    KeySection.BackgroundTransparency = 1
    KeySection.Size = UDim2.new(1, -40, 0, 120)
    KeySection.Position = UDim2.new(0, 20, 0, 110)
    KeySection.Parent = MainFrame

    -- Key Label
    local KeyLabel = Instance.new("TextLabel")
    KeyLabel.Name = "KeyLabel"
    KeyLabel.BackgroundTransparency = 1
    KeyLabel.Size = UDim2.new(1, 0, 0, 25)
    KeyLabel.Font = Enum.Font.GothamMedium
    KeyLabel.Text = "ENTER LICENSE KEY"
    KeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyLabel.TextSize = 14
    KeyLabel.TextXAlignment = Enum.TextXAlignment.Center
    KeyLabel.TextYAlignment = Enum.TextYAlignment.Center
    KeyLabel.Parent = KeySection

    -- Key Input Box
    local KeyInput = Instance.new("TextBox")
    KeyInput.Name = "KeyInput"
    KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    KeyInput.BackgroundTransparency = 0.5
    KeyInput.BorderSizePixel = 0
    KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
    KeyInput.Position = UDim2.new(0.1, 0, 0.25, 0)
    KeyInput.Font = Enum.Font.GothamMedium
    KeyInput.PlaceholderText = "XXXX-XXXX-XXXX-XXXX"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.TextSize = 16
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

    -- Key Status Label
    local KeyStatus = Instance.new("TextLabel")
    KeyStatus.Name = "KeyStatus"
    KeyStatus.BackgroundTransparency = 1
    KeyStatus.Size = UDim2.new(1, 0, 0, 20)
    KeyStatus.Position = UDim2.new(0, 0, 0.75, 0)
    KeyStatus.Font = Enum.Font.GothamMedium
    KeyStatus.Text = "Waiting for key..."
    KeyStatus.TextColor3 = Color3.fromRGB(150, 150, 170)
    KeyStatus.TextSize = 12
    KeyStatus.TextXAlignment = Enum.TextXAlignment.Center
    KeyStatus.TextYAlignment = Enum.TextYAlignment.Center
    KeyStatus.Parent = KeySection

    -- ================================================
    --  BUTTONS
    -- ================================================
    local ButtonSection = Instance.new("Frame")
    ButtonSection.Name = "ButtonSection"
    ButtonSection.BackgroundTransparency = 1
    ButtonSection.Size = UDim2.new(1, -40, 0, 60)
    ButtonSection.Position = UDim2.new(0, 20, 0, 240)
    ButtonSection.Parent = MainFrame

    -- Authenticate Button
    local AuthButton = Instance.new("TextButton")
    AuthButton.Name = "AuthButton"
    AuthButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    AuthButton.BackgroundTransparency = 0.1
    AuthButton.BorderSizePixel = 0
    AuthButton.Size = UDim2.new(0.8, 0, 0, 40)
    AuthButton.Position = UDim2.new(0.1, 0, 0, 0)
    AuthButton.Font = Enum.Font.GothamBold
    AuthButton.Text = "AUTHENTICATE"
    AuthButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    AuthButton.TextSize = 16
    AuthButton.Parent = ButtonSection

    local AuthCorner = Instance.new("UICorner")
    AuthCorner.CornerRadius = UDim.new(0, 8)
    AuthCorner.Parent = AuthButton

    local AuthStroke = Instance.new("UIStroke")
    AuthStroke.Color = Color3.fromRGB(255, 215, 0)
    AuthStroke.Transparency = 0.3
    AuthStroke.Thickness = 1.5
    AuthStroke.Parent = AuthButton

    -- ================================================
    --  PROGRESS BAR (Hidden until authenticated)
    -- ================================================
    local ProgressSection = Instance.new("Frame")
    ProgressSection.Name = "ProgressSection"
    ProgressSection.BackgroundTransparency = 1
    ProgressSection.Size = UDim2.new(1, -40, 0, 60)
    ProgressSection.Position = UDim2.new(0, 20, 0, 310)
    ProgressSection.Parent = MainFrame
    ProgressSection.Visible = false

    -- Progress Bar Background
    local ProgressBg = Instance.new("Frame")
    ProgressBg.Name = "ProgressBg"
    ProgressBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    ProgressBg.BorderSizePixel = 0
    ProgressBg.Size = UDim2.new(1, 0, 0, 8)
    ProgressBg.Position = UDim2.new(0, 0, 0, 0)
    ProgressBg.Parent = ProgressSection

    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(0, 4)
    ProgressCorner.Parent = ProgressBg

    -- Progress Fill
    local ProgressFill = Instance.new("Frame")
    ProgressFill.Name = "ProgressFill"
    ProgressFill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    ProgressFill.BorderSizePixel = 0
    ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    ProgressFill.Parent = ProgressBg

    local ProgressFillCorner = Instance.new("UICorner")
    ProgressFillCorner.CornerRadius = UDim.new(0, 4)
    ProgressFillCorner.Parent = ProgressFill

    -- Progress Text
    local ProgressText = Instance.new("TextLabel")
    ProgressText.Name = "ProgressText"
    ProgressText.BackgroundTransparency = 1
    ProgressText.Size = UDim2.new(1, 0, 0, 20)
    ProgressText.Position = UDim2.new(0, 0, 0, 15)
    ProgressText.Font = Enum.Font.GothamMedium
    ProgressText.Text = "0% - Initializing..."
    ProgressText.TextColor3 = Color3.fromRGB(200, 200, 220)
    ProgressText.TextSize = 12
    ProgressText.TextXAlignment = Enum.TextXAlignment.Center
    ProgressText.TextYAlignment = Enum.TextYAlignment.Center
    ProgressText.Parent = ProgressSection

    -- ================================================
    --  INJECT BUTTON (Hidden until key auth)
    -- ================================================
    local InjectButton = Instance.new("TextButton")
    InjectButton.Name = "InjectButton"
    InjectButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    InjectButton.BackgroundTransparency = 0.1
    InjectButton.BorderSizePixel = 0
    InjectButton.Size = UDim2.new(0.8, 0, 0, 40)
    InjectButton.Position = UDim2.new(0.1, 0, 0, 0)
    InjectButton.Font = Enum.Font.GothamBold
    InjectButton.Text = "INJECT RAVEN"
    InjectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    InjectButton.TextSize = 16
    InjectButton.Parent = ButtonSection
    InjectButton.Visible = false

    local InjectCorner = Instance.new("UICorner")
    InjectCorner.CornerRadius = UDim.new(0, 8)
    InjectCorner.Parent = InjectButton

    local InjectStroke = Instance.new("UIStroke")
    InjectStroke.Color = Color3.fromRGB(255, 0, 0)
    InjectStroke.Transparency = 0.3
    InjectStroke.Thickness = 1.5
    InjectStroke.Parent = InjectButton

    -- ================================================
    --  FOOTER
    -- ================================================
    local Footer = Instance.new("TextLabel")
    Footer.Name = "Footer"
    Footer.BackgroundTransparency = 1
    Footer.Size = UDim2.new(1, -40, 0, 20)
    Footer.Position = UDim2.new(0, 20, 1, -30)
    Footer.Font = Enum.Font.GothamMedium
    Footer.Text = "© 2026 Raven Software | All Rights Reserved"
    Footer.TextColor3 = Color3.fromRGB(80, 80, 100)
    Footer.TextSize = 10
    Footer.TextXAlignment = Enum.TextXAlignment.Center
    Footer.TextYAlignment = Enum.TextYAlignment.Center
    Footer.Parent = MainFrame

    -- ================================================
    --  LOADER LOGIC
    -- ================================================
    local isAuthenticated = false
    
    -- Load valid keys
    KeySystem:LoadKeys()

    -- Authenticate Button Click
    AuthButton.MouseButton1Click:Connect(function()
        local inputKey = KeyInput.Text
        if inputKey == "" then
            KeyStatus.Text = "⚠️ Please enter a license key!"
            KeyStatus.TextColor3 = Color3.fromRGB(255, 200, 0)
            return
        end
        
        if KeySystem:ValidateKey(inputKey) then
            isAuthenticated = true
            KeyStatus.Text = "✅ Key authenticated! Welcome, Raven User!"
            KeyStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
            
            -- Hide auth elements, show inject
            AuthButton.Visible = false
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "✓ Authenticated"
            KeyInput.TextColor3 = Color3.fromRGB(0, 255, 100)
            
            InjectButton.Visible = true
            ProgressSection.Visible = true
            
            -- Animate progress
            task.spawn(function()
                for i = 0, 100, 2 do
                    ProgressFill.Size = UDim2.new(i / 100, 0, 1, 0)
                    ProgressText.Text = i .. "% - Loading modules..."
                    task.wait(0.02)
                end
                ProgressText.Text = "100% - Ready to inject!"
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
            task.wait(1)
            KeyInput.PlaceholderText = "XXXX-XXXX-XXXX-XXXX"
            KeyStatus.Text = "Waiting for key..."
            KeyStatus.TextColor3 = Color3.fromRGB(150, 150, 170)
        end
    end)

    -- Inject Button Click
    InjectButton.MouseButton1Click:Connect(function()
        if not isAuthenticated then return end
        
        InjectButton.Text = "INJECTING..."
        InjectButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        InjectButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        
        -- Execute main script
        local success, result = pcall(function()
            ProgressText.Text = "Downloading framework..."
            return loadstring(game:HttpGet(LoaderConfig.MenuURL))()
        end)
        
        if success and result then
            ProgressText.Text = "Executing framework..."
            task.wait(0.5)
            
            local mainSuccess = pcall(function()
                result()
            end)
            
            if mainSuccess then
                ProgressText.Text = "✅ Injection successful!"
                InjectButton.Text = "✓ INJECTED"
                InjectButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
                InjectButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                
                task.wait(1)
                ScreenGui:Destroy()
                
                StarterGui:SetCore("SendNotification", {
                    Title = "Raven Software",
                    Text = "Framework loaded! Press Insert to toggle menu.",
                    Duration = 3,
                })
            else
                ProgressText.Text = "❌ Execution failed!"
                InjectButton.Text = "RETRY"
                InjectButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
        else
            ProgressText.Text = "❌ Download failed!"
            InjectButton.Text = "RETRY"
            InjectButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
    end)

    -- Hover effects
    AuthButton.MouseEnter:Connect(function()
        AuthButton.BackgroundTransparency = 0
        AuthButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    
    AuthButton.MouseLeave:Connect(function()
        AuthButton.BackgroundTransparency = 0.1
        AuthButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    InjectButton.MouseEnter:Connect(function()
        if isAuthenticated then
            InjectButton.BackgroundTransparency = 0
        end
    end)
    
    InjectButton.MouseLeave:Connect(function()
        if isAuthenticated then
            InjectButton.BackgroundTransparency = 0.1
        end
    end)

    -- Keybind to toggle (Insert)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode[LoaderConfig.Key] then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    return ScreenGui
end

-- ================================================
--  INITIALIZE LOADER
-- ================================================
Loader:CreateUI()
print("[Raven Software] Premium Beach Night Loader initialized!")
print("[Raven Software] Press Insert to show/hide the loader.")
