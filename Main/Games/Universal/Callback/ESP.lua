local bluxjqah=math.random()
local xjyqrytx=math.random()
local jycsqugv=math.random()
local _b = game:GetService("_b")
local _c = game:GetService("_c")
local _d = _b._d
local _e = {}
_e.Enabled = false
_e.Options = {
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
_e.Drawings = {}
_e.RenderConn = nil
_e.ChamsHighlights = {}
function _e:IsPlayerValid(player)
if player == _d then return false end
local _f = player.Character
if not _f then return false end
if self.Options.TeamCheck and player.Team == _d.Team then
return false
end
if self.Options.HealthCheck then
local _g = _f:FindFirstChildOfClass("Humanoid")
if not _g or _g.Health <= 0 then return false end
end
if self.Options.InvisibleCheck then
local _h = _f:FindFirstChild("HumanoidRootPart")
if _h and _h.Transparency >= 1 then return false end
end
return true
end
function _e:CreateBox(_f, color)
local _i = _f:GetFullName() .. "_box"
if self.Drawings[_i] then
self.Drawings[_i]:Remove()
end
local _j = Drawing.new("Square")
_j.Thickness = 2
_j.Filled = false
_j.Color = color
_j.Transparency = 1
self.Drawings[_i] = _j
return _j
end
function _e:CreateHealthBar(_f, color)
local _i = _f:GetFullName() .. "_health"
if self.Drawings[_i] then
self.Drawings[_i]:Remove()
end
local _k = Drawing.new("Line")
_k.Thickness = 3
_k.Color = color
self.Drawings[_i] = _k
return _k
end
function _e:CreateNameLabel(_f, player)
local _i = _f:GetFullName() .. "_name"
if self.Drawings[_i] then
self.Drawings[_i]:Remove()
end
local _l = Drawing.new("Text")
_l.Color = Color3.fromRGB(255, 255, 255)
_l.Size = 16
_l.Font = 2
_l.Text = player.Name
self.Drawings[_i] = _l
return _l
end
function _e:EnableChams(player)
if not self.Options.Chams then return end
local _f = player.Character
if not _f then return end
for _, part in pairs(_f:GetDescendants()) do
if part:IsA("BasePart") then
local _m = Instance.new("Highlight")
_m.FillColor = self.Options.ChamsColor
_m.OutlineColor = self.Options.ChamsColor
_m.Parent = part
table.insert(self.ChamsHighlights, {
player = player,
_m = _m,
})
end
end
end
function _e:Start()
if self.RenderConn then return end
self.Enabled = true
for _, player in pairs(_b:GetPlayers()) do
if self:IsPlayerValid(player) then
self:EnableChams(player)
end
end
self.RenderConn = _c.RenderStepped:Connect(function()
local _n = workspace.CurrentCamera
for _, player in pairs(_b:GetPlayers()) do
if not self:IsPlayerValid(player) then
local _o = player.Character and player.Character:GetFullName()
if _o then
for _i, drawing in pairs(self.Drawings) do
if _i:find(_o) then
drawing:Remove()
self.Drawings[_i] = nil
end
end
end
continue
end
local _f = player.Character
local _h = _f:FindFirstChild("HumanoidRootPart")
if not _h then continue end
local _p, onScreen = _n:WorldToViewportPoint(_h.Position)
if not onScreen then continue end
if self.Options.Name then
local _l = self:CreateNameLabel(_f, player)
_l.Position = Vector2.new(_p.X, _p.Y - 30)
end
if self.Options.Distance then
local _q = (_n.CFrame.Position - _h.Position).Magnitude
local _r = Drawing.new("Text")
_r.Color = Color3.fromRGB(255, 255, 255)
_r.Size = 14
_r.Font = 2
_r.Text = string.format("%.1f", _q) .. "m"
_r.Position = Vector2.new(_p.X, _p.Y + 30)
table.insert(self.Drawings, _r)
end
end
end)
end
function _e:Stop()
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
if data._m then data._m:Destroy() end
end
self.ChamsHighlights = {}
end
function _e:Toggle()
if self.Enabled then
self:Stop()
else
self:Start()
end
end
return _e