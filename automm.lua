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
        end -- Fixed missing 'end' instead of 'endI'
    end
end)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modified Orion Library Source
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Boss Farm GUI", HidePremium = false, SaveConfig = true, ConfigFolder = "BossFarm"})

-- Variables
local player = Players.LocalPlayer
local isFarming = false
local hoverHeight = 25 -- Height above boss
local safeDistance = 20 -- Safe distance to avoid boss attacks
local tweenSpeed = 300 -- Fixed tween speed
local currentTween = nil
local isCharacterLocked = false

-- Target Boss Configuration
local targetBoss = "Captain Elephant"
local knownBossPositions = {
    ["Captain Elephant"] = Vector3.new(62, 75, -1389) -- Add the approximate position of the boss
    -- Add more boss positions as needed
}

-- Fast Attack Implementation
_G["L*12_34"] = false
local function EnableFastAttack()
    _G["L*12_34"] = true
    if _G["L*12_34"] then
        local L_1A, L_2B, L_3C = game:GetService("ReplicatedStorage"), game:GetService("Players"), game.Players.LocalPlayer
        local L_4D = {L_5E = true, L_6F = 0.001, L_7G = 200, L_8H = 200}
        local L_9I = L_1A:WaitForChild("Modules"):WaitForChild("Net")
        
        local function L_10J(L_11K)
            return L_11K and L_11K:FindFirstChild("Humanoid") and L_11K.Humanoid.Health > 0
        end
        
        local function L_12L()
            local L_13M = {}
            for _, L_14N in ipairs(workspace.Enemies:GetChildren()) do
                if L_10J(L_14N) then
                    local L_15O = L_14N:FindFirstChild("Head")
                    if L_15O and L_3C:DistanceFromCharacter(L_15O.Position) <= L_4D.L_7G then
                        table.insert(L_13M, {["Enemy"] = L_14N, ["Target"] = L_15O})
                    end
                end
            end
            return L_13M
        end
        
        local function L_16P()
            local L_17Q, L_18R = 0, 0
            return function()
                local L_19S = tick()
                if L_19S - L_17Q >= 1 then
                    L_17Q, L_18R = L_19S, 0
                end
                L_18R = L_18R + 1
                if L_18R <= L_4D.L_8H then
                    return true
                else
                    task.wait(0.005)
                    return false
                end
            end
        end
        
        task.spawn(function()
            while _G["L*12_34"] do
                if L_4D.L_5E and L_16P()() then
                    for _, L_20T in ipairs(L_12L()) do
                        L_9I["RE/RegisterAttack"]:FireServer(0)
                        L_9I["RE/RegisterHit"]:FireServer(L_20T.Target, {{L_20T.Enemy, L_20T.Target}})
                    end
                end
                task.wait(L_4D.L_6F)
            end
        end)
    end
end

-- Functions
local function LockCharacter()
    if isCharacterLocked then return end
    
    local character = player.Character
    if character then
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.PlatformStand = true
        humanoid:ChangeState(Enum.HumanoidStateType.PlatformStanding)
        isCharacterLocked = true
    end
end

local function UnlockCharacter()
    local character = player.Character
    if character then
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.PlatformStand = false
        isCharacterLocked = false
    end
end

-- Cancel current tween if exists
local function CancelCurrentTween()
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
end

local function StabilizeCFrame(targetCFrame)
    -- Return a clean CFrame with only position and Y-axis rotation (to prevent shaking)
    local position = targetCFrame.Position
    local _, y, _ = CFrame.new(position, position + targetCFrame.LookVector).Rotation:ToEulerAnglesYXZ()
    return CFrame.new(position) * CFrame.Angles(0, y, 0)
end

local function TweenToPosition(targetCFrame)
    CancelCurrentTween()
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Stabilize the target CFrame to prevent shaking
    local stableCFrame = StabilizeCFrame(targetCFrame)
    
    -- Calculate position with safe distance and height
    local safePosition = stableCFrame * CFrame.new(0, hoverHeight, -safeDistance)
    
    -- Calculate distance for fixed speed
    local distance = (safePosition.Position - humanoidRootPart.Position).Magnitude
    local tweenTime = distance / tweenSpeed
    
    -- Create and play tween
    humanoidRootPart.Anchored = false
    
    currentTween = TweenService:Create(
        humanoidRootPart, 
        TweenInfo.new(tweenTime, Enum.EasingStyle.Linear),
        {CFrame = safePosition}
    )
    
    currentTween:Play()
    return currentTween
end

local function EquipWeapon(weaponName)
    if not player.Character then return end
    
    local weapon = player.Backpack:FindFirstChild(weaponName)
    if weapon then
        player.Character.Humanoid:EquipTool(weapon)
        return true
    end
    return false
end

-- Improved boss finding function
local function FindBoss()
    -- First check if boss exists in workspace
    local boss = workspace.Enemies:FindFirstChild(targetBoss)
    if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
        return boss
    end
    
    -- If boss is not found, return nil but we'll use knownBossPositions instead
    return nil
end

local function GetBossCFrame()
    local boss = FindBoss()
    
    if boss and boss:FindFirstChild("HumanoidRootPart") then
        -- Boss is loaded, return its actual CFrame
        return boss.HumanoidRootPart.CFrame
    elseif knownBossPositions[targetBoss] then
        -- Boss not loaded, but we know where it should be
        local position = knownBossPositions[targetBoss]
        return CFrame.new(position)
    end
    
    -- No boss found and no known position
    return nil
end

-- Fixed boss following function to prevent shaking
local function StableBossFollowing()
    task.spawn(function()
        while isFarming do
            local bossCFrame = GetBossCFrame()
            
            if bossCFrame then
                -- Only create a new tween if we don't have an active one or if it's completed
                if not currentTween or currentTween.PlaybackState == Enum.PlaybackState.Completed then
                    TweenToPosition(bossCFrame)
                end
            else
                -- If we can't find the boss or its position, wait longer before retrying
                task.wait(1)
            end
            
            -- Short wait to prevent excessive updates that cause shaking
            task.wait(0.5)
        end
    end)
end

-- Teleport to boss spawn area if boss is not loaded
local function TeleportToBossSpawn()
    local bossCFrame = GetBossCFrame()
    if bossCFrame then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            TweenToPosition(bossCFrame)
            return true
        end
    end
    return false
end

-- Farm Function
local function FarmBoss()
    if isFarming then
        -- Lock character movement
        LockCharacter()
        
        -- Equip weapon
        EquipWeapon("Sharkman Karate")
        
        -- Teleport to boss spawn if not in range
        TeleportToBossSpawn()
        
        -- Start stable following
        StableBossFollowing()
        
        -- Start farming loop
        task.spawn(function()
            while isFarming do
                local boss = FindBoss()
                
                -- If boss is found and loaded, attack
                if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    -- Continue attacking
                else
                    -- Boss not found or not loaded, wait briefly
                    task.wait(1)
                end
                
                task.wait(0.1)
            end
        end)
    else
        -- Clean up when farming stops
        CancelCurrentTween()
        UnlockCharacter()
    end
end

-- Main Tab
local FarmTab = Window:MakeTab({
    Name = "Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- UI Toggles
FarmTab:AddToggle({
    Name = "Farm Captain Elephant",
    Default = false,
    Callback = function(Value)
        isFarming = Value
        if Value then
            EnableFastAttack() -- Enable fast attack when farming starts
            FarmBoss()
        else
            _G["L*12_34"] = false -- Disable fast attack when farming stops
            CancelCurrentTween()
            UnlockCharacter()
        end
    end
})

-- Add Bring Mob Toggle
FarmTab:AddToggle({
    Name = "Bring Mobs",
    Default = false,
    Callback = function(Value)
        _G.BringMobs = Value
    end
})

-- Add boss selection dropdown
local BossesTab = Window:MakeTab({
    Name = "Bosses",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Add boss position finder
BossesTab:AddButton({
    Name = "Save Current Boss Position",
    Callback = function()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local position = character.HumanoidRootPart.Position
            knownBossPositions[targetBoss] = position
            OrionLib:MakeNotification({
                Name = "Position Saved",
                Content = "Saved position for " .. targetBoss,
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})
