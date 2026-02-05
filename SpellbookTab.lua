local Config = EasyPort_Config
local Helpers = EasyPort_Helpers

local SpellbookTab = {}
local mainFrame
local categoryButtons = {}
local utilityButtons = {}
local currentFilter = "All"
local searchText = ""
local minimapButton

-- ============================================================================
-- DATA HELPERS
-- ============================================================================

local function GetAllUtilities()
    local utilities = {}
    
    for _, data in ipairs(EasyPort_DungeonData) do
        local isAvailable = false
        
        if data.itemID then
            isAvailable = PlayerHasToy(data.itemID) or C_Item.GetItemCount(data.itemID) > 0
        elseif data.spellID then
            isAvailable = IsSpellKnown(data.spellID) or IsPlayerSpell(data.spellID)
        end
        
        if isAvailable then
            table.insert(utilities, data)
        end
    end
    
    return utilities
end

local function FilterUtilities(utilities, category, search)
    local filtered = {}
    
    for _, data in ipairs(utilities) do
        local matchesCategory = (category == "All") or (data.category == category)
        local matchesSearch = true
        
        if search and search ~= "" then
            local searchLower = string.lower(search)
            local nameLower = string.lower(data.name or "")
            local destLower = string.lower(data.destination or "")
            matchesSearch = string.find(nameLower, searchLower) or string.find(destLower, searchLower)
        end
        
        if matchesCategory and matchesSearch then
            table.insert(filtered, data)
        end
    end
    
    return filtered
end

local function GetCategories(utilities)
    local categorySet = {}
    for _, data in ipairs(utilities) do
        if data.category then
            categorySet[data.category] = true
        end
    end
    
    local categories = {"All"}
    local categoryOrder = {
        "M+ Dungeon", "Raid", "Delve", "Home", 
        "Mage", "Druid", "Shaman", "Death Knight", "Monk", "Demon Hunter",
        "Mage Utility", "Warlock Utility", "Priest Utility", "Druid Utility", "Evoker Utility",
        "Utility", "Toy"
    }
    
    for _, cat in ipairs(categoryOrder) do
        if categorySet[cat] then
            table.insert(categories, cat)
        end
    end
    
    -- Add any remaining categories
    for cat in pairs(categorySet) do
        local found = false
        for _, orderedCat in ipairs(categoryOrder) do
            if orderedCat == cat then found = true; break end
        end
        if not found then
            table.insert(categories, cat)
        end
    end
    
    return categories
end

-- ============================================================================
-- BUTTON CREATION (Reusing Banner Logic)
-- ============================================================================

local function SetupButtonAction(button, data)
    -- DISABLED: Spellbook is read-only for debugging
    -- Use the actionType defined in the data to determine how to use this utility
    local actionType = data.actionType or "spell" -- default to spell if not specified
    
    if actionType == "spell" then
        -- Spells (teleports, hearthstones, class abilities)
        local iconTexture = C_Spell.GetSpellTexture(data.spellID)
        if iconTexture then 
            button.icon:SetTexture(iconTexture) 
        end
        -- DISABLED for debugging
        -- button:SetAttribute("type", "spell")
        -- button:SetAttribute("spell", data.spellID)
    elseif actionType == "toy" then
        -- Toys (Jeeves, Blingtron, hearthstone toys, etc)
        local iconTexture = C_Item.GetItemIconByID(data.itemID)
        if iconTexture then 
            button.icon:SetTexture(iconTexture) 
        end
        -- DISABLED for debugging
        -- button:SetAttribute("type", "toy")
        -- button:SetAttribute("toy", data.itemID)
    elseif actionType == "item" then
        -- Items (mounts, consumables, etc)
        local iconTexture = C_Item.GetItemIconByID(data.itemID)
        if iconTexture then 
            button.icon:SetTexture(iconTexture) 
        end
        -- DISABLED for debugging
        -- button:SetAttribute("type", "item")
        -- button:SetAttribute("item", "item:" .. data.itemID)
    end
end

local function UpdateButtonDisplay(button, data)
    local cooldown = Helpers.GetCooldownRemaining(data)
    
    if cooldown > 0 then
        -- On cooldown
        button.icon:SetDesaturated(true)
        button.name:SetTextColor(0.5, 0.5, 0.5)
        button.info:SetTextColor(1, 0.3, 0.3)
        button.info:SetText(Helpers.FormatCooldownTime(cooldown))
        button.bg:SetColorTexture(0.05, 0.05, 0.05, 0.8)
    else
        -- Ready to use
        button.icon:SetDesaturated(false)
        button.name:SetTextColor(1, 1, 1)
        button.bg:SetColorTexture(0.08, 0.08, 0.08, 0.9)
        
        if data.destination then
            button.info:SetTextColor(0.7, 0.7, 0.7)
            button.info:SetText(data.destination)
        elseif data.cooldown then
            button.info:SetTextColor(0.6, 0.6, 0.6)
            button.info:SetText("CD: " .. data.cooldown)
        else
            button.info:SetText("")
        end
    end
end

local function CreateUtilityButton(parent, data, index)
    local button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate")
    button:SetSize(280, 48)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    
    -- Background
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.08, 0.08, 0.08, 0.9)
    button.bg = bg
    
    -- Border
    local border = button:CreateTexture(nil, "BORDER")
    border:SetPoint("TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", 1, -1)
    border:SetColorTexture(0.3, 0.3, 0.3, 1)
    button.border = border
    
    -- Icon
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(38, 38)
    icon:SetPoint("LEFT", 5, 0)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    button.icon = icon
    
    -- Icon border
    local iconBorder = button:CreateTexture(nil, "OVERLAY")
    iconBorder:SetPoint("TOPLEFT", icon, -1, 1)
    iconBorder:SetPoint("BOTTOMRIGHT", icon, 1, -1)
    iconBorder:SetColorTexture(0, 0, 0, 0.6)
    
    -- Name text
    local name = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    name:SetPoint("TOPLEFT", icon, "TOPRIGHT", 8, -2)
    name:SetPoint("RIGHT", -8, 0)
    name:SetJustifyH("LEFT")
    name:SetText(data.name)
    button.name = name
    
    -- Info text (cooldown or destination)
    local info = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    info:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -4)
    info:SetPoint("RIGHT", -8, 0)
    info:SetJustifyH("LEFT")
    button.info = info
    
    -- Category badge
    local category = button:CreateFontString(nil, "OVERLAY", "GameFontNormalTiny")
    category:SetPoint("BOTTOMRIGHT", -4, 4)
    category:SetTextColor(0.5, 0.5, 0.5)
    category:SetText(data.category or "")
    
    -- Setup action
    SetupButtonAction(button, data)
    button.data = data
    
    -- Initial display update
    UpdateButtonDisplay(button, data)
    
    -- Hover effects
    button:SetScript("OnEnter", function(self)
        self.bg:SetColorTexture(0.15, 0.18, 0.25, 1)
        self.border:SetColorTexture(0.5, 0.7, 1, 1)
        
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(data.name, 1, 0.82, 0, 1, true)
        
        if data.destination then
            GameTooltip:AddLine(data.destination, 0.9, 0.9, 0.9, true)
        end
        
        if data.category then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Category: " .. data.category, 0.5, 0.8, 1)
        end
        
        local cd = Helpers.GetCooldownRemaining(data)
        if cd > 0 then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Ready in " .. Helpers.FormatCooldownTime(cd), 1, 0.3, 0.3)
        elseif data.cooldown then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Cooldown: " .. data.cooldown, 0.6, 0.6, 0.6)
        end
        
        GameTooltip:AddLine(" ")
        
        -- Context-aware action text
        local actionText = "Click to use"
        if data.category == "M+ Dungeon" or data.category == "Raid" or data.category == "Delve" or 
           data.category == "Home" or data.category == "Mage" or data.category == "Druid" or 
           data.category == "Shaman" or data.category == "Death Knight" or data.category == "Monk" or 
           data.category == "Demon Hunter" or data.category == "Toy" then
            actionText = "Click to teleport"
        elseif data.category and data.category:find("Utility") then
            if data.destination and (data.destination:find("Repair") or data.destination:find("Mailbox") or 
               data.destination:find("Transmog") or data.destination:find("Anvil")) then
                actionText = "Click to summon"
            elseif data.keywords and (tContains(data.keywords, "buff") or tContains(data.keywords, "fort") or 
                    tContains(data.keywords, "motw") or tContains(data.keywords, "intellect")) then
                actionText = "Click to cast"
            else
                actionText = "Click to use"
            end
        end
        
        GameTooltip:AddLine(actionText, 0.3, 1, 0.3)
        GameTooltip:AddLine("Right-click to announce", 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    
    button:SetScript("OnLeave", function(self)
        local cd = Helpers.GetCooldownRemaining(data)
        if cd > 0 then
            self.bg:SetColorTexture(0.05, 0.05, 0.05, 0.8)
        else
            self.bg:SetColorTexture(0.08, 0.08, 0.08, 0.9)
        end
        self.border:SetColorTexture(0.3, 0.3, 0.3, 1)
        GameTooltip:Hide()
    end)
    
    -- Handle right-click announcements
    button:SetScript("PostClick", function(self, mouseButton)
        if mouseButton == "RightButton" then
            Helpers.AnnounceUtility(data)
        end
    end)
    
    return button
end

-- ============================================================================
-- DISPLAY UPDATE
-- ============================================================================

local function UpdateUtilityDisplay()
    -- Hide all existing buttons
    for _, btn in ipairs(utilityButtons) do
        btn:Hide()
    end
    wipe(utilityButtons)
    
    -- Get and filter utilities
    local allUtilities = GetAllUtilities()
    local filteredUtilities = FilterUtilities(allUtilities, currentFilter, searchText)
    
    -- Sort by category, then name
    table.sort(filteredUtilities, function(a, b)
        if a.category ~= b.category then
            return (a.category or "") < (b.category or "")
        end
        return (a.name or "") < (b.name or "")
    end)
    
    -- Create buttons in 2-column layout
    local scrollChild = mainFrame.scrollFrame.content
    local yOffset = 10
    local column1X = 10
    local column2X = 300
    local buttonHeight = 48
    local spacing = 6
    
    for i, data in ipairs(filteredUtilities) do
        local button = CreateUtilityButton(scrollChild, data, i)
        
        local column = ((i - 1) % 2)
        local row = math.floor((i - 1) / 2)
        
        if column == 0 then
            button:SetPoint("TOPLEFT", column1X, -yOffset - (row * (buttonHeight + spacing)))
        else
            button:SetPoint("TOPLEFT", column2X, -yOffset - (row * (buttonHeight + spacing)))
        end
        
        button:Show()
        table.insert(utilityButtons, button)
    end
    
    -- Update scroll height
    local totalRows = math.ceil(#filteredUtilities / 2)
    local contentHeight = yOffset + (totalRows * (buttonHeight + spacing)) + 20
    scrollChild:SetHeight(math.max(contentHeight, 500))
    
    -- Update count display
    if mainFrame.countText then
        mainFrame.countText:SetText(string.format("Showing %d utilities", #filteredUtilities))
    end
end

local function UpdateCooldowns()
    for _, button in ipairs(utilityButtons) do
        if button.data then
            UpdateButtonDisplay(button, button.data)
        end
    end
end

-- ============================================================================
-- CATEGORY BUTTONS
-- ============================================================================

local function CreateCategoryButton(parent, categoryName, index)
    local button = CreateFrame("Button", nil, parent)
    button:SetSize(120, 28)
    button:SetPoint("TOPLEFT", 10 + ((index - 1) * 125), -8)
    
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.1, 0.1, 0.1, 0.8)
    button.bg = bg
    
    local border = button:CreateTexture(nil, "BORDER")
    border:SetPoint("TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", 1, -1)
    border:SetColorTexture(0.3, 0.3, 0.3, 1)
    button.border = border
    
    local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("CENTER")
    text:SetText(categoryName)
    button.text = text
    
    button.categoryName = categoryName
    
    button:SetScript("OnClick", function(self)
        currentFilter = self.categoryName
        
        -- Update all category buttons
        for _, catBtn in ipairs(categoryButtons) do
            if catBtn.categoryName == currentFilter then
                catBtn.bg:SetColorTexture(0.2, 0.4, 0.6, 1)
                catBtn.border:SetColorTexture(0.4, 0.7, 1, 1)
                catBtn.text:SetTextColor(1, 1, 1)
            else
                catBtn.bg:SetColorTexture(0.1, 0.1, 0.1, 0.8)
                catBtn.border:SetColorTexture(0.3, 0.3, 0.3, 1)
                catBtn.text:SetTextColor(0.8, 0.8, 0.8)
            end
        end
        
        UpdateUtilityDisplay()
    end)
    
    button:SetScript("OnEnter", function(self)
        if self.categoryName ~= currentFilter then
            self.bg:SetColorTexture(0.15, 0.15, 0.15, 1)
            self.border:SetColorTexture(0.5, 0.5, 0.5, 1)
        end
    end)
    
    button:SetScript("OnLeave", function(self)
        if self.categoryName ~= currentFilter then
            self.bg:SetColorTexture(0.1, 0.1, 0.1, 0.8)
            self.border:SetColorTexture(0.3, 0.3, 0.3, 1)
        end
    end)
    
    return button
end

local function UpdateCategoryButtons()
    for _, btn in ipairs(categoryButtons) do
        btn:Hide()
    end
    wipe(categoryButtons)
    
    local allUtilities = GetAllUtilities()
    local categories = GetCategories(allUtilities)
    
    local visibleCount = 0
    for i, cat in ipairs(categories) do
        if visibleCount < 4 then -- Show max 4 category buttons
            local btn = CreateCategoryButton(mainFrame.categoryBar, cat, visibleCount + 1)
            
            if cat == currentFilter then
                btn.bg:SetColorTexture(0.2, 0.4, 0.6, 1)
                btn.border:SetColorTexture(0.4, 0.7, 1, 1)
                btn.text:SetTextColor(1, 1, 1)
            else
                btn.text:SetTextColor(0.8, 0.8, 0.8)
            end
            
            btn:Show()
            table.insert(categoryButtons, btn)
            visibleCount = visibleCount + 1
        end
    end
end

-- ============================================================================
-- MAIN FRAME
-- ============================================================================

local function CreateMainFrame()
    if mainFrame then return mainFrame end
    
    mainFrame = CreateFrame("Frame", "EasyPortCompendium", UIParent, "BasicFrameTemplateWithInset")
    mainFrame:SetSize(620, 680)
    mainFrame:SetPoint("CENTER")
    mainFrame:SetMovable(true)
    mainFrame:EnableMouse(true)
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
    mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)
    mainFrame:SetClampedToScreen(true)
    mainFrame:Hide()
    
    mainFrame.TitleText:SetText("EasyPort Compendium")
    mainFrame.TitleText:SetTextColor(1, 0.82, 0)
    
    mainFrame.CloseButton:HookScript("OnClick", function()
        mainFrame:Hide()
    end)
    
    -- Category bar
    local categoryBar = CreateFrame("Frame", nil, mainFrame)
    categoryBar:SetPoint("TOPLEFT", 12, -30)
    categoryBar:SetPoint("TOPRIGHT", -32, -30)
    categoryBar:SetHeight(36)
    mainFrame.categoryBar = categoryBar
    
    -- Search box
    local searchBox = CreateFrame("EditBox", nil, mainFrame, "InputBoxTemplate")
    searchBox:SetSize(180, 25)
    searchBox:SetPoint("TOPRIGHT", -35, -34)
    searchBox:SetAutoFocus(false)
    searchBox:SetMaxLetters(50)
    searchBox:SetScript("OnTextChanged", function(self)
        searchText = self:GetText()
        UpdateUtilityDisplay()
    end)
    searchBox:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    
    local searchLabel = searchBox:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    searchLabel:SetPoint("BOTTOMLEFT", searchBox, "TOPLEFT", 0, 2)
    searchLabel:SetText("Search:")
    searchLabel:SetTextColor(0.8, 0.8, 0.8)
    
    -- Count display
    local countText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    countText:SetPoint("BOTTOMLEFT", 15, 12)
    countText:SetTextColor(0.7, 0.7, 0.7)
    mainFrame.countText = countText
    
    -- Scroll frame
    local scrollFrame = CreateFrame("ScrollFrame", nil, mainFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 12, -75)
    scrollFrame:SetPoint("BOTTOMRIGHT", -32, 35)
    mainFrame.scrollFrame = scrollFrame
    
    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(590, 500)
    scrollFrame.content = scrollChild
    scrollFrame:SetScrollChild(scrollChild)
    
    -- Refresh button
    local refreshBtn = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
    refreshBtn:SetSize(100, 25)
    refreshBtn:SetPoint("BOTTOMRIGHT", -35, 8)
    refreshBtn:SetText("Refresh")
    refreshBtn:SetScript("OnClick", function()
        UpdateCategoryButtons()
        UpdateUtilityDisplay()
    end)
    
    -- Initialize
    UpdateCategoryButtons()
    UpdateUtilityDisplay()
    
    -- Start cooldown update timer
    C_Timer.NewTicker(1, UpdateCooldowns)
    
    return mainFrame
end

-- ============================================================================
-- MINIMAP BUTTON
-- ============================================================================

local function CreateMinimapButton()
    if minimapButton then return minimapButton end
    
    minimapButton = CreateFrame("Button", "EasyPortMinimapButton", Minimap)
    minimapButton:SetSize(32, 32)
    minimapButton:SetFrameStrata("MEDIUM")
    minimapButton:SetFrameLevel(8)
    minimapButton:RegisterForClicks("AnyUp")
    minimapButton:RegisterForDrag("LeftButton")
    minimapButton:SetMovable(true)
    
    local angle = 210
    local x = math.cos(angle) * 80
    local y = math.sin(angle) * 80
    minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
    
    local bg = minimapButton:CreateTexture(nil, "BACKGROUND")
    bg:SetSize(20, 20)
    bg:SetPoint("CENTER")
    bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    
    local border = minimapButton:CreateTexture(nil, "OVERLAY")
    border:SetSize(52, 52)
    border:SetPoint("TOPLEFT")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    
    local icon = minimapButton:CreateTexture(nil, "ARTWORK")
    icon:SetSize(20, 20)
    icon:SetPoint("CENTER")
    icon:SetTexture("Interface\\Icons\\Spell_Arcane_TeleportDalaran")
    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    
    minimapButton:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            SpellbookTab.Toggle()
        end
    end)
    
    minimapButton:SetScript("OnDragStart", function(self)
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
    
    minimapButton:SetScript("OnDragStop", function(self)
        self:UnlockHighlight()
        self:SetScript("OnUpdate", nil)
    end)
    
    minimapButton:SetScript("OnEnter", function(self)
        self:LockHighlight()
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("EasyPort", 1, 1, 1)
        GameTooltip:AddLine("Your complete utility compendium", 0.7, 0.7, 0.7)
        GameTooltip:AddLine(" ", 1, 1, 1)
        GameTooltip:AddLine("Teleports • Utilities • Services", 0.5, 0.8, 1)
        GameTooltip:AddLine(" ", 1, 1, 1)
        GameTooltip:AddLine("Click to open", 0.3, 1, 0.3)
        GameTooltip:AddLine("Drag to move", 0.5, 0.5, 0.5)
        GameTooltip:Show()
    end)
    
    minimapButton:SetScript("OnLeave", function(self)
        self:UnlockHighlight()
        GameTooltip:Hide()
    end)
    
    minimapButton:Show()
    return minimapButton
end

-- ============================================================================
-- PUBLIC API
-- ============================================================================

function SpellbookTab.Initialize()
    CreateMinimapButton()
end

function SpellbookTab.Toggle()
    if not mainFrame then
        CreateMainFrame()
        mainFrame:Show()
    elseif mainFrame:IsShown() then
        mainFrame:Hide()
    else
        UpdateCategoryButtons()
        UpdateUtilityDisplay()
        mainFrame:Show()
    end
end

function SpellbookTab.Show()
    if not mainFrame then
        CreateMainFrame()
    end
    UpdateCategoryButtons()
    UpdateUtilityDisplay()
    mainFrame:Show()
end

function SpellbookTab.Hide()
    if mainFrame then
        mainFrame:Hide()
    end
end

_G.EasyPort_SpellbookTab = SpellbookTab

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
        -- Show appropriate action text
        if data.category == "Utility" then
            if data.destination and (data.destination:find("Repair") or data.destination:find("Mailbox") or data.destination:find("Transmog")) then
                GameTooltip:AddLine("Click to summon", 0.3, 1, 0.3)
            else
                GameTooltip:AddLine("Click to use", 0.3, 1, 0.3)
            end
        else
            GameTooltip:AddLine("Click to teleport", 0.3, 1, 0.3)
        end
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

-- ============================================================================
-- DISPLAY UPDATE
-- ============================================================================