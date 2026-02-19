
local player_meta = FindMetaTable("Player")

ST2_DATA_FOLDER = "stranded2_characters"

if not file.Exists(ST2_DATA_FOLDER, "DATA") then
    file.CreateDir(ST2_DATA_FOLDER)
end

function loadCharData(ply, char_id)
	if not IsValid(ply) then return end

    local fileName = ST2_DATA_FOLDER .. "/" .. ply:SteamID64() .. "_c" .. char_id .. ".txt"

    if file.Exists(fileName, "DATA") then
        local rawData = file.Read(fileName, "DATA")
        local stats = util.JSONToTable(rawData)

        if stats then
			return stats
        end
    end

	return nil
end

function player_meta:LoadCharacterState(char_id)
	local data = loadCharData(self, char_id)

	if not data then
		self:PrintMessage(HUD_PRINTTALK, "No saved data for this character slot.")
		return
	end

	self:SetTeam(1)
	self:UnSpectatePlayer(false)

	self:SetCharName(data.name or "Unknown")

	self:SetHealth(tonumber(data.hp) or 100)
	self:SetThirst(tonumber(data.thirst) or 100)
	self:SetHunger(tonumber(data.hunger) or 100)

	if data.position != nil then
		if istable(data.position) and data.position.x and data.position.y and data.position.z then
			self:SetPos(Vector(data.position.x, data.position.y, data.position.z))
		end
	else
		/*
		local all_spawns = table.Copy(MAPCONFIG.DEFAULT_SPAWNS)
		local rnd_spawn = TableRandom(all_spawns)

		if rnd_spawn then
			self:SetPos(rnd_spawn)
			table.RemoveByValue(all_spawns, rnd_spawn)
		end
		*/
	end

	if data.eyeangs != nil then
		if istable(data.eyeangs) and data.eyeangs.p and data.eyeangs.y and data.eyeangs.r then
			self:SetEyeAngles(Angle(data.eyeangs.p, data.eyeangs.y, data.eyeangs.r))
		end
	end

	if data.model != nil then
		self:SetModel(data.model)

		if data.bodygroups != nil then
			self.st_body_groups = data.bodygroups
			self:SetBodyGroups(data.bodygroups)
		end
	end

    -- rpg stats
	self:SetLevel(tonumber(data.level) or 0)
	self:SetEXP(tonumber(data.exp) or 0)
	self:SetCloth(tonumber(data.cloth) or 0)
	self:SetWood(tonumber(data.wood) or 0)
	self:SetStone(tonumber(data.stone) or 0)
	self:SetCopper(tonumber(data.copper) or 0)
	self:SetIron(tonumber(data.iron) or 0)

	self:SetStatAttack(tonumber(data.stat_attack) or 0)
	self:SetStatDefense(tonumber(data.stat_defense) or 0)
	self:SetStatSpeed(tonumber(data.stat_speed) or 0)
	self:SetStatStamina(tonumber(data.stat_stamina) or 0)

	ply.backpack_items = data.backpack_items or {}

	self:SetNWInt("st_charid", char_id)
end

function player_meta:SaveCharacterState(char_id)
    local stats = {
		name = self:GetCharName(),
		hp = self:Health(),
		thirst = self:GetThirst(),
		hunger = self:GetHunger(),

		position = {x=self:GetPos().x, y=self:GetPos().y, z=self:GetPos().z},
		eyeangs = {p=self:EyeAngles().p, y=self:EyeAngles().y, r=self:EyeAngles().r},
		model = self:GetModel(),
		bodygroups = self.st_body_groups,

		level = self:GetLevel(),
		cloth = self:GetCloth(),
		wood = self:GetWood(),
		stone = self:GetStone(),
		copper = self:GetCopper(),
		iron = self:GetIron(),

		stat_attack = self:GetStatAttack(),
		stat_defense = self:GetStatDefense(),
		stat_speed = self:GetStatSpeed(),
		stat_stamina = self:GetStatStamina(),

		backpack_items = self.backpack_items or {},
    }

    -- Convert the table to JSON for easy reading/writing
    local jsonData = util.TableToJSON(stats)
    local fileName = ST2_DATA_FOLDER .. "/" .. self:SteamID64() .. "_c" .. char_id .. ".txt"

    file.Write(fileName, jsonData)

	print("Character data saved for " .. self:Nick() .. " (Slot " .. char_id .. ")")
	print(fileName)
end

hook.Add("PlayerDisconnected", "ST_SaveChar_Disconnect", function(ply)
	local char_id = ply:GetNWInt("st_charid", nil)

	if char_id then
		ply:SaveCharacterState(char_id)
	end
end)

hook.Add("ShutDown", "ST_SaveChar_ServerShuttingDown", function()
	for _, ply in ipairs(player.GetAll()) do
		local char_id = ply:GetNWInt("st_charid", nil)

		if char_id then
			ply:SaveCharacterState(char_id)
		end
	end
end)
