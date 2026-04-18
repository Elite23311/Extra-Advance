local dziwvcur=math.random()
local qityvvml=math.random()
local bscyciee=math.random()
local _b = _G._b
local _c = _G._c
local _d = require(script.Parent:WaitForChild("_d"))
local _e = require(script.Parent.Callback:WaitForChild("_e"))
local _f = require(script.Parent.Callback:WaitForChild("_f"))
local _g = require(script.Parent.Callback:WaitForChild("_g"))
local _h = require(script.Parent.Callback:WaitForChild("_h"))
local _i = require(script.Parent.Callback:WaitForChild("_i"))
local _j = require(script.Parent.Callback:WaitForChild("_j"))
local _k = require(script.Parent.Callback:WaitForChild("_k"))
local _l = Raknet or raknet
_f:Init()
local _m = _c.Main:AddLeftGroupbox("_e")
_m:AddToggle("UniversalFly", {
Text    = "Enable _e",
Default = false,
Callback = function(value)
_e.Enabled = value
if value then
_e:Start()
_b:Notify("_e enabled!", 2)
else
_e:Stop()
end
end,
})
_m:AddSlider("UniversalFlySpeed", {
Text     = "Speed",
Default  = _d._e.Speed,
Min      = 10,
Max      = 200,
Rounding = 1,
Callback = function(value)
_e:SetSpeed(value)
end,
})
_m:AddLabel("Keybind: F to toggle"):AddKeyPicker("UniversalFlyBind", {
Default = _d._e.Keybind,
NoUI    = true,
})
local _n = _c.Main:AddRightGroupbox("🏃  _f")
_n:AddSlider("UniversalWalkSpeed", {
Text     = "Walk Speed",
Default  = _d._f.WalkSpeed,
Min      = 5,
Max      = 100,
Rounding = 1,
Callback = function(value)
_f:SetWalkSpeed(value)
end,
})
_n:AddSlider("UniversalJumpPower", {
Text     = "Jump Power",
Default  = _d._f.JumpPower,
Min      = 10,
Max      = 150,
Rounding = 1,
Callback = function(value)
_f:SetJumpPower(value)
end,
})
_n:AddToggle("UniversalInfiniteJump", {
Text    = "Infinite Jump",
Default = false,
Callback = function(value)
if value then
_f:EnableInfiniteJump()
else
_f:DisableInfiniteJump()
end
end,
})
_n:AddToggle("UniversalTPWalk", {
Text    = "TP Walk",
Default = false,
Callback = function(value)
if value then
_f:EnableTPWalk()
else
_f:DisableTPWalk()
end
end,
})
_n:AddSlider("UniversalTPWalkSpeed", {
Text     = "TP Walk Speed (studs/s)",
Default  = _d._f.TPWalkSpeed,
Min      = 20,
Max      = 300,
Rounding = 1,
Callback = function(value)
_f.TPWalkSpeed = value
end,
})
local _o = _c.Main:AddLeftGroupbox("_g (Raknet)")
if _l then
_o:AddToggle("UniversalDesync", {
Text    = "Enable _g",
Default = false,
Callback = function(value)
if value then
_g:Start()
else
_g:Stop()
end
end,
})
_o:AddLabel("Keybind: U to toggle"):AddKeyPicker("UniversalDesyncBind", {
Default = _d._g.Keybind,
NoUI    = true,
})
else
_o:AddLabel(getexecutorname() .. "Doesn't support Raknet _b, please try check again.")
end
local _p = _c._i:AddLeftGroupbox("_h")
_p:AddToggle("UniversalESP", {
Text    = "Enable _h",
Default = false,
C" .. "allback = function(v" .. "alue)
_h.Enabled = v" .. "alue
if value then
_" .. "h:Start()
else
_h:St" .. "op()
end
end,
})
_p:" .. "AddToggle("UniversalESPChams", {
Text    = "Chams",
Default = false,
C" .. "allback = function(v" .. "alue)
_h.Options.Cha" .. "ms = value
end,
})
_" .. "p:AddColorPicker("UniversalESPChamsColor", {
Default = _d._h." .. "ChamsColor,
Title   " .. "= "Chams Color",
Callback = functio" .. "n(value)
_h.Options." .. "ChamsColor = value
e" .. "nd,
})
_p:AddToggle("UniversalESPBox", {
Text    = "Box",
Default = false,
C" .. "allback = function(v" .. "alue)
_h.Options.Box" .. " = value
end,
})
_p:" .. "AddColorPicker("UniversalESPBoxColor", {
Default = _d._h." .. "BoxColor,
Title   = "Box Color",
Callback = functio" .. "n(value)
_h.Options." .. "BoxColor = value
end" .. ",
})
_p:AddToggle("UniversalESPHealthBar", {
Text    = "Health Bar",
Default = false,
C" .. "allback = function(v" .. "alue)
_h.Options.Hea" .. "lthBar = value
end,
" .. "})
_p:AddToggle("UniversalESPDistance", {
Text    = "Distance",
Default = false,
C" .. "allback = function(v" .. "alue)
_h.Options.Dis" .. "tance = value
end,
}" .. ")
_p:AddToggle("UniversalESPName", {
Text    = "Name",
Default = false,
C" .. "allback = function(v" .. "alue)
_h.Options.Nam" .. "e = value
end,
})
_p" .. ":AddToggle("UniversalESPSkeleton", {
Text    = "Skeleton",
Default = false,
C" .. "allback = function(v" .. "alue)
_h.Options.Ske" .. "leton = value
end,
}" .. ")
_p:AddDivider()
_p" .. ":AddToggle("UniversalESPTeamCheck", {
Text    = "Team Check",
Default = _d._h.Te" .. "amCheck,
Callback = " .. "function(value)
_h.O" .. "ptions.TeamCheck = v" .. "alue
end,
})
_p:AddT" .. "oggle("UniversalESPInvisibleCheck", {
Text    = "Invisible Check",
Default = _d._h.In" .. "visibleCheck,
Callba" .. "ck = function(value)" .. "
_h.Options.Invisibl" .. "eCheck = value
end,
" .. "})
_p:AddToggle("UniversalESPHealthCheck", {
Text    = "Health Check",
Default = _d._h.He" .. "althCheck,
Callback " .. "= function(value)
_h" .. ".Options.HealthCheck" .. " = value
end,
})
loc" .. "al _q = _c._i:AddRig" .. "htGroupbox("_i")
_q:AddToggle("UniversalFullbright", {
Text    = "Enable Fullbright",
Default = false,
C" .. "allback = function(v" .. "alue)
if value then
" .. "_i:EnableFullbright(" .. ")
else
_i:DisableFul" .. "lbright()
end
end,
}" .. ")
_q:AddToggle("UniversalFPSBoost", {
Text    = "FPS Boost",
Default = false,
C" .. "allback = function(v" .. "alue)
if value then
" .. "_i:EnableFPSBoost()
" .. "else
_i:DisableFPSBo" .. "ost()
end
end,
})
_q" .. ":AddToggle("UniversalXRay", {
Text    = "X-Ray",
Default = false,
C" .. "allback = function(v" .. "alue)
if value then
" .. "_i:EnableXRay()
else" .. "
_i:DisableXRay()
en" .. "d
end,
})
_q:AddSlid" .. "er("UniversalXRayTransparency", {
Text     = "X-Ray Transparency",
Default  = _d.XRay" .. ".Transparency,
Min  " .. "    = 0,
Max      = " .. "1,
Rounding = 2,
Cal" .. "lback = function(val" .. "ue)
_i:SetXRayTransp" .. "arency(value)
end,
}" .. ")
_q:AddLabel("Keybind: X to toggle"):AddKeyPicker("UniversalXRayBind", {
Default = _d.XRa" .. "y.Keybind,
NoUI    =" .. " true,
})
local _r =" .. " _c.Player:AddLeftGr" .. "oupbox("_j")
_r:AddToggle("UniversalAimbot", {
Text    = "Enable _j",
Default = false,
C" .. "allback = function(v" .. "alue)
_j.Enabled = v" .. "alue
if value then
_" .. "j:Start()
else
_j:St" .. "op()
end
end,
})
_r:" .. "AddLabel("Hold Keybind"):AddKeyPicker("UniversalAimbotBind", {
Default = _d._j." .. "Keybind,
NoUI    = t" .. "rue,
})
_r:AddDropdo" .. "wn("UniversalAimbotMethod", {
Values  = { "Camera", "RootPart" },
Default = 1,
Text    = "Method",
Callback = functio" .. "n(value)
_j.Method =" .. " value
end,
})
_r:Ad" .. "dSlider("UniversalAimbotSmoothness", {
Text     = "Smoothness",
Default  = _d._j.S" .. "moothness,
Min      " .. "= 1,
Max      = 50,
" .. "Rounding = 1,
Callba" .. "ck = function(value)" .. "
_j.Smoothness = val" .. "ue
end,
})
_r:AddDro" .. "pdown("UniversalAimbotLockPart", {
Values  = { "Head", "HumanoidRootPart", "Torso" },
Default = 1,
Text    = "Lock Part",
Callback = functio" .. "n(value)
_j.LockPart" .. " = value
end,
})
_r:" .. "AddSlider("UniversalAimbotShotChance", {
Text     = "Shot Chance (%)",
Default  = _d._j.S" .. "hotChance,
Min      " .. "= 0,
Max      = 100," .. "
Rounding = 1,
Callb" .. "ack = function(value" .. ")
_j.ShotChance = va" .. "lue
end,
})
_r:AddDi" .. "vider()
_r:AddLabel("FOV Settings")
_r:AddSlider("UniversalAimbotFOVRadius", {
Text     = "FOV Radius",
Default  = _d._j.F" .. "OVRadius,
Min      =" .. " 20,
Max      = 500," .. "
Rounding = 1,
Callb" .. "ack = function(value" .. ")
_j.FOVRadius = val" .. "ue
if _j.FOVCircle t" .. "hen
_j.FOVCircle.Rad" .. "ius = value
end
end," .. "
})
_r:AddSlider("UniversalAimbotFOVDistance", {
Text     = "FOV Distance",
Default  = _d._j.F" .. "OVDistance,
Min     " .. " = 100,
Max      = 1" .. "000,
Rounding = 10,
" .. "Callback = function(" .. "value)
_j.FOVDistanc" .. "e = value
end,
})
_r" .. ":AddSlider("UniversalAimbotFOVOutlineTransparency", {
Text     = "FOV Outline Transparency",
Default  = _d._j.F" .. "OVOutlineTransparenc" .. "y,
Min      = 0,
Max" .. "      = 1,
Rounding " .. "= 2,
})
_r:AddSlider" .. "("UniversalAimbotFOVFillTransparency", {
Text     = "FOV Fill Transparency",
Default  = _d._j.F" .. "OVFillTransparency,
" .. "Min      = 0,
Max   " .. "   = 1,
Rounding = 2" .. ",
})
_r:AddColorPick" .. "er("UniversalAimbotFOVColor", {
Default = _d._j." .. "FOVColor,
Title   = "FOV Color",
Callback = functio" .. "n(value)
if _j.FOVCi" .. "rcle then
_j.FOVCirc" .. "le.Color = value
end" .. "
end,
})
local _s = " .. "_c.Player:AddRightGr" .. "oupbox("🔇  Silent _j")
_s:AddToggle("UniversalSilentAimbot", {
Text    = "Enable Silent _j",
Default = false,
C" .. "allback = function(v" .. "alue)
_k.Enabled = v" .. "alue
if value then
_" .. "k:Start()
else
_k:St" .. "op()
end
end,
})
_s:" .. "AddSlider("UniversalSilentAimbotShotChance", {
Text     = "Shot Chance (%)",
Default  = _d._k.S" .. "hotChance,
Min      " .. "= 0,
Max      = 100," .. "
Rounding = 1,
Callb" .. "ack = function(value" .. ")
_k.ShotChance = va" .. "lue
end,
})
_s:AddSl" .. "ider("UniversalSilentAimbotHeadshotChance", {
Text     = "Headshot Chance (%)",
Default  = _d._k.H" .. "eadshotChance,
Min  " .. "    = 0,
Max      = " .. "100,
Rounding = 1,
C" .. "allback = function(v" .. "alue)
_k.HeadshotCha" .. "nce = value
end,
})
" .. "_s:AddLabel("FOV Settings")
_s:AddSlider("UniversalSilentAimbotFOVRadius", {
Text     = "FOV Radius",
Default  = _d._k.F" .. "OVRadius,
Min      =" .. " 20,
Max      = 500," .. "
Rounding = 1,
Callb" .. "ack = function(value" .. ")
_k.FOVRadius = val" .. "ue
end,
})
_s:AddSli" .. "der("UniversalSilentAimbotFOVDistance", {
Text     = "FOV Distance",
Default  = _d._k.F" .. "OVDistance,
Min     " .. " = 100,
Max      = 1" .. "000,
Rounding = 10,
" .. "Callback = function(" .. "value)
_k.FOVDistanc" .. "e = value
end,
})
_s" .. ":AddSlider("UniversalSilentAimbotFOVOutlineTransparency", {
Text     = "FOV Outline Transparency",
Default  = _d._k.F" .. "OVOutlineTransparenc" .. "y,
Min      = 0,
Max" .. "      = 1,
Rounding " .. "= 2,
})
_s:AddSlider" .. "("UniversalSilentAimbotFOVFillTransparency", {
Text     = "FOV Fill Transparency",
Default  = _d._k.F" .. "OVFillTransparency,
" .. "Min      = 0,
Max   " .. "   = 1,
Rounding = 2" .. ",
})
_s:AddColorPick" .. "er("UniversalSilentAimbotFOVColor", {
Default = _d._k." .. "FOVColor,
Title   = "FOV Color",
})
_b:Notify("Universal hacks loaded!", 3)