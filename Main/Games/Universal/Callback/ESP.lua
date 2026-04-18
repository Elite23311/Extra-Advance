local _npujpal=math.random()
local _niqsqcl=math.random()
local _napdbix=math.random()
local _obb = game:GetService("Players")
local _obc = game:GetService("RunService")
local _obd = _obb._obd
local _obe = {}
_obe.Enabled = false
_obe.Options = {
Chams = false,
ChamsColor = Color3.fromRGB(0, 255, 0),
Box = false,
BoxColor = Color3.fromRGB(0, 255, 0),
HealthBar = false,
Distance = false,
Name = false,
Skeleton = false,
TeamCheck = true,
InvisibleCheck = true,
HealthCheck = true,
}
_obe.Drawings = {}
_obe.RenderConn = nil
_obe.ChamsHighlights = {}
function _obe:IsPlayerValid(player)
if player == _obd then return false end
local _obf = player.Character
if not _obf then return false end
if self.Options.TeamCheck and player.Team == _obd.Team then
return false
end
if self.Options.HealthCheck then
local _obg = _obf:FindFirstChildOfClass("Humanoid")
if not _obg or _obg.Health <= 0 then return false end
end
if self.Options.InvisibleCheck then
local _obh = _obf:FindFirstChild("HumanoidRootPart")
if _obh and _obh.Transparency >= 1 then return false end
end
return true
end
function _obe:CreateBox(_obf, color)
local _obi = _obf:GetFullName() .. "_box"
if self.Drawings[_obi] then
self.Drawings[_obi]:Remove()
end
local _obj = Drawing.new("Square")
_obj.Thickness = 2
_obj.Filled = false
_obj.Color = color
_obj.Transparency = 1
self.Drawings[_obi] = _obj
return _obj
end
function _obe:CreateHealthBar(_obf, color)
local _obi = _obf:GetFullName() .. "_health"
if self.Drawings[_obi] then
self.Drawings[_obi]:Remove()
end
local _obk = Drawing.new("Line")
_obk.Thickness = 3
_obk.Color = color
self.Drawings[_obi] = _obk
return _obk
end
function _obe:CreateNameLabel(_obf, player)
local _obi = _obf:GetFullName() .. "_name"
if self.Drawings[_obi] then
self.Drawings[_obi]:Remove()
end
local _obl = Drawing.new("Text")
_obl.Color = Color3.fromRGB(255, 255, 255)
_obl.Size = 16
_obl.Font = 2
_obl.Text = player.Name
self.Drawings[_obi] = _obl
return _obl
end
function _obe:EnableChams(player)
if not self.Options.Chams then return end
local _obf = player.Character
if not _obf then return end
for _, part in pairs(_obf:GetDescendants()) do
if part:IsA("BasePart") then
local _obm = Instance.new("Highlight")
_obm.FillColor = self.Options.ChamsColor
_obm.OutlineColor = self.Options.ChamsColor
_obm.Parent = part
table.insert(self.ChamsHighlights, {
player = player,
_obm = _obm,
})
end
end
end
function _obe:Start()
if self.RenderConn then return end
self.Enabled = true
for _, player in pairs(_obb:GetPlayers()) do
if self:IsPlayerValid(player) then
self:EnableChams(player)
end
end
self.RenderConn = _obc.RenderStepped:Connect(function()
local _obn = workspace.CurrentCamera
for _, player in pairs(_obb:GetPlayers()) do
if not self:IsPlayerValid(player) then
local _obo = player.Character and player.Character:GetFullName()
if _obo then
for _obi, drawing in pairs(self.Drawings) do
if _obi:find(_obo) then
drawing:Remove()
self.Drawings[_obi] = nil
end
end
end
continue
end
local _obf = player.Character
local _obh = _obf:FindFirstChild("HumanoidRootPart")
if not _obh then continue end
local _obp, onScreen = _obn:WorldToViewportPoint(_obh.Position)
if not onScreen then continue end
if self.Options.Name then
local _obl = self:CreateNameLabel(_obf, player)
_obl.Position = Vector2.new(_obp.X, _obp.Y - 30)
end
if self.Options.Distance then
local _obq = (_obn.CFrame.Position - _obh.Position).Magnitude
local _obr = Drawing.new("Text")
_obr.Color = Color3.fromRGB(255, 255, 255)
_obr.Size = 14
_obr.Font = 2
_obr.Text = string.format("%.1f", _obq) .. "m"
_obr.Position = Vector2.new(_obp.X, _obp.Y + 30)
table.insert(self.Drawings, _obr)
end
end
end)
end
function _obe:Stop()
self.Enabled = false
if self.RenderConn then
self.RenderConn:Disconnect()
self.RenderConn = nil
end
for _, drawing in pairs(self.Drawings) do
if drawing then drawing:Remove() end
end
self.Drawings = {}
for _, data in pairs(self.ChamsHighlights) do
if data._obm then data._obm:Destroy() end
end
self.ChamsHighlights = {}
end
function _obe:Toggle()
if self.Enabled then
self:Stop()
else
self:Start()
end
end
return _obe