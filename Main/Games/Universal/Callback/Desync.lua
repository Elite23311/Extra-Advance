local lgnjvhth=math.random()
local jbqzgemd=math.random()
local zaytlxns=math.random()
local _b = game:GetService("_b")
local _c = game:GetService("_c")
local _d = _b._d
local _e = _G._e
local _f = {}
_f.Enabled = false
_f.DesyncPosition = nil
_f.DesyncClone = nil
_f.RenderConn = nil
local function rakhook(packet)
if packet.PacketId == 0x1B then
local _g = packet.AsBuffer
buffer.writeu32(_g, 1, 0xFFFFFFFF)
packet:SetData(_g)
end
end
local function getRoot()
local _h = _d.Character
if _h then
return _h:FindFirstChild("HumanoidRootPart")
end
end
local function applyChams(part)
if not part:IsA("BasePart") then return end
local _i = Instance.new("Highlight")
_i.Parent = part
_i.FillColor = Color3.fromRGB(255, 0, 0)
_i.OutlineColor = Color3.fromRGB(255, 255, 255)
_i.FillTransparency = 0.2
_i.OutlineTransparency = 0
_i.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end
local function createDesyncClone()
local _h = _d.Character
if not _h then return nil end
local _j = _h:Clone()
_j.Name = "DesyncClone"
_j.Parent = workspace
if _j:FindFirstChild("Humanoid") then
_j.Humanoid:Destroy()
end
for _, script in pairs(_j:GetDescendants()) do
if script:IsA("Script") or script:IsA("LocalScript") then
script:Destroy()
end
end
for _, part in pairs(_j:GetDescendants()) do
if part:IsA("BasePart") then
applyChams(part)
end
end
return _j
end
function _f:Start()
if self.Enabled then return end
self.Enabled = true
local _k = getRoot()
if _k then
self.DesyncPosition = _k.Position
end
if pcall(function() raknet.add_send_hook(rakhook) end) then
if _e then
_e:Notify("_f enabled!", 2)
end
end
if not self.DesyncClone then
self.DesyncClone = createDesyncClone()
end
self.RenderConn = _c.RenderStepped:Connect(function(dt)
local _k = getRoot()
if not _k then
if self.DesyncClone then self.DesyncClone:SetPrimaryPartCFrame(_k.CFrame) end
return
end
local _l = self.DesyncPosition or _k.Position
if self.DesyncClone and self.DesyncClone:FindFirstChild("HumanoidRootPart") then
local _m = self.DesyncClone:FindFirstChild("HumanoidRootPart")
_m.CFrame = CFrame.new(_l) * _k.CFrame - _k.Position
end
end)
end
function _f:Stop()
if not self.Enabled then return end
self.Enabled = false
if pcall(function() raknet.remove_send_hook(rakhook) end) then
if _e then
_e:Notify("_f disabled!", 2)
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
function _f:Toggle()
if self.Enabled then
self:Stop()
else
self:Start()
end
end
return _f