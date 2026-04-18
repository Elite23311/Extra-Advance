local _npqtaix=math.random()
local _njfxyde=math.random()
local _nxsfkap=math.random()
local _obb = game:GetService("Players")
local _obc = game:GetService("RunService")
local _obd = game:GetService("UserInputService")
local _obe = _obb._obe
local _obf = {}
_obf.Enabled = false
_obf.Method = "Camera"
_obf.Smoothness = 12
_obf.LockPart = "Head"
_obf.ShotChance = 100
_obf.FOVRadius = 120
_obf.FOVDistance = 500
_obf.RenderConn = nil
_obf.FOVCircle = nil
function _obf:GetTarget()
local _obg = workspace.CurrentCamera
local _obh = _obg.ViewportSize / 2
local _obi, closestDist = nil, math.huge
for _, player in pairs(_obb:GetPlayers()) do
if player == _obe then continue end
local _obj = player.Character
if not _obj then continue end
local _obk = _obj:FindFirstChildOfClass("Humanoid")
if not _obk or _obk.Health <= 0 then continue end
local _obl = _obj:FindFirstChild(self.LockPart) or _obj:FindFirstChild("HumanoidRootPart")
if not _obl then continue end
local _obm, onScreen = _obg:WorldToViewportPoint(_obl.Position)
if not onScreen then continue end
local _obn = (_obg.CFrame.Position - _obl.Position).Magnitude
if _obn > self.FOVDistance then continue end
local _obo = (Vector2.new(_obm.X, _obm.Y) - _obh).Magnitude
if _obo > self.FOVRadius then continue end
if _obo < closestDist then
closestDist = _obo
_obi = _obl
end
end
return _obi
end
function _obf:Start()
if self.RenderConn then return end
self.Enabled = true
self.FOVCircle = Drawing.new("Circle")
self.FOVCircle.Visible = true
self.FOVCircle.Filled = false
self.FOVCircle.Thickness = 1
self.FOVCircle.NumSides = 64
self.FOVCircle.Radius = self.FOVRadius
self.FOVCircle.Color = Color3.fromRGB(255, 255, 255)
self.RenderConn = _obc.RenderStepped:Connect(function()
local _obg = workspace.CurrentCamera
self.FOVCircle.Position = _obg.ViewportSize / 2
if not self.Enabled then return end
local _obp = self:GetTarget()
if not _obp then return end
if math.random(1, 100) > self.ShotChance then return end
if self.Method == "Camera" then
local _obq = CFrame.lookAt(_obg.CFrame.Position, _obp.Position)
_obg.CFrame = _obg.CFrame:Lerp(_obq, 1 / self.Smoothness)
elseif self.Method == "RootPart" then
local _obj = _obe.Character
if _obj and _obj:FindFirstChild("HumanoidRootPart") then
local _obr = _obj.HumanoidRootPart
local _obq = CFrame.lookAt(_obr.CFrame.Position, _obp.Position)
_obr.CFrame = _obr.CFrame:Lerp(_obq, 1 / self.Smoothness)
end
end
end)
end
function _obf:Stop()
self.Enabled = false
if self.RenderConn then
self.RenderConn:Disconnect()
self.RenderConn = nil
end
if self.FOVCircle then
self.FOVCircle:Remove()
self.FOVCircle = nil
end
end
function _obf:SetConfig(key, value)
if self[key] ~= nil then
self[key] = value
end
end
return _obf