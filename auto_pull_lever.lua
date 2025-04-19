repeat
    task.wait()
until game:IsLoaded()

function setTeam(teamName)
    local args = {
        [1] = "SetTeam",
        [2] = teamName
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

_G.Select_Marines = true

spawn(function()
    while wait() do
        if _G.Select_Pirates then
            setTeam("Pirates")
            _G.Select_Pirates = false  
            break
        end
    end
end)
spawn(function()
    while wait() do
        if _G.Select_Marines then
            setTeam("Marines")
            _G.Select_Marines = false  
            break
        end
    end
end)


local plr = game:GetService("Players").LocalPlayer
local CommF = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera

-- Constants
local Doorsau = CFrame.new(28576.4688, 14935.9512, 75.469101, -1, -4.22219593e-08, 1.13133396e-08, 0, -0.258819044, -0.965925813, 4.37113883e-08, -0.965925813, 0.258819044)
local Door2 = 0.2
local API_URL = "https://web-production-a0a2e.up.railway.app/mirageisland?key=khoadeptrai"

-- Global settings for Tween
getgenv().TweenSpeed = 325 -- Tốc độ di chuyển, có thể điều chỉnh
-- Variables
local IsTweening = false
local DefaultCameraZoom = 12.5 -- Default Roblox camera zoom

-- Functions
function WaitForRespawn()
    repeat
        task.wait()
    until plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0
    print("Character respawned successfully!")
end

function Tween(Pos)
    -- If character is dead, wait for respawn
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or 
       not plr.Character:FindFirstChild("Humanoid") or 
       plr.Character.Humanoid.Health <= 0 then
        print("Character is dead, waiting for respawn...")
        WaitForRespawn()
    end
    
    -- Check again after possible respawn
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and 
       plr.Character:FindFirstChild("Humanoid") and 
       plr.Character.Humanoid.Health > 0 then
        
        -- Calculate distance
        local Distance = (Pos.Position - plr.Character.HumanoidRootPart.Position).Magnitude
        
        -- Make sure character is not sitting
        if plr.Character.Humanoid.Sit == true then
            plr.Character.Humanoid.Sit = false
        end
        
        -- Create tween
        local Tweeb
        pcall(
            function()
                Tweeb = game:GetService("TweenService"):Create(
                    plr.Character.HumanoidRootPart,
                    TweenInfo.new(Distance / getgenv().TweenSpeed, Enum.EasingStyle.Linear),
                    {CFrame = Pos}
                )
            end
        )
        
        -- Start tween
        IsTweening = true
        Tweeb:Play()
        
        -- Wait for tween to complete or be cancelled
        Tweeb.Completed:Connect(function()
            IsTweening = false
        end)
    else
        print("Character not ready for tweening")
    end
end

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

function getBlueGear()
    if game.workspace.Map:FindFirstChild("MysticIsland") then
        for i, v in pairs(game.workspace.Map.MysticIsland:GetChildren()) do
            if v:IsA("MeshPart") and v.MeshId == "rbxassetid://10153114969" then
                return v
            end
        end
    end
end

function getHighestPoint()
    if not game.workspace.Map:FindFirstChild("MysticIsland") then
        return nil
    end
    for i, v in pairs(game:GetService("Workspace").Map.MysticIsland:GetDescendants()) do
        if v:IsA("MeshPart") then
            if v.MeshId == "rbxassetid://6745037796" then
                return v
            end
        end
    end
end

-- Hàm zoom camera đến góc nhìn thứ nhất
function SetFirstPersonCamera()
    local player = game:GetService("Players").LocalPlayer
    local camera = workspace.CurrentCamera
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
        -- Lưu zoom level hiện tại
        if not _G.OldCameraOffset then
            _G.OldCameraOffset = player.CameraMinZoomDistance
        end
        
        -- Đặt camera vào góc nhìn thứ nhất
        player.CameraMinZoomDistance = 0.5
        player.CameraMaxZoomDistance = 0.5
        
        print("Camera zoomed to first person view")
    end
end

-- Hàm reset camera về chế độ bình thường
function ResetCamera()
    local player = game:GetService("Players").LocalPlayer
    
    if _G.OldCameraOffset then
        player.CameraMinZoomDistance = 0
        player.CameraMaxZoomDistance = DefaultCameraZoom
        _G.OldCameraOffset = nil
        
        print("Camera reset to default view")
    end
end

function CollectBlueGear()
    -- Chỉ thực hiện CollectBlueGear vào buổi tối
    if function7() ~= "Night" then
        print("[Auto Pull Lever] Waiting for Night time to collect Blue Gear...")
        return false
    end
    
    local BlueGear = getBlueGear()
    if BlueGear and not BlueGear.CanCollide and BlueGear.Transparency ~= 1 then
        -- Zoom camera to first person before tweening
        SetFirstPersonCamera()
        Tween(getBlueGear().CFrame)
    elseif BlueGear and BlueGear.Transparency == 1 then
        -- Zoom camera to first person 
        SetFirstPersonCamera()
        
        if (getHighestPoint().CFrame*CFrame.new(0, 211.88, 0).Position-plr.Character.HumanoidRootPart.Position).Magnitude > 10 then 
            Tween(getHighestPoint().CFrame*CFrame.new(0, 211.88, 0))
        else
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, game:GetService("Lighting"):GetMoonDirection() + workspace.CurrentCamera.CFrame.Position)
            task.wait(.1)
            game:service("VirtualInputManager"):SendKeyEvent(true, "T", false, game)
            task.wait()
            game:service("VirtualInputManager"):SendKeyEvent(false, "T", false, game)
            task.wait(1.5)
            ResetCamera() -- Reset camera after completing the action
        end
    end
    
    return true
end

function CheckTempleProgress()
    local v213 = CommF:InvokeServer("RaceV4Progress", "Check")
    if v213 == 1 then
        CommF:InvokeServer("RaceV4Progress", "Begin")
        return true
    elseif v213 == 2 then
        Tween(CFrame.new(-2061.10522, 37.5483475, -10241.7959, 1, 0, 0, 0, 1, 0, 0, 0, 1))
        if (CFrame.new(-2061.10522, 37.5483475, -10241.7959, 1, 0, 0, 0, 1, 0, 0, 0, 1).Position-plr.Character.HumanoidRootPart.Position).Magnitude < 8 then 
            local args = {
                [1] = "RaceV4Progress",
                [2] = "Teleport"
            }
            CommF:InvokeServer(unpack(args))
        end
        return true
    elseif v213 == 3 then
        CommF:InvokeServer("RaceV4Progress", "Continue")
        return true
    end
    return false
end

function PullLever()
    if not CommF:InvokeServer("CheckTempleDoor") then 
        if game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
            -- Nếu đã check tiến độ temple và có thể tiếp tục, thì không cần đợi đêm
            if CheckTempleProgress() then
                print("[Auto Pull Lever] Temple progress actions performed")
            else
                -- Nếu cần collect BlueGear
                if function7() == "Night" then
                    -- Đêm rồi, có thể collect
                    CollectBlueGear()
                else
                    -- Nếu trời sáng, chỉ thông báo và chờ đợi đêm đến
                    print("[Auto Pull Lever] Mirage Island found! Waiting for night to collect Blue Gear...")
                    -- Vẫn tiếp tục các chức năng khác khi trời sáng
                end
            end
        elseif not game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then 
            print("[Auto Pull Lever] Mirage Island not found, joining a server with Mirage Island...")
            JoinMirageServer()
        end
    
        -- Phần pull lever có thể thực hiện bất kể ngày hay đêm
        if game:GetService("Workspace").Map["Temple of Time"].Lever.Lever.CFrame.Z > Doorsau.Z + Door2 or game:GetService("Workspace").Map["Temple of Time"].Lever.Lever.CFrame.Z < Doorsau.Z - Door2 then 
            if (plr.Character.HumanoidRootPart.Position-game:GetService("Workspace").Map["Temple of Time"].Lever.Part.Position).Magnitude > 10 then
                Tween(game:GetService("Workspace").Map["Temple of Time"].Lever.Part.CFrame)
            else
                fireproximityprompt(workspace.Map["Temple of Time"].Lever.Prompt.ProximityPrompt, 1)
            end
        else
            print("[Auto Pull Lever] Pull Lever Complete!")
            ResetCamera() -- Đảm bảo reset camera sau khi hoàn thành
        end
    else
        print("[Auto Pull Lever] Temple Door already open!")
    end
end

function JoinMirageServer()
    local success, response = pcall(function()
        return request({
            Url = API_URL,
            Method = "GET"
        })
    end)

    if success then
        local data
        pcall(function()
            data = HttpService:JSONDecode(response.Body)
        end)
        
        if data and data.status == "true" and #data.List > 0 then
            for _, jobId in ipairs(data.List) do
                print("[Auto Pull Lever] Joining server with Mirage Island: " .. jobId)
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobId)
                task.wait(5)
            end
        else
            print("[Auto Pull Lever] No servers with Mirage Island found.")
            task.wait(30)
        end
    else
        print("[Auto Pull Lever] Failed to get Mirage Island servers. Error:", tostring(response))
        task.wait(30)
    end
end

-- Cleanup function when script stops
local function CleanupOnStop()
    ResetCamera() -- Reset camera zoom when script stops
end

-- Main Loop
spawn(function()
    while task.wait() do 
        pcall(function()
            PullLever()
        end)
    end
end)

-- Connect cleanup to game closing event
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == plr then
        CleanupOnStop()
    end
end)

print("[Auto Pull Lever] Script started successfully!")
