-- ╔══════════════════════════════════════════╗
-- ║         Games/Rivals.lua                 ║
-- ║  Auto-loaded when PlaceId = 2788229376   ║
-- ╚══════════════════════════════════════════╝
--
-- HOW TOGGLES WORK HERE:
-- Every toggle's Callback receives `state` (true/false).
-- That boolean is passed straight into the feature function.
-- Pattern:  Toggle ON  → feature(true)  → fires logic / connects loop
--           Toggle OFF → feature(false) → disconnects / restores defaults
--
-- Remote firing pattern:
--   When a toggle turns on, we fire a RemoteEvent or call a function.
--   When it turns off, we stop firing / restore state.

local Library      = _G.Library
local Tabs         = _G.Tabs
local _Toggles     = Toggles   -- from LinoriaLib getgenv()
local _Options     = Options   -- from LinoriaLib getgenv()

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- ── WAIT FOR CHARACTER ─────────────────────
local function GetChar()  return LocalPlayer.Character end
local function GetHum()
    local c = GetChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function GetRoot()
    local c = GetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- ══════════════════════════════════════════
-- UTILITY: connection store so we can
-- disconnect loops when toggles turn OFF
-- ══════════════════════════════════════════
local Connections = {}

local function Connect(id, signal, fn)
    if Connections[id] then
        Connections[id]:Disconnect()
    end
    Connections[id] = signal:Connect(fn)
end

local function Disconnect(id)
    if Connections[id] then
        Connections[id]:Disconnect()
        Connections[id] = nil
    end
end

-- ══════════════════════════════════════════
--  RIVALS — find remotes
--  (update these names if Rivals patches)
-- ══════════════════════════════════════════
local RS      = game:GetService("ReplicatedStorage")

-- Helper: wait safely for a remote, returns nil if not found after timeout
local function FindRemote(name, timeout)
    timeout = timeout or 5
    local found = nil
    local t = tick()
    repeat
        found = RS:FindFirstChild(name, true)
        task.wait(0.1)
    until found or (tick() - t) > timeout
    return found
end

-- ══════════════════════════════════════════
--           MAIN TAB
-- ══════════════════════════════════════════
local CombatLeft  = Tabs.Main:AddLeftGroupbox("Combat")
local CombatRight = Tabs.Main:AddRightGroupbox("Misc")

-- ── SPEED HACK ─────────────────────────────
-- Toggle ON  → sets WalkSpeed to slider value
-- Toggle OFF → restores default (16)
local function ApplySpeed(state)
    local hum = GetHum()
    if not hum then return end
    hum.WalkSpeed = state and _Options.RivalsSpeed.Value or 16
end

CombatLeft:AddToggle("RivalsSpeedOn", {
    Text     = "Speed Hack",
    Default  = false,
    Tooltip  = "Boosts walk speed",
    Callback = function(state) ApplySpeed(state) end,
})

CombatLeft:AddSlider("RivalsSpeed", {
    Text     = "Walk Speed",
    Default  = 50,
    Min      = 16,
    Max      = 300,
    Rounding = 0,
    Callback = function(val)
        if _Toggles.RivalsSpeedOn.Value then ApplySpeed(true) end
    end,
})

-- Keep speed applied after respawn
Connect("SpeedRespawn", LocalPlayer.CharacterAdded, function()
    task.wait(1)
    if _Toggles.RivalsSpeedOn.Value then ApplySpeed(true) end
end)

-- ── HIGH JUMP ──────────────────────────────
local function ApplyJump(state)
    local hum = GetHum()
    if not hum then return end
    hum.JumpPower = state and _Options.RivalsJumpPow.Value or 50
end

CombatLeft:AddToggle("RivalsJumpOn", {
    Text     = "High Jump",
    Default  = false,
    Callback = function(state) ApplyJump(state) end,
})

CombatLeft:AddSlider("RivalsJumpPow", {
    Text     = "Jump Power",
    Default  = 120,
    Min      = 50,
    Max      = 500,
    Rounding = 0,
    Callback = function(val)
        if _Toggles.RivalsJumpOn.Value then ApplyJump(true) end
    end,
})

-- ── INFINITE JUMP ──────────────────────────
-- Toggle ON  → connects JumpRequest to force jump state
-- Toggle OFF → disconnects
CombatLeft:AddToggle("RivalsInfJump", {
    Text     = "Infinite Jump",
    Default  = false,
    Callback = function(state)
        if state then
            Connect("InfJump", UserInputService.JumpRequest, function()
                local hum = GetHum()
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        else
            Disconnect("InfJump")
        end
    end,
})

CombatLeft:AddDivider()

-- ── NOCLIP ─────────────────────────────────
-- Toggle ON  → per-step cancels collision on character parts
-- Toggle OFF → restores CanCollide
CombatLeft:AddToggle("RivalsNoclip", {
    Text     = "Noclip",
    Default  = false,
    Tooltip  = "Walk through walls",
    Callback = function(state)
        if state then
            Connect("Noclip", RunService.Stepped, function()
                local char = GetChar()
                if not char then return end
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        else
            Disconnect("Noclip")
            -- restore
            local char = GetChar()
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

-- ── ANTI VOID ──────────────────────────────
-- Toggle ON  → every heartbeat checks Y position
-- Toggle OFF → disconnects the check
CombatLeft:AddToggle("RivalsAntiVoid", {
    Text    = "Anti Void",
    Default = true,
    Tooltip = "Teleports you to spawn if you fall below Y -150",
    Callback = function(state)
        if state then
            Connect("AntiVoid", RunService.Heartbeat, function()
                local root = GetRoot()
                if root and root.Position.Y < -150 then
                    root.CFrame = CFrame.new(0, 10, 0)
                    Library:Notify("Anti Void triggered!", 2)
                end
            end)
        else
            Disconnect("AntiVoid")
        end
    end,
})

-- run anti void at start since Default = true
do
    Connect("AntiVoid", RunService.Heartbeat, function()
        local root = GetRoot()
        if root and root.Position.Y < -150 then
            root.CFrame = CFrame.new(0, 10, 0)
        end
    end)
end

-- ── RIGHT: MISC ────────────────────────────

-- AUTO RESPAWN
-- Toggle ON  → connects Humanoid.Died to call LoadCharacter
-- Toggle OFF → disconnects
CombatRight:AddToggle("RivalsAutoRespawn", {
    Text     = "Auto Respawn",
    Default  = false,
    Callback = function(state)
        if state then
            local char = GetChar()
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    Connect("AutoRespawn", hum.Died, function()
                        task.wait(1)
                        if _Toggles.RivalsAutoRespawn.Value then
                            LocalPlayer:LoadCharacter()
                        end
                    end)
                end
            end
            -- also reconnect on each new character
            Connect("AutoRespawnChar", LocalPlayer.CharacterAdded, function(newChar)
                local hum = newChar:WaitForChild("Humanoid", 5)
                if hum then
                    Connect("AutoRespawn", hum.Died, function()
                        task.wait(1)
                        if _Toggles.RivalsAutoRespawn.Value then
                            LocalPlayer:LoadCharacter()
                        end
                    end)
                end
            end)
        else
            Disconnect("AutoRespawn")
            Disconnect("AutoRespawnChar")
        end
    end,
})

-- ANTI AIM (spin)
CombatRight:AddToggle("RivalsAntiAim", {
    Text     = "Anti Aim  (Spin)",
    Default  = false,
    Tooltip  = "Spins your HRP to confuse hitboxes",
    Callback = function(state)
        if state then
            local angle = 0
            Connect("AntiAim", RunService.RenderStepped, function(dt)
                angle = angle + _Options.RivalsSpinSpeed.Value * dt * 60
                local root = GetRoot()
                if root then
                    root.CFrame = CFrame.new(root.Position)
                        * CFrame.Angles(0, math.rad(angle), 0)
                end
            end)
        else
            Disconnect("AntiAim")
        end
    end,
})

CombatRight:AddSlider("RivalsSpinSpeed", {
    Text     = "Spin Speed",
    Default  = 12,
    Min      = 1,
    Max      = 60,
    Rounding = 0,
})

CombatRight:AddDivider()

-- TELEPORT TO SPAWN
CombatRight:AddButton({
    Text = "Teleport to Spawn",
    Func = function()
        local root = GetRoot()
        if root then
            root.CFrame = CFrame.new(0, 10, 0)
            Library:Notify("Teleported to spawn!", 3)
        end
    end,
})

-- REJOIN
CombatRight:AddButton({
    Text        = "Rejoin Server",
    DoubleClick = true,
    Tooltip     = "Double-click to confirm",
    Func        = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end,
})

-- ══════════════════════════════════════════
--          VISUAL TAB
-- ══════════════════════════════════════════
local ESPBox   = Tabs.Visual:AddLeftGroupbox("ESP")
local WorldBox = Tabs.Visual:AddRightGroupbox("World")

-- ── HIGHLIGHT ESP ──────────────────────────
-- Toggle ON  → creates a SelectionBox for each enemy
-- Toggle OFF → removes all SelectionBoxes
local ESPObjects = {}
local Camera     = workspace.CurrentCamera

local function MakeESP(plr)
    if ESPObjects[plr] then return end
    local box = Instance.new("SelectionBox")
    box.Color3               = _Options.RivalsESPColor.Value
    box.SurfaceColor3        = _Options.RivalsESPColor.Value
    box.SurfaceTransparency  = 0.6
    box.LineThickness        = 0.04
    box.Parent               = Camera

    local function applyChar(char)
        box.Adornee = char
    end

    if plr.Character then applyChar(plr.Character) end
    plr.CharacterAdded:Connect(applyChar)

    ESPObjects[plr] = box
end

local function RemoveESP(plr)
    if ESPObjects[plr] then
        ESPObjects[plr]:Destroy()
        ESPObjects[plr] = nil
    end
end

local function RefreshESP(state)
    if state then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then MakeESP(p) end
        end
    else
        for plr in pairs(ESPObjects) do RemoveESP(plr) end
    end
end

ESPBox:AddToggle("RivalsESP", {
    Text     = "Enable ESP",
    Default  = false,
    Callback = function(state) RefreshESP(state) end,
})

ESPBox:AddLabel("ESP Color"):AddColorPicker("RivalsESPColor", {
    Default = Color3.fromRGB(255, 50, 50),
    Title   = "ESP Box Color",
    Callback = function(color)
        for _, box in pairs(ESPObjects) do
            box.Color3 = color
            box.SurfaceColor3 = color
        end
    end,
})

ESPBox:AddToggle("RivalsESPTeam", {
    Text    = "Team Check",
    Default = true,
    Tooltip = "Skip teammates",
})

Players.PlayerAdded:Connect(function(p)
    if _Toggles.RivalsESP.Value and p ~= LocalPlayer then MakeESP(p) end
end)

Players.PlayerRemoving:Connect(function(p) RemoveESP(p) end)

-- ── WORLD ──────────────────────────────────
-- Toggle ON  → fires fullbright(true)  
-- Toggle OFF → fires fullbright(false)
local Lighting = game:GetService("Lighting")
local _origBrightness = Lighting.Brightness
local _origClock      = Lighting.ClockTime
local _origFogEnd     = Lighting.FogEnd
local _origShadows    = Lighting.GlobalShadows
local _origAmbient    = Lighting.Ambient

local function ApplyFullbright(state)
    if state then
        Lighting.Brightness    = 10
        Lighting.ClockTime     = 14
        Lighting.FogEnd        = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient       = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness    = _origBrightness
        Lighting.ClockTime     = _origClock
        Lighting.FogEnd        = _origFogEnd
        Lighting.GlobalShadows = _origShadows
        Lighting.Ambient       = _origAmbient
    end
end

WorldBox:AddToggle("RivalsFullbright", {
    Text     = "Fullbright",
    Default  = false,
    Callback = function(state) ApplyFullbright(state) end,
})

WorldBox:AddToggle("RivalsNoFog", {
    Text     = "No Fog",
    Default  = false,
    Callback = function(state)
        Lighting.FogEnd = state and 100000 or _origFogEnd
    end,
})

-- ══════════════════════════════════════════
--          PLAYER TAB
-- ══════════════════════════════════════════
local CharBox = Tabs.Player:AddLeftGroupbox("Character")
local InfoBox = Tabs.Player:AddRightGroupbox("Info")

-- FLING (fires velocity on HRP — classic exploit)
-- Toggle ON  → each heartbeat applies upward velocity
-- Toggle OFF → stops
CharBox:AddToggle("RivalsFlying", {
    Text     = "Fly",
    Default  = false,
    Callback = function(state)
        if state then
            local bv -- BodyVelocity
            Connect("Fly", RunService.Heartbeat, function()
                local root = GetRoot()
                if not root then return end
                if not bv or not bv.Parent then
                    bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    bv.Velocity = Vector3.zero
                    bv.Parent   = root
                end
                local cf    = workspace.CurrentCamera.CFrame
                local speed = _Options.RivalsFlySpeed.Value
                local vel   = Vector3.zero
                local uis   = UserInputService

                if uis:IsKeyDown(Enum.KeyCode.W) then vel = vel + cf.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then vel = vel - cf.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then vel = vel - cf.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then vel = vel + cf.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0,1,0) end
                if uis:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel - Vector3.new(0,1,0) end

                bv.Velocity = vel.Magnitude > 0 and vel.Unit * speed or Vector3.zero
            end)
        else
            Disconnect("Fly")
            local root = GetRoot()
            if root then
                local bv = root:FindFirstChildOfClass("BodyVelocity")
                if bv then bv:Destroy() end
            end
        end
    end,
})

CharBox:AddSlider("RivalsFlySpeed", {
    Text     = "Fly Speed",
    Default  = 60,
    Min      = 10,
    Max      = 300,
    Rounding = 0,
})

CharBox:AddDivider()

-- GODMODE attempt (client-side health lock)
CharBox:AddToggle("RivalsGodMode", {
    Text     = "God Mode  (client)",
    Default  = false,
    Tooltip  = "Locks health on client — server may still kill you",
    Callback = function(state)
        if state then
            Connect("GodMode", RunService.Heartbeat, function()
                local hum = GetHum()
                if hum then hum.Health = hum.MaxHealth end
            end)
        else
            Disconnect("GodMode")
        end
    end,
})

-- INFO
InfoBox:AddLabel("Player: " .. LocalPlayer.Name)
InfoBox:AddLabel("User ID: " .. LocalPlayer.UserId)
InfoBox:AddLabel("Account Age: " .. LocalPlayer.AccountAge .. "d")
InfoBox:AddDivider()

InfoBox:AddButton({
    Text = "Copy Username",
    Func = function()
        setclipboard(LocalPlayer.Name)
        Library:Notify("Username copied!", 3)
    end,
})

InfoBox:AddButton({
    Text = "Copy User ID",
    Func = function()
        setclipboard(tostring(LocalPlayer.UserId))
        Library:Notify("User ID copied!", 3)
    end,
})

-- ══════════════════════════════════════════
-- CLEANUP on Library unload
-- ══════════════════════════════════════════
Library:OnUnload(function()
    for id in pairs(Connections) do Disconnect(id) end
    for plr in pairs(ESPObjects) do RemoveESP(plr) end
    ApplyFullbright(false)
end)

Library:Notify("Rivals script loaded!", 4)
