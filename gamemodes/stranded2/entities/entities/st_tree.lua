AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Tree"
ENT.Author    = "Maya"
ENT.Category  = "Stranded 2"
ENT.Spawnable = true

ENT.Models = {
    "models/props_foliage/tree_pine04.mdl",
    "models/props_foliage/tree_pine05.mdl",
    "models/props_foliage/tree_pine06.mdl",
    "models/props_foliage/tree_pine_large.mdl"
}

-- Initial Setup
function ENT:Initialize()
    if SERVER then
        -- Set the model to the one you requested
        self:SetModel(table.Random(self.Models))
        
        -- Physics setup
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)

        -- Freeze it in place immediately
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableMotion(false)
            phys:Wake()
        end

        self:SetHealth(800)
        self:SetPos(self:GetPos() - Vector(0, 0, 10))
    end
end

-- Client-side drawing (standard)
if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end

function ENT:OnTakeDamage(dmginfo)
    self:SetHealth(self:Health() - dmginfo:GetDamage())

    local inflictor = dmginfo:GetInflictor()
    local attacker = dmginfo:GetAttacker()

    if IsValid(inflictor) and attacker:IsPlayer() and
    !(string.find(inflictor:GetClass(), "pickaxe") or string.find(inflictor:GetClass(), "pick_axe")) and
    string.find(inflictor:GetClass(), "axe")
    then
        attacker:AddWood(1)
        attacker:AddEXP(1)
    end

    if (self:Health() <= 0) then
        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())
        util.Effect("Explosion", effectdata)
        self:Remove()
        attacker:AddEXP(1)
    else
        -- Optional: Add a hit effect
        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())
        util.Effect("ManhackSparks", effectdata)
    end
end
