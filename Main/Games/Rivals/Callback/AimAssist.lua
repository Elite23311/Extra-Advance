local mgftrtvk=math.random()
local wbfvvnwg=math.random()
local hlsgnrnw=math.random()
local _b = require(script.Parent.Parent:WaitForChild("_b"))
local _c          = game:GetService("_c")
local _d       = game:GetService("_d")
local _e = game:GetService("_e")
local _f           = workspace.CurrentCamera
local _g      = _c._g
local _h = {}
_h._b = _b._h
_h.Circle = nil
_h.RenderConn = nil
_h.Callbacks = {
OnTargetAcquired = function() end,
OnTargetLost = function() end,
OnAimUpdate = function() end,
}
local function GetTarget()
local _i   = _f.ViewportSize / 2
local _j      = _h._b.FOV
local _k = _h._b.TargetPart
local _l, closestDist = nil, math.huge
for _, plr in ipairs(_c:GetPlayers()) do
if plr == _g then continue end
local _m = plr.Character
if not _m then continue end
local _n = _m:FindFirstChildOfClass("Humanoid")
if not _n or _n.Health <= 0 then continue end
local _o = _m:FindFirstChild(_k) or _m:FindFirstChild("HumanoidRootPart")
if not _o then continue end
local _p, onScreen = _f:WorldToViewportPoint(_o.Position)
if not onScreen then continue end
local _q = (Vector2.new(_p.X, _p.Y) - _i).Magnitude
if _q > _j then continue end
if _h._b.VisibleOnly then
local _r = _f.CFrame.Position
local _s    = Ray.new(_r, _o.Position - _r)
local _t    = workspace:FindPartOnRayWithIgnoreList(_s, { _g.Character, _f })
if _t and not _t:IsDescendantOf(_m) then continue end
end
if _q < closestDist then
closestDist = _q
_l     = _o
end
end
return _l
end
function _h:Start()
if self.RenderConn then
warn("[_h] Already running!")
return
end
self.Circle = Drawing.new("Circle")
self.Circle.Visible   = false
self.Circle.Filled    = false
self.Circle.Thickness = 1
self.Circle.NumSides  = 64
self.Circle.Radius    = self._b.FOV
self.Circle.Color     = self._b.FOVColor
self.RenderConn = _d.RenderStepped:Connect(function()
local _i = _f.ViewportSize / 2
if self._b.ShowFOV then
self.Circle.Visible  = true
self.Circle.Position = _i
self.Circle.Radius   = self._b.FOV
else
self.Circle.Visible = false
end
if not self._b.Enabled then return end
if self._b.OnlyWhileClicking and not _e:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
return
end
local _u = GetTarget()
if not _u then
self.Callbacks.OnTargetLost()
return
end
self.Callbacks.OnTargetAcquired(_u)
local _v = CFrame.lookAt(_f.CFrame.Position, _u.Position)
_f.CFrame  = _f.CFrame:Lerp(_v, 1 / self._b.Smoothness)
self.Callbacks.OnAimUpdate(_u, _v)
end)
end
function _h:Stop()
if self.RenderConn then
self.RenderConn:Disconnect()
self.RenderConn = nil
end
if self.Circle then
self.Circle:Remove()
self.Circle = nil
end
end
function _h:SetConfig(key, value)
if self._b[key] ~= nil then
self._b[key] = value
end
end
function _h:OnTargetAcquired(callback)
self.Callbacks.OnTargetAcquired = callback
end
function _h:OnTargetLost(callback)
self.Callbacks.OnTargetLost = callback
end
function _h:OnAimUpdate(callback)
self.Callbacks.OnAimUpdate = callback
end
return _h