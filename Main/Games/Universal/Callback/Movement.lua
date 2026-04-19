-- [[ Universal/Callback/Movement.lua ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Movement = {}

Movement.WalkSpeedValue = 16
Movement.JumpPowerValue = 50
Movement.TPWalkEnabled = false
Movement.TPWalkSpeed = 100
Movement.InfiniteJumpEnabled = false
Movement.RenderConn = nil
Movement.HumanoidConnection = nil

local function hookHumanoid(humanoid)
    if not humanoid then return end
    
    local original = humanoid.WalkSpeed
    
    hookfunction(humanoid, "GetPropertyChangedSignal", function(self, prop)
        if prop == "WalkSpeed" then
            task.defer(function()
                if humanoid and humanoid.Parent then
                    humanoid.WalkSpeed = Movement.WalkSpeedValue
                end
            end)
        end
        return original
    end)
    
    humanoid.WalkSpeed = Movement.WalkSpeedValue
end

local function setupTPWalk()
    local camera = workspace.CurrentCamera
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    return RunService.RenderStepped:Connect(function()
        if not Movement.TPWalkEnabled or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return
        end

        local root = LocalPlayer.Character.HumanoidRootPart
        local moveDir = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + (camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - (camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camera.CFrame.RightVector
        end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
            root.CFrame = root.CFrame + moveDir * (Movement.TPWalkSpeed / 60)
        end
    end)
end

function Movement:SetWalkSpeed(speed)
    self.WalkSpeedValue = speed
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speed
    end
end

function Movement:SetJumpPower(power)
    self.JumpPowerValue = power
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = power
    end
end

function Movement:EnableInfiniteJump()
    self.InfiniteJumpEnabled = true
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and self.InfiniteJumpEnabled then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

function Movement:DisableInfiniteJump()
    self.InfiniteJumpEnabled = false
end

function Movement:EnableTPWalk()
    if self.RenderConn then
        self.RenderConn:Disconnect()
    end
    self.TPWalkEnabled = true
    self.RenderConn = setupTPWalk()
end

function Movement:DisableTPWalk()
    if self.RenderConn then
        self.RenderConn:Disconnect()
        self.RenderConn = nil
    end
    self.TPWalkEnabled = false
end

function Movement:Init()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        hookHumanoid(char.Humanoid)
    end

    LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(0.1)
        if newChar:FindFirstChild("Humanoid") then
            hookHumanoid(newChar.Humanoid)
        end
    end)
end

return Movement

