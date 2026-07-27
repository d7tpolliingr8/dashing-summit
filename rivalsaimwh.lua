-- // Raven Software | Premium Utility Suite
-- // Black | Red | Yellow Edition
-- // Featuring: Advanced Aimbot V4, Skin Changer, Unlock All

-- ================================================
--  COMPATIBILITY LAYER
-- ================================================
if not checkcaller then checkcaller = function() return true end end
if not getnamecallmethod then getnamecallmethod = function() return "" end end
if not hookmetamethod then hookmetamethod = nil end

-- ================================================
--  SERVICES
-- ================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Camera = Workspace.CurrentCamera
local LP = Players.LocalPlayer

-- ================================================
--  LOAD LINORIA
-- ================================================
local Library, SaveManager, ThemeManager
local LibraryLoaded = false

local function LoadLibrary()
    local urls = {
        "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua",
        "https://raw.githubusercontent.com/caIIed/Linoria-Rewrite/main/Library.lua",
    }
    
    for _, url in ipairs(urls) do
        local success, result = pcall(function()
            return loadstring(game:HttpGet(url))()
        end)
        if success and result then
            Library = result
            LibraryLoaded = true
            return true
        end
    end
    return false
end

if not LoadLibrary() then
    warn("[Raven Software] Failed to load UI library")
    StarterGui:SetCore("SendNotification", {
        Title = "Raven Software",
        Text = "Failed to load UI library. Please try again.",
        Duration = 5,
    })
    return
end

pcall(function()
    SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua"))()
end)
pcall(function()
    ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()
end)

-- ================================================
--  RAVEN THEME (Black, Red, Yellow)
-- ================================================
local RavenTheme = {
    Background = Color3.fromRGB(10, 10, 10),
    Surface = Color3.fromRGB(20, 20, 20),
    Surface2 = Color3.fromRGB(30, 30, 30),
    Primary = Color3.fromRGB(255, 0, 0),
    Secondary = Color3.fromRGB(255, 215, 0),
    Accent = Color3.fromRGB(200, 0, 0),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Success = Color3.fromRGB(0, 255, 0),
    Danger = Color3.fromRGB(255, 0, 0),
    Warning = Color3.fromRGB(255, 215, 0),
    Border = Color3.fromRGB(40, 40, 40),
}

local function ApplyRavenTheme()
    if not Library then return end
    pcall(function()
        Library.AccentColor = RavenTheme.Primary
        Library.AccentColorDark = RavenTheme.Accent
        Library.FontColor = RavenTheme.Text
        Library.MainColor = RavenTheme.Background
        Library.BackgroundColor = RavenTheme.Surface
        Library.OutlineColor = RavenTheme.Border
        Library:UpdateColorsUsingRegistry()
        
        if ThemeManager then
            ThemeManager:ApplyTheme("Raven")
        end
    end)
end

-- ================================================
--  CONFIGURATION
-- ================================================
local Cfg = {
    ESP = {
        Enabled = false,
        MaxDistance = 1000,
        Skeleton = true,
        SkeletonColor = RavenTheme.Secondary,
        Names = true,
        NameColor = RavenTheme.Text,
        Distance = true,
        DistanceColor = RavenTheme.TextSecondary,
        Health = true,
        Tracers = false,
        TracerColor = RavenTheme.Primary,
        Chams = true,
        ChamsColor = RavenTheme.Primary,
        ChamsTransparency = 0.3,
        ChamsOutline = RavenTheme.Background,
        ChamsOutlineTransparency = 0.5,
        Box = false,
        BoxColor = RavenTheme.Secondary,
        CornerBox = false,
        CornerColor = RavenTheme.Primary,
        OffscreenArrows = false,
        OffscreenArrowColor = RavenTheme.Primary,
        Glow = false,
        GlowColor = RavenTheme.Primary,
        GlowIntensity = 0.3,
        HeadDot = false,
        HeadDotColor = RavenTheme.Primary,
    },
    Aimbot = {
        Enabled = false,
        Part = "Head",
        FOV = 200,
        ShowFOV = true,
        FOVColor = RavenTheme.Primary,
        Smoothness = 0.3,
        YOffset = 0,
        Prediction = 0.5,
        WallCheck = false,
        AimKey = "MouseButton2",
        MaxDistance = 500,
        InsaneTracking = false,
        TrackingSpeed = 0.8,
        TrackingPrediction = 2.0,
        Snappiness = 0.9,
        AutoShoot = false,
    },
    SkinChanger = {
        Enabled = false,
        SelectedWeapon = "AssaultRifle",
        SkinType = "Sniper",
        WeaponModels = {
            AssaultRifle = {
                Name = "Assault Rifle",
                Damage = 25,
                Range = 300,
                FireRate = 0.1,
                BulletSpeed = 2000,
                Spread = 0.05,
                Zoom = 1,
            },
            Sniper = {
                Name = "Sniper",
                Damage = 150,
                Range = 1000,
                FireRate = 0.8,
                BulletSpeed = 5000,
                Spread = 0.001,
                Zoom = 4,
            },
            Shotgun = {
                Name = "Shotgun",
                Damage = 40,
                Range = 150,
                FireRate = 0.4,
                BulletSpeed = 1500,
                Spread = 0.2,
                Zoom = 1,
            },
            SMG = {
                Name = "SMG",
                Damage = 18,
                Range = 250,
                FireRate = 0.05,
                BulletSpeed = 1800,
                Spread = 0.08,
                Zoom = 1.5,
            },
            LMG = {
                Name = "LMG",
                Damage = 22,
                Range = 350,
                FireRate = 0.07,
                BulletSpeed = 1900,
                Spread = 0.06,
                Zoom = 1.5,
            },
            Pistol = {
                Name = "Pistol",
                Damage = 30,
                Range = 200,
                FireRate = 0.2,
                BulletSpeed = 1600,
                Spread = 0.04,
                Zoom = 1,
            },
            RPG = {
                Name = "RPG",
                Damage = 200,
                Range = 500,
                FireRate = 1.5,
                BulletSpeed = 1000,
                Spread = 0.1,
                Zoom = 2,
            },
            Minigun = {
                Name = "Minigun",
                Damage = 15,
                Range = 300,
                FireRate = 0.02,
                BulletSpeed = 2000,
                Spread = 0.1,
                Zoom = 1,
            },
            Laser = {
                Name = "Laser",
                Damage = 50,
                Range = 400,
                FireRate = 0.01,
                BulletSpeed = 8000,
                Spread = 0.001,
                Zoom = 2,
            },
        }
    },
    Visuals = {
        FullBright = false,
        NoFog = false,
        Crosshair = false,
        CrosshairColor = RavenTheme.Primary,
        CrosshairSize = 12,
        CrosshairGap = 4,
        CrosshairSpinSpeed = 2.0,
    },
    Movement = {
        Fly = false,
        FlySpeed = 50,
        Noclip = false,
        FlyKeybind = Enum.KeyCode.F,
        SpeedHack = false,
        SpeedValue = 24,
    },
    Unlock = {
        UnlockAll = false,
        ForceUnlock = false,
        UnlockMethods = {
            Bypass = false,
            FakePurchases = false,
            MemoryEdit = false,
            RemoteSpoof = false,
            ClientSpoof = false,
            InventoryFake = false,
            StatsModify = false,
            LeaderboardFake = false,
            ItemDuplication = false,
            CurrencySpoof = false,
            LevelFake = false,
            BadgeUnlock = false,
            TrophyUnlock = false,
            AchievementUnlock = false,
            CollectionComplete = false,
            SkinUnlock = false,
            CosmeticUnlock = false,
            ToolUnlock = false,
            WeaponUnlock = false,
            VehicleUnlock = false,
            PetUnlock = false,
            MountUnlock = false,
            TitleUnlock = false,
            RankFake = false,
            RoleFake = false,
            PermissionsFake = false,
            VipFake = false,
            PremiumFake = false,
            BattlePassFake = false,
            SeasonRewards = false,
            EventUnlock = false,
            DailyRewards = false,
            WeeklyRewards = false,
            MonthlyRewards = false,
            SpecialRewards = false,
            LootBoxUnlock = false,
            MysteryUnlock = false,
            RareItems = false,
            EpicItems = false,
            LegendaryItems = false,
            MythicItems = false,
            ExoticItems = false,
            UltimateItems = false,
            AllItems = false,
            UnlockAllGames = false,
            UnlockAllBadges = false,
            UnlockAllTrophies = false,
            UnlockAllAchievements = false,
            UnlockAllSkins = false,
            UnlockAllCosmetics = false,
            UnlockAllWeapons = false,
            UnlockAllVehicles = false,
            UnlockAllPets = false,
            UnlockAllMounts = false,
        }
    },
    Misc = {
        AntiAFK = false,
        Watermark = true,
    }
}

-- ================================================
--  DRAWING HELPERS
-- ================================================
local function L(props)
    local d = Drawing.new("Line")
    d.Visible = false
    d.Color = props.Color or RavenTheme.Text
    d.Thickness = props.Thickness or 1
    d.ZIndex = props.ZIndex or 5
    return d
end

local function T(props)
    local d = Drawing.new("Text")
    d.Visible = false
    d.Text = props.Text or ""
    d.Size = props.Size or 13
    d.Center = props.Center ~= nil and props.Center or true
    d.Outline = true
    d.OutlineColor = RavenTheme.Background
    d.Color = props.Color or RavenTheme.Text
    d.ZIndex = props.ZIndex or 6
    d.Position = Vector2.new(-9999, -9999)
    return d
end

local function C(props)
    local d = Drawing.new("Circle")
    d.Visible = false
    d.Filled = false
    d.Thickness = props.Thickness or 2
    d.Color = props.Color or RavenTheme.Primary
    d.ZIndex = props.ZIndex or 10
    d.NumSides = 64
    d.Position = Vector2.new(-9999, -9999)
    d.Radius = 1
    return d
end

-- ================================================
--  UTILITY FUNCTIONS
-- ================================================
local function W2S(pos)
    local vp, on = Camera:WorldToViewportPoint(pos)
    return Vector2.new(vp.X, vp.Y), on and vp.Z > 0
end

local function AimPoint()
    if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        local vp = Camera.ViewportSize
        return Vector2.new(vp.X * 0.5, vp.Y * 0.5)
    end
    return UserInputService:GetMouseLocation()
end

local function GetCharacterParts(char)
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    local hum = char:FindFirstChildOfClass("Humanoid")
    local head = char:FindFirstChild("Head")
    if hrp and hum and head then return hrp, hum, head end
end

local function IsCharacterAlive(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0 and char:FindFirstChild("HumanoidRootPart") ~= nil
end

local function GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- ================================================
--  SKIN CHANGER / WEAPON MODIFIER
-- ================================================
local weaponModifications = {}

-- Function to apply weapon changes
local function ApplyWeaponChanges(tool)
    if not tool or not tool:IsA("Tool") then return end
    
    -- Find the handle or main part
    local handle = tool:FindFirstChild("Handle") or tool:FindFirstChild("Grip") or tool:FindFirstChild("Part")
    if not handle then return end
    
    local skinType = Cfg.SkinChanger.SkinType
    local weaponData = Cfg.SkinChanger.WeaponModels[skinType]
    if not weaponData then return end
    
    -- Change weapon properties
    for _, part in ipairs(tool:GetDescendants()) do
        if part:IsA("Part") or part:IsA("MeshPart") then
            -- Change appearance based on skin type
            if skinType == "Sniper" then
                -- Make it look like a sniper
                part.Size = Vector3.new(1.5, 0.3, 0.3)
                part.Material = Enum.Material.Metal
                part.BrickColor = BrickColor.new("Dark gray")
                
                -- Add scope (cylindrical part)
                local scope = Instance.new("Part")
                scope.Name = "Scope"
                scope.Size = Vector3.new(0.2, 0.2, 0.3)
                scope.Parent = handle
                scope.CFrame = handle.CFrame * CFrame.new(0, 0.3, -0.4)
                scope.Anchored = true
                scope.CanCollide = false
                scope.BrickColor = BrickColor.new("Black")
                scope.Material = Enum.Material.Glass
                
                -- Add barrel
                local barrel = Instance.new("Part")
                barrel.Name = "Barrel"
                barrel.Size = Vector3.new(0.1, 0.1, 0.8)
                barrel.Parent = handle
                barrel.CFrame = handle.CFrame * CFrame.new(0, 0, -0.7)
                barrel.Anchored = true
                barrel.CanCollide = false
                barrel.BrickColor = BrickColor.new("Dark stone gray")
                barrel.Material = Enum.Material.Metal
                
                -- Weld everything
                local weld = Instance.new("Weld")
                weld.Part0 = handle
                weld.Part1 = scope
                weld.C0 = CFrame.new(0, 0.3, -0.4)
                weld.Parent = handle
                
                local weld2 = Instance.new("Weld")
                weld2.Part0 = handle
                weld2.Part1 = barrel
                weld2.C0 = CFrame.new(0, 0, -0.7)
                weld2.Parent = handle
                
            elseif skinType == "Shotgun" then
                part.Size = Vector3.new(1.2, 0.4, 0.4)
                part.Material = Enum.Material.Wood
                part.BrickColor = BrickColor.new("Brown")
                
            elseif skinType == "SMG" then
                part.Size = Vector3.new(1, 0.3, 0.25)
                part.Material = Enum.Material.Metal
                part.BrickColor = BrickColor.new("Dark stone gray")
                
            elseif skinType == "LMG" then
                part.Size = Vector3.new(2, 0.5, 0.3)
                part.Material = Enum.Material.Metal
                part.BrickColor = BrickColor.new("Dark green")
                
            elseif skinType == "Pistol" then
                part.Size = Vector3.new(0.6, 0.2, 0.2)
                part.Material = Enum.Material.Metal
                part.BrickColor = BrickColor.new("Dark gray")
                
            elseif skinType == "RPG" then
                part.Size = Vector3.new(1.8, 0.6, 0.6)
                part.Material = Enum.Material.Metal
                part.BrickColor = BrickColor.new("Olive green")
                
            elseif skinType == "Minigun" then
                part.Size = Vector3.new(2.5, 0.8, 0.8)
                part.Material = Enum.Material.Metal
                part.BrickColor = BrickColor.new("Dark stone gray")
                
            elseif skinType == "Laser" then
                part.Size = Vector3.new(0.8, 0.2, 0.2)
                part.Material = Enum.Material.Neon
                part.BrickColor = BrickColor.new("Bright red")
                part.Transparency = 0.3
            end
        end
    end
    
    -- Modify tool properties
    if tool:FindFirstChild("ToolTip") then
        tool.ToolTip = weaponData.Name
    end
    
    -- Try to modify damage if it exists
    for _, v in pairs(tool:GetDescendants()) do
        if v:IsA("NumberValue") and v.Name:lower():find("damage") then
            v.Value = weaponData.Damage
        elseif v:IsA("NumberValue") and v.Name:lower():find("range") then
            v.Value = weaponData.Range
        elseif v:IsA("NumberValue") and v.Name:lower():find("firerate") or v.Name:lower():find("rate") then
            v.Value = weaponData.FireRate
        elseif v:IsA("NumberValue") and v.Name:lower():find("spread") then
            v.Value = weaponData.Spread
        elseif v:IsA("NumberValue") and v.Name:lower():find("zoom") then
            v.Value = weaponData.Zoom
        end
    end
end

-- Function to change weapon skin
local function ChangeWeaponSkin()
    if not Cfg.SkinChanger.Enabled then return end
    
    local player = LP
    local character = player.Character
    if not character then return end
    
    -- Check all tools in character and backpack
    local tools = {}
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("Tool") then
            table.insert(tools, child)
        end
    end
    
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, child in pairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                table.insert(tools, child)
            end
        end
    end
    
    -- Apply changes to each tool
    for _, tool in pairs(tools) do
        ApplyWeaponChanges(tool)
    end
end

-- Function to get current weapon name
local function GetCurrentWeapon()
    local player = LP
    local character = player.Character
    if not character then return "None" end
    
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("Tool") then
            return child.Name
        end
    end
    
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, child in pairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                return child.Name
            end
        end
    end
    
    return "None"
end

-- Function to scan for weapons to skin change
local function ScanForWeapons()
    local foundWeapons = {}
    local player = LP
    
    -- Check character
    if player.Character then
        for _, child in pairs(player.Character:GetChildren()) do
            if child:IsA("Tool") then
                table.insert(foundWeapons, child.Name)
            end
        end
    end
    
    -- Check backpack
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, child in pairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                table.insert(foundWeapons, child.Name)
            end
        end
    end
    
    if #foundWeapons == 0 then
        table.insert(foundWeapons, "None")
    end
    
    return foundWeapons
end

-- Hook to apply skin changes when weapons are equipped
local function HookWeaponEquip()
    -- Override the tool equipped function
    local player = LP
    player.CharacterAdded:Connect(function(char)
        char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and Cfg.SkinChanger.Enabled then
                task.wait(0.1)
                ApplyWeaponChanges(child)
            end
        end)
    end)
end

-- Start weapon hooks
HookWeaponEquip()

-- ================================================
--  UNLOCK ALL SYSTEM
-- ================================================
local UnlockMethods = {}

UnlockMethods.Bypass = function()
    pcall(function()
        for _, v in pairs(getreg()) do
            if type(v) == "table" and rawget(v, "IsLoaded") then
                rawset(v, "IsLoaded", function() return true end)
            end
        end
    end)
end

UnlockMethods.FakePurchases = function()
    pcall(function()
        local MarketService = game:GetService("MarketplaceService")
        local old = MarketService.PromptPurchase
        MarketService.PromptPurchase = function(...) return true end
    end)
end

UnlockMethods.MemoryEdit = function()
    pcall(function()
        for _, v in pairs(getgc()) do
            if type(v) == "table" and rawget(v, "locked") ~= nil then
                rawset(v, "locked", false)
            end
        end
    end)
end

UnlockMethods.RemoteSpoof = function()
    pcall(function()
        local old = game.ReplicatedStorage.FindFirstChild
        game.ReplicatedStorage.FindFirstChild = function(...)
            local args = {...}
            if args[1] == "Unlock" then
                return Instance.new("RemoteEvent")
            end
            return old(...)
        end
    end)
end

UnlockMethods.ClientSpoof = function()
    pcall(function()
        local player = LP
        local fakeData = {
            hasPremium = true,
            hasVip = true,
            level = 999,
            rank = "Ultimate",
            coins = 999999,
            gems = 999999,
        }
        for k, v in pairs(fakeData) do
            pcall(function() player[k] = v end)
        end
    end)
end

UnlockMethods.InventoryFake = function()
    pcall(function()
        if LP:FindFirstChild("Inventory") then LP.Inventory:Destroy() end
        local inv = Instance.new("Folder")
        inv.Name = "Inventory"
        inv.Parent = LP
    end)
end

UnlockMethods.StatsModify = function()
    pcall(function()
        if LP:FindFirstChild("Stats") then
            for _, v in pairs(LP.Stats:GetDescendants()) do
                if v:IsA("NumberValue") then
                    v.Value = v.Value * 1000
                end
            end
        end
    end)
end

UnlockMethods.LeaderboardFake = function()
    pcall(function()
        if LP:FindFirstChild("leaderstats") then
            for _, v in pairs(LP.leaderstats:GetDescendants()) do
                if v:IsA("NumberValue") then
                    v.Value = 999999
                end
            end
        end
    end)
end

UnlockMethods.ItemDuplication = function()
    pcall(function()
        local backpack = LP:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local clone = tool:Clone()
                    clone.Parent = backpack
                end
            end
        end
    end)
end

UnlockMethods.CurrencySpoof = function()
    pcall(function()
        local currency = {"Coins", "Gems", "Gold", "Silver", "Bronze", "Diamonds", "Points", "Credits"}
        for _, name in ipairs(currency) do
            local val = Instance.new("IntValue")
            val.Name = name
            val.Value = 999999
            val.Parent = LP
        end
    end)
end

UnlockMethods.LevelFake = function()
    pcall(function()
        local level = Instance.new("IntValue")
        level.Name = "Level"
        level.Value = 999
        level.Parent = LP
    end)
end

UnlockMethods.BadgeUnlock = function()
    pcall(function()
        local badges = Workspace:FindFirstChild("Badges")
        if badges then
            for _, badge in pairs(badges:GetChildren()) do
                if badge:IsA("StringValue") then
                    local clone = badge:Clone()
                    clone.Parent = LP
                end
            end
        end
    end)
end

UnlockMethods.TrophyUnlock = function()
    pcall(function()
        local trophies = Workspace:FindFirstChild("Trophies")
        if trophies then
            for _, trophy in pairs(trophies:GetChildren()) do
                if trophy:IsA("Part") then
                    trophy.CanCollide = false
                    trophy.Transparency = 0
                end
            end
        end
    end)
end

UnlockMethods.AchievementUnlock = function()
    pcall(function()
        local remote = Instance.new("RemoteEvent")
        remote.Name = "AchievementEvent"
        remote.Parent = game.ReplicatedStorage
        remote:FireServer("UnlockAll")
    end)
end

UnlockMethods.CollectionComplete = function()
    pcall(function()
        local collection = LP:FindFirstChild("Collection")
        if collection then
            for _, item in pairs(collection:GetChildren()) do
                if item:IsA("BoolValue") then
                    item.Value = true
                end
            end
        end
    end)
end

UnlockMethods.SkinUnlock = function()
    pcall(function()
        local skins = LP:FindFirstChild("Skins")
        if skins then
            for _, skin in pairs(skins:GetChildren()) do
                if skin:IsA("StringValue") then
                    local clone = skin:Clone()
                    clone.Parent = LP
                end
            end
        end
    end)
end

UnlockMethods.CosmeticUnlock = function()
    pcall(function()
        local cosmetics = LP:FindFirstChild("Cosmetics")
        if cosmetics then
            for _, cosmetic in pairs(cosmetics:GetChildren()) do
                if cosmetic:IsA("StringValue") then
                    local clone = cosmetic:Clone()
                    clone.Parent = LP
                end
            end
        end
    end)
end

UnlockMethods.ToolUnlock = function()
    pcall(function()
        local tools = Workspace:FindFirstChild("Tools")
        if tools then
            for _, tool in pairs(tools:GetChildren()) do
                if tool:IsA("Tool") then
                    local clone = tool:Clone()
                    clone.Parent = LP.Backpack
                end
            end
        end
    end)
end

UnlockMethods.WeaponUnlock = function()
    pcall(function()
        local weapons = Workspace:FindFirstChild("Weapons")
        if weapons then
            for _, weapon in pairs(weapons:GetChildren()) do
                if weapon:IsA("Tool") then
                    local clone = weapon:Clone()
                    clone.Parent = LP.Backpack
                end
            end
        end
    end)
end

UnlockMethods.VehicleUnlock = function()
    pcall(function()
        local vehicles = Workspace:FindFirstChild("Vehicles")
        if vehicles then
            for _, vehicle in pairs(vehicles:GetChildren()) do
                if vehicle:IsA("Model") then
                    vehicle.Parent = Workspace
                end
            end
        end
    end)
end

UnlockMethods.PetUnlock = function()
    pcall(function()
        local pets = Workspace:FindFirstChild("Pets")
        if pets then
            for _, pet in pairs(pets:GetChildren()) do
                if pet:IsA("Model") then
                    local clone = pet:Clone()
                    clone.Parent = LP
                end
            end
        end
    end)
end

UnlockMethods.MountUnlock = function()
    pcall(function()
        local mounts = Workspace:FindFirstChild("Mounts")
        if mounts then
            for _, mount in pairs(mounts:GetChildren()) do
                if mount:IsA("Model") then
                    local clone = mount:Clone()
                    clone.Parent = LP
                end
            end
        end
    end)
end

UnlockMethods.TitleUnlock = function()
    pcall(function()
        local title = Instance.new("StringValue")
        title.Name = "Title"
        title.Value = "Raven Master"
        title.Parent = LP
    end)
end

UnlockMethods.RankFake = function()
    pcall(function()
        local rank = Instance.new("StringValue")
        rank.Name = "Rank"
        rank.Value = "Ultimate Raven"
        rank.Parent = LP
    end)
end

UnlockMethods.RoleFake = function()
    pcall(function()
        local role = Instance.new("StringValue")
        role.Name = "Role"
        role.Value = "Developer"
        role.Parent = LP
    end)
end

UnlockMethods.PermissionsFake = function()
    pcall(function()
        for _, name in ipairs({"Admin", "Moderator", "Owner", "VIP", "Premium", "Beta"}) do
            local perm = Instance.new("BoolValue")
            perm.Name = name
            perm.Value = true
            perm.Parent = LP
        end
    end)
end

UnlockMethods.VipFake = function()
    pcall(function()
        local vip = Instance.new("BoolValue")
        vip.Name = "VIP"
        vip.Value = true
        vip.Parent = LP
    end)
end

UnlockMethods.PremiumFake = function()
    pcall(function()
        local premium = Instance.new("BoolValue")
        premium.Name = "Premium"
        premium.Value = true
        premium.Parent = LP
    end)
end

UnlockMethods.BattlePassFake = function()
    pcall(function()
        local battlepass = Instance.new("BoolValue")
        battlepass.Name = "BattlePass"
        battlepass.Value = true
        battlepass.Parent = LP
    end)
end

UnlockMethods.SeasonRewards = function()
    pcall(function()
        local season = Instance.new("IntValue")
        season.Name = "SeasonReward"
        season.Value = 999999
        season.Parent = LP
    end)
end

UnlockMethods.EventUnlock = function()
    pcall(function()
        local events = Workspace:FindFirstChild("Events")
        if events then
            for _, event in pairs(events:GetChildren()) do
                if event:IsA("StringValue") then
                    local clone = event:Clone()
                    clone.Parent = LP
                end
            end
        end
    end)
end

UnlockMethods.DailyRewards = function()
    pcall(function()
        local daily = Instance.new("BoolValue")
        daily.Name = "DailyReward"
        daily.Value = true
        daily.Parent = LP
    end)
end

UnlockMethods.WeeklyRewards = function()
    pcall(function()
        local weekly = Instance.new("BoolValue")
        weekly.Name = "WeeklyReward"
        weekly.Value = true
        weekly.Parent = LP
    end)
end

UnlockMethods.MonthlyRewards = function()
    pcall(function()
        local monthly = Instance.new("BoolValue")
        monthly.Name = "MonthlyReward"
        monthly.Value = true
        monthly.Parent = LP
    end)
end

UnlockMethods.SpecialRewards = function()
    pcall(function()
        local special = Instance.new("BoolValue")
        special.Name = "SpecialReward"
        special.Value = true
        special.Parent = LP
    end)
end

UnlockMethods.LootBoxUnlock = function()
    pcall(function()
        local lootbox = Instance.new("StringValue")
        lootbox.Name = "LootBox"
        lootbox.Value = "Ultimate"
        lootbox.Parent = LP
    end)
end

UnlockMethods.MysteryUnlock = function()
    pcall(function()
        local mystery = Instance.new("BoolValue")
        mystery.Name = "MysteryUnlock"
        mystery.Value = true
        mystery.Parent = LP
    end)
end

UnlockMethods.RareItems = function()
    pcall(function()
        local rare = Instance.new("Folder")
        rare.Name = "RareItems"
        rare.Parent = LP
        for i = 1, 10 do
            local item = Instance.new("StringValue")
            item.Name = "RareItem_" .. i
            item.Value = "RareItem" .. i
            item.Parent = rare
        end
    end)
end

UnlockMethods.EpicItems = function()
    pcall(function()
        local epic = Instance.new("Folder")
        epic.Name = "EpicItems"
        epic.Parent = LP
        for i = 1, 10 do
            local item = Instance.new("StringValue")
            item.Name = "EpicItem_" .. i
            item.Value = "EpicItem" .. i
            item.Parent = epic
        end
    end)
end

UnlockMethods.LegendaryItems = function()
    pcall(function()
        local legendary = Instance.new("Folder")
        legendary.Name = "LegendaryItems"
        legendary.Parent = LP
        for i = 1, 10 do
            local item = Instance.new("StringValue")
            item.Name = "LegendaryItem_" .. i
            item.Value = "LegendaryItem" .. i
            item.Parent = legendary
        end
    end)
end

UnlockMethods.MythicItems = function()
    pcall(function()
        local mythic = Instance.new("Folder")
        mythic.Name = "MythicItems"
        mythic.Parent = LP
        for i = 1, 10 do
            local item = Instance.new("StringValue")
            item.Name = "MythicItem_" .. i
            item.Value = "MythicItem" .. i
            item.Parent = mythic
        end
    end)
end

UnlockMethods.ExoticItems = function()
    pcall(function()
        local exotic = Instance.new("Folder")
        exotic.Name = "ExoticItems"
        exotic.Parent = LP
        for i = 1, 10 do
            local item = Instance.new("StringValue")
            item.Name = "ExoticItem_" .. i
            item.Value = "ExoticItem" .. i
            item.Parent = exotic
        end
    end)
end

UnlockMethods.UltimateItems = function()
    pcall(function()
        local ultimate = Instance.new("Folder")
        ultimate.Name = "UltimateItems"
        ultimate.Parent = LP
        for i = 1, 10 do
            local item = Instance.new("StringValue")
            item.Name = "UltimateItem_" .. i
            item.Value = "UltimateItem" .. i
            item.Parent = ultimate
        end
    end)
end

UnlockMethods.AllItems = function()
    pcall(function()
        local items = Instance.new("Folder")
        items.Name = "AllItems"
        items.Parent = LP
        for i = 1, 100 do
            local item = Instance.new("StringValue")
            item.Name = "Item_" .. i
            item.Value = "Item" .. i
            item.Parent = items
        end
    end)
end

UnlockMethods.UnlockAllGames = function()
    pcall(function()
        local games = Workspace:FindFirstChild("Games")
        if games then
            for _, game in pairs(games:GetChildren()) do
                if game:IsA("Model") then
                    game.Parent = Workspace
                end
            end
        end
    end)
end

UnlockMethods.UnlockAllBadges = function()
    pcall(function()
        for i = 1, 100 do
            local badge = Instance.new("StringValue")
            badge.Name = "Badge_" .. i
            badge.Value = "Badge" .. i
            badge.Parent = LP
        end
    end)
end

UnlockMethods.UnlockAllTrophies = function()
    pcall(function()
        for i = 1, 50 do
            local trophy = Instance.new("StringValue")
            trophy.Name = "Trophy_" .. i
            trophy.Value = "Trophy" .. i
            trophy.Parent = LP
        end
    end)
end

UnlockMethods.UnlockAllAchievements = function()
    pcall(function()
        for i = 1, 100 do
            local achievement = Instance.new("StringValue")
            achievement.Name = "Achievement_" .. i
            achievement.Value = "Achievement" .. i
            achievement.Parent = LP
        end
    end)
end

UnlockMethods.UnlockAllSkins = function()
    pcall(function()
        for i = 1, 50 do
            local skin = Instance.new("StringValue")
            skin.Name = "Skin_" .. i
            skin.Value = "Skin" .. i
            skin.Parent = LP
        end
    end)
end

UnlockMethods.UnlockAllCosmetics = function()
    pcall(function()
        for i = 1, 50 do
            local cosmetic = Instance.new("StringValue")
            cosmetic.Name = "Cosmetic_" .. i
            cosmetic.Value = "Cosmetic" .. i
            cosmetic.Parent = LP
        end
    end)
end

UnlockMethods.UnlockAllWeapons = function()
    pcall(function()
        for i = 1, 30 do
            local weapon = Instance.new("StringValue")
            weapon.Name = "Weapon_" .. i
            weapon.Value = "Weapon" .. i
            weapon.Parent = LP
        end
    end)
end

UnlockMethods.UnlockAllVehicles = function()
    pcall(function()
        for i = 1, 20 do
            local vehicle = Instance.new("StringValue")
            vehicle.Name = "Vehicle_" .. i
            vehicle.Value = "Vehicle" .. i
            vehicle.Parent = LP
        end
    end)
end

UnlockMethods.UnlockAllPets = function()
    pcall(function()
        for i = 1, 30 do
            local pet = Instance.new("StringValue")
            pet.Name = "Pet_" .. i
            pet.Value = "Pet" .. i
            pet.Parent = LP
        end
    end)
end

UnlockMethods.UnlockAllMounts = function()
    pcall(function()
        for i = 1, 20 do
            local mount = Instance.new("StringValue")
            mount.Name = "Mount_" .. i
            mount.Value = "Mount" .. i
            mount.Parent = LP
        end
    end)
end

local function RunUnlockAll()
    if not Cfg.Unlock.UnlockAll then return end
    
    for method, enabled in pairs(Cfg.Unlock.UnlockMethods) do
        if enabled and UnlockMethods[method] then
            pcall(UnlockMethods[method])
        end
    end
    
    if Cfg.Unlock.ForceUnlock then
        for _, method in pairs(UnlockMethods) do
            pcall(method)
        end
    end
    
    StarterGui:SetCore("SendNotification", {
        Title = "Raven Software",
        Text = "Unlock All initiated!",
        Duration = 2,
    })
end

-- ================================================
--  AIMBOT WITH INSANE TRACKING
-- ================================================
local FOVCircle = C{ Color = RavenTheme.Primary, ZIndex = 10 }
local CurrentTarget = nil

local function GetAimPart(char)
    local part = Cfg.Aimbot.Part
    if part == "Head" then return char:FindFirstChild("Head") end
    if part == "HumanoidRootPart" then return char:FindFirstChild("HumanoidRootPart") end
    if part == "UpperTorso" then return char:FindFirstChild("UpperTorso") end
    return char:FindFirstChild("Torso") or char:FindFirstChild("Head")
end

local function IsVisible(targetPos)
    if not Cfg.Aimbot.WallCheck then return true end
    
    local origin = Camera.CFrame.Position
    local direction = (targetPos - origin).Unit
    local distance = (targetPos - origin).Magnitude
    
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LP.Character}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    
    local result = workspace:Raycast(origin, direction * distance, params)
    return not result
end

local function IsValidTarget(player)
    if not player or player == LP then return false end
    if not player.Character then return false end
    
    local char = player.Character
    if not IsCharacterAlive(char) then return false end
    
    local part = GetAimPart(char)
    if not part then return false end
    
    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if myRoot then
        local dist = GetDistance(part.Position, myRoot.Position)
        if dist > Cfg.Aimbot.MaxDistance then return false end
    end
    
    return true, char, part
end

local function GetClosestTarget()
    local center = AimPoint()
    local best, bestDist = nil, Cfg.Aimbot.FOV
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end
        
        local valid, char, part = IsValidTarget(player)
        if not valid then continue end
        
        local pos = part.Position + Vector3.new(0, Cfg.Aimbot.YOffset, 0)
        
        if not IsVisible(pos) then continue end
        
        local screen, onScreen = W2S(pos)
        if not onScreen then continue end
        
        local dist = GetDistance(screen, center)
        if dist < bestDist then
            bestDist = dist
            best = { Player = player, Char = char, Part = part, Position = pos }
        end
    end
    
    return best
end

local function IsAimKeyPressed()
    local key = Cfg.Aimbot.AimKey
    if typeof(key) == "EnumItem" then
        if key.EnumType == Enum.UserInputType then
            return UserInputService:IsMouseButtonPressed(key)
        elseif key.EnumType == Enum.KeyCode then
            return UserInputService:IsKeyDown(key)
        end
    elseif typeof(key) == "string" then
        if key == "MouseButton2" then
            return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        elseif key == "MouseButton1" then
            return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        else
            local success, keyCode = pcall(function() return Enum.KeyCode[key] end)
            if success and keyCode then
                return UserInputService:IsKeyDown(keyCode)
            end
        end
    end
    return false
end

local function DoAimbot()
    if not Cfg.Aimbot.Enabled then
        CurrentTarget = nil
        return
    end

    local holding = IsAimKeyPressed()
    if not holding then
        CurrentTarget = nil
        return
    end

    local target = GetClosestTarget()
    if not target then
        CurrentTarget = nil
        return
    end

    CurrentTarget = target
    local aimPos = target.Position
    
    -- Prediction
    if Cfg.Aimbot.Prediction > 0 then
        local hrp = target.Char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local vel = hrp.AssemblyLinearVelocity
            local dist = GetDistance(Camera.CFrame.Position, hrp.Position)
            local time = math.min(dist / 500, 1) * Cfg.Aimbot.Prediction
            aimPos = aimPos + vel * time
        end
    end
    
    -- INSANE TRACKING
    if Cfg.Aimbot.InsaneTracking then
        local hrp = target.Char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local vel = hrp.AssemblyLinearVelocity
            local dist = GetDistance(Camera.CFrame.Position, hrp.Position)
            local predictionTime = math.min(dist / 300, 2) * Cfg.Aimbot.TrackingPrediction
            aimPos = aimPos + vel * predictionTime * 0.6
            
            local accel = hrp.AssemblyLinearAcceleration or Vector3.new()
            if accel.Magnitude > 0 then
                aimPos = aimPos + accel * predictionTime * 0.2
            end
            
            local currentCF = Camera.CFrame
            local targetCF = CFrame.lookAt(currentCF.Position, aimPos)
            local smoothFactor = Cfg.Aimbot.Snappiness
            Camera.CFrame = currentCF:Lerp(targetCF, smoothFactor)
            
            if Cfg.Aimbot.AutoShoot then
                VirtualInputManager:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, false)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, true)
            end
            
            return
        end
    end
    
    -- Normal aim
    local currentCF = Camera.CFrame
    local targetCF = CFrame.lookAt(currentCF.Position, aimPos)
    
    if Cfg.Aimbot.Smoothness <= 0 then
        Camera.CFrame = targetCF
    else
        local smooth = Clamp(1 - Cfg.Aimbot.Smoothness, 0.01, 1)
        Camera.CFrame = currentCF:Lerp(targetCF, smooth)
    end
    
    if Cfg.Aimbot.AutoShoot then
        VirtualInputManager:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, false)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, true)
    end
end

-- ================================================
--  FOV UPDATE
-- ================================================
local function UpdateFOV()
    if not Cfg.Aimbot.ShowFOV or not Cfg.Aimbot.Enabled then
        FOVCircle.Visible = false
        return
    end
    
    FOVCircle.Visible = true
    FOVCircle.Position = AimPoint()
    FOVCircle.Radius = Cfg.Aimbot.FOV
    FOVCircle.Color = Cfg.Aimbot.FOVColor
end

-- ================================================
--  ESP SYSTEM
-- ================================================
local ESPObjects = {}

local function CreateESP(player)
    if ESPObjects[player] then return end
    
    local o = {
        Skeleton = {},
        SkeletonOutline = {},
        Health = {},
        Name = T{ Color = RavenTheme.Text, Size = 13, ZIndex = 6 },
        Distance = T{ Color = RavenTheme.TextSecondary, Size = 11, ZIndex = 6 },
        Tracer = L{ Color = RavenTheme.Primary, ZIndex = 3 },
        TracerOutline = L{ Color = RavenTheme.Background, Thickness = 2.5, ZIndex = 2 },
        Box = {},
        BoxOutline = {},
        Corner = {},
        Chams = nil,
        Glow = nil,
        HeadDot = C{ Color = RavenTheme.Primary, Radius = 3, Thickness = 3, ZIndex = 7 },
    }
    
    for i = 1, 14 do
        o.SkeletonOutline[i] = L{ Color = RavenTheme.Background, Thickness = 3, ZIndex = 3 }
        o.Skeleton[i] = L{ Color = RavenTheme.Secondary, Thickness = 1.5, ZIndex = 4 }
    end
    
    o.Health[1] = L{ Color = RavenTheme.Background, Thickness = 2, ZIndex = 5 }
    o.Health[2] = L{ Color = RavenTheme.Success, Thickness = 2, ZIndex = 6 }
    
    for i = 1, 4 do
        o.Box[i] = L{ Color = RavenTheme.Secondary, Thickness = 1.5, ZIndex = 5 }
        o.BoxOutline[i] = L{ Color = RavenTheme.Background, Thickness = 3, ZIndex = 4 }
    end
    
    for i = 1, 8 do
        o.Corner[i] = L{ Color = RavenTheme.Primary, Thickness = 2, ZIndex = 5 }
    end
    
    ESPObjects[player] = o
end

local function DestroyESP(player)
    local o = ESPObjects[player]
    if not o then return end
    
    for _, list in ipairs({o.Skeleton, o.SkeletonOutline, o.Health, o.Box, o.BoxOutline, o.Corner}) do
        for _, obj in ipairs(list or {}) do
            pcall(function() obj:Remove() end)
        end
    end
    
    pcall(function() o.Name:Remove() end)
    pcall(function() o.Distance:Remove() end)
    pcall(function() o.Tracer:Remove() end)
    pcall(function() o.TracerOutline:Remove() end)
    pcall(function() o.HeadDot:Remove() end)
    
    if o.Chams then pcall(function() o.Chams:Destroy() end) end
    if o.Glow then pcall(function() o.Glow:Destroy() end) end
    
    ESPObjects[player] = nil
end

local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end
        
        CreateESP(player)
        local o = ESPObjects[player]
        local char = player.Character
        
        if not char or not IsCharacterAlive(char) then
            if o then
                o.Name.Visible = false
                o.Distance.Visible = false
                o.Tracer.Visible = false
                o.TracerOutline.Visible = false
                o.HeadDot.Visible = false
                for _, list in ipairs({o.Skeleton, o.SkeletonOutline, o.Health, o.Box, o.BoxOutline, o.Corner}) do
                    for _, obj in ipairs(list) do obj.Visible = false end
                end
                if o.Chams then o.Chams.Enabled = false end
                if o.Glow then o.Glow.Enabled = false end
            end
            continue
        end
        
        local hrp, hum, head = GetCharacterParts(char)
        if not hrp or not hum then continue end
        
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local dist = myRoot and GetDistance(hrp.Position, myRoot.Position) or 0
        
        if dist > Cfg.ESP.MaxDistance then
            o.Name.Visible = false
            o.Distance.Visible = false
            o.Tracer.Visible = false
            o.TracerOutline.Visible = false
            o.HeadDot.Visible = false
            for _, list in ipairs({o.Skeleton, o.SkeletonOutline, o.Health, o.Box, o.BoxOutline, o.Corner}) do
                for _, obj in ipairs(list) do obj.Visible = false end
            end
            if o.Chams then o.Chams.Enabled = false end
            if o.Glow then o.Glow.Enabled = false end
            continue
        end
        
        if not Cfg.ESP.Enabled then
            if o.Name then o.Name.Visible = false end
            if o.Distance then o.Distance.Visible = false end
            if o.Tracer then o.Tracer.Visible = false end
            if o.TracerOutline then o.TracerOutline.Visible = false end
            if o.HeadDot then o.HeadDot.Visible = false end
            for _, list in ipairs({o.Skeleton, o.SkeletonOutline, o.Health, o.Box, o.BoxOutline, o.Corner}) do
                for _, obj in ipairs(list) do obj.Visible = false end
            end
            if o.Chams then o.Chams.Enabled = false end
            if o.Glow then o.Glow.Enabled = false end
            continue
        end
        
        -- Calculate bounding box
        local top = head.Position + Vector3.new(0, 0.7, 0)
        local bot = hrp.Position - Vector3.new(0, 3.2, 0)
        local ts, ton = W2S(top)
        local bs, bon = W2S(bot)
        
        if not ton and not bon then
            for _, list in ipairs({o.Skeleton, o.SkeletonOutline, o.Health, o.Box, o.BoxOutline, o.Corner}) do
                for _, obj in ipairs(list) do obj.Visible = false end
            end
            if o.Name then o.Name.Visible = false end
            if o.Distance then o.Distance.Visible = false end
            if o.Tracer then o.Tracer.Visible = false end
            if o.TracerOutline then o.TracerOutline.Visible = false end
            if o.HeadDot then o.HeadDot.Visible = false end
            continue
        end
        
        local ls = W2S(hrp.Position - hrp.CFrame.RightVector * 1.5)
        local rs = W2S(hrp.Position + hrp.CFrame.RightVector * 1.5)
        
        local x = math.min(ts.X, bs.X, ls.X, rs.X)
        local x2 = math.max(ts.X, bs.X, ls.X, rs.X)
        local y = ts.Y
        local h = bs.Y - ts.Y
        local cx = (x + x2) / 2
        
        if h < 5 then
            for _, list in ipairs({o.Skeleton, o.SkeletonOutline, o.Health, o.Box, o.BoxOutline, o.Corner}) do
                for _, obj in ipairs(list) do obj.Visible = false end
            end
            if o.Name then o.Name.Visible = false end
            if o.Distance then o.Distance.Visible = false end
            if o.Tracer then o.Tracer.Visible = false end
            if o.TracerOutline then o.TracerOutline.Visible = false end
            if o.HeadDot then o.HeadDot.Visible = false end
            continue
        end
        
        -- Update skeleton
        local isR6 = char:FindFirstChild("Torso") ~= nil and not char:FindFirstChild("HumanoidRootPart")
        local skel = isR6 and {
            {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
            {"Torso", "Left Leg"}, {"Torso", "Right Leg"},
        } or {
            {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
            {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
            {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
            {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
            {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
        }
        
        for i, bones in ipairs(skel) do
            local p1 = char:FindFirstChild(bones[1])
            local p2 = char:FindFirstChild(bones[2])
            if Cfg.ESP.Skeleton and p1 and p2 then
                local s1, on1 = W2S(p1.Position)
                local s2, on2 = W2S(p2.Position)
                if on1 or on2 then
                    o.Skeleton[i].From = s1
                    o.Skeleton[i].To = s2
                    o.Skeleton[i].Color = Cfg.ESP.SkeletonColor
                    o.Skeleton[i].Visible = true
                    o.SkeletonOutline[i].From = s1
                    o.SkeletonOutline[i].To = s2
                    o.SkeletonOutline[i].Visible = true
                else
                    o.Skeleton[i].Visible = false
                    o.SkeletonOutline[i].Visible = false
                end
            else
                o.Skeleton[i].Visible = false
                o.SkeletonOutline[i].Visible = false
            end
        end
        
        -- Update name
        if Cfg.ESP.Names then
            o.Name.Position = Vector2.new(cx, y - 16)
            o.Name.Text = player.DisplayName or player.Name
            o.Name.Color = Cfg.ESP.NameColor
            o.Name.Visible = true
        else
            o.Name.Visible = false
        end
        
        -- Update distance
        if Cfg.ESP.Distance then
            o.Distance.Position = Vector2.new(cx, y + h + 3)
            o.Distance.Text = string.format("[%dm]", math.floor(dist))
            o.Distance.Color = Cfg.ESP.DistanceColor
            o.Distance.Visible = true
        else
            o.Distance.Visible = false
        end
        
        -- Update health
        if Cfg.ESP.Health then
            local ratio = Clamp(hum.Health / hum.MaxHealth, 0, 1)
            local bx = x - 5
            local bh = math.max(h, 1)
            local fh = math.max(bh * ratio, 0)
            
            o.Health[1].From = Vector2.new(bx, y)
            o.Health[1].To = Vector2.new(bx, y + bh)
            o.Health[1].Visible = true
            
            o.Health[2].From = Vector2.new(bx, y + bh - fh)
            o.Health[2].To = Vector2.new(bx, y + bh)
            o.Health[2].Color = ratio > 0.5 and RavenTheme.Success or RavenTheme.Danger
            o.Health[2].Visible = fh > 0
        else
            o.Health[1].Visible = false
            o.Health[2].Visible = false
        end
        
        -- Update box
        if Cfg.ESP.Box then
            local corners = {
                {Vector2.new(x, y), Vector2.new(x + w, y)},
                {Vector2.new(x, y + h), Vector2.new(x + w, y + h)},
                {Vector2.new(x, y), Vector2.new(x, y + h)},
                {Vector2.new(x + w, y), Vector2.new(x + w, y + h)},
            }
            
            for i, corner in ipairs(corners) do
                o.Box[i].From = corner[1]
                o.Box[i].To = corner[2]
                o.Box[i].Color = Cfg.ESP.BoxColor
                o.Box[i].Visible = true
                
                o.BoxOutline[i].From = corner[1]
                o.BoxOutline[i].To = corner[2]
                o.BoxOutline[i].Visible = true
            end
        else
            for i = 1, 4 do
                o.Box[i].Visible = false
                o.BoxOutline[i].Visible = false
            end
        end
        
        -- Update corner box
        if Cfg.ESP.CornerBox then
            local len = math.min(w, h) * 0.25
            local corners = {
                {Vector2.new(x, y + len), Vector2.new(x, y)},
                {Vector2.new(x, y), Vector2.new(x + len, y)},
                {Vector2.new(x + w - len, y), Vector2.new(x + w, y)},
                {Vector2.new(x + w, y), Vector2.new(x + w, y + len)},
                {Vector2.new(x, y + h - len), Vector2.new(x, y + h)},
                {Vector2.new(x, y + h), Vector2.new(x + len, y + h)},
                {Vector2.new(x + w - len, y + h), Vector2.new(x + w, y + h)},
                {Vector2.new(x + w, y + h - len), Vector2.new(x + w, y + h)},
            }
            
            for i, corner in ipairs(corners) do
                o.Corner[i].From = corner[1]
                o.Corner[i].To = corner[2]
                o.Corner[i].Color = Cfg.ESP.CornerColor
                o.Corner[i].Visible = true
            end
        else
            for i = 1, 8 do
                o.Corner[i].Visible = false
            end
        end
        
        -- Update tracers
        if Cfg.ESP.Tracers then
            local vp = Camera.ViewportSize
            local from = Vector2.new(vp.X / 2, vp.Y)
            
            o.Tracer.From = from
            o.Tracer.To = bs
            o.Tracer.Color = Cfg.ESP.TracerColor
            o.Tracer.Visible = true
            
            o.TracerOutline.From = from
            o.TracerOutline.To = bs
            o.TracerOutline.Visible = true
        else
            o.Tracer.Visible = false
            o.TracerOutline.Visible = false
        end
        
        -- Update chams
        if Cfg.ESP.Chams then
            if not o.Chams or o.Chams.Parent ~= char then
                if o.Chams then o.Chams:Destroy() end
                local h = Instance.new("Highlight")
                h.Adornee = char
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Parent = char
                o.Chams = h
            end
            o.Chams.Enabled = true
            o.Chams.FillColor = Cfg.ESP.ChamsColor
            o.Chams.FillTransparency = Cfg.ESP.ChamsTransparency
            o.Chams.OutlineColor = Cfg.ESP.ChamsOutline
            o.Chams.OutlineTransparency = Cfg.ESP.ChamsOutlineTransparency
        elseif o.Chams then
            o.Chams.Enabled = false
        end
        
        -- Update glow
        if Cfg.ESP.Glow then
            if not o.Glow or o.Glow.Parent ~= char then
                if o.Glow then o.Glow:Destroy() end
                local g = Instance.new("Highlight")
                g.Adornee = char
                g.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                g.Parent = char
                o.Glow = g
            end
            o.Glow.Enabled = true
            o.Glow.FillColor = Cfg.ESP.GlowColor
            o.Glow.FillTransparency = 1 - Cfg.ESP.GlowIntensity
            o.Glow.OutlineColor = Cfg.ESP.GlowColor
            o.Glow.OutlineTransparency = 0.3
        elseif o.Glow then
            o.Glow.Enabled = false
        end
        
        -- Update head dot
        if Cfg.ESP.HeadDot then
            local headScreen, headOn = W2S(head.Position)
            if headOn then
                o.HeadDot.Position = headScreen
                o.HeadDot.Color = Cfg.ESP.HeadDotColor
                o.HeadDot.Visible = true
            else
                o.HeadDot.Visible = false
            end
        else
            o.HeadDot.Visible = false
        end
    end
end

-- ================================================
--  CROSSHAIR SYSTEM
-- ================================================
local CrosshairLines = {}
local CenterDot = nil
local CrosshairAngle = 0

local function CreateCrosshair()
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Cfg.Visuals.CrosshairColor
        line.Thickness = 1.5
        line.ZIndex = 15
        CrosshairLines[i] = line
    end
    
    CenterDot = Drawing.new("Circle")
    CenterDot.Visible = false
    CenterDot.Filled = true
    CenterDot.Radius = 1.5
    CenterDot.Color = Cfg.Visuals.CrosshairColor
    CenterDot.ZIndex = 16
    CenterDot.NumSides = 12
end

local function UpdateCrosshair()
    if not Cfg.Visuals.Crosshair then
        for _, line in ipairs(CrosshairLines) do
            line.Visible = false
        end
        if CenterDot then CenterDot.Visible = false end
        return
    end
    
    local center = AimPoint()
    local size = Cfg.Visuals.CrosshairSize
    local gap = Cfg.Visuals.CrosshairGap
    local col = Cfg.Visuals.CrosshairColor
    
    CrosshairAngle = CrosshairAngle + (0.03 * Cfg.Visuals.CrosshairSpinSpeed)
    if CrosshairAngle > math.pi * 2 then
        CrosshairAngle = CrosshairAngle - math.pi * 2
    end
    
    for i = 1, 4 do
        local line = CrosshairLines[i]
        local angle = (i - 1) * (math.pi / 2) + CrosshairAngle + math.pi / 4
        local fromPos = Vector2.new(
            center.X + math.cos(angle) * gap,
            center.Y + math.sin(angle) * gap
        )
        local toPos = Vector2.new(
            center.X + math.cos(angle) * (gap + size),
            center.Y + math.sin(angle) * (gap + size)
        )
        line.From = fromPos
        line.To = toPos
        line.Color = col
        line.Thickness = 2
        line.Visible = true
    end
    
    if CenterDot then
        CenterDot.Position = center
        CenterDot.Color = col
        CenterDot.Radius = 2
        CenterDot.Visible = true
    end
end

-- ================================================
--  FLIGHT SYSTEM
-- ================================================
local flyConnection = nil
local flyEnabled = false

local function StartFly()
    if flyConnection then return end
    local char = LP.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
    end
    
    flyConnection = RunService:BindToRenderStep("FlySystem", Enum.RenderPriority.Last.Value, function()
        if not flyEnabled then
            StopFly()
            return
        end
        
        local speed = Cfg.Movement.FlySpeed
        local camLook = Camera.CFrame.LookVector
        local camRight = Camera.CFrame.RightVector
        local camUp = Camera.CFrame.UpVector
        
        local moveDirection = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camLook
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camLook
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camRight
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camRight
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + camUp
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - camUp
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * speed
            root.Velocity = moveDirection
        else
            root.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function StopFly()
    if flyConnection then
        RunService:UnbindFromRenderStep("FlySystem")
        flyConnection = nil
    end
    local char = LP.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

local function ToggleFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        StartFly()
        StarterGui:SetCore("SendNotification", {
            Title = "Raven Software",
            Text = "Flight enabled",
            Duration = 1,
        })
    else
        StopFly()
        StarterGui:SetCore("SendNotification", {
            Title = "Raven Software",
            Text = "Flight disabled",
            Duration = 1,
        })
    end
    Cfg.Movement.Fly = flyEnabled
    if Toggles and Toggles.FlyToggle then
        pcall(function() Toggles.FlyToggle:SetValue(flyEnabled) end)
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local keybind = Cfg.Movement.FlyKeybind
    if not keybind then return end
    
    if typeof(keybind) == "EnumItem" then
        if input.KeyCode == keybind or input.UserInputType == keybind then
            ToggleFly()
        end
    elseif typeof(keybind) == "string" then
        if keybind == "MouseButton2" and input.UserInputType == Enum.UserInputType.MouseButton2 then
            ToggleFly()
        elseif keybind == "MouseButton1" and input.UserInputType == Enum.UserInputType.MouseButton1 then
            ToggleFly()
        else
            pcall(function()
                local kc = Enum.KeyCode[keybind]
                if kc and input.KeyCode == kc then
                    ToggleFly()
                end
            end)
        end
    end
end)

-- ================================================
--  NOCLIP SYSTEM
-- ================================================
local noclipConnection = nil

local function StartNoclip()
    if noclipConnection then return end
    
    noclipConnection = RunService:BindToRenderStep("NoclipSystem", Enum.RenderPriority.Last.Value, function()
        if not Cfg.Movement.Noclip then
            StopNoclip()
            return
        end
        
        local char = LP.Character
        if not char then return end
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function StopNoclip()
    if noclipConnection then
        RunService:UnbindFromRenderStep("NoclipSystem")
        noclipConnection = nil
    end
    
    local char = LP.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ================================================
--  VISUALS
-- ================================================
local function UpdateVisuals()
    if Cfg.Visuals.FullBright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    else
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
    
    if Cfg.Visuals.NoFog then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
    else
        Lighting.FogEnd = 1000
        Lighting.FogStart = 0
    end
end

-- ================================================
--  PLAYER MANAGEMENT
-- ================================================
local function OnPlayerAdded(player)
    CreateESP(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        local o = ESPObjects[player]
        if o and o.Chams then
            o.Chams:Destroy()
            o.Chams = nil
        end
        if o and o.Glow then
            o.Glow:Destroy()
            o.Glow = nil
        end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LP then OnPlayerAdded(player) end
end
Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(DestroyESP)

-- ================================================
--  RENDER LOOPS
-- ================================================
RunService.RenderStepped:Connect(function()
    Camera = Workspace.CurrentCamera
    pcall(UpdateFOV)
    pcall(UpdateESP)
    pcall(UpdateVisuals)
    pcall(UpdateCrosshair)
end)

RunService:BindToRenderStep("RavenAimbot", Enum.RenderPriority.Last.Value, function()
    Camera = Workspace.CurrentCamera
    pcall(DoAimbot)
end)

-- ================================================
--  USER INTERFACE
-- ================================================
local Window = Library:CreateWindow({
    Title = "Raven Software",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
})

-- Raven Branding
pcall(function()
    if Window and Window.Holder then
        local logoContainer = Instance.new("Frame")
        logoContainer.Name = "RavenLogo"
        logoContainer.BackgroundTransparency = 1
        logoContainer.AnchorPoint = Vector2.new(0, 1)
        logoContainer.Position = UDim2.new(0, 12, 1, -12)
        logoContainer.Size = UDim2.new(0, 180, 0, 50)
        logoContainer.ZIndex = 5
        
        local glassBg = Instance.new("Frame")
        glassBg.Name = "GlassBackground"
        glassBg.BackgroundColor3 = RavenTheme.Background
        glassBg.BackgroundTransparency = 0.3
        glassBg.BorderSizePixel = 0
        glassBg.Size = UDim2.new(1, 0, 1, 0)
        glassBg.ZIndex = 5
        glassBg.Parent = logoContainer
        
        local cornerGlass = Instance.new("UICorner")
        cornerGlass.CornerRadius = UDim.new(0, 8)
        cornerGlass.Parent = glassBg
        
        local strokeGlass = Instance.new("UIStroke")
        strokeGlass.Color = RavenTheme.Primary
        strokeGlass.Transparency = 0.5
        strokeGlass.Thickness = 1.5
        strokeGlass.Parent = glassBg
        
        local iconFrame = Instance.new("Frame")
        iconFrame.Name = "IconFrame"
        iconFrame.BackgroundTransparency = 1
        iconFrame.Position = UDim2.new(0, 5, 0.5, -20)
        iconFrame.Size = UDim2.new(0, 40, 0, 40)
        iconFrame.ZIndex = 6
        iconFrame.Parent = logoContainer
        
        local logoLabel = Instance.new("ImageLabel")
        logoLabel.Name = "RavenLogoImage"
        logoLabel.BackgroundTransparency = 1
        logoLabel.Size = UDim2.new(1, 0, 1, 0)
        logoLabel.Image = "rbxassetid://73575987788416"
        logoLabel.ScaleType = Enum.ScaleType.Fit
        logoLabel.ZIndex = 6
        logoLabel.Parent = iconFrame
        
        local textHolder = Instance.new("Frame")
        textHolder.Name = "TextHolder"
        textHolder.BackgroundTransparency = 1
        textHolder.Position = UDim2.new(0, 50, 0, 4)
        textHolder.Size = UDim2.new(1, -55, 1, -8)
        textHolder.ZIndex = 6
        textHolder.Parent = logoContainer
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "BrandTitle"
        titleLabel.BackgroundTransparency = 1
        titleLabel.Size = UDim2.new(1, 0, 0, 20)
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.Text = "RAVEN"
        titleLabel.TextColor3 = RavenTheme.Primary
        titleLabel.TextSize = 15
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.ZIndex = 6
        titleLabel.Parent = textHolder
        
        local subLabel = Instance.new("TextLabel")
        subLabel.Name = "BrandSubtitle"
        subLabel.BackgroundTransparency = 1
        subLabel.Position = UDim2.new(0, 0, 0, 19)
        subLabel.Size = UDim2.new(1, 0, 0, 16)
        subLabel.Font = Enum.Font.GothamMedium
        subLabel.Text = "SOFTWARE"
        subLabel.TextColor3 = RavenTheme.Secondary
        subLabel.TextSize = 10
        subLabel.TextXAlignment = Enum.TextXAlignment.Left
        subLabel.ZIndex = 6
        subLabel.Parent = textHolder
        
        local accentLine = Instance.new("Frame")
        accentLine.Name = "AccentLine"
        accentLine.BackgroundColor3 = RavenTheme.Primary
        accentLine.BackgroundTransparency = 0
        accentLine.Position = UDim2.new(0, 5, 0, 0)
        accentLine.Size = UDim2.new(0, 3, 1, 0)
        accentLine.ZIndex = 6
        accentLine.Parent = logoContainer
        
        logoContainer.Parent = Window.Holder
    end
end)

local Tabs = {
    ESP = Window:AddTab("ESP"),
    Aimbot = Window:AddTab("Aimbot"),
    Skins = Window:AddTab("Skins"),
    Unlock = Window:AddTab("Unlock"),
    Visuals = Window:AddTab("Visuals"),
    Movement = Window:AddTab("Movement"),
    Settings = Window:AddTab("Settings"),
}

ApplyRavenTheme()
CreateCrosshair()

task.spawn(function()
    task.wait(0.2)
    ApplyRavenTheme()
end)

-- =============================================
-- ESP TAB
-- =============================================
local ESPGroup = Tabs.ESP:AddLeftGroupbox("ESP Controls")

ESPGroup:AddToggle("ESPEnabled", { Text = "Enable ESP", Default = Cfg.ESP.Enabled })
Toggles.ESPEnabled:OnChanged(function(v) Cfg.ESP.Enabled = v end)

ESPGroup:AddSlider("ESPMaxDist", { Text = "Max Distance", Default = Cfg.ESP.MaxDistance, Min = 50, Max = 5000, Rounding = 0 })
Options.ESPMaxDist:OnChanged(function(v) Cfg.ESP.MaxDistance = v end)

ESPGroup:AddToggle("ESPSkeleton", { Text = "Skeleton", Default = Cfg.ESP.Skeleton })
Toggles.ESPSkeleton:OnChanged(function(v) Cfg.ESP.Skeleton = v end)
Toggles.ESPSkeleton:AddColorPicker("ESPSkeletonColor", { Default = Cfg.ESP.SkeletonColor, Title = "Color" })
Options.ESPSkeletonColor:OnChanged(function(v) Cfg.ESP.SkeletonColor = v end)

ESPGroup:AddToggle("ESPChams", { Text = "Chams", Default = Cfg.ESP.Chams })
Toggles.ESPChams:OnChanged(function(v) Cfg.ESP.Chams = v end)
Toggles.ESPChams:AddColorPicker("ESPChamsColor", { Default = Cfg.ESP.ChamsColor, Title = "Color" })
Options.ESPChamsColor:OnChanged(function(v) Cfg.ESP.ChamsColor = v end)

ESPGroup:AddToggle("ESPGlow", { Text = "Glow", Default = Cfg.ESP.Glow })
Toggles.ESPGlow:OnChanged(function(v) Cfg.ESP.Glow = v end)
Toggles.ESPGlow:AddColorPicker("ESPGlowColor", { Default = Cfg.ESP.GlowColor, Title = "Color" })
Options.ESPGlowColor:OnChanged(function(v) Cfg.ESP.GlowColor = v end)

ESPGroup:AddToggle("ESPHeadDot", { Text = "Head Dot", Default = Cfg.ESP.HeadDot })
Toggles.ESPHeadDot:OnChanged(function(v) Cfg.ESP.HeadDot = v end)
Toggles.ESPHeadDot:AddColorPicker("ESPHeadDotColor", { Default = Cfg.ESP.HeadDotColor, Title = "Color" })
Options.ESPHeadDotColor:OnChanged(function(v) Cfg.ESP.HeadDotColor = v end)

-- =============================================
-- AIMBOT TAB
-- =============================================
local AimbotGroup = Tabs.Aimbot:AddLeftGroupbox("Aimbot Controls")

AimbotGroup:AddToggle("AimbotEnabled", { Text = "Enable Aimbot", Default = Cfg.Aimbot.Enabled })
Toggles.AimbotEnabled:OnChanged(function(v) Cfg.Aimbot.Enabled = v end)
Toggles.AimbotEnabled:AddKeyPicker("AimbotKey", { Default = "MouseButton2", Text = "Aimbot Key", NoUI = false })
Options.AimbotKey:OnChanged(function(v) Cfg.Aimbot.AimKey = Options.AimbotKey.Value end)

AimbotGroup:AddToggle("AimbotWallCheck", { Text = "Wall Check", Default = Cfg.Aimbot.WallCheck })
Toggles.AimbotWallCheck:OnChanged(function(v) Cfg.Aimbot.WallCheck = v end)

AimbotGroup:AddDropdown("AimbotPart", { Values = {"Head", "HumanoidRootPart", "UpperTorso", "Torso"}, Default = 1, Text = "Hitbox" })
Options.AimbotPart:OnChanged(function(v) Cfg.Aimbot.Part = v end)

AimbotGroup:AddToggle("AimbotShowFOV", { Text = "Show FOV", Default = Cfg.Aimbot.ShowFOV })
Toggles.AimbotShowFOV:OnChanged(function(v) Cfg.Aimbot.ShowFOV = v end)
Toggles.AimbotShowFOV:AddColorPicker("AimbotFOVColor", { Default = Cfg.Aimbot.FOVColor, Title = "Color" })
Options.AimbotFOVColor:OnChanged(function(v) Cfg.Aimbot.FOVColor = v end)

AimbotGroup:AddSlider("AimbotFOV", { Text = "FOV Radius", Default = Cfg.Aimbot.FOV, Min = 10, Max = 800, Rounding = 0 })
Options.AimbotFOV:OnChanged(function(v) Cfg.Aimbot.FOV = v end)

AimbotGroup:AddSlider("AimbotSmoothness", { Text = "Smoothness", Default = Cfg.Aimbot.Smoothness, Min = 0, Max = 1, Rounding = 2 })
Options.AimbotSmoothness:OnChanged(function(v) Cfg.Aimbot.Smoothness = v end)

AimbotGroup:AddSlider("AimbotPrediction", { Text = "Prediction", Default = Cfg.Aimbot.Prediction, Min = 0, Max = 2, Rounding = 2 })
Options.AimbotPrediction:OnChanged(function(v) Cfg.Aimbot.Prediction = v end)

-- Insane Tracking
local TrackingGroup = Tabs.Aimbot:AddRightGroupbox("Insane Tracking")

TrackingGroup:AddToggle("InsaneTracking", { Text = "Enable Insane Tracking", Default = Cfg.Aimbot.InsaneTracking })
Toggles.InsaneTracking:OnChanged(function(v) Cfg.Aimbot.InsaneTracking = v end)

TrackingGroup:AddSlider("TrackingSpeed", { Text = "Tracking Speed", Default = Cfg.Aimbot.TrackingSpeed, Min = 0.1, Max = 1, Rounding = 2 })
Options.TrackingSpeed:OnChanged(function(v) Cfg.Aimbot.TrackingSpeed = v end)

TrackingGroup:AddSlider("TrackingPrediction", { Text = "Prediction Multiplier", Default = Cfg.Aimbot.TrackingPrediction, Min = 0.5, Max = 4, Rounding = 1 })
Options.TrackingPrediction:OnChanged(function(v) Cfg.Aimbot.TrackingPrediction = v end)

TrackingGroup:AddSlider("Snappiness", { Text = "Snappiness", Default = Cfg.Aimbot.Snappiness, Min = 0.1, Max = 1, Rounding = 2 })
Options.Snappiness:OnChanged(function(v) Cfg.Aimbot.Snappiness = v end)

TrackingGroup:AddToggle("AutoShoot", { Text = "Auto Shoot", Default = Cfg.Aimbot.AutoShoot })
Toggles.AutoShoot:OnChanged(function(v) Cfg.Aimbot.AutoShoot = v end)

-- =============================================
-- SKIN CHANGER TAB
-- =============================================
local SkinGroup = Tabs.Skins:AddLeftGroupbox("Weapon Skin Changer")

SkinGroup:AddToggle("SkinChangerEnabled", { Text = "Enable Skin Changer", Default = Cfg.SkinChanger.Enabled })
Toggles.SkinChangerEnabled:OnChanged(function(v)
    Cfg.SkinChanger.Enabled = v
    if v then
        task.wait(0.5)
        ChangeWeaponSkin()
        StarterGui:SetCore("SendNotification", {
            Title = "Raven Software",
            Text = "Skin Changer enabled!",
            Duration = 2,
        })
    end
end)

SkinGroup:AddDropdown("SkinType", { 
    Values = {"AssaultRifle", "Sniper", "Shotgun", "SMG", "LMG", "Pistol", "RPG", "Minigun", "Laser"}, 
    Default = 2, 
    Text = "Weapon Type" 
})
Options.SkinType:OnChanged(function(v)
    Cfg.SkinChanger.SkinType = v
    if Cfg.SkinChanger.Enabled then
        task.wait(0.2)
        ChangeWeaponSkin()
        StarterGui:SetCore("SendNotification", {
            Title = "Raven Software",
            Text = "Weapon changed to: " .. v,
            Duration = 2,
        })
    end
end)

-- Weapon Stats Display
local StatsGroup = Tabs.Skins:AddRightGroupbox("Weapon Stats")

StatsGroup:AddButton("Refresh Stats", function()
    local skinType = Cfg.SkinChanger.SkinType
    local data = Cfg.SkinChanger.WeaponModels[skinType]
    if data then
        StarterGui:SetCore("SendNotification", {
            Title = "Weapon Stats",
            Text = string.format("%s\nDamage: %d\nRange: %d\nFire Rate: %.2f\nZoom: %.1fx", 
                data.Name, data.Damage, data.Range, data.FireRate, data.Zoom),
            Duration = 3,
        })
    end
end)

StatsGroup:AddButton("Apply Changes Now", function()
    if Cfg.SkinChanger.Enabled then
        ChangeWeaponSkin()
        StarterGui:SetCore("SendNotification", {
            Title = "Raven Software",
            Text = "Weapon changes applied!",
            Duration = 2,
        })
    end
end)

StatsGroup:AddButton("Scan Weapons", function()
    local weapons = ScanForWeapons()
    local msg = "Weapons found:\n"
    for _, weapon in ipairs(weapons) do
        msg = msg .. "- " .. weapon .. "\n"
    end
    StarterGui:SetCore("SendNotification", {
        Title = "Weapon Scanner",
        Text = msg,
        Duration = 4,
    })
end)

-- =============================================
-- UNLOCK TAB
-- =============================================
local UnlockGroup = Tabs.Unlock:AddLeftGroupbox("Unlock All System")

UnlockGroup:AddToggle("UnlockAll", { Text = "Unlock All (50+ Methods)", Default = Cfg.Unlock.UnlockAll })
Toggles.UnlockAll:OnChanged(function(v) 
    Cfg.Unlock.UnlockAll = v
    if v then RunUnlockAll() end
end)

UnlockGroup:AddToggle("UnlockForce", { Text = "Force Unlock", Default = Cfg.Unlock.ForceUnlock })
Toggles.UnlockForce:OnChanged(function(v) Cfg.Unlock.ForceUnlock = v end)

UnlockGroup:AddButton("Execute Unlock All", function()
    Cfg.Unlock.UnlockAll = true
    RunUnlockAll()
    StarterGui:SetCore("SendNotification", {
        Title = "Raven Software",
        Text = "Unlock All executed!",
        Duration = 2,
    })
end)

local UnlockMethodsGroup = Tabs.Unlock:AddRightGroupbox("Unlock Methods")

UnlockMethodsGroup:AddToggle("UnlockBypass", { Text = "Bypass", Default = Cfg.Unlock.UnlockMethods.Bypass })
Toggles.UnlockBypass:OnChanged(function(v) Cfg.Unlock.UnlockMethods.Bypass = v end)

UnlockMethodsGroup:AddToggle("UnlockFakePurchases", { Text = "Fake Purchases", Default = Cfg.Unlock.UnlockMethods.FakePurchases })
Toggles.UnlockFakePurchases:OnChanged(function(v) Cfg.Unlock.UnlockMethods.FakePurchases = v end)

UnlockMethodsGroup:AddToggle("UnlockMemoryEdit", { Text = "Memory Edit", Default = Cfg.Unlock.UnlockMethods.MemoryEdit })
Toggles.UnlockMemoryEdit:OnChanged(function(v) Cfg.Unlock.UnlockMethods.MemoryEdit = v end)

UnlockMethodsGroup:AddToggle("UnlockRemoteSpoof", { Text = "Remote Spoof", Default = Cfg.Unlock.UnlockMethods.RemoteSpoof })
Toggles.UnlockRemoteSpoof:OnChanged(function(v) Cfg.Unlock.UnlockMethods.RemoteSpoof = v end)

UnlockMethodsGroup:AddToggle("UnlockClientSpoof", { Text = "Client Spoof", Default = Cfg.Unlock.UnlockMethods.ClientSpoof })
Toggles.UnlockClientSpoof:OnChanged(function(v) Cfg.Unlock.UnlockMethods.ClientSpoof = v end)

UnlockMethodsGroup:AddToggle("UnlockInventoryFake", { Text = "Inventory Fake", Default = Cfg.Unlock.UnlockMethods.InventoryFake })
Toggles.UnlockInventoryFake:OnChanged(function(v) Cfg.Unlock.UnlockMethods.InventoryFake = v end)

UnlockMethodsGroup:AddToggle("UnlockStatsModify", { Text = "Stats Modify", Default = Cfg.Unlock.UnlockMethods.StatsModify })
Toggles.UnlockStatsModify:OnChanged(function(v) Cfg.Unlock.UnlockMethods.StatsModify = v end)

UnlockMethodsGroup:AddToggle("UnlockLeaderboardFake", { Text = "Leaderboard Fake", Default = Cfg.Unlock.UnlockMethods.LeaderboardFake })
Toggles.UnlockLeaderboardFake:OnChanged(function(v) Cfg.Unlock.UnlockMethods.LeaderboardFake = v end)

UnlockMethodsGroup:AddToggle("UnlockItemDuplication", { Text = "Item Duplication", Default = Cfg.Unlock.UnlockMethods.ItemDuplication })
Toggles.UnlockItemDuplication:OnChanged(function(v) Cfg.Unlock.UnlockMethods.ItemDuplication = v end)

UnlockMethodsGroup:AddToggle("UnlockCurrencySpoof", { Text = "Currency Spoof", Default = Cfg.Unlock.UnlockMethods.CurrencySpoof })
Toggles.UnlockCurrencySpoof:OnChanged(function(v) Cfg.Unlock.UnlockMethods.CurrencySpoof = v end)

UnlockMethodsGroup:AddToggle("UnlockLevelFake", { Text = "Level Fake", Default = Cfg.Unlock.UnlockMethods.LevelFake })
Toggles.UnlockLevelFake:OnChanged(function(v) Cfg.Unlock.UnlockMethods.LevelFake = v end)

UnlockMethodsGroup:AddToggle("UnlockBadge", { Text = "Badge Unlock", Default = Cfg.Unlock.UnlockMethods.BadgeUnlock })
Toggles.UnlockBadge:OnChanged(function(v) Cfg.Unlock.UnlockMethods.BadgeUnlock = v end)

UnlockMethodsGroup:AddToggle("UnlockTrophy", { Text = "Trophy Unlock", Default = Cfg.Unlock.UnlockMethods.TrophyUnlock })
Toggles.UnlockTrophy:OnChanged(function(v) Cfg.Unlock.UnlockMethods.TrophyUnlock = v end)

UnlockMethodsGroup:AddToggle("UnlockAchievement", { Text = "Achievement Unlock", Default = Cfg.Unlock.UnlockMethods.AchievementUnlock })
Toggles.UnlockAchievement:OnChanged(function(v) Cfg.Unlock.UnlockMethods.AchievementUnlock = v end)

UnlockMethodsGroup:AddToggle("UnlockCollection", { Text = "Collection Complete", Default = Cfg.Unlock.UnlockMethods.CollectionComplete })
Toggles.UnlockCollection:OnChanged(function(v) Cfg.Unlock.UnlockMethods.CollectionComplete = v end)

UnlockMethodsGroup:AddToggle("UnlockSkin", { Text = "Skin Unlock", Default = Cfg.Unlock.UnlockMethods.SkinUnlock })
Toggles.UnlockSkin:OnChanged(function(v) Cfg.Unlock.UnlockMethods.SkinUnlock = v end)

UnlockMethodsGroup:AddToggle("UnlockCosmetic", { Text = "Cosmetic Unlock", Default = Cfg.Unlock.UnlockMethods.CosmeticUnlock })
Toggles.UnlockCosmetic:OnChanged(function(v) Cfg.Unlock.UnlockMethods.CosmeticUnlock = v end)

UnlockMethodsGroup:AddToggle("UnlockTool", { Text = "Tool Unlock", Default = Cfg.Unlock.UnlockMethods.ToolUnlock })
Toggles.UnlockTool:OnChanged(function(v) Cfg.Unlock.UnlockMethods.ToolUnlock = v end)

UnlockMethodsGroup:AddToggle("UnlockWeapon", { Text = "Weapon Unlock", Default = Cfg.Unlock.UnlockMethods.WeaponUnlock })
Toggles.UnlockWeapon:OnChanged(function(v) Cfg.Unlock.UnlockMethods.WeaponUnlock = v end)

UnlockMethodsGroup:AddToggle("UnlockVehicle", { Text = "Vehicle Unlock", Default = Cfg.Unlock.UnlockMethods.VehicleUnlock })
Toggles.UnlockVehicle:OnChanged(function(v) Cfg.Unlock.UnlockMethods.VehicleUnlock = v end)

UnlockMethodsGroup:AddToggle("UnlockPet", { Text = "Pet Unlock", Default = Cfg.Unlock.UnlockMethods.PetUnlock })
Toggles.UnlockPet:OnChanged(function(v) Cfg.Unlock.UnlockMethods.PetUnlock = v end)

UnlockMethodsGroup:AddToggle("UnlockMount", { Text = "Mount Unlock", Default = Cfg.Unlock.UnlockMethods.MountUnlock })
Toggles.UnlockMount:OnChanged(function(v) Cfg.Unlock.UnlockMethods.MountUnlock = v end)

UnlockMethodsGroup:AddToggle("UnlockTitle", { Text = "Title Unlock", Default = Cfg.Unlock.UnlockMethods.TitleUnlock })
Toggles.UnlockTitle:OnChanged(function(v) Cfg.Unlock.UnlockMethods.TitleUnlock = v end)

UnlockMethodsGroup:AddToggle("UnlockRank", { Text = "Rank Fake", Default = Cfg.Unlock.UnlockMethods.RankFake })
Toggles.UnlockRank:OnChanged(function(v) Cfg.Unlock.UnlockMethods.RankFake = v end)

UnlockMethodsGroup:AddToggle("UnlockRole", { Text = "Role Fake", Default = Cfg.Unlock.UnlockMethods.RoleFake })
Toggles.UnlockRole:OnChanged(function(v) Cfg.Unlock.UnlockMethods.RoleFake = v end)

-- =============================================
-- VISUALS TAB
-- =============================================
local VisualsGroup = Tabs.Visuals:AddLeftGroupbox("Environment & Crosshair")

VisualsGroup:AddToggle("FullBright", { Text = "Fullbright", Default = Cfg.Visuals.FullBright })
Toggles.FullBright:OnChanged(function(v) Cfg.Visuals.FullBright = v end)

VisualsGroup:AddToggle("NoFog", { Text = "No Fog", Default = Cfg.Visuals.NoFog })
Toggles.NoFog:OnChanged(function(v) Cfg.Visuals.NoFog = v end)

VisualsGroup:AddToggle("Crosshair", { Text = "Crosshair", Default = Cfg.Visuals.Crosshair })
Toggles.Crosshair:OnChanged(function(v) Cfg.Visuals.Crosshair = v end)
Toggles.Crosshair:AddColorPicker("CrosshairColor", { Default = Cfg.Visuals.CrosshairColor, Title = "Color" })
Options.CrosshairColor:OnChanged(function(v) Cfg.Visuals.CrosshairColor = v end)

VisualsGroup:AddSlider("CrosshairSize", { Text = "Size", Default = Cfg.Visuals.CrosshairSize, Min = 4, Max = 30, Rounding = 0 })
Options.CrosshairSize:OnChanged(function(v) Cfg.Visuals.CrosshairSize = v end)

VisualsGroup:AddSlider("CrosshairGap", { Text = "Gap", Default = Cfg.Visuals.CrosshairGap, Min = 1, Max = 15, Rounding = 0 })
Options.CrosshairGap:OnChanged(function(v) Cfg.Visuals.CrosshairGap = v end)

-- =============================================
-- MOVEMENT TAB
-- =============================================
local MovementGroup = Tabs.Movement:AddLeftGroupbox("Movement Controls")

MovementGroup:AddToggle("Fly", { Text = "Flight", Default = Cfg.Movement.Fly })
Toggles.Fly:OnChanged(function(v)
    if flyEnabled ~= v then ToggleFly() end
end)
Toggles.Fly:AddKeyPicker("FlyKey", { Default = "F", Text = "Fly Key", NoUI = false })
Options.FlyKey:OnChanged(function(v) Cfg.Movement.FlyKeybind = Options.FlyKey.Value end)

MovementGroup:AddSlider("FlySpeed", { Text = "Flight Speed", Default = Cfg.Movement.FlySpeed, Min = 10, Max = 300, Rounding = 0 })
Options.FlySpeed:OnChanged(function(v) Cfg.Movement.FlySpeed = v end)

MovementGroup:AddToggle("SpeedHack", { Text = "Speed Hack", Default = Cfg.Movement.SpeedHack })
Toggles.SpeedHack:OnChanged(function(v) Cfg.Movement.SpeedHack = v end)

MovementGroup:AddSlider("SpeedValue", { Text = "Speed Factor", Default = Cfg.Movement.SpeedValue, Min = 16, Max = 100, Rounding = 0 })
Options.SpeedValue:OnChanged(function(v) Cfg.Movement.SpeedValue = v end)

MovementGroup:AddToggle("Noclip", { Text = "Noclip", Default = Cfg.Movement.Noclip })
Toggles.Noclip:OnChanged(function(v)
    Cfg.Movement.Noclip = v
    if v then StartNoclip() else StopNoclip() end
end)

-- =============================================
-- SETTINGS TAB
-- =============================================
Library:SetWatermark("Raven Software | Black | Red | Yellow")
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

-- Cleanup
game:BindToClose(function()
    StopFly()
    StopNoclip()
    for player, _ in pairs(ESPObjects) do
        DestroyESP(player)
    end
    pcall(function() FOVCircle:Remove() end)
    for _, line in ipairs(CrosshairLines) do
        pcall(function() line:Remove() end)
    end
    if CenterDot then pcall(function() CenterDot:Remove() end) end
end)
