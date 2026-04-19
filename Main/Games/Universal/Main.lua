-- [[ Games/Universal/Main.lua ]] --

local Library = getgenv().Library
local Window  = getgenv().Window
local RAW     = getgenv().RAW

local function requireModule(path)
    local content = game:HttpGet(getgenv().RAW .. path)
    if content:sub(1, 1) == "<" or #content < 10 then
        warn("[Extra Advance] 404: " .. path)
        return nil
    end
    local fn, err = loadstring(content, path)
    if not fn then
        warn("[Extra Advance] Compile error: " .. path .. " >> " .. tostring(err))
        return nil
    end
    setfenv(fn, getfenv())
    return fn()
end

local Fly          = requireModule("Games/Universal/Callback/Fly.lua")
local Movement     = requireModule("Games/Universal/Callback/Movement.lua")
local Desync       = requireModule("Games/Universal/Callback/Desync.lua")
local ESP          = requireModule("Games/Universal/Callback/ESP.lua")
local Visual       = requireModule("Games/Universal/Callback/Visual.lua")
local Aimbot       = requireModule("Games/Universal/Callback/Aimbot.lua")
local SilentAimbot = requireModule("Games/Universal/Callback/SilentAimbot.lua")
local Config       = requireModule("Games/Universal/Config.lua")

local IsRaknetSupported = (pcall(function() return Raknet or raknet end)) and (Raknet or raknet) or false

Movement:Init()

-- ──────────────────────────────────────────
-- Tabs
-- ──────────────────────────────────────────

local Tabs = {
    Main   = Window:AddTab("Main"),
    Visual = Window:AddTab("Visual"),
    Player = Window:AddTab("Player"),
}

getgenv().Tabs = Tabs

-- ──────────────────────────────────────────
-- MAIN TAB
-- ──────────────────────────────────────────

local MainBox = Tabs.Main:AddLeftGroupbox("Fly")

MainBox:AddToggle("UniversalFly", {
    Text    = "Enable Fly",
    Default = false,
    Callback = function(value)
        Fly.Enabled = value
        if value then
            Fly:Start()
            Library:Notify("Fly enabled!", 2)
        else
            Fly:Stop()
        end
    end,
}):AddKeyPicker("UniversalFlyBind", {
    Default = Config.Fly.Keybind,
    Text    = "Fly",
    Mode    = "Toggle",
})

MainBox:AddSlider("UniversalFlySpeed", {
    Text     = "Speed",
    Default  = Config.Fly.Speed,
    Min      = 10,
    Max      = 200,
    Rounding = 1,
    Callback = function(value)
        Fly:SetSpeed(value)
    end,
})

local MovementBox = Tabs.Main:AddRightGroupbox("Movement")

MovementBox:AddSlider("UniversalWalkSpeed", {
    Text     = "Walk Speed",
    Default  = Config.Movement.WalkSpeed,
    Min      = 5,
    Max      = 100,
    Rounding = 1,
    Callback = function(value)
        Movement:SetWalkSpeed(value)
    end,
})

MovementBox:AddSlider("UniversalJumpPower", {
    Text     = "Jump Power",
    Default  = Config.Movement.JumpPower,
    Min      = 10,
    Max      = 150,
    Rounding = 1,
    Callback = function(value)
        Movement:SetJumpPower(value)
    end,
})

MovementBox:AddToggle("UniversalInfiniteJump", {
    Text    = "Infinite Jump",
    Default = false,
    Callback = function(value)
        if value then
            Movement:EnableInfiniteJump()
        else
            Movement:DisableInfiniteJump()
        end
    end,
})

MovementBox:AddToggle("UniversalTPWalk", {
    Text    = "TP Walk",
    Default = false,
    Callback = function(value)
        if value then
            Movement:EnableTPWalk()
        else
            Movement:DisableTPWalk()
        end
    end,
})

MovementBox:AddSlider("UniversalTPWalkSpeed", {
    Text     = "TP Walk Speed (studs/s)",
    Default  = Config.Movement.TPWalkSpeed,
    Min      = 20,
    Max      = 300,
    Rounding = 1,
    Callback = function(value)
        Movement.TPWalkSpeed = value
    end,
})

local DesyncBox = Tabs.Main:AddLeftGroupbox("Desync (Raknet)")

if IsRaknetSupported then
    DesyncBox:AddToggle("UniversalDesync", {
        Text    = "Enable Desync",
        Default = false,
        Callback = function(value)
            if value then
                Desync:Start()
            else
                Desync:Stop()
            end
        end,
    }):AddKeyPicker("UniversalDesyncBind", {
        Default = Config.Desync.Keybind,
        Text    = "Desync",
        Mode    = "Toggle",
    })
else
    DesyncBox:AddLabel(getexecutorname() .. " doesn't support Raknet.")
end

-- ──────────────────────────────────────────
-- VISUAL TAB
-- ──────────────────────────────────────────

local ESPBox = Tabs.Visual:AddLeftGroupbox("ESP")

ESPBox:AddToggle("UniversalESP", {
    Text    = "Enable ESP",
    Default = false,
    Callback = function(value)
        ESP.Enabled = value
        if value then ESP:Start() else ESP:Stop() end
    end,
})

ESPBox:AddToggle("UniversalESPChams", {
    Text    = "Chams",
    Default = false,
    Callback = function(value)
        ESP.Options.Chams = value
    end,
})

ESPBox:AddLabel("Chams Color"):AddColorPicker("UniversalESPChamsColor", {
    Default  = Config.ESP.ChamsColor,
    Callback = function(value)
        ESP.Options.ChamsColor = value
    end,
})

ESPBox:AddToggle("UniversalESPBox", {
    Text    = "Box",
    Default = false,
    Callback = function(value)
        ESP.Options.Box = value
    end,
})

ESPBox:AddLabel("Box Color"):AddColorPicker("UniversalESPBoxColor", {
    Default  = Config.ESP.BoxColor,
    Callback = function(value)
        ESP.Options.BoxColor = value
    end,
})

ESPBox:AddToggle("UniversalESPHealthBar", {
    Text    = "Health Bar",
    Default = false,
    Callback = function(value)
        ESP.Options.HealthBar = value
    end,
})

ESPBox:AddToggle("UniversalESPDistance", {
    Text    = "Distance",
    Default = false,
    Callback = function(value)
        ESP.Options.Distance = value
    end,
})

ESPBox:AddToggle("UniversalESPName", {
    Text    = "Name",
    Default = false,
    Callback = function(value)
        ESP.Options.Name = value
    end,
})

ESPBox:AddToggle("UniversalESPSkeleton", {
    Text    = "Skeleton",
    Default = false,
    Callback = function(value)
        ESP.Options.Skeleton = value
    end,
})

ESPBox:AddDivider()

ESPBox:AddToggle("UniversalESPTeamCheck", {
    Text    = "Team Check",
    Default = Config.ESP.TeamCheck,
    Callback = function(value)
        ESP.Options.TeamCheck = value
    end,
})

ESPBox:AddToggle("UniversalESPInvisibleCheck", {
    Text    = "Invisible Check",
    Default = Config.ESP.InvisibleCheck,
    Callback = function(value)
        ESP.Options.InvisibleCheck = value
    end,
})

ESPBox:AddToggle("UniversalESPHealthCheck", {
    Text    = "Health Check",
    Default = Config.ESP.HealthCheck,
    Callback = function(value)
        ESP.Options.HealthCheck = value
    end,
})

local VisualBox = Tabs.Visual:AddRightGroupbox("Visual")

VisualBox:AddToggle("UniversalFullbright", {
    Text    = "Enable Fullbright",
    Default = false,
    Callback = function(value)
        if value then Visual:EnableFullbright() else Visual:DisableFullbright() end
    end,
})

VisualBox:AddToggle("UniversalFPSBoost", {
    Text    = "FPS Boost",
    Default = false,
    Callback = function(value)
        if value then Visual:EnableFPSBoost() else Visual:DisableFPSBoost() end
    end,
})

VisualBox:AddToggle("UniversalXRay", {
    Text    = "X-Ray",
    Default = false,
    Callback = function(value)
        if value then Visual:EnableXRay() else Visual:DisableXRay() end
    end,
}):AddKeyPicker("UniversalXRayBind", {
    Default = Config.XRay.Keybind,
    Text    = "X-Ray",
    Mode    = "Toggle",
})

VisualBox:AddSlider("UniversalXRayTransparency", {
    Text     = "X-Ray Transparency",
    Default  = Config.XRay.Transparency,
    Min      = 0,
    Max      = 1,
    Rounding = 2,
    Callback = function(value)
        Visual:SetXRayTransparency(value)
    end,
})

-- ──────────────────────────────────────────
-- PLAYER TAB
-- ──────────────────────────────────────────

local AimbotBox = Tabs.Player:AddLeftGroupbox("Aimbot")

AimbotBox:AddToggle("UniversalAimbot", {
    Text    = "Enable Aimbot",
    Default = false,
    Callback = function(value)
        Aimbot.Enabled = value
        if value then Aimbot:Start() else Aimbot:Stop() end
    end,
}):AddKeyPicker("UniversalAimbotBind", {
    Default = Config.Aimbot.Keybind,
    Text    = "Aimbot",
    Mode    = "Hold",
})

AimbotBox:AddDropdown("UniversalAimbotMethod", {
    Values  = { "Camera", "RootPart" },
    Default = 1,
    Text    = "Method",
    Callback = function(value)
        Aimbot.Method = value
    end,
})

AimbotBox:AddSlider("UniversalAimbotSmoothness", {
    Text     = "Smoothness",
    Default  = Config.Aimbot.Smoothness,
    Min      = 1,
    Max      = 50,
    Rounding = 1,
    Callback = function(value)
        Aimbot.Smoothness = value
    end,
})

AimbotBox:AddDropdown("UniversalAimbotLockPart", {
    Values  = { "Head", "HumanoidRootPart", "Torso" },
    Default = 1,
    Text    = "Lock Part",
    Callback = function(value)
        Aimbot.LockPart = value
    end,
})

AimbotBox:AddSlider("UniversalAimbotShotChance", {
    Text     = "Shot Chance (%)",
    Default  = Config.Aimbot.ShotChance,
    Min      = 0,
    Max      = 100,
    Rounding = 1,
    Callback = function(value)
        Aimbot.ShotChance = value
    end,
})

AimbotBox:AddDivider()
AimbotBox:AddLabel("FOV Settings")

AimbotBox:AddSlider("UniversalAimbotFOVRadius", {
    Text     = "FOV Radius",
    Default  = Config.Aimbot.FOVRadius,
    Min      = 20,
    Max      = 500,
    Rounding = 1,
    Callback = function(value)
        Aimbot.FOVRadius = value
        if Aimbot.FOVCircle then Aimbot.FOVCircle.Radius = value end
    end,
})

AimbotBox:AddSlider("UniversalAimbotFOVDistance", {
    Text     = "FOV Distance",
    Default  = Config.Aimbot.FOVDistance,
    Min      = 100,
    Max      = 1000,
    Rounding = 10,
    Callback = function(value)
        Aimbot.FOVDistance = value
    end,
})

AimbotBox:AddSlider("UniversalAimbotFOVOutlineTransparency", {
    Text     = "FOV Outline Transparency",
    Default  = Config.Aimbot.FOVOutlineTransparency,
    Min      = 0,
    Max      = 1,
    Rounding = 2,
})

AimbotBox:AddSlider("UniversalAimbotFOVFillTransparency", {
    Text     = "FOV Fill Transparency",
    Default  = Config.Aimbot.FOVFillTransparency,
    Min      = 0,
    Max      = 1,
    Rounding = 2,
})

AimbotBox:AddLabel("FOV Color"):AddColorPicker("UniversalAimbotFOVColor", {
    Default  = Config.Aimbot.FOVColor,
    Callback = function(value)
        if Aimbot.FOVCircle then Aimbot.FOVCircle.Color = value end
    end,
})

local SilentAimbotBox = Tabs.Player:AddRightGroupbox("Silent Aimbot")

SilentAimbotBox:AddToggle("UniversalSilentAimbot", {
    Text    = "Enable Silent Aimbot",
    Default = false,
    Callback = function(value)
        SilentAimbot.Enabled = value
        if value then SilentAimbot:Start() else SilentAimbot:Stop() end
    end,
})

SilentAimbotBox:AddSlider("UniversalSilentAimbotShotChance", {
    Text     = "Shot Chance (%)",
    Default  = Config.SilentAimbot.ShotChance,
    Min      = 0,
    Max      = 100,
    Rounding = 1,
    Callback = function(value)
        SilentAimbot.ShotChance = value
    end,
})

SilentAimbotBox:AddSlider("UniversalSilentAimbotHeadshotChance", {
    Text     = "Headshot Chance (%)",
    Default  = Config.SilentAimbot.HeadshotChance,
    Min      = 0,
    Max      = 100,
    Rounding = 1,
    Callback = function(value)
        SilentAimbot.HeadshotChance = value
    end,
})

SilentAimbotBox:AddLabel("FOV Settings")

SilentAimbotBox:AddSlider("UniversalSilentAimbotFOVRadius", {
    Text     = "FOV Radius",
    Default  = Config.SilentAimbot.FOVRadius,
    Min      = 20,
    Max      = 500,
    Rounding = 1,
    Callback = function(value)
        SilentAimbot.FOVRadius = value
    end,
})

SilentAimbotBox:AddSlider("UniversalSilentAimbotFOVDistance", {
    Text     = "FOV Distance",
    Default  = Config.SilentAimbot.FOVDistance,
    Min      = 100,
    Max      = 1000,
    Rounding = 10,
    Callback = function(value)
        SilentAimbot.FOVDistance = value
    end,
})

SilentAimbotBox:AddSlider("UniversalSilentAimbotFOVOutlineTransparency", {
    Text     = "FOV Outline Transparency",
    Default  = Config.SilentAimbot.FOVOutlineTransparency,
    Min      = 0,
    Max      = 1,
    Rounding = 2,
})

SilentAimbotBox:AddSlider("UniversalSilentAimbotFOVFillTransparency", {
    Text     = "FOV Fill Transparency",
    Default  = Config.SilentAimbot.FOVFillTransparency,
    Min      = 0,
    Max      = 1,
    Rounding = 2,
})

SilentAimbotBox:AddLabel("FOV Color"):AddColorPicker("UniversalSilentAimbotFOVColor", {
    Default = Config.SilentAimbot.FOVColor,
})

-- ──────────────────────────────────────────
-- Unload
-- ──────────────────────────────────────────

Library:OnUnload(function()
    Fly:Stop()
    Movement:DisableTPWalk()
    Movement:DisableInfiniteJump()
    Desync:Stop()
    ESP:Stop()
    Visual:DisableFullbright()
    Visual:DisableXRay()
    Visual:DisableFPSBoost()
    Aimbot:Stop()
    SilentAimbot:Stop()
    Library:Notify("Script cleanly unloaded.", 3)
end)

Library:Notify("Universal Script loaded.", 3)