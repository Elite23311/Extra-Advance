local _nfgdpne=math.random()
local _nlgbjya=math.random()
local _nldffeu=math.random()
local _obb = game:GetService("Players")
local _obc = game:GetService("RunService")
local _obd = _obb._obd
local _obe = _G._obe
local _obf = {}
_obf.Enabled = false
_obf.DesyncPosition = nil
_obf.DesyncClone = nil
_obf.RenderConn = nil
local function rakhook(packet)
if packet.PacketId == 0x1B then
local _obg = packet.AsBuffer
buffer.writeu32(_obg, 1, 0xFFFFFFFF)
packet:SetData(_obg)
end
end
local function getRoot()
local _obh = _obd.Character
if _obh then
return _obh:FindFirstChild("HumanoidRootPart")
end
end
local function applyChams(part)
if not part:IsA("BasePart") then return end
local _obi = Instance.new("Highlight")
_obi.Parent = part
_obi.FillColor = Color3.fromRGB(255, 0, 0)
_obi.OutlineColor = Color3.fromRGB(255, 255, 255)
_obi.FillTransparency = 0.2
_obi.OutlineTransparency = 0
_obi.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end
local function createDesyncClone()
local _obh = _obd.Character
if not _obh then return nil end
local _obj = _obh:Clone()
_obj.Name = "DesyncClone"
_obj.Parent = workspace
if _obj:FindFirstChild("Humanoid") then
_obj.Humanoid:Destroy()
end
for _, script in pairs(_obj:GetDescendants()) do
if script:IsA("Script") or script:IsA("LocalScript") then
script:Destroy()
end
end
for _, part in pairs(_obj:GetDescendants()) do
if part:IsA("BasePart") then
applyChams(part)
end
end
return _obj
end
function _obf:Start()
if self.Enabled then return end
self.Enabled = true
local _obk = getRoot()
if _obk then
self.DesyncPosition = _obk.Position
end
if pcall(function() raknet.add_send_hook(rakhook) end) then
if _obe then
_obe:Notify("Desync enabled!", 2)
end
end
if not self.DesyncClone then
self.DesyncClone = createDesyncClone()
end
self.RenderConn = _obc.RenderStepped:Connect(function(dt)
local _obk = getRoot()
if not _obk then
if self.DesyncClone then self.DesyncClone:SetPrimaryPartCFrame(_obk.CFrame) end
return
end
local _obl = self.DesyncPosition or _obk.Position
if self.DesyncClone and self.DesyncClone:FindFirstChild("HumanoidRootPart") then
local _obm = self.DesyncClone:FindFirstChild("HumanoidRootPart")
_obm.CFrame = CFrame.new(_obl) * _obk.CFrame - _obk.Position
end
end)
end
function _obf:Stop()
if not self.Enabled then return end
self.Enabled = false
if pcall(function() raknet.remove_send_hook(rakhook) end) then
if _obe then
_obe:Notify("Desync disabled!", 2)
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
function _obf:Toggle()
if self.Enabled then
self:Stop()
else
self:Start()
end
end
return _obf