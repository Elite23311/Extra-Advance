local cakpedho=math.random()
local yrcstbqa=math.random()
local owxmtqpy=math.random()
local _b = game:GetService("_b")
local _c = game:GetService("_c")
local _d = game:GetService("_d")
local _e = _c._e
local _f = {}
_f.Enabled = false
_f.Speed = 50
_f.VelocityVector = Vector3.new(0, 0, 0)
_f.RenderConn = nil
_f.BodyVelocity = nil
function _f:Start()
if self.RenderConn then
warn("[_f] Already running!")
return
end
local _g = _e.Character
if not _g or not _g:FindFirstChild("HumanoidRootPart") then
warn("[_f] No character found!")
return
end
local _h = _g.HumanoidRootPart
self.BodyVelocity = Instance.new("BodyVelocity")
self.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
self.BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
self.BodyVelocity.Parent = _h
self.RenderConn = _b.RenderStepped:Connect(function()
if not self.Enabled or not _h.Parent then
self:Stop()
return
end
local _i = workspace.CurrentCamera
local _j = Vector3.new(0, 0, 0)
if _d:IsKeyDown(Enum.KeyCode.W) then
_j = _j + (_i.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
end
if _d:IsKeyDown(Enum.KeyCode.S) then
_j = _j - (_i.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
end
if _d:IsKeyDown(Enum.KeyCode.A) then
_j = _j - _i.CFrame.RightVector
end
if _d:IsKeyDown(Enum.KeyCode.D) then
_j = _j + _i.CFrame.RightVector
end
if _d:IsKeyDown(Enum.KeyCode.Space) then
_j = _j + Vector3.new(0, 1, 0)
end
if _d:IsKeyDown(Enum.KeyCode.LeftControl) then
_j = _j - Vector3.new(0, 1, 0)
end
if _j.Magnitude > 0 then
_j = _j.Unit
end
self.BodyVelocity.Velocity = _j * self.Speed
end)
end
function _f:Stop()
if self.RenderConn then
self.RenderConn:Disconnect()
self.RenderConn = nil
end
if self.BodyVelocity then
self.BodyVelocity:Destroy()
self.BodyVelocity = nil
end
self.Enabled = false
end
function _f:SetSpeed(speed)
self.Speed = speed
end
return _f