-- [[ Universal/Callback/Fly.lua ]] --

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Fly = {}

Fly.Enabled = false
Fly.Speed = 50
Fly.VelocityVector = Vector3.new(0, 0, 0)
Fly.RenderConn = nil
Fly.BodyVelocity = nil

function Fly:Start()
    if self.RenderConn then
        warn("[Fly] Already running!")
        return
    end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        warn("[Fly] No character found!")
        return
    end

    local root = char.HumanoidRootPart
    
    self.BodyVelocity = Instance.new("BodyVelocity")
    self.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    self.BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    self.BodyVelocity.Parent = root

    self.RenderConn = RunService.RenderStepped:Connect(function()
        if not self.Enabled or not root.Parent then
            self:Stop()
            return
        end

        local camera = workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + (camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - (camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
        end

        self.BodyVelocity.Velocity = moveDir * self.Speed
    end)
end

function Fly:Stop()
    if self.RenderConn then
        self.RenderConn:Disconnect()
        self.RenderConn = nil
    end
    if self.BodyVelocity then
        self.BodyVelocity:Destroy()
        self.BodyVelocity = nil
    end
    self.Enabled = false
end

function Fly:SetSpeed(speed)
    self.Speed = speed
end

return Fly

