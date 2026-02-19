
util.AddNetworkString("st_fetch_characters")
util.AddNetworkString("st_select_character")

net.Receive("st_fetch_characters", function(len, ply)
    local chars = {}

    for i=1, 5 do
        local data = loadCharData(ply, i)

        if data then
            chars[i] = data
        end
    end

    net.Start("st_fetch_characters")
        net.WriteTable(chars)
    net.Send(ply)
end)

net.Receive("st_select_character", function(len, ply)
    local char_name = net.ReadString()

    for i=1, 5 do
        local data = loadCharData(ply, i)

        if data and data.name == char_name then
            ply:LoadCharacterState(i)
        end
    end
end)
