-- [[ Universal/Callback/Noclip.lua ]] --
-- Parts have CanCollide = false for movement; reads of CanCollide on the local
-- character are spoofed to true via Movement:RegisterIndexSpoof (same as Fly velocity).

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Noclip = {}
Noclip.Enabled = false
Noclip.Movement = nil
Noclip.RenderConn = nil

local function canCollideSpoofFn(self, key)
    if not Noclip.Enabled or key ~= "CanCollide" then
        return nil
    end
    if typeof(self) ~= "Instance" or not self:IsA("BasePart") then
        return nil
    end
    local char = LocalPlayer.Character
    if not char or not self:IsDescendantOf(char) then
        return nil
    end
    return true
end

function Noclip:Start()
    if self.RenderConn then
        return
    end
    self.Enabled = true
    local M = self.Movement
    if M then
        M:RegisterIndexSpoof("NoclipCanCollide", canCollideSpoofFn)
    end

    self.RenderConn = RunService.RenderStepped:Connect(function()
        if not self.Enabled then
            return
        end
        local char = LocalPlayer.Character
        if not char then
            return
        end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end)
end

function Noclip:Stop()
    self.Enabled = false
    if self.RenderConn then
        self.RenderConn:Disconnect()
        self.RenderConn = nil
    end
    local M = self.Movement
    if M then
        M:UnregisterIndexSpoof("NoclipCanCollide")
    end
    local char = LocalPlayer.Character
    if char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = true
            end
        end
    end
end

return Noclip
