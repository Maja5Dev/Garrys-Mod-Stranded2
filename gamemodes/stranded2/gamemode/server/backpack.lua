
util.AddNetworkString("st_backpack_open")
util.AddNetworkString("st_backpack_save_positions")

net.Receive("st_backpack_open", function(len, ply)
    net.Start("st_backpack_open")
        net.WriteTable(ply.backpack_items or {})
    net.Send(ply)
end)

net.Receive("st_backpack_save_positions", function(len, ply)
    local items = net.ReadTable()

    for k,v in pairs(ply.backpack_items) do
        for _, v2 in pairs(items) do
            if v2.id == v.id then
                v.x = v2.x
                v.y = v2.y
            end
        end
    end
end)

local ST_ITEMS = {
    ["Berry"] = {w = 1, h = 1, color = Color(200, 50, 150, 200)},
}

if NEXT_ITEM_ID == nil then
    NEXT_ITEM_ID = 1
end

local player_meta = FindMetaTable("Player")

local function findEmptySlot(GridData, itemW, itemH)
    -- We only loop up to (GRID - item size) so we don't bother checking
    -- spots where the item would obviously hang off the edge of the backpack.
    for y = 0, BACKPACK_GRID_H - itemH do
        for x = 0, BACKPACK_GRID_W - itemW do
            
            -- Use our existing helper to check if this specific block of slots is free
            if CanPlaceItem(GridData, x, y, itemW, itemH) then
                return x, y -- We found a spot! Return the coordinates.
            end

        end
    end
    
    -- If the loop finishes and finds nothing, return nil
    return nil, nil
end

local function createGridData(items)
    local grid = {}
    for x = 0, BACKPACK_GRID_W - 1 do
        grid[x] = {}
    end

    for _, item in pairs(items) do
        for x = item.x, item.x + item.w - 1 do
            for y = item.y, item.y + item.h - 1 do
                grid[x][y] = true
            end
        end
    end

    return grid
end

function player_meta:AddItem(name)
    local itemData = ST_ITEMS[name]
    if not itemData then return end

    local startX, startY = findEmptySlot(createGridData(self.backpack_items), itemData.w, itemData.h)
    if not startX then
        self:ChatPrint("No space in backpack for " .. name .. "!")
        return false
    end

    local newItem = {
        name = name,
        id = NEXT_ITEM_ID,
        w = itemData.w,
        h = itemData.h,
        color = itemData.color,
        x = startX,
        y = startY,
    }

    self.backpack_items = self.backpack_items or {}
    table.insert(self.backpack_items, newItem)

    NEXT_ITEM_ID = NEXT_ITEM_ID + 1
end

function player_meta:RemoveItem(name)
    if not self.backpack_items then return end

    for i, item in ipairs(self.backpack_items) do
        if item.name == name then
            table.remove(self.backpack_items, i)
            break
        end
    end
end
