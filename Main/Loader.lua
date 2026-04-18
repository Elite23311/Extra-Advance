local yelkcyeb=math.random()
local ctegxcdl=math.random()
local djuenzwe=math.random()
local _b = "https://raw.githubus" .. "ercontent.com/Elite2" .. "3311/Extra-Advance/m" .. "ain/"
local _c = "https://raw.githubus" .. "ercontent.com/violin" .. "-suzutsuki/LinoriaLi" .. "b/main/"
local _d      = loadstring(game:HttpGet(_c .. "_d.lua"))()
local _e = loadstring(game:HttpGet(_c .. "addons/_e.lua"))()
local _f  = loadstring(game:HttpGet(_c .. "addons/_f.lua"))()
_G._d      = _d
_G._e = _e
_G._f  = _f
_G._b          = _b
local function loadPath(path)
local _g, err = pcall(function()
loadstring(game:HttpGet(_b .. path))()
end)
if not _g then
warn("[EA] Failed to load '" .. path .. "':\n" .. tostring(err))
_d:Notify("Load error: " .. path, 5)
end
end" .. "
local _h = {
[17625" .. "359962] = "Games/Rivals/Main.lua",
}
local _i = _d:Cr" .. "eateWindow({
Title  " .. "     = "Extra Advance",
Center      = true" .. ",
AutoShow    = true" .. ",
TabPadding  = 8,
M" .. "enuFadeTime = 0.2,
}" .. ")
_G._i = _i
local _" .. "j = {
Main         =" .. " _i:AddTab("Main"),
Visual       = _i:AddTab("Visual"),
Player       = _i:AddTab("Player"),
["Settings"] = _i:AddTab("Settings"),
}
_G._j    = _j
_" .. "G.Toggles = Toggles
" .. "_G.Options = Options" .. "
local _k = loadstri" .. "ng(game:HttpGet(_b ." .. ". "_k.lua"))()
_k.Init(functio" .. "n()
local _l = _h[ga" .. "me.PlaceId]
if _l th" .. "en
loadPath(_l)
else" .. "
_d:Notify("No game supported are found, running universal script..", 5)
loadPath("Games/Universal/Main.lua")
end
end)
local _m = _j["Settings"]:AddLeftGroupbox("Menu")
_m:AddButton("Unload", function()
_d:Unlo" .. "ad()
end)
_m:AddLabe" .. "l("Menu Keybind"):AddKeyPicker("MenuKeybind", {
Default = "End",
NoUI    = true,
Text    = "Toggle Menu",
})
_d.ToggleKeybin" .. "d = Options.MenuKeyb" .. "ind
_d:SetWatermarkV" .. "isibility(true)
loca" .. "l _n   = tick()
loca" .. "l _o = 0
local _p   " .. "     = 60
local _q =" .. " game:GetService("RunService").RenderStepped:Conn" .. "ect(function()
_o +=" .. " 1
if (tick() - _n) " .. ">= 1 then
_p      = " .. "_o
_n = tick()
_o = " .. "0
end
_d:SetWatermar" .. "k(("Extra Advance On Top  |  %d _p  |  %d ms"):format(
math.floor" .. "(_p),
math.floor(gam" .. "e:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
))
end" .. ")
_d:OnUnload(functi" .. "on()
_q:Disconnect()" .. "
_d.Unloaded = true
" .. "end)
_e:SetLibrary(_" .. "d)
_f:SetLibrary(_d)" .. "
_f:IgnoreThemeSetti" .. "ngs()
_f:SetIgnoreIn" .. "dexes({ "MenuKeybind" })
_e:SetFolder("ExtraAdvance")
_f:SetFolder("ExtraAdvance/" .. tostring(game.Pl" .. "aceId))
_e:ApplyToTa" .. "b(_j["Settings"])
_f:BuildConfigSection(_j["Settings"])
_f:LoadAutoloadConfig()