
hook.Add("Tick", "ST_UpdatePlayerSpeeds", function()
    for _, ply in ipairs(player.GetAll()) do
        if IsValid(ply) and ply:Alive() then
            local speedMultiplier = 1.0
            
            -- Check for status effects that modify speed
            if ply:GetHunger() < 20 then
                speedMultiplier = speedMultiplier * 0.9
            end
            
            if ply:GetThirst() < 20 then
                speedMultiplier = speedMultiplier * 0.8
            end

            if ply.doingAction != nil then
                speedMultiplier = 0.01
            end
            
            ply:SetWalkSpeed(DEF_WALK_SPEED * speedMultiplier)
            ply:SetRunSpeed(DEF_RUN_SPEED * speedMultiplier)
            ply:SetJumpPower(DEF_JUMP_POWER * speedMultiplier)
        end
    end
end)
