-- ╔══════════════════════════════════════════╗
-- ║   Games/Universal/Callback/Desync.lua    ║
-- ║  Raknet desync script                    ║
-- ╚══════════════════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Library = _G.Library
local Desync = {}

Desync.Enabled = false
Desync.DesyncPosition = nil
Desync.Circle = nil
Desync.RenderConn = nil

local function rakhook(packet)
    if packet.PacketId == 0x1B then
        local data = packet.AsBuffer
        buffer.writeu32(data, 1, 0xFFFFFFFF)
        packet:SetData(data)
    end
end

local function getRoot()
    local char = LocalPlayer.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
end

function Desync:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    local root = getRoot()
    if root then
        self.DesyncPosition = root.Position
    end
    
    if pcall(function() raknet.add_send_hook(rakhook) end) then
        if Library then
            Library:Notify("🌀 Desync enabled!", 2)
        end
    end

    -- Visual circle
    if not self.Circle then
        self.Circle = Instance.new("Part")
        self.Circle.Shape = Enum.PartType.Cylinder
        self.Circle.Size = Vector3.new(0.15, 7, 7)
        self.Circle.Anchored = true
        self.Circle.CanCollide = false
        self.Circle.Material = Enum.Material.Neon
        self.Circle.Color = Color3.fromRGB(255, 255, 255)
        self.Circle.Transparency = 0.75
        self.Circle.Parent = workspace
        self.Circle.Orientation = Vector3.new(0, 0, 90)
    end

    local baseSize = 7
    local t = 0

    self.RenderConn = RunService.RenderStepped:Connect(function(dt)
        local root = getRoot()
        if not root then
            if self.Circle then self.Circle.Transparency = 1 end
            return
        end

        local targetPos = self.DesyncPosition or root.Position
        self.Circle.Position = Vector3.new(targetPos.X, targetPos.Y - 2.9, targetPos.Z)
        self.Circle.Transparency = 0.75

        t = t + dt * 2
        local pulse = math.sin(t) * 0.5 + 0.5
        local size = baseSize + pulse * 1.5
        self.Circle.Size = Vector3.new(0.15, size, size)
    end)
end

function Desync:Stop()
    if not self.Enabled then return end
    self.Enabled = false
    
    if pcall(function() raknet.remove_send_hook(rakhook) end) then
        if Library then
            Library:Notify("🌀 Desync disabled!", 2)
        end
    end
    
    self.DesyncPosition = nil

    if self.RenderConn then
        self.RenderConn:Disconnect()
        self.RenderConn = nil
    end

    if self.Circle then
        self.Circle:Destroy()
        self.Circle = nil
    end
end

function Desync:Toggle()
    if self.Enabled then
        self:Stop()
    else
        self:Start()
    end
end

return Desync
