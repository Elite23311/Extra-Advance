-- ╔══════════════════════════════════════════╗
-- ║  Games/Universal/Callback/Aimbot.lua     ║
-- ║  Aimbot with camera/rootpart methods     ║
-- ╚══════════════════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Aimbot = {}

Aimbot.Enabled = false
Aimbot.Method = "Camera"
Aimbot.Smoothness = 12
Aimbot.LockPart = "Head"
Aimbot.ShotChance = 100
Aimbot.FOVRadius = 120
Aimbot.FOVDistance = 500
Aimbot.RenderConn = nil
Aimbot.FOVCircle = nil

function Aimbot:GetTarget()
    local camera = workspace.CurrentCamera
    local center = camera.ViewportSize / 2
    local closest, closestDist = nil, math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        local part = char:FindFirstChild(self.LockPart) or char:FindFirstChild("HumanoidRootPart")
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

function Aimbot:Start()
    if self.RenderConn then return end
    self.Enabled = true

    self.FOVCircle = Drawing.new("Circle")
    self.FOVCircle.Visible = true
    self.FOVCircle.Filled = false
    self.FOVCircle.Thickness = 1
    self.FOVCircle.NumSides = 64
    self.FOVCircle.Radius = self.FOVRadius
    self.FOVCircle.Color = Color3.fromRGB(255, 255, 255)

    self.RenderConn = RunService.RenderStepped:Connect(function()
        local camera = workspace.CurrentCamera
        self.FOVCircle.Position = camera.ViewportSize / 2

        if not self.Enabled then return end

        local target = self:GetTarget()
        if not target then return end

        -- Apply shot chance
        if math.random(1, 100) > self.ShotChance then return end

        if self.Method == "Camera" then
            local targetCF = CFrame.lookAt(camera.CFrame.Position, target.Position)
            camera.CFrame = camera.CFrame:Lerp(targetCF, 1 / self.Smoothness)
        elseif self.Method == "RootPart" then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local targetCF = CFrame.lookAt(root.CFrame.Position, target.Position)
                root.CFrame = root.CFrame:Lerp(targetCF, 1 / self.Smoothness)
            end
        end
    end)
end

function Aimbot:Stop()
    self.Enabled = false
    if self.RenderConn then
        self.RenderConn:Disconnect()
        self.RenderConn = nil
    end
    if self.FOVCircle then
        self.FOVCircle:Remove()
        self.FOVCircle = nil
    end
end

function Aimbot:SetConfig(key, value)
    if self[key] ~= nil then
        self[key] = value
    end
end

return Aimbot
