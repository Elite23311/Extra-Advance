-- [[ Universal/Callback/Visual.lua ]] --

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local Visual = {}

Visual.OriginalLighting = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
}

Visual.OriginalTransparencies = {}
Visual.FullbrightEnabled = false
Visual.XRayEnabled = false
Visual.XRayTransparency = 0.3
Visual.FPSBoostEnabled = false
Visual.FPSBoostConn = nil

function Visual:EnableFullbright()
    if self.FullbrightEnabled then return end
    self.FullbrightEnabled = true
    
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end

function Visual:DisableFullbright()
    if not self.FullbrightEnabled then return end
    self.FullbrightEnabled = false
    
    Lighting.Brightness = self.OriginalLighting.Brightness
    Lighting.Ambient = self.OriginalLighting.Ambient
    Lighting.OutdoorAmbient = self.OriginalLighting.OutdoorAmbient
end

function Visual:EnableXRay()
    if self.XRayEnabled then return end
    self.XRayEnabled = true
    
    local function setTransparency(part, amount)
        if part:IsA("BasePart") then
            self.OriginalTransparencies[part] = part.Transparency
            part.Transparency = amount
        end
    end

    for _, part in pairs(workspace:GetDescendants()) do
        setTransparency(part, self.XRayTransparency)
    end

    workspace.DescendantAdded:Connect(function(part)
        if self.XRayEnabled then
            setTransparency(part, self.XRayTransparency)
        end
    end)
end

function Visual:DisableXRay()
    if not self.XRayEnabled then return end
    self.XRayEnabled = false
    
    for part, transparency in pairs(self.OriginalTransparencies) do
        if part and part.Parent then
            part.Transparency = transparency
        end
    end
    self.OriginalTransparencies = {}
end

function Visual:SetXRayTransparency(amount)
    self.XRayTransparency = math.clamp(amount, 0, 1)
    
    if self.XRayEnabled then
        for part, _ in pairs(self.OriginalTransparencies) do
            if part and part.Parent and part:IsA("BasePart") then
                part.Transparency = self.XRayTransparency
            end
        end
    end
end

function Visual:EnableFPSBoost()
    if self.FPSBoostEnabled then return end
    self.FPSBoostEnabled = true
    
    -- Reduce update frequency
    local renderConnection
    renderConnection = RunService.RenderStepped:Connect(function()
        if self.FPSBoostEnabled then
            -- Reduce particle emissions, shadow updates, etc.
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("ParticleEmitter") then
                    part.Enabled = false
                end
            end
        else
            renderConnection:Disconnect()
        end
    end)
    
    self.FPSBoostConn = renderConnection
end

function Visual:DisableFPSBoost()
    if not self.FPSBoostEnabled then return end
    self.FPSBoostEnabled = false
    
    if self.FPSBoostConn then
        self.FPSBoostConn:Disconnect()
        self.FPSBoostConn = nil
    end
    
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("ParticleEmitter") then
            part.Enabled = true
        end
    end
end

return Visual

