# ScriptHub — LinoriaLib Edition

> Modular Roblox script hub using [LinoriaLib](https://github.com/violin-suzutsuki/LinoriaLib).  
> Users run **one line**. Everything else loads automatically.

---

## Quick Start (for users)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/Loader.lua"))()
```

Paste this into your executor and hit Execute. That's it.

---

## Folder Structure

```
YourRepo/
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

### 1. Create your GitHub repo

Make it **public** so raw URLs work.

### 2. Edit `Loader.lua`

Open `Loader.lua` and change line 9:

```lua
local RAW = "https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/"
```

Replace `YOUR_USER` and `YOUR_REPO` with your actual GitHub username and repo name.

### 3. Add your keys

Open `Features/Main.lua` and fill in `VALID_KEYS`:

```lua
local VALID_KEYS = {
    ["yourkey123"] = true,
    ["anotherkey"] = true,
}
```

Keys are **case-insensitive**. Once a user enters a valid key it saves locally — they won't need to re-enter it next time.

To **invalidate** all saved keys: just remove the key from the table. Saved keys on disk will fail the check on next run.

### 4. Push to GitHub

Keep the exact folder structure. Every file must be at the same relative path as shown above.

### 5. Users execute

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/Loader.lua"))()
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

The correct file loads automatically when a user runs the script in that game.

---

## Adding a New Feature Module

1. Create `Features/MyFeature.lua`
2. At the top of the file, reference globals set by `Main.lua`:

```lua
local Library  = _G.Library
local Tabs     = _G.Tabs
local _Toggles = Toggles   -- LinoriaLib getgenv()
local _Options = Options   -- LinoriaLib getgenv()
```

3. In `Main.lua`, inside `OnAuthenticated()`, add:

```lua
_G.Load("Features/MyFeature.lua")
```

---

## How Toggles Work (the toggle → fires lua pattern)

Every toggle in this hub follows the same pattern:

```lua
GroupBox:AddToggle("MyFeatureOn", {
    Text     = "My Feature",
    Default  = false,
    Callback = function(state)  -- state is true or false
        if state then
            -- Feature turned ON: start loop / connect signal / apply change
        else
            -- Feature turned OFF: disconnect loop / restore defaults
        end
    end,
})
```

### Example: toggle that connects/disconnects a loop

```lua
local Connections = {}

GroupBox:AddToggle("SpeedOn", {
    Text     = "Speed Hack",
    Default  = false,
    Callback = function(state)
        if state then
            -- ON: apply speed
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Options.SpeedValue.Value end

            -- or connect a loop:
            Connections.Speed = RunService.Heartbeat:Connect(function()
                local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if h then h.WalkSpeed = Options.SpeedValue.Value end
            end)
        else
            -- OFF: restore and disconnect
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

### Example: toggle that fires a RemoteEvent

```lua
local Remote = game:GetService("ReplicatedStorage"):WaitForChild("SomeRemote")

GroupBox:AddToggle("RemoteFeature", {
    Text     = "Fire Remote Feature",
    Default  = false,
    Callback = function(state)
        if state then
            -- Fire the remote with true
            Remote:FireServer(true)
            -- Start a loop to keep it active if needed
            Connections.Remote = RunService.Heartbeat:Connect(function()
                Remote:FireServer(true)
            end)
        else
            -- Fire with false to tell server we stopped
            Remote:FireServer(false)
            if Connections.Remote then
                Connections.Remote:Disconnect()
                Connections.Remote = nil
            end
        end
    end,
})
```

### Example: reading a slider value inside a toggle callback

```lua
GroupBox:AddToggle("JumpOn", {
    Text     = "High Jump",
    Default  = false,
    Callback = function(state)
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        -- Read the slider's current value using Options
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
        -- When slider changes, re-apply if toggle is on
        if Toggles.JumpOn.Value then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = val end
        end
    end,
})
```

---

## Global Variables Reference

All modules can access these after `Main.lua` runs:

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

## LinoriaLib Element Quick Reference

### Toggle
```lua
Box:AddToggle("ID", { Text = "Label", Default = false, Callback = function(state) end })
Toggles.ID.Value          -- get current state
Toggles.ID:SetValue(true) -- set state
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
Options.ID.Value  -- returns selected string
```

### Button
```lua
Box:AddButton({ Text = "Click me", Func = function() end, DoubleClick = false })
```

### Input (textbox)
```lua
Box:AddInput("ID", { Default = "", Finished = true, Text = "Label", Placeholder = "..." })
Options.ID.Value  -- returns current string
```

### Color Picker
```lua
Box:AddLabel("Color"):AddColorPicker("ID", { Default = Color3.fromRGB(255,0,0) })
Options.ID.Value  -- returns Color3
```

### Keybind
```lua
Box:AddLabel("Keybind"):AddKeyPicker("ID", { Default = "MB2", Mode = "Toggle" })
Options.ID:GetState()  -- true/false
```

---

## Notes

- **LinoriaLib** puts `Toggles` and `Options` into `getgenv()` automatically — you don't need to do `_G.Toggles`. Just use `Toggles` and `Options` directly anywhere.
- Always create **all UI elements first**, then set up `:OnChanged` callbacks after. This is the LinoriaLib-recommended pattern.
- `SaveManager:LoadAutoloadConfig()` must be called **last** so all elements exist before config values are applied.
#   E x t r a - A d v a n c e  
 #   E x t r a - A d v a n c e  
 