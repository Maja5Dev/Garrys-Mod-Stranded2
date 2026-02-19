
function GM:PlayerInitialSpawn(ply)
	ply:SetNoDraw(true)
	ply:SetTeam(TEAM_UNASSIGNED)
	ply:ConCommand("char_menu")
end

function GM:PlayerSpawn(ply)
	if ply:Team() == TEAM_UNASSIGNED then
		ply:SetSpectator()
	end
	
	ply:SetSuppressPickupNotices(true)

	if ply.died == true then
		ply:SetHealth(50)
		ply:SetHunger(100)
		ply:SetThirst(100)
		ply.died = false
		print("Player " .. ply:Name() .. " has respawned with 50 health, 100 hunger, and 100 thirst.")
	end
end

function GM:PlayerDeath(victim)
	victim.died = true
	PrintMessage(HUD_PRINTTALK, victim:Name() .. " died.")
end
