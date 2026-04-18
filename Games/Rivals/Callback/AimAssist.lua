-- ╔══════════════════════════════════════════╗
-- ║   Games/Rivals/Callback/AimAssist.lua    ║
-- ║  Callback-only implementation             ║
-- ╚══════════════════════════════════════════╝

local Config = require(script.Parent.Parent:WaitForChild("Config"))

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera           = workspace.CurrentCamera
local LocalPlayer      = Players.LocalPlayer

local AimAssist = {}
AimAssist.Config = Config.AimAssist
AimAssist.Circle = nil
AimAssist.RenderConn = nil
AimAssist.Callbacks = {
    OnTargetAcquired = function() end,
    OnTargetLost = function() end,
    OnAimUpdate = function() end,
}

local function GetTarget()
    local center   = Camera.ViewportSize / 2
    local fov      = AimAssist.Config.FOV
    local partName = AimAssist.Config.TargetPart
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
        if AimAssist.Config.VisibleOnly then
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

function AimAssist:Start()
    if self.RenderConn then
        warn("[AimAssist] Already running!")
        return
    end

    self.Circle = Drawing.new("Circle")
    self.Circle.Visible   = false
    self.Circle.Filled    = false
    self.Circle.Thickness = 1
    self.Circle.NumSides  = 64
    self.Circle.Radius    = self.Config.FOV
    self.Circle.Color     = self.Config.FOVColor

    self.RenderConn = RunService.RenderStepped:Connect(function()
        local center = Camera.ViewportSize / 2

        -- FOV circle
        if self.Config.ShowFOV then
            self.Circle.Visible  = true
            self.Circle.Position = center
            self.Circle.Radius   = self.Config.FOV
        else
            self.Circle.Visible = false
        end

        -- Aim assist gate checks
        if not self.Config.Enabled then return end
        if self.Config.OnlyWhileClicking and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            return
        end

        local target = GetTarget()
        if not target then
            self.Callbacks.OnTargetLost()
            return
        end

        self.Callbacks.OnTargetAcquired(target)

        local targetCF = CFrame.lookAt(Camera.CFrame.Position, target.Position)
        Camera.CFrame  = Camera.CFrame:Lerp(targetCF, 1 / self.Config.Smoothness)

        self.Callbacks.OnAimUpdate(target, targetCF)
    end)
end

function AimAssist:Stop()
    if self.RenderConn then
        self.RenderConn:Disconnect()
        self.RenderConn = nil
    end
    if self.Circle then
        self.Circle:Remove()
        self.Circle = nil
    end
end

function AimAssist:SetConfig(key, value)
    if self.Config[key] ~= nil then
        self.Config[key] = value
    end
end

function AimAssist:OnTargetAcquired(callback)
    self.Callbacks.OnTargetAcquired = callback
end

function AimAssist:OnTargetLost(callback)
    self.Callbacks.OnTargetLost = callback
end

function AimAssist:OnAimUpdate(callback)
    self.Callbacks.OnAimUpdate = callback
end

return AimAssist
