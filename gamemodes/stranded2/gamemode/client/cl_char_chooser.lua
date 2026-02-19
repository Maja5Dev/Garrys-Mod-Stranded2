
function FetchCharactersForBrowser()
    net.Start("st_fetch_characters")
    net.SendToServer()
end
concommand.Add("char_menu", FetchCharactersForBrowser)

net.Receive("st_fetch_characters", function(len, ply)
    local characters = net.ReadTable()
    OpenCharBrowser(characters)
end)

function OpenCharBrowser(characters)
    -- Main Window
    local frame = vgui.Create("DFrame")
    frame:SetSize(600, 400)
    frame:SetTitle("Character Selection")
    frame:Center()
    frame:MakePopup()

    -- 1. The List View (The Table)
    local list = vgui.Create("DListView", frame)
    list:SetPos(10, 35)
    list:SetSize(380, 320)
    list:SetMultiSelect(false)
    list:AddColumn("Name")
    list:AddColumn("ATK")
    list:AddColumn("DEF")
    list:AddColumn("SPD")
    list:AddColumn("STM")

    -- Populate the list
    for _, char in ipairs(characters) do
        list:AddLine(char.name, char.stat_attack, char.stat_defense, char.stat_speed, char.stat_stamina)
    end

    local mdl = "models/player/group01/male_07.mdl" -- Default model if no characters exist
    if characters[1] and characters[1].model then
        mdl = characters[1].model
    end

    -- 2. The Model Preview (Right side)
    local modelPreview = vgui.Create("DModelPanel", frame)
    modelPreview:SetPos(400, 35)
    modelPreview:SetSize(190, 320)
    modelPreview:SetModel(mdl) -- Default preview

    -- Update preview when clicking a list item
    list.OnRowSelected = function(_, rowIndex, row)
        local selectedChar = characters[rowIndex]
        modelPreview:SetModel(selectedChar.model)
        
        -- Flash the model panel to show it updated
        modelPreview:SetColor(Color(200, 255, 200))
        timer.Simple(0.1, function() modelPreview:SetColor(color_white) end)
    end

    -- 3. Select Button
    local selectBtn = vgui.Create("DButton", frame)
    selectBtn:SetText("CONFIRM SELECTION")
    selectBtn:SetPos(10, 360)
    selectBtn:SetSize(580, 30)
    selectBtn:SetFont("DermaDefaultBold")
    
    selectBtn.DoClick = function()
        local selectedLine = list:GetSelectedLine()
        if not selectedLine then 
            surface.PlaySound("buttons/button10.wav")
            return 
        end

        local charData = characters[selectedLine]

        net.Start("st_select_character")
            net.WriteString(charData.name)
        net.SendToServer()

        frame:Close()
    end
end
