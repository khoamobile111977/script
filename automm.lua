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
        endI
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
local hoverHeight = 25 -- Tăng chiều cao trên đầu boss
local safeDistance = 20 -- Khoảng cách an toàn để tránh đòn đánh của boss
local tweenSpeed = 300 -- Tốc độ tween cố định
local currentTween = nil
local lastPositionUpdate = 0
local positionUpdateInterval = 0.5

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
    local character = player.Character
    if character then
        local humanoid = character:WaitForChild("Humanoid")
        -- Remove anchoring of HumanoidRootPart
        humanoid.PlatformStand = true
        humanoid:ChangeState(Enum.HumanoidStateType.PlatformStanding)
    end
end

local function UnlockCharacter()
    local character = player.Character
    if character then
        local humanoid = character:WaitForChild("Humanoid")
        -- Re-enable character controls
        humanoid.PlatformStand = false
    end
end

local function TweenToPosition(targetCFrame)
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Cancel existing tween to prevent conflicts
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    
    -- Calculate a stable position relative to the boss
    local offset = CFrame.new(0, hoverHeight, -safeDistance)
    local safePosition = targetCFrame * offset
    
    -- Calculate tween duration based on distance for smooth movement
    local distance = (safePosition.Position - humanoidRootPart.Position).Magnitude
    local tweenTime = math.min(distance / tweenSpeed, 10) -- Cap at 10 seconds max
    
    -- Create and play the tween
    currentTween = TweenService:Create(
        humanoidRootPart, 
        TweenInfo.new(
            tweenTime, 
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        ),
        {CFrame = safePosition}
    )
    
    currentTween:Play()
    
    -- Return the tween so we can track its completion
    return currentTween
end

local function EquipWeapon(weaponName)
    local weapon = player.Backpack:FindFirstChild(weaponName)
    if weapon then
        player.Character.Humanoid:EquipTool(weapon)
    end
end

local function FindBoss()
    local boss = workspace.Enemies:FindFirstChild("Captain Elephant")
    return boss
end

-- Improved boss following with better stability
local function FollowBoss()
    task.spawn(function()
        while isFarming do
            local now = tick()
            -- Only update position periodically to reduce jitter
            if now - lastPositionUpdate >= positionUpdateInterval then
                lastPositionUpdate = now
                
                local boss = FindBoss()
                if boss and boss:FindFirstChild("HumanoidRootPart") then
                    local bossHRP = boss:FindFirstChild("HumanoidRootPart")
                    if bossHRP then
                        -- Only tween if we're not already close enough
                        local character = player.Character
                        if character then
                            local hrp = character:FindFirstChild("HumanoidRootPart")
                            if hrp and (hrp.Position - bossHRP.Position).Magnitude > (safeDistance + 5) then
                                TweenToPosition(bossHRP.CFrame)
                            end
                        end
                    end
                end
            end
            task.wait(0.05) -- Check more frequently but update position less frequently
        end
    end)
end

-- Improved Farm Function
local function FarmBoss()
    task.spawn(function()
        while isFarming do
            local boss = FindBoss()
            
            if boss and boss:FindFirstChild("HumanoidRootPart") then
                -- Stabilize character to prevent jittering
                StabilizeCharacter()
                
                -- Equip weapon
                EquipWeapon("Sharkman Karate")
                
                -- Start following boss with improved stability
                FollowBoss()
                
                -- Attack logic
                local isRealBoss = boss.Name == "Captain Elephant"
                
                while isFarming do
                    if isRealBoss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health <= 0 then
                        -- Boss is dead, wait for respawn
                        break
                    elseif not isRealBoss and workspace.Enemies:FindFirstChild("Captain Elephant") then
                        -- Found real boss, switch to it
                        break
                    elseif not boss:IsDescendantOf(workspace) then
                        -- Boss was removed from workspace
                        break
                    end
                    
                    -- Allow short wait between attack attempts for stability
                    task.wait(0.1)
                end
            end
            
            task.wait(1)
        end
        
        -- Cleanup when farming stops
        RestoreCharacter()
    end)
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
