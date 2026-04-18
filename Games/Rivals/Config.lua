-- ╔══════════════════════════════════════════╗
-- ║      Games/Rivals/Config.lua             ║
-- ║  Game-specific configuration              ║
-- ╚══════════════════════════════════════════╝

local Config = {}

Config.AimAssist = {
    Enabled       = false,
    FOV           = 120,
    Smoothness    = 12,
    TargetPart    = "Head",
    OnlyWhileClicking = true,
    VisibleOnly   = true,
    ShowFOV       = true,
    FOVColor      = Color3.fromRGB(255, 255, 255),
    Keybind       = "MB2",
}

return Config
