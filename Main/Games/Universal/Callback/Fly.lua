-- [[ Universal/Callback/Fly.lua ]] --
-- CFrame-based movement (no BodyVelocity). Velocity / AssemblyLinearVelocity reads on
-- HRP are spoofed via Movement:RegisterIndexSpoof (__index chain, same idea as Movement
-- walk/jump). Instance properties are not Lua functions, so hookfunction is not used here.

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local Fly = {}
Fly.Enabled = false
Fly.Speed = 50
Fly.RenderConn = nil
Fly.SpoofRoot = nil

local function velocitySpoofFn(self, key)
    if not Fly.Enabled or not Fly.SpoofRoot or self ~= Fly.SpoofRoot then
        return nil
    end
    if key == "Velocity" or key == "AssemblyLinearVelocity" then
        return Vector3.zero
    end
    return nil
end

function Fly:_setSpoofRoot(root)
    self.SpoofRoot = root
    local M = self.Movement
    if not M then return end
    if root then
        M:RegisterIndexSpoof("FlyVelocity", velocitySpoofFn)
    else
        M:UnregisterIndexSpoof("FlyVelocity")
    end
end

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
    self:_setSpoofRoot(root)

    self.RenderConn = RunService.RenderStepped:Connect(function(dt)
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

        local step = self.Speed * math.clamp(dt, 1 / 240, 1 / 20)
        if moveDir.Magnitude > 0 then
            root.CFrame = root.CFrame + moveDir * step
        end
    end)
end

function Fly:Stop()
    if self.RenderConn then
        self.RenderConn:Disconnect()
        self.RenderConn = nil
    end
    self:_setSpoofRoot(nil)
    self.Enabled = false
end

function Fly:SetSpeed(speed)
    self.Speed = speed
end

return Fly
