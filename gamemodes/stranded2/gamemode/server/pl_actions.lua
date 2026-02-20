
util.AddNetworkString("st_pl_drink_water")
util.AddNetworkString("st_pl_forage")
util.AddNetworkString("st_pl_item_action")
util.AddNetworkString("st_backpack_update")

ST_ACTIONS = {
    ["drinking_water"] = function(ply)
        ply:AddThirst(5)
    end,

    ["foraging"] = function(ply)
        local foundItem = math.random(1, 100) <= 30 -- 30% chance to find something
        
        if foundItem then
            local forage_items = {}

            for k,v in pairs(ST_ITEMS) do
                if v.forageable then
                    table.insert(forage_items, k)
                end
            end

            local rnd_item = table.Random(forage_items)

            if rnd_item then
                ply:AddItem(rnd_item.name)
                ply:ChatPrint("You found a "..rnd_item.name.." while foraging!")
            end
        else
            ply:ChatPrint("You found nothing while foraging.")
        end
    end,
}

hook.Add("Tick", "ST_PlayerActions", function()
    for _, ply in ipairs(player.GetAll()) do
        if IsValid(ply) and ply:Alive() and ply.doingAction != nil then
            local actionName, endTime = unpack(ply.doingAction)

            if CurTime() >= endTime then
                local actionFunc = ST_ACTIONS[actionName]
                
                if actionFunc then
                    actionFunc(ply)
                end

                ply.doingAction = nil
            end
        end
    end
end)

net.Receive("st_pl_drink_water", function(len, ply)
    if not IsValid(ply) or not ply:Alive() then return end
    ply.doingAction = {"drinking_water", CurTime() + 2}
end)

net.Receive("st_pl_forage", function(len, ply)
    if not IsValid(ply) or not ply:Alive() then return end
    ply.doingAction = {"foraging", CurTime() + 3}
end)

net.Receive("st_pl_item_action", function(len, ply)
    local item_id = net.ReadInt(16)
    local action_name = net.ReadString()

    local itemName = nil
    for k,v in pairs(ply.backpack_items) do
        if v.id == item_id then
            itemName = v.name
            break
        end
    end

    if not itemName then
        print("Item with ID " .. item_id .. " not found in player's backpack.")
        return
    end

    for item_name, item_data in pairs(ST_ITEMS) do
        if itemName == item_name and item_data.actions and #item_data.actions > 0 then
            for _, action in ipairs(item_data.actions) do
                if action and action.name == action_name and isfunction(action.func) then
                    action.func(ply)
                    ply:ChatPrint("You used " .. item_name .. " and performed " .. action.name .. "!")

                    for k,v in pairs(ply.backpack_items) do
                        if v.id == item_id then
                            table.remove(ply.backpack_items, k)
                            break
                        end
                    end

                    net.Start("st_backpack_update")
                        net.WriteTable(ply.backpack_items)
                    net.Send(ply)

                    break
                end
            end
        end
    end
end)
