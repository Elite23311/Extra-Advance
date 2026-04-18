-- ╔══════════════════════════════════════════╗
-- ║         ScriptHub — Loader.lua           ║
-- ║   The ONLY file your users ever run.     ║
-- ╚══════════════════════════════════════════╝
--
-- User loadstring:
--   loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/Loader.lua"))()

-- ── CONFIG ─────────────────────────────────
local RAW = "https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/"
-- ───────────────────────────────────────────

-- ── GAME ROUTES ────────────────────────────
-- Add your PlaceIds here. The value is the path
-- inside your repo that will be loaded for that game.
local GameRoutes = {
    [2788229376] = "Games/Rivals.lua",
    -- [YOUR_PLACE_ID] = "Games/YourGame.lua",
}
-- ───────────────────────────────────────────

-- ── LOAD LINORIALIB ────────────────────────
local repo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"

local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- ── SHARED GLOBALS ─────────────────────────
-- All Feature/Game modules read from _G so they
-- don't need to re-load the library themselves.
_G.Library      = Library
_G.ThemeManager = ThemeManager
_G.SaveManager  = SaveManager
_G.RAW          = RAW

-- Safe remote loader with error reporting
_G.Load = function(path)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(RAW .. path))()
    end)
    if not ok then
        warn("[ScriptHub] Failed to load '" .. path .. "':\n" .. tostring(err))
        Library:Notify("Load error: " .. path, 5)
    end
end

-- ── BOOT SEQUENCE ──────────────────────────
-- 1. Key system + window + settings
_G.Load("Features/Main.lua")

-- 2. Game-specific module (if supported)
local route = GameRoutes[game.PlaceId]
if route then
    _G.Load(route)
else
    Library:Notify("Unsupported game  |  PlaceId: " .. game.PlaceId, 6)
end
