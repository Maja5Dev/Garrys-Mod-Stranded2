GM.Name = "Stranded 2"
GM.Author = "Maya"
GM.Email = "N/A"
GM.Website = "N/A"

DeriveGamemode("sandbox")

function GM:CreateTeams()
    team.SetUp(1, "Characters", Color(255, 0, 0))
end

BACKPACK_SLOT_SIZE = 40
BACKPACK_GRID_W = 10
BACKPACK_GRID_H = 10

DEF_WALK_SPEED = 180
DEF_RUN_SPEED = 240
DEF_JUMP_POWER = 180

function CanPlaceItem(GridData, startX, startY, itemW, itemH)
    -- Check if it's out of bounds
    if startX < 0 or startY < 0 or (startX + itemW) > BACKPACK_GRID_W or (startY + itemH) > BACKPACK_GRID_H then
        return false
    end
    -- Check for overlapping items
    for x = startX, startX + itemW - 1 do
        for y = startY, startY + itemH - 1 do
            if GridData[x] and GridData[x][y] then
                return false
            end
        end
    end
    return true
end
