local _nsusaqd=math.random()
local _nsnwrzf=math.random()
local _ntdlhvf=math.random()
local _obb = game:GetService("Lighting")
local _obc = game:GetService("RunService")
local _obd = {}
_obd.OriginalLighting = {
Brightness = _obb.Brightness,
Ambient = _obb.Ambient,
OutdoorAmbient = _obb.OutdoorAmbient,
}
_obd.OriginalTransparencies = {}
_obd.FullbrightEnabled = false
_obd.XRayEnabled = false
_obd.XRayTransparency = 0.3
_obd.FPSBoostEnabled = false
_obd.FPSBoostConn = nil
function _obd:EnableFullbright()
if self.FullbrightEnabled then return end
self.FullbrightEnabled = true
_obb.Brightness = 2
_obb.Ambient = Color3.fromRGB(255, 255, 255)
_obb.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end
function _obd:DisableFullbright()
if not self.FullbrightEnabled then return end
self.FullbrightEnabled = false
_obb.Brightness = self.OriginalLighting.Brightness
_obb.Ambient = self.OriginalLighting.Ambient
_obb.OutdoorAmbient = self.OriginalLighting.OutdoorAmbient
end
function _obd:EnableXRay()
if self.XRayEnabled then return end
self.XRayEnabled = true
local function setTransparency(part, amount)
if part:IsA("BasePart") then
self.OriginalTransparencies[part] = part.Transparency
part.Transparency = amount
end
end
for _, part in pairs(workspace:GetDescendants()) do
setTransparency(part, self.XRayTransparency)
end
workspace.DescendantAdded:Connect(function(part)
if self.XRayEnabled then
setTransparency(part, self.XRayTransparency)
end
end)
end
function _obd:DisableXRay()
if not self.XRayEnabled then return end
self.XRayEnabled = false
for part, transparency in pairs(self.OriginalTransparencies) do
if part and part.Parent then
part.Transparency = transparency
end
end
self.OriginalTransparencies = {}
end
function _obd:SetXRayTransparency(amount)
self.XRayTransparency = math.clamp(amount, 0, 1)
if self.XRayEnabled then
for part, _ in pairs(self.OriginalTransparencies) do
if part and part.Parent and part:IsA("BasePart") then
part.Transparency = self.XRayTransparency
end
end
end
end
function _obd:EnableFPSBoost()
if self.FPSBoostEnabled then return end
self.FPSBoostEnabled = true
local _obe
_obe = _obc.RenderStepped:Connect(function()
if self.FPSBoostEnabled then
for _, part in pairs(workspace:GetDescendants()) do
if part:IsA("ParticleEmitter") then
part.Enabled = false
end
end
else
_obe:Disconnect()
end
end)
self.FPSBoostConn = _obe
end
function _obd:DisableFPSBoost()
if not self.FPSBoostEnabled then return end
self.FPSBoostEnabled = false
if self.FPSBoostConn then
self.FPSBoostConn:Disconnect()
self.FPSBoostConn = nil
end
for _, part in pairs(workspace:GetDescendants()) do
if part:IsA("ParticleEmitter") then
part.Enabled = true
end
end
end
return _obd