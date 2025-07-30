local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local speedHackLoop = nil
local advancedSpeedHackLoop = nil
local antiFlipLoop = nil
local currentSpeed = 16
local maxSpeed = 32
local accelerationRate = 2
local decelerationRate = 4
local airSpeedMultiplier = 1.5
local directionalBoost = 1.2

-- Label para la sección de SpeedHack
AddLabel("speedhack_section", "Sección SpeedHack", {
    align = "Center",
    font = "GothamBold",
    size = 16,
    color = Color3.fromRGB(100, 255, 150)
})

-- Switch para activar/desactivar SpeedHack
AddToggle("enable_speedhack", "Activar SpeedHack", function(state)
    if state then
        if not speedHackLoop then
            speedHackLoop = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = currentSpeed
                end
            end)
            addConsoleLog("SpeedHack: Activado", "success")
        end
    else
        if speedHackLoop then
            speedHackLoop:Disconnect()
            speedHackLoop = nil
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 16
            end
            addConsoleLog("SpeedHack: Desactivado", "info")
        end
    end
end)

-- Textbox para cambiar la velocidad
AddTextbox("speed_velocity", "Cambiar Velocidad", "16", function(value)
    local speed = tonumber(value)
    if speed then
        currentSpeed = speed
        addConsoleLog("Velocidad cambiada a: " .. value, "info")
    else
        addConsoleLog("Valor de velocidad inválido: " .. value, "error")
    end
end)

-- Switch para No Fall (adaptado del código proporcionado)
AddToggle("no_fall", "Sin Caída", function(state)
    if state then
        if not antiFlipLoop then
            antiFlipLoop = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if not char then return end
                local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                if humanoid and rootPart then
                    humanoid.PlatformStand = false
                    humanoid.Sit = false
                    rootPart.CanCollide = true
                    local cf = rootPart.CFrame
                    local up = cf.UpVector
                    local tilt = math.deg(math.acos(math.clamp(up:Dot(Vector3.new(0, 1, 0)), -1, 1)))
                    local dir = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z).Unit
                    local targetCF = CFrame.lookAt(cf.Position, cf.Position + dir)
                    local lerpAlpha = tilt > 15 and 0.8 or (tilt > 5 and 0.5 or 0.3)
                    rootPart.CFrame = cf:Lerp(targetCF, lerpAlpha)
                    local av = rootPart.AssemblyAngularVelocity
                    rootPart.AssemblyAngularVelocity = Vector3.new(0, av.Y * 0.2, 0)
                    if humanoid:GetState() == Enum.HumanoidStateType.Physics or humanoid:GetState() == Enum.HumanoidStateType.PlatformStanding then
                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end
                    local raycast = workspace:Raycast(rootPart.Position, Vector3.new(0, -10, 0))
                    if raycast and raycast.Distance > 5 then
                        local vel = rootPart.AssemblyLinearVelocity
                        rootPart.AssemblyLinearVelocity = Vector3.new(vel.X, math.min(vel.Y, -10), vel.Z)
                    end
                end
            end)
            addConsoleLog("Sin Caída: Activado", "success")
        end
    else
        if antiFlipLoop then
            antiFlipLoop:Disconnect()
            antiFlipLoop = nil
            addConsoleLog("Sin Caída: Desactivado", "info")
        end
    end
end)

-- Label para la sección avanzada
AddLabel("advanced_section", "Sección Avanzada", {
    align = "Center",
    font = "GothamBold",
    size = 16,
    color = Color3.fromRGB(100, 255, 150)
})

-- Switch para activar/desactivar SpeedHack Avanzado
AddToggle("enable_advanced_speedhack", "Activar SpeedHack Avanzado", function(state)
    if state then
        if not advancedSpeedHackLoop then
            advancedSpeedHackLoop = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("Humanoid") or not char:FindFirstChild("HumanoidRootPart") then return end
                local humanoid = char.Humanoid
                local rootPart = char.HumanoidRootPart
                local isMoving = humanoid.MoveDirection.Magnitude > 0
                local isInAir = humanoid:GetState() == Enum.HumanoidStateType.Jumping or humanoid:GetState() == Enum.HumanoidStateType.Freefall
                local camera = workspace.CurrentCamera
                local lookDirection = camera.CFrame.LookVector
                local moveDirection = humanoid.MoveDirection.Unit
                local directionalFactor = isMoving and math.max(0, moveDirection:Dot(Vector3.new(lookDirection.X, 0, lookDirection.Z).Unit)) or 0
                local targetSpeed = maxSpeed
                if isInAir then
                    targetSpeed = targetSpeed * airSpeedMultiplier
                end
                if directionalFactor > 0.5 then
                    targetSpeed = targetSpeed * directionalBoost
                end
                local currentWalkSpeed = humanoid.WalkSpeed
                local speedChange = isMoving and accelerationRate or -decelerationRate
                local newSpeed = math.clamp(currentWalkSpeed + speedChange, 16, targetSpeed)
                humanoid.WalkSpeed = newSpeed
            end)
            addConsoleLog("SpeedHack Avanzado: Activado", "success")
        end
    else
        if advancedSpeedHackLoop then
            advancedSpeedHackLoop:Disconnect()
            advancedSpeedHackLoop = nil
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 16
            end
            addConsoleLog("SpeedHack Avanzado: Desactivado", "info")
        end
    end
end)

-- Textbox para velocidad máxima
AddTextbox("max_speed", "Velocidad Máxima", "32", function(value)
    local speed = tonumber(value)
    if speed then
        maxSpeed = speed
        addConsoleLog("Velocidad Máxima cambiada a: " .. value, "info")
    else
        addConsoleLog("Valor de Velocidad Máxima inválido: " .. value, "error")
    end
end)

-- Textbox para tasa de aceleración
AddTextbox("acceleration_rate", "Tasa de Aceleración", "2", function(value)
    local rate = tonumber(value)
    if rate then
        accelerationRate = rate
        addConsoleLog("Tasa de Aceleración cambiada a: " .. value, "info")
    else
        addConsoleLog("Valor de Tasa de Aceleración inválido: " .. value, "error")
    end
end)

-- Textbox para tasa de desaceleración
AddTextbox("deceleration_rate", "Tasa de Desaceleración", "4", function(value)
    local rate = tonumber(value)
    if rate then
        decelerationRate = rate
        addConsoleLog("Tasa de Desaceleración cambiada a: " .. value, "info")
    else
        addConsoleLog("Valor de Tasa de Desaceleración inválido: " .. value, "error")
    end
end)

-- Textbox para multiplicador de velocidad aérea
AddTextbox("air_speed_multiplier", "Multiplicador Velocidad Aérea", "1.5", function(value)
    local multiplier = tonumber(value)
    if multiplier then
        airSpeedMultiplier = multiplier
        addConsoleLog("Multiplicador Velocidad Aérea cambiado a: " .. value, "info")
    else
        addConsoleLog("Valor de Multiplicador Velocidad Aérea inválido: " .. value, "error")
    end
end)

-- Textbox para aumento direccional
AddTextbox("directional_boost", "Aumento Direccional", "1.2", function(value)
    local boost = tonumber(value)
    if boost then
        directionalBoost = boost
        addConsoleLog("Aumento Direccional cambiado a: " .. value, "info")
    else
        addConsoleLog("Valor de Aumento Direccional inválido: " .. value, "error")
    end
end)
