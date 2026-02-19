
local next_hunger_check = 0

hook.Add("Tick", "Stranded2_HungerSystem", function()
    if CurTime() < next_hunger_check then return end

    for _, ply in pairs(player.GetAll()) do
        if not IsValid(ply) then continue end
        if not ply:Alive() then continue end
        if ply:Team() != 1 then continue end -- Only apply to players in the Characters team

        ply:AddHunger(-0.05)
        ply:AddThirst(-0.07)

        if ply:GetHunger() <= 0 then
            local damage = DamageInfo()
            damage:SetDamage(1)
            damage:SetDamageType(DMG_GENERIC)
            damage:SetAttacker(game.GetWorld())
            damage:SetInflictor(game.GetWorld())
            ply:TakeDamageInfo(damage)
        end
    end

    next_hunger_check = CurTime() + 2
end)
