AddCSLuaFile("mapconfigs/"..game.GetMap().."/cl_init.lua")
AddCSLuaFile("mapconfigs/"..game.GetMap().."/shared.lua")
AddCSLuaFile("client/cl_char_chooser.lua")
AddCSLuaFile("client/cl_char_creation.lua")
AddCSLuaFile("client/cl_hud_stats.lua")
AddCSLuaFile("client/cl_hud.lua")
AddCSLuaFile("client/cl_targetid_actions.lua")
AddCSLuaFile("client/cl_backpack.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

include("mapconfigs/"..game.GetMap().."/shared.lua")
include("mapconfigs/"..game.GetMap().."/init.lua")

include("server/npc_spawning.lua")
include("server/saving.lua")
include("server/hunger_system.lua")
include("server/create_char.lua")
include("server/character.lua")
include("server/pl_ext.lua")
include("server/player.lua")
include("server/pl_actions.lua")
include("server/backpack.lua")

function GM:Initialize()
    if not file.Exists(ST2_DATA_FOLDER, "DATA") then
        file.CreateDir(ST2_DATA_FOLDER)
    end
end
