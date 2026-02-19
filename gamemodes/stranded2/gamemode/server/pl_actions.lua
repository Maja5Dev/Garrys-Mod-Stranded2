
util.AddNetworkString("st_pl_drink_water")
util.AddNetworkString("st_pl_forage")

net.Receive("st_pl_drink_water", function(len, ply)
    if not IsValid(ply) or not ply:Alive() then return end
    -- Implement water drinking logic here
    print(ply:Nick() .. " is trying to drink water.")

    ply:AddThirst(5)
end)

net.Receive("st_pl_forage", function(len, ply)
    if not IsValid(ply) or not ply:Alive() then return end
    -- Implement foraging logic here
    print(ply:Nick() .. " is trying to forage.")

    local foundItem = math.random(1, 100) <= 30 -- 30% chance to find something
    if foundItem then
        ply:AddItem("Berry")
        ply:ChatPrint("You found a Berry while foraging!")
    else
        ply:ChatPrint("You found nothing while foraging.")
    end
end)
