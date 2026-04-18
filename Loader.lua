--   loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/Loader.lua"))()

local RAW = "https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/"

local GameRoutes = {
    [17625359962] = "Games/Rivals.lua",
    -- [YOUR_PLACE_ID] = "Games/YourGame.lua",
}
local repo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"

local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

_G.Library      = Library
_G.ThemeManager = ThemeManager
_G.SaveManager  = SaveManager
_G.RAW          = RAW

_G.Load = function(path)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(RAW .. path))()
    end)
    if not ok then
        warn("[EA] Failed to load '" .. path .. "':\n" .. tostring(err))
        Library:Notify("Load error: " .. path, 5)
    end
end

_G.Load("Features/Main.lua")

local route = GameRoutes[game.PlaceId]
if route then
    _G.Load(route)
else
    Library:Notify("Unsupported game  |  PlaceId: " .. game.PlaceId, 6)
end
