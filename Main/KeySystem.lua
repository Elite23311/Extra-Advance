-- [[ KeySystem.lua ]] --
-- Standalone Custom Key System UI

local TweenService = game:GetService("TweenService")
local RAW = "https://raw.githubusercontent.com/Elite23311/Extra-Advance/main/Main/"

local function decode(arr)
    local t = {}
    for i = 1, #arr do
        t[i] = string.char(arr[i])
    end
    return table.concat(t)
end

local KEY_FOLDER = decode({83, 99, 114, 105, 112, 116, 72, 117, 98}) -- ScriptHub
local KEY_FILE   = KEY_FOLDER .. "/" .. decode({107, 101, 121, 46, 116, 120, 116}) -- key.txt

local VALID_KEYS = {
    [decode({121, 111, 117, 114, 107, 101, 121, 49, 50, 51})] = true,
    [decode({116, 101, 115, 116, 107, 101, 121})]             = true,
    ["eatest"]                                                 = true,
}

-- ──────────────────────────────────────────
-- Key Helpers
-- ──────────────────────────────────────────

local function SaveKey(key)
    if not isfolder(KEY_FOLDER) then makefolder(KEY_FOLDER) end
    writefile(KEY_FILE, key)
end

local function GetSavedKey()
    if isfile(KEY_FILE) then
        return readfile(KEY_FILE):match("^%s*(.-)%s*$")
    end
end

local function CheckKey(key)
    if not key or key == "" then return false end
    local cleanKey = key:gsub("%s+", ""):lower()
    return VALID_KEYS[cleanKey] == true
end

local function LoadLoader()
    print("[Extra Advance] Auth success. Loading features...")
    local success, err = pcall(function()
        loadstring(game:HttpGet(RAW .. "Loader.lua" .. "?v=" .. tick()))()
    end)
    if not success then
        warn("[Extra Advance] Loader failed: " .. tostring(err))
    end
end

-- ──────────────────────────────────────────
-- Auto-Auth Check
-- ──────────────────────────────────────────

local saved = GetSavedKey()
if CheckKey(saved) then
    LoadLoader()
    return
end

-- ──────────────────────────────────────────
-- UI Setup
-- ──────────────────────────────────────────

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExtraAdvanceKeySystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- Backdrop blur
local BlurFrame = Instance.new("Frame")
BlurFrame.Name = "Backdrop"
BlurFrame.Size = UDim2.new(1, 0, 1, 0)
BlurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlurFrame.BackgroundTransparency = 0.5
BlurFrame.ZIndex = 0
BlurFrame.Parent = ScreenGui

-- Main Card
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 0) -- starts at 0 height for animation
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 1
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Accent bar at top
local AccentBar = Instance.new("Frame")
AccentBar.Name = "AccentBar"
AccentBar.Size = UDim2.new(1, 0, 0, 3)
AccentBar.Position = UDim2.new(0, 0, 0, 0)
AccentBar.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
AccentBar.BorderSizePixel = 0
AccentBar.ZIndex = 2
AccentBar.Parent = MainFrame

local AccentGrad = Instance.new("UIGradient")
AccentGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255)),
})
AccentGrad.Parent = AccentBar

-- Logo / Title area
local LogoLabel = Instance.new("TextLabel")
LogoLabel.Name = "Logo"
LogoLabel.Size = UDim2.new(1, 0, 0, 28)
LogoLabel.Position = UDim2.new(0, 0, 0, 22)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "EXTRA ADVANCE"
LogoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.TextSize = 20
LogoLabel.ZIndex = 2
LogoLabel.Parent = MainFrame

local SubLabel = Instance.new("TextLabel")
SubLabel.Name = "Sub"
SubLabel.Size = UDim2.new(1, 0, 0, 18)
SubLabel.Position = UDim2.new(0, 0, 0, 52)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "KEY AUTHENTICATION"
SubLabel.TextColor3 = Color3.fromRGB(0, 160, 255)
SubLabel.Font = Enum.Font.GothamBold
SubLabel.TextSize = 11
SubLabel.ZIndex = 2
SubLabel.Parent = MainFrame

-- Divider
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0.85, 0, 0, 1)
Divider.Position = UDim2.new(0.075, 0, 0, 82)
Divider.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Divider.BorderSizePixel = 0
Divider.ZIndex = 2
Divider.Parent = MainFrame

-- Status label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "Status"
StatusLabel.Size = UDim2.new(0.85, 0, 0, 18)
StatusLabel.Position = UDim2.new(0.075, 0, 0, 96)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Enter your key to continue."
StatusLabel.TextColor3 = Color3.fromRGB(120, 120, 130)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.ZIndex = 2
StatusLabel.Parent = MainFrame

-- Key Input
local InputContainer = Instance.new("Frame")
InputContainer.Size = UDim2.new(0.85, 0, 0, 42)
InputContainer.Position = UDim2.new(0.075, 0, 0, 122)
InputContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
InputContainer.ZIndex = 2
InputContainer.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = InputContainer

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = Color3.fromRGB(50, 50, 58)
InputStroke.Thickness = 1
InputStroke.Parent = InputContainer

local KeyInput = Instance.new("TextBox")
KeyInput.Name = "KeyInput"
KeyInput.Size = UDim2.new(1, -16, 1, 0)
KeyInput.Position = UDim2.new(0, 12, 0, 0)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "Enter your key..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(70, 70, 80)
KeyInput.TextColor3 = Color3.fromRGB(220, 220, 225)
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 13
KeyInput.TextXAlignment = Enum.TextXAlignment.Left
KeyInput.ZIndex = 3
KeyInput.Parent = InputContainer

-- Focus glow
KeyInput.Focused:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(0, 140, 255),
    }):Play()
end)
KeyInput.FocusLost:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(50, 50, 58),
    }):Play()
end)

-- Submit Button
local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Name = "SubmitBtn"
SubmitBtn.Size = UDim2.new(0.85, 0, 0, 42)
SubmitBtn.Position = UDim2.new(0.075, 0, 0, 176)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
SubmitBtn.Text = "Authenticate"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 13
SubmitBtn.AutoButtonColor = false
SubmitBtn.ZIndex = 2
SubmitBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = SubmitBtn

local BtnGrad = Instance.new("UIGradient")
BtnGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 255)),
})
BtnGrad.Rotation = 90
BtnGrad.Parent = SubmitBtn

-- Hover effect
SubmitBtn.MouseEnter:Connect(function()
    TweenService:Create(SubmitBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(0, 140, 255),
    }):Play()
end)
SubmitBtn.MouseLeave:Connect(function()
    TweenService:Create(SubmitBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(0, 120, 255),
    }):Play()
end)

-- Discord Button
local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Name = "DiscordBtn"
DiscordBtn.Size = UDim2.new(0.85, 0, 0, 32)
DiscordBtn.Position = UDim2.new(0.075, 0, 0, 228)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
DiscordBtn.Text = "Get key on Discord"
DiscordBtn.TextColor3 = Color3.fromRGB(150, 150, 165)
DiscordBtn.Font = Enum.Font.Gotham
DiscordBtn.TextSize = 12
DiscordBtn.AutoButtonColor = false
DiscordBtn.ZIndex = 2
DiscordBtn.Parent = MainFrame

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 8)
DiscordCorner.Parent = DiscordBtn

local DiscordStroke = Instance.new("UIStroke")
DiscordStroke.Color = Color3.fromRGB(45, 45, 55)
DiscordStroke.Thickness = 1
DiscordStroke.Parent = DiscordBtn

DiscordBtn.MouseEnter:Connect(function()
    TweenService:Create(DiscordStroke, TweenInfo.new(0.15), {
        Color = Color3.fromRGB(88, 101, 242),
    }):Play()
    TweenService:Create(DiscordBtn, TweenInfo.new(0.15), {
        TextColor3 = Color3.fromRGB(200, 200, 255),
    }):Play()
end)
DiscordBtn.MouseLeave:Connect(function()
    TweenService:Create(DiscordStroke, TweenInfo.new(0.15), {
        Color = Color3.fromRGB(45, 45, 55),
    }):Play()
    TweenService:Create(DiscordBtn, TweenInfo.new(0.15), {
        TextColor3 = Color3.fromRGB(150, 150, 165),
    }):Play()
end)

-- Version label
local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(1, 0, 0, 16)
VersionLabel.Position = UDim2.new(0, 0, 0, 272)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v1.0.0  •  Extra Advance"
VersionLabel.TextColor3 = Color3.fromRGB(55, 55, 65)
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextSize = 10
VersionLabel.ZIndex = 2
VersionLabel.Parent = MainFrame

-- ──────────────────────────────────────────
-- Interactions
-- ──────────────────────────────────────────

local function setStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color or Color3.fromRGB(120, 120, 130)
end

local function setSubmitState(text, color)
    SubmitBtn.Text = text
    TweenService:Create(SubmitBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = color,
    }):Play()
end

SubmitBtn.MouseButton1Click:Connect(function()
    local entered = KeyInput.Text
    if entered == "" then
        setStatus("⚠  Please enter a key.", Color3.fromRGB(255, 200, 50))
        return
    end

    setSubmitState("Checking...", Color3.fromRGB(60, 60, 70))
    SubmitBtn.Active = false
    task.wait(0.4)

    if CheckKey(entered) then
        SaveKey(entered:gsub("%s+", ""):lower())
        setSubmitState("✓  Valid Key!", Color3.fromRGB(0, 180, 100))
        setStatus("✓  Authenticated! Loading...", Color3.fromRGB(0, 200, 120))
        task.wait(0.6)
        -- Close animation
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 400, 0, 0),
        }):Play()
        TweenService:Create(BlurFrame, TweenInfo.new(0.35), {
            BackgroundTransparency = 1,
        }):Play()
        task.wait(0.4)
        ScreenGui:Destroy()
        LoadLoader()
    else
        setSubmitState("✗  Invalid Key", Color3.fromRGB(200, 50, 50))
        setStatus("✗  Key not recognised. Try again.", Color3.fromRGB(220, 80, 80))
        task.wait(1.2)
        setSubmitState("Authenticate", Color3.fromRGB(0, 120, 255))
        setStatus("Enter your key to continue.", Color3.fromRGB(120, 120, 130))
        SubmitBtn.Active = true
    end
end)

DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/extraadvance")
    DiscordBtn.Text = "✓  Copied to clipboard!"
    TweenService:Create(DiscordBtn, TweenInfo.new(0.15), {
        TextColor3 = Color3.fromRGB(0, 200, 120),
    }):Play()
    task.wait(1.8)
    DiscordBtn.Text = "Get key on Discord"
    TweenService:Create(DiscordBtn, TweenInfo.new(0.15), {
        TextColor3 = Color3.fromRGB(150, 150, 165),
    }):Play()
end)

-- ──────────────────────────────────────────
-- Open Animation
-- ──────────────────────────────────────────

TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 400, 0, 300),
}):Play()