local _nwlatxn=math.random()
local _ntyhkux=math.random()
local _njtvuzc=math.random()
local _obb = _G._obb
local _obc    = _G._obc
local _obd = _G._obd
local function decode(arr)
local _obe = {}
for i = 1, #arr do
_obe[i] = string.char(arr[i])
end
return table.concat(_obe)
end
local _obf = decode({83, 99, 114, 105, 112, 116, 72, 117, 98})
local _obg   = _obf .. "/" .. decode({107, 101, 121, 46, 116, 120, 116})
local _obh = {
[decode({121, 111, 117, 114, 107, 101, 121, 49, 50, 51})] = true,
[decode({116, 101, 115, 116, 107, 101, 121})]           = true,
["EAtest"]                                                = true,
}
local function SaveKey(key)
if not isfolder(_obf) then
makefolder(_obf)
end
writefile(_obg, key)
end
local function GetSavedKey()
if isfile(_obg) then
return readfile(_obg):match("^%s*(.-)%s*$")
end
end
local function CheckKey(key)
return _obh[key:lower()] == true
end
local _obi = {}
function _obi.Init(onAuthCallback)
if getgenv().scriptkey and getgenv().scriptkey ~= "" then
if CheckKey(getgenv().scriptkey) then
_obb:Notify("✓ Authenticated via scriptkey — loading features...", 3)
SaveKey(getgenv().scriptkey)
onAuthCallback()
return
else
_obb:Notify("Invalid scriptkey!", 3)
end
end
local _obj = GetSavedKey()
if _obj and CheckKey(_obj) then
_obb:Notify("✓ Authenticated — loading features...", 3)
onAuthCallback()
return
end
local _obk = _obc.Main:AddLeftGroupbox("🔑  Key System")
_obk:AddLabel("Enter your key to unlock the script.\nGet keys from our Discord.", true)
_obk:AddDivider()
_obk:AddInput("KeyInput", {
Default     = "",
Numeric     = false,
Finished    = true,
Text        = "Key",
Placeholder = "Paste your key here...",
})
_obk:AddButton({
Text = "Submit Key",
Func = function()
local _obl = _obd.KeyInput.Value:match("^%s*(.-)%s*$")
if _obl == "" then
_obb:Notify("Please enter a key first.", 3)
return
end
if CheckKey(_obl) then
SaveKey(_obl)
_obb:Notify("Key accepted!", 3)
onAuthCallback()
else
_obb:Notify("Invalid key. Try again.", 4)
end
end,
})
_obk:AddDivider()
_obk:AddButton({
Text = "Get Key  →  Discord",
Func = function()
setclipboard("https://discord.gg/YOURLINK")
_obb:Notify("Discord link copied!", 3)
end,
})
_obk:AddButton({
Text = "Clear Saved Key",
Func = function()
if isfile(_obg) then
delfile(_obg)
_obb:Notify("Saved key cleared.", 3)
else
_obb:Notify("No saved key found.", 3)
end
end,
})
end
return _obi