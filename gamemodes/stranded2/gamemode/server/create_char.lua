
util.AddNetworkString("st_create_character")

net.Receive("st_create_character", function(len, ply)
    local name = net.ReadString()
    local model = net.ReadString()
    local stats = net.ReadTable()

    if not stats or stats.Attack == nil or stats.Defense == nil or stats.Speed == nil or stats.Stamina == nil then
        print("Invalid stats received from " .. ply:Nick())
        return
    end

    if stats.Attack + stats.Defense + stats.Speed + stats.Stamina > 10 then
        ply:ChatPrint("Total stat points cannot exceed 10! Cannot create character")
        return
    end

    local char_id = 1

    for i=1, 5 do
        local char = loadCharData(ply, i)

        if char then
            char_id = i + 1
            break
        end

        if char_id > 5 then
            ply:ChatPrint("You have already created 5 characters! Cannot create more.")
            return
        end
    end

    local stats = {
        name = name,
		hp = 100,
		thirst = 100,
		hunger = 100,

		position = nil,
		eyeangs = nil,
		model = model,
		bodygroups = nil,

		level = 0,
        exp = 0,

		cloth = 0,
		wood = 0,
		stone = 0,
		copper = 0,
		iron = 0,

		stat_attack = stats.Attack,
		stat_defense = stats.Defense,
		stat_speed = stats.Speed,
		stat_stamina = stats.Stamina
    }

    -- Convert the table to JSON for easy reading/writing
    local jsonData = util.TableToJSON(stats)
    local fileName = ST2_DATA_FOLDER .. "/" .. ply:SteamID64() .. "_c" .. char_id .. ".txt"

    file.Write(fileName, jsonData)

	print("Character data saved for " .. ply:Nick() .. " (Slot " .. char_id .. ")")
	print(fileName)


    timer.Simple(1, function()
        if IsValid(ply) then
            ply:LoadCharacterState(char_id)
        end
    end)
end)
