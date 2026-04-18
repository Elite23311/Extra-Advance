
local Library = _G.Library
local Tabs    = _G.Tabs

local _Toggles = Toggles
local _Options  = Options

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera           = workspace.CurrentCamera
local LocalPlayer      = Players.LocalPlayer

-- ── UI ─────────────────────────────────────
local AimBox = Tabs.Main:AddLeftGroupbox("Aim Assist")
local CfgBox = Tabs.Main:AddRightGroupbox("Aim Config")

AimBox:AddToggle("AimAssist", {
    Text    = "Enable Aim Assist",
    Default = false,
    Tooltip = "Smoothly moves camera toward the nearest target",
})

AimBox:AddToggle("AimOnClick", {
    Text    = "Only While Clicking",
    Default = true,
    Tooltip = "Only activates while holding left mouse button",
})

AimBox:AddToggle("AimVisibleOnly", {
    Text    = "Visible Targets Only",
    Default = true,
    Tooltip = "Ignores players behind walls",
})

AimBox:AddToggle("AimShowFOV", {
    Text    = "Show FOV Circle",
    Default = true,
})

AimBox:AddDivider()

AimBox:AddLabel("Keybind"):AddKeyPicker("AimKeybind", {
    Default          = "MB2",
    SyncToggleState  = true,
    Mode             = "Hold",
    Text             = "Aim Assist Hold",
    NoUI             = false,
})

-- Config
CfgBox:AddSlider("AimFOV", {
    Text     = "FOV Radius",
    Default  = 120,
    Min      = 20,
    Max      = 500,
    Rounding = 0,
})

CfgBox:AddSlider("AimSmooth", {
    Text     = "Smoothness",
    Default  = 12,
    Min      = 1,
    Max      = 100,
    Rounding = 0,
    Tooltip  = "Higher = smoother / slower",
})

CfgBox:AddDropdown("AimPart", {
    Values  = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso" },
    Default = 1,
    Text    = "Target Hitbox",
})

CfgBox:AddDivider()

CfgBox:AddLabel("FOV Color"):AddColorPicker("AimCircleColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Title   = "FOV Circle Color",
})

-- ── FOV CIRCLE ─────────────────────────────
local Circle = Drawing.new("Circle")
Circle.Visible   = false
Circle.Filled    = false
Circle.Thickness = 1
Circle.NumSides  = 64
Circle.Radius    = _Options.AimFOV.Value
Circle.Color     = _Options.AimCircleColor.Value

_Options.AimCircleColor:OnChanged(function()
    Circle.Color = _Options.AimCircleColor.Value
end)

_Options.AimFOV:OnChanged(function()
    Circle.Radius = _Options.AimFOV.Value
end)

-- ── HELPERS ────────────────────────────────
local function GetTarget()
    local center   = Camera.ViewportSize / 2
    local fov      = _Options.AimFOV.Value
    local partName = _Options.AimPart.Value
    local closest, closestDist = nil, math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        local part = char:FindFirstChild(partName) or char:FindFirstChild("HumanoidRootPart")
        if not part then continue end

        local screen, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end

        local dist2D = (Vector2.new(screen.X, screen.Y) - center).Magnitude
        if dist2D > fov then continue end

        -- Visible check
        if _Toggles.AimVisibleOnly.Value then
            local origin = Camera.CFrame.Position
            local ray    = Ray.new(origin, part.Position - origin)
            local hit    = workspace:FindPartOnRayWithIgnoreList(ray, { LocalPlayer.Character, Camera })
            if hit and not hit:IsDescendantOf(char) then continue end
        end

        if dist2D < closestDist then
            closestDist = dist2D
            closest     = part
        end
    end

    return closest
end

-- ── RENDER LOOP ────────────────────────────
local conn = RunService.RenderStepped:Connect(function()
    local center = Camera.ViewportSize / 2

    -- FOV circle
    if _Toggles.AimShowFOV.Value then
        Circle.Visible  = true
        Circle.Position = center
        Circle.Radius   = _Options.AimFOV.Value
    else
        Circle.Visible = false
    end

    -- Aim assist gate checks
    if not _Toggles.AimAssist.Value then return end
    if _Toggles.AimOnClick.Value
        and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        return
    end

    local target = GetTarget()
    if not target then return end

    local targetCF = CFrame.lookAt(Camera.CFrame.Position, target.Position)
    Camera.CFrame  = Camera.CFrame:Lerp(targetCF, 1 / _Options.AimSmooth.Value)
end)

-- Cleanup on unload
Library:OnUnload(function()
    conn:Disconnect()
    Circle:Remove()
end)

Library:Notify("Aim Assist loaded!", 3)
