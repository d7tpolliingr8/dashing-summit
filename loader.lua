--[[
    Raven Cheats - Direct Load
    No Loader - Instant Menu
    Discord: https://discord.gg/FnKfhZ7Fb6
]]

-- ======================================================================
--  CONFIGURATION
-- ======================================================================

local SCRIPT_URL = "https://raw.githubusercontent.com/d7tpolliingr8/dashing-summit/main/rivalsaimwh.lua"

-- ======================================================================
--  DIRECT LOAD - NO LOADER
-- ======================================================================

print("[Raven] Loading directly...")

local success, result = pcall(function()
    return loadstring(game:HttpGet(SCRIPT_URL))()
end)

if success then
    print("[Raven] ✅ Loaded successfully!")
    print("[Raven] Press Right Shift to open menu.")
else
    warn("[Raven] ❌ Failed to load: " .. tostring(result))
end
