if _G["L_12_34"] then
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
        while _G["L_12_34"] do
            if L_4D.L_5E and L_16P() then
                for _, L_20T in ipairs(L_12L()) do
                    L_9I["RE/RegisterAttack"]:FireServer(0)
                    L_9I["RE/RegisterHit"]:FireServer(L_20T.Target, {{L_20T.Enemy, L_20T.Target}})
                end
            end
            task.wait(L_4D.L_6F)
        end
    end)
end

local G2L = {}
local G2L_REQUIRE = require;
local G2L_MODULES = {};
local function require(Module:ModuleScript)
	local ModuleState = G2L_MODULES[Module];
	if ModuleState then
		if not ModuleState.Required then
			ModuleState.Required = true;
			ModuleState.Value = ModuleState.Closure();
		end
		return ModuleState.Value;
	end;
	return G2L_REQUIRE(Module);
end

-- Remove existing UI code
-- G2L["0"] = Instance.new("ScreenGui")
-- G2L["1"] = Instance.new("Frame")
-- ...existing code...
-- G2L["17"] = Instance.new("UICorner")

-- Add new UI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local FPSText = Instance.new("TextLabel")
local TimeText = Instance.new("TextLabel")
local FruitText = Instance.new("TextLabel")
local BossText = Instance.new("TextLabel")

ScreenGui.Name = "MainGui"
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Position = UDim2.new(0.03, 0, 0.56, 0)
MainFrame.Size = UDim2.new(0, 244, 0, 149)

FPSText.Name = "FPSText"
FPSText.Parent = MainFrame
FPSText.Font = Enum.Font.SourceSans
FPSText.Text = "FPS: 0 | Ping: 0"
FPSText.TextColor3 = Color3.fromRGB(255, 255, 255)
FPSText.Position = UDim2.new(0, 0, 0, 0)
FPSText.Size = UDim2.new(1, 0, 0, 30)

TimeText.Name = "TimeText"
TimeText.Parent = MainFrame
TimeText.Font = Enum.Font.SourceSans
TimeText.Text = "Time Played: 0h 0m 0s"
TimeText.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeText.Position = UDim2.new(0, 0, 0, 30)
TimeText.Size = UDim2.new(1, 0, 0, 30)

FruitText.Name = "FruitText"
FruitText.Parent = MainFrame
FruitText.Font = Enum.Font.SourceSans
FruitText.Text = "Fruit Spawned: ❌"
FruitText.TextColor3 = Color3.fromRGB(255, 255, 255)
FruitText.Position = UDim2.new(0, 0, 0, 60)
FruitText.Size = UDim2.new(1, 0, 0, 30)

BossText.Name = "BossText"
BossText.Parent = MainFrame
BossText.Font = Enum.Font.SourceSans
BossText.Text = "Boss Status: None"
BossText.TextColor3 = Color3.fromRGB(255, 255, 255)
BossText.Position = UDim2.new(0, 0, 0, 90)
BossText.Size = UDim2.new(1, 0, 0, 30)

-- Update FPS and Ping
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

RunService.RenderStepped:Connect(function(frame)
	local fps = math.round(1 / frame)    
	local pingValue = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
	FPSText.Text = "FPS: " .. fps .. " | Ping: " .. math.round(pingValue)
end)

-- Update Time Played
function setTime()
	local GameTime = math.floor(workspace.DistributedGameTime + 0.5)
	local Hour = math.floor(GameTime / (60^2)) % 24
	local Minute = math.floor(GameTime / (60^1)) % 60
	local Second = math.floor(GameTime / (60^0)) % 60
	TimeText.Text = ("Time Played: " .. Hour .. "h " .. Minute .. "m " .. Second .. "s")
end

spawn(function()
	while task.wait() do
		pcall(function()
			setTime()
		end)
	end
end)

-- Update Fruit Status
spawn(function()
	pcall(function()
		while wait(1) do  
			local foundFruit = false
			for _, v in pairs(game.Workspace:GetChildren()) do
				if string.find(v.Name, "Fruit") then
					FruitText.Text = ("Fruit Spawned: " .. v.Name)
					foundFruit = true
				end
			end
			if not foundFruit then
				FruitText.Text = ("Fruit Spawned: ❌")
			end
		end
	end)
end)

-- Update Boss Status
local function updateBossStatus(status)
	BossText.Text = "Boss Status: " .. status
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart", 9)
local Humanoid = Character:WaitForChild("Humanoid", 9)

getgenv().TweenSpeed = 350

local placeid = game.PlaceId

function WaitHRP(q0) 
    if not q0 then return end
    return q0.Character:WaitForChild("HumanoidRootPart", 9) 
end

function Tween(Pos)
    if game.Players.LocalPlayer.Character.Humanoid.Health > 0 and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
            game.Players.LocalPlayer.Character.Humanoid.Sit = false
        end
        pcall(
            function()
                Tweeb =
                    game:GetService("TweenService"):Create(
                    game.Players.LocalPlayer.Character.HumanoidRootPart,
                    TweenInfo.new(Distance / getgenv().TweenSpeed, Enum.EasingStyle.Linear),
                    {CFrame = Pos}
                )
            end
        )
        Tweeb:Play()
        if Distance <= 370 then
            Tweeb:Cancel()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
        end
    end
end

function Taixiu(Pos)
    repeat wait()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
        game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid"):ChangeState(15)
        wait(2)
        game.Players.LocalPlayer.Character.PrimaryPart.CFrame = Pos
        wait(3)
    until (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 2000
end

function InstanceTween(P)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = P
end

spawn(function()
        while wait() do
            pcall(function()
                if _G["DitBossDoughKing"] or _G["DitBossIndra"] or NoCLip == true then
                    if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyGyro") then
                        local Noclip = Instance.new("BodyVelocity")
                        Noclip.Name = "BodyClip"
                        Noclip.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                        Noclip.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        Noclip.Velocity = Vector3.new(0, 0, 0)
                        for i, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                else
                    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
                end
            end)
        end
    end)

local function EquipTool(toolName)
    local tool = LocalPlayer.Backpack:FindFirstChild(toolName)
    if tool and Character and Character:FindFirstChild("Humanoid") then
        task.wait(0.1)
        Character.Humanoid:EquipTool(tool)
    end
end

local function AutoHaki()
    if not Character:FindFirstChild("HasBuso") then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

local function CheckStun()
    local stun = Character:FindFirstChild("Stun")
    return stun and stun.Value ~= 0 or false
end

CheckStun()

local ChooseWeapon = "Melee"
local SelectWeapon = nil
task.spawn(function()
    while task.wait(0.5) do
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool.ToolTip == ChooseWeapon then
                SelectWeapon = tool.Name
                break
            end
        end
    end
end)

local CongCake = CFrame.new(-2009.2802734375, 4532.97216796875, -14937.3076171875)

spawn(function()
    while wait() do
        if _G["DitBossDoughKing"] then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then
                    for v1440, v1441 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if (v1441.Name == "Dough King") then
                            if (v1441:FindFirstChild("Humanoid") and v1441:FindFirstChild("HumanoidRootPart") and (v1441.Humanoid.Health > 0)) then
                                repeat
                                    task.wait();
                                    G2L["7"].Text = "Dit Dough King 🪞";
                                    AutoHaki();
                                    EquipTool(SelectWeapon);
                                    v1441.HumanoidRootPart.CanCollide = false;
                                    v1441.Humanoid.WalkSpeed = 0;
                                    v1441.HumanoidRootPart.Size = Vector3.new(60, 60, 60);
                                    Tween(v1441.HumanoidRootPart.CFrame * Pos);
                                    _G["L_12_34"] = true
                                until not _G["DitBossDoughKing"] or not v1441.Parent or (v1441.Humanoid.Health <= 0)
                            end
                        end
                    end
                else 
                    Tween(CongCake)
                end
            end);
        end
    end
end);

local AdminPos = CFrame.new(-5344.822265625, 423.98541259766, -2725.0930175781)

spawn(function()
    while wait() do
        if _G["DitBossIndra"] then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("rip_indra True Form") or game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") then
                    for v1440, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == ("rip_indra True Form" or v.Name == "rip_indra") and v.Humanoid.Health > 0 and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            if (v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and (v.Humanoid.Health > 0)) then
                                repeat
                                    task.wait();
                                    G2L["7"].Text = "Dit Rip Indra 🗡️";
                                    AutoHaki();
                                    EquipTool(SelectWeapon);
                                    v.HumanoidRootPart.CanCollide = false;
                                    v.Humanoid.WalkSpeed = 0;
                                    v.HumanoidRootPart.Size = Vector3.new(60, 60, 60);
                                    Tween(v.HumanoidRootPart.CFrame * Pos);
                                    _G["L_12_34"] = true
                                until not _G["DitBossIndra"] or not v.Parent or (v.Humanoid.Health <= 0)
                            end
                        end
                    end
                else 
                    Tween(AdminPos)
                end
            end);
        end
    end
end);

-- Example usage of updateBossStatus
updateBossStatus("Dough King Detected")
