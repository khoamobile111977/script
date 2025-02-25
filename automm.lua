-- Chọn Team
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

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modified Orion Library Source
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Boss Farm GUI", HidePremium = false, SaveConfig = true, ConfigFolder = "BossFarm"})

-- Variables
local player = Players.LocalPlayer
local isFarming = false
local hoverHeight = 25    -- Chiều cao so với boss
local safeDistance = 20   -- Khoảng cách an toàn phía sau boss
local tweenSpeed = 300    -- Tốc độ tween (có thể điều chỉnh)

-------------------------------------------------
-- Fast Attack Implementation (không chỉnh sửa)
-------------------------------------------------
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

-------------------------------------------------
-- Các hàm điều khiển nhân vật và tween
-------------------------------------------------

local function LockCharacter()
    local character = player.Character
    if character then
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.PlatformStand = true
        humanoid:ChangeState(Enum.HumanoidStateType.PlatformStanding)
    end
end

local function UnlockCharacter()
    local character = player.Character
    if character then
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.PlatformStand = false
    end
end

-- Hàm tween đến vị trí an toàn xung quanh boss
local function TweenToSafePosition(targetCFrame)
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local safePosition = targetCFrame * CFrame.new(0, hoverHeight, -safeDistance)
    local distance = (safePosition.Position - humanoidRootPart.Position).Magnitude
    local tweenTime = distance / tweenSpeed

    humanoidRootPart.Anchored = false

    local tween = TweenService:Create(humanoidRootPart, 
        TweenInfo.new(tweenTime, Enum.EasingStyle.Linear),
        {CFrame = safePosition}
    )
    tween:Play()
    return tween
end

-- Tìm boss trong workspace
local function FindBoss()
    local boss = workspace.Enemies:FindFirstChild("Captain Elephant")
    return boss
end

-- Hàm liên tục theo dõi boss và tween đến vị trí an toàn
local function ContinuouslyFollowBoss()
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    while isFarming do
        local boss = FindBoss()
        if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
            local targetCFrame = boss.HumanoidRootPart.CFrame
            local safePosition = targetCFrame * CFrame.new(0, hoverHeight, -safeDistance)
            local distance = (safePosition.Position - humanoidRootPart.Position).Magnitude
            local tweenTime = distance / tweenSpeed

            -- Nếu khoảng cách đủ lớn thì tạo tween (để tránh rung lắc khi gần)
            if distance > 5 then
                local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = safePosition})
                tween:Play()
                tween.Completed:Wait()
            else
                task.wait(0.1)
            end
        else
            task.wait(0.1)
        end
    end
end

-------------------------------------------------
-- Hàm farm boss
-------------------------------------------------
local function FarmBoss()
    LockCharacter()
    EquipWeapon("Sharkman Karate")
    -- Bắt đầu chạy hàm theo dõi boss trong 1 luồng riêng
    local followTask = task.spawn(ContinuouslyFollowBoss)
    
    -- Vòng lặp kiểm tra boss: nếu boss chết hoặc không tồn tại, thoát khỏi farm
    while isFarming do
        local boss = FindBoss()
        if not (boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0) then
            break
        end
        task.wait(0.5)
    end
    isFarming = false
    UnlockCharacter()
end

-------------------------------------------------
-- Hàm trang bị vũ khí
-------------------------------------------------
local function EquipWeapon(weaponName)
    local weapon = player.Backpack:FindFirstChild(weaponName)
    if weapon then
        player.Character.Humanoid:EquipTool(weapon)
    end
end

-------------------------------------------------
-- Tạo tab GUI
-------------------------------------------------
local FarmTab = Window:MakeTab({
    Name = "Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

FarmTab:AddToggle({
    Name = "Farm Captain Elephant",
    Default = false,
    Callback = function(Value)
        isFarming = Value
        if Value then
            EnableFastAttack()  -- Kích hoạt tấn công nhanh
            task.spawn(FarmBoss)
        else
            _G["L*12_34"] = false  -- Tắt tấn công nhanh khi dừng farm
            UnlockCharacter()
        end
    end
})

FarmTab:AddToggle({
    Name = "Bring Mobs",
    Default = false,
    Callback = function(Value)
        _G.BringMobs = Value
    end
})
