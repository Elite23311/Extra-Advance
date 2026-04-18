# Extra Advance - Universal Roblox Hacks Framework

A powerful, modular exploit framework for Roblox with universal hacks and game-specific modules. Built with advanced obfuscation for security and stability.

## Features

### Universal Hacks (All Games)

#### Movement
- **Fly** - Camera-relative flight with customizable speed
- **Walk Speed** - Adjust player movement speed
- **Jump Power** - Customize jump height
- **TP Walk** - Teleport-based movement
- **Infinite Jump** - Unlimited jumping ability

#### Combat
- **Aimbot** - Automatic aiming with FOV circle and smoothness control
- **Silent Aimbot** - Aim without moving camera, includes shot chance and headshot chance
- **Desync** - Raknet packet modification with visual indicator

#### Visuals
- **ESP** - Player rendering with:
  - Chams (colored player bodies)
  - Box ESP (bounding boxes)
  - Health bars
  - Skeleton display
  - Distance counter
  - Player names
  - Team/Invisible/Health filters
- **Fullbright** - Increase brightness
- **XRay** - See through objects
- **FPS Boost** - Optimize performance

### Game-Specific Hacks

#### Rivals (PlaceId: 17625359962)
- **AimAssist** - Game-specific aiming enhancements

## Installation

### Method 1: Direct Load (Recommended)
1. Open your Roblox executor (Synapse X, Script-Ware, etc.)
2. Copy this command:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/Extra-Advance/main/Loader.lua"))()
```
3. Execute in the game

### Method 2: Copy Code
1. Download `Loader.lua` from this repository
2. Paste into your executor
3. Execute

## Usage

### First Time Setup
1. When you first load the script, you'll see a key validation window
2. Use a valid authentication key
3. The main GUI will appear once authenticated

### Main GUI

**Tabs:**
- **Main** - Core hacks (Fly, Movement, Desync)
- **Visual** - ESP, Fullbright, XRay, FPS Boost
- **Player** - Aimbot and Silent Aimbot settings
- **Settings** - UI customization and keybinds

### Key Features

#### Fly
- Toggle: Use keybind or click toggle
- Speed: Adjust flight speed (default: 50)
- WASD: Move relative to camera direction

#### Aimbot
- **FOV**: Radius of aiming circle (default: 100)
- **Smoothness**: Aim smoothing (default: 0.5)
- **Lock Part**: Choose body part to aim (Head, Torso, etc.)
- **Shot Chance**: Success rate for shots (%)

#### Silent Aimbot
- Aims without moving your camera
- **Headshot Chance**: Chance to aim head vs body
- Useful for undetected gameplay

#### Desync
- Modifies Raknet packets for player position manipulation
- Shows visual circle indicator when active
- Notifications on toggle

#### ESP
- Customizable rendering options
- Filter by team, invisibility, or health status
- Real-time distance and health display

### Configuration

All settings are adjustable in the GUI:
- Toggle features on/off
- Adjust numeric values (speed, FOV, etc.)
- Change keybinds
- Customize UI theme

Settings are saved automatically per-game.

## Compatibility

- **Works on:** Most Roblox games
- **Optimized for:** Rivals and FPS-style games
- **Requires:** Working Roblox executor with loadstring support

## Performance

- Lightweight (~50KB obfuscated)
- Optimized callback system
- Minimal impact on game FPS
- Built-in FPS boost module

## Important Notes

- ⚠️ Use at your own risk
- Always check game ToS before using
- Disable before playing other games or public servers
- Keep exploits private - don't share with non-devs

## Support

- Check that you have a valid executor installed
- Ensure your executor supports `loadstring()`
- Try restarting your game if features don't work
- Update your executor if experiencing crashes

## Legal

This is for educational and authorized testing purposes only. Users are responsible for complying with Roblox Terms of Service and game-specific rules. The author is not responsible for bans or legal issues resulting from misuse.

---

**Current Version:** Enterprise Obfuscated Build  
**Last Updated:** April 2026

---

## How Toggles Work

Every toggle follows the same pattern — `state` is `true` when turned on, `false` when turned off:

```lua
GroupBox:AddToggle("MyFeatureOn", {
    Text     = "My Feature",
    Default  = false,
    Callback = function(state)
        if state then
            -- Feature ON: connect loop / apply change / fire remote
        else
            -- Feature OFF: disconnect loop / restore defaults
        end
    end,
})
```

### Toggle that connects/disconnects a loop

```lua
local Connections = {}

GroupBox:AddToggle("SpeedOn", {
    Text     = "Speed Hack",
    Default  = false,
    Callback = function(state)
        if state then
            Connections.Speed = RunService.Heartbeat:Connect(function()
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = Options.SpeedValue.Value end
            end)
        else
            if Connections.Speed then
                Connections.Speed:Disconnect()
                Connections.Speed = nil
            end
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end,
})
```

### Toggle that fires a RemoteEvent

```lua
local Remote = game:GetService("ReplicatedStorage"):WaitForChild("SomeRemote")

GroupBox:AddToggle("RemoteFeature", {
    Text     = "Remote Feature",
    Default  = false,
    Callback = function(state)
        if state then
            Remote:FireServer(true)
            Connections.Remote = RunService.Heartbeat:Connect(function()
                Remote:FireServer(true)
            end)
        else
            Remote:FireServer(false)
            if Connections.Remote then
                Connections.Remote:Disconnect()
                Connections.Remote = nil
            end
        end
    end,
})
```

### Toggle + Slider working together

```lua
GroupBox:AddToggle("JumpOn", {
    Text     = "High Jump",
    Default  = false,
    Callback = function(state)
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hum.JumpPower = state and Options.JumpPowerSlider.Value or 50
    end,
})

GroupBox:AddSlider("JumpPowerSlider", {
    Text     = "Jump Power",
    Default  = 120,
    Min      = 50,
    Max      = 500,
    Rounding = 0,
    Callback = function(val)
        if Toggles.JumpOn.Value then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = val end
        end
    end,
})
```

---

## Global Variables Reference

| Variable | Type | Description |
|---|---|---|
| `_G.Library` | table | LinoriaLib Library object |
| `_G.Window` | table | The created Window |
| `_G.Tabs` | table | `{ Main, Visual, Player, Settings }` |
| `_G.ThemeManager` | table | ThemeManager addon |
| `_G.SaveManager` | table | SaveManager addon |
| `_G.Load(path)` | function | Loads a file from your raw GitHub URL |
| `Toggles` | table | LinoriaLib getgenv() — index by toggle ID |
| `Options` | table | LinoriaLib getgenv() — index by slider/dropdown/etc ID |

---

## LinoriaLib Quick Reference

### Toggle
```lua
Box:AddToggle("ID", { Text = "Label", Default = false, Callback = function(state) end })
Toggles.ID.Value          -- current state (bool)
Toggles.ID:SetValue(true)
Toggles.ID:OnChanged(function() end)
```

### Slider
```lua
Box:AddSlider("ID", { Text = "Label", Default = 50, Min = 0, Max = 100, Rounding = 0 })
Options.ID.Value
Options.ID:SetValue(75)
Options.ID:OnChanged(function() end)
```

### Dropdown
```lua
Box:AddDropdown("ID", { Values = {"A","B","C"}, Default = 1, Text = "Label" })
Options.ID.Value  -- selected string
```

### Button
```lua
Box:AddButton({ Text = "Click me", Func = function() end, DoubleClick = false })
```

### Input
```lua
Box:AddInput("ID", { Default = "", Finished = true, Text = "Label", Placeholder = "..." })
Options.ID.Value  -- current string
```

### Color Picker
```lua
Box:AddLabel("Color"):AddColorPicker("ID", { Default = Color3.fromRGB(255,0,0) })
Options.ID.Value  -- Color3
```

### Keybind
```lua
Box:AddLabel("Keybind"):AddKeyPicker("ID", { Default = "MB2", Mode = "Toggle" })
Options.ID:GetState()  -- true/false
```

---

## Notes

- `Toggles` and `Options` are in `getgenv()` automatically from LinoriaLib — use them directly, no `_G` needed.
- Always create all UI elements **first**, then set up `:OnChanged` callbacks after.
- `SaveManager:LoadAutoloadConfig()` must be called **last** so all elements exist before config values are applied.
