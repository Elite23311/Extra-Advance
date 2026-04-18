local ckeloxpz=math.random()
local daphpkxf=math.random()
local xxxadetm=math.random()
local _b = game:GetService("_b")
local _c = game:GetService("_c")
local _d = {}
_d.OriginalLighting = {
Brightness = _b.Brightness,
Ambient = _b.Ambient,
OutdoorAmbient = _b.OutdoorAmbient,
}
_d.OriginalTransparencies = {}
_d.FullbrightEnabled = false
_d.XRayEnabled = false
_d.XRayTransparency = 0.3
_d.FPSBoostEnabled = false
_d.FPSBoostConn = nil
function _d:EnableFullbright()
if self.FullbrightEnabled then return end
self.FullbrightEnabled = true
_b.Brightness = 2
_b.Ambient = Color3.fromRGB(255, 255, 255)
_b.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end
function _d:DisableFullbright()
if not self.FullbrightEnabled then return end
self.FullbrightEnabled = false
_b.Brightness = self.OriginalLighting.Brightness
_b.Ambient = self.OriginalLighting.Ambient
_b.OutdoorAmbient = self.OriginalLighting.OutdoorAmbient
end
function _d:EnableXRay()
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
function _d:DisableXRay()
if not self.XRayEnabled then return end
self.XRayEnabled = false
for part, transparency in pairs(self.OriginalTransparencies) do
if part and part.Parent then
part.Transparency = transparency
end
end
self.OriginalTransparencies = {}
end
function _d:SetXRayTransparency(amount)
self.XRayTransparency = math.clamp(amount, 0, 1)
if self.XRayEnabled then
for part, _ in pairs(self.OriginalTransparencies) do
if part and part.Parent and part:IsA("BasePart") then
part.Transparency = self.XRayTransparency
end
end
end
end
function _d:EnableFPSBoost()
if self.FPSBoostEnabled then return end
self.FPSBoostEnabled = true
local _e
_e = _c.RenderStepped:Connect(function()
if self.FPSBoostEnabled then
for _, part in pairs(workspace:GetDescendants()) do
if part:IsA("ParticleEmitter") then
part.Enabled = false
end
end
else
_e:Disconnect()
end
end)
self.FPSBoostConn = _e
end
function _d:DisableFPSBoost()
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
return _d