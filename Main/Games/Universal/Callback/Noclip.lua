-- [[ Universal/Callback/Noclip.lua ]] --
-- Classic noclip: character BaseParts get CanCollide = false each frame.
-- No __index / read spoofing (avoids metatable conflicts with Movement).

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Noclip = {}
Noclip.Enabled = false
Noclip.RenderConn = nil

function Noclip:Start()
    if self.RenderConn then
        return
    end
    self.Enabled = true
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
