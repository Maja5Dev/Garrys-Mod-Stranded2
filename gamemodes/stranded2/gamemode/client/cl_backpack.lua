-- Configuration
local PADDING = 30

-- A 2D table to keep track of which slots are taken
local GridData = {}
for x = 0, BACKPACK_GRID_W - 1 do
    GridData[x] = {}
end

-- Helper function to occupy or clear grid spaces
local function SetGridSpace(GridData, startX, startY, itemW, itemH, state)
    if not GridData[startX] then return end
    
    for x = startX, startX + itemW - 1 do
        for y = startY, startY + itemH - 1 do
            GridData[x][y] = state
        end
    end
end

local backpack_frame = nil

local function OpenBackpack(items)
    -- Clear previous grid data if reopening
    for x = 0, BACKPACK_GRID_W - 1 do
        GridData[x] = {}
    end

    local frame = vgui.Create("DFrame")
    -- Calculate total size: slots * size + padding on both sides
    frame:SetSize((BACKPACK_GRID_W * BACKPACK_SLOT_SIZE) + (PADDING * 2) + 130, (BACKPACK_GRID_H * BACKPACK_SLOT_SIZE) + (PADDING * 2))
    frame:Center()
    frame:SetTitle("Backpack")
    frame:MakePopup()

    backpack_frame = frame

    -- Paint the background and grid
    frame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(40, 40, 40, 245))
        
        -- Draw the empty slots
        for x = 0, BACKPACK_GRID_W - 1 do
            for y = 0, BACKPACK_GRID_H - 1 do
                surface.SetDrawColor(20, 20, 20, 200)
                -- We subtract 2 from size to create a 1px border between slots
                surface.DrawRect(PADDING + (x * BACKPACK_SLOT_SIZE), PADDING + (y * BACKPACK_SLOT_SIZE), BACKPACK_SLOT_SIZE - 2, BACKPACK_SLOT_SIZE - 2)
            end
        end
    end

    frame.newItems = {}

    frame.OnClose = function(self)
        net.Start("st_backpack_save_positions")
            net.WriteTable(self.newItems)
        net.SendToServer()
    end

    local selectedItem = nil

    local action_panel = vgui.Create("DPanel", frame)
    action_panel:SetSize(130, 30)
    action_panel:SetPos(frame:GetWide() - action_panel:GetWide() - 10, frame:GetTall() - action_panel:GetTall() - 10)
    action_panel.Paint = function(self, w, h)
        if selectedItem then
            draw.RoundedBox(4, 0, 0, w, h, Color(70, 70, 70, 255))
        end
    end

    local createActions = function(item_id, item_name)
        -- Clear previous buttons
        for _, child in pairs(action_panel:GetChildren()) do
            child:Remove()
        end

        -- Find the item data based on item_id
        local itemData = nil

        for name, data in pairs(ST_ITEMS) do
            if name == item_name then
                itemData = data
                break
            end
        end

        if not itemData or not itemData.actions then return end

        local buttonY = 0
        for _, action in ipairs(itemData.actions) do
            local btn = vgui.Create("DButton", action_panel)
            btn:SetSize(action_panel:GetWide(), 30)
            btn:SetPos(0, buttonY)
            btn:SetText("")
            btn.DoClick = function()
                if action.func then
                    net.Start("st_pl_item_action")
                        net.WriteInt(item_id, 16)
                        net.WriteString(action.name)
                    net.SendToServer()
                end
            end
            btn.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, Color(70, 70, 70, 255))
                draw.SimpleText(action.name, "DermaDefault", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            buttonY = buttonY + 35 -- Move down for next button
        end
    end


    -- Function to spawn items into the grid
    local function CreateItem(slotsW, slotsH, startX, startY, color, name, item_id)
        -- Make sure it can spawn first
        if not CanPlaceItem(GridData, startX, startY, slotsW, slotsH) then
            print("Could not spawn " .. name .. " - no room!")
            return
        end

        local item = vgui.Create("DPanel", frame)
        item:SetSize((slotsW * BACKPACK_SLOT_SIZE) - 2, (slotsH * BACKPACK_SLOT_SIZE) - 2)
        item.GridX = startX
        item.GridY = startY
        item.SlotsW = slotsW
        item.SlotsH = slotsH

        -- Snap to initial position and register in grid
        item:SetPos(PADDING + (startX * BACKPACK_SLOT_SIZE), PADDING + (startY * BACKPACK_SLOT_SIZE))
        SetGridSpace(GridData, startX, startY, slotsW, slotsH, true)

        item.Paint = function(self, w, h)
            local clr = color
            if selectedItem == item_id then
                clr = Color(color.r + 20, color.g + 20, color.b + 20, 255)
            else
                clr = color
            end
            draw.RoundedBox(4, 0, 0, w, h, clr)
            draw.SimpleText(name, "DermaDefault", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        -- Custom Drag Logic
        item.OnMousePressed = function(self, mousecode)
            if mousecode == MOUSE_LEFT then
                selectedItem = item_id
                createActions(item_id, name)

                self:MouseCapture(true)
                self.Dragging = true
                self:MoveToFront()
                
                -- Save original position in case we drop it in an invalid spot
                self.StartX, self.StartY = self:GetPos()
                
                -- Calculate where on the panel we clicked so it doesn't snap to the top-left of the mouse
                local mx, my = gui.MousePos()
                self.HoldX, self.HoldY = self:ScreenToLocal(mx, my)

                -- Temporarily free up the grid space while dragging
                SetGridSpace(GridData, self.GridX, self.GridY, self.SlotsW, self.SlotsH, false)
            end
        end

        item.OnMouseReleased = function(self, mousecode)
            if self.Dragging then
                self:MouseCapture(false)
                self.Dragging = false
                
                -- Calculate nearest grid coordinates based on drop position
                local curX, curY = self:GetPos()
                local dropX = math.Round((curX - PADDING) / BACKPACK_SLOT_SIZE)
                local dropY = math.Round((curY - PADDING) / BACKPACK_SLOT_SIZE)
                
                -- Check if the drop is valid
                if CanPlaceItem(GridData, dropX, dropY, self.SlotsW, self.SlotsH) then
                    -- Valid Drop! Snap it to the new grid position
                    self.GridX = dropX
                    self.GridY = dropY
                    self:SetPos(PADDING + (dropX * BACKPACK_SLOT_SIZE), PADDING + (dropY * BACKPACK_SLOT_SIZE))
                    SetGridSpace(GridData, self.GridX, self.GridY, self.SlotsW, self.SlotsH, true)
                else
                    -- Invalid Drop! Snap it back to its original position
                    self:SetPos(self.StartX, self.StartY)
                    SetGridSpace(GridData, self.GridX, self.GridY, self.SlotsW, self.SlotsH, true)
                end

                -- Save the new position for server update
                frame.newItems[item_id] = {
                    id = item_id,
                    x = self.GridX,
                    y = self.GridY,
                }
            end
        end

        item.Think = function(self)
            if self.Dragging then
                local mx, my = gui.MousePos()
                local parentX, parentY = frame:ScreenToLocal(mx, my)
                -- Move panel with mouse, offset by where we initially clicked it
                self:SetPos(parentX - self.HoldX, parentY - self.HoldY)
            end
        end
    end

    for k,v in pairs(items) do
        CreateItem(v.w, v.h, v.x, v.y, v.color, v.name, v.id)
    end
end

net.Receive("st_backpack_open", function(len)
    local items = net.ReadTable()
    OpenBackpack(items)
end)

net.Receive("st_backpack_update", function(len)
    if IsValid(backpack_frame) then
        backpack_frame:Close()
    end

    local items = net.ReadTable()
    OpenBackpack(items)
end)

concommand.Add("open_backpack", function()
    net.Start("st_backpack_open")
    net.SendToServer()
end)
