local _nahjtxw=math.random()
local _ndcfliq=math.random()
local _nmkxjut=math.random()
local _obb = {}
_obb.Fly = {
Enabled       = false,
Speed         = 50,
Keybind       = "F",
}
_obb.Movement = {
WalkSpeed     = 16,
JumpPower     = 50,
TPWalkEnabled = false,
TPWalkSpeed   = 100,
InfiniteJumpEnabled = false,
}
_obb.Desync = {
Enabled       = false,
Keybind       = "U",
}
_obb.ESP = {
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
_obb.XRay = {
Enabled       = false,
Keybind       = "X",
Transparency  = 0.3,
}
_obb.Fullbright = {
Enabled       = false,
}
_obb.FPSBoost = {
Enabled       = false,
}
_obb.Aimbot = {
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
_obb.SilentAimbot = {
Enabled       = false,
FOVRadius     = 120,
FOVDistance   = 500,
FOVOutlineTransparency = 0,
FOVFillTransparency = 0.5,
FOVColor      = Color3.fromRGB(255, 0, 0),
ShotChance    = 100,
HeadshotChance = 50,
}
return _obb