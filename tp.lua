local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- UI Colors
local COLORS = {
    primary = Color3.fromRGB(45, 45, 45),
    secondary = Color3.fromRGB(35, 35, 35),
    accent = Color3.fromRGB(0, 170, 255),
    text = Color3.fromRGB(255, 255, 255),
    buttonHover = Color3.fromRGB(60, 60, 60)
}

-- Tạo ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportGui"
gui.ResetOnSpawn = false
gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Tạo nút menu (luôn hiển thị)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0.5, -20)
toggleButton.Text = "☰"
toggleButton.TextSize = 20
toggleButton.Font = Enum.Font.GothamBold
toggleButton.BackgroundColor3 = COLORS.accent
toggleButton.TextColor3 = COLORS.text
toggleButton.BorderSizePixel = 0
toggleButton.Parent = gui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleButton

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 280)
frame.Position = UDim2.new(0, 60, 0.5, -140)
frame.BackgroundColor3 = COLORS.primary
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = COLORS.secondary
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "Teleport Menu"
title.TextColor3 = COLORS.text
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.Parent = titleBar

-- Function tạo button
local function createStylishButton(text, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Position = position
    button.Text = text
    button.TextColor3 = COLORS.text
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.BackgroundColor3 = COLORS.secondary
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Parent = frame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = COLORS.buttonHover
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = COLORS.secondary
        }):Play()
    end)
    
    return button
end

-- Tạo speed control UI
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0.65, 0)
speedLabel.Text = "Tốc độ bay: 325"  -- Giá trị mặc định mới
speedLabel.TextColor3 = COLORS.text
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.GothamSemibold
speedLabel.BackgroundTransparency = 1
speedLabel.Parent = frame

-- Tạo frame cho slider
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0.9, 0, 0, 6)
sliderFrame.Position = UDim2.new(0.05, 0, 0.75, 0)
sliderFrame.BackgroundColor3 = COLORS.secondary
sliderFrame.BorderSizePixel = 0
sliderFrame.Parent = frame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = sliderFrame

-- Tạo slider button
local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 16, 0, 16)
sliderButton.Position = UDim2.new(0.5, -8, 0.5, -8)
sliderButton.Text = ""
sliderButton.BackgroundColor3 = COLORS.accent
sliderButton.BorderSizePixel = 0
sliderButton.Parent = sliderFrame
sliderButton.ZIndex = 2

local sliderButtonCorner = Instance.new("UICorner")
sliderButtonCorner.CornerRadius = UDim.new(1, 0)
sliderButtonCorner.Parent = sliderButton

-- Tạo các nút teleport
local mansionButton = createStylishButton("🏰 Đến Mansion", UDim2.new(0.05, 0, 0.2, 0))
local tikiButton = createStylishButton("🌴 Đến Tiki", UDim2.new(0.05, 0, 0.4, 0))

-- Vị trí teleport (đã cập nhật mansion)
local locations = {
    mansion = CFrame.new(-12488.4365234375, 336.38446044921875, -7445.7744140625),
    tiki = CFrame.new(-16664.458984375, 189.5279998779297, 523.4910278320312)
}

-- Biến lưu tốc độ (giá trị mặc định mới)
local flySpeed = 325

-- Xử lý slider
local function updateSlider(input)
    local sliderPosition = math.clamp(
        (input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X,
        0,
        1
    )
    
    -- Update slider position
    sliderButton.Position = UDim2.new(sliderPosition, -8, 0.5, -8)
    
    -- Update speed value (thay đổi range tốc độ)
    flySpeed = math.floor(sliderPosition * 900) + 100  -- 100 to 1000
    speedLabel.Text = "Tốc độ bay: " .. flySpeed
end

local isDragging = false

sliderButton.MouseButton1Down:Connect(function()
    isDragging = true
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateSlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- Function tween với tốc độ cố định
local function tweenToLocation(location)
    local character = Players.LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local humanoidRootPart = character.HumanoidRootPart
    local humanoid = character:FindFirstChild("Humanoid")
    
    -- Tính toán thời gian dựa trên khoảng cách và tốc độ
    local distance = (location.Position - humanoidRootPart.Position).Magnitude
    local tweenDuration = distance / flySpeed
    
    -- Disable controls
    if humanoid then
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
    end
    
    -- Create and play tween
    local tween = TweenService:Create(humanoidRootPart, 
        TweenInfo.new(tweenDuration, Enum.EasingStyle.Linear), 
        {CFrame = location}
    )
    
    -- Enable controls after tween
    tween.Completed:Connect(function()
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end)
    
    tween:Play()
end

-- Xử lý sự kiện nút
mansionButton.MouseButton1Click:Connect(function()
    tweenToLocation(locations.mansion)
end)

tikiButton.MouseButton1Click:Connect(function()
    tweenToLocation(locations.tiki)
end)

-- Xử lý đóng/mở menu
local isMenuOpen = true
toggleButton.MouseButton1Click:Connect(function()
    isMenuOpen = not isMenuOpen
    if isMenuOpen then
        frame.Visible = true
    else
        frame.Visible = false
    end
end)
