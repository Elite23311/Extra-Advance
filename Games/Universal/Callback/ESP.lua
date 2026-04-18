-- ╔══════════════════════════════════════════╗
-- ║     Games/Universal/Callback/ESP.lua     ║
-- ║  ESP with player rendering options       ║
-- ╚══════════════════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local ESP = {}

ESP.Enabled = false
ESP.Options = {
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
ESP.Drawings = {}
ESP.RenderConn = nil
ESP.ChamsHighlights = {}

function ESP:IsPlayerValid(player)
    if player == LocalPlayer then return false end
    local char = player.Character
    if not char then return false end
    
    if self.Options.TeamCheck and player.Team == LocalPlayer.Team then
        return false
    end
    
    if self.Options.HealthCheck then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
    end
    
    if self.Options.InvisibleCheck then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root and root.Transparency >= 1 then return false end
    end
    
    return true
end

function ESP:CreateBox(char, color)
    local key = char:GetFullName() .. "_box"
    if self.Drawings[key] then
        self.Drawings[key]:Remove()
    end
    
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Color = color
    box.Transparency = 1
    self.Drawings[key] = box
    
    return box
end

function ESP:CreateHealthBar(char, color)
    local key = char:GetFullName() .. "_health"
    if self.Drawings[key] then
        self.Drawings[key]:Remove()
    end
    
    local bar = Drawing.new("Line")
    bar.Thickness = 3
    bar.Color = color
    self.Drawings[key] = bar
    
    return bar
end

function ESP:CreateNameLabel(char, player)
    local key = char:GetFullName() .. "_name"
    if self.Drawings[key] then
        self.Drawings[key]:Remove()
    end
    
    local label = Drawing.new("Text")
    label.Color = Color3.fromRGB(255, 255, 255)
    label.Size = 16
    label.Font = 2
    label.Text = player.Name
    self.Drawings[key] = label
    
    return label
end

function ESP:EnableChams(player)
    if not self.Options.Chams then return end
    
    local char = player.Character
    if not char then return end
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = self.Options.ChamsColor
            highlight.OutlineColor = self.Options.ChamsColor
            highlight.Parent = part
            
            table.insert(self.ChamsHighlights, {
                player = player,
                highlight = highlight,
            })
        end
    end
end

function ESP:Start()
    if self.RenderConn then return end
    self.Enabled = true
    
    for _, player in pairs(Players:GetPlayers()) do
        if self:IsPlayerValid(player) then
            self:EnableChams(player)
        end
    end

    self.RenderConn = RunService.RenderStepped:Connect(function()
        local camera = workspace.CurrentCamera
        
        for _, player in pairs(Players:GetPlayers()) do
            if not self:IsPlayerValid(player) then
                local charName = player.Character and player.Character:GetFullName()
                if charName then
                    for key, drawing in pairs(self.Drawings) do
                        if key:find(charName) then
                            drawing:Remove()
                            self.Drawings[key] = nil
                        end
                    end
                end
                continue
            end
            
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then continue end
            
            local screen, onScreen = camera:WorldToViewportPoint(root.Position)
            if not onScreen then continue end
            
            if self.Options.Name then
                local label = self:CreateNameLabel(char, player)
                label.Position = Vector2.new(screen.X, screen.Y - 30)
            end
            
            if self.Options.Distance then
                local dist = (camera.CFrame.Position - root.Position).Magnitude
                local distLabel = Drawing.new("Text")
                distLabel.Color = Color3.fromRGB(255, 255, 255)
                distLabel.Size = 14
                distLabel.Font = 2
                distLabel.Text = string.format("%.1f", dist) .. "m"
                distLabel.Position = Vector2.new(screen.X, screen.Y + 30)
                table.insert(self.Drawings, distLabel)
            end
        end
    end)
end

function ESP:Stop()
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
        if data.highlight then data.highlight:Destroy() end
    end
    self.ChamsHighlights = {}
end

function ESP:Toggle()
    if self.Enabled then
        self:Stop()
    else
        self:Start()
    end
end

return ESP
