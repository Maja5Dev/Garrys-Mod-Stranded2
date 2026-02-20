include("shared.lua")

include("mapconfigs/"..game.GetMap().."/cl_init.lua")
include("mapconfigs/"..game.GetMap().."/shared.lua")
include("client/cl_char_chooser.lua")
include("client/cl_char_creation.lua")
include("client/cl_hud_stats.lua")
include("client/cl_hud.lua")
include("client/cl_targetid_actions.lua")
include("shared/items.lua")
include("client/cl_backpack.lua")

local halo_color = Color(125, 125, 125)

hook.Add("PreDrawHalos", "AddPropHalos", function()
    if LocalPlayer():GetObserverMode() ~= OBS_MODE_NONE then return end

    local haloents = {}

    for k,v in pairs(ents.FindByClass("st_*")) do
        if v:GetPos():Distance(LocalPlayer():GetPos()) < 200 then
            table.ForceInsert(haloents, v)
        end
    end

	halo.Add(haloents, halo_color, 5, 5, 2)
end)
