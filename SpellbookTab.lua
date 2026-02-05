local Config = EasyPort_Config
local Helpers = EasyPort_Helpers

local SpellbookTab = {}
local tabButton
local contentFrame
local scrollFrame
local teleportButtons = {}

local function GetAvailableTeleportsByCategory()
    local categories = {}
    
    for _, data in ipairs(EasyPort_DungeonData) do
        local isAvailable = false
        
        if data.itemID then
            isAvailable = PlayerHasToy(data.itemID) or C_Item.GetItemCount(data.itemID) > 0
        elseif data.spellID then
            isAvailable = IsSpellKnown(data.spellID) or IsPlayerSpell(data.spellID)
        end
        
        if isAvailable then
            local cat = data.category or "Other"
            if not categories[cat] then
                categories[cat] = {}
            end
            table.insert(categories[cat], data)
        end
    end
    
    return categories
end

local function CreateTeleportButton(parent, data, column, yPos)
    local button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate")
    button:SetSize(190, 40)
    
    local xOffset = (column == 1) and 8 or 203
    button:SetPoint("TOPLEFT", xOffset, yPos)
    button:RegisterForClicks("AnyUp")
    
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.08, 0.08, 0.08, 0.9)
    button.bg = bg
    
    local border = button:CreateTexture(nil, "BORDER")
    border:SetPoint("TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", 1, -1)
    border:SetColorTexture(0.25, 0.25, 0.25, 1)
    button.border = border
    
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(32, 32)
    icon:SetPoint("LEFT", 4, 0)
    
    if data.itemID then
        local iconTexture = C_Item.GetItemIconByID(data.itemID)
        if iconTexture then icon:SetTexture(iconTexture) end
        -- Toys are used via their spell, not as items
        if PlayerHasToy(data.itemID) and data.spellName then
            button:SetAttribute("type", "spell")
            button:SetAttribute("spell", data.spellName)
        else
            -- Regular items use item macro
            -- For mounts, check if already mounted and add dismount logic
            local isMountItem = data.keywords and (tContains(data.keywords, "mount") or 
                                                    tContains(data.keywords, "mammoth") or 
                                                    tContains(data.keywords, "yak") or 
                                                    tContains(data.keywords, "brutosaur"))
            
            if isMountItem then
                -- If mounted, dismount first, then use the mount
                local macroText = "/dismount [mounted]\n/use item:" .. data.itemID
                button:SetAttribute("type", "macro")
                button:SetAttribute("macrotext", macroText)
            else
                button:SetAttribute("type", "macro")
                button:SetAttribute("macrotext", "/use item:" .. data.itemID)
            end
        end
    elseif data.spellID then
        local iconTexture = C_Spell.GetSpellTexture(data.spellID)
        if iconTexture then icon:SetTexture(iconTexture) end
        button:SetAttribute("type", "spell")
        button:SetAttribute("spell", data.spellName)
    end
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    button.icon = icon
    
    local iconBorder = button:CreateTexture(nil, "OVERLAY")
    iconBorder:SetPoint("TOPLEFT", icon, -1, 1)
    iconBorder:SetPoint("BOTTOMRIGHT", icon, 1, -1)
    iconBorder:SetColorTexture(0, 0, 0, 0.5)
    
    local name = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    name:SetPoint("LEFT", icon, "RIGHT", 8, 4)
    name:SetPoint("RIGHT", -6, 0)
    name:SetJustifyH("LEFT")
    name:SetText(data.name)
    button.nameText = name
    
    local cooldownText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalTiny")
    cooldownText:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -2)
    cooldownText:SetPoint("RIGHT", -6, 0)
    cooldownText:SetJustifyH("LEFT")
    cooldownText:SetTextColor(0.6, 0.6, 0.6)
    if data.destination then
        cooldownText:SetText(data.destination)
    elseif data.cooldown then
        cooldownText:SetText("CD: " .. data.cooldown)
    end
    button.cooldownText = cooldownText
    
    local cooldown = Helpers.GetCooldownRemaining(data)
    if cooldown > 0 then
        icon:SetDesaturated(true)
        name:SetTextColor(0.5, 0.5, 0.5)
        bg:SetColorTexture(0.05, 0.05, 0.05, 0.7)
    else
        icon:SetDesaturated(false)
        name:SetTextColor(1, 1, 1)
    end
    
    button:SetScript("OnEnter", function(self)
        self.bg:SetColorTexture(0.15, 0.18, 0.25, 1)
        self.border:SetColorTexture(0.4, 0.6, 1, 1)
        
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(data.name, 1, 0.82, 0)
        
        if data.destination then
            GameTooltip:AddLine(data.destination, 0.8, 0.8, 0.8, true)
        end
        
        local cd = Helpers.GetCooldownRemaining(data)
        if cd > 0 then
            GameTooltip:AddLine(" ", 1, 1, 1)
            GameTooltip:AddLine("Ready in " .. Helpers.FormatCooldownTime(cd), 1, 0.3, 0.3)
        elseif data.cooldown then
            GameTooltip:AddLine(" ", 1, 1, 1)
            GameTooltip:AddLine("Cooldown: " .. data.cooldown, 0.5, 0.5, 0.5)
        end
        
        GameTooltip:AddLine(" ", 1, 1, 1)
        GameTooltip:AddLine("Click to teleport", 0.3, 1, 0.3)
        GameTooltip:Show()
    end)
    
    button:SetScript("OnLeave", function(self)
        local cd = Helpers.GetCooldownRemaining(self.data)
        if cd > 0 then
            self.bg:SetColorTexture(0.05, 0.05, 0.05, 0.7)
        else
            self.bg:SetColorTexture(0.08, 0.08, 0.08, 0.9)
        end
        self.border:SetColorTexture(0.25, 0.25, 0.25, 1)
        GameTooltip:Hide()
    end)
    
    button.data = data
    return button
end

local function UpdateTeleportList()
    for _, btn in ipairs(teleportButtons) do
        btn:Hide()
    end
    wipe(teleportButtons)
    
    local categories = GetAvailableTeleportsByCategory()
    local yOffset = 0
    
    local categoryOrder = {"M+ Dungeon", "Raid", "Delve", "Home", "Mage", "Druid", "Shaman", "Death Knight", "Monk", "Demon Hunter", "Warlock", "Toy"}
    
    for _, categoryName in ipairs(categoryOrder) do
        local teleports = categories[categoryName]
        if teleports and #teleports > 0 then
            local header = scrollFrame.content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            header:SetPoint("TOPLEFT", 8, -yOffset - 8)
            header:SetText(categoryName)
            header:SetTextColor(1, 0.82, 0)
            header:SetJustifyH("LEFT")
            table.insert(teleportButtons, header)
            
            local divider = scrollFrame.content:CreateTexture(nil, "ARTWORK")
            divider:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -4)
            divider:SetPoint("RIGHT", scrollFrame.content, "RIGHT", -8, 0)
            divider:SetHeight(1)
            divider:SetColorTexture(0.4, 0.4, 0.4, 0.5)
            table.insert(teleportButtons, divider)
            
            yOffset = yOffset + 32
            
            local currentRow = yOffset
            for i, data in ipairs(teleports) do
                local column = ((i - 1) % 2) + 1
                local btn = CreateTeleportButton(scrollFrame.content, data, column, -currentRow - 8)
                
                table.insert(teleportButtons, btn)
                
                if i % 2 == 0 or i == #teleports then
                    currentRow = currentRow + 44
                end
            end
            
            yOffset = currentRow + 8
        end
    end
    
    for categoryName, teleports in pairs(categories) do
        local found = false
        for _, cat in ipairs(categoryOrder) do
            if cat == categoryName then found = true; break end
        end
        
        if not found and #teleports > 0 then
            local header = scrollFrame.content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            header:SetPoint("TOPLEFT", 8, -yOffset - 8)
            header:SetText(categoryName)
            header:SetTextColor(1, 0.82, 0)
            header:SetJustifyH("LEFT")
            table.insert(teleportButtons, header)
            
            local divider = scrollFrame.content:CreateTexture(nil, "ARTWORK")
            divider:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -4)
            divider:SetPoint("RIGHT", scrollFrame.content, "RIGHT", -8, 0)
            divider:SetHeight(1)
            divider:SetColorTexture(0.4, 0.4, 0.4, 0.5)
            table.insert(teleportButtons, divider)
            
            yOffset = yOffset + 32
            
            local currentRow = yOffset
            for i, data in ipairs(teleports) do
                local column = ((i - 1) % 2) + 1
                local btn = CreateTeleportButton(scrollFrame.content, data, column, -currentRow - 8)
                
                table.insert(teleportButtons, btn)
                
                if i % 2 == 0 or i == #teleports then
                    currentRow = currentRow + 44
                end
            end
            
            yOffset = currentRow + 8
        end
    end
    
    scrollFrame.content:SetHeight(math.max(yOffset + 20, 400))
end

local function CreateContentFrame()
    if contentFrame then return end
    
    contentFrame = CreateFrame("Frame", "EasyPortSpellbookFrame", UIParent, "BasicFrameTemplateWithInset")
    contentFrame:SetSize(415, 540)
    contentFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    contentFrame:SetMovable(true)
    contentFrame:EnableMouse(true)
    contentFrame:RegisterForDrag("LeftButton")
    contentFrame:SetScript("OnDragStart", contentFrame.StartMoving)
    contentFrame:SetScript("OnDragStop", contentFrame.StopMovingOrSizing)
    contentFrame:SetClampedToScreen(true)
    contentFrame:Hide()
    
    scrollFrame = CreateFrame("ScrollFrame", nil, contentFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 10, -28)
    scrollFrame:SetPoint("BOTTOMRIGHT", -28, 10)
    
    scrollFrame.content = CreateFrame("Frame", nil, scrollFrame)
    scrollFrame.content:SetSize(385, 400)
    scrollFrame:SetScrollChild(scrollFrame.content)
    
    contentFrame.TitleText:SetText("Teleportation Compendium")
    contentFrame.TitleText:SetTextColor(1, 0.82, 0)
    
    contentFrame.CloseButton:HookScript("OnClick", function() contentFrame:Hide() end)
    
    UpdateTeleportList()
    C_Timer.NewTicker(2, UpdateTeleportList)
end

local function ToggleEasyPortTab()
    if not contentFrame then 
        CreateContentFrame()
        contentFrame:Show()
        UpdateTeleportList()
    elseif contentFrame:IsShown() then
        contentFrame:Hide()
    else
        contentFrame:Show()
        UpdateTeleportList()
    end
end

function SpellbookTab.Initialize()
    if tabButton then return end
    
    tabButton = CreateFrame("Button", "EasyPortMinimapButton", Minimap)
    tabButton:SetSize(32, 32)
    tabButton:SetFrameStrata("MEDIUM")
    tabButton:SetFrameLevel(8)
    tabButton:RegisterForClicks("AnyUp")
    tabButton:RegisterForDrag("LeftButton")
    tabButton:SetMovable(true)
    
    local angle = 210
    local x = math.cos(angle) * 80
    local y = math.sin(angle) * 80
    tabButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
    
    local bg = tabButton:CreateTexture(nil, "BACKGROUND")
    bg:SetSize(20, 20)
    bg:SetPoint("CENTER")
    bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    
    local border = tabButton:CreateTexture(nil, "OVERLAY")
    border:SetSize(52, 52)
    border:SetPoint("TOPLEFT")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    
    local icon = tabButton:CreateTexture(nil, "ARTWORK")
    icon:SetSize(20, 20)
    icon:SetPoint("CENTER")
    icon:SetTexture("Interface\\Icons\\Spell_Arcane_TeleportDalaran")
    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    
    tabButton:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            ToggleEasyPortTab()
        end
    end)
    
    tabButton:SetScript("OnDragStart", function(self)
        self:LockHighlight()
        self:SetScript("OnUpdate", function(self)
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            px, py = px / scale, py / scale
            
            local angle = math.atan2(py - my, px - mx)
            local x = math.cos(angle) * 80
            local y = math.sin(angle) * 80
            
            self:ClearAllPoints()
            self:SetPoint("CENTER", Minimap, "CENTER", x, y)
        end)
    end)
    
    tabButton:SetScript("OnDragStop", function(self)
        self:UnlockHighlight()
        self:SetScript("OnUpdate", nil)
    end)
    
    tabButton:SetScript("OnEnter", function(self)
        self:LockHighlight()
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("EasyPort", 1, 1, 1)
        GameTooltip:AddLine("Click to view all teleports", 0.7, 0.7, 0.7)
        GameTooltip:AddLine("Drag to move", 0.5, 0.5, 0.5)
        GameTooltip:Show()
    end)
    
    tabButton:SetScript("OnLeave", function(self)
        self:UnlockHighlight()
        GameTooltip:Hide()
    end)
    
    tabButton:Show()
end

function SpellbookTab.Toggle()
    ToggleEasyPortTab()
end

_G.EasyPort_SpellbookTab = SpellbookTab
