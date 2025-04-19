-- Đợi đến khi game load xong bằng repeat
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


-- Boss farm settings
getgenv().TweenSpeed = 325 -- Speed for tweening to locations
getgenv().StopFarmingWhenItemsObtained = true -- Stop farming when both items are obtained

-- Boss information
local BossList = {
    {
        Name = "rip_indra True Form",
        SpawnName = "rip_indra True Form",
        Priority = 1 
    },
    {
        Name = "Dough King",
        SpawnName = "Dough King",
        Priority = 2 
    }
}

ChooseWeapon = "Melee" -- Can be "Melee" or "Sword"
SelectWeapon = "" -- Will be auto-selected based on ChooseWeapon

-- Keep track of boss state
local IsBossFarmActive = false
local IsTweening = false
local CurrentBossTarget = nil
local IsRespawning = false -- Flag to track if character is respawning

-- Function to check if player has an item
local function CheckItemInventory(itemName)
    for i, v in pairs(game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("getInventory")) do
        if v.Name == itemName then
            return true
        end
    end
    return false
end

-- Function to check if both items are obtained
local function AreBothItemsObtained()
    return CheckItemInventory("Mirror Fractal") and CheckItemInventory("Valkyrie Helm")
end

-- Import functions from the provided script
local m = loadstring(http_request({
	["Url"] = "https://raw.githubusercontent.com/Iamkhnah/projectluacanmayidollop8a/refs/heads/main/pkhanh.lua",
	["Method"] = "GET",
	["Headers"] = { 
		["user-agent"] = "Coded by pkhanh"
	}
}).Body)()
spawn(function()
	while wait() do
		m.mmb()
	end
end)

-- Check if enemies exist function
function CheckEnemies(name)
    for i, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name:find(name) and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            return v
        end
    end
    return false
end

-- Get boss spawn position from ReplicatedStorage
function GetBossSpawnPosition(bossName)
    local boss = game:GetService("ReplicatedStorage"):FindFirstChild(bossName)
    if boss and boss:FindFirstChild("HumanoidRootPart") then
        return boss.HumanoidRootPart.CFrame
    end
    return nil
end

-- Check if a specific boss is alive
function IsBossAlive(bossName)
    local boss = CheckEnemies(bossName)
    return boss ~= false and boss.Humanoid.Health > 0
end

-- Find all active bosses function
function FindActiveBosses()
    local activeBosses = {}
    
    for _, bossInfo in ipairs(BossList) do
        local boss = CheckEnemies(bossInfo.Name)
        if boss and boss.Humanoid.Health > 0 then
            table.insert(activeBosses, {
                Boss = boss,
                Info = bossInfo
            })
        end
    end
    
    -- Sort by priority (lower number = higher priority)
    table.sort(activeBosses, function(a, b)
        return a.Info.Priority < b.Info.Priority
    end)
    
    return activeBosses
end

-- Check if a boss is in workspace but dead
function IsDeadBossInWorkspace(bossName)
    for i, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name:find(bossName) and v:FindFirstChild("Humanoid") and v.Humanoid.Health <= 0 then
            return true
        end
    end
    return false
end

-- Find available boss spawns in ReplicatedStorage
function FindAvailableBossSpawns()
    local availableSpawns = {}
    
    for _, bossInfo in ipairs(BossList) do
        -- Check if boss is not dead in workspace
        if not IsDeadBossInWorkspace(bossInfo.Name) then
            local spawnCFrame = GetBossSpawnPosition(bossInfo.SpawnName)
            if spawnCFrame then
                table.insert(availableSpawns, {
                    SpawnCFrame = spawnCFrame,
                    Info = bossInfo
                })
            end
        end
    end
    
    -- Sort by priority (lower number = higher priority)
    table.sort(availableSpawns, function(a, b)
        return a.Info.Priority < b.Info.Priority
    end)
    
    return availableSpawns
end

-- Wait for character to respawn
function WaitForRespawn()
    local localPlayer = game.Players.LocalPlayer
    IsRespawning = true
    
    -- Wait until character exists and is loaded
    while not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") or 
          not localPlayer.Character:FindFirstChild("Humanoid") or 
          localPlayer.Character.Humanoid.Health <= 0 do
        wait(1)
    end
    
    -- Add a safety delay to allow character to fully load
    wait(3)
    IsRespawning = false
    return true
end

-- Tween function with concurrent boss checking
function Tween(Pos)
    local localPlayer = game.Players.LocalPlayer
    
    -- If character is dead, wait for respawn
    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") or 
       not localPlayer.Character:FindFirstChild("Humanoid") or 
       localPlayer.Character.Humanoid.Health <= 0 then
        print("Character is dead, waiting for respawn...")
        WaitForRespawn()
    end
    
    -- Check again after possible respawn
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and 
       localPlayer.Character:FindFirstChild("Humanoid") and 
       localPlayer.Character.Humanoid.Health > 0 then
        
        -- Calculate distance
        local Distance = (Pos.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
        
        -- Make sure character is not sitting
        if localPlayer.Character.Humanoid.Sit == true then
            localPlayer.Character.Humanoid.Sit = false
        end
        
        -- Create tween
        local Tweeb
        pcall(
            function()
                Tweeb = game:GetService("TweenService"):Create(
                    localPlayer.Character.HumanoidRootPart,
                    TweenInfo.new(Distance / getgenv().TweenSpeed, Enum.EasingStyle.Linear),
                    {CFrame = Pos}
                )
            end
        )
        
        -- Start tween
        IsTweening = true
        Tweeb:Play()
        
        -- Start a parallel thread to check for any boss while tweening
        local bossCheckConnection
        bossCheckConnection = game:GetService("RunService").Heartbeat:Connect(function()
            -- Check if character died during tweening
            if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") or 
               not localPlayer.Character:FindFirstChild("Humanoid") or 
               localPlayer.Character.Humanoid.Health <= 0 then
                IsTweening = false
                if Tweeb then Tweeb:Cancel() end
                if bossCheckConnection then bossCheckConnection:Disconnect() end
                return
            end
            
            -- Check if all required items are obtained
            if getgenv().StopFarmingWhenItemsObtained and AreBothItemsObtained() then
                print("All required items obtained! Stopping farm...")
                IsTweening = false
                IsBossFarmActive = false
                if Tweeb then Tweeb:Cancel() end
                if bossCheckConnection then bossCheckConnection:Disconnect() end
                return
            end
            
            -- Check if any boss has appeared in the Enemies folder
            local activeBosses = FindActiveBosses()
            if #activeBosses > 0 and IsTweening then
                local highestPriorityBoss = activeBosses[1] -- First one has highest priority
                print(highestPriorityBoss.Info.Name .. " detected in Enemies folder! Breaking tween...")
                IsTweening = false
                if Tweeb then Tweeb:Cancel() end
                if bossCheckConnection then bossCheckConnection:Disconnect() end
                
                -- Immediately start attacking the boss
                KillBoss(highestPriorityBoss.Boss)
            end
        end)
        
        -- Wait for tween to complete or be cancelled
        Tweeb.Completed:Connect(function()
            IsTweening = false
            if bossCheckConnection then
                bossCheckConnection:Disconnect()
            end
        end)
    else
        print("Character not ready for tweening")
    end
end

-- Equip tool function
function EquipTool(ToolSe)
    if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
        wait(0.5)
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
    end
end

-- Auto select weapon based on type
task.spawn(function()
    while wait() do
        pcall(function()
            if ChooseWeapon == "Melee" then
                for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Melee" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            SelectWeapon = v.Name
                        end
                    end
                end
            elseif ChooseWeapon == "Sword" then
                for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Sword" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            SelectWeapon = v.Name
                        end
                    end
                end
            end
        end)
    end
end)

-- Auto Haki function
function AutoHaki()
    if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end
end

-- Detect if part exists
function DetectingPart(enemy)
    return enemy and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart")
end

-- Bring mobs function
function Bring(mobname, cfr, notcf, dis)
    for i, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == mobname and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= dis then
                v.HumanoidRootPart.CFrame = cfr
            end
        end
    end
end

-- Kill monster function
function KillMonster(name, bringmobvalue, value)
    if CheckEnemies(name) then
        local v = CheckEnemies(name)
        task.spawn(function()
            if bringmobvalue == true then
                Bring(v.Name, v.HumanoidRootPart.CFrame, (v.HumanoidRootPart.Position - v.HumanoidRootPart.Position), 350)
            end
        end)
        if DetectingPart(v) and v.Humanoid.Health > 0 then
            repeat task.wait()
                -- Check if player's character is alive
                if not game.Players.LocalPlayer.Character or 
                   not game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") or 
                   game.Players.LocalPlayer.Character.Humanoid.Health <= 0 then
                    print("Character died, waiting for respawn...")
                    WaitForRespawn()
                end
                
                -- Check if all required items are obtained
                if getgenv().StopFarmingWhenItemsObtained and AreBothItemsObtained() then
                    print("All required items obtained! Stopping farm...")
                    return
                end
                
                -- Check if enemy is still alive
                if DetectingPart(v) and v.Humanoid.Health > 0 then
                    AutoHaki()
                    EquipTool(SelectWeapon)
                    Tween(v.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)) -- Fly above the monster
                end
            until value or not DetectingPart(v) or v.Humanoid.Health <= 0 or not game.Players.LocalPlayer.Character or 
                  not game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") or 
                  game.Players.LocalPlayer.Character.Humanoid.Health <= 0
        end
    end
end

-- Direct boss killing function when boss is already found
function KillBoss(boss)
    if boss and DetectingPart(boss) and boss.Humanoid.Health > 0 then
        print("Starting to attack " .. boss.Name)
        
        task.spawn(function()
            Bring(boss.Name, boss.HumanoidRootPart.CFrame, (boss.HumanoidRootPart.Position - boss.HumanoidRootPart.Position), 350)
        end)
        
        repeat task.wait()
            -- Check if player's character is alive
            if not game.Players.LocalPlayer.Character or 
               not game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") or 
               game.Players.LocalPlayer.Character.Humanoid.Health <= 0 then
                print("Character died, waiting for respawn...")
                WaitForRespawn()
            end
            
            -- Check if all required items are obtained
            if getgenv().StopFarmingWhenItemsObtained and AreBothItemsObtained() then
                print("All required items obtained! Stopping farm...")
                IsBossFarmActive = false
                return
            end
            
            -- Check if boss is still alive
            if DetectingPart(boss) and boss.Humanoid.Health > 0 then
                AutoHaki()
                EquipTool(SelectWeapon)
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)
            end
        until not DetectingPart(boss) or boss.Humanoid.Health <= 0 or not IsBossFarmActive or 
              not game.Players.LocalPlayer.Character or 
              not game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") or 
              game.Players.LocalPlayer.Character.Humanoid.Health <= 0
        
        print(boss.Name .. " defeated or disappeared!")
    end
end

-- Connect death event to handle respawning
local function ConnectDeathEvent()
    game.Players.LocalPlayer.Character.Humanoid.Died:Connect(function()
        print("Character died, waiting for respawn...")
        IsRespawning = true
        IsTweening = false
        
        -- Wait for respawn
        WaitForRespawn()
    end)
end

-- Connect character added event
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    print("Character added, connecting death event...")
    -- Wait for humanoid to be added
    character:WaitForChild("Humanoid")
    ConnectDeathEvent()
    
    -- Character is now loaded
    IsRespawning = false
    
    -- Wait for everything to load
    wait(3)
    
    -- If boss farm is active, start over
    if IsBossFarmActive then
        print("Respawned, continuing boss farm...")
    end
end)

-- Connect to existing character if present
if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
    ConnectDeathEvent()
end

-- Main boss farming loop with priority handling
task.spawn(function()
    while task.wait(0.1) do
        -- Check if all required items are obtained
        if getgenv().StopFarmingWhenItemsObtained and AreBothItemsObtained() then
            print("All required items obtained! Stopping farm...")
            IsBossFarmActive = false
            wait(5) -- Wait a bit before checking again
            continue
        end
        
        -- Skip if currently respawning
        if IsRespawning then
            continue
        end
        
        if not IsBossFarmActive then
            -- First priority: Check if any boss already exists in the Enemies folder
            local activeBosses = FindActiveBosses()
            
            if #activeBosses > 0 then
                -- Bosses are already present in the Enemies folder
                local targetBoss = activeBosses[1] -- Get highest priority boss
                print(targetBoss.Info.Name .. " found directly in Enemies folder!")
                IsBossFarmActive = true
                
                -- Attack boss directly
                KillBoss(targetBoss.Boss)
                
                -- Reset state when boss dies
                IsBossFarmActive = false
            else
                -- No bosses found in Enemies, check spawn locations in ReplicatedStorage
                local availableSpawns = FindAvailableBossSpawns()
                
                if #availableSpawns > 0 then
                    local targetSpawn = availableSpawns[1] -- Get highest priority spawn
                    print(targetSpawn.Info.Name .. " spawn found in ReplicatedStorage! Tweening to location...")
                    wait(5)
                    IsBossFarmActive = true
                    
                    -- Tween to the boss spawn location (with continuous checking)
                    Tween(targetSpawn.SpawnCFrame)
                    
                    -- After reaching spawn location (if no boss was found during tween),
                    -- wait and check for boss again
                    if IsBossFarmActive and not IsTweening then
                        -- Check for all bosses after reaching spawn
                        local bossesAfterTween = FindActiveBosses()
                        
                        if #bossesAfterTween > 0 then
                            -- Boss found after tween, kill highest priority one
                            KillBoss(bossesAfterTween[1].Boss)
                        else
                            -- No boss found, wait at spawn location
                            print("At spawn location but no boss found. Waiting...")
                            local waitTimer = 0
                            
                            while waitTimer < 30 and #FindActiveBosses() == 0 do
                                wait(1)
                                waitTimer = waitTimer + 1
                                
                                -- Check if all required items are obtained
                                if getgenv().StopFarmingWhenItemsObtained and AreBothItemsObtained() then
                                    print("All required items obtained! Stopping farm...")
                                    IsBossFarmActive = false
                                    break
                                end
                            end
                            
                            -- Check if any boss appeared while waiting
                            local newBosses = FindActiveBosses()
                            if #newBosses > 0 then
                                KillBoss(newBosses[1].Boss)
                            end
                        end
                    end
                    
                    -- Reset state
                    IsBossFarmActive = false
                else
                    -- No boss spawns found
                    print("No boss spawns found in ReplicatedStorage. Waiting...")
                    wait(3)
                end
            end
        end
    end
end)

-- Setup a separate loop to continuously monitor for boss appearance
task.spawn(function()
    while wait(0.5) do
        if IsTweening then
            -- Check if all required items are obtained
            if getgenv().StopFarmingWhenItemsObtained and AreBothItemsObtained() then
                print("All required items obtained! Stopping farm...")
                IsBossFarmActive = false
                IsTweening = false
                continue
            end
            
            -- Check if any boss appeared while we're tweening to spawn
            local activeBosses = FindActiveBosses()
            
            if #activeBosses > 0 then
                print("Boss appeared during search! Redirecting...")
                -- The tween function will handle redirecting to the boss
            end
        end
    end
end)

-- Continue with GUI code
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local StatusFrame = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local MirrorFractalStatus = Instance.new("TextLabel")
local ValkyrieMFractalStatus = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")
local MirrorFractalIcon = Instance.new("ImageLabel")
local ValkyrieMHelmIcon = Instance.new("ImageLabel")
local MirrorFractalStatusIcon = Instance.new("ImageLabel")
local ValkyrieHelmStatusIcon = Instance.new("ImageLabel")
local MirrorFractalStatusText = Instance.new("TextLabel")
local ValkyrieHelmStatusText = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local AutoFarmStatus = Instance.new("TextLabel")

-- Properties setup
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Increased size of MainFrame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125) -- Adjusted position for larger frame
MainFrame.Size = UDim2.new(0, 350, 0, 250) -- Increased height for the auto farm status
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Selectable = true

UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 10)

-- Title
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "View Status"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24.000

-- Status Frame
StatusFrame.Name = "StatusFrame"
StatusFrame.Parent = MainFrame
StatusFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
StatusFrame.Position = UDim2.new(0, 15, 0, 50)
StatusFrame.Size = UDim2.new(0, 320, 0, 135)

UICorner_2.Parent = StatusFrame
UICorner_2.CornerRadius = UDim.new(0, 8)

UIListLayout.Parent = StatusFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 15)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- Mirror Fractal Status
MirrorFractalStatus.Name = "MirrorFractalStatus"
MirrorFractalStatus.Parent = StatusFrame
MirrorFractalStatus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MirrorFractalStatus.BackgroundTransparency = 1
MirrorFractalStatus.Position = UDim2.new(0, 50, 0, 20)
MirrorFractalStatus.Size = UDim2.new(0, 240, 0, 55)
MirrorFractalStatus.Font = Enum.Font.Gotham
MirrorFractalStatus.Text = "Mirror Fractal"
MirrorFractalStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
MirrorFractalStatus.TextSize = 20.000
MirrorFractalStatus.TextXAlignment = Enum.TextXAlignment.Left

-- Mirror Fractal Icon
MirrorFractalIcon.Name = "MirrorFractalIcon"
MirrorFractalIcon.Parent = MirrorFractalStatus
MirrorFractalIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MirrorFractalIcon.BackgroundTransparency = 1
MirrorFractalIcon.Position = UDim2.new(0, -40, 0, 0)
MirrorFractalIcon.Size = UDim2.new(0, 40, 0, 40)
MirrorFractalIcon.Image = "rbxassetid://122580054458254"
MirrorFractalIcon.ScaleType = Enum.ScaleType.Fit

-- Mirror Fractal Status Icon
MirrorFractalStatusIcon.Name = "MirrorFractalStatusIcon"
MirrorFractalStatusIcon.Parent = MirrorFractalStatus
MirrorFractalStatusIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MirrorFractalStatusIcon.BackgroundTransparency = 1
MirrorFractalStatusIcon.Position = UDim2.new(1, -40, 0, 0)
MirrorFractalStatusIcon.Size = UDim2.new(0, 40, 0, 40)
MirrorFractalStatusIcon.ScaleType = Enum.ScaleType.Fit

-- Mirror Fractal Status Text
MirrorFractalStatusText.Name = "MirrorFractalStatusText"
MirrorFractalStatusText.Parent = MirrorFractalStatus
MirrorFractalStatusText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MirrorFractalStatusText.BackgroundTransparency = 1
MirrorFractalStatusText.Position = UDim2.new(0, 0, 0, 30)
MirrorFractalStatusText.Size = UDim2.new(0, 240, 0, 25)
MirrorFractalStatusText.Font = Enum.Font.Gotham
MirrorFractalStatusText.Text = "Checking..."
MirrorFractalStatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
MirrorFractalStatusText.TextSize = 16.000
MirrorFractalStatusText.TextXAlignment = Enum.TextXAlignment.Left

-- Valkyrie Helm Status
ValkyrieMFractalStatus.Name = "ValkyrieMFractalStatus"
ValkyrieMFractalStatus.Parent = StatusFrame
ValkyrieMFractalStatus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ValkyrieMFractalStatus.BackgroundTransparency = 1
-- Continuing with Valkyrie Helm Status setup
ValkyrieMFractalStatus.Position = UDim2.new(0, 50, 0, 80)
ValkyrieMFractalStatus.Size = UDim2.new(0, 240, 0, 55)
ValkyrieMFractalStatus.Font = Enum.Font.Gotham
ValkyrieMFractalStatus.Text = "Valkyrie Helm"
ValkyrieMFractalStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
ValkyrieMFractalStatus.TextSize = 20.000
ValkyrieMFractalStatus.TextXAlignment = Enum.TextXAlignment.Left

-- Valkyrie Helm Icon
ValkyrieMHelmIcon.Name = "ValkyrieMHelmIcon"
ValkyrieMHelmIcon.Parent = ValkyrieMFractalStatus
ValkyrieMHelmIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ValkyrieMHelmIcon.BackgroundTransparency = 1
ValkyrieMHelmIcon.Position = UDim2.new(0, -40, 0, 0)
ValkyrieMHelmIcon.Size = UDim2.new(0, 40, 0, 40)
ValkyrieMHelmIcon.Image = "rbxassetid://86863879522887"
ValkyrieMHelmIcon.ScaleType = Enum.ScaleType.Fit

-- Valkyrie Helm Status Icon
ValkyrieHelmStatusIcon.Name = "ValkyrieHelmStatusIcon"
ValkyrieHelmStatusIcon.Parent = ValkyrieMFractalStatus
ValkyrieHelmStatusIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ValkyrieHelmStatusIcon.BackgroundTransparency = 1
ValkyrieHelmStatusIcon.Position = UDim2.new(1, -40, 0, 0)
ValkyrieHelmStatusIcon.Size = UDim2.new(0, 40, 0, 40)
ValkyrieHelmStatusIcon.ScaleType = Enum.ScaleType.Fit

-- Valkyrie Helm Status Text
ValkyrieHelmStatusText.Name = "ValkyrieHelmStatusText"
ValkyrieHelmStatusText.Parent = ValkyrieMFractalStatus
ValkyrieHelmStatusText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ValkyrieHelmStatusText.BackgroundTransparency = 1
ValkyrieHelmStatusText.Position = UDim2.new(0, 0, 0, 30)
ValkyrieHelmStatusText.Size = UDim2.new(0, 240, 0, 25)
ValkyrieHelmStatusText.Font = Enum.Font.Gotham
ValkyrieHelmStatusText.Text = "Checking..."
ValkyrieHelmStatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
ValkyrieHelmStatusText.TextSize = 16.000
ValkyrieHelmStatusText.TextXAlignment = Enum.TextXAlignment.Left

-- Add Auto Farm Status Text
AutoFarmStatus = Instance.new("TextLabel")
AutoFarmStatus.Name = "AutoFarmStatus"
AutoFarmStatus.Parent = MainFrame
AutoFarmStatus.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
AutoFarmStatus.BackgroundTransparency = 0.5
AutoFarmStatus.Position = UDim2.new(0, 15, 0, 195)
AutoFarmStatus.Size = UDim2.new(0, 320, 0, 40)
AutoFarmStatus.Font = Enum.Font.GothamBold
AutoFarmStatus.Text = "Auto Farm Status: Running"
AutoFarmStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
AutoFarmStatus.TextSize = 16.000

-- Add UI corner to Auto Farm Status
local UICorner_4 = Instance.new("UICorner")
UICorner_4.Parent = AutoFarmStatus
UICorner_4.CornerRadius = UDim.new(0, 8)

-- Close button
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Position = UDim2.new(1, -35, 0, 10)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16.000

UICorner_3.Parent = CloseButton
UICorner_3.CornerRadius = UDim.new(0, 10)

-- Function to update the status displays
local function UpdateStatus()
    -- Check Mirror Fractal
    local hasMirrorFractal = CheckItemInventory("Mirror Fractal")
    
    -- Update image status icon for Mirror Fractal
    if hasMirrorFractal then
        MirrorFractalStatusIcon.Image = "rbxassetid://105243636614423" -- Green image
        MirrorFractalStatusText.Text = "Available"
        MirrorFractalStatusText.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        MirrorFractalStatusIcon.Image = "rbxassetid://82930659347671" -- Red image
        MirrorFractalStatusText.Text = "Not Available"
        MirrorFractalStatusText.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
    
    -- Check Valkyrie Helm
    local hasValkyrieHelm = CheckItemInventory("Valkyrie Helm")
    
    -- Update image status icon for Valkyrie Helm
    if hasValkyrieHelm then
        ValkyrieHelmStatusIcon.Image = "rbxassetid://105243636614423" -- Green image
        ValkyrieHelmStatusText.Text = "Available"
        ValkyrieHelmStatusText.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        ValkyrieHelmStatusIcon.Image = "rbxassetid://82930659347671" -- Red image
        ValkyrieHelmStatusText.Text = "Not Available"
        ValkyrieHelmStatusText.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
    
    -- Check if both items are obtained
    if hasValkyrieHelm and hasMirrorFractal and getgenv().StopFarmingWhenItemsObtained then
        AutoFarmStatus.Text = "Auto Farm Status: Stopped (Items Obtained)"
        AutoFarmStatus.TextColor3 = Color3.fromRGB(255, 255, 0)
        IsBossFarmActive = false
    else
        if IsRespawning then
            AutoFarmStatus.Text = "Auto Farm Status: Respawning..."
            AutoFarmStatus.TextColor3 = Color3.fromRGB(255, 165, 0) -- Orange
        else if IsBossFarmActive then
                AutoFarmStatus.Text = "Auto Farm Status: Fighting Boss"
                AutoFarmStatus.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red
            else
                AutoFarmStatus.Text = "Auto Farm Status: Searching"
                AutoFarmStatus.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green
            end
        end
    end
end

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Update status initially
UpdateStatus()

-- Status update loop
task.spawn(function()
    while wait(1) do
        UpdateStatus()
    end
end)

-- Notification when script starts
print("Đã chạy script")
print("Fast Attack: Enabled")
print("Boss Priority:")
for _, bossInfo in ipairs(BossList) do
    print("- Priority " .. bossInfo.Priority .. ": " .. bossInfo.Name)
end
print("Waiting for bosses...")

-- Thêm thư viện HTTP để gọi API
local HttpService = game:GetService("HttpService")

-- Function để lấy job ID từ API
function GetJobIdFromAPI(boss)
    local apiUrl
    if boss == "rip_indra" then
        apiUrl = "https://web-production-a0a2e.up.railway.app/rareboss?key=khoadeptrai&boss=rip_indra%20True%20Form"
    elseif boss == "dough_king" then
        apiUrl = "https://web-production-a0a2e.up.railway.app/rareboss?key=khoadeptrai&boss=Dough%20King"
    end
    
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(apiUrl))
    end)
    
    if success and response.status == "true" and #response.List > 0 then
        return response.List
    end
    
    return nil
end

-- Function để join server với job ID
function JoinServer(jobId)
    if jobId then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobId)
    end
end

-- Function để check API và thực hiện hopping
function CheckAPIAndHop()
    -- Check nếu không có cả hai item
    local hasMirrorFractal = CheckItemInventory("Mirror Fractal")
    local hasValkyrieHelm = CheckItemInventory("Valkyrie Helm")
    
    if not hasMirrorFractal and not hasValkyrieHelm then
        print("Không có cả hai item, ưu tiên check RIP Indra trước...")
        local ripIndraJobs = GetJobIdFromAPI("rip_indra")
        
        if ripIndraJobs then
            print("Tìm thấy server có RIP Indra, đang thực hiện teleport...")
            for _, jobId in ipairs(ripIndraJobs) do
                JoinServer(jobId)
                wait(3) -- Đợi một chút trước khi thử job ID tiếp theo nếu teleport thất bại
            end
        else
            print("Không tìm thấy server có RIP Indra, chuyển sang check Dough King...")
            local doughKingJobs = GetJobIdFromAPI("dough_king")
            
            if doughKingJobs then
                print("Tìm thấy server có Dough King, đang thực hiện teleport...")
                for _, jobId in ipairs(doughKingJobs) do
                    JoinServer(jobId)
                    wait(3)
                end
            else
                print("Không tìm thấy server nào có boss, chờ 3 giây và thử lại...")
                wait(3)
            end
        end
    elseif not hasMirrorFractal then
        print("Không có Mirror Fractal, đang check server có Dough King...")
        local doughKingJobs = GetJobIdFromAPI("dough_king")
        
        if doughKingJobs then
            print("Tìm thấy server có Dough King, đang thực hiện teleport...")
            for _, jobId in ipairs(doughKingJobs) do
                JoinServer(jobId)
                wait(3)
            end
        else
            print("Không tìm thấy server nào có Dough King, chờ 30 giây và thử lại...")
            wait(3)
        end
    elseif not hasValkyrieHelm then
        print("Không có Valkyrie Helm, đang check server có RIP Indra...")
        local ripIndraJobs = GetJobIdFromAPI("rip_indra")
        
        if ripIndraJobs then
            print("Tìm thấy server có RIP Indra, đang thực hiện teleport...")
            for _, jobId in ipairs(ripIndraJobs) do
                JoinServer(jobId)
                wait(3)
            end
        else
            print("Không tìm thấy server nào có RIP Indra, chờ 30 giây và thử lại...")
            wait(3)
        end
    end
end

-- Thêm thông tin cho GUI về trạng thái API hopping
local ServerHoppingStatus = Instance.new("TextLabel")
ServerHoppingStatus.Name = "ServerHoppingStatus"
ServerHoppingStatus.Parent = MainFrame
ServerHoppingStatus.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ServerHoppingStatus.BackgroundTransparency = 0.5
ServerHoppingStatus.Position = UDim2.new(0, 15, 0, 195 + 45) -- Dưới Auto Farm Status
ServerHoppingStatus.Size = UDim2.new(0, 320, 0, 40)
ServerHoppingStatus.Font = Enum.Font.GothamBold
ServerHoppingStatus.Text = "Server Hopping: Waiting..."
ServerHoppingStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
ServerHoppingStatus.TextSize = 16.000

-- Thêm UI corner cho Server Hopping Status
local UICorner_5 = Instance.new("UICorner")
UICorner_5.Parent = ServerHoppingStatus
UICorner_5.CornerRadius = UDim.new(0, 8)

-- Điều chỉnh kích thước frame chính
MainFrame.Size = UDim2.new(0, 350, 0, 295) -- Tăng kích thước để có chỗ cho label mới

-- Cập nhật function UpdateStatus để cập nhật cả thông tin server hopping
local originalUpdateStatus = UpdateStatus
function UpdateStatus()
    originalUpdateStatus() -- Gọi function gốc
    
    -- Cập nhật Server Hopping Status
    local hasMirrorFractal = CheckItemInventory("Mirror Fractal")
    local hasValkyrieHelm = CheckItemInventory("Valkyrie Helm")
    
    if not hasMirrorFractal and not hasValkyrieHelm then
        ServerHoppingStatus.Text = "Server Hopping: Checking for both bosses..."
        ServerHoppingStatus.TextColor3 = Color3.fromRGB(255, 165, 0) -- Orange
    elseif not hasMirrorFractal then
        ServerHoppingStatus.Text = "Server Hopping: Checking for Dough King..."
        ServerHoppingStatus.TextColor3 = Color3.fromRGB(255, 165, 0) -- Orange
    elseif not hasValkyrieHelm then
        ServerHoppingStatus.Text = "Server Hopping: Checking for RIP Indra..."
        ServerHoppingStatus.TextColor3 = Color3.fromRGB(255, 165, 0) -- Orange
    else
        ServerHoppingStatus.Text = "Server Hopping: Not needed (Items obtained)"
        ServerHoppingStatus.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green
    end
end


task.spawn(function()
    while true do
        wait(5) 
        
        if StopFarmingWhenItemsObtained and AreBothItemsObtained() then
            ServerHoppingStatus.Text = "Server Hopping: Not needed (Items obtained)"
            ServerHoppingStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
            wait(30) 
            continue
        end
        
        if IsBossFarmActive or IsRespawning or IsTweening then
            continue
        end
        
        local activeBosses = FindActiveBosses()
        local availableSpawns = FindAvailableBossSpawns()
        
        if #activeBosses == 0 and #availableSpawns == 0 then
            ServerHoppingStatus.Text = "Server Hopping: Finding servers with bosses..."
            ServerHoppingStatus.TextColor3 = Color3.fromRGB(255, 255, 0)
            CheckAPIAndHop()
        end
    end
end)
