AddLabel("welcome", "🔥 Bienvenido al ModMenu Universal 🔥")

AddToggle("speedhack", "SpeedHack", function(enabled)
    if enabled then
        print("SpeedHack activado")
        -- Aquí pondrías el código para activar el speedhack
    else
        print("SpeedHack desactivado")
        -- Código para desactivar speedhack
    end
end)

AddToggle("flyhack", "Fly Hack", function(enabled)
    if enabled then
        print("Fly Hack activado")
        -- Código para activar fly
    else
        print("Fly Hack desactivado")
        -- Código para desactivar fly
    end
end)

AddCheckbox("noclip", "Noclip", function(enabled)
    if enabled then
        print("Noclip activado")
        -- Código para activar noclip
    else
        print("Noclip desactivado")
        -- Código para desactivar noclip
    end
end)

AddTextbox("customSpeed", "Custom Speed", "Ingresa velocidad", function(text)
    local speed = tonumber(text)
    if speed then
        print("Velocidad personalizada: " .. speed)
        -- Aquí aplicas la velocidad personalizada
    else
        print("Valor inválido para velocidad")
    end
end)

AddText("info", "infoText", "Este menú es un ejemplo básico. Añade tus hacks aquí.", {color = Color3.fromRGB(255, 200, 0), style = "Bold", align = "Center"})

