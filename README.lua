
--[[
    HAK CLIENT v1.0
    Roblox Edition
    Meteor-inspired GUI Framework
    UI framework for your own Roblox game
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

local Old = CoreGui:FindFirstChild("HAK_CLIENT")
if Old then Old:Destroy() end

local Theme = {
    Background = Color3.fromRGB(22, 22, 27),
    Panel = Color3.fromRGB(30, 30, 37),
    Element = Color3.fromRGB(39, 39, 48),
    Accent = Color3.fromRGB(151, 91, 255),
    Text = Color3.fromRGB(240, 240, 245),
    Muted = Color3.fromRGB(145, 145, 160),
    Enabled = Color3.fromRGB(151, 91, 255)
}

local Modules = {
    Combat = {},
    Movement = {},
    Render = {},
    Player = {},
    World = {},
    Misc = {}
}

local GUI = Instance.new("ScreenGui")
GUI.Name = "HAK_CLIENT"
GUI.ResetOnSpawn = false
GUI.DisplayOrder = 999
GUI.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(650, 420)
Main.Position = UDim2.new(0.5, -325, 0.5, -210)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.Parent = GUI

local function Corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function Stroke(obj)
    local s = Instance.new("UIStroke")
    s.Color = Theme.Accent
    s.Transparency = 0.65
    s.Thickness = 1
    s.Parent = obj
end

Corner(Main, 10)
Stroke(Main)

-- TITLE BAR

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 42)
Top.BackgroundColor3 = Theme.Panel
Top.BorderSizePixel = 0
Top.Parent = Main
Corner(Top, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.fromOffset(15, 0)
Title.BackgroundTransparency = 1
Title.Text = "HAK CLIENT"
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local function MakeButton(parent, text, pos, size)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = Theme.Element
    b.Text = text
    b.TextColor3 = Theme.Text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.BorderSizePixel = 0
    b.Parent = parent
    Corner(b, 6)
    return b
end

local Minimize = MakeButton(
    Top, "−",
    UDim2.new(1, -76, 0, 7),
    UDim2.fromOffset(30, 28)
)

local Close = MakeButton(
    Top, "×",
    UDim2.new(1, -39, 0, 7),
    UDim2.fromOffset(30, 28)
)

-- DRAG

local dragging = false
local dragStart, startPos

Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- MINIMIZE / RESTORE

local minimized = false
local OldSize = Main.Size

Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized

    if minimized then
        OldSize = Main.Size
        TweenService:Create(
            Main,
            TweenInfo.new(0.2),
            {Size = UDim2.fromOffset(650, 42)}
        ):Play()
        Minimize.Text = "+"
    else
        TweenService:Create(
            Main,
            TweenInfo.new(0.2),
            {Size = OldSize}
        ):Play()
        Minimize.Text = "−"
    end
end)

Close.MouseButton1Click:Connect(function()
    GUI:Destroy()
end)

-- SIDEBAR

local Sidebar = Instance.new("Frame")
Sidebar.Position = UDim2.fromOffset(10, 52)
Sidebar.Size = UDim2.new(0, 145, 1, -62)
Sidebar.BackgroundColor3 = Theme.Panel
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Corner(Sidebar, 8)

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 5)
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 10)
SidePadding.PaddingLeft = UDim.new(0, 8)
SidePadding.PaddingRight = UDim.new(0, 8)
SidePadding.Parent = Sidebar

-- CONTENT

local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(165, 52)
Content.Size = UDim2.new(1, -175, 1, -62)
Content.BackgroundColor3 = Theme.Panel
Content.BorderSizePixel = 0
Content.Parent = Main
Corner(Content, 8)

local Search = Instance.new("TextBox")
Search.Position = UDim2.fromOffset(12, 10)
Search.Size = UDim2.new(1, -24, 0, 32)
Search.BackgroundColor3 = Theme.Element
Search.PlaceholderText = "Search modules..."
Search.Text = ""
Search.TextColor3 = Theme.Text
Search.PlaceholderColor3 = Theme.Muted
Search.Font = Enum.Font.Gotham
Search.TextSize = 13
Search.BorderSizePixel = 0
Search.ClearTextOnFocus = false
Search.Parent = Content
Corner(Search, 6)

local ModuleScroll = Instance.new("ScrollingFrame")
ModuleScroll.Position = UDim2.fromOffset(10, 52)
ModuleScroll.Size = UDim2.new(1, -20, 1, -62)
ModuleScroll.BackgroundTransparency = 1
ModuleScroll.BorderSizePixel = 0
ModuleScroll.ScrollBarThickness = 3
ModuleScroll.ScrollBarImageColor3 = Theme.Accent
ModuleScroll.CanvasSize = UDim2.new()
ModuleScroll.Parent = Content

local ModuleLayout = Instance.new("UIListLayout")
ModuleLayout.Padding = UDim.new(0, 6)
ModuleLayout.Parent = ModuleScroll

ModuleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ModuleScroll.CanvasSize = UDim2.new(
        0, 0, 0,
        ModuleLayout.AbsoluteContentSize.Y + 10
    )
end)

-- MODULE SYSTEM

local ActiveCategory = "Combat"
local ModuleButtons = {}

local function RefreshModules()
    for _, child in ipairs(ModuleScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    ModuleButtons = {}

    for name, data in pairs(Modules[ActiveCategory]) do
        local query = string.lower(Search.Text)
        local visible = string.find(string.lower(name), query, 1, true)

        if visible then
            local button = MakeButton(
                ModuleScroll,
                name .. (data.Enabled and "    [ON]" or "    [OFF]"),
                UDim2.new(),
                UDim2.new(1, -5, 0, 39)
            )

            button.TextXAlignment = Enum.TextXAlignment.Left
            button.Text = "   " .. name ..
                (data.Enabled and "    [ON]" or "    [OFF]")

            button.BackgroundColor3 = data.Enabled
                and Theme.Accent
                or Theme.Element

            button.MouseButton1Click:Connect(function()
                data.Enabled = not data.Enabled

                if data.Callback then
                    task.spawn(data.Callback, data.Enabled)
                end

                RefreshModules()
            end)

            ModuleButtons[name] = button
        end
    end
end

local function AddModule(category, name, description, callback)
    if not Modules[category] then return end

    Modules[category][name] = {
        Enabled = false,
        Description = description,
        Callback = callback
    }

    if category == ActiveCategory then
        RefreshModules()
    end
end

-- CATEGORY BUTTONS

for _, category in ipairs({
    "Combat",
    "Movement",
    "Render",
    "Player",
    "World",
    "Misc"
}) do
    local button = MakeButton(
        Sidebar,
        category,
        UDim2.new(),
        UDim2.new(1, 0, 0, 38)
    )

    button.MouseButton1Click:Connect(function()
        ActiveCategory = category
        Search.Text = ""
        RefreshModules()
    end)
end

Search:GetPropertyChangedSignal("Text"):Connect(RefreshModules)

-- HUD

local HUD = Instance.new("TextLabel")
HUD.Size = UDim2.fromOffset(190, 100)
HUD.Position = UDim2.new(0, 15, 0.5, 0)
HUD.BackgroundColor3 = Theme.Background
HUD.BackgroundTransparency = 0.15
HUD.TextColor3 = Theme.Text
HUD.Font = Enum.Font.Gotham
HUD.TextSize = 12
HUD.TextXAlignment = Enum.TextXAlignment.Left
HUD.TextYAlignment = Enum.TextYAlignment.Top
HUD.Text = "HAK CLIENT"
HUD.Parent = GUI
Corner(HUD, 7)
Stroke(HUD)

-- RIGHT SHIFT TOGGLE

local menuVisible = true

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.RightShift then
        menuVisible = not menuVisible
        Main.Visible = menuVisible
    end
end)

-- INITIAL MODULES
-- Framework demo only: no game manipulation.

AddModule("Misc", "GUI Info", "Framework status", function(enabled)
    HUD.Visible = enabled
end)

AddModule("Render", "Module HUD", "Show active modules", function(enabled)
    HUD.Visible = enabled
end)

RefreshModules()

print("[HAK CLIENT] Loaded successfully")
