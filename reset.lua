-- Tạo ScreenGui để chứa nút Reset
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ResetCharacterGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Tạo TextButton để làm nút Reset
local ResetButton = Instance.new("TextButton")
ResetButton.Name = "ResetButton"
ResetButton.Size = UDim2.new(0, 80, 0, 30)
ResetButton.Position = UDim2.new(0.95, -80, 0.05, 0) -- Góc trên bên phải
ResetButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ResetButton.Text = "Reset"
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetButton.Font = Enum.Font.SourceSansBold
ResetButton.TextSize = 16
ResetButton.BorderSizePixel = 0
ResetButton.AutoButtonColor = true
ResetButton.Parent = ScreenGui

-- Làm cho góc nút bo tròn
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = ResetButton

-- Thêm hiệu ứng khi hover
local OriginalColor = ResetButton.BackgroundColor3
ResetButton.MouseEnter:Connect(function()
    ResetButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
end)

ResetButton.MouseLeave:Connect(function()
    ResetButton.BackgroundColor3 = OriginalColor
end)

-- Xử lý sự kiện khi nhấn nút
ResetButton.MouseButton1Click:Connect(function()
    -- Reset nhân vật của người chơi
    local character = game.Players.LocalPlayer.Character
    if character then
        character:BreakJoints()
    end
end)

-- Script sẽ chạy trong LocalScript
local function onPlayerAdded(player)
    if player == game.Players.LocalPlayer then
        player.CharacterAdded:Connect(function()
            -- Đảm bảo GUI luôn hiển thị sau khi nhân vật được tạo lại
            ScreenGui.Enabled = true
        end)
    end
end

-- Kết nối sự kiện cho người chơi hiện tại
if game.Players.LocalPlayer then
    onPlayerAdded(game.Players.LocalPlayer)
end

-- Kết nối sự kiện cho người chơi mới
game.Players.PlayerAdded:Connect(onPlayerAdded)
