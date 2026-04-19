-- [[ Universal/Config.lua ]] --

local Config = {}

Config.Fly = {
    Enabled       = false,
    Speed         = 50,
    Keybind       = "F",
}

Config.Noclip = {
    Keybind = "N",
}

Config.Movement = {
    WalkSpeed     = 16,
    JumpPower     = 50,
    TPWalkEnabled = false,
    TPWalkSpeed   = 100,
    InfiniteJumpEnabled = false,
}

Config.Desync = {
    Enabled       = false,
    Keybind       = "U",
}

Config.ESP = {
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

Config.XRay = {
    Enabled       = false,
    Keybind       = "X",
    Transparency  = 0.3,
}

Config.Fullbright = {
    Enabled       = false,
}

Config.FPSBoost = {
    Enabled       = false,
}

Config.Aimbot = {
    Enabled       = false,
    Keybind       = "MB2",
    Mode          = "Hold",
    Method        = "Camera",
    Smoothness    = 12,
    LockPart      = "Head",
    ShotChance    = 100,
    FOVRadius     = 120,
    FOVDistance   = 500,
    MaxTargetDistance = 500,
    ShowFOV       = true,
    TeamCheck     = false,
    InvisibleCheck = false,
    HealthCheck   = true,
    WallCheck     = false,
    FOVOutlineTransparency = 0,
    FOVFillTransparency = 0.5,
    FOVColor      = Color3.fromRGB(255, 255, 255),
}

Config.SilentAimbot = {
    Enabled       = false,
    FOVRadius     = 120,
    FOVDistance   = 500,
    FOVOutlineTransparency = 0,
    FOVFillTransparency = 0.5,
    FOVColor      = Color3.fromRGB(255, 0, 0),
    ShotChance    = 100,
    HeadshotChance = 50,
}

return Config

