
surface.CreateFont("ST_Hud_Stats", {
	font = "Arial",
	extended = false,
	size = 17,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

local resources = {
    {key = "st_cloth",  label = "Cloth: "},
    {key = "st_wood",   label = "Wood: "},
    {key = "st_stone",  label = "Stone: "},
    {key = "st_copper", label = "Copper: "},
    {key = "st_iron",   label = "Iron: "}
}

hook.Add("HUDPaint", "ResourceDisplayHUD", function()
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:Alive() then return end
    if ply:Team() != 1 then return end
    
    -- In a real scenario, char_id would be defined by your character system
    -- We'll assume char_id is 1 for this example or needs to be fetched
    --local char_id = ply:GetNWInt("CurrentCharacterID", 1) 

    local x, y = 20, 20 -- Starting position (Top Left)
    local padding = 25   -- Space between lines

    draw.RoundedBox(8, x - 10, y - 10, 150, ((3 + #resources) * padding) + 15, Color(0, 0, 0, 150))

    local level = ply:GetNWInt("st_level", 0)
    local exp = ply:GetNWInt("st_exp", 0)
    local exp_needed = math.floor(400 * (1.07 ^ level))

    -- level
    draw.SimpleText("Level: " .. level, "ST_Hud_Stats", x, y, Color(255, 255, 255, 255))
    -- exp
    draw.SimpleText("EXP: " .. exp .. "/" .. exp_needed, "ST_Hud_Stats", x, y + padding, Color(255, 255, 255, 255))

    y = y + (3 * padding) -- Move down for resources

    for i, res in ipairs(resources) do
        -- Fetching PData. Note: PData returns strings, so we default to "0"
       --local val = ply:GetPData(res.key .. char_id) or "0"
        local val = ply:GetNWInt(res.key) or "0"
        
        draw.SimpleText(res.label .. val, "ST_Hud_Stats", x, y + ((i - 1) * padding), Color(255, 255, 255, 255))
    end
end)
