-- Release.lua: Universal Game Hack Configuration for Mod Menu UI
-- For educational purposes only. Do not use in live Roblox games.

-- Clear existing elements to avoid conflicts
for id, element in pairs(elements or {}) do
    element:Destroy()
end
elements = {}
elementCount = 0

-- Game selection buttons
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

-- Add game selection buttons
AddLabel("game_select_label", "Select a Game:")
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

            -- Load game-specific hacks
            if game == "Murder Mystery 2" then
                AddToggle("mm2_esp", "Player ESP", function(state)
                    addConsoleLog("MM2 Player ESP: " .. (state and "Enabled" or "Disabled"), state and "success" or "info")
                end)
                AddCheckbox("mm2_killall", "Kill All", function(state)
                    addConsoleLog("MM2 Kill All: " .. (state and "Activated" or "Deactivated"), state and "success" or "info")
                end)
                AddTextbox("mm2_coins", "Coin Multiplier", "1", function(value)
                    addConsoleLog("MM2 Coin Multiplier set to: " .. value, "info")
                end)
            elseif game == "Free Fire Max Roblox" then
                AddToggle("ff_aim", "Aim Assist", function(state)
                    addConsoleLog("FF Aim Assist: " .. (state and "Enabled" or "Disabled"), state and "success" or "info")
                end)
                AddToggle("ff_speed", "Speed Hack", function(state)
                    addConsoleLog("FF Speed Hack: " .. (state and "Enabled" or "Disabled"), state and "success" or "info")
                end)
                AddCheckbox("ff_ammo", "Infinite Ammo", function(state)
                    addConsoleLog("FF Infinite Ammo: " .. (state and "Activated" or "Deactivated"), state and "success" or "info")
                end)
            elseif game == "Hide & Seek Extreme" then
                AddToggle("hs_reveal", "Reveal Hiders", function(state)
                    addConsoleLog("HS Reveal Hiders: " .. (state and "Enabled" or "Disabled"), state and "success" or "info")
                end)
                AddCheckbox("hs_autoseek", "Auto-Seek", function(state)
                    addConsoleLog("HS Auto-Seek: " .. (state and "Activated" or "Deactivated"), state and "success" or "info")
                end)
            elseif game == "Find the Button" then
                AddToggle("ftb_esp", "Button ESP", function(state)
                    addConsoleLog("FTB Button ESP: " .. (state and "Enabled" or "Disabled"), state and "success" or "info")
                end)
                AddCheckbox("ftb_autoclick", "Auto-Click Button", function(state)
                    addConsoleLog("FTB Auto-Click: " .. (state and "Activated" or "Deactivated"), state and "success" or "info")
                end)
            elseif game == "Prop Hunt" then
                AddToggle("ph_prop_esp", "Prop ESP", function(state)
                    addConsoleLog("PH Prop ESP: " .. (state and "Enabled" or "Disabled"), state and "success" or "info")
                end)
                AddCheckbox("ph_invis", "Invisibility", function(state)
                    addConsoleLog("PH Invisibility: " .. (state and "Activated" or "Deactivated"), state and "success" or "info")
                end)
            elseif game == "Epic Minigames" then
                AddToggle("em_autowin", "Auto-Win Minigame", function(state)
                    addConsoleLog("EM Auto-Win: " .. (state and "Enabled" or "Disabled"), state and "success" or "info")
                end)
                AddTextbox("em_score", "Score Multiplier", "1", function(value)
                    addConsoleLog("EM Score Multiplier set to: " .. value, "info")
                end)
            elseif game == "Tower of Hell" then
                AddToggle("toh_nofall", "No Fall Damage", function(state)
                    addConsoleLog("ToH No Fall: " .. (state and "Enabled" or "Disabled"), state and "success" or "info")
                end)
                AddCheckbox("toh_autoclimb", "Auto-Climb", function(state)
                    addConsoleLog("ToH Auto-Climb: " .. (state and "Activated" or "Deactivated"), state and "success" or "info")
                end)
            elseif game == "Brookhaven 🏡 RP" then
                AddTextbox("bh_money", "Money Amount", "1000", function(value)
                    addConsoleLog("BH Money set to: " .. value, "info")
                end)
                AddToggle("bh_unlock", "Unlock All Items", function(state)
                    addConsoleLog("BH Unlock All: " .. (state and "Enabled" or "Disabled"), state and "success" or "info")
                end)
            elseif game == "Dress to Impress" then
                AddCheckbox("dti_autostyle", "Auto-Style Outfit", function(state)
                    addConsoleLog("DTI Auto-Style: " .. (state and "Activated" or "Deactivated"), state and "success" or "info")
                end)
                AddTextbox("dti_currency", "Currency Boost", "100", function(value)
                    addConsoleLog("DTI Currency Boost set to: " .. value, "info")
                end)
            end
            -- Disable other game toggles
            for j, otherGame in ipairs(games) do
                if i ~= j and elements["game_select_" .. j] then
                    local toggle = elements["game_select_" .. j]:FindFirstChildOfClass("TextButton")
                    if toggle then
                        toggle:FindFirstChildOfClass("Frame"):FindFirstChildOfClass("Frame").Position = UDim2.new(0, 2, 0.5, -8)
                        toggle:FindFirstChildOfClass("Frame").BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                    end
                end
            end
        end
    end)
end

-- Add disclaimer
AddText("disclaimer", "Disclaimer", "For educational purposes only. Do not use in live games.", {
    color = Color3.fromRGB(255, 100, 100),
    font = "GothamBold",
    align = "Center",
    size = 12
})

addConsoleLog("Game selection loaded successfully", "success")
