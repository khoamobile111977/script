getgenv().PullLeverSettings = {
    ['API Key'] = "khoadeptrai", -- API key for the mirage island jobID API
    ['Auto Pull Lever'] = true, -- Toggle for auto pull lever
    ['Server Hop'] = true, -- Toggle for server hop if no mirage island
    ['Hop Delay'] = 15, -- Delay between hops (in seconds)
    ['Teleport To Mirage'] = true, -- Toggle to teleport to Mirage Island when found
    ['Discord Webhook'] = false, -- Toggle for Discord webhook notifications
    ['Webhook URL'] = "", -- Your Discord webhook URL
}

-- Load the required services
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Wait for player to be loaded
repeat wait() until LocalPlayer:FindFirstChild("DataLoaded")
repeat wait() until game:IsLoaded()

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

-- Helper function to parse date/time for webhook
local function parseDateTime()
    local date = os.date("*t")
    local hour = (date.hour) % 24
    local ampm = hour < 12 and "AM" or "PM"
    
    hour = hour == 0 and 12 or (hour > 12 and hour - 12 or hour)
    
    return string.format("%d/%d/%d %d:%02d:%02d %s", date.month, date.day, date.year, hour, date.min, date.sec, ampm)
end

-- Function to send Discord webhook
local function SendWebhook(isMirage)
    if not getgenv().PullLeverSettings['Discord Webhook'] or getgenv().PullLeverSettings['Webhook URL'] == "" then return end
    
    local url = getgenv().PullLeverSettings['Webhook URL']
    
    -- Create webhook message
    local msg = {
        ["content"] = "",
        ["embeds"] = {
            {
                ["title"] = "🏝️ Mirage Island Found!",
                ["description"] = "Mirage Island has been found in your server!\n\n**Player:** " .. LocalPlayer.Name .. "\n**Job ID:** " .. game.JobId .. "\n**Server Size:** " .. #game:GetService("Players"):GetPlayers() .. "/" .. game:GetService("Players").MaxPlayers,
                ["type"] = "rich",
                ["color"] = tonumber(0x00FF00),
                ["fields"] = {
                    {
                        ["name"] = "Current Time",
                        ["value"] = IsNightTime() and "🌙 Night" or "☀️ Day",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Status",
                        ["value"] = "Server Hopping: " .. (getgenv().PullLeverSettings['Server Hop'] and "✅" or "❌"),
                        ["inline"] = true
                    }
                },
                ["image"] = {
                    ["url"] = "https://cdn.discordapp.com/attachments/973570282356891719/1097969638333222963/banana_cat.jpg"
                },
                ["footer"] = {
                    ["text"] = "Auto Pull Lever Script • " .. parseDateTime(),
                    ["icon_url"] = "https://cdn.discordapp.com/attachments/973570282356891719/1097969638333222963/banana_cat.jpg"
                },
            }
        }
    }
    
    -- Send webhook request
    local request
    if syn then
        request = syn.request 
    elseif http_request then
        request = http_request
    elseif request then
        request = request
    elseif http.request then
        request = http.request
    end
    
    if request then
        request({
            Url = url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(msg)
        })
    end
end

-- Function to check if mirage island exists
local function CheckMirageIsland()
    return Workspace.Map:FindFirstChild("MysticIsland") ~= nil
end

-- Function to check if it's night time
local function IsNightTime()
    local CurrentTime = ""
    
    if game.PlaceId == 7449423635 then -- Third Sea
        CurrentTime = Lighting:GetMinutesAfterMidnight() >= 1140 or Lighting:GetMinutesAfterMidnight() <= 360
    else
        CurrentTime = Lighting.ClockTime >= 19 or Lighting.ClockTime <= 6
    end
    
    return CurrentTime
end

-- Function to get mirage island server list from API
local function GetMirageServers()
    local apiUrl = "https://web-production-a0a2e.up.railway.app/mirageisland?key=" .. getgenv().PullLeverSettings['API Key']
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(apiUrl))
    end)
    
    if success and result and result.status == "true" and #result.List > 0 then
        return result.List
    else
        return nil
    end
end

-- Function to teleport to a specific position
local function Teleport(Position)
    LocalPlayer.Character.HumanoidRootPart.CFrame = Position
end

-- Function for server hopping to a specific JobId
local function JoinServer(JobId)
    if JobId and JobId ~= game.JobId then
        game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", JobId)
    end
end

-- Function to join a random server
local function HopServer()
    local v14 = require(game:GetService("ReplicatedStorage").Notification)
    v14.new("<Color=Red>Auto Pull Lever: Wait "..(tostring(getgenv().PullLeverSettings['Hop Delay']) or "15").."s [Hop Server]<Color=/>"):Display()
    
    wait(getgenv().PullLeverSettings['Hop Delay'] or 15)
    
    local v14 = require(game:GetService("ReplicatedStorage").Notification)
    v14.new("<Color=Red>Auto Pull Lever: Hopping Server<Color=/>"):Display()
    
    -- Try to join a server with Mirage Island from API
    local mirageServers = GetMirageServers()
    if mirageServers then
        for _, jobId in pairs(mirageServers) do
            if jobId ~= game.JobId then
                JoinServer(jobId)
                wait(1)
                break
            end
        end
    end
    
    -- If still here, try regular server hop
    for i=1,100 do
        local huhu = game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer(i)
        for k,v in pairs(huhu) do
            if v.Count >= 10 and k ~= game.JobId then
                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", k)
                wait(1)
                break
            end
        end
    end
end

-- Function to teleport to Advanced Fruit Dealer on Mirage Island
local function TeleportToMirageIsland()
    if not CheckMirageIsland() then return end
    
    local Notification = require(game:GetService("ReplicatedStorage").Notification)
    Notification.new("Auto Pull Lever: Teleporting to Mirage Island"):Display()
    
    -- First teleport to the island itself
    local mysticIsland = Workspace.Map:FindFirstChild("MysticIsland")
    if mysticIsland then
        local centerPosition = mysticIsland:GetModelCFrame().Position
        Teleport(CFrame.new(centerPosition + Vector3.new(0, 200, 0))) -- Teleport above the island
        wait(1)
    end
    
    -- Look for Advanced Fruit Dealer
    local allNPCs = {}
    
    -- Get NIL instances
    for _, v in pairs(getnilinstances()) do
        if v.Name == "Advanced Fruit Dealer" and v:FindFirstChild("HumanoidRootPart") then
            table.insert(allNPCs, v)
        end
    end
    
    -- Get workspace NPCs
    for _, v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
        if v.Name == "Advanced Fruit Dealer" and v:FindFirstChild("HumanoidRootPart") then
            table.insert(allNPCs, v)
        end
    end
    
    -- Teleport to the fruit dealer if found
    if #allNPCs > 0 then
        Teleport(allNPCs[1].HumanoidRootPart.CFrame)
        Notification.new("Auto Pull Lever: Found Advanced Fruit Dealer"):Display()
        return true
    end
    
    return false
end

-- Flag to track if we've sent webhook for this mirage island
local mirageWebhookSent = false

-- Function to pull the lever in Temple of Time
local function PullLever()
    if not game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("CheckTempleDoor") then 
        if CheckMirageIsland() then
            -- Send webhook notification if mirage island is found and we haven't sent it yet
            if not mirageWebhookSent and getgenv().PullLeverSettings['Discord Webhook'] then
                SendWebhook(true)
                mirageWebhookSent = true
            end
            
            -- If Mirage Island is found and teleport option is enabled
            if getgenv().PullLeverSettings['Teleport To Mirage'] then
                if TeleportToMirageIsland() then
                    wait(10) -- Wait at mirage island for a bit
                    return -- Skip the lever pulling if we're at mirage island
                end
            end
            
            if IsNightTime() then
                local v213 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")
                if v213 == 1 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Begin")
                elseif v213 == 2 then
                    -- Teleport to Temple of Time
                    local TemplePosition = CFrame.new(28609.392578125, 14896.533203125, 106.4216537475586)
                    Teleport(TemplePosition)
                    
                    local args = {
                        [1] = "RaceV4Progress",
                        [2] = "Teleport"
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                elseif v213 == 3 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Continue")
                end
            else
                local Notification = require(game:GetService("ReplicatedStorage").Notification)
                Notification.new("Auto Pull Lever: Waiting for night time"):Display()
                wait(5)
                return
            end
        elseif not CheckMirageIsland() and getgenv().PullLeverSettings['Server Hop'] then 
            -- Reset webhook flag if no mirage island
            mirageWebhookSent = false
            HopServer()
            return
        end
    
        -- If lever position is correct
        local Lever = Workspace.Map["Temple of Time"].Lever
        if Lever then
            -- Get the distance to the lever
            local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - Lever.Part.Position).Magnitude
            
            if Distance > 10 then
                -- Teleport to the lever
                Teleport(Lever.Part.CFrame)
            else
                -- Pull the lever
                fireproximityprompt(Workspace.Map["Temple of Time"].Lever.Prompt.ProximityPrompt, 1)
            end
        end
    else
        local Notification = require(game:GetService("ReplicatedStorage").Notification)
        Notification.new("Auto Pull Lever: Pull Lever Complete"):Display()
    end
end

-- Main loop
spawn(function()
    while wait() do 
        if getgenv().PullLeverSettings['Auto Pull Lever'] then 
            pcall(function()
                PullLever()
            end)
        end
    end
end)

-- Status display loop
spawn(function()
    while wait(5) do
        pcall(function()
            local status = ""
            if CheckMirageIsland() then
                status = "Mirage Island: Found ✅"
            else
                status = "Mirage Island: Not Found ❌"
            end
            
            if IsNightTime() then
                status = status .. " | Time: Night 🌙"
            else
                status = status .. " | Time: Day ☀️"
            end
            
            local Notification = require(game:GetService("ReplicatedStorage").Notification)
            Notification.new(status):Display()
        end)
    end
end)

-- Initial notification
local Notification = require(game:GetService("ReplicatedStorage").Notification)
Notification.new("Auto Pull Lever: Script Started"):Display()
print("Auto Pull Lever Script loaded!") 