-- Release.lua: Universal Game Hack Configuration for Mod Menu UI
-- For educational purposes only. Do not use in live Roblox games.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Clear existing elements
for id, element in pairs(elements or {}) do
    element:Destroy()
end
elements = {}
elementCount = 0

-- Game list
local games = {
    "Murder Mystery 2",
    "Free Fire Max Roblox",
    "Hide & Seek Extreme",
    "Find the Button",
    "Prop Hunt",
    "Epic Minigames",
    "Tower of Hell",
    "Brookhaven 🏡 RP",
    "Dress to Impress"
}

-- Add game selection label
AddLabel("game_select_label", "Select a Game:", {
    align = "Center",
    font = "GothamBold",
    size = 16,
    color = Color3.fromRGB(100, 255, 150)
})

-- Add game selection toggles
for i, game in ipairs(games) do
    AddToggle("game_select_" .. i, game, function(state)
        if state then
            -- Clear previous hacks
            for id, element in pairs(elements) do
                if not id:match("^game_select_") and id ~= "game_select_label" and id ~= "disclaimer" then
                    element:Destroy()
                    elements[id] = nil
                end
            end
            elementCount = #games + 2 -- Game buttons + label + disclaimer

            -- Game-specific hacks
            if game == "Murder Mystery 2" then
                local espLoop
                AddToggle("mm2_esp", "Player ESP", function(state)
                    if state then
                        espLoop = RunService.RenderStepped:Connect(function()
                            for _, player in ipairs(Players:GetPlayers()) do
                                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                                    local highlight = player.Character:FindFirstChild("ESPHighlight") or Instance.new("Highlight")
                                    highlight.Name = "ESPHighlight"
                                    highlight.FillTransparency = 0.5
                                    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                                    highlight.Parent = player.Character
                                end
                            end
                        end)
                        addConsoleLog("MM2 Player ESP: Enabled", "success")
                    else
                        if espLoop then
                            espLoop:Disconnect()
                            espLoop = nil
                            for _, player in ipairs(Players:GetPlayers()) do
                                if player.Character and player.Character:FindFirstChild("ESPHighlight") then
                                    player.Character.ESPHighlight:Destroy()
                                end
                            end
                            addConsoleLog("MM2 Player ESP: Disabled", "info")
                        end
                    end
                end)
                AddCheckbox("mm2_killall", "Kill All", function(state)
                    if state then
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                                player.Character.Humanoid.Health = 0
                            end
                        end
                        addConsoleLog("MM2 Kill All: Activated", "success")
                    end
                end)
                AddTextbox("mm2_coins", "Coin Multiplier", "1", function(value)
                    local multiplier = tonumber(value)
                    if multiplier then
                        addConsoleLog("MM2 Coin Multiplier set to: " .. value, "info")
                    else
                        addConsoleLog("Invalid Coin Multiplier: " .. value, "error")
                    end
                end)
            elseif game == "Free Fire Max Roblox" then
                local aimLoop
                AddToggle("ff_aim", "Aim Assist", function(state)
                    if state then
                        aimLoop = RunService.RenderStepped:Connect(function()
                            local closestPlayer = nil
                            local closestDistance = math.huge
                            local camera = Workspace.CurrentCamera
                            for _, player in ipairs(Players:GetPlayers()) do
                                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                                    local headPos = player.Character.Head.Position
                                    local screenPos, onScreen = camera:WorldToViewportPoint(headPos)
                                    if onScreen then
                                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude
                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestPlayer = player
                                        end
                                    end
                                end
                            end
                            if closestPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                local rootPart = LocalPlayer.Character.HumanoidRootPart
                                rootPart.CFrame = CFrame.new(rootPart.Position, closestPlayer.Character.Head.Position)
                            end
                        end)
                        addConsoleLog("FF Aim Assist: Enabled", "success")
                    else
                        if aimLoop then
                            aimLoop:Disconnect()
                            aimLoop = nil
                            addConsoleLog("FF Aim Assist: Disabled", "info")
                        end
                    end
                end)
                AddToggle("ff_speed", "Speed Hack", function(state)
                    if state then
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            char.Humanoid.WalkSpeed = 32
                            addConsoleLog("FF Speed Hack: Enabled", "success")
                        end
                    else
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            char.Humanoid.WalkSpeed = 16
                            addConsoleLog("FF Speed Hack: Disabled", "info")
                        end
                    end
                end)
            elseif game == "Hide & Seek Extreme" then
                local revealLoop
                AddToggle("hs_reveal", "Reveal Hiders", function(state)
                    if state then
                        revealLoop = RunService.RenderStepped:Connect(function()
                            for _, player in ipairs(Players:GetPlayers()) do
                                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                                    local highlight = player.Character:FindFirstChild("Highlight") or Instance.new("Highlight")
                                    highlight.Name = "Highlight"
                                    highlight.FillTransparency = 0.7
                                    highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                                    highlight.Parent = player.Character
                                end
                            end
                        end)
                        addConsoleLog("HS Reveal Hiders: Enabled", "success")
                    else
                        if revealLoop then
                            revealLoop:Disconnect()
                            revealLoop = nil
                            for _, player in ipairs(Players:GetPlayers()) do
                                if player.Character and player.Character:FindFirstChild("Highlight") then
                                    player.Character.Highlight:Destroy()
                                end
                            end
                            addConsoleLog("HS Reveal Hiders: Disabled", "info")
                        end
                    end
                end)
                AddCheckbox("hs_noclip", "No-Clip", function(state)
                    if state then
                        local noclipLoop = RunService.Stepped:Connect(function()
                            local char = LocalPlayer.Character
                            if char then
                                for _, part in ipairs(char:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        part.CanCollide = false
                                    end
                                end
                            end
                        end)
                        addConsoleLog("HS No-Clip: Activated", "success")
                    else
                        local char = LocalPlayer.Character
                        if char then
                            for _, part in ipairs(char:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = true
                                end
                            end
                        end
                        addConsoleLog("HS No-Clip: Deactivated", "info")
                    end
                end)
            elseif game == "Find the Button" then
                local buttonEspLoop
                AddToggle("ftb_esp", "Button ESP", function(state)
                    if state then
                        buttonEspLoop = RunService.RenderStepped:Connect(function()
                            for _, obj in ipairs(Workspace:GetDescendants()) do
                                if obj.Name:lower():match("button") and obj:IsA("BasePart") then
                                    local highlight = obj:FindFirstChild("ButtonHighlight") or Instance.new("Highlight")
                                    highlight.Name = "ButtonHighlight"
                                    highlight.FillTransparency = 0.5
                                    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                                    highlight.Parent = obj
                                end
                            end
                        end)
                        addConsoleLog("FTB Button ESP: Enabled", "success")
                    else
                        if buttonEspLoop then
                            buttonEspLoop:Disconnect()
                            buttonEspLoop = nil
                            for _, obj in ipairs(Workspace:GetDescendants()) do
                                if obj:FindFirstChild("ButtonHighlight") then
                                    obj.ButtonHighlight:Destroy()
                                end
                            end
                            addConsoleLog("FTB Button ESP: Disabled", "info")
                        end
                    end
                end)
                AddCheckbox("ftb_teleport", "Teleport to Button", function(state)
                    if state then
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            if obj.Name:lower():match("button") and obj:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                                break
                            end
                        end
                        addConsoleLog("FTB Teleport to Button: Activated", "success")
                    end
                end)
            elseif game == "Prop Hunt" then
                local propEspLoop
                AddToggle("ph_prop_esp", "Prop ESP", function(state)
                    if state then
                        propEspLoop = RunService.RenderStepped:Connect(function()
                            for _, obj in ipairs(Workspace:GetDescendants()) do
                                if obj.Name:lower():match("prop") and obj:IsA("BasePart") then
                                    local highlight = obj:FindFirstChild("PropHighlight") or Instance.new("Highlight")
                                    highlight.Name = "PropHighlight"
                                    highlight.FillTransparency = 0.5
                                    highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
                                    highlight.Parent = obj
                                end
                            end
                        end)
                        addConsoleLog("PH Prop ESP: Enabled", "success")
                    else
                        if propEspLoop then
                            propEspLoop:Disconnect()
                            propEspLoop = nil
                            for _, obj in ipairs(Workspace:GetDescendants()) do
                                if obj:FindFirstChild("PropHighlight") then
                                    obj.PropHighlight:Destroy()
                                end
                            end
                            addConsoleLog("PH Prop ESP: Disabled", "info")
                        end
                    end
                end)
                AddCheckbox("ph_invis", "Invisibility", function(state)
                    if state then
                        local char = LocalPlayer.Character
                        if char then
                            for _, part in ipairs(char:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.Transparency = 0.9
                                end
                            end
                        end
                        addConsoleLog("PH Invisibility: Activated", "success")
                    else
                        local char = LocalPlayer.Character
                        if char then
                            for _, part in ipairs(char:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.Transparency = 0
                                end
                            end
                        end
                        addConsoleLog("PH Invisibility: Deactivated", "info")
                    end
                end)
            elseif game == "Epic Minigames" then
                AddToggle("em_autowin", "Auto-Win Minigame", function(state)
                    if state then
                        addConsoleLog("EM Auto-Win: Enabled (Placeholder)", "success")
                    else
                        addConsoleLog("EM Auto-Win: Disabled", "info")
                    end
                end)
                AddTextbox("em_score", "Score Multiplier", "1", function(value)
                    local multiplier = tonumber(value)
                    if multiplier then
                        addConsoleLog("EM Score Multiplier set to: " .. value, "info")
                    else
                        addConsoleLog("Invalid Score Multiplier: " .. value, "error")
                    end
                end)
            elseif game == "Tower of Hell" then
                local noFallLoop
                AddToggle("toh_nofall", "No Fall Damage", function(state)
                    if state then
                        noFallLoop = RunService.Stepped:Connect(function()
                            local char = LocalPlayer.Character
                            if char and char:FindFirstChild("Humanoid") then
                                local humanoid = char.Humanoid
                                if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                                    local vel = char.HumanoidRootPart.AssemblyLinearVelocity
                                    char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
                                end
                            end
                        end)
                        addConsoleLog("ToH No Fall: Enabled", "success")
                    else
                        if noFallLoop then
                            noFallLoop:Disconnect()
                            noFallLoop = nil
                            addConsoleLog("ToH No Fall: Disabled", "info")
                        end
                    end
                end)
                AddCheckbox("toh_autoclimb", "Auto-Climb", function(state)
                    if state then
                        local climbLoop = RunService.Stepped:Connect(function()
                            local char = LocalPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                local rootPart = char.HumanoidRootPart
                                rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 0.5, 0)
                            end
                        end)
                        addConsoleLog("ToH Auto-Climb: Activated", "success")
                    else
                        addConsoleLog("ToH Auto-Climb: Deactivated", "info")
                    end
                end)
            elseif game == "Brookhaven 🏡 RP" then
                AddTextbox("bh_money", "Money Amount", "1000", function(value)
                    local amount = tonumber(value)
                    if amount then
                        addConsoleLog("BH Money set to: " .. value, "info")
                    else
                        addConsoleLog("Invalid Money Amount: " .. value, "error")
                    end
                end)
                AddToggle("bh_speed", "Speed Hack", function(state)
                    if state then
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            char.Humanoid.WalkSpeed = 32
                            addConsoleLog("BH Speed Hack: Enabled", "success")
                        end
                    else
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            char.Humanoid.WalkSpeed = 16
                            addConsoleLog("BH Speed Hack: Disabled", "info")
                        end
                    end
                end)
            elseif game == "Dress to Impress" then
                AddCheckbox("dti_autostyle", "Auto-Style Outfit", function(state)
                    if state then
                        addConsoleLog("DTI Auto-Style: Activated (Placeholder)", "success")
                    else
                        addConsoleLog("DTI Auto-Style: Deactivated", "info")
                    end
                end)
                AddTextbox("dti_currency", "Currency Boost", "100", function(value)
                    local amount = tonumber(value)
                    if amount then
                        addConsoleLog("DTI Currency Boost set to: " .. value, "info")
                    else
                        addConsoleLog("Invalid Currency Boost: " .. value, "error")
                    end
                end)
            end
            -- Disable other game toggles
            for j, otherGame in ipairs(games) do
                if i ~= j and elements["game_select_" .. j] then
                    local toggle = elements["game_select_" .. j]:FindFirstChildOfClass("TextButton")
                    if toggle then
                        local frame = toggle:FindFirstChildOfClass("Frame")
                        frame:FindFirstChildOfClass("Frame").Position = UDim2.new(0, 2, 0.5, -8)
                        frame.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                    end
                end
            end
        end
    end)
end

-- Add disclaimer
AddText("disclaimer", "Disclaimer", "For educational purposes only. Do not use in live Roblox games.", {
    color = Color3.fromRGB(255, 100, 100),
    font = "GothamBold",
    align = "Center",
    size = 12
})

addConsoleLog("Game hacks loaded successfully", "success")
