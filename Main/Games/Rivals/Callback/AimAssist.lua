local _nxqdold=math.random()
local _ncmlbko=math.random()
local _neyytpy=math.random()
local _obb = require(script.Parent.Parent:WaitForChild("Config"))
local _obc          = game:GetService("Players")
local _obd       = game:GetService("RunService")
local _obe = game:GetService("UserInputService")
local _obf           = workspace.CurrentCamera
local _obg      = _obc._obg
local _obh = {}
_obh._obb = _obb._obh
_obh.Circle = nil
_obh.RenderConn = nil
_obh.Callbacks = {
OnTargetAcquired = function() end,
OnTargetLost = function() end,
OnAimUpdate = function() end,
}
local function GetTarget()
local _obi   = _obf.ViewportSize / 2
local _obj      = _obh._obb.FOV
local _obk = _obh._obb.TargetPart
local _obl, closestDist = nil, math.huge
for _, plr in ipairs(_obc:GetPlayers()) do
if plr == _obg then continue end
local _obm = plr.Character
if not _obm then continue end
local _obn = _obm:FindFirstChildOfClass("Humanoid")
if not _obn or _obn.Health <= 0 then continue end
local _obo = _obm:FindFirstChild(_obk) or _obm:FindFirstChild("HumanoidRootPart")
if not _obo then continue end
local _obp, onScreen = _obf:WorldToViewportPoint(_obo.Position)
if not onScreen then continue end
local _obq = (Vector2.new(_obp.X, _obp.Y) - _obi).Magnitude
if _obq > _obj then continue end
if _obh._obb.VisibleOnly then
local _obr = _obf.CFrame.Position
local _obs    = Ray.new(_obr, _obo.Position - _obr)
local _obt    = workspace:FindPartOnRayWithIgnoreList(_obs, { _obg.Character, _obf })
if _obt and not _obt:IsDescendantOf(_obm) then continue end
end
if _obq < closestDist then
closestDist = _obq
_obl     = _obo
end
end
return _obl
end
function _obh:Start()
if self.RenderConn then
warn("[AimAssist] Already running!")
return
end
self.Circle = Drawing.new("Circle")
self.Circle.Visible   = false
self.Circle.Filled    = false
self.Circle.Thickness = 1
self.Circle.NumSides  = 64
self.Circle.Radius    = self._obb.FOV
self.Circle.Color     = self._obb.FOVColor
self.RenderConn = _obd.RenderStepped:Connect(function()
local _obi = _obf.ViewportSize / 2
if self._obb.ShowFOV then
self.Circle.Visible  = true
self.Circle.Position = _obi
self.Circle.Radius   = self._obb.FOV
else
self.Circle.Visible = false
end
if not self._obb.Enabled then return end
if self._obb.OnlyWhileClicking and not _obe:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
return
end
local _obu = GetTarget()
if not _obu then
self.Callbacks.OnTargetLost()
return
end
self.Callbacks.OnTargetAcquired(_obu)
local _obv = CFrame.lookAt(_obf.CFrame.Position, _obu.Position)
_obf.CFrame  = _obf.CFrame:Lerp(_obv, 1 / self._obb.Smoothness)
self.Callbacks.OnAimUpdate(_obu, _obv)
end)
end
function _obh:Stop()
if self.RenderConn then
self.RenderConn:Disconnect()
self.RenderConn = nil
end
if self.Circle then
self.Circle:Remove()
self.Circle = nil
end
end
function _obh:SetConfig(key, value)
if self._obb[key] ~= nil then
self._obb[key] = value
end
end
function _obh:OnTargetAcquired(callback)
self.Callbacks.OnTargetAcquired = callback
end
function _obh:OnTargetLost(callback)
self.Callbacks.OnTargetLost = callback
end
function _obh:OnAimUpdate(callback)
self.Callbacks.OnAimUpdate = callback
end
return _obh