-- [[ Loader.lua ]] --

local RAW  = "https://raw.githubusercontent.com/Elite23311/Extra-Advance/main/Main/"
local repo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"

local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local UIS = game:GetService("UserInputService")
game:GetService("RunService").RenderStepped:Connect(function()
    UIS.MouseIconEnabled = true
end)

getgenv().Library      = Library
getgenv().ThemeManager = ThemeManager
getgenv().SaveManager  = SaveManager
getgenv().RAW          = RAW

local function log(msg)
    print("[Extra Advance] " .. tostring(msg))
end

local function loadPath(path)
    log("Loading: " .. path)
    local content = game:HttpGet(RAW .. path)
    if content:sub(1, 1) == "<" or #content < 10 then
        warn("[Extra Advance] 404: " .. path)
        return
    end
    local fn, err = loadstring(content, path)
    if not fn then
        warn("[Extra Advance] Compile error: " .. path .. " >> " .. tostring(err))
        return
    end
    -- fix for prometheus getfenv issue
    setfenv(fn, getfenv())
    fn()
end

-- ──────────────────────────────────────────
-- Window
-- ──────────────────────────────────────────

local Window = Library:CreateWindow({
    Title        = "Extra Advance",
    Center       = true,
    AutoShow     = true,
    TabPadding   = 8,
    MenuFadeTime = 0.2,
})

Library.ShowCustomCursor = false

getgenv().Window = Window

-- ──────────────────────────────────────────
-- Game Routes
-- ──────────────────────────────────────────

local GameRoutes = {
    [17625359962] = "Games/Rivals/Main.lua",
}

-- ──────────────────────────────────────────
-- Load
-- ──────────────────────────────────────────

local route = GameRoutes[game.PlaceId]

if route then
    Library:Notify("Supported game detected! Loading...", 2)
    loadPath(route)
else
    Library:Notify("No supported game found. Loading Universal only.", 5)
    loadPath("Games/Universal/Main.lua")
end

-- ──────────────────────────────────────────
-- Settings
-- ──────────────────────────────────────────

local SettingsTab = Window:AddTab("Settings")
local MenuGroup = SettingsTab:AddLeftGroupbox("Menu")

MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

MenuGroup:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
    Default = "End",
    NoUI    = true,
    Text    = "Toggle Menu",
})

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("ExtraAdvance")
SaveManager:SetFolder("ExtraAdvance/" .. tostring(game.PlaceId))

ThemeManager:ApplyToTab(SettingsTab)
SaveManager:BuildConfigSection(SettingsTab)

SaveManager:LoadAutoloadConfig()
log("Loading complete.")

print("[Debug] Library:", tostring(getgenv().Library))
print("[Debug] Window:", tostring(getgenv().Window))
print("[Debug] RAW:", tostring(getgenv().RAW))
-- ──────────────────────────────────────────
-- Watermark
-- ──────────────────────────────────────────

Library:SetWatermarkVisibility(true)

local fpsTimer   = tick()
local fpsCounter = 0
local fps        = 60

local wmConn = game:GetService("RunService").RenderStepped:Connect(function()
    fpsCounter = fpsCounter + 1
    if (tick() - fpsTimer) >= 1 then
        fps        = fpsCounter
        fpsTimer   = tick()
        fpsCounter = 0
    end
    Library:SetWatermark(("Extra Advance | %d fps | %d ms"):format(
        math.floor(fps),
        math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
    ))
end)

Library:OnUnload(function()
    if wmConn then wmConn:Disconnect() end
    log("Unloading script...")
    Library.Unloaded = true
end)