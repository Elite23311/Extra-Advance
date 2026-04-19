-- [[ Universal/Callback/Aimbot.lua ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Aimbot = {}

Aimbot.Enabled = false
Aimbot.Method = "Camera"
Aimbot.Smoothness = 12
Aimbot.LockPart = "Head"
Aimbot.ShotChance = 100
Aimbot.FOVRadius = 120
Aimbot.FOVDistance = 500
Aimbot.MaxTargetDistance = 500
Aimbot.ShowFOV = true
Aimbot.TeamCheck = false
Aimbot.InvisibleCheck = false
Aimbot.HealthCheck = true
Aimbot.WallCheck = false
Aimbot.FOVOutlineTransparency = 0
Aimbot.FOVFillTransparency = 0.5
Aimbot.FOVColor = Color3.fromRGB(255, 255, 255)
Aimbot.RenderConn = nil
Aimbot.FOVCircle = nil

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Blacklist

local function hasLineOfSight(origin, targetPart)
    local char = targetPart:FindFirstAncestorOfClass("Model")
    if not char then
        return true
    end
    local dir = targetPart.Position - origin
    local dist = dir.Magnitude
    if dist < 0.05 then
        return true
    end
    local filter = { LocalPlayer.Character }
    rayParams.FilterDescendantsInstances = filter
    local hit = workspace:Raycast(origin, dir.Unit * (dist - 0.05), rayParams)
    if not hit then
        return true
    end
    return hit.Instance:IsDescendantOf(char)
end

function Aimbot:IsPlayerTargetable(player, part, hum)
    if player == LocalPlayer then
        return false
    end
    if self.TeamCheck and LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team then
        return false
    end
    if self.HealthCheck then
        if not hum or hum.Health <= 0 then
            return false
        end
    elseif hum and hum.Health <= 0 then
        return false
    end
    if self.InvisibleCheck then
        if part.Transparency >= 1 then
            return false
        end
        local root = part.Parent and part.Parent:FindFirstChild("HumanoidRootPart")
        if root and root.Transparency >= 1 then
            return false
        end
    end
    if self.WallCheck then
        local camera = workspace.CurrentCamera
        if camera and not hasLineOfSight(camera.CFrame.Position, part) then
            return false
        end
    end
    return true
end

function Aimbot:GetTarget()
    local camera = workspace.CurrentCamera
    if not camera then
        return nil
    end
    local center = camera.ViewportSize / 2
    local closest, closestDist = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local part = char:FindFirstChild(self.LockPart) or char:FindFirstChild("HumanoidRootPart")
            if part and self:IsPlayerTargetable(player, part, hum) then
                local screen, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist3D = (camera.CFrame.Position - part.Position).Magnitude
                    if dist3D <= self.MaxTargetDistance then
                        local dist2D = (Vector2.new(screen.X, screen.Y) - center).Magnitude
                        if dist2D <= self.FOVRadius then
                            if dist2D < closestDist then
                                closestDist = dist2D
                                closest = part
                            end
                        end
                    end
                end
            end
        end
    end

    return closest
end

function Aimbot:_ensureFovCircle()
    if self.FOVCircle then
        return
    end
    self.FOVCircle = Drawing.new("Circle")
    self.FOVCircle.Visible = self.ShowFOV
    self.FOVCircle.Filled = false
    self.FOVCircle.Thickness = 1
    self.FOVCircle.NumSides = 64
    self.FOVCircle.Radius = self.FOVRadius
    self.FOVCircle.Color = self.FOVColor
    self.FOVCircle.Transparency = self.FOVOutlineTransparency
end

function Aimbot:Start()
    if self.RenderConn then
        return
    end
    self.Enabled = true

    if self.ShowFOV then
        self:_ensureFovCircle()
    end

    self.RenderConn = RunService.RenderStepped:Connect(function()
        local camera = workspace.CurrentCamera
        if not camera then
            return
        end

        if self.FOVCircle then
            self.FOVCircle.Position = camera.ViewportSize / 2
            self.FOVCircle.Visible = self.ShowFOV
            self.FOVCircle.Radius = self.FOVRadius
        end

        if not self.Enabled then
            return
        end

        local target = self:GetTarget()
        if not target then
            return
        end

        if math.random(1, 100) > self.ShotChance then
            return
        end

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
    if key == "ShowFOV" then
        if value and self.Enabled and not self.FOVCircle then
            self:_ensureFovCircle()
        end
        if self.FOVCircle then
            self.FOVCircle.Visible = value
        end
    end
end

return Aimbot
