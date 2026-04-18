-- ╔══════════════════════════════════════════╗
-- ║ Games/Universal/Callback/SilentAimbot.lua║
-- ║  Silent aimbot without visible aiming    ║
-- ╚══════════════════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local SilentAimbot = {}

SilentAimbot.Enabled = false
SilentAimbot.FOVRadius = 120
SilentAimbot.FOVDistance = 500
SilentAimbot.ShotChance = 100
SilentAimbot.HeadshotChance = 50
SilentAimbot.RenderConn = nil
SilentAimbot.LastTarget = nil

function SilentAimbot:GetTarget()
    local camera = workspace.CurrentCamera
    local center = camera.ViewportSize / 2
    local closest, closestDist = nil, math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        local part = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not part then continue end

        local screen, onScreen = camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end

        local dist3D = (camera.CFrame.Position - part.Position).Magnitude
        if dist3D > self.FOVDistance then continue end

        local dist2D = (Vector2.new(screen.X, screen.Y) - center).Magnitude
        if dist2D > self.FOVRadius then continue end

        if dist2D < closestDist then
            closestDist = dist2D
            closest = part
        end
    end

    return closest
end

function SilentAimbot:ShouldShoot()
    return math.random(1, 100) <= self.ShotChance
end

function SilentAimbot:ShouldHeadshot()
    return math.random(1, 100) <= self.HeadshotChance
end

function SilentAimbot:Start()
    if self.RenderConn then return end
    self.Enabled = true

    self.RenderConn = RunService.RenderStepped:Connect(function()
        if not self.Enabled then return end

        if not self:ShouldShoot() then
            self.LastTarget = nil
            return
        end

        local target = self:GetTarget()
        if target and self:ShouldHeadshot() then
            local char = target.Parent
            if char then
                local head = char:FindFirstChild("Head")
                if head then
                    self.LastTarget = head
                    return
                end
            end
        end
        self.LastTarget = target
    end)
end

function SilentAimbot:Stop()
    self.Enabled = false
    if self.RenderConn then
        self.RenderConn:Disconnect()
        self.RenderConn = nil
    end
    self.LastTarget = nil
end

function SilentAimbot:GetLastTarget()
    return self.LastTarget
end

function SilentAimbot:SetConfig(key, value)
    if self[key] ~= nil then
        self[key] = value
    end
end

return SilentAimbot
