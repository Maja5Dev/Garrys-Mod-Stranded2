
-- Hide the default HL2 Health and Aux bars
local hide = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true
}

hook.Add("HUDShouldDraw", "HideDefaultHUD", function(name)
    if hide[name] then return false end
end)

hook.Add("HUDPaint", "SimpleSurvivalHUD", function()
    local client = LocalPlayer()
    if !client:Alive() then return end
    if client:Team() != 1 then return end

    -- Configuration
    local width = 200
    local height = 20
    local spacing = 10
    local x = 30
    local y = ScrH() - 100 -- Starting height from bottom

    -- Fetching Data (Defaulting to 100 if variables don't exist yet)
    local hp = client:Health()
    local hunger = math.Round(client:GetNWInt("st_hunger", 100)) -- Common variable name for survival mods
    local thirst = math.Round(client:GetNWInt("st_thirst", 100))

    -- Helper function to draw bars
    local function DrawStatBar(current, max, label, color, order)
        local barY = y + (order * (height + spacing))
        
        -- Background (Shadow)
        draw.RoundedBox(4, x, barY, width, height, Color(0, 0, 0, 200))
        
        -- Foreground (The actual stat)
        local fillWidth = math.Clamp((current / max) * width, 0, width)
        draw.RoundedBox(4, x, barY, fillWidth, height, color)

        -- Text Label
        draw.SimpleText(label .. ": " .. current, "DermaDefaultBold", x + 5, barY + 3, Color(255, 255, 255))
    end

    -- Draw the bars
    DrawStatBar(hp, 100, "HEALTH", Color(200, 50, 50), 0)
    DrawStatBar(hunger, 100, "HUNGER", Color(200, 150, 50), 1)
    DrawStatBar(thirst, 100, "THIRST", Color(50, 100, 200), 2)
end)
