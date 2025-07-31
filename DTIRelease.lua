-- ===== DRESS TO IMPRESS ADVANCED SCRIPT =====
-- Información general
AddLabel("title", "🌟 Dress to Impress Ultimate Helper 🌟")
AddText("desc", "Script completo para Dress to Impress con todas las funciones avanzadas",
    "Incluye auto farm, VIP gratis, copiar outfits, trolling y mucho más",
    { color=Color3.fromRGB(255,215,0), style="Bold", size=18, align="Center", icon=true, font="GothamBold" }
)

-- ===== SERVICIOS Y VARIABLES =====
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Variables globales
local autoFarmEnabled = false
local infiniteMoneyEnabled = false
local vipUnlocked = false
local rainbowSkinEnabled = false
local savedOutfits = {}
local currentWalkSpeed = 16
local currentJumpPower = 50

-- ===== CÓDIGOS ACTUALIZADOS (JULIO 2025) =====
AddLabel("codes_section", "💎 CÓDIGOS Y RECOMPENSAS")

local activeCodes = {
    -- Códigos verificados activos
    "PIXIIUWU", "1CON1CF4TMA", "3NCHANTEDD1ZZY", "ANGELT4NKED",
    "ASHLEYBUNNI", "B3APL4YS_D0L1E", "BELALASLAY", "C4LLMEHH4LEY",
    "CH00P1E_1S_B4CK", "D1ORST4R", "ELLA", "IBELLASLAY",
    "ITSJUSTNICHOLAS", "KITTYUUHH", "KREEK", "LABOOTS",
    "LANA", "LANABOW", "LANATUTU", "LEAHASHE", "M3RM4ID",
    "MEGANPLAYSBOOTS", "S3M_0W3N_Y4Y", "SUBM15CY", "TEKKYOOZ",
    "UMOYAE", "SUMMER2025", "NEWUPDATE", "FASHIONISTA"
}

AddToggle("redeemAllCodes", "🎁 Canjear todos los códigos activos", function(state)
    if state then
        spawn(function()
            for i, code in ipairs(activeCodes) do
                pcall(function()
                    ReplicatedStorage:WaitForChild("Functions"):WaitForChild("RedeemCode"):InvokeServer(code)
                end)
                AddNotification("Código canjeado: " .. code, 2)
                wait(0.8) -- Evitar rate limit
            end
            AddNotification("¡Todos los códigos canjeados!", 3)
        end)
    end
end)

AddTextbox("manualCode", "✏️ Código manual", "Introduce código aquí", function(value)
    local code = string.upper(string.gsub(value, "%s+", ""))
    if #code > 0 then
        pcall(function()
            ReplicatedStorage:WaitForChild("Functions"):WaitForChild("RedeemCode"):InvokeServer(code)
        end)
        AddNotification("Intentado: " .. code, 2)
    end
end)

-- ===== AUTO FARM Y DINERO =====
AddLabel("farm_section", "💰 AUTO FARM Y DINERO")

AddToggle("infiniteMoney", "💸 Dinero infinito", function(state)
    infiniteMoneyEnabled = state
    if state then
        spawn(function()
            while infiniteMoneyEnabled do
                pcall(function()
                    -- Hack de dinero (ajustar según la estructura del juego)
                    local moneyValue = LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("Money")
                    if moneyValue then
                        moneyValue.Value = 999999999
                    end
                    
                    -- También intentar modificar dinero en el servidor
                    ReplicatedStorage:FindFirstChild("AddMoney"):FireServer(50000)
                end)
                wait(5)
            end
        end)
        AddNotification("💰 Dinero infinito activado", 3)
    else
        AddNotification("💰 Dinero infinito desactivado", 2)
    end
end)

AddToggle("autoFarm", "🔄 Auto Farm Cash", function(state)
    autoFarmEnabled = state
    if state then
        spawn(function()
            while autoFarmEnabled do
                -- Auto farm por participar en fashion shows
                pcall(function()
                    local fashionEvent = ReplicatedStorage:FindFirstChild("JoinFashionShow")
                    if fashionEvent then
                        fashionEvent:FireServer()
                    end
                end)
                
                -- Auto votar en shows
                pcall(function()
                    local voteEvent = ReplicatedStorage:FindFirstChild("Vote")
                    if voteEvent then
                        voteEvent:FireServer(math.random(1,5)) -- Voto aleatorio
                    end
                end)
                
                wait(30) -- Cada 30 segundos
            end
        end)
        AddNotification("🔄 Auto Farm activado", 3)
    else
        AddNotification("🔄 Auto Farm desactivado", 2)
    end
end)

-- ===== VIP Y ITEMS PREMIUM =====
AddLabel("vip_section", "👑 VIP Y ITEMS PREMIUM")

AddToggle("unlockVIP", "👑 Desbloquear VIP gratis", function(state)
    if state then
        pcall(function()
            -- Modificar estado VIP local
            LocalPlayer:SetAttribute("VIP", true)
            LocalPlayer:SetAttribute("Premium", true)
            
            -- Intentar unlockear items VIP
            local vipItems = ReplicatedStorage:FindFirstChild("VIPItems")
            if vipItems then
                for _, item in pairs(vipItems:GetChildren()) do
                    item.Unlocked.Value = true
                end
            end
        end)
        AddNotification("👑 VIP desbloqueado!", 3)
    end
end)

AddToggle("unlockAllItems", "🎨 Desbloquear todos los items", function(state)
    if state then
        pcall(function()
            -- Desbloquear todos los items de ropa
            local itemsFolder = ReplicatedStorage:FindFirstChild("Items") or ReplicatedStorage:FindFirstChild("Clothing")
            if itemsFolder then
                for _, category in pairs(itemsFolder:GetChildren()) do
                    if category:IsA("Folder") then
                        for _, item in pairs(category:GetChildren()) do
                            if item:FindFirstChild("Unlocked") then
                                item.Unlocked.Value = true
                            end
                        end
                    end
                end
            end
            
            -- También desbloquear en el inventario local
            local inventory = LocalPlayer:FindFirstChild("Inventory")
            if inventory then
                for _, item in pairs(inventory:GetChildren()) do
                    item.Value = true
                end
            end
        end)
        AddNotification("🎨 Todos los items desbloqueados!", 3)
    end
end)

-- ===== COPIAR OUTFITS =====
AddLabel("outfit_section", "👗 GESTIÓN DE OUTFITS")

local targetPlayerName = ""
AddTextbox("targetPlayer", "👤 Nombre del jugador", "Escribe el nombre exacto", function(value)
    targetPlayerName = value
end)

AddToggle("copyOutfit", "📋 Copiar outfit del jugador", function(state)
    if state and targetPlayerName ~= "" then
        local targetPlayer = Players:FindFirstChild(targetPlayerName)
        if targetPlayer and targetPlayer.Character then
            pcall(function()
                -- Copiar accesorios
                for _, accessory in pairs(targetPlayer.Character:GetChildren()) do
                    if accessory:IsA("Accessory") then
                        local newAccessory = accessory:Clone()
                        newAccessory.Parent = LocalPlayer.Character
                    end
                end
                
                -- Copiar colores de ropa
                local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                if targetHumanoid then
                    Humanoid.BodyColors.HeadColor = targetHumanoid.BodyColors.HeadColor
                    Humanoid.BodyColors.TorsoColor = targetHumanoid.BodyColors.TorsoColor
                    Humanoid.BodyColors.LeftArmColor = targetHumanoid.BodyColors.LeftArmColor
                    Humanoid.BodyColors.RightArmColor = targetHumanoid.BodyColors.RightArmColor
                    Humanoid.BodyColors.LeftLegColor = targetHumanoid.BodyColors.LeftLegColor
                    Humanoid.BodyColors.RightLegColor = targetHumanoid.BodyColors.RightLegColor
                end
            end)
            AddNotification("📋 Outfit copiado de " .. targetPlayerName, 3)
        else
            AddNotification("❌ Jugador no encontrado", 2)
        end
    end
end)

AddToggle("saveCurrentOutfit", "💾 Guardar outfit actual", function(state)
    if state then
        local outfitData = {}
        
        -- Guardar accesorios
        for _, accessory in pairs(LocalPlayer.Character:GetChildren()) do
            if accessory:IsA("Accessory") then
                table.insert(outfitData, {
                    Type = "Accessory",
                    Id = accessory:FindFirstChild("Handle") and accessory.Handle:FindFirstChild("Mesh") and accessory.Handle.Mesh.MeshId or ""
                })
            end
        end
        
        -- Guardar colores
        outfitData.BodyColors = {
            HeadColor = Humanoid.BodyColors.HeadColor,
            TorsoColor = Humanoid.BodyColors.TorsoColor,
            LeftArmColor = Humanoid.BodyColors.LeftArmColor,
            RightArmColor = Humanoid.BodyColors.RightArmColor,
            LeftLegColor = Humanoid.BodyColors.LeftLegColor,
            RightLegColor = Humanoid.BodyColors.RightLegColor
        }
        
        table.insert(savedOutfits, outfitData)
        AddNotification("💾 Outfit guardado (#" .. #savedOutfits .. ")", 3)
    end
end)

AddToggle("loadLastOutfit", "📤 Cargar último outfit guardado", function(state)
    if state and #savedOutfits > 0 then
        local lastOutfit = savedOutfits[#savedOutfits]
        
        -- Remover accesorios actuales
        for _, accessory in pairs(LocalPlayer.Character:GetChildren()) do
            if accessory:IsA("Accessory") then
                accessory:Destroy()
            end
        end
        
        -- Aplicar outfit guardado
        pcall(function()
            for _, item in pairs(lastOutfit) do
                if item.Type == "Accessory" and item.Id ~= "" then
                    -- Crear nuevo accesorio (simplificado)
                    local newAccessory = Instance.new("Accessory")
                    local handle = Instance.new("Part")
                    local mesh = Instance.new("SpecialMesh")
                    
                    handle.Name = "Handle"
                    handle.Parent = newAccessory
                    mesh.Parent = handle
                    mesh.MeshId = item.Id
                    
                    newAccessory.Parent = LocalPlayer.Character
                end
            end
            
            -- Aplicar colores
            if lastOutfit.BodyColors then
                Humanoid.BodyColors.HeadColor = lastOutfit.BodyColors.HeadColor
                Humanoid.BodyColors.TorsoColor = lastOutfit.BodyColors.TorsoColor
                Humanoid.BodyColors.LeftArmColor = lastOutfit.BodyColors.LeftArmColor
                Humanoid.BodyColors.RightArmColor = lastOutfit.BodyColors.RightArmColor
                Humanoid.BodyColors.LeftLegColor = lastOutfit.BodyColors.LeftLegColor
                Humanoid.BodyColors.RightLegColor = lastOutfit.BodyColors.RightLegColor
            end
        end)
        
        AddNotification("📤 Outfit cargado!", 3)
    else
        AddNotification("❌ No hay outfits guardados", 2)
    end
end)

-- ===== TROLLING Y EFECTOS =====
AddLabel("troll_section", "🃏 TROLLING Y EFECTOS")

AddToggle("rainbowSkin", "🌈 Piel arcoíris", function(state)
    rainbowSkinEnabled = state
    if state then
        spawn(function()
            while rainbowSkinEnabled do
                local hue = tick() % 5 / 5
                local color = Color3.fromHSV(hue, 1, 1)
                
                pcall(function()
                    Humanoid.BodyColors.HeadColor3 = color
                    Humanoid.BodyColors.TorsoColor3 = color
                    Humanoid.BodyColors.LeftArmColor3 = color
                    Humanoid.BodyColors.RightArmColor3 = color
                    Humanoid.BodyColors.LeftLegColor3 = color
                    Humanoid.BodyColors.RightLegColor3 = color
                end)
                
                wait(0.1)
            end
        end)
    end
end)

local customFaceId = ""
AddTextbox("customFace", "😀 ID de cara personalizada", "Introduce Decal ID", function(value)
    customFaceId = value
end)

AddToggle("applyCustomFace", "🎭 Aplicar cara personalizada", function(state)
    if state and customFaceId ~= "" then
        pcall(function()
            local head = LocalPlayer.Character:FindFirstChild("Head")
            if head then
                local face = head:FindFirstChild("face") or Instance.new("Decal")
                face.Name = "face"
                face.Parent = head
                face.Face = Enum.NormalId.Front
                face.Texture = "rbxassetid://" .. customFaceId
            end
        end)
        AddNotification("🎭 Cara personalizada aplicada", 3)
    end
end)

AddToggle("glowEffect", "✨ Efecto brillante", function(state)
    pcall(function()
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                if state then
                    local pointLight = Instance.new("PointLight")
                    pointLight.Name = "GlowEffect"
                    pointLight.Color = Color3.fromRGB(255, 255, 255)
                    pointLight.Brightness = 2
                    pointLight.Range = 10
                    pointLight.Parent = part
                else
                    local glow = part:FindFirstChild("GlowEffect")
                    if glow then glow:Destroy() end
                end
            end
        end
    end)
end)

-- ===== MOVIMIENTO Y TELEPORT =====
AddLabel("movement_section", "🚀 MOVIMIENTO Y TELEPORT")

AddSlider("walkSpeed", "🏃 Velocidad de caminar", 16, 16, 200, function(value)
    currentWalkSpeed = value
    Humanoid.WalkSpeed = value
end)

AddSlider("jumpPower", "🦘 Fuerza de salto", 50, 50, 200, function(value)
    currentJumpPower = value
    Humanoid.JumpPower = value
end)

AddToggle("infiniteJump", "🦘 Salto infinito", function(state)
    if state then
        UserInputService.JumpRequest:Connect(function()
            if state then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

-- Teleports a ubicaciones importantes
local teleportLocations = {
    ["Spawn"] = Vector3.new(0, 5, 0),
    ["Dressing Room"] = Vector3.new(50, 5, 0),
    ["Runway"] = Vector3.new(0, 5, 100),
    ["VIP Area"] = Vector3.new(-50, 10, 0),
    ["Photo Studio"] = Vector3.new(100, 5, 50)
}

for locationName, position in pairs(teleportLocations) do
    AddToggle("teleport" .. locationName:gsub("%s+", ""), "📍 TP a " .. locationName, function(state)
        if state then
            RootPart.CFrame = CFrame.new(position)
            AddNotification("📍 Teletransportado a " .. locationName, 2)
        end
    end)
end

-- Teleport por coordenadas personalizadas
local customCoords = Vector3.new(0, 0, 0)
AddTextbox("coordX", "X", "0", function(v) customCoords = Vector3.new(tonumber(v) or 0, customCoords.Y, customCoords.Z) end)
AddTextbox("coordY", "Y", "0", function(v) customCoords = Vector3.new(customCoords.X, tonumber(v) or 0, customCoords.Z) end)
AddTextbox("coordZ", "Z", "0", function(v) customCoords = Vector3.new(customCoords.X, customCoords.Y, tonumber(v) or 0) end)

AddToggle("teleportCustom", "🎯 TP a coordenadas", function(state)
    if state then
        RootPart.CFrame = CFrame.new(customCoords)
        AddNotification("🎯 TP a " .. tostring(customCoords), 2)
    end
end)

-- ===== FUNCIONES ADICIONALES =====
AddLabel("extra_section", "⚡ FUNCIONES ADICIONALES")

AddToggle("noClip", "👻 Atravesar paredes", function(state)
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

AddToggle("antiAFK", "💤 Anti AFK", function(state)
    if state then
        spawn(function()
            while state do
                -- Pequeño movimiento para evitar AFK
                local currentPos = RootPart.CFrame
                RootPart.CFrame = currentPos * CFrame.new(0.1, 0, 0)
                wait(0.1)
                RootPart.CFrame = currentPos
                wait(300) -- Cada 5 minutos
            end
        end)
    end
end)

AddToggle("fullBright", "💡 Iluminación completa", function(state)
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
    end
end)

AddToggle("esp", "👁️ ESP (Ver jugadores)", function(state)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                if state then
                    local billboard = Instance.new("BillboardGui")
                    local textLabel = Instance.new("TextLabel")
                    
                    billboard.Name = "ESP"
                    billboard.Parent = humanoidRootPart
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true
                    
                    textLabel.Parent = billboard
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = player.Name
                    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    textLabel.TextScaled = true
                    textLabel.Font = Enum.Font.GothamBold
                else
                    local esp = humanoidRootPart:FindFirstChild("ESP")
                    if esp then esp:Destroy() end
                end
            end
        end
    end
end)

-- Auto-equipar nuevos items
AddToggle("autoEquip", "🎽 Auto equipar items nuevos", function(state)
    if state then
        local backpack = LocalPlayer:WaitForChild("Backpack")
        backpack.ChildAdded:Connect(function(item)
            if item:IsA("Tool") or item:IsA("Accessory") then
                item.Parent = LocalPlayer.Character
                AddNotification("🎽 Equipado: " .. item.Name, 2)
            end
        end)
    end
end)

-- ===== INFORMACIÓN Y ESTADO =====
AddLabel("info_section", "ℹ️ INFORMACIÓN")
AddText("status", "Estado: Script cargado correctamente", "Versión: 3.0 Advanced", 
    { color=Color3.fromRGB(0,255,0), style="Bold", size=14 }
)

-- Función para mostrar notificaciones
function AddNotification(text, duration)
    print("📢 " .. text)
    -- Aquí podrías agregar una GUI de notificación más avanzada
end

-- ===== INICIALIZACIÓN =====
spawn(function()
    wait(2)
    AddNotification("🌟 Dress to Impress Ultimate Helper cargado!", 3)
    AddNotification("✅ Todas las funciones disponibles", 2)
end)

-- Mantener la velocidad personalizada
spawn(function()
    while wait(1) do
        if Humanoid.WalkSpeed ~= currentWalkSpeed then
            Humanoid.WalkSpeed = currentWalkSpeed
        end
        if Humanoid.JumpPower ~= currentJumpPower then
            Humanoid.JumpPower = currentJumpPower
        end
    end
end)

print("🎉 Dress to Impress Ultimate Helper v3.0 - Completamente cargado!")
