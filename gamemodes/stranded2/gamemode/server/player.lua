
function GM:PlayerInitialSpawn(ply)
	ply:SetNoDraw(true)
	ply:SetTeam(TEAM_UNASSIGNED)
	ply:ConCommand("char_menu")
	ply.died = false
end

function GM:PlayerSpawn(ply)
	if ply:Team() == TEAM_UNASSIGNED then
		ply:SetSpectator()
	end
	
	ply:SetSuppressPickupNotices(true)

	if ply.died == true then
		ply:SetHealth(40)
		ply:SetHunger(30)
		ply:SetThirst(30)
		ply.died = false
	end
end

function GM:PlayerDeath(victim)
	victim.died = true
	PrintMessage(HUD_PRINTTALK, victim:Name() .. " died.")
end
