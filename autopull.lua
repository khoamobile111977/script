local plr = game.Players.LocalPlayer
local Doorsau = CFrame.new(28576.4688, 14935.9512, 75.469101, -1, -4.22219593e-08, 1.13133396e-08, 0, -0.258819044, -0.965925813, 4.37113883e-08, -0.965925813, 0.258819044)
local Door2 = 0.2
local apiUrl = "https://web-production-a0a2e.up.railway.app/mirageisland?key=khoadeptrai"
local HopCooldown = 0
local MaxHopCooldown = 60 -- Cooldown giữa các lần hop server (giây)
local DebugMode = true -- Bật/tắt thông báo debug

-- Function để in debug nếu DebugMode = true
function DebugPrint(message)
    if DebugMode then
        print("[AutoPull] " .. message)
    end
end

-- Function teleport
function toTarget(p, pos, targetCFrame)
    if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
        pcall(function()
            local Distance = (pos - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if Distance > 300 then
                local Speed = 300
                local tween = game:GetService("TweenService"):Create(
                    game.Players.LocalPlayer.Character.HumanoidRootPart,
                    TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
                    {CFrame = targetCFrame}
                )
                tween:Play()
                DebugPrint("Đang teleport (tween) - Khoảng cách: " .. math.floor(Distance))
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
                DebugPrint("Đã teleport (instant)")
            end
        end)
    end
end

-- Function check day/night
function GetGameTime()
    local clockTime = game.Lighting.ClockTime
    if clockTime >= 18 or clockTime < 5 then
        return "Night"
    else
        return "Day" 
    end
end

-- Function to check if Mirage Island exists
function CheckMirageIsland()
    local mirageExists = game:GetService("Workspace").Map:FindFirstChild("MysticIsland") ~= nil
    DebugPrint("Kiểm tra Mirage Island: " .. (mirageExists and "Đã tìm thấy" or "Không tìm thấy"))
    return mirageExists
end

-- Function to hop to another server using Job ID
function HopToServer(jobId)
    DebugPrint("Đang chuyển đến server: " .. jobId)
    local TeleportService = game:GetService("TeleportService")
    
    local success, error = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId)
    end)
    
    if not success then
        DebugPrint("Lỗi khi teleport: " .. tostring(error))
    end
end

-- Function to get Mirage Island servers from API with better error handling
function GetMirageServers()
    DebugPrint("Đang lấy danh sách server từ API...")
    local HttpService = game:GetService("HttpService")
    
    -- Kết nối đến API
    local success, response = pcall(function()
        return HttpService:GetAsync(apiUrl)
    end)
    
    if not success then
        DebugPrint("Lỗi kết nối API: " .. tostring(response))
        return {}, false
    end
    
    -- Parse JSON
    local decodeSuccess, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    
    if not decodeSuccess then
        DebugPrint("Lỗi khi phân tích JSON: " .. tostring(data))
        return {}, false
    end
    
    -- Kiểm tra dữ liệu
    if not data or not data.List or not data.status then
        DebugPrint("Phản hồi API không đúng định dạng")
        return {}, false
    end
    
    DebugPrint("Đã nhận " .. #data.List .. " server từ API")
    return data.List, data.status == "true"
end

-- Function main pull lever
function PullLever()
    -- Kiểm tra cửa đền
    local doorChecked = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("CheckTempleDoor")
    
    if not doorChecked then 
        if GetGameTime() == "Night" then
            if CheckMirageIsland() then
                -- Xử lý khi tìm thấy Mirage Island
                local raceProgress = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")
                DebugPrint("Tiến độ Race V4: " .. tostring(raceProgress))
                
                if raceProgress == 1 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Begin")
                elseif raceProgress == 2 then
                    -- Teleport đến cổng vào
                    local gatewayPos = CFrame.new(2956.78, 2281.85, -7217.63)
                    toTarget(plr.Character.HumanoidRootPart.Position, gatewayPos.Position, gatewayPos)
                    
                    if (gatewayPos.Position - plr.Character.HumanoidRootPart.Position).Magnitude < 8 then 
                        local args = {
                            [1] = "RaceV4Progress",
                            [2] = "Teleport"  
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                        DebugPrint("Đã gọi teleport vào Temple of Time")
                    end
                elseif raceProgress == 3 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Continue")
                    DebugPrint("Đã gọi Continue RaceV4Progress")
                end
            else
                -- Không tìm thấy Mirage Island, cần đổi server
                if HopCooldown <= 0 then
                    DebugPrint("Không tìm thấy Mirage Island, đang tìm server khác...")
                    local serverList, status = GetMirageServers()
                    
                    if status and #serverList > 0 then
                        local randomServer = serverList[math.random(1, #serverList)]
                        DebugPrint("Tìm thấy server có Mirage Island, đang chuyển đến: " .. randomServer)
                        HopToServer(randomServer)
                        HopCooldown = MaxHopCooldown
                    else
                        DebugPrint("Không tìm thấy server nào có Mirage Island hoặc API không phản hồi đúng.")
                        HopCooldown = MaxHopCooldown / 2 -- Thử lại sau nửa thời gian cooldown
                    end
                else
                    DebugPrint("Đang chờ cooldown: " .. HopCooldown .. " giây")
                end
            end
        else
            DebugPrint("Hiện tại là ban ngày, đang chờ đến đêm để tìm Mirage Island...")
        end
    else
        -- Xử lý kéo cần trong Temple of Time
        local leverPart = game:GetService("Workspace").Map["Temple of Time"].Lever
        
        if leverPart.Lever.CFrame.Z > Doorsau.Z + Door2 or leverPart.Lever.CFrame.Z < Doorsau.Z - Door2 then
            local distance = (plr.Character.HumanoidRootPart.Position - leverPart.Part.Position).Magnitude
            
            if distance > 10 then
                toTarget(plr.Character.HumanoidRootPart.Position, leverPart.Part.Position, leverPart.Part.CFrame)
            else
                DebugPrint("Đang kéo cần gạt...")
                fireproximityprompt(workspace.Map["Temple of Time"].Lever.Prompt.ProximityPrompt, 1)
            end
        else
            DebugPrint("Cần gạt đã được kéo")
        end
    end
end

-- Cooldown Counter
spawn(function()
    while wait(1) do
        if HopCooldown > 0 then
            HopCooldown = HopCooldown - 1
        end
    end
end)

-- Thông báo khởi động
DebugPrint("Auto Pull Lever Script đã được khởi động!")
DebugPrint("Đang tìm kiếm Mirage Island...")

-- Main loop
spawn(function()
    while task.wait() do 
        pcall(function()
            PullLever()            
        end)
    end
end)
