AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Bush"
ENT.Author    = "Maya"
ENT.Category  = "Stranded 2"
ENT.Spawnable = true

-- Initial Setup
function ENT:Initialize()
    -- Set the model to the one you requested
   --self:SetModel("models/props_foliage/bush2.mdl")
   self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
   self:SetNoDraw(true) -- Hide the default model since we're using a child prop for visuals

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    if SERVER then
        self:SetUseType(SIMPLE_USE)
    end

    -- Freeze it in place immediately
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
        phys:Sleep()
    end

    if SERVER then
        local bush_model = ents.Create("prop_physics")
        bush_model:SetModel("models/props_foliage/bush2.mdl")
        bush_model:SetPos(self:GetPos() - Vector(0, 0, 10)) -- Adjust position so it sits nicely on the ground
        bush_model:SetAngles(self:GetAngles())
        bush_model:SetParent(self)
        bush_model:Spawn()
    end
end

-- Interaction Logic
if SERVER then
    function ENT:Use(activator, caller)
        -- 'activator' is usually the player who pressed E
        if IsValid(activator) and activator:IsPlayer() then
            
            -- Action: Let's give them a little health and play a sound
            activator:SetHealth(math.min(activator:Health() + 5, 100))
            self:EmitSound("physics/surfaces/underwater_impact_slap1.wav")
            
            -- Notify the player
            activator:PrintMessage(HUD_PRINTTALK, "You searched the bush and felt refreshed!")
            
            -- Optional: Add a cool effect
            local effectdata = EffectData()
            effectdata:SetOrigin(self:GetPos())
            util.Effect("WheelDust", effectdata)
        end
    end
end

-- Client-side drawing (standard)
if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end
