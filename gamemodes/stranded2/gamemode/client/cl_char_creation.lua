-- Simple RPG Character Creation UI
local function OpenCharMenu()
    local totalPoints = 10
    local stats = {
        Attack = 0,
        Defense = 0,
        Speed = 0,
        Stamina = 0
    }

    -- List of available models
    local models = {
        "models/player/group01/male_07.mdl",
        "models/player/group01/female_02.mdl",
        "models/player/combine_soldier.mdl",
        "models/player/kleiner.mdl"
    }
    local selectedModel = models[1]

    -- Main Frame
    local frame = vgui.Create("DFrame")
    frame:SetSize(700, 800)
    frame:SetTitle("Character Creation")
    frame:Center()
    frame:MakePopup()

    -- --- NEW: Name Creation Field ---
    local nameLabel = vgui.Create("DLabel", frame)
    nameLabel:SetText("Character Name:")
    nameLabel:SetPos(100, 50)
    nameLabel:SetSize(200, 20)

    local nameEntry = vgui.Create("DTextEntry", frame)
    nameEntry:SetPos(100, 75)
    nameEntry:SetSize(200, 25)
    nameEntry:SetPlaceholderText("Enter name here...")
    -- -------------------------------

    -- Model Preview
    local icon = vgui.Create("DModelPanel", frame)
    icon:SetSize(350, 400)
    icon:SetPos(350, 30)
    icon:SetModel(selectedModel)

    -- Model Selection Dropdown
    local modelLabel = vgui.Create("DLabel", frame) -- Added label for clarity
    modelLabel:SetText("Select Appearance:")
    modelLabel:SetPos(100, 120)
    modelLabel:SetSize(200, 20)

    local modelSelector = vgui.Create("DComboBox", frame)
    modelSelector:SetPos(100, 140)
    modelSelector:SetSize(200, 25)
    modelSelector:SetValue("Select Model")
    for _, mdl in pairs(models) do modelSelector:AddChoice(mdl) end
    modelSelector.OnSelect = function(_, _, value)
        selectedModel = value
        icon:SetModel(value)
    end

    -- Points Remaining Label
    local pointsLabel = vgui.Create("DLabel", frame)
    pointsLabel:SetText("Points Remaining: " .. totalPoints)
    pointsLabel:SetPos(135, 220)
    pointsLabel:SetSize(150, 20)
    pointsLabel:SetTextColor(Color(0, 255, 0))

    -- Function to create stat rows
    local yPos = 250
    for statName, _ in pairs(stats) do
        local label = vgui.Create("DLabel", frame)
        label:SetText(statName .. ": " .. stats[statName])
        label:SetPos(100, yPos)
        label:SetSize(100, 20)

        local btn_minus = vgui.Create("DButton", frame)
        btn_minus:SetText("-")
        btn_minus:SetPos(220, yPos)
        btn_minus:SetSize(30, 30)
        btn_minus.DoClick = function()
            if stats[statName] > 0 then
                stats[statName] = stats[statName] - 1
                totalPoints = totalPoints + 1
                label:SetText(statName .. ": " .. stats[statName])
                pointsLabel:SetText("Points Remaining: " .. totalPoints)
            end
        end

        local btn = vgui.Create("DButton", frame)
        btn:SetText("+")
        btn:SetPos(260, yPos)
        btn:SetSize(30, 30)
        btn.DoClick = function()
            if totalPoints > 0 then
                stats[statName] = stats[statName] + 1
                totalPoints = totalPoints - 1
                label:SetText(statName .. ": " .. stats[statName])
                pointsLabel:SetText("Points Remaining: " .. totalPoints)
            end
        end

        yPos = yPos + 40
    end

    -- Finish Button
    local finish = vgui.Create("DButton", frame)
    finish:SetText("SPAWN CHARACTER")
    finish:SetPos(100, 500)
    finish:SetSize(200, 40)
    finish.DoClick = function()
        local charName = nameEntry:GetValue()

        -- Validation: Check if name is empty
        if string.Trim(charName) == "" then
            surface.PlaySound("buttons/button10.wav")
            print("You must enter a name!")
            return
        end

        -- Validation: Points spent
        if totalPoints > 0 then
            surface.PlaySound("buttons/button10.wav")
            print("Spend all your points first!")
            return
        end

        -- Networking to Server
        net.Start("st_create_character")
            net.WriteString(charName)      -- Sent Name
            net.WriteString(selectedModel) -- Sent Model
            net.WriteTable(stats)          -- Sent Stats
        net.SendToServer()
        
        print("Character Created: " .. charName)
        frame:Close()
    end
end

concommand.Add("create_char", OpenCharMenu)
