-- ╔══════════════════════════════════════════╗
-- ║         KeySystem.lua                    ║
-- ║  Extracted key validation & UI gate      ║
-- ╚══════════════════════════════════════════╝

local Library = _G.Library
local Tabs    = _G.Tabs
local Options = _G.Options

local function decode(arr)
    local t = {}
    for i = 1, #arr do
        t[i] = string.char(arr[i])
    end
    return table.concat(t)
end

local KEY_FOLDER = decode({83, 99, 114, 105, 112, 116, 72, 117, 98}) -- ScriptHub
local KEY_FILE   = KEY_FOLDER .. "/" .. decode({107, 101, 121, 46, 116, 120, 116}) -- key.txt

local VALID_KEYS = {
    [decode({121, 111, 117, 114, 107, 101, 121, 49, 50, 51})] = true,
    [decode({116, 101, 115, 116, 107, 101, 121})]           = true,
}

local function SaveKey(key)
    if not isfolder(KEY_FOLDER) then
        makefolder(KEY_FOLDER)
    end
    writefile(KEY_FILE, key)
end

local function GetSavedKey()
    if isfile(KEY_FILE) then
        return readfile(KEY_FILE):match("^%s*(.-)%s*$")
    end
end

local function CheckKey(key)
    return VALID_KEYS[key:lower()] == true
end

local KeySystem = {}

function KeySystem.Init(onAuthCallback)
    local savedKey = GetSavedKey()
    if savedKey and CheckKey(savedKey) then
        -- Silent auto-auth
        Library:Notify("✓ Authenticated — loading features...", 3)
        onAuthCallback()
        return
    end

    -- Show key input UI in Main tab
    local KeyBox = Tabs.Main:AddLeftGroupbox("🔑  Key System")

    KeyBox:AddLabel("Enter your key to unlock the script.\nGet keys from our Discord.", true)
    KeyBox:AddDivider()

    KeyBox:AddInput("KeyInput", {
        Default     = "",
        Numeric     = false,
        Finished    = true,
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
                onAuthCallback()
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

return KeySystem
