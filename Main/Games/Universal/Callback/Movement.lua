local xbtwdjhn=math.random()
local lyfgpqme=math.random()
local fffxinvn=math.random()
local _b = game:GetService("_b")
local _c = game:GetService("_c")
local _d = game:GetService("_d")
local _e = _b._e
local _f = {}
_f.WalkSpeedValue = 16
_f.JumpPowerValue = 50
_f.TPWalkEnabled = false
_f.TPWalkSpeed = 100
_f.InfiniteJumpEnabled = false
_f.RenderConn = nil
_f.HumanoidConnection = nil
local function hookHumanoid(humanoid)
if not humanoid then return end
local _g = humanoid.WalkSpeed
hookfunction(humanoid, "GetPropertyChangedSignal", function(self, prop)
if prop == "WalkSpeed" then
task.defer(function()
if humanoid and humanoid.Parent then
humanoid.WalkSpeed = _f.WalkSpeedValue
end
end)
end
return _g
end)
humanoid.WalkSpeed = _f.WalkSpeedValue
end
local function setupTPWalk()
local _h = workspace.CurrentCamera
local _b = game:GetService("_b")
local _e = _b._e
return _c.RenderStepped:Connect(function()
if not _f.TPWalkEnabled or not _e.Character or not _e.Character:FindFirstChild("HumanoidRootPart") then
return
end
local _i = _e.Character.HumanoidRootPart
local _j = Vector3.new(0, 0, 0)
if _d:IsKeyDown(Enum.KeyCode.W) then
_j = _j + (_h.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
end
if _d:IsKeyDown(Enum.KeyCode.S) then
_j = _j - (_h.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
end
if _d:IsKeyDown(Enum.KeyCode.A) then
_j = _j - _h.CFrame.RightVector
end
if _d:IsKeyDown(Enum.KeyCode.D) then
_j = _j + _h.CFrame.RightVector
end
if _j.Magnitude > 0 then
_j = _j.Unit
_i.CFrame = _i.CFrame + _j * (_f.TPWalkSpeed / 60)
end
end)
end
function _f:SetWalkSpeed(speed)
self.WalkSpeedValue = speed
local _k = _e.Character
if _k and _k:FindFirstChild("Humanoid") then
_k.Humanoid.WalkSpeed = speed
end
end
function _f:SetJumpPower(power)
self.JumpPowerValue = power
local _k = _e.Character
if _k and _k:FindFirstChild("Humanoid") then
_k.Humanoid.JumpPower = power
end
end
function _f:EnableInfiniteJump()
self.InfiniteJumpEnabled = true
_d.InputBegan:Connect(function(input, gameProcessed)
if gameProcessed then return end
if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
local _k = _e.Character
if _k and _k:FindFirstChild("Humanoid") and self.InfiniteJumpEnabled then
_k.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
end
end)
end
function _f:DisableInfiniteJump()
self.InfiniteJumpEnabled = false
end
function _f:EnableTPWalk()
if self.RenderConn then
self.RenderConn:Disconnect()
end
self.TPWalkEnabled = true
self.RenderConn = setupTPWalk()
end
function _f:DisableTPWalk()
if self.RenderConn then
self.RenderConn:Disconnect()
self.RenderConn = nil
end
self.TPWalkEnabled = false
end
function _f:Init()
local _k = _e.Character
if _k and _k:FindFirstChild("Humanoid") then
hookHumanoid(_k.Humanoid)
end
_e.CharacterAdded:Connect(function(newChar)
task.wait(0.1)
if newChar:FindFirstChild("Humanoid") then
hookHumanoid(newChar.Humanoid)
end
end)
end
return _f