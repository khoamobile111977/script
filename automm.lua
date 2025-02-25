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


G2L["0"] = Instance.new("ScreenGui")
G2L["1"] = Instance.new("Frame")
G2L["2"] = Instance.new("Frame")
G2L["3"] = Instance.new("UICorner")
G2L["4"] = Instance.new("Frame")
G2L["5"] = Instance.new("TextLabel")
G2L["6"] = Instance.new("TextLabel")
G2L["7"] = Instance.new("TextLabel")
G2L["8"] = Instance.new("ImageLabel")
G2L["9"] = Instance.new("TextLabel")
G2L["10"] = Instance.new("ImageLabel")
G2L["11"] = Instance.new("TextLabel")
G2L["12"] = Instance.new("ImageLabel")
G2L["13"] = Instance.new("TextLabel")
G2L["14"] = Instance.new("ImageLabel")
G2L["15"] = Instance.new("TextLabel")
G2L["16"] = Instance.new("ImageLabel")
G2L["17"] = Instance.new("UICorner")


G2L["0"].Name = [[MainGui]]
G2L["0"].Enabled = true
G2L["0"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
G2L["0"].Parent = game.Players.LocalPlayer.PlayerGui

G2L["1"].Name = [[MainFarme]]
G2L["1"].Active = false
G2L["1"].AnchorPoint = Vector2.new(0, 0)
G2L["1"].BackgroundColor3 = Color3.fromRGB(70, 70, 70)
G2L["1"].BackgroundTransparency = 0.2
G2L["1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["1"].BorderSizePixel = 0
G2L["1"].ClipsDescendants = true
G2L["1"].Draggable = false
G2L["1"].Position = UDim2.new(0.030303031, 0, 0.5577618, 0)
G2L["1"].Rotation = 0
G2L["1"].Selectable = false
G2L["1"].SelectionOrder = 0
G2L["1"].Size = UDim2.new(0, 244, 0, 149)
G2L["1"].Visible = true
G2L["1"].ZIndex = 1
G2L["1"].Parent = G2L["0"]

G2L["2"].Name = [[FrameDebug]]
G2L["2"].Active = false
G2L["2"].AnchorPoint = Vector2.new(0, 0)
G2L["2"].BackgroundColor3 = Color3.fromRGB(184, 0, 3)
G2L["2"].BackgroundTransparency = 0
G2L["2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["2"].BorderSizePixel = 0
G2L["2"].ClipsDescendants = false
G2L["2"].Draggable = false
G2L["2"].Position = UDim2.new(0, 0, 0, 0)
G2L["2"].Rotation = 0
G2L["2"].Selectable = false
G2L["2"].SelectionOrder = 0
G2L["2"].Size = UDim2.new(0, 244, 0, 20)
G2L["2"].Visible = true
G2L["2"].ZIndex = 1
G2L["2"].Parent = G2L["1"]

G2L["3"].Name = [[UICornerFrameDebug]]
G2L["3"].CornerRadius = UDim.new(0, 8)
G2L["3"].Parent = G2L["2"]

G2L["4"].Name = [[DontCareToMuch]]
G2L["4"].Active = false
G2L["4"].AnchorPoint = Vector2.new(0, 0)
G2L["4"].BackgroundColor3 = Color3.fromRGB(184, 0, 3)
G2L["4"].BackgroundTransparency = 0.2
G2L["4"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["4"].BorderSizePixel = 0
G2L["4"].ClipsDescendants = false
G2L["4"].Draggable = false
G2L["4"].Position = UDim2.new(0, 0, 0.6315781, 0)
G2L["4"].Rotation = 0
G2L["4"].Selectable = false
G2L["4"].SelectionOrder = 0
G2L["4"].Size = UDim2.new(0, 268, 0, 7)
G2L["4"].Visible = true
G2L["4"].ZIndex = 1
G2L["4"].Parent = G2L["2"]

G2L["5"].Name = [[Title]]
G2L["5"].FontFace = Font.new([[rbxasset://fonts/families/DenkOne.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
G2L["5"].Text = [[HOHO]]
G2L["5"].TextColor3 = Color3.fromRGB(255, 255, 255)
G2L["5"].TextScaled = false
G2L["5"].TextSize = 15
G2L["5"].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
G2L["5"].TextStrokeTransparency = 1
G2L["5"].TextWrapped = false
G2L["5"].TextXAlignment = Enum.TextXAlignment.Center
G2L["5"].TextYAlignment = Enum.TextYAlignment.Center
G2L["5"].Active = false
G2L["5"].AnchorPoint = Vector2.new(0, 0)
G2L["5"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G2L["5"].BackgroundTransparency = 1
G2L["5"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["5"].BorderSizePixel = 0
G2L["5"].ClipsDescendants = false
G2L["5"].Draggable = false
G2L["5"].Position = UDim2.new(0, 0, 0, 0)
G2L["5"].Rotation = 0
G2L["5"].Selectable = false
G2L["5"].SelectionOrder = 0
G2L["5"].Size = UDim2.new(0, 73, 0, 19)
G2L["5"].Visible = true
G2L["5"].ZIndex = 1
G2L["5"].Parent = G2L["2"]

G2L["6"].Name = [[Debug]]
G2L["6"].FontFace = Font.new([[rbxasset://fonts/families/DenkOne.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
G2L["6"].Text = [[DEBUG]]
G2L["6"].TextColor3 = Color3.fromRGB(0, 0, 0)
G2L["6"].TextScaled = false
G2L["6"].TextSize = 15
G2L["6"].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
G2L["6"].TextStrokeTransparency = 1
G2L["6"].TextWrapped = false
G2L["6"].TextXAlignment = Enum.TextXAlignment.Left
G2L["6"].TextYAlignment = Enum.TextYAlignment.Center
G2L["6"].Active = false
G2L["6"].AnchorPoint = Vector2.new(0, 0)
G2L["6"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G2L["6"].BackgroundTransparency = 1
G2L["6"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["6"].BorderSizePixel = 0
G2L["6"].ClipsDescendants = false
G2L["6"].Draggable = false
G2L["6"].Position = UDim2.new(0.23770492, 0, 0, 0)
G2L["6"].Rotation = 0
G2L["6"].Selectable = false
G2L["6"].SelectionOrder = 0
G2L["6"].Size = UDim2.new(0, 127, 0, 19)
G2L["6"].Visible = true
G2L["6"].ZIndex = 1
G2L["6"].Parent = G2L["2"]

G2L["7"].Name = [[status]]
G2L["7"].FontFace = Font.new([[rbxasset://fonts/families/DenkOne.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
G2L["7"].Text = [[Loading...]]
G2L["7"].TextColor3 = Color3.fromRGB(255, 255, 255)
G2L["7"].TextScaled = false
G2L["7"].TextSize = 15
G2L["7"].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
G2L["7"].TextStrokeTransparency = 1
G2L["7"].TextWrapped = false
G2L["7"].TextXAlignment = Enum.TextXAlignment.Left
G2L["7"].TextYAlignment = Enum.TextYAlignment.Center
G2L["7"].Active = false
G2L["7"].AnchorPoint = Vector2.new(0, 0)
G2L["7"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G2L["7"].BackgroundTransparency = 1
G2L["7"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["7"].BorderSizePixel = 0
G2L["7"].ClipsDescendants = false
G2L["7"].Draggable = false
G2L["7"].Position = UDim2.new(0.094262294, 0, 1.3494738, 0)
G2L["7"].Rotation = 0
G2L["7"].Selectable = false
G2L["7"].SelectionOrder = 0
G2L["7"].Size = UDim2.new(0, 230, 0, 16)
G2L["7"].Visible = true
G2L["7"].ZIndex = 1
G2L["7"].Parent = G2L["2"]

G2L["8"].Name = [[Tick1]]
G2L["8"].Image = [[rbxassetid://377245168]]
G2L["8"].ImageColor3 = Color3.fromRGB(255, 255, 255)
G2L["8"].ScaleType = Enum.ScaleType.Stretch
G2L["8"].SliceCenter = Rect.new(0, 0, 0, 0)
G2L["8"].TileSize = UDim2.new(1, 0, 1, 0)
G2L["8"].Active = false
G2L["8"].AnchorPoint = Vector2.new(0, 0)
G2L["8"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G2L["8"].BackgroundTransparency = 1
G2L["8"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["8"].BorderSizePixel = 0
G2L["8"].ClipsDescendants = false
G2L["8"].Draggable = false
G2L["8"].Position = UDim2.new(-0.09271804, 0, -0.055921555, 0)
G2L["8"].Rotation = 0
G2L["8"].Selectable = false
G2L["8"].SelectionOrder = 0
G2L["8"].Size = UDim2.new(0, 15, 0, 15)
G2L["8"].Visible = true
G2L["8"].ZIndex = 1
G2L["8"].Parent = G2L["7"]

G2L["9"].Name = [[StatusAnthor]]
G2L["9"].FontFace = Font.new([[rbxasset://fonts/families/DenkOne.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
G2L["9"].Text = [[FPS]]
G2L["9"].TextColor3 = Color3.fromRGB(255, 255, 255)
G2L["9"].TextScaled = false
G2L["9"].TextSize = 15
G2L["9"].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
G2L["9"].TextStrokeTransparency = 1
G2L["9"].TextWrapped = false
G2L["9"].TextXAlignment = Enum.TextXAlignment.Left
G2L["9"].TextYAlignment = Enum.TextYAlignment.Center
G2L["9"].Active = false
G2L["9"].AnchorPoint = Vector2.new(0, 0)
G2L["9"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G2L["9"].BackgroundTransparency = 1
G2L["9"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["9"].BorderSizePixel = 0
G2L["9"].ClipsDescendants = false
G2L["9"].Draggable = false
G2L["9"].Position = UDim2.new(0.094262294, 0, 2.4126318, 0)
G2L["9"].Rotation = 0
G2L["9"].Selectable = false
G2L["9"].SelectionOrder = 0
G2L["9"].Size = UDim2.new(0, 230, 0, 16)
G2L["9"].Visible = true
G2L["9"].ZIndex = 1
G2L["9"].Parent = G2L["2"]

G2L["10"].Name = [[Tick2]]
G2L["10"].Image = [[rbxassetid://377245168]]
G2L["10"].ImageColor3 = Color3.fromRGB(255, 255, 255)
G2L["10"].ScaleType = Enum.ScaleType.Stretch
G2L["10"].SliceCenter = Rect.new(0, 0, 0, 0)
G2L["10"].TileSize = UDim2.new(1, 0, 1, 0)
G2L["10"].Active = false
G2L["10"].AnchorPoint = Vector2.new(0, 0)
G2L["10"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G2L["10"].BackgroundTransparency = 1
G2L["10"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["10"].BorderSizePixel = 0
G2L["10"].ClipsDescendants = false
G2L["10"].Draggable = false
G2L["10"].Position = UDim2.new(-0.09480433, 0, 0.0625, 0)
G2L["10"].Rotation = 0
G2L["10"].Selectable = false
G2L["10"].SelectionOrder = 0
G2L["10"].Size = UDim2.new(0, 15, 0, 15)
G2L["10"].Visible = true
G2L["10"].ZIndex = 1
G2L["10"].Parent = G2L["9"]

G2L["11"].Name = [[Time]]
G2L["11"].FontFace = Font.new([[rbxasset://fonts/families/DenkOne.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
G2L["11"].Text = [[Time]]
G2L["11"].TextColor3 = Color3.fromRGB(255, 255, 255)
G2L["11"].TextScaled = false
G2L["11"].TextSize = 15
G2L["11"].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
G2L["11"].TextStrokeTransparency = 1
G2L["11"].TextWrapped = false
G2L["11"].TextXAlignment = Enum.TextXAlignment.Left
G2L["11"].TextYAlignment = Enum.TextYAlignment.Center
G2L["11"].Active = false
G2L["11"].AnchorPoint = Vector2.new(0, 0)
G2L["11"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G2L["11"].BackgroundTransparency = 1
G2L["11"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["11"].BorderSizePixel = 0
G2L["11"].ClipsDescendants = false
G2L["11"].Draggable = false
G2L["11"].Position = UDim2.new(0.094262294, 0, 3.6063159, 0)
G2L["11"].Rotation = 0
G2L["11"].Selectable = false
G2L["11"].SelectionOrder = 0
G2L["11"].Size = UDim2.new(0, 230, 0, 16)
G2L["11"].Visible = true
G2L["11"].ZIndex = 1
G2L["11"].Parent = G2L["2"]

G2L["12"].Name = [[Tick3]]
G2L["12"].Image = [[rbxassetid://377245168]]
G2L["12"].ImageColor3 = Color3.fromRGB(255, 255, 255)
G2L["12"].ScaleType = Enum.ScaleType.Stretch
G2L["12"].SliceCenter = Rect.new(0, 0, 0, 0)
G2L["12"].TileSize = UDim2.new(1, 0, 1, 0)
G2L["12"].Active = false
G2L["12"].AnchorPoint = Vector2.new(0, 0)
G2L["12"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G2L["12"].BackgroundTransparency = 1
G2L["12"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["12"].BorderSizePixel = 0
G2L["12"].ClipsDescendants = false
G2L["12"].Draggable = false
G2L["12"].Position = UDim2.new(-0.09565217, 0, 0.0625, 0)
G2L["12"].Rotation = 0
G2L["12"].Selectable = false
G2L["12"].SelectionOrder = 0
G2L["12"].Size = UDim2.new(0, 15, 0, 15)
G2L["12"].Visible = true
G2L["12"].ZIndex = 1
G2L["12"].Parent = G2L["11"]

G2L["13"].Name = [[NextMoon]]
G2L["13"].FontFace = Font.new([[rbxasset://fonts/families/DenkOne.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
G2L["13"].Text = [[Next 🌕]]
G2L["13"].TextColor3 = Color3.fromRGB(255, 255, 255)
G2L["13"].TextScaled = false
G2L["13"].TextSize = 15
G2L["13"].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
G2L["13"].TextStrokeTransparency = 1
G2L["13"].TextWrapped = false
G2L["13"].TextXAlignment = Enum.TextXAlignment.Left
G2L["13"].TextYAlignment = Enum.TextYAlignment.Center
G2L["13"].Active = false
G2L["13"].AnchorPoint = Vector2.new(0, 0)
G2L["13"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G2L["13"].BackgroundTransparency = 1
G2L["13"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["13"].BorderSizePixel = 0
G2L["13"].ClipsDescendants = false
G2L["13"].Draggable = false
G2L["13"].Position = UDim2.new(0.094262294, 0, 4.692631, 0)
G2L["13"].Rotation = 0
G2L["13"].Selectable = false
G2L["13"].SelectionOrder = 0
G2L["13"].Size = UDim2.new(0, 230, 0, 16)
G2L["13"].Visible = true
G2L["13"].ZIndex = 1
G2L["13"].Parent = G2L["2"]

G2L["14"].Name = [[Tick4]]
G2L["14"].Image = [[rbxassetid://377245168]]
G2L["14"].ImageColor3 = Color3.fromRGB(255, 255, 255)
G2L["14"].ScaleType = Enum.ScaleType.Stretch
G2L["14"].SliceCenter = Rect.new(0, 0, 0, 0)
G2L["14"].TileSize = UDim2.new(1, 0, 1, 0)
G2L["14"].Active = false
G2L["14"].AnchorPoint = Vector2.new(0, 0)
G2L["14"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G2L["14"].BackgroundTransparency = 1
G2L["14"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["14"].BorderSizePixel = 0
G2L["14"].ClipsDescendants = false
G2L["14"].Draggable = false
G2L["14"].Position = UDim2.new(-0.09565217, 0, 0, 0)
G2L["14"].Rotation = 0
G2L["14"].Selectable = false
G2L["14"].SelectionOrder = 0
G2L["14"].Size = UDim2.new(0, 15, 0, 15)
G2L["14"].Visible = true
G2L["14"].ZIndex = 1
G2L["14"].Parent = G2L["13"]

G2L["15"].Name = [[StatusFruit]]
G2L["15"].FontFace = Font.new([[rbxasset://fonts/families/DenkOne.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
G2L["15"].Text = [[Fruit Spawned]]
G2L["15"].TextColor3 = Color3.fromRGB(255, 255, 255)
G2L["15"].TextScaled = false
G2L["15"].TextSize = 15
G2L["15"].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
G2L["15"].TextStrokeTransparency = 1
G2L["15"].TextWrapped = false
G2L["15"].TextXAlignment = Enum.TextXAlignment.Left
G2L["15"].TextYAlignment = Enum.TextYAlignment.Center
G2L["15"].Active = false
G2L["15"].AnchorPoint = Vector2.new(0, 0)
G2L["15"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G2L["15"].BackgroundTransparency = 1
G2L["15"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["15"].BorderSizePixel = 0
G2L["15"].ClipsDescendants = false
G2L["15"].Draggable = false
G2L["15"].Position = UDim2.new(0.094262294, 0, 5.783158, 0)
G2L["15"].Rotation = 0
G2L["15"].Selectable = false
G2L["15"].SelectionOrder = 0
G2L["15"].Size = UDim2.new(0, 230, 0, 16)
G2L["15"].Visible = true
G2L["15"].ZIndex = 1
G2L["15"].Parent = G2L["2"]

G2L["16"].Name = [[ImageLabel]]
G2L["16"].Image = [[rbxassetid://377245168]]
G2L["16"].ImageColor3 = Color3.fromRGB(255, 255, 255)
G2L["16"].ScaleType = Enum.ScaleType.Stretch
G2L["16"].SliceCenter = Rect.new(0, 0, 0, 0)
G2L["16"].TileSize = UDim2.new(1, 0, 1, 0)
G2L["16"].Active = false
G2L["16"].AnchorPoint = Vector2.new(0, 0)
G2L["16"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G2L["16"].BackgroundTransparency = 1
G2L["16"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["16"].BorderSizePixel = 0
G2L["16"].ClipsDescendants = false
G2L["16"].Draggable = false
G2L["16"].Position = UDim2.new(-0.09565217, 0, 0, 0)
G2L["16"].Rotation = 0
G2L["16"].Selectable = false
G2L["16"].SelectionOrder = 0
G2L["16"].Size = UDim2.new(0, 15, 0, 15)
G2L["16"].Visible = true
G2L["16"].ZIndex = 1
G2L["16"].Parent = G2L["15"]

G2L["17"].Name = [[UICornerMainFrame]]
G2L["17"].CornerRadius = UDim.new(0, 8)
G2L["17"].Parent = G2L["1"]

local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

RunService.RenderStepped:Connect(function(frame)
	local fps = math.round(1 / frame)    
	local pingValue = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
	G2L["9"].Text = "FPS: " .. fps .. " | Ping: " .. math.round(pingValue) "("
end)

function setTime()
	local GameTime = math.floor(workspace.DistributedGameTime+0.5)
	local Hour = math.floor(GameTime/(60^2))%24
	local Minute = math.floor(GameTime/(60^1))%60
	local Second = math.floor(GameTime/(60^0))%60
	G2L["11"].Text = ("Time Played : "..Hour.." Minute: "..Minute.." Second : "..Second)
end

spawn(function()
	while task.wait() do
		pcall(function()
			setTime()
		end)
	end
end)


spawn(function()
	pcall(function()
		while wait(1) do  
			local foundFruit = false
			for i, v in pairs(game.Workspace:GetChildren()) do
				if string.find(v.Name, "Fruit") then
					G2L["15"].Text = ("Fruit Spawned : " .. v.Name)
					foundFruit = true
				end
			end
			if not foundFruit then
				G2L["15"].Text = ("Fruit Spawned : ".. "❌")
			end
		end
	end)
end)   

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