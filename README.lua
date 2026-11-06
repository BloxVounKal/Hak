-- ==============================================================================
-- [ROBLOX LUAU] NGOC'S ULTIMATE FAKE GIFT & RAINBOW CONSOLE SYSTEM
-- Exclusive Script for Ngoc | 7-Color Gradient Animation & Multi-Tools
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- ------------------------------------------------------------------------------
-- 1. TẠO SCREEN GUI CHÍNH
-- ------------------------------------------------------------------------------
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "NgocSystemGui"
mainGui.ResetOnSpawn = false
mainGui.Parent = playerGui

-- ------------------------------------------------------------------------------
-- 2. KHUNG CONSOLE CHÍNH (MAIN FRAME)
-- ------------------------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 480, 0, 360)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = mainGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Thêm viền Stroke phát sáng nhẹ
local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Parent = mainFrame

-- ------------------------------------------------------------------------------
-- 3. HỆ THỐNG GRADIENT 7 MÀU RAINBOW (CHẠY REAL-TIME)
-- ------------------------------------------------------------------------------
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),     -- Đỏ
	ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 127, 0)),   -- Cam
	ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),   -- Vàng
	ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 0)),     -- Lục
	ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),     -- Lam
	ColorSequenceKeypoint.new(0.83, Color3.fromRGB(75, 0, 130)),    -- Chàm
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(143, 0, 255))    -- Tím
})
uiGradient.Parent = mainStroke

-- Xử lý xoay góc Gradient liên tục tạo hiệu ứng chạy màu mượt mà
RunService.RenderStepped:Connect(function(deltaTime)
	uiGradient.Rotation = (uiGradient.Rotation + (deltaTime * 90)) % 360
end)

-- ------------------------------------------------------------------------------
-- 4. TIÊU ĐỀ HỆ THỐNG (HEADER FOR NGOC)
-- ------------------------------------------------------------------------------
local titleHeader = Instance.new("TextLabel")
titleHeader.Size = UDim2.new(1, -40, 0, 40)
titleHeader.Position = UDim2.new(0, 15, 0, 5)
titleHeader.BackgroundTransparency = 1
titleHeader.Font = Enum.Font.GothamBold
titleHeader.TextSize = 16
titleHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
titleHeader.Text = "⚡ NGOC'S ULTIMATE CONTROL CENTER v3.0"
titleHeader.TextXAlignment = Enum.TextXAlignment.Left
titleHeader.Parent = mainFrame

-- Gradient riêng cho dòng Chữ Tiêu Đề
local titleGradient = uiGradient:Clone()
titleGradient.Parent = titleHeader

-- Nút Tắt/Mở Nhanh
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- ------------------------------------------------------------------------------
-- 5. DANH SÁCH TÍNH NĂNG (SCROLLING BUTTON PANEL)
-- ------------------------------------------------------------------------------
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -60)
container.Position = UDim2.new(0, 10, 0, 50)
container.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
container.BorderSizePixel = 0
container.ScrollBarThickness = 4
container.CanvasSize = UDim2.new(0, 0, 0, 0)
container.AutomaticCanvasSize = Enum.AutomaticSize.Y
container.Parent = mainFrame

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 8)
containerCorner.Parent = container

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 215, 0, 45)
gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.Parent = container

local gridPadding = Instance.new("UIPadding")
gridPadding.PaddingTop = UDim.new(0, 10)
gridPadding.PaddingLeft = UDim.new(0, 10)
gridPadding.Parent = container

-- Hàm phụ tạo nút chức năng phong cách 7 màu
local function createFeatureButton(name, icon, color, callback)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.BackgroundColor3 = Color3.fromRGB(32, 32, 45)
	btn.Text = icon .. " " .. name
	btn.TextColor3 = color
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 13
	btn.Parent = container
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn
	
	local btnStroke = Instance.new("UIStroke")
	btnStroke.Thickness = 1
	btnStroke.Color = color
	btnStroke.Transparency = 0.5
	btnStroke.Parent = btn
	
	btn.MouseButton1Click:Connect(function()
		-- Hiệu ứng bấm nút
		local tween = TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0, 205, 0, 40)})
		tween:Play()
		task.wait(0.1)
		btn.Size = UDim2.new(0, 215, 0, 45)
		callback()
	end)
end

-- ------------------------------------------------------------------------------
-- 6. KHỞI TẠO CÁC CHỨC NĂNG DÀNH CHO NGOC
-- ------------------------------------------------------------------------------

-- Chức năng 1: Spawner Gift Pop-up Đẳng Cấp
createFeatureButton("Fake Gift Banner", "🎁", Color3.fromRGB(255, 215, 0), function()
	local giftGui = Instance.new("ScreenGui")
	giftGui.Parent = playerGui
	
	local gFrame = Instance.new("Frame")
	gFrame.Size = UDim2.new(0, 360, 0, 200)
	gFrame.Position = UDim2.new(0.5, -180, 0.35, -100)
	gFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
	gFrame.Parent = giftGui
	
	local gCorner = Instance.new("UICorner")
	gCorner.CornerRadius = UDim.new(0, 14)
	gCorner.Parent = gFrame
	
	local gStroke = Instance.new("UIStroke")
	gStroke.Thickness = 3
	gStroke.Parent = gFrame
	
	local gGradient = uiGradient:Clone()
	gGradient.Parent = gStroke
	
	local gTitle = Instance.new("TextLabel")
	gTitle.Size = UDim2.new(1, 0, 0, 50)
	gTitle.BackgroundTransparency = 1
	gTitle.Text = "👑 ĐẶC QUYỀN VIP - NGOC"
	gTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	gTitle.Font = Enum.Font.GothamBold
	gTitle.TextSize = 20
	gTitle.Parent = gFrame
	
	local gText = Instance.new("TextLabel")
	gText.Size = UDim2.new(1, -20, 0, 70)
	gText.Position = UDim2.new(0, 10, 0, 50)
	gText.BackgroundTransparency = 1
	gText.Text = "Bạn vừa được Hệ Thống trao tặng:\n+99,999,999 Fake Robux\n+1x Admin Custom Sword"
	gText.TextColor3 = Color3.fromRGB(200, 255, 200)
	gText.Font = Enum.Font.Gotham
	gText.TextSize = 14
	gText.Parent = gFrame
	
	local claimBtn = Instance.new("TextButton")
	claimBtn.Size = UDim2.new(0, 160, 0, 40)
	claimBtn.Position = UDim2.new(0.5, -80, 1, -50)
	claimBtn.BackgroundColor3 = Color3.fromRGB(0, 220, 110)
	claimBtn.Text = "NHẬN PHẦN THƯỞNG"
	claimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	claimBtn.Font = Enum.Font.GothamBold
	claimBtn.TextSize = 13
	claimBtn.Parent = gFrame
	
	local cCorner = Instance.new("UICorner")
	cCorner.CornerRadius = UDim.new(0, 8)
	cCorner.Parent = claimBtn
	
	claimBtn.MouseButton1Click:Connect(function()
		giftGui:Destroy()
	end)
end)

-- Chức năng 2: Cộng Fake Robux Counter
local fakeRobux = 0
createFeatureButton("Add 1M Fake Robux", "💰", Color3.fromRGB(0, 255, 150), function()
	fakeRobux = fakeRobux + 1000000
	print("[NGOC SYSTEM]: Số dư Fake Robux hiện tại: " .. tostring(fakeRobux) .. " Robux")
end)

-- Chức năng 3: Super Speed (Tăng tốc độ di chuyển)
local isSpeed = false
createFeatureButton("Super Speed", "⚡", Color3.fromRGB(0, 200, 255), function()
	local char = localPlayer.Character
	if char and char:FindFirstChild("Humanoid") then
		isSpeed = not isSpeed
		char.Humanoid.WalkSpeed = isSpeed and 100 or 16
	end
end)

-- Chức năng 4: High Jump (Nhảy cao)
local isJump = false
createFeatureButton("High Jump", "🚀", Color3.fromRGB(255, 150, 0), function()
	local char = localPlayer.Character
	if char and char:FindFirstChild("Humanoid") then
		isJump = not isJump
		char.Humanoid.JumpPower = isJump and 150 or 50
	end
end)

-- Chức năng 5: God Mode (Kháng sát thương giả lập)
createFeatureButton("God Mode (Fake)", "🛡️", Color3.fromRGB(255, 50, 150), function()
	local char = localPlayer.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.MaxHealth = 999999
		char.Humanoid.Health = 999999
	end
end)

-- Chức năng 6: ESP Box (Hiển thị vị trí người chơi khác)
local espActive = false
createFeatureButton("Player ESP", "👁️", Color3.fromRGB(180, 100, 255), function()
	espActive = not espActive
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") then
			if espActive then
				if not p.Character.Head:FindFirstChild("NgocESP") then
					local bb = Instance.new("BillboardGui")
					bb.Name = "NgocESP"
					bb.Size = UDim2.new(0, 100, 0, 30)
					bb.AlwaysOnTop = true
					bb.Adornee = p.Character.Head
					
					local txt = Instance.new("TextLabel")
					txt.Size = UDim2.new(1, 0, 1, 0)
					txt.BackgroundTransparency = 1
					txt.Text = "[ " .. p.Name .. " ]"
					txt.TextColor3 = Color3.fromRGB(0, 255, 255)
					txt.Font = Enum.Font.GothamBold
					txt.TextSize = 12
					txt.Parent = bb
					
					bb.Parent = p.Character.Head
				end
			else
				if p.Character.Head:FindFirstChild("NgocESP") then
					p.Character.Head.NgocESP:Destroy()
				end
			end
		end
	end
end)

print("[Ngoc System]: Nạp Script thành công! Nhấn nút Close hoặc gọi giao diện để trải nghiệm.")
