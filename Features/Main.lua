-- ╔══════════════════════════════════════════╗
-- ║       Features/Main.lua                  ║
-- ║  Key system · Window · Tabs · Addons     ║
-- ╚══════════════════════════════════════════╝

local Library      = _G.Library
local ThemeManager = _G.ThemeManager
local SaveManager  = _G.SaveManager

-- ── KEY SYSTEM ─────────────────────────────
-- Put your valid keys here. Keys are case-insensitive.
local VALID_KEYS = {
    ["yourkey123"] = true,
    ["testkey"]    = true,
}

local KEY_FOLDER = "ScriptHub"
local KEY_FILE   = KEY_FOLDER .. "/key.txt"

local function SaveKey(key)
    if not isfolder(KEY_FOLDER) then makefolder(KEY_FOLDER) end
    writefile(KEY_FILE, key)
end

local function GetSavedKey()
    if isfile(KEY_FILE) then
        return readfile(KEY_FILE):match("^%s*(.-)%s*$") -- trim whitespace
    end
end

local function CheckKey(key)
    return VALID_KEYS[key:lower()] == true
end

-- ── WINDOW ─────────────────────────────────
local Window = Library:CreateWindow({
    Title       = "ScriptHub",
    Center      = true,
    AutoShow    = true,
    TabPadding  = 8,
    MenuFadeTime = 0.2,
})

_G.Window = Window

-- ── TABS ───────────────────────────────────
-- These are created here so Game modules can
-- add groupboxes into them freely.
local Tabs = {
    Main         = Window:AddTab("Main"),
    Visual       = Window:AddTab("Visual"),
    Player       = Window:AddTab("Player"),
    ["Settings"] = Window:AddTab("Settings"),
}

_G.Tabs    = Tabs
_G.Toggles = Toggles  -- LinoriaLib exposes this to getgenv()
_G.Options = Options  -- LinoriaLib exposes this to getgenv()

-- ── KEY GATE ───────────────────────────────
-- If key is already saved & valid → skip the gate entirely.
-- Otherwise lock out Settings/etc until authenticated.

local authed = false

local function OnAuthenticated()
    authed = true
    Library:Notify("✓ Authenticated — loading features...", 3)
    task.wait(0.5)
    -- Load AimAssist after auth
    _G.Load("Features/AimAssist.lua")
end

local savedKey = GetSavedKey()
if savedKey and CheckKey(savedKey) then
    -- Silent auto-auth
    OnAuthenticated()
else
    -- Show a key input at the top of Main tab
    local KeyBox = Tabs.Main:AddLeftGroupbox("🔑  Key System")

    KeyBox:AddLabel("Enter your key to unlock the script.\nGet keys from our Discord.", true)
    KeyBox:AddDivider()

    KeyBox:AddInput("KeyInput", {
        Default     = "",
        Numeric     = false,
        Finished    = true,  -- fires on Enter
        Text        = "Key",
        Placeholder = "Paste your key here...",
    })

    KeyBox:AddButton({
        Text = "Submit Key",
        Func = function()
            local entered = Options.KeyInput.Value:match("^%s*(.-)%s*$")
            if entered == "" then
                Library:Notify("Please enter a key first.", 3)
                return
            end
            if CheckKey(entered) then
                SaveKey(entered)
                Library:Notify("Key accepted!", 3)
                OnAuthenticated()
            else
                Library:Notify("Invalid key. Try again.", 4)
            end
        end,
    })

    KeyBox:AddDivider()

    KeyBox:AddButton({
        Text = "Get Key  →  Discord",
        Func = function()
            setclipboard("https://discord.gg/YOURLINK")
            Library:Notify("Discord link copied!", 3)
        end,
    })

    KeyBox:AddButton({
        Text = "Clear Saved Key",
        Func = function()
            if isfile(KEY_FILE) then
                delfile(KEY_FILE)
                Library:Notify("Saved key cleared.", 3)
            else
                Library:Notify("No saved key found.", 3)
            end
        end,
    })
end

-- ── SETTINGS TAB ───────────────────────────
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

-- ── WATERMARK ──────────────────────────────
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

-- ── ADDONS ─────────────────────────────────
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("ScriptHub")
SaveManager:SetFolder("ScriptHub/" .. tostring(game.PlaceId))

ThemeManager:ApplyToTab(Tabs["Settings"])
SaveManager:BuildConfigSection(Tabs["Settings"])

SaveManager:LoadAutoloadConfig()
