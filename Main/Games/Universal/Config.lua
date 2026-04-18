local btgtsygl=math.random()
local auwkbocq=math.random()
local supvdlot=math.random()
local _b = {}
_b.Fly = {
Enabled       = false,
Speed         = 50,
Keybind       = "F",
}
_b.Movement = {
WalkSpeed     = 16,
JumpPower     = 50,
TPWalkEnabled = false,
TPWalkSpeed   = 100,
InfiniteJumpEnabled = false,
}
_b.Desync = {
Enabled       = false,
Keybind       = "U",
}
_b.ESP = {
Enabled       = false,
Keybind       = "E",
Chams         = false,
ChamsColor    = Color3.fromRGB(0, 255, 0),
Box           = false,
BoxColor      = Color3.fromRGB(0, 255, 0),
HealthBar     = false,
Distance      = false,
Name          = false,
Skeleton      = false,
TeamCheck     = true,
InvisibleCheck = true,
HealthCheck   = true,
}
_b.XRay = {
Enabled       = false,
Keybind       = "X",
Transparency  = 0.3,
}
_b.Fullbright = {
Enabled       = false,
}
_b.FPSBoost = {
Enabled       = false,
}
_b.Aimbot = {
Enabled       = false,
Keybind       = "MB2",
Mode          = "Hold",
Method        = "Camera",
Smoothness    = 12,
LockPart      = "Head",
ShotChance    = 100,
FOVRadius     = 120,
FOVDistance   = 500,
FOVOutlineTransparency = 0,
FOVFillTransparency = 0.5,
FOVColor      = Color3.fromRGB(255, 255, 255),
}
_b.SilentAimbot = {
Enabled       = false,
FOVRadius     = 120,
FOVDistance   = 500,
FOVOutlineTransparency = 0,
FOVFillTransparency = 0.5,
FOVColor      = Color3.fromRGB(255, 0, 0),
ShotChance    = 100,
HeadshotChance = 50,
}
return _b