local _ntxsqax=math.random()
local _nzfurvl=math.random()
local _nqhwicq=math.random()
local _obb = "https://raw.githubusercontent.com/Elite23311/Extra-Advance/main/"
local _obc = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"
local _obd      = loadstring(game:HttpGet(_obc .. "Library.lua"))()
local _obe = loadstring(game:HttpGet(_obc .. "addons/ThemeManager.lua"))()
local _obf  = loadstring(game:HttpGet(_obc .. "addons/SaveManager.lua"))()
_G._obd      = _obd
_G._obe = _obe
_G._obf  = _obf
_G._obb          = _obb
local function loadPath(path)
local _obg, err = pcall(function()
loadstring(game:HttpGet(_obb .. path))()
end)
if not _obg then
warn("[EA] Failed to load '" .. path .. "':\n" .. tostring(err))
_obd:Notify("Load error: " .. path, 5)
end
end
local _obh = {
[17625359962] = "Games/Rivals/Main.lua",
}
local _obi = _obd:CreateWindow({
Title       = "Extra Advance",
Center      = true,
AutoShow    = true,
TabPadding  = 8,
MenuFadeTime = 0.2,
})
_G._obi = _obi
local _obj = {
Main         = _obi:AddTab("Main"),
Visual       = _obi:AddTab("Visual"),
Player       = _obi:AddTab("Player"),
["Settings"] = _obi:AddTab("Settings"),
}
_G._obj    = _obj
_G.Toggles = Toggles
_G.Options = Options
local _obk = loadstring(game:HttpGet(_obb .. "KeySystem.lua"))()
_obk.Init(function()
local _obl = _obh[game.PlaceId]
if _obl then
loadPath(_obl)
else
_obd:Notify("No game supported are found, running universal script..", 5)
loadPath("Games/Universal/Main.lua")
end
end)
local _obm = _obj["Settings"]:AddLeftGroupbox("Menu")
_obm:AddButton("Unload", function()
_obd:Unload()
end)
_obm:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
Default = "End",
NoUI    = true,
Text    = "Toggle Menu",
})
_obd.ToggleKeybind = Options.MenuKeybind
_obd:SetWatermarkVisibility(true)
local _obn   = tick()
local _obo = 0
local _obp        = 60
local _obq = game:GetService("RunService").RenderStepped:Connect(function()
_obo += 1
if (tick() - _obn) >= 1 then
_obp      = _obo
_obn = tick()
_obo = 0
end
_obd:SetWatermark(("Extra Advance On Top  |  %d fps  |  %d ms"):format(
math.floor(_obp),
math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
))
end)
_obd:OnUnload(function()
_obq:Disconnect()
_obd.Unloaded = true
end)
_obe:SetLibrary(_obd)
_obf:SetLibrary(_obd)
_obf:IgnoreThemeSettings()
_obf:SetIgnoreIndexes({ "MenuKeybind" })
_obe:SetFolder("ExtraAdvance")
_obf:SetFolder("ExtraAdvance/" .. tostring(game.PlaceId))
_obe:ApplyToTab(_obj["Settings"])
_obf:BuildConfigSection(_obj["Settings"])
_obf:LoadAutoloadConfig()