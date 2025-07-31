-- Información general
AddLabel("title", "Dress to Impress Helper")

AddText("desc", "Bienvenido a tu GUI para Dress to Impress",
    "Usá los toggles para canjear códigos oficiales o intentar resolver el código secreto del flamethrower automático.",
    { color=Color3.fromRGB(255,255,255), style="Bold", size=16, align="Center", icon=true, font="GothamBold" }
)

-- Toggle: canjear todos los códigos activos conocidos
local codes = {
    "PIXIIUWU",
    "1CON1CF4TMA",
    "3NCHANTEDD1ZZY",
    "ANGELT4NKED",
    "ASHLEYBUNNI",
    "B3APL4YS_D0L1E",
    "BELALASLAY",
    "C4LLMEHH4LEY",
    "CH00P1E_1S_B4CK",
    "D1ORST4R",
    "ELLA",
    "IBELLASLAY",
    "ITSJUSTNICHOLAS",
    "KITTYUUHH",
    "KREEK",
    "LABOOTS",
    "LANA",
    "LANABOW",
    "LANATUTU",
    "LEAHASHE",
    "M3RM4ID",
    "MEGANPLAYSBOOTS",
    "S3M_0W3N_Y4Y",
    "SUBM15CY",
    "TEKKYOOZ",
    "UMOYAE"
}

AddToggle("redeemCodes", "Canjear códigos activos", function(state)
    if state then
        for _, code in ipairs(codes) do
            game:GetService("ReplicatedStorage"):WaitForChild("Functions"):WaitForChild("RedeemCode"):InvokeServer(code)
            wait(0.5)
        end
        print("Códigos canjeados.")
    end
end)

-- Textbox para ingresar un código manual
AddTextbox("manualCode", "Introducir código manual", "Escribí el código (todo en mayúscula)", function(value)
    local code = string.upper(value:match("%S+")) -- limpia espacios
    if #code > 0 then
        game:GetService("ReplicatedStorage"):WaitForChild("Functions"):WaitForChild("RedeemCode"):InvokeServer(code)
        print("Intentado código:", code)
    end
end)

-- Checkbox: mostrar pistas automáticas para el código secreto del flamethrower
AddCheckbox("hintSolver", "Mostrar pistas del código secreto", function(state)
    if state then
        -- Asumimos que hay un valor compartido con emojis y números
        local info = game:GetService("ReplicatedStorage"):FindFirstChild("SecretCodeInfo")
        if info then
            print("Emoji‑Number Clues:")
            for emoji, num in pairs(info:GetChildren()) do
                print(emoji.Name, "=", num.Value)
            end
        else
            print("No hay información de pistas disponible.")
        end
    else
        print("Pistas ocultadas.")
    end
end)

-- Coordenadas manuales (si necesitás teletransportarte o ubicar posiciones de emojis)
local coords = Vector3.new(0,0,0)
AddTextbox("coordX", "Coord X", "Ej: 100", function(v) coords = Vector3.new(tonumber(v) or coords.X, coords.Y, coords.Z) end)
AddTextbox("coordY", "Coord Y", "Ej: 5", function(v) coords = Vector3.new(coords.X, tonumber(v) or coords.Y, coords.Z) end)
AddTextbox("coordZ", "Coord Z", "Ej: -50", function(v) coords = Vector3.new(coords.X, coords.Y, tonumber(v) or coords.Z) end)

AddToggle("teleportCoords", "Teleport a coordenadas", function(state)
    if state then
        local plr = game.Players.LocalPlayer
        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(coords)
            print("Teletransporte a:", coords)
        else
            warn("No se pudo teletransportar: personaje no disponible.")
        end
    end
end)

-- Opciones adicionales útiles
AddLabel("extras", "Extras disponibles")
AddToggle("autoPickClothes", "Auto equipar ropa canjeada", function(state)
    -- lógica de ejemplo: equipar último redeem
    if state then
        -- suponiendo que hay un evento que notifica items añadidos
        game:GetService("Players").LocalPlayer.Backpack.ChildAdded:Connect(function(item)
            item.Parent = game.Players.LocalPlayer.Character
            print("Equipado:", item.Name)
        end)
    end
end)

AddToggle("autoAcceptInfo", "Auto aceptar tutoriales o popups", function(state)
    if state then
        -- cerrar ventanas emergentes automáticamente
        local gui = game:GetService("Players").LocalPlayer.PlayerGui
        gui.DescendantAdded:Connect(function(child)
            if child:IsA("TextButton") and child.Text == "Aceptar" then
                child:Activate()
                print("Popup aceptado automáticamente.")
            end
        end)
    end
end)

