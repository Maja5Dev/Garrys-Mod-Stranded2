
function GM:SpawnNPC(ply, npc_type, pos, ang)
    local npc = ents.Create(npc_type)
    npc:SetPos(pos)
    npc:SetAngles(ang)
    npc:Spawn()
end
