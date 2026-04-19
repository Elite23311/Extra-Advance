-- [[ Universal/Callback/Desync.lua ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Library = getgenv().Library
local Desync = {}

Desync.Enabled = false
Desync.DesyncPosition = nil
Desync.DesyncClone = nil
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

local function applyChams(part)
    if not part:IsA("BasePart") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = part
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.2
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

local function createDesyncClone()
    local char = LocalPlayer.Character
    if not char then return nil end
    
    local clone = char:Clone()
    clone.Name = "DesyncClone"
    clone.Parent = workspace
    
    -- Remove humanoid and scripts
    if clone:FindFirstChild("Humanoid") then
        clone.Humanoid:Destroy()
    end
    
    for _, child in pairs(clone:GetChildren()) do
        if child:IsA("Script") or child:IsA("LocalScript") then
            child:Destroy()
        end
    end
    
    -- Apply chams to all visible parts
    for _, part in pairs(clone:GetDescendants()) do
        if part:IsA("BasePart") then
            applyChams(part)
        end
    end
    
    return clone
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
            Library:Notify("Desync enabled!", 2)
        end
    end

    -- Create desync clone with chams
    if not self.DesyncClone then
        self.DesyncClone = createDesyncClone()
    end

    self.RenderConn = RunService.RenderStepped:Connect(function(dt)
        local root = getRoot()
        if not root then
            if self.DesyncClone then self.DesyncClone:SetPrimaryPartCFrame(root.CFrame) end
            return
        end

        local targetPos = self.DesyncPosition or root.Position
        
        -- Move clone to desync position
        if self.DesyncClone and self.DesyncClone:FindFirstChild("HumanoidRootPart") then
            local cloneRoot = self.DesyncClone:FindFirstChild("HumanoidRootPart")
            cloneRoot.CFrame = CFrame.new(targetPos) * root.CFrame - root.Position
        end
    end)
end

function Desync:Stop()
    if not self.Enabled then return end
    self.Enabled = false
    
    if pcall(function() raknet.remove_send_hook(rakhook) end) then
        if Library then
            Library:Notify("Desync disabled!", 2)
        end
    end
    
    self.DesyncPosition = nil

    if self.RenderConn then
        self.RenderConn:Disconnect()
        self.RenderConn = nil
    end

    if self.DesyncClone then
        self.DesyncClone:Destroy()
        self.DesyncClone = nil
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

