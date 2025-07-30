AddText("welcomeMsg", "Welcome", "🎮 ¡Bienvenido al HackName Menu!", {
    color = Color3.fromRGB(0, 255, 150),
    style = "Bold",
    font = "GothamBold",
    align = "Center",
    size = 16,
    icon = false
})

AddToggle("speedHack", "Speed Hack", function(enabled)
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = enabled and 50 or 16
    end
end)

AddTextbox("walkspeedInput", "Walk Speed", "16", function(text)
    local speed = tonumber(text) or 16
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end)

AddText("movementInfo", "Movement Info", "Configura tu velocidad de movimiento personalizada", {
    color = Color3.fromRGB(200, 200, 255),
    style = "Normal",
    font = "Gotham",
    align = "Left",
    size = 12,
    icon = true
})

AddCheckbox("showFPS", "Show FPS Counter", function(enabled)
    print("FPS Counter:", enabled and "Enabled" or "Disabled")
end)

AddToggle("fullbright", "Full Bright", function(enabled)
    local lighting = game:GetService("Lighting")
    if enabled then
        lighting.Brightness = 2
        lighting.ClockTime = 14
        lighting.FogEnd = 100000
    else
        lighting.Brightness = 1
        lighting.ClockTime = 14
        lighting.FogEnd = 100000
    end
end)

AddText("versionText", "Version Info", "Version: 0.1.0 | Build: 1 | Release: 2025", {
    color = Color3.fromRGB(150, 255, 150),
    style = "Normal",
    font = "Code",
    align = "Center",
    size = 11,
    icon = true
})

AddText("footerText", "Footer", "Made with ❤️ by XabitaGG", {
    color = Color3.fromRGB(255, 100, 150),
    style = "Normal",
    font = "Cartoon",
    align = "Center",
    size = 12,
    icon = false
})
