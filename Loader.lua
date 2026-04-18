--   loadstring(game:HttpGet("https://raw.githubusercontent.com/Elite23311/Extra-Advance/main/Loader.lua"))()

local RAW = "https://raw.githubusercontent.com/Elite23311/Extra-Advance/main/"
local repo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"

local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

_G.Library      = Library
_G.ThemeManager = ThemeManager
_G.SaveManager  = SaveManager
_G.RAW          = RAW

local function loadPath(path)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(RAW .. path))()
    end)
    if not ok then
        warn("[EA] Failed to load '" .. path .. "':\n" .. tostring(err))
        Library:Notify("Load error: " .. path, 5)
    end
end

local GameRoutes = {
    [17625359962] = "Games/Rivals/Main.lua",
    -- [YOUR_PLACE_ID] = "Games/YourGame/Main.lua",
}

local Window = Library:CreateWindow({
    Title       = "ScriptHub",
    Center      = true,
    AutoShow    = true,
    TabPadding  = 8,
    MenuFadeTime = 0.2,
})

_G.Window = Window

local Tabs = {
    Main         = Window:AddTab("Main"),
    Visual       = Window:AddTab("Visual"),
    Player       = Window:AddTab("Player"),
    ["Settings"] = Window:AddTab("Settings"),
}

_G.Tabs    = Tabs
_G.Toggles = Toggles
_G.Options = Options

-- Load key system
local KeySystem = loadstring(game:HttpGet(RAW .. "KeySystem.lua"))()

KeySystem.Init(function()
    -- Callback after authentication
    -- Always load Universal hacks
    loadPath("Games/Universal/Main.lua")
    
    -- Load game-specific hacks if available
    local route = GameRoutes[game.PlaceId]
    if route then
        loadPath(route)
    end
end)

local MenuGroup = Tabs["Settings"]:AddLeftGroupbox("Menu")

MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

MenuGroup:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
    Default = "End",
    NoUI    = true,
    Text    = "Toggle Menu",
})

Library.ToggleKeybind = Options.MenuKeybind

Library:SetWatermarkVisibility(true)

local fpsTimer   = tick()
local fpsCounter = 0
local fps        = 60

local wmConn = game:GetService("RunService").RenderStepped:Connect(function()
    fpsCounter += 1
    if (tick() - fpsTimer) >= 1 then
        fps      = fpsCounter
        fpsTimer = tick()
        fpsCounter = 0
    end
    Library:SetWatermark(("ScriptHub  |  %d fps  |  %d ms"):format(
        math.floor(fps),
        math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
    ))
end)

Library:OnUnload(function()
    wmConn:Disconnect()
    Library.Unloaded = true
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("ScriptHub")
SaveManager:SetFolder("ScriptHub/" .. tostring(game.PlaceId))

ThemeManager:ApplyToTab(Tabs["Settings"])
SaveManager:BuildConfigSection(Tabs["Settings"])

SaveManager:LoadAutoloadConfig()

SaveManager:LoadAutoloadConfig()
