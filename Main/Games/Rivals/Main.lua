-- [[ Games/Rivals/Main.lua ]] --

local Library = getgenv().Library
local Window  = getgenv().Window
local Tabs    = getgenv().Tabs
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

local AimAssist = requireModule("Games/Rivals/Callback/AimAssist.lua")

local RivalsBox = Tabs.Main:AddLeftGroupbox("Aim Assist")

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

Library:Notify("Rivals Script Loaded.", 3)