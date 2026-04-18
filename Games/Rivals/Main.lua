-- ╔══════════════════════════════════════════╗
-- ║      Games/Rivals/Main.lua               ║
-- ║  Game entry point - loads callbacks      ║
-- ╚══════════════════════════════════════════╝

local RAW = _G.RAW
local Library = _G.Library
local Tabs = _G.Tabs

-- Load game-specific callbacks
local AimAssist = require(script.Parent:WaitForChild("Callback"):WaitForChild("AimAssist"))

-- Example: Set up UI controls for the callback module
local RivalsBox = Tabs.Main:AddLeftGroupbox("Rivals - Aim Assist")

RivalsBox:AddToggle("RivalsAim", {
    Text    = "Enable Aim Assist",
    Default = false,
    Callback = function(value)
        AimAssist:SetConfig("Enabled", value)
        if value then
            AimAssist:Start()
            Library:Notify("Aim Assist started!", 2)
        else
            AimAssist:Stop()
            Library:Notify("Aim Assist stopped!", 2)
        end
    end,
})

RivalsBox:AddToggle("RivalsAimFOV", {
    Text    = "Show FOV",
    Default = AimAssist.Config.ShowFOV,
    Callback = function(value)
        AimAssist:SetConfig("ShowFOV", value)
    end,
})

RivalsBox:AddSlider("RivalsAimFOVRadius", {
    Text     = "FOV Radius",
    Default  = AimAssist.Config.FOV,
    Min      = 20,
    Max      = 500,
    Rounding = 0,
    Callback = function(value)
        AimAssist:SetConfig("FOV", value)
    end,
})

RivalsBox:AddSlider("RivalsAimSmooth", {
    Text     = "Smoothness",
    Default  = AimAssist.Config.Smoothness,
    Min      = 1,
    Max      = 100,
    Rounding = 0,
    Callback = function(value)
        AimAssist:SetConfig("Smoothness", value)
    end,
})

RivalsBox:AddDropdown("RivalsAimPart", {
    Values  = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso" },
    Default = 1,
    Text    = "Target Part",
    Callback = function(value)
        AimAssist:SetConfig("TargetPart", value)
    end,
})

Library:Notify("Rivals game loaded!", 3)
