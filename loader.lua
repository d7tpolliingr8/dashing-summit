-- // Raven Software | Customer Loader
-- // Yellow | Red | Black Edition
-- // Premium Utility Framework Loader

-- ================================================
--  LOADER CONFIGURATION
-- ================================================
local LoaderConfig = {
    Name = "Raven Software",
    Version = "1.0.0",
    Developer = "Raven",
    Colors = {
        Yellow = Color3.fromRGB(255, 215, 0),
        Red = Color3.fromRGB(255, 0, 0),
        DarkRed = Color3.fromRGB(180, 0, 0),
        Black = Color3.fromRGB(0, 0, 0),
        DarkGray = Color3.fromRGB(20, 20, 20),
        Gray = Color3.fromRGB(40, 40, 40),
        White = Color3.fromRGB(255, 255, 255),
    },
    Links = {
        Main = "https://raw.githubusercontent.com/your-repo/Raven-Software/main/menu.lua",
        Config = "https://raw.githubusercontent.com/your-repo/Raven-Software/main/config.lua",
    },
    Key = "Insert",
}

-- ================================================
--  LOADER UI
-- ================================================
local Loader = {}

function Loader:CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RavenLoader"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = LoaderConfig.Colors.Black
    MainFrame.BackgroundTransparency = 0.95
    MainFrame.BorderSizePixel = 0
    MainFrame.Size = UDim2.new(0, 450, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- Glass Effect Background
    local GlassBg = Instance.new("Frame")
    GlassBg.Name = "GlassBackground"
    GlassBg.BackgroundColor3 = LoaderConfig.Colors.DarkGray
    GlassBg.BackgroundTransparency = 0.3
    GlassBg.BorderSizePixel = 0
    GlassBg.Size = UDim2.new(1, 0, 1, 0)
    GlassBg.Parent = MainFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = GlassBg

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = LoaderConfig.Colors.Red
    Stroke.Transparency = 0.4
    Stroke.Thickness = 2
    Stroke.Parent = GlassBg

    -- Red Accent Line (Left)
    local AccentLine = Instance.new("Frame")
    AccentLine.Name = "AccentLine"
    AccentLine.BackgroundColor3 = LoaderConfig.Colors.Red
    AccentLine.BackgroundTransparency = 0
    AccentLine.Size = UDim2.new(0, 4, 1, 0)
    AccentLine.Parent = MainFrame

    -- Logo Section
    local LogoContainer = Instance.new("Frame")
    LogoContainer.Name = "LogoContainer"
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Size = UDim2.new(1, 0, 0, 80)
    LogoContainer.Position = UDim2.new(0, 0, 0, 20)
    LogoContainer.Parent = MainFrame

    -- Raven Icon (Text-based)
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Name = "IconLabel"
    IconLabel.BackgroundTransparency = 1
    IconLabel.Size = UDim2.new(0, 50, 0, 50)
    IconLabel.Position = UDim2.new(0.5, -85, 0, 15)
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Text = "⬡"
    IconLabel.TextColor3 = LoaderConfig.Colors.Yellow
    IconLabel.TextSize = 40
    IconLabel.TextXAlignment = Enum.TextXAlignment.Center
    IconLabel.TextYAlignment = Enum.TextYAlignment.Center
    IconLabel.Parent = LogoContainer

    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(0, 300, 0, 30)
    TitleLabel.Position = UDim2.new(0.5, -25, 0, 15)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "RAVEN SOFTWARE"
    TitleLabel.TextColor3 = LoaderConfig.Colors.Yellow
    TitleLabel.TextSize = 24
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
    TitleLabel.Parent = LogoContainer

    -- Subtitle
    local SubLabel = Instance.new("TextLabel")
    SubLabel.Name = "SubLabel"
    SubLabel.BackgroundTransparency = 1
    SubLabel.Size = UDim2.new(0, 300, 0, 20)
    SubLabel.Position = UDim2.new(0.5, -25, 0, 45)
    SubLabel.Font = Enum.Font.GothamMedium
    SubLabel.Text = "Premium Utility Framework v" .. LoaderConfig.Version
    SubLabel.TextColor3 = LoaderConfig.Colors.Red
    SubLabel.TextSize = 12
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.TextYAlignment = Enum.TextYAlignment.Center
    SubLabel.Parent = LogoContainer

    -- Divider Line
    local Divider = Instance.new("Frame")
    Divider.Name = "Divider"
    Divider.BackgroundColor3 = LoaderConfig.Colors.Gray
    Divider.BackgroundTransparency = 0.5
    Divider.Size = UDim2.new(0.85, 0, 0, 1)
    Divider.Position = UDim2.new(0.075, 0, 0, 100)
    Divider.Parent = MainFrame

    -- Status Section
    local StatusContainer = Instance.new("Frame")
    StatusContainer.Name = "StatusContainer"
    StatusContainer.BackgroundTransparency = 1
    StatusContainer.Size = UDim2.new(1, 0, 0, 100)
    StatusContainer.Position = UDim2.new(0, 0, 0, 115)
    StatusContainer.Parent = MainFrame

    -- Status Label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Size = UDim2.new(1, -40, 0, 25)
    StatusLabel.Position = UDim2.new(0, 20, 0, 10)
    StatusLabel.Font = Enum.Font.GothamMedium
    StatusLabel.Text = "◉ Initializing..."
    StatusLabel.TextColor3 = LoaderConfig.Colors.Yellow
    StatusLabel.TextSize = 14
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.TextYAlignment = Enum.TextYAlignment.Center
    StatusLabel.Parent = StatusContainer

    -- Progress Bar Background
    local ProgressBg = Instance.new("Frame")
    ProgressBg.Name = "ProgressBg"
    ProgressBg.BackgroundColor3 = LoaderConfig.Colors.DarkGray
    ProgressBg.BorderSizePixel = 0
    ProgressBg.Size = UDim2.new(0.9, 0, 0, 8)
    ProgressBg.Position = UDim2.new(0.05, 0, 0, 45)
    ProgressBg.Parent = StatusContainer

    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(0, 4)
    ProgressCorner.Parent = ProgressBg

    -- Progress Bar Fill
    local ProgressFill = Instance.new("Frame")
    ProgressFill.Name = "ProgressFill"
    ProgressFill.BackgroundColor3 = LoaderConfig.Colors.Red
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
    ProgressText.Position = UDim2.new(0, 0, 0, 60)
    ProgressText.Font = Enum.Font.GothamMedium
    ProgressText.Text = "0%"
    ProgressText.TextColor3 = LoaderConfig.Colors.White
    ProgressText.TextSize = 12
    ProgressText.TextXAlignment = Enum.TextXAlignment.Center
    ProgressText.TextYAlignment = Enum.TextYAlignment.Center
    ProgressText.Parent = StatusContainer

    -- Details Label
    local DetailsLabel = Instance.new("TextLabel")
    DetailsLabel.Name = "DetailsLabel"
    DetailsLabel.BackgroundTransparency = 1
    DetailsLabel.Size = UDim2.new(1, -40, 0, 20)
    DetailsLabel.Position = UDim2.new(0, 20, 0, 80)
    DetailsLabel.Font = Enum.Font.GothamMedium
    DetailsLabel.Text = "Loading modules..."
    DetailsLabel.TextColor3 = LoaderConfig.Colors.Gray
    DetailsLabel.TextSize = 11
    DetailsLabel.TextXAlignment = Enum.TextXAlignment.Left
    DetailsLabel.TextYAlignment = Enum.TextYAlignment.Center
    DetailsLabel.Parent = StatusContainer

    -- Button Section
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Name = "ButtonContainer"
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Size = UDim2.new(1, 0, 0, 50)
    ButtonContainer.Position = UDim2.new(0, 0, 0, 230)
    ButtonContainer.Parent = MainFrame

    -- Load Button
    local LoadButton = Instance.new("TextButton")
    LoadButton.Name = "LoadButton"
    LoadButton.BackgroundColor3 = LoaderConfig.Colors.Red
    LoadButton.BackgroundTransparency = 0.2
    LoadButton.BorderSizePixel = 0
    LoadButton.Size = UDim2.new(0, 150, 0, 35)
    LoadButton.Position = UDim2.new(0.5, -75, 0, 0)
    LoadButton.Font = Enum.Font.GothamBold
    LoadButton.Text = "INJECT"
    LoadButton.TextColor3 = LoaderConfig.Colors.White
    LoadButton.TextSize = 14
    LoadButton.Parent = ButtonContainer

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = LoadButton

    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = LoaderConfig.Colors.Yellow
    ButtonStroke.Transparency = 0.3
    ButtonStroke.Thickness = 1.5
    ButtonStroke.Parent = LoadButton

    -- Footer
    local FooterLabel = Instance.new("TextLabel")
    FooterLabel.Name = "FooterLabel"
    FooterLabel.BackgroundTransparency = 1
    FooterLabel.Size = UDim2.new(1, 0, 0, 20)
    FooterLabel.Position = UDim2.new(0, 0, 1, -25)
    FooterLabel.Font = Enum.Font.GothamMedium
    FooterLabel.Text = "© 2026 Raven Software | All Rights Reserved"
    FooterLabel.TextColor3 = LoaderConfig.Colors.Gray
    FooterLabel.TextSize = 10
    FooterLabel.TextXAlignment = Enum.TextXAlignment.Center
    FooterLabel.TextYAlignment = Enum.TextYAlignment.Center
    FooterLabel.Parent = MainFrame

    -- Animation Variables
    local progress = 0
    local isLoaded = false

    -- Progress Animation
    local function UpdateProgress(value, status, details)
        progress = math.min(value, 100)
        ProgressFill.Size = UDim2.new(progress / 100, 0, 1, 0)
        ProgressText.Text = math.floor(progress) .. "%"
        StatusLabel.Text = "◉ " .. (status or "Loading...")
        DetailsLabel.Text = details or "Loading modules..."
        
        if progress == 100 then
            StatusLabel.Text = "◉ Ready!"
            StatusLabel.TextColor3 = LoaderConfig.Colors.Yellow
            LoadButton.Text = "INJECT"
            LoadButton.BackgroundColor3 = LoaderConfig.Colors.Red
            LoadButton.BackgroundTransparency = 0.1
            isLoaded = true
        end
    end

    -- Load Button Click
    LoadButton.MouseButton1Click:Connect(function()
        if isLoaded then
            LoadButton.Text = "LOADING..."
            LoadButton.BackgroundColor3 = LoaderConfig.Colors.Yellow
            LoadButton.BackgroundTransparency = 0.3
            LoadButton.TextColor3 = LoaderConfig.Colors.Black
            
            -- Execute the main script
            self:ExecuteMainScript(UpdateProgress)
        end
    end)

    -- Hover Effects
    LoadButton.MouseEnter:Connect(function()
        if isLoaded then
            LoadButton.BackgroundTransparency = 0
            LoadButton.TextColor3 = LoaderConfig.Colors.Yellow
        end
    end)

    LoadButton.MouseLeave:Connect(function()
        if isLoaded then
            LoadButton.BackgroundTransparency = 0.2
            LoadButton.TextColor3 = LoaderConfig.Colors.White
        end
    end)

    -- Keybind to close loader (Insert key)
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode[LoaderConfig.Key] then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    -- Save references
    self.UI = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        ProgressFill = ProgressFill,
        ProgressText = ProgressText,
        StatusLabel = StatusLabel,
        DetailsLabel = DetailsLabel,
        LoadButton = LoadButton,
        UpdateProgress = UpdateProgress,
    }

    -- Initial animation
    task.spawn(function()
        for i = 0, 100, 2 do
            UpdateProgress(i, "Initializing...", "Loading system components...")
            task.wait(0.02)
        end
        UpdateProgress(100, "Ready!", "System loaded successfully")
    end)

    return self.UI
end

-- ================================================
--  EXECUTE MAIN SCRIPT
-- ================================================
function Loader:ExecuteMainScript(updateProgress)
    local function UpdateStatus(progress, status, details)
        if updateProgress then
            updateProgress(progress, status, details)
        end
    end

    UpdateStatus(10, "Connecting...", "Establishing connection to servers...")
    task.wait(0.5)

    UpdateStatus(25, "Downloading...", "Fetching main framework...")
    task.wait(0.5)

    -- Load the main menu
    local success, result = pcall(function()
        UpdateStatus(50, "Loading...", "Initializing UI library...")
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
    end)

    if success and result then
        UpdateStatus(75, "Loading...", "Loading Raven Software modules...")
        task.wait(0.3)
        
        -- Execute the main menu code
        UpdateStatus(90, "Finalizing...", "Starting Raven Software...")
        task.wait(0.3)
        
        -- Load and execute the main menu
        local mainSuccess, mainResult = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/Raven-Software/main/menu.lua"))()
        end)

        if mainSuccess then
            UpdateStatus(100, "Loaded!", "Raven Software ready!")
            task.wait(0.5)
            
            -- Close loader after successful injection
            if self.UI and self.UI.ScreenGui then
                self.UI.ScreenGui:Destroy()
            end
            
            StarterGui:SetCore("SendNotification", {
                Title = "Raven Software",
                Text = "Framework loaded successfully! Press Insert to toggle menu.",
                Duration = 3,
            })
        else
            UpdateStatus(100, "Error!", "Failed to load main menu")
            self.UI.LoadButton.Text = "RETRY"
            self.UI.LoadButton.BackgroundColor3 = LoaderConfig.Colors.Red
            self.UI.LoadButton.BackgroundTransparency = 0.1
        end
    else
        UpdateStatus(100, "Error!", "Failed to load UI library")
        self.UI.LoadButton.Text = "RETRY"
        self.UI.LoadButton.BackgroundColor3 = LoaderConfig.Colors.Red
    end
end

-- ================================================
--  INITIALIZE LOADER
-- ================================================
local loaderUI = Loader:CreateUI()

-- ================================================
--  KEYBIND TOGGLE (Insert)
-- ================================================
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode[LoaderConfig.Key] then
        if loaderUI and loaderUI.ScreenGui then
            loaderUI.ScreenGui.Enabled = not loaderUI.ScreenGui.Enabled
        end
    end
end)

print("[Raven Software] Loader initialized. Press Insert to show/hide.")
