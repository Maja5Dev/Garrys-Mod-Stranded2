ST_ITEMS = {
    ["Blueberry"] = {
        name = "Blueberry",
        forageable = true,
        w = 1,
        h = 1,
        color = Color(50, 80, 200, 200),
        actions = {
            {
                name = "Eat",
                func = function(ply)
                    -- Focuses more on hydration than food
                    ply:AddHunger(2)
                    ply:AddThirst(6)
                end
            }
        },
    },

    ["Glowberry"] = {
        name = "Glowberry",
        forageable = true,
        w = 1,
        h = 1,
        color = Color(0, 255, 150, 200),
        actions = {
            {
                name = "Eat",
                func = function(ply)
                    -- Provides a small health boost and maybe a speed buff?
                    ply:AddHealth(10)
                    -- If your server has a RunSpeed function:
                    -- ply:SetRunSpeed(ply:GetRunSpeed() + 10) 
                end
            }
        },
    },

    ["Bitterberry"] = {
        name = "Bitterberry",
        forageable = true,
        w = 1,
        h = 1,
        color = Color(100, 0, 0, 200),
        actions = {
            {
                name = "Eat",
                func = function(ply)
                    -- High hunger restoration, but hurts the player
                    ply:AddHunger(10)
                    ply:AddHealth(-5)
                end
            }
        },
    },

    ["Elderberry"] = {
        name = "Elderberry",
        forageable = true,
        w = 1,
        h = 1,
        color = Color(80, 20, 100, 200),
        actions = {
            {
                name = "Eat",
                func = function(ply)
                    -- The "Superfood" - rare and balanced
                    ply:AddHunger(7)
                    ply:AddThirst(7)
                    ply:AddHealth(4)
                end
            }
        },
    },

    ["Wild Mushroom"] = {
        name = "Wild Mushroom",
        forageable = true,
        w = 1,
        h = 1,
        color = Color(150, 100, 50, 200),
        actions = {
            {
                name = "Eat",
                func = function(ply)
                    ply:AddHunger(8)

                    local rnd = math.random()
                    if rnd < 0.5 then
                        ply:AddHealth(1)
                    else
                        ply:AddHealth(-5)
                    end
                end
            }
        },
    },

    ["Medicinal Herb"] = {
        name = "Medicinal Herb",
        forageable = true,
        w = 1,
        h = 1,
        color = Color(50, 200, 50, 200),
        actions = {
            {
                name = "Apply to Wounds",
                func = function(ply)
                    ply:AddHealth(10)
                end
            }
        },
    },

    ["Dry Sticks"] = {
        name = "Dry Sticks",
        forageable = true,
        w = 1,
        h = 2, -- Taking up more vertical space
        color = Color(100, 80, 40, 200),
        actions = {
            {
                name = "Snap",
                func = function(ply)
                    -- Maybe used for crafting later? For now, just a sound effect
                    ply:EmitSound("physics/wood/wood_plank_break1.wav")
                end
            }
        },
    },
}