local deuzidht=math.random()
local hmndnzpm=math.random()
local xgzvbwzp=math.random()
local _b = game:GetService("_b")
local _c = game:GetService("_c")
local _d = _b._d
local _e = {}
_e.Enabled = false
_e.FOVRadius = 120
_e.FOVDistance = 500
_e.ShotChance = 100
_e.HeadshotChance = 50
_e.RenderConn = nil
_e.LastTarget = nil
function _e:GetTarget()
local _f = workspace.CurrentCamera
local _g = _f.ViewportSize / 2
local _h, closestDist = nil, math.huge
for _, player in pairs(_b:GetPlayers()) do
if player == _d then continue end
local _i = player.Character
if not _i then continue end
local _j = _i:FindFirstChildOfClass("Humanoid")
if not _j or _j.Health <= 0 then continue end
local _k = _i:FindFirstChild("Head") or _i:FindFirstChild("HumanoidRootPart")
if not _k then continue end
local _l, onScreen = _f:WorldToViewportPoint(_k.Position)
if not onScreen then continue end
local _m = (_f.CFrame.Position - _k.Position).Magnitude
if _m > self.FOVDistance then continue end
local _n = (Vector2.new(_l.X, _l.Y) - _g).Magnitude
if _n > self.FOVRadius then continue end
if _n < closestDist then
closestDist = _n
_h = _k
end
end
return _h
end
function _e:ShouldShoot()
return math.random(1, 100) <= self.ShotChance
end
function _e:ShouldHeadshot()
return math.random(1, 100) <= self.HeadshotChance
end
function _e:Start()
if self.RenderConn then return end
self.Enabled = true
self.RenderConn = _c.RenderStepped:Connect(function()
if not self.Enabled then return end
if not self:ShouldShoot() then
self.LastTarget = nil
return
end
local _o = self:GetTarget()
if _o and self:ShouldHeadshot() then
local _i = _o.Parent
if _i then
local _p = _i:FindFirstChild("Head")
if _p then
self.LastTarget = _p
return
end
end
end
self.LastTarget = _o
end)
end
function _e:Stop()
self.Enabled = false
if self.RenderConn then
self.RenderConn:Disconnect()
self.RenderConn = nil
end
self.LastTarget = nil
end
function _e:GetLastTarget()
return self.LastTarget
end
function _e:SetConfig(key, value)
if self[key] ~= nil then
self[key] = value
end
end
return _e