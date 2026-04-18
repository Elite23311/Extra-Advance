local hxsqskwh=math.random()
local wvrerdre=math.random()
local gdyuyouu=math.random()
local _b = game:GetService("_b")
local _c = game:GetService("_c")
local _d = game:GetService("_d")
local _e = _b._e
local _f = {}
_f.Enabled = false
_f.Method = "Camera"
_f.Smoothness = 12
_f.LockPart = "Head"
_f.ShotChance = 100
_f.FOVRadius = 120
_f.FOVDistance = 500
_f.RenderConn = nil
_f.FOVCircle = nil
function _f:GetTarget()
local _g = workspace.CurrentCamera
local _h = _g.ViewportSize / 2
local _i, closestDist = nil, math.huge
for _, player in pairs(_b:GetPlayers()) do
if player == _e then continue end
local _j = player.Character
if not _j then continue end
local _k = _j:FindFirstChildOfClass("Humanoid")
if not _k or _k.Health <= 0 then continue end
local _l = _j:FindFirstChild(self.LockPart) or _j:FindFirstChild("HumanoidRootPart")
if not _l then continue end
local _m, onScreen = _g:WorldToViewportPoint(_l.Position)
if not onScreen then continue end
local _n = (_g.CFrame.Position - _l.Position).Magnitude
if _n > self.FOVDistance then continue end
local _o = (Vector2.new(_m.X, _m.Y) - _h).Magnitude
if _o > self.FOVRadius then continue end
if _o < closestDist then
closestDist = _o
_i = _l
end
end
return _i
end
function _f:Start()
if self.RenderConn then return end
self.Enabled = true
self.FOVCircle = Drawing.new("Circle")
self.FOVCircle.Visible = true
self.FOVCircle.Filled = false
self.FOVCircle.Thickness = 1
self.FOVCircle.NumSides = 64
self.FOVCircle.Radius = self.FOVRadius
self.FOVCircle.Color = Color3.fromRGB(255, 255, 255)
self.RenderConn = _c.RenderStepped:Connect(function()
local _g = workspace.CurrentCamera
self.FOVCircle.Position = _g.ViewportSize / 2
if not self.Enabled then return end
local _p = self:GetTarget()
if not _p then return end
if math.random(1, 100) > self.ShotChance then return end
if self.Method == "Camera" then
local _q = CFrame.lookAt(_g.CFrame.Position, _p.Position)
_g.CFrame = _g.CFrame:Lerp(_q, 1 / self.Smoothness)
elseif self.Method == "RootPart" then
local _j = _e.Character
if _j and _j:FindFirstChild("HumanoidRootPart") then
local _r = _j.HumanoidRootPart
local _q = CFrame.lookAt(_r.CFrame.Position, _p.Position)
_r.CFrame = _r.CFrame:Lerp(_q, 1 / self.Smoothness)
end
end
end)
end
function _f:Stop()
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
function _f:SetConfig(key, value)
if self[key] ~= nil then
self[key] = value
end
end
return _f