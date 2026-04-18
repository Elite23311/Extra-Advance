# Extra-Advance

> Modular Roblox script hub using [LinoriaLib](https://github.com/violin-suzutsuki/LinoriaLib).  
> Users run **one line**. Everything else loads automatically.

---

## Quick Start (for users)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Elite23311/Extra-Advance/main/Loader.lua"))()
```

Paste this into your executor and hit Execute. That's it.

---

## Folder Structure

```
Extra-Advance/
├── Loader.lua            ← Users run this. Edit RAW + GameRoutes here.
├── Features/
│   ├── Main.lua          ← Key system, window, tabs, watermark, addons
│   └── AimAssist.lua     ← Aim assist (loaded after key auth)
├── Games/
│   └── Rivals.lua        ← Rivals-specific features (auto-routed by PlaceId)
└── README.md
```

---

## Setup (for developers)

### 1. Edit `Loader.lua`

Open `Loader.lua` and make sure line 9 says:

```lua
local RAW = "https://raw.githubusercontent.com/Elite23311/Extra-Advance/main/"
```

### 2. Add your keys

Open `Features/Main.lua` and fill in `VALID_KEYS`:

```lua
local VALID_KEYS = {
    ["yourkey123"] = true,
    ["anotherkey"] = true,
}
```

Keys are **case-insensitive**. Once a user enters a valid key it saves locally — they won't need to re-enter it next time.

To **invalidate** all saved keys: just remove the key from the table. Saved keys on disk will fail the check on next run.

### 3. Push changes to GitHub

```bash
git add .
git commit -m "your message"
git push
```

---

## Adding a New Game

1. Find the game's **PlaceId** (visible in the Roblox URL: `roblox.com/games/PLACEID/...`)
2. Create `Games/YourGame.lua`
3. Add an entry in `Loader.lua`:

```lua
local GameRoutes = {
    [2788229376] = "Games/Rivals.lua",
    [YOUR_PLACE_ID] = "Games/YourGame.lua",  -- add here
}
```

---

## Adding a New Feature Module

1. Create `Features/MyFeature.lua`
2. At the top reference the globals set by `Main.lua`:

```lua
local Library  = _G.Library
local Tabs     = _G.Tabs
local _Toggles = Toggles   -- LinoriaLib getgenv()
local _Options = Options   -- LinoriaLib getgenv()
```

3. In `Main.lua` inside `OnAuthenticated()`, add:

```lua
_G.Load("Features/MyFeature.lua")
```

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
