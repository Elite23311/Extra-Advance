local _nlprzhq=math.random()
local _nzllbad=math.random()
local _nhvhgqf=math.random()
local _obb = _G._obb
local _obc = _G._obc
local _obd = require(script.Parent:WaitForChild("Config"))
local _obe = require(script.Parent.Callback:WaitForChild("Fly"))
local _obf = require(script.Parent.Callback:WaitForChild("Movement"))
local _obg = require(script.Parent.Callback:WaitForChild("Desync"))
local _obh = require(script.Parent.Callback:WaitForChild("ESP"))
local _obi = require(script.Parent.Callback:WaitForChild("Visual"))
local _obj = require(script.Parent.Callback:WaitForChild("Aimbot"))
local _obk = require(script.Parent.Callback:WaitForChild("SilentAimbot"))
local _obl = Raknet or raknet
_obf:Init()
local _obm = _obc.Main:AddLeftGroupbox("Fly")
_obm:AddToggle("UniversalFly", {
Text    = "Enable Fly",
Default = false,
Callback = function(value)
_obe.Enabled = value
if value then
_obe:Start()
_obb:Notify("Fly enabled!", 2)
else
_obe:Stop()
end
end,
})
_obm:AddSlider("UniversalFlySpeed", {
Text     = "Speed",
Default  = _obd._obe.Speed,
Min      = 10,
Max      = 200,
Rounding = 1,
Callback = function(value)
_obe:SetSpeed(value)
end,
})
_obm:AddLabel("Keybind: F to toggle"):AddKeyPicker("UniversalFlyBind", {
Default = _obd._obe.Keybind,
NoUI    = true,
})
local _obn = _obc.Main:AddRightGroupbox("🏃  Movement")
_obn:AddSlider("UniversalWalkSpeed", {
Text     = "Walk Speed",
Default  = _obd._obf.WalkSpeed,
Min      = 5,
Max      = 100,
Rounding = 1,
Callback = function(value)
_obf:SetWalkSpeed(value)
end,
})
_obn:AddSlider("UniversalJumpPower", {
Text     = "Jump Power",
Default  = _obd._obf.JumpPower,
Min      = 10,
Max      = 150,
Rounding = 1,
Callback = function(value)
_obf:SetJumpPower(value)
end,
})
_obn:AddToggle("UniversalInfiniteJump", {
Text    = "Infinite Jump",
Default = false,
Callback = function(value)
if value then
_obf:EnableInfiniteJump()
else
_obf:DisableInfiniteJump()
end
end,
})
_obn:AddToggle("UniversalTPWalk", {
Text    = "TP Walk",
Default = false,
Callback = function(value)
if value then
_obf:EnableTPWalk()
else
_obf:DisableTPWalk()
end
end,
})
_obn:AddSlider("UniversalTPWalkSpeed", {
Text     = "TP Walk Speed (studs/s)",
Default  = _obd._obf.TPWalkSpeed,
Min      = 20,
Max      = 300,
Rounding = 1,
Callback = function(value)
_obf.TPWalkSpeed = value
end,
})
local _obo = _obc.Main:AddLeftGroupbox("Desync (Raknet)")
if _obl then
_obo:AddToggle("UniversalDesync", {
Text    = "Enable Desync",
Default = false,
Callback = function(value)
if value then
_obg:Start()
else
_obg:Stop()
end
end,
})
_obo:AddLabel("Keybind: U to toggle"):AddKeyPicker("UniversalDesyncBind", {
Default = _obd._obg.Keybind,
NoUI    = true,
})
else
_obo:AddLabel(getexecutorname() .. "Doesn't support Raknet Library, please try check again.")
end
local _obp = _obc._obi:AddLeftGroupbox("ESP")
_obp:AddToggle("UniversalESP", {
Text    = "Enable ESP",
Default = false,
Callback = function(value)
_obh.Enabled = value
if value then
_obh:Start()
else
_obh:Stop()
end
end,
})
_obp:AddToggle("UniversalESPChams", {
Text    = "Chams",
Default = false,
Callback = function(value)
_obh.Options.Chams = value
end,
})
_obp:AddColorPicker("UniversalESPChamsColor", {
Default = _obd._obh.ChamsColor,
Title   = "Chams Color",
Callback = function(value)
_obh.Options.ChamsColor = value
end,
})
_obp:AddToggle("UniversalESPBox", {
Text    = "Box",
Default = false,
Callback = function(value)
_obh.Options.Box = value
end,
})
_obp:AddColorPicker("UniversalESPBoxColor", {
Default = _obd._obh.BoxColor,
Title   = "Box Color",
Callback = function(value)
_obh.Options.BoxColor = value
end,
})
_obp:AddToggle("UniversalESPHealthBar", {
Text    = "Health Bar",
Default = false,
Callback = function(value)
_obh.Options.HealthBar = value
end,
})
_obp:AddToggle("UniversalESPDistance", {
Text    = "Distance",
Default = false,
Callback = function(value)
_obh.Options.Distance = value
end,
})
_obp:AddToggle("UniversalESPName", {
Text    = "Name",
Default = false,
Callback = function(value)
_obh.Options.Name = value
end,
})
_obp:AddToggle("UniversalESPSkeleton", {
Text    = "Skeleton",
Default = false,
Callback = function(value)
_obh.Options.Skeleton = value
end,
})
_obp:AddDivider()
_obp:AddToggle("UniversalESPTeamCheck", {
Text    = "Team Check",
Default = _obd._obh.TeamCheck,
Callback = function(value)
_obh.Options.TeamCheck = value
end,
})
_obp:AddToggle("UniversalESPInvisibleCheck", {
Text    = "Invisible Check",
Default = _obd._obh.InvisibleCheck,
Callback = function(value)
_obh.Options.InvisibleCheck = value
end,
})
_obp:AddToggle("UniversalESPHealthCheck", {
Text    = "Health Check",
Default = _obd._obh.HealthCheck,
Callback = function(value)
_obh.Options.HealthCheck = value
end,
})
local _obq = _obc._obi:AddRightGroupbox("Visual")
_obq:AddToggle("UniversalFullbright", {
Text    = "Enable Fullbright",
Default = false,
Callback = function(value)
if value then
_obi:EnableFullbright()
else
_obi:DisableFullbright()
end
end,
})
_obq:AddToggle("UniversalFPSBoost", {
Text    = "FPS Boost",
Default = false,
Callback = function(value)
if value then
_obi:EnableFPSBoost()
else
_obi:DisableFPSBoost()
end
end,
})
_obq:AddToggle("UniversalXRay", {
Text    = "X-Ray",
Default = false,
Callback = function(value)
if value then
_obi:EnableXRay()
else
_obi:DisableXRay()
end
end,
})
_obq:AddSlider("UniversalXRayTransparency", {
Text     = "X-Ray Transparency",
Default  = _obd.XRay.Transparency,
Min      = 0,
Max      = 1,
Rounding = 2,
Callback = function(value)
_obi:SetXRayTransparency(value)
end,
})
_obq:AddLabel("Keybind: X to toggle"):AddKeyPicker("UniversalXRayBind", {
Default = _obd.XRay.Keybind,
NoUI    = true,
})
local _obr = _obc.Player:AddLeftGroupbox("Aimbot")
_obr:AddToggle("UniversalAimbot", {
Text    = "Enable Aimbot",
Default = false,
Callback = function(value)
_obj.Enabled = value
if value then
_obj:Start()
else
_obj:Stop()
end
end,
})
_obr:AddLabel("Hold Keybind"):AddKeyPicker("UniversalAimbotBind", {
Default = _obd._obj.Keybind,
NoUI    = true,
})
_obr:AddDropdown("UniversalAimbotMethod", {
Values  = { "Camera", "RootPart" },
Default = 1,
Text    = "Method",
Callback = function(value)
_obj.Method = value
end,
})
_obr:AddSlider("UniversalAimbotSmoothness", {
Text     = "Smoothness",
Default  = _obd._obj.Smoothness,
Min      = 1,
Max      = 50,
Rounding = 1,
Callback = function(value)
_obj.Smoothness = value
end,
})
_obr:AddDropdown("UniversalAimbotLockPart", {
Values  = { "Head", "HumanoidRootPart", "Torso" },
Default = 1,
Text    = "Lock Part",
Callback = function(value)
_obj.LockPart = value
end,
})
_obr:AddSlider("UniversalAimbotShotChance", {
Text     = "Shot Chance (%)",
Default  = _obd._obj.ShotChance,
Min      = 0,
Max      = 100,
Rounding = 1,
Callback = function(value)
_obj.ShotChance = value
end,
})
_obr:AddDivider()
_obr:AddLabel("FOV Settings")
_obr:AddSlider("UniversalAimbotFOVRadius", {
Text     = "FOV Radius",
Default  = _obd._obj.FOVRadius,
Min      = 20,
Max      = 500,
Rounding = 1,
Callback = function(value)
_obj.FOVRadius = value
if _obj.FOVCircle then
_obj.FOVCircle.Radius = value
end
end,
})
_obr:AddSlider("UniversalAimbotFOVDistance", {
Text     = "FOV Distance",
Default  = _obd._obj.FOVDistance,
Min      = 100,
Max      = 1000,
Rounding = 10,
Callback = function(value)
_obj.FOVDistance = value
end,
})
_obr:AddSlider("UniversalAimbotFOVOutlineTransparency", {
Text     = "FOV Outline Transparency",
Default  = _obd._obj.FOVOutlineTransparency,
Min      = 0,
Max      = 1,
Rounding = 2,
})
_obr:AddSlider("UniversalAimbotFOVFillTransparency", {
Text     = "FOV Fill Transparency",
Default  = _obd._obj.FOVFillTransparency,
Min      = 0,
Max      = 1,
Rounding = 2,
})
_obr:AddColorPicker("UniversalAimbotFOVColor", {
Default = _obd._obj.FOVColor,
Title   = "FOV Color",
Callback = function(value)
if _obj.FOVCircle then
_obj.FOVCircle.Color = value
end
end,
})
local _obs = _obc.Player:AddRightGroupbox("🔇  Silent Aimbot")
_obs:AddToggle("UniversalSilentAimbot", {
Text    = "Enable Silent Aimbot",
Default = false,
Callback = function(value)
_obk.Enabled = value
if value then
_obk:Start()
else
_obk:Stop()
end
end,
})
_obs:AddSlider("UniversalSilentAimbotShotChance", {
Text     = "Shot Chance (%)",
Default  = _obd._obk.ShotChance,
Min      = 0,
Max      = 100,
Rounding = 1,
Callback = function(value)
_obk.ShotChance = value
end,
})
_obs:AddSlider("UniversalSilentAimbotHeadshotChance", {
Text     = "Headshot Chance (%)",
Default  = _obd._obk.HeadshotChance,
Min      = 0,
Max      = 100,
Rounding = 1,
Callback = function(value)
_obk.HeadshotChance = value
end,
})
_obs:AddLabel("FOV Settings")
_obs:AddSlider("UniversalSilentAimbotFOVRadius", {
Text     = "FOV Radius",
Default  = _obd._obk.FOVRadius,
Min      = 20,
Max      = 500,
Rounding = 1,
Callback = function(value)
_obk.FOVRadius = value
end,
})
_obs:AddSlider("UniversalSilentAimbotFOVDistance", {
Text     = "FOV Distance",
Default  = _obd._obk.FOVDistance,
Min      = 100,
Max      = 1000,
Rounding = 10,
Callback = function(value)
_obk.FOVDistance = value
end,
})
_obs:AddSlider("UniversalSilentAimbotFOVOutlineTransparency", {
Text     = "FOV Outline Transparency",
Default  = _obd._obk.FOVOutlineTransparency,
Min      = 0,
Max      = 1,
Rounding = 2,
})
_obs:AddSlider("UniversalSilentAimbotFOVFillTransparency", {
Text     = "FOV Fill Transparency",
Default  = _obd._obk.FOVFillTransparency,
Min      = 0,
Max      = 1,
Rounding = 2,
})
_obs:AddColorPicker("UniversalSilentAimbotFOVColor", {
Default = _obd._obk.FOVColor,
Title   = "FOV Color",
})
_obb:Notify("Universal hacks loaded!", 3)