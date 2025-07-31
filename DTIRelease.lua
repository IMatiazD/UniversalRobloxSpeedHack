-- ===== STEAL A BRAINROT ULTIMATE SCRIPT =====
-- Avanzado con bypass de anticheat y funciones OP
print("🧠 Loading Steal a Brainrot Ultimate Script...")

-- ===== SERVICIOS Y CONFIGURACIÓN =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ===== VARIABLES GLOBALES =====
local scriptEnabled = true
local autoStealEnabled = false
local anticheatBypass = true
local targetBrainrot = nil
local homeBase = nil
local currentSpeed = 150
local currentJumpPower = 120
local godModeEnabled = false
local espEnabled = false
local autoFarmEnabled = false
local flyEnabled = false
local originalWalkSpeed = Humanoid.WalkSpeed
local originalJumpPower = Humanoid.JumpPower

-- Arrays para ESP y detección
local brainrotItems = {}
local enemyPlayers = {}
local espConnections = {}

-- ===== GUI SETUP =====
local function CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "StealBrainrotGUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    
    return ScreenGui
end

local gui = CreateGUI()

-- ===== ANTICHEAT BYPASS FUNCTIONS =====
local function BypassAnticheat()
    if not anticheatBypass then return end
    
    -- Spoof network calls
    local mt = getrawmetatable(game)
    local oldNameCall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Block anticheat detection
        if method == "FireServer" or method == "InvokeServer" then
            local eventName = tostring(self)
            if eventName:find("AntiCheat") or eventName:find("Detect") or eventName:find("Ban") then
                return
            end
        end
        
        return oldNameCall(self, ...)
    end)
    
    -- Hide script traces
    local function hideScript()
        for _, connection in pairs(getconnections(LocalPlayer.CharacterAdded)) do
            if connection.Function and debug.getinfo(connection.Function).source:match("AntiCheat") then
                connection:Disconnect()
            end
        end
    end
    
    spawn(hideScript)
    print("🛡️ Anticheat bypass activated")
end

-- ===== DETECTION FUNCTIONS =====
local function FindBrainrots()
    brainrotItems = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("brainrot") or obj.Name:lower():find("brain") then
            if obj:IsA("Part") or obj:IsA("Model") then
                -- Check if it has value
                local valueObj = obj:FindFirstChild("Value") or obj:FindFirstChild("Cash") or obj:FindFirstChild("Money")
                local value = 0
                if valueObj then
                    value = valueObj.Value or 0
                end
                
                table.insert(brainrotItems, {
                    object = obj,
                    position = obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position or obj.Position,
                    value = value,
                    distance = (RootPart.Position - (obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position or obj.Position)).Magnitude
                })
            end
        end
    end
    
    -- Sort by value (highest first)
    table.sort(brainrotItems, function(a, b)
        return a.value > b.value
    end)
    
    return brainrotItems
end

local function FindMyBase()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("base") or obj.Name:lower():find("spawn") then
            if obj:FindFirstChild("Owner") and obj.Owner.Value == LocalPlayer then
                homeBase = obj
                print("🏠 Base encontrada:", obj.Position)
                return obj
            end
        end
    end
    
    -- If no base found, use spawn
    homeBase = Workspace:FindFirstChild("SpawnLocation") or RootPart
    return homeBase
end

-- ===== MOVEMENT FUNCTIONS =====
local function SafeTeleport(targetPos, speed)
    if not targetPos then return end
    
    speed = speed or 1
    local distance = (RootPart.Position - targetPos).Magnitude
    local duration = distance / (currentSpeed * speed)
    
    -- Create smooth teleport to avoid detection
    local tween = TweenService:Create(
        RootPart,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(targetPos)}
    )
    
    tween:Play()
    return tween
end

local function InstantTeleport(targetPos)
    if not targetPos then return end
    RootPart.CFrame = CFrame.new(targetPos)
end

-- ===== STEALING FUNCTIONS =====
local function StealBrainrot(brainrotData)
    if not brainrotData or not brainrotData.object then return false end
    
    local brainrot = brainrotData.object
    local originalPos = RootPart.CFrame
    
    -- Teleport to brainrot
    SafeTeleport(brainrotData.position + Vector3.new(0, 5, 0), 2)
    wait(0.5)
    
    -- Try multiple steal methods
    local stolen = false
    
    -- Method 1: Click/Touch
    pcall(function()
        if brainrot:FindFirstChild("ClickDetector") then
            fireclickdetector(brainrot.ClickDetector)
            stolen = true
        end
    end)
    
    -- Method 2: Proximity
    pcall(function()
        if brainrot:FindFirstChild("ProximityPrompt") then
            fireproximityprompt(brainrot.ProximityPrompt)
            stolen = true
        end
    end)
    
    -- Method 3: Remote events
    pcall(function()
        local stealEvent = ReplicatedStorage:FindFirstChild("StealBrainrot") or ReplicatedStorage:FindFirstChild("Steal")
        if stealEvent then
            stealEvent:FireServer(brainrot)
            stolen = true
        end
    end)
    
    -- Method 4: Direct manipulation
    pcall(function()
        brainrot.Parent = LocalPlayer.Character
        stolen = true
    end)
    
    wait(0.3)
    
    -- Return to base if stolen
    if stolen and homeBase then
        local basePos = homeBase:IsA("Model") and homeBase.PrimaryPart and homeBase.PrimaryPart.Position or homeBase.Position
        SafeTeleport(basePos + Vector3.new(0, 10, 0), 3)
        print("💰 Brainrot robado y llevado a la base! Valor: " .. tostring(brainrotData.value))
    end
    
    return stolen
end

-- ===== AUTO FARM SYSTEM =====
local function AutoFarmLoop()
    while autoFarmEnabled and scriptEnabled do
        -- Find and update brainrots
        local brainrots = FindBrainrots()
        
        if #brainrots > 0 then
            -- Target highest value brainrot
            local target = brainrots[1]
            targetBrainrot = target
            
            print("🎯 Targeting brainrot worth: " .. tostring(target.value))
            
            -- Steal it
            local success = StealBrainrot(target)
            
            if success then
                wait(2) -- Wait before next steal
            else
                wait(1) -- Quick retry
            end
        else
            print("🔍 No brainrots found, searching...")
            wait(3)
        end
        
        wait(0.5)
    end
end

-- ===== ESP SYSTEM =====
local function CreateESP(obj, color, text)
    local billboard = Instance.new("BillboardGui")
    local frame = Instance.new("Frame")
    local textLabel = Instance.new("TextLabel")
    
    billboard.Name = "ESP"
    billboard.Parent = obj
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    
    frame.Parent = billboard
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.5
    frame.BackgroundColor3 = color
    frame.BorderSizePixel = 0
    
    textLabel.Parent = frame
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    
    return billboard
end

local function UpdateESP()
    if not espEnabled then return end
    
    -- Clear old ESP
    for _, connection in pairs(espConnections) do
        if connection and connection.Parent then
            connection:Destroy()
        end
    end
    espConnections = {}
    
    -- ESP for Brainrots
    local brainrots = FindBrainrots()
    for _, brainrotData in pairs(brainrots) do
        local esp = CreateESP(
            brainrotData.object:IsA("Model") and brainrotData.object.PrimaryPart or brainrotData.object,
            Color3.fromRGB(255, 215, 0),
            "💰 Brainrot ($" .. tostring(brainrotData.value) .. ")"
        )
        table.insert(espConnections, esp)
    end
    
    -- ESP for Players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local esp = CreateESP(
                player.Character.HumanoidRootPart,
                Color3.fromRGB(255, 0, 0),
                "👤 " .. player.Name
            )
            table.insert(espConnections, esp)
        end
    end
end

-- ===== SPEED AND MOVEMENT HACKS =====
local function ApplySpeedHack()
    if Humanoid then
        Humanoid.WalkSpeed = currentSpeed
        Humanoid.JumpPower = currentJumpPower
    end
end

local function EnableFly()
    if flyEnabled then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = RootPart
        
        local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
        bodyAngularVelocity.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
        bodyAngularVelocity.Parent = RootPart
        
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not flyEnabled then
                bodyVelocity:Destroy()
                bodyAngularVelocity:Destroy()
                connection:Disconnect()
                return
            end
            
            local camera = Workspace.CurrentCamera
            local moveVector = Humanoid.MoveDirection * currentSpeed
            bodyVelocity.Velocity = camera.CFrame:VectorToWorldSpace(Vector3.new(moveVector.X, 0, moveVector.Z))
            
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, currentSpeed, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, -currentSpeed, 0)
            end
        end)
    end
end

-- ===== GOD MODE =====
local function EnableGodMode()
    if godModeEnabled then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        
        -- Block damage
        local connection
        connection = Humanoid.HealthChanged:Connect(function()
            if godModeEnabled and Humanoid.Health < Humanoid.MaxHealth then
                Humanoid.Health = Humanoid.MaxHealth
            elseif not godModeEnabled then
                connection:Disconnect()
            end
        end)
    end
end

-- ===== GUI FUNCTIONS =====
AddLabel("title", "🧠 STEAL A BRAINROT ULTIMATE")
AddText("desc",
    "Script avanzado con bypass de anticheat",
    "Auto steal, ESP, speed hack, fly y mucho más",
    { color=Color3.fromRGB(255,100,255), style="Bold", size=16, align="Center", font="GothamBold" }
)

-- ===== MAIN FUNCTIONS =====
AddLabel("main_section", "🎯 FUNCIONES PRINCIPALES")

AddToggle("autoSteal", "💰 Auto Steal (Highest Value)", function(state)
    autoStealEnabled = state
    if state then
        FindMyBase()
        spawn(AutoFarmLoop)
        print("🤖 Auto steal activado - targeting highest value brainrots")
    else
        print("⏹️ Auto steal desactivado")
    end
end)

AddToggle("autoFarm", "🔄 Auto Farm Everything", function(state)
    autoFarmEnabled = state
    if state then
        spawn(function()
            while autoFarmEnabled do
                -- Auto collect cash
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name:lower():find("cash") or obj.Name:lower():find("money") then
                        if obj:FindFirstChild("ClickDetector") then
                            fireclickdetector(obj.ClickDetector)
                        end
                    end
                end
                wait(1)
            end
        end)
        print("💸 Auto farm cash activado")
    end
end)

AddToggle("esp", "👁️ ESP (Brainrots + Players)", function(state)
    espEnabled = state
    if state then
        spawn(function()
            while espEnabled do
                UpdateESP()
                wait(2)
            end
        end)
        print("👁️ ESP activado")
    else
        -- Clear ESP
        for _, connection in pairs(espConnections) do
            if connection and connection.Parent then
                connection:Destroy()
            end
        end
        espConnections = {}
        print("👁️ ESP desactivado")
    end
end)

-- ===== MOVEMENT SECTION =====
AddLabel("movement_section", "🚀 MOVIMIENTO Y SPEED")

AddSlider("speedHack", "⚡ Speed Multiplier", 150, 16, 500, function(value)
    currentSpeed = value
    ApplySpeedHack()
end)

AddSlider("jumpHack", "🦘 Jump Power", 120, 50, 300, function(value)
    currentJumpPower = value
    ApplySpeedHack()
end)

AddToggle("fly", "✈️ Fly Mode", function(state)
    flyEnabled = state
    if state then
        EnableFly()
        print("✈️ Fly mode activado - WASD to move, Space/Shift up/down")
    else
        print("✈️ Fly mode desactivado")
    end
end)

AddToggle("noclip", "👻 No Clip", function(state)
    if state then
        spawn(function()
            while state do
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                wait(0.1)
            end
        end)
    else
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end)

-- ===== TELEPORT SECTION =====
AddLabel("teleport_section", "📍 TELEPORTACIÓN")

AddToggle("tpToHighestValue", "💎 TP to Highest Value Brainrot", function(state)
    if state then
        local brainrots = FindBrainrots()
        if #brainrots > 0 then
            InstantTeleport(brainrots[1].position + Vector3.new(0, 5, 0))
            print("💎 Teleported to highest value brainrot: $" .. tostring(brainrots[1].value))
        else
            print("❌ No brainrots found")
        end
    end
end)

AddToggle("tpToBase", "🏠 TP to My Base", function(state)
    if state then
        local base = FindMyBase()
        if base then
            local basePos = base:IsA("Model") and base.PrimaryPart and base.PrimaryPart.Position or base.Position
            InstantTeleport(basePos + Vector3.new(0, 10, 0))
            print("🏠 Teleported to base")
        end
    end
end)

local targetPlayerName = ""
AddTextbox("targetPlayerTP", "👤 Player Name", "Enter exact name", function(value)
    targetPlayerName = value
end)

AddToggle("tpToPlayer", "👤 TP to Player", function(state)
    if state and targetPlayerName ~= "" then
        local targetPlayer = Players:FindFirstChild(targetPlayerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            InstantTeleport(targetPlayer.Character.HumanoidRootPart.Position + Vector3.new(5, 0, 0))
            print("👤 Teleported to " .. targetPlayerName)
        else
            print("❌ Player not found: " .. targetPlayerName)
        end
    end
end)

-- ===== COMBAT SECTION =====
AddLabel("combat_section", "⚔️ COMBATE Y DEFENSA")

AddToggle("godMode", "🛡️ God Mode", function(state)
    godModeEnabled = state
    if state then
        EnableGodMode()
        print("🛡️ God mode activado")
    else
        print("🛡️ God mode desactivado")
    end
end)

AddToggle("autoLockBase", "🔒 Auto Lock Base", function(state)
    if state then
        spawn(function()
            while state do
                -- Try to lock base
                pcall(function()
                    local lockEvent = ReplicatedStorage:FindFirstChild("LockBase") or ReplicatedStorage:FindFirstChild("Lock")
                    if lockEvent then
                        lockEvent:FireServer()
                    end
                end)
                wait(5)
            end
        end)
        print("🔒 Auto lock base activado")
    end
end)

AddToggle("autoDefend", "⚔️ Auto Defend", function(state)
    if state then
        spawn(function()
            while state do
                -- Auto attack nearby enemies
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (RootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance < 20 then -- If enemy too close
                            -- Try to attack
                            pcall(function()
                                local attackEvent = ReplicatedStorage:FindFirstChild("Attack") or ReplicatedStorage:FindFirstChild("Hit")
                                if attackEvent then
                                    attackEvent:FireServer(player.Character)
                                end
                            end)
                        end
                    end
                end
                wait(0.5)
            end
        end)
        print("⚔️ Auto defend activado")
    end
end)

-- ===== UTILITY SECTION =====
AddLabel("utility_section", "🔧 UTILIDADES")

AddToggle("antiAFK", "💤 Anti AFK", function(state)
    if state then
        spawn(function()
            while state do
                -- Small movement to prevent AFK
                local currentPos = RootPart.CFrame
                RootPart.CFrame = currentPos * CFrame.new(0.1, 0, 0)
                wait(0.1)
                RootPart.CFrame = currentPos
                wait(600) -- Every 10 minutes
            end
        end)
    end
end)

AddToggle("fullBright", "💡 Full Bright", function(state)
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
    end
end)

AddToggle("infiniteYield", "🔄 Infinite Yield Commands", function(state)
    if state then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
end)

-- ===== BYPASS SECTION =====
AddLabel("bypass_section", "🛡️ ANTICHEAT BYPASS")

AddToggle("enableBypass", "🛡️ Enable Anticheat Bypass", function(state)
    anticheatBypass = state
    if state then
        BypassAnticheat()
    end
end)

AddToggle("spoofStats", "📊 Spoof Player Stats", function(state)
    if state then
        spawn(function()
            while state do
                pcall(function()
                    -- Spoof various stats to appear legitimate
                    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
                    if leaderstats then
                        local cash = leaderstats:FindFirstChild("Cash") or leaderstats:FindFirstChild("Money")
                        if cash and cash.Value > 1000000 then
                            cash.Value = math.random(10000, 50000) -- Keep reasonable values
                        end
                    end
                end)
                wait(30)
            end
        end)
    end
end)

-- ===== STATUS SECTION =====
AddLabel("status_section", "📊 ESTADO")
AddText("currentStatus", "✅ Script cargado correctamente", "Todas las funciones disponibles", 
    { color=Color3.fromRGB(0,255,0), style="Bold", size=14 }
)

-- ===== INITIALIZATION =====
spawn(function()
    wait(2)
    print("🧠 Steal a Brainrot Ultimate Script v2.0 loaded!")
    print("🛡️ Anticheat bypass ready")
    print("💰 Auto steal system ready")
    print("⚡ Speed hacks ready")
    print("👁️ ESP system ready")
    
    -- Auto-enable some features
    anticheatBypass = true
    BypassAnticheat()
    
    -- Keep speed hack active
    spawn(function()
        while scriptEnabled do
            ApplySpeedHack()
            wait(1)
        end
    end)
    
    -- Auto-find base
    FindMyBase()
end)

-- ===== CLEANUP ON CHARACTER RESPAWN =====
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    
    wait(1)
    ApplySpeedHack()
    if godModeEnabled then EnableGodMode() end
    if flyEnabled then EnableFly() end
    
    print("🔄 Character respawned, reapplying hacks...")
end)

print("🎉 Steal a Brainrot Ultimate Script fully loaded! Use with caution 🧠")
