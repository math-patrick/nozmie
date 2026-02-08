-- ============================================================================
-- Nozmie - Utility Collection UI
-- Standalone window styled like the Toy Box layout
-- ============================================================================

local UtilityUI = {}
local frame
local content
local scrollFrame
local searchBox
local filterDropDown
local dataCache = {}
local filteredData = {}
local buttons = {}
local selectedFilter = "ALL"
local selectedTab = "UTILITY"
local petIconCache = {}
local GRID_PADDING = 14
local ROW_HEIGHT = 46
local ICON_SIZE = 28
local MINIMAP_ICON_TEXTURE = "Interface\\Icons\\Spell_Holy_BorrowedTime"

local teleportCategories = {
    ["Home"] = true,
    ["Toy"] = true,
    ["Class"] = true,
    ["M+ Dungeon"] = true,
    ["Raid"] = true,
    ["Delve"] = true
}

local Locale = _G.Nozmie_Locale
local Helpers = _G.Nozmie_Helpers
local BannerController = _G.Nozmie_BannerController
local function Lstr(key, fallback)
    if Locale and Locale.GetString then
        return Locale.GetString(key, fallback)
    end
    return fallback or key
end

local filterOptions = {}

local function GetPetIconByName(petName)
    if not petName or not C_PetJournal or not C_PetJournal.GetNumPets then
        return nil
    end
    if petIconCache[petName] ~= nil then
        return petIconCache[petName]
    end
    local numPets = C_PetJournal.GetNumPets()
    for index = 1, numPets do
        local _, _, _, customName, _, _, _, petNameFromJournal, icon = C_PetJournal.GetPetInfoByIndex(index)
        if petNameFromJournal == petName or customName == petName then
            petIconCache[petName] = icon
            return icon
        end
    end
    petIconCache[petName] = nil
    return nil
end

local function IsUtilityEntry(item)
    return item and item.category and item.category:find("Utility")
end

local function IsTeleportEntry(item)
    return item and item.category and teleportCategories[item.category]
end

local function GetEntryName(item)
    return item.name or item.spellName or ""
end

local function HasKeyword(item, keyword)
    if not item.keywords then
        return false
    end
    for _, key in ipairs(item.keywords) do
        if key == keyword then
            return true
        end
    end
    return false
end

local function IsServiceEntry(item)
    local destination = item.destination or ""
    return destination:find("Repair") or destination:find("Mailbox") or destination:find("Transmog") or destination:find("Anvil")
end

local function IsTrainingEntry(item)
    local destination = item.destination or ""
    return destination:find("Training") or HasKeyword(item, "dummy")
end

local function IsCookingEntry(item)
    local destination = item.destination or ""
    return destination:find("Cooking") or HasKeyword(item, "cooking")
end

local function GetCategoryLabel(item)
    if IsUtilityEntry(item) then
        return Lstr("utility.category.utility", "Utility")
    end
    if IsTeleportEntry(item) then
        return Lstr("utility.category.teleport", "Teleport")
    end
    return item.category or ""
end

local function GetEntryDescription(item)
    if not item then
        return ""
    end
    if IsTeleportEntry(item) then
        if item.category == "M+ Dungeon" then
            return Lstr("utility.desc.mplus", "M+ Portal")
        end
        if item.category == "Raid" then
            return Lstr("utility.desc.raid", "Raid Portal")
        end
        if item.category == "Delve" then
            return Lstr("utility.desc.delve", "Delve Portal")
        end
        if item.category == "Class" then
            return Lstr("utility.desc.class", "Class Portal")
        end
        if item.category == "Home" then
            return Lstr("utility.desc.home", "Home Teleport")
        end
        if item.category == "Toy" then
            return Lstr("utility.desc.toy", "Toy Teleport")
        end
        return Lstr("utility.desc.teleport", "Teleport")
    end

    local tags = {}
    local destination = item.destination or ""
    if destination:find("Repair") then table.insert(tags, Lstr("utility.desc.repair", "Repair")) end
    if destination:find("Mailbox") then table.insert(tags, Lstr("utility.desc.mail", "Mail")) end
    if destination:find("Transmog") then table.insert(tags, Lstr("utility.desc.transmog", "Transmog")) end
    if destination:find("Anvil") then table.insert(tags, Lstr("utility.desc.anvil", "Anvil")) end
    if HasKeyword(item, "auction") or HasKeyword(item, "ah") then
        table.insert(tags, Lstr("utility.desc.ah", "Auction House"))
    end
    if HasKeyword(item, "bank") then table.insert(tags, Lstr("utility.desc.bank", "Bank")) end
    if HasKeyword(item, "vendor") then table.insert(tags, Lstr("utility.desc.vendor", "Vendor")) end
    if HasKeyword(item, "training") or HasKeyword(item, "dummy") then
        table.insert(tags, Lstr("utility.desc.training", "Training"))
    end
    if HasKeyword(item, "cooking") then table.insert(tags, Lstr("utility.desc.cooking", "Cooking")) end

    if #tags > 0 then
        return table.concat(tags, ", ")
    end

    return GetCategoryLabel(item)
end

local function MatchesFilter(item)
    return true
end

local function MatchesSearch(item, query)
    if query == "" then
        return true
    end
    local name = GetEntryName(item):lower()
    local spellName = (item.spellName or ""):lower()
    local destination = (item.destination or ""):lower()
    if name:find(query, 1, true) or spellName:find(query, 1, true) or destination:find(query, 1, true) then
        return true
    end
    if item.keywords then
        for _, key in ipairs(item.keywords) do
            if key:lower():find(query, 1, true) then
                return true
            end
        end
    end
    return false
end

local function IsUsableUtility(item)
    if Helpers and Helpers.CanPlayerUseTeleport then
        return Helpers.CanPlayerUseTeleport(item)
    end
    if item.itemID then
        if PlayerHasToy and PlayerHasToy(item.itemID) then
            return true
        end
        if C_Item and C_Item.GetItemCount then
            return C_Item.GetItemCount(item.itemID, true, false, false) > 0
        end
        return false
    end
    if item.spellID and (IsSpellKnown(item.spellID) or IsPlayerSpell(item.spellID)) then
        return true
    end
    return false
end

local function BuildDataCache()
    dataCache = {}
    if not _G.Nozmie_Data then
        return
    end
    for _, item in ipairs(_G.Nozmie_Data) do
        if (IsUtilityEntry(item) or IsTeleportEntry(item)) and IsUsableUtility(item) then
            table.insert(dataCache, item)
        end
    end
    table.sort(dataCache, function(a, b)
        return GetEntryName(a) < GetEntryName(b)
    end)
end

local function BuildFilteredData()
    local query = ""
    if searchBox and searchBox.GetText then
        query = searchBox:GetText() or ""
        query = query:lower()
        if strtrim then
            query = strtrim(query)
        end
    end

    filteredData = {}
    for _, item in ipairs(dataCache) do
        local matchesTab = (selectedTab == "UTILITY" and IsUtilityEntry(item)) or
            (selectedTab == "TELEPORT" and IsTeleportEntry(item))
        if matchesTab and MatchesFilter(item) and MatchesSearch(item, query) then
            table.insert(filteredData, item)
        end
    end
end

local function GetIconForEntry(item)
    if item.itemID then
        return C_Item.GetItemIconByID(item.itemID)
    end
    if item.spellID then
        return C_Spell.GetSpellTexture(item.spellID)
    end
    if item.petName then
        return GetPetIconByName(item.petName)
    end
    return "Interface\\Icons\\INV_Misc_QuestionMark"
end

local function EnsureButton(index)
    if buttons[index] then
        return buttons[index]
    end

    local button = CreateFrame("Button", nil, content, "SecureActionButtonTemplate")

    button:SetSize(1, ROW_HEIGHT)
    button:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2")
    if button:GetHighlightTexture() then
        button:GetHighlightTexture():SetBlendMode("ADD")
        button:GetHighlightTexture():SetAllPoints(button)
    end

    button.icon = button.Icon or button.icon
    if not button.icon then
        button.icon = button:CreateTexture(nil, "ARTWORK")
    end
    button.icon:SetSize(ICON_SIZE, ICON_SIZE)
    button.icon:SetPoint("LEFT", button, "LEFT", 14, 0)
    button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

    button.border = button.IconBorder or button.Border
    if not button.border then
        button.border = button:CreateTexture(nil, "OVERLAY")
        button.border:SetTexture("Interface\\Buttons\\UI-Quickslot2")
    end
    button.border:SetSize(ICON_SIZE + 22, ICON_SIZE + 22)
    button.border:SetPoint("CENTER", button.icon, "CENTER", 0, 0)
    button.name = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    button.name:SetPoint("TOPLEFT", button.icon, "TOPRIGHT", 12, -4)
    button.name:SetPoint("RIGHT", button, "RIGHT", -10, 0)
    button.name:SetJustifyH("LEFT")
    button.category = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    button.category:SetPoint("TOPLEFT", button.name, "BOTTOMLEFT", 0, -2)
    button.category:SetPoint("RIGHT", button.name, "RIGHT", 0, 0)
    button.category:SetJustifyH("LEFT")
    button:EnableMouse(true)
    button:RegisterForClicks("AnyUp", "AnyDown")

    button:SetScript("OnEnter", function(self)
        local data = self.data
        if not data then
            return
        end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if data.itemID then
            GameTooltip:SetItemByID(data.itemID)
        elseif data.spellID then
            GameTooltip:SetSpellByID(data.spellID)
        else
            GameTooltip:SetText(GetEntryName(data))
        end
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    buttons[index] = button
    return button
end

local function ApplyActionAttributes(button, item)
    if BannerController and BannerController.ConfigureActionButton then
        BannerController.ConfigureActionButton(button, item)
        return
    end
    if BannerController and BannerController.ApplyActionAttributes then
        BannerController.ApplyActionAttributes(button, item)
        return
    end

    button:SetAttribute("type", nil)
    button:SetAttribute("macrotext", nil)
    button:SetAttribute("spell", nil)
    button:SetAttribute("item", nil)

    if item.macrotext then
        button:SetAttribute("type", "macro")
        button:SetAttribute("macrotext", item.macrotext)
        return
    end
    if item.petName then
        button:SetAttribute("type", "macro")
        button:SetAttribute("macrotext", "/summonpet " .. item.petName)
        return
    end
    if item.itemID then
        button:SetAttribute("type", "macro")
        button:SetAttribute("macrotext", "/use item:" .. item.itemID)
        return
    end
    if item.spellName then
        button:SetAttribute("type", "spell")
        button:SetAttribute("spell", item.spellName)
        return
    end
end

local function LayoutButtons()
    if not content or not scrollFrame then
        return
    end
    local width = scrollFrame:GetWidth() or 0
    if width <= 0 then
        width = frame and frame.Inset and frame.Inset:GetWidth() or 520
    end
    content:SetWidth(width)
    local columns = math.max(2, math.floor((width + GRID_PADDING) / 220))

    for i, button in ipairs(buttons) do
        button:Hide()
    end

    local col = 0
    local row = 0
    for index, entry in ipairs(filteredData) do
        local button = EnsureButton(index)
        button.data = entry
        button.name:SetText(GetEntryName(entry))
        button.category:SetText(GetEntryDescription(entry))
        local icon = GetIconForEntry(entry)
        button.icon:SetTexture(icon)
        ApplyActionAttributes(button, entry)

        local x = col * (width / columns)
        local y = row * (ROW_HEIGHT + GRID_PADDING)
        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", content, "TOPLEFT", x, -y)
        button:SetWidth((width / columns) - GRID_PADDING)
        button:Show()

        col = col + 1
        if col >= columns then
            col = 0
            row = row + 1
        end
    end

    local rows = math.max(1, row + (col > 0 and 1 or 0))
    content:SetHeight(rows * (ROW_HEIGHT + GRID_PADDING))
end

local function RefreshLayout()
    BuildFilteredData()
    LayoutButtons()
end

local function UpdateTabSelection(value, teleportTab, utilityTab)
    selectedTab = value or "UTILITY"
    local active = value == "TELEPORT" and teleportTab or utilityTab
    local inactive = value == "TELEPORT" and utilityTab or teleportTab
    if active and active.GetFontString then
        active:GetFontString():SetTextColor(1, 0.82, 0)
    end
    if inactive and inactive.GetFontString then
        inactive:GetFontString():SetTextColor(0.7, 0.7, 0.7)
    end
    if active and active.SetButtonState then
        active:SetButtonState("PUSHED", true)
    end
    if inactive and inactive.SetButtonState then
        inactive:SetButtonState("NORMAL", false)
    end
    RefreshLayout()
end

local function CreateTabButtons(parent, anchor)
    local teleportTab = CreateFrame("Button", nil, parent)
    teleportTab:SetSize(150, 30)
    teleportTab:SetNormalFontObject("GameFontNormal")
    teleportTab:SetHighlightFontObject("GameFontHighlight")

    local utilityTab = CreateFrame("Button", nil, parent)
    utilityTab:SetSize(150, 30)
    utilityTab:SetNormalFontObject("GameFontNormal")
    utilityTab:SetHighlightFontObject("GameFontHighlight")

    local anchorFrame = anchor or parent
    utilityTab:SetPoint("TOPRIGHT", anchorFrame, "TOPLEFT", -8, -2)
    teleportTab:SetPoint("RIGHT", utilityTab, "LEFT", -6, 0)
    teleportTab:SetText(Lstr("utility.tab.teleport", "Teleports"))
    teleportTab:SetScript("OnClick", function()
        UpdateTabSelection("TELEPORT", teleportTab, utilityTab)
    end)

    teleportTab:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
    teleportTab:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
    teleportTab:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")

    utilityTab:SetText(Lstr("utility.tab.utility", "Utility"))
    utilityTab:SetScript("OnClick", function()
        UpdateTabSelection("UTILITY", teleportTab, utilityTab)
    end)

    utilityTab:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
    utilityTab:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
    utilityTab:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")

    UpdateTabSelection(selectedTab, teleportTab, utilityTab)
end

local function EnsureFrame()
    if frame then
        return frame
    end

    frame = CreateFrame("Frame", "NozmieUtilityFrame", UIParent, "PortraitFrameTemplate")
    frame:SetSize(700, 470)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("HIGH")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    if frame.TitleText then
        frame.TitleText:SetText(Lstr("utility.title", "Utility"))
    end
    if frame.Portrait then
        frame.Portrait:SetTexture(MINIMAP_ICON_TEXTURE)
    elseif frame.PortraitContainer and frame.PortraitContainer.portrait then
        frame.PortraitContainer.portrait:SetTexture(MINIMAP_ICON_TEXTURE)
    end
    if frame.CloseButton then
        frame.CloseButton:SetScript("OnClick", function()
            frame:Hide()
        end)
    end

    frame.Inset = CreateFrame("Frame", nil, frame, "InsetFrameTemplate3")
    frame.Inset:SetPoint("TOPLEFT", 4, -86)
    frame.Inset:SetPoint("BOTTOMRIGHT", -6, 28)

    searchBox = CreateFrame("EditBox", nil, frame, "SearchBoxTemplate")
    searchBox:SetSize(220, 20)
    searchBox:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -24, -32)
    searchBox:SetScript("OnTextChanged", function()
        RefreshLayout()
    end)

    CreateTabButtons(frame, searchBox)


    scrollFrame = CreateFrame("ScrollFrame", nil, frame.Inset, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 6, -6)
    scrollFrame:SetPoint("BOTTOMRIGHT", -28, 6)

    content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(1, 1)
    scrollFrame:SetScrollChild(content)

    scrollFrame:SetScript("OnSizeChanged", function()
        LayoutButtons()
    end)

    frame:SetScript("OnShow", function()
        BuildDataCache()
        RefreshLayout()
    end)

    frame.Inset:SetScript("OnSizeChanged", function()
        LayoutButtons()
    end)

    if type(UISpecialFrames) == "table" then
        table.insert(UISpecialFrames, "NozmieUtilityFrame")
    end

    frame:Hide()
    return frame
end

function UtilityUI.Toggle()
    local host = EnsureFrame()
    if host:IsShown() then
        host:Hide()
    else
        host:Show()
    end
end

function UtilityUI.Show()
    EnsureFrame():Show()
end

function UtilityUI.Hide()
    if frame then
        frame:Hide()
    end
end

_G.Nozmie_UtilityUI = UtilityUI
