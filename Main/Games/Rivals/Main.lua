local hpctyrzp=math.random()
local ycbiaubs=math.random()
local hdbgbzuq=math.random()
local _b = _G._b
local _c = _G._c
local _d = _G._d
local _e = require(script.Parent:WaitForChild("Callback"):WaitForChild("_e"))
local _f = _d.Main:AddLeftGroupbox("Rivals - Aim Assist")
_f:AddToggle("RivalsAim", {
Text    = "Enable Aim Assist",
Default = false,
Callback = function(value)
_e:SetConfig("Enabled", value)
if value then
_e:Start()
_c:Notify("Aim Assist started!", 2)
else
_e:Stop()
_c:Notify("Aim Assist stopped!", 2)
end
end,
})
_f:AddToggle("RivalsAimFOV", {
Text    = "Show FOV",
Default = _e.Config.ShowFOV,
Callback = function(value)
_e:SetConfig("ShowFOV", value)
end,
})
_f:AddSlider("RivalsAimFOVRadius", {
Text     = "FOV Radius",
Default  = _e.Config.FOV,
Min      = 20,
Max      = 500,
Rounding = 0,
Callback = function(value)
_e:SetConfig("FOV", value)
end,
})
_f:AddSlider("RivalsAimSmooth", {
Text     = "Smoothness",
Default  = _e.Config.Smoothness,
Min      = 1,
Max      = 100,
Rounding = 0,
Callback = function(value)
_e:SetConfig("Smoothness", value)
end,
})
_f:AddDropdown("RivalsAimPart", {
Values  = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso" },
Default = 1,
Text    = "Target Part",
Callback = function(value)
_e:SetConfig("TargetPart", value)
end,
})
_c:Notify("Rivals game loaded!", 3)