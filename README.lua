
--[[
    HAK CLIENT v2.0
    Roblox Edition
    Meteor-inspired ClickGUI
    Lua / Delta
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- CLEANUP
local Previous = PlayerGui:FindFirstChild("HAK_CLIENT")
if Previous then
    Previous:Destroy()
end

-- CONFIG
local Config = {
    Accent = Color3.fromRGB(153, 105, 255),
    Background = Color3.fromRGB(19, 19, 24),
    Panel = Color3.fromRGB(28, 28, 35),
    Element = Color3.fromRGB(38, 38, 47),
    Text = Color3.fromRGB(240, 240, 245),
    Muted = Color3.fromRGB(145, 145, 158),
    Enabled = Color3.fromRGB(153, 105, 255),

    OpenKey = Enum.KeyCode.RightShift,
    Animation = 0.16
}

local Categories = {
    "Combat",
    "Movement",
    "Render",
    "Player",
    "World",
    "Misc"
}

local Registry = {}
local ActiveCategory = {}
local Panels = {}
local SearchQuery = ""

local MenuOpen = true
local BindingTarget = nil
local FPS = 0

-- UTILITY
local function Create(class, properties, parent)
    local obj = Instance.new(class)

    for key, value in pairs(properties or {}) do
        obj[key] = value
    end

    obj.Parent = parent
    return obj
end

local function Round(obj, radius)
    Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 6)
    }, obj)
end

local function Outline(obj, color, transparency)
    Create("UIStroke", {
        Color = color or Config.Accent,
        Transparency = transparency or 0.65,
        Thickness = 1
    }, obj)
end

local function Tween(obj, properties)
    TweenService:Create(
        obj,
        TweenInfo.new(
            Config.Animation,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        properties
    ):Play()
end

local function Text(parent, value, size, position, fontSize)
    return Create("TextLabel", {
        Size = size,
        Position = position,
        BackgroundTransparency = 1,
        Text = value,
        TextColor3 = Config.Text,
        TextSize = fontSize or 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    }, parent)
end

local function Button(parent, value, size, position)
    local button = Create("TextButton", {
        Size = size,
        Position = position,
        BackgroundColor3 = Config.Element,
        BorderSizePixel = 0,
        Text = value,
        TextColor3 = Config.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        AutoButtonColor = false
    }, parent)

    Round(button, 5)
    return button
end

-- SCREEN
local Screen = Create("ScreenGui", {
    Name = "HAK_CLIENT",
    ResetOnSpawn = false,
    DisplayOrder = 999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

-- MAIN WINDOW
local Main = Create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(780, 510),
    Position = UDim2.new(0.5, -390, 0.5, -255),
    BackgroundColor3 = Config.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, Screen)

Round(Main, 9)
Outline(Main, Config.Accent, 0.45)

-- TOP BAR
local Top = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = Config.Panel,
    BorderSizePixel = 0
}, Main)

local Brand = Text(
    Top,
    "HAK CLIENT",
    UDim2.fromOffset(180, 44),
    UDim2.fromOffset(15, 0),
    16
)
Brand.Font = Enum.Font.GothamBold

local Version = Text(
    Top,
    "ROBLOX EDITION  /  2.0",
    UDim2.fromOffset(200, 44),
    UDim2.fromOffset(145, 0),
    10
)
Version.TextColor3 = Config.Muted

local Close = Button(
    Top,
    "×",
    UDim2.fromOffset(32, 30),
    UDim2.new(1, -42, 0, 7)
)

local Minimize = Button(
    Top,
    "−",
    UDim2.fromOffset(32, 30),
    UDim2.new(1, -80, 0, 7)
)

-- DRAG MAIN
do
    local dragging = false
    local startInput
    local startPosition

    Top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPosition = Main.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

            local delta = input.Position - startInput

            Main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- MINIMIZE
local Minimized = false
local NormalSize = Main.Size

Minimize.MouseButton1Click:Connect(function()
    Minimized = not Minimized

    if Minimized then
        NormalSize = Main.Size

        Tween(Main, {
            Size = UDim2.fromOffset(780, 44)
        })

        Minimize.Text = "+"
    else
        Tween(Main, {
            Size = NormalSize
        })

        Minimize.Text = "−"
    end
end)

-- SEARCH BAR
local Search = Create("TextBox", {
    Position = UDim2.fromOffset(12, 55),
    Size = UDim2.new(1, -24, 0, 34),
    BackgroundColor3 = Config.Element,
    BorderSizePixel = 0,
    Text = "",
    PlaceholderText = "Search modules...",
    PlaceholderColor3 = Config.Muted,
    TextColor3 = Config.Text,
    TextSize = 12,
    Font = Enum.Font.Gotham,
    ClearTextOnFocus = false
}, Main)

Round(Search, 6)

Search:GetPropertyChangedSignal("Text"):Connect(function()
    SearchQuery = string.lower(Search.Text)

    for _, panel in pairs(Panels) do
        panel.Refresh()
    end
end)

-- PANEL CONTAINER
local Container = Create("ScrollingFrame", {
    Position = UDim2.fromOffset(10, 100),
    Size = UDim2.new(1, -20, 1, -110),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Config.Accent,
    ScrollingDirection = Enum.ScrollingDirection.X,
    CanvasSize = UDim2.new()
}, Main)

local PanelLayout = Create("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 9),
    SortOrder = Enum.SortOrder.LayoutOrder
}, Container)

Create("UIPadding", {
    PaddingBottom = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 5)
}, Container)

PanelLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.fromOffset(
        PanelLayout.AbsoluteContentSize.X + 10,
        0
    )
end)

-- SETTINGS WINDOW
local SettingsWindow

local function CloseSettings()
    if SettingsWindow then
        SettingsWindow:Destroy()
        SettingsWindow = nil
    end
end

local function OpenSettings(module)
    CloseSettings()

    local Window = Create("Frame", {
        Size = UDim2.fromOffset(290, 220),
        Position = UDim2.new(0.5, -145, 0.5, -110),
        BackgroundColor3 = Config.Panel,
        BorderSizePixel = 0,
        ZIndex = 20
    }, Screen)

    SettingsWindow = Window
    Round(Window, 8)
    Outline(Window)

    local Header = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Config.Element,
        BorderSizePixel = 0,
        ZIndex = 21
    }, Window)

    Text(
        Header,
        module.Name .. " SETTINGS",
        UDim2.new(1, -45, 1, 0),
        UDim2.fromOffset(12, 0),
        12
    ).ZIndex = 22

    local Exit = Button(
        Header,
        "×",
        UDim2.fromOffset(25, 25),
        UDim2.new(1, -32, 0, 6)
    )
    Exit.ZIndex = 22
    Exit.MouseButton1Click:Connect(CloseSettings)

    Text(
        Window,
        module.Description or "Module configuration",
        UDim2.new(1, -24, 0, 35),
        UDim2.fromOffset(12, 43),
        11
    ).TextColor3 = Config.Muted

    local KeyButton = Button(
        Window,
        "KEYBIND: " .. module.Key.Name,
        UDim2.new(1, -24, 0, 32),
        UDim2.fromOffset(12, 85)
    )

    KeyButton.MouseButton1Click:Connect(function()
        BindingTarget = module
        KeyButton.Text = "PRESS ANY KEY..."
    end)

    local EnabledButton = Button(
        Window,
        "ENABLED: " .. tostring(module.Enabled),
        UDim2.new(1, -24, 0, 32),
        UDim2.fromOffset(12, 125)
    )

    EnabledButton.MouseButton1Click:Connect(function()
        module:SetEnabled(not module.Enabled)
        EnabledButton.Text = "ENABLED: " .. tostring(module.Enabled)
    end)

    Text(
        Window,
        "HAK CLIENT / MODULE CONFIGURATION",
        UDim2.new(1, -20, 0, 25),
        UDim2.fromOffset(12, 178),
        9
    ).TextColor3 = Config.Muted
end

-- MODULE RENDER
local function BuildModuleRow(module, parent)
    local row = Create("Frame", {
        Size = UDim2.new(1, -8, 0, 34),
        BackgroundColor3 = Config.Element,
        BorderSizePixel = 0
    }, parent)

    Round(row, 5)

    local Toggle = Button(
        row,
        "",
        UDim2.new(1, -38, 1, 0),
        UDim2.new()
    )
    Toggle.BackgroundTransparency = 1
    Toggle.TextXAlignment = Enum.TextXAlignment.Left
    Toggle.Text = "   " .. module.Name

    local Gear = Button(
        row,
        "⚙",
        UDim2.fromOffset(34, 30),
        UDim2.new(1, -35, 0, 2)
    )

    local function Update()
        Toggle.TextColor3 = module.Enabled
            and Config.Accent
            or Config.Text

        row.BackgroundColor3 = module.Enabled
            and Color3.fromRGB(49, 39, 65)
            or Config.Element
    end

    Toggle.MouseButton1Click:Connect(function()
        module:SetEnabled(not module.Enabled)
        Update()
    end)

    Gear.MouseButton1Click:Connect(function()
        OpenSettings(module)
    end)

    Update()
    return row
end

-- CATEGORY PANELS
for index, category in ipairs(Categories) do
    local Panel = Create("Frame", {
        Name = category,
        Size = UDim2.fromOffset(185, 365),
        BackgroundColor3 = Config.Panel,
        BorderSizePixel = 0,
        LayoutOrder = index
    }, Container)

    Round(Panel, 7)
    Outline(Panel, Config.Accent, 0.8)

    local Header = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 37),
        BackgroundColor3 = Config.Element,
        BorderSizePixel = 0,
        Text = category:upper() .. "     −",
        TextColor3 = Config.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    }, Panel)

    Round(Header, 7)

    local List = Create("ScrollingFrame", {
        Position = UDim2.fromOffset(5, 42),
        Size = UDim2.new(1, -10, 1, -47),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Config.Accent,
        CanvasSize = UDim2.new()
    }, Panel)

    local Layout = Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.Name
    }, List)

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        List.CanvasSize = UDim2.fromOffset(
            0,
            Layout.AbsoluteContentSize.Y + 5
        )
    end)

    local collapsed = false

    Header.MouseButton1Click:Connect(function()
        collapsed = not collapsed

        List.Visible = not collapsed

        Tween(Panel, {
            Size = UDim2.fromOffset(
                185,
                collapsed and 37 or 365
            )
        })

        Header.Text = category:upper() ..
            (collapsed and "     +" or "     −")
    end)

    -- DRAG CATEGORY PANEL
    local dragging = false
    local startPosition
    local startInput

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            startInput = input.Position
            startPosition = Panel.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - startInput

            Panel.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    Panels[category] = {
        Frame = Panel,
        List = List,
        Refresh = function()
            for _, child in ipairs(List:GetChildren()) do
                if child:IsA("Frame") then
                    child:Destroy()
                end
            end

            for _, module in ipairs(Registry) do
                if module.Category == category then
                    local matches = string.find(
                        string.lower(module.Name),
                        SearchQuery,
                        1,
                        true
                    )

                    if matches then
                        BuildModuleRow(module, List)
                    end
                end
            end
        end
    }
end

-- MODULE REGISTRATION
local function RegisterModule(category, name, description, callback)
    assert(Panels[category], "Invalid category")

    local module = {
        Name = name,
        Category = category,
        Description = description or "",
        Enabled = false,
        Key = Enum.KeyCode.Unknown,
        Callback = callback
    }

    function module:SetEnabled(state)
        state = state == true

        if self.Enabled == state then return end

        self.Enabled = state

        if self.Callback then
            local success, err = pcall(self.Callback, state)

            if not success then
                warn("[HAK] Module error:", self.Name, err)
            end
        end

        for _, panel in pairs(Panels) do
            panel.Refresh()
        end
    end

    table.insert(Registry, module)

    Panels[category].Refresh()

    return module
end

-- HUD
local HUD = Create("Frame", {
    Position = UDim2.fromOffset(15, 100),
    Size = UDim2.fromOffset(200, 95),
    BackgroundColor3 = Config.Background,
    BackgroundTransparency = 0.12,
    BorderSizePixel = 0
}, Screen)

Round(HUD, 6)
Outline(HUD, Config.Accent)

local HUDTitle = Text(
    HUD,
    "HAK CLIENT",
    UDim2.new(1, -15, 0, 24),
    UDim2.fromOffset(8, 3),
    13
)
HUDTitle.Font = Enum.Font.GothamBold
HUDTitle.TextColor3 = Config.Accent

local HUDInfo = Text(
    HUD,
    "FPS: --\nACTIVE MODULES: 0",
    UDim2.new(1, -15, 0, 55),
    UDim2.fromOffset(8, 29),
    11
)
HUDInfo.TextYAlignment = Enum.TextYAlignment.Top

-- HUD DRAG
do
    local dragging = false
    local startInput
    local startPosition

    HUD.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPosition = HUD.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - startInput

            HUD.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- FPS COUNTER
local frameCount = 0
local elapsed = 0

RunService.RenderStepped:Connect(function(dt)
    frameCount += 1
    elapsed += dt

    if elapsed >= 1 then
        FPS = frameCount
        frameCount = 0
        elapsed = 0
    end

    local count = 0

    for _, module in ipairs(Registry) do
        if module.Enabled then
            count += 1
        end
    end

    HUDInfo.Text = "FPS: " .. FPS ..
        "\nACTIVE MODULES: " .. count
end)

-- KEYBINDS
UIS.InputBegan:Connect(function(input, processed)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then
        return
    end

    if BindingTarget then
        if input.KeyCode == Enum.KeyCode.Escape then
            BindingTarget.Key = Enum.KeyCode.Unknown
        else
            BindingTarget.Key = input.KeyCode
        end

        BindingTarget = nil

        if SettingsWindow then
            CloseSettings()
        end

        return
    end

    if processed then return end

    if input.KeyCode == Config.OpenKey then
        MenuOpen = not MenuOpen
        Main.Visible = MenuOpen
    end

    for _, module in ipairs(Registry) do
        if module.Key ~= Enum.KeyCode.Unknown
        and input.KeyCode == module.Key then
            module:SetEnabled(not module.Enabled)
        end
    end
end)

-- CLOSE
Close.MouseButton1Click:Connect(function()
    Screen:Destroy()
end)

-- EXAMPLE MODULES
RegisterModule(
    "Render",
    "Watermark",
    "Display HAK CLIENT branding",
    function(enabled)
        HUDTitle.Visible = enabled
    end
)

RegisterModule(
    "Render",
    "FPS Counter",
    "Display current FPS",
    function(enabled)
        HUDInfo.Visible = enabled
    end
)

RegisterModule(
    "Player",
    "Player Information",
    "Display local player information",
    function(enabled)
        if enabled then
            HUDInfo.Text = "PLAYER: " .. Player.Name
        end
    end
)

-- REFRESH ALL
for _, panel in pairs(Panels) do
    panel.Refresh()
end

-- PUBLIC API
_G.HAK = {
    RegisterModule = RegisterModule,
    Registry = Registry,
    Config = Config,
    Screen = Screen
}

print("[HAK CLIENT] v2.0 loaded")
print("[HAK CLIENT] Press RightShift to toggle GUI")
