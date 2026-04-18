local gfqemess=math.random()
local wsqelgsp=math.random()
local zvvmnvpm=math.random()
local _b = _G._b
local _c    = _G._c
local _d = _G._d
local function decode(arr)
local _e = {}
for i = 1, #arr do
_e[i] = string.char(arr[i])
end
return table.concat(_e)
end
local _f = decode({83, 99, 114, 105, 112, 116, 72, 117, 98})
local _g   = _f .. "/" .. decode({107, 101, 121, 46, 116, 120, 116})
local _h = {
[decode({121, 111, 117, 114, 107, 101, 121, 49, 50, 51})] = true,
[decode({116, 101, 115, 116, 107, 101, 121})]           = true,
["EAtest"]                                                = true,
}
local function SaveKey(key)
if not isfolder(_f) then
makefolder(_f)
end
writefile(_g, key)
end
local function GetSavedKey()
if isfile(_g) then
return readfile(_g):match("^%s*(.-)%s*$")
end
end
local function CheckKey(key)
return _h[key:lower()] == true
end
local _i = {}
function _i.Init(onAuthCallback)
if getgenv().scriptkey and getgenv().scriptkey ~= "" then
if CheckKey(getgenv().scriptkey) then
_b:Notify("✓ Authenticated via " .. "scriptkey — loading " .. "features...", 3)
SaveKey(getgenv().scriptkey)
onAuthCallback()
return
else
_b:Notify("Invalid scriptkey!", 3)
end
end
local _j = GetSavedKey()
if _j and CheckKey(_j) then
_b:Notify("✓ Authenticated — loading features...", 3)
onAuthCallback()
return
end
local _k = _c.Main:AddLeftGroupbox("🔑  Key System")
_k:AddLabel("Enter your key to un" .. "lock the script.\nGe" .. "t keys from our Disc" .. "ord.", true)
_k:AddDivider()
_k:AddInput("KeyInput", {
Default     = "",
Numeric     = false,
Finished    = true,
Text        = "Key",
Placeholder = "Paste your key here...",
})
_k:AddButton({
Text = "Submit Key",
Func = function()
local _l = _d.KeyInput.Value:match("^%s*(.-)%s*$")
if _l == "" then
_b:Notify("Please enter a key first.", 3)
return
end
if CheckKey(_l) then
SaveKey(_l)
_b:Notify("Key accepted!", 3)
onAuthCallback()
else
_b:Notify("Invalid key. Try again.", 4)
end
end,
})
_k:AddDivider()
_k:AddButton({
Text = "Get Key  →  Discord",
Func = function()
setclipboard("https://discord.gg/YOURLINK")
_b:Notify("Discord link copied!", 3)
end,
})
_k:AddButton({
Text = "Clear Saved Key",
Func = function()
if isfile(_g) then
delfile(_g)
_b:Notify("Saved key cleared.", 3)
else
_b:Notify("No saved key found.", 3)
end
end,
})
end
return _i