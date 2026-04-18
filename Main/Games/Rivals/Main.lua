local _nptrkoe=math.random()
local _nqckgdt=math.random()
local _nytxkfh=math.random()
local _obb = _G._obb
local _obc = _G._obc
local _obd = _G._obd
local _obe = require(script.Parent:WaitForChild("Callback"):WaitForChild("AimAssist"))
local _obf = _obd.Main:AddLeftGroupbox("Rivals - Aim Assist")
_obf:AddToggle("RivalsAim", {
Text    = "Enable Aim Assist",
Default = false,
Callback = function(value)
_obe:SetConfig("Enabled", value)
if value then
_obe:Start()
_obc:Notify("Aim Assist started!", 2)
else
_obe:Stop()
_obc:Notify("Aim Assist stopped!", 2)
end
end,
})
_obf:AddToggle("RivalsAimFOV", {
Text    = "Show FOV",
Default = _obe.Config.ShowFOV,
Callback = function(value)
_obe:SetConfig("ShowFOV", value)
end,
})
_obf:AddSlider("RivalsAimFOVRadius", {
Text     = "FOV Radius",
Default  = _obe.Config.FOV,
Min      = 20,
Max      = 500,
Rounding = 0,
Callback = function(value)
_obe:SetConfig("FOV", value)
end,
})
_obf:AddSlider("RivalsAimSmooth", {
Text     = "Smoothness",
Default  = _obe.Config.Smoothness,
Min      = 1,
Max      = 100,
Rounding = 0,
Callback = function(value)
_obe:SetConfig("Smoothness", value)
end,
})
_obf:AddDropdown("RivalsAimPart", {
Values  = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso" },
Default = 1,
Text    = "Target Part",
Callback = function(value)
_obe:SetConfig("TargetPart", value)
end,
})
_obc:Notify("Rivals game loaded!", 3)