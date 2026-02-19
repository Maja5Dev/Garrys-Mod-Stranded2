
local xp_needed_for_level = 400
local extra_xp_needed_per_level = 1.07 -- multiplier

local player_meta = FindMetaTable("Player")

function player_meta:AddEXP(amount)
    local currentEXP = self:GetNWInt("st_exp", 0)
    local newEXP = currentEXP + amount
    self:SetEXP(newEXP)

    -- Check for level up
    local currentLevel = self:GetNWInt("st_level", 0)
    local expToLevelUp = xp_needed_for_level
    expToLevelUp = math.floor(expToLevelUp * (extra_xp_needed_per_level ^ currentLevel)) -- Increase required EXP for each level

    if newEXP >= expToLevelUp then
        self:SetLevel(currentLevel + 1)
        self:SetEXP(newEXP - expToLevelUp) -- Carry over extra EXP
        self:ChatPrint("Congratulations! You've leveled up to Level " .. (currentLevel + 1) .. "!")
    end
end

function player_meta:StripPlayer()
    self:StripWeapons()
    self:StripAmmo()
end

function player_meta:SetSpectator()
	self:StripPlayer()
	self:SetNoDraw(true)
	self:SetNoTarget(true)
	self:SetTeam(TEAM_SPECTATOR)
	self:Spectate(OBS_MODE_ROAMING)
end

function player_meta:UnSpectatePlayer(savepos)
	local pos = self:GetPos()
	local ang = self:EyeAngles()
	self:SetNoDraw(false)
	self:UnSpectate()
	self:Spawn()
	
	if savepos == true then
		self:SetPos(pos)
		self:SetEyeAngles(ang)
	end
end

-- Char Name
function player_meta:SetCharName(name)
    self:SetNWString("st_char_name", name)
end

function player_meta:GetCharName()
    return self:GetNWString("st_char_name", "Unknown")
end

-- Hunger
function player_meta:AddHunger(amount)
    local hunger = self:GetNWInt("st_hunger", 100)
    hunger = math.Clamp(hunger + amount, 0, 100)
    self:SetNWInt("st_hunger", hunger)
end

function player_meta:SetHunger(amount)
    self:SetNWInt("st_hunger", math.Clamp(amount, 0, 100))
end

function player_meta:GetHunger()
    return self:GetNWInt("st_hunger", 100)
end

-- Thirst
function player_meta:AddThirst(amount)
    local thirst = self:GetNWInt("st_thirst", 100)
    thirst = math.Clamp(thirst + amount, 0, 100)
    self:SetNWInt("st_thirst", thirst)
end

function player_meta:SetThirst(amount)
    self:SetNWInt("st_thirst", math.Clamp(amount, 0, 100))
end

function player_meta:GetThirst()
    return self:GetNWInt("st_thirst", 100)
end

-- Level
function player_meta:AddLevel(amount)
    local level = self:GetNWInt("st_level", 0)
    level = math.max(0, level + amount)
    self:SetNWInt("st_level", level)
end

function player_meta:SetLevel(level)
    self:SetNWInt("st_level", math.max(0, level))
end

function player_meta:GetLevel()
    return self:GetNWInt("st_level", 0)
end

-- EXP
function player_meta:AddEXP(amount)
    local exp = self:GetNWInt("st_exp", 0)
    exp = math.max(0, exp + amount)
    self:SetNWInt("st_exp", exp)
end

function player_meta:SetEXP(exp)
    self:SetNWInt("st_exp", math.max(0, exp))
end

function player_meta:GetEXP()
    return self:GetNWInt("st_exp", 0)
end

-- Cloth
function player_meta:AddCloth(amount)
    local cloth = self:GetNWInt("st_cloth", 0)
    cloth = math.max(0, cloth + amount)
    self:SetNWInt("st_cloth", cloth)
end

function player_meta:SetCloth(amount)
    self:SetNWInt("st_cloth", math.max(0, amount))
end

function player_meta:GetCloth()
    return self:GetNWInt("st_cloth", 0)
end

-- Wood
function player_meta:AddWood(amount)
    local wood = self:GetNWInt("st_wood", 0)
    wood = math.max(0, wood + amount)
    self:SetNWInt("st_wood", wood)
end

function player_meta:SetWood(amount)
    self:SetNWInt("st_wood", math.max(0, amount))
end

function player_meta:GetWood()
    return self:GetNWInt("st_wood", 0)
end

-- Stone
function player_meta:AddStone(amount)
    local stone = self:GetNWInt("st_stone", 0)
    stone = math.max(0, stone + amount)
    self:SetNWInt("st_stone", stone)
end

function player_meta:SetStone(amount)
    self:SetNWInt("st_stone", math.max(0, amount))
end

function player_meta:GetStone()
    return self:GetNWInt("st_stone", 0)
end

-- Copper
function player_meta:AddCopper(amount)
    local copper = self:GetNWInt("st_copper", 0)
    copper = math.max(0, copper + amount)
    self:SetNWInt("st_copper", copper)
end

function player_meta:SetCopper(amount)
    self:SetNWInt("st_copper", math.max(0, amount))
end

function player_meta:GetCopper()
    return self:GetNWInt("st_copper", 0)
end

-- Iron
function player_meta:AddIron(amount)
    local iron = self:GetNWInt("st_iron", 0)
    iron = math.max(0, iron + amount)
    self:SetNWInt("st_iron", iron)
end

function player_meta:SetIron(amount)
    self:SetNWInt("st_iron", math.max(0, amount))
end

function player_meta:GetIron()
    return self:GetNWInt("st_iron", 0)
end

-- Stat Attack
function player_meta:SetStatAttack(amount)
    self:SetNWInt("st_stat_attack", math.max(0, amount))
end

function player_meta:AddStatAttack(amount)
    local current = self:GetNWInt("st_stat_attack", 0)
    self:SetNWInt("st_stat_attack", math.max(0, current + amount))
end

function player_meta:GetStatAttack()
    return self:GetNWInt("st_stat_attack", 0)
end

-- Stat Defense
function player_meta:SetStatDefense(amount)
    self:SetNWInt("st_stat_defense", math.max(0, amount))
end

function player_meta:AddStatDefense(amount)
    local current = self:GetNWInt("st_stat_defense", 0)
    self:SetNWInt("st_stat_defense", math.max(0, current + amount))
end

function player_meta:GetStatDefense()
    return self:GetNWInt("st_stat_defense", 0)
end

-- Stat Speed
function player_meta:SetStatSpeed(amount)
    self:SetNWInt("st_stat_speed", math.max(0, amount))
end

function player_meta:AddStatSpeed(amount)
    local current = self:GetNWInt("st_stat_speed", 0)
    self:SetNWInt("st_stat_speed", math.max(0, current + amount))
end

function player_meta:GetStatSpeed()
    return self:GetNWInt("st_stat_speed", 0)
end

-- Stat Stamina
function player_meta:SetStatStamina(amount)
    self:SetNWInt("st_stat_stamina", math.max(0, amount))
end

function player_meta:AddStatStamina(amount)
    local current = self:GetNWInt("st_stat_stamina", 0)
    self:SetNWInt("st_stat_stamina", math.max(0, current + amount))
end

function player_meta:GetStatStamina()
    return self:GetNWInt("st_stat_stamina", 0)
end