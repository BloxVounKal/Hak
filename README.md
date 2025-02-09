local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local tracking = false  -- Trạng thái bật/tắt tính năng
local target = nil  -- Lưu đối thủ

-- Tạo GUI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 100, 0, 50)
toggleButton.Position = UDim2.new(1, -110, 0, 10)
toggleButton.Text = "Track: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

toggleButton.MouseButton1Click:Connect(function()
    tracking = not tracking
    toggleButton.Text = tracking and "Track: ON" or "Track: OFF"
    toggleButton.BackgroundColor3 = tracking and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- Chọn đối thủ gần nhất
local function findClosestEnemy()
    local closest, distance = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (p.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if mag < distance then
                closest, distance = p.Character.HumanoidRootPart, mag
            end
        end
    end
    return closest
end

-- Cập nhật camera hoặc shiftlock
RunService.RenderStepped:Connect(function()
    if tracking then
        target = findClosestEnemy()
        if target then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        end
    end
end)
