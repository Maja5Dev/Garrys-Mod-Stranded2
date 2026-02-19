
local cooldown = 0

hook.Add("HUDPaint", "WaterGrassInteraction", function()
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:Alive() then return end

    -- Trace from the player's eyes forward 100 units
    local tr = ply:GetEyeTrace()
    if tr.HitPos:Distance(ply:GetShootPos()) > 100 then return end

    local material = tr.HitTexture
    local prompt = ""
    local actionType = nil

    -- Check for Water
    -- GMod water textures usually contain "nature/water" or "liquid"
    if tr.MatType == MAT_SLOSH or string.find(material, "water") or ply:WaterLevel() > 0 then
        prompt = "Press [E] to drink from water source"
        actionType = "water"
    
    -- Check for Grass
    elseif tr.MatType == MAT_GRASS or string.find(material, "grass") then
        prompt = "Press [E] to forage"
        actionType = "grass"
    end

    -- Draw the UI if we have an action
    if actionType then
        draw.SimpleTextOutlined(prompt, "DefaultFixedDropShadow", ScrW() / 2, ScrH() / 2 + 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)

        -- Handle Interaction
        if input.IsKeyDown(KEY_E) and CurTime() > cooldown then
            cooldown = CurTime() + 1 -- 1 second cooldown
            
            if actionType == "water" then
                net.Start("st_pl_drink_water")
                net.SendToServer()
                print("Interacting with water...")

            elseif actionType == "grass" then
                net.Start("st_pl_forage")
                net.SendToServer()
                print("Interacting with grass...")
            end
        end
    end
end)
