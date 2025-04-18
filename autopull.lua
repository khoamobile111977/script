local plr = game.Players.LocalPlayer
local Doorsau = CFrame.new(28576.4688,14935.9512,75.469101,-1,-4.22219593e-08,1.13133396e-08,0,-0.258819044,-0.965925813,4.37113883e-08,-0.965925813,0.258819044)
local Door2 = 0.2
local apiUrl = "https://web-production-a0a2e.up.railway.app/mirageisland?key=khoadeptrai"
local HopCooldown = 0
local MaxHopCooldown = 60 -- Cooldown giữa các lần hop server (giây)

-- Function teleport
function toTarget(p,pos,targetCFrame)
    if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
        pcall(function()
            local Distance = (pos - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if Distance > 300 then
                local Speed = 300 -- Adjust speed as needed
                local tween = game:GetService("TweenService"):Create(
                    game.Players.LocalPlayer.Character.HumanoidRootPart,
                    TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
                    {CFrame = targetCFrame}
                )
                tween:Play()
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
            end
        end)
    end
end

-- Function check day/night
function function7()
    local GameTime = "Error"
    local c2 = game.Lighting.ClockTime
    if c2 >= 18 or c2 < 5 then
        GameTime = "Night"
    else
        GameTime = "Day" 
    end
    return GameTime
end

-- Function to check if Mirage Island exists
function checkMirageIsland()
    return game:GetService("Workspace").Map:FindFirstChild("MysticIsland") ~= nil
end

-- Function to hop to another server using Job ID
function hopToServer(jobId)
    local TeleportService = game:GetService("TeleportService")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId)
end

-- Function to get Mirage Island servers from API
function getMirageServers()
    local HttpService = game:GetService("HttpService")
    local success, response = pcall(function()
        return HttpService:GetAsync(apiUrl)
    end)
    
    if success then
        local data = HttpService:JSONDecode(response)
        return data.List, data.status == "true"
    else
        print("Lỗi khi lấy dữ liệu từ API: " .. tostring(response))
        return {}, false
    end
end

-- Function main pull lever
function PullLever()
    if not game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("CheckTempleDoor") then 
        if function7() == "Night" then
            if checkMirageIsland() then
                local v213 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")
                if v213 == 1 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Begin")
                elseif v213 == 2 then
                    toTarget(plr.Character.HumanoidRootPart.Position,CFrame.new(2956.78, 2281.85, -7217.63).Position,CFrame.new(2956.78, 2281.85, -7217.63))
                    if (CFrame.new(2956.78, 2281.85, -7217.63).Position-plr.Character.HumanoidRootPart.Position).Magnitude < 8 then 
                        local args = {
                            [1] = "RaceV4Progress",
                            [2] = "Teleport"  
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    end
                elseif v213 == 3 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Continue")
                end
            else
                -- Không tìm thấy Mirage Island trong server hiện tại
                if HopCooldown <= 0 then
                    print("Không tìm thấy Mirage Island, đang tìm server khác...")
                    local serverList, status = getMirageServers()
                    
                    if status and #serverList > 0 then
                        local randomIndex = math.random(1, #serverList)
                        local selectedServer = serverList[randomIndex]
                        print("Đang chuyển đến server có Mirage Island: " .. selectedServer)
                        hopToServer(selectedServer)
                        HopCooldown = MaxHopCooldown
                    else
                        print("Không tìm thấy server nào có Mirage Island hoặc API không trả về dữ liệu hợp lệ.")
                        HopCooldown = MaxHopCooldown / 2 -- Thử lại sau nửa thời gian cooldown
                    end
                else
                    HopCooldown = HopCooldown - 1
                    print("Đang chờ cooldown hop server: " .. HopCooldown .. " giây còn lại")
                end
            end
        else
            print("Hiện tại là ban ngày, đang chờ đến đêm để tìm Mirage Island...")
        end
    else
        if game:GetService("Workspace").Map["Temple of Time"].Lever.Lever.CFrame.Z > Doorsau.Z + Door2 or game:GetService("Workspace").Map["Temple of Time"].Lever.Lever.CFrame.Z < Doorsau.Z - Door2 then
            if (plr.Character.HumanoidRootPart.Position-game:GetService("Workspace").Map["Temple of Time"].Lever.Part.Position).Magnitude > 10 then
                toTarget(plr.Character.HumanoidRootPart.Position,game:GetService("Workspace").Map["Temple of Time"].Lever.Part.Position,game:GetService("Workspace").Map["Temple of Time"].Lever.Part.CFrame)
            else
                fireproximityprompt(workspace.Map["Temple of Time"].Lever.Prompt.ProximityPrompt,1)
            end
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

-- Main loop
spawn(function()
    while task.wait() do 
        pcall(function()
            PullLever()            
        end)
    end
end)