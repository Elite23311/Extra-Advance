local _nsdgjzq=math.random()
local _nhjifgk=math.random()
local _nmuscnm=math.random()
local _obb = game:GetService("RunService")
local _obc = game:GetService("Players")
local _obd = game:GetService("UserInputService")
local _obe = _obc._obe
local _obf = {}
_obf.Enabled = false
_obf.Speed = 50
_obf.VelocityVector = Vector3.new(0, 0, 0)
_obf.RenderConn = nil
_obf.BodyVelocity = nil
function _obf:Start()
if self.RenderConn then
warn("[Fly] Already running!")
return
end
local _obg = _obe.Character
if not _obg or not _obg:FindFirstChild("HumanoidRootPart") then
warn("[Fly] No character found!")
return
end
local _obh = _obg.HumanoidRootPart
self.BodyVelocity = Instance.new("BodyVelocity")
self.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
self.BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
self.BodyVelocity.Parent = _obh
self.RenderConn = _obb.RenderStepped:Connect(function()
if not self.Enabled or not _obh.Parent then
self:Stop()
return
end
local _obi = workspace.CurrentCamera
local _obj = Vector3.new(0, 0, 0)
if _obd:IsKeyDown(Enum.KeyCode.W) then
_obj = _obj + (_obi.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
end
if _obd:IsKeyDown(Enum.KeyCode.S) then
_obj = _obj - (_obi.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
end
if _obd:IsKeyDown(Enum.KeyCode.A) then
_obj = _obj - _obi.CFrame.RightVector
end
if _obd:IsKeyDown(Enum.KeyCode.D) then
_obj = _obj + _obi.CFrame.RightVector
end
if _obd:IsKeyDown(Enum.KeyCode.Space) then
_obj = _obj + Vector3.new(0, 1, 0)
end
if _obd:IsKeyDown(Enum.KeyCode.LeftControl) then
_obj = _obj - Vector3.new(0, 1, 0)
end
if _obj.Magnitude > 0 then
_obj = _obj.Unit
end
self.BodyVelocity.Velocity = _obj * self.Speed
end)
end
function _obf:Stop()
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
function _obf:SetSpeed(speed)
self.Speed = speed
end
return _obf