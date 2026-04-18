local _nkhnhqu=math.random()
local _nqxvzrt=math.random()
local _npucztd=math.random()
local _obb = game:GetService("Players")
local _obc = game:GetService("RunService")
local _obd = game:GetService("UserInputService")
local _obe = _obb._obe
local _obf = {}
_obf.WalkSpeedValue = 16
_obf.JumpPowerValue = 50
_obf.TPWalkEnabled = false
_obf.TPWalkSpeed = 100
_obf.InfiniteJumpEnabled = false
_obf.RenderConn = nil
_obf.HumanoidConnection = nil
local function hookHumanoid(humanoid)
if not humanoid then return end
local _obg = humanoid.WalkSpeed
hookfunction(humanoid, "GetPropertyChangedSignal", function(self, prop)
if prop == "WalkSpeed" then
task.defer(function()
if humanoid and humanoid.Parent then
humanoid.WalkSpeed = _obf.WalkSpeedValue
end
end)
end
return _obg
end)
humanoid.WalkSpeed = _obf.WalkSpeedValue
end
local function setupTPWalk()
local _obh = workspace.CurrentCamera
local _obb = game:GetService("Players")
local _obe = _obb._obe
return _obc.RenderStepped:Connect(function()
if not _obf.TPWalkEnabled or not _obe.Character or not _obe.Character:FindFirstChild("HumanoidRootPart") then
return
end
local _obi = _obe.Character.HumanoidRootPart
local _obj = Vector3.new(0, 0, 0)
if _obd:IsKeyDown(Enum.KeyCode.W) then
_obj = _obj + (_obh.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
end
if _obd:IsKeyDown(Enum.KeyCode.S) then
_obj = _obj - (_obh.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
end
if _obd:IsKeyDown(Enum.KeyCode.A) then
_obj = _obj - _obh.CFrame.RightVector
end
if _obd:IsKeyDown(Enum.KeyCode.D) then
_obj = _obj + _obh.CFrame.RightVector
end
if _obj.Magnitude > 0 then
_obj = _obj.Unit
_obi.CFrame = _obi.CFrame + _obj * (_obf.TPWalkSpeed / 60)
end
end)
end
function _obf:SetWalkSpeed(speed)
self.WalkSpeedValue = speed
local _obk = _obe.Character
if _obk and _obk:FindFirstChild("Humanoid") then
_obk.Humanoid.WalkSpeed = speed
end
end
function _obf:SetJumpPower(power)
self.JumpPowerValue = power
local _obk = _obe.Character
if _obk and _obk:FindFirstChild("Humanoid") then
_obk.Humanoid.JumpPower = power
end
end
function _obf:EnableInfiniteJump()
self.InfiniteJumpEnabled = true
_obd.InputBegan:Connect(function(input, gameProcessed)
if gameProcessed then return end
if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
local _obk = _obe.Character
if _obk and _obk:FindFirstChild("Humanoid") and self.InfiniteJumpEnabled then
_obk.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
end
end)
end
function _obf:DisableInfiniteJump()
self.InfiniteJumpEnabled = false
end
function _obf:EnableTPWalk()
if self.RenderConn then
self.RenderConn:Disconnect()
end
self.TPWalkEnabled = true
self.RenderConn = setupTPWalk()
end
function _obf:DisableTPWalk()
if self.RenderConn then
self.RenderConn:Disconnect()
self.RenderConn = nil
end
self.TPWalkEnabled = false
end
function _obf:Init()
local _obk = _obe.Character
if _obk and _obk:FindFirstChild("Humanoid") then
hookHumanoid(_obk.Humanoid)
end
_obe.CharacterAdded:Connect(function(newChar)
task.wait(0.1)
if newChar:FindFirstChild("Humanoid") then
hookHumanoid(newChar.Humanoid)
end
end)
end
return _obf