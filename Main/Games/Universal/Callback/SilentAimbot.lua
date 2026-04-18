local _ntynpes=math.random()
local _nmmwcsx=math.random()
local _ndxepid=math.random()
local _obb = game:GetService("Players")
local _obc = game:GetService("RunService")
local _obd = _obb._obd
local _obe = {}
_obe.Enabled = false
_obe.FOVRadius = 120
_obe.FOVDistance = 500
_obe.ShotChance = 100
_obe.HeadshotChance = 50
_obe.RenderConn = nil
_obe.LastTarget = nil
function _obe:GetTarget()
local _obf = workspace.CurrentCamera
local _obg = _obf.ViewportSize / 2
local _obh, closestDist = nil, math.huge
for _, player in pairs(_obb:GetPlayers()) do
if player == _obd then continue end
local _obi = player.Character
if not _obi then continue end
local _obj = _obi:FindFirstChildOfClass("Humanoid")
if not _obj or _obj.Health <= 0 then continue end
local _obk = _obi:FindFirstChild("Head") or _obi:FindFirstChild("HumanoidRootPart")
if not _obk then continue end
local _obl, onScreen = _obf:WorldToViewportPoint(_obk.Position)
if not onScreen then continue end
local _obm = (_obf.CFrame.Position - _obk.Position).Magnitude
if _obm > self.FOVDistance then continue end
local _obn = (Vector2.new(_obl.X, _obl.Y) - _obg).Magnitude
if _obn > self.FOVRadius then continue end
if _obn < closestDist then
closestDist = _obn
_obh = _obk
end
end
return _obh
end
function _obe:ShouldShoot()
return math.random(1, 100) <= self.ShotChance
end
function _obe:ShouldHeadshot()
return math.random(1, 100) <= self.HeadshotChance
end
function _obe:Start()
if self.RenderConn then return end
self.Enabled = true
self.RenderConn = _obc.RenderStepped:Connect(function()
if not self.Enabled then return end
if not self:ShouldShoot() then
self.LastTarget = nil
return
end
local _obo = self:GetTarget()
if _obo and self:ShouldHeadshot() then
local _obi = _obo.Parent
if _obi then
local _obp = _obi:FindFirstChild("Head")
if _obp then
self.LastTarget = _obp
return
end
end
end
self.LastTarget = _obo
end)
end
function _obe:Stop()
self.Enabled = false
if self.RenderConn then
self.RenderConn:Disconnect()
self.RenderConn = nil
end
self.LastTarget = nil
end
function _obe:GetLastTarget()
return self.LastTarget
end
function _obe:SetConfig(key, value)
if self[key] ~= nil then
self[key] = value
end
end
return _obe