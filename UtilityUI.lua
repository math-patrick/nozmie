-- ============================================================================
-- Nozmie - Utility UI Module
-- Main utility frame with tabs, item grid, and search
-- ============================================================================

local SharedUI = _G.Nozmie_SharedUI
local ConfigHelpers = _G.Nozmie_ConfigHelpers
local Helpers = _G.Nozmie_Helpers
local BannerController = _G.Nozmie_BannerController

local Locale = _G.Nozmie_Locale
local function Lstr(key, fallback)
    if Locale and Locale.GetString then
        return Locale.GetString(key, fallback)
    end
    return fallback or key
end

local selectedTab = "TELEPORT"
local TAB_UTILITY = "UTILITY"
local TAB_TELEPORT = "TELEPORT"
local TAB_HEARTHSTONE = "HEARTHSTONE"

local UtilityUI = {}
_G.Nozmie_UtilityUI = UtilityUI
local filteredData = {}
local buttons = {}
local GRID_PADDING = 8
local ROW_HEIGHT = 44
local ICON_SIZE = 36
local frame
local content
local searchBox
local scrollFrame
local dataCache = {}
local EnsureFrame

local function IsUtilityEntry(item)
    return item and item.category == "Utility"
end

local function IsTeleportEntry(item)
    if not item then
        return false
    end
    return item.category == "M+ Dungeon" or item.category == "Raid" or item.category == "Delve" or item.category == "Toy"
end

local function MatchesFilter(item)
    return item ~= nil
end

local function MatchesSearch(item, query)
    if not query or query == "" then
        return true
    end
    local text = string.lower(table.concat({
        tostring(item.name or ""),
        tostring(item.spellName or ""),
        tostring(item.destination or ""),
        tostring(item.category or "")
    }, " "))
    if text:find(query, 1, true) then
        return true
    end
    if item.keywords then
        for _, keyword in ipairs(item.keywords) do
            if type(keyword) == "string" and string.lower(keyword):find(query, 1, true) then
                return true
            end
        end
    end
    return false
end

local function GetEntryDescription(data)
    return data.destination or data.category or ""
end

local function EnsureButton(index)
    if buttons[index] then
        return buttons[index]
    end
    local utilityButtonModule = _G.Nozmie_UtilityButton
    local button = utilityButtonModule and utilityButtonModule.Create and
                       utilityButtonModule.Create(content, ICON_SIZE, ROW_HEIGHT) or
                       CreateFrame("Button", nil, content, "SecureActionButtonTemplate")
    if not button.icon then
        button.icon = button:CreateTexture(nil, "ARTWORK")
        button.icon:SetSize(ICON_SIZE, ICON_SIZE)
        button.icon:SetPoint("LEFT", button, "LEFT", 14, 0)
    end
    if not button.name then
        button.name = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        button.name:SetPoint("TOPLEFT", button.icon, "TOPRIGHT", 12, -4)
        button.name:SetPoint("RIGHT", button, "RIGHT", -10, 0)
        button.name:SetJustifyH("LEFT")
    end
    if not button.category then
        button.category = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        button.category:SetPoint("TOPLEFT", button.name, "BOTTOMLEFT", 0, -2)
        button.category:SetPoint("RIGHT", button.name, "RIGHT", 0, 0)
        button.category:SetJustifyH("LEFT")
    end
    if not button.cooldown then
        button.cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
        button.cooldown:SetAllPoints(button.icon)
        button.cooldown:Hide()
    end
    if not button.cooldownText then
        button.cooldownText = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        button.cooldownText:SetPoint("CENTER", button.icon, "CENTER", 0, 0)
        button.cooldownText:Hide()
    end
    button:EnableMouse(true)
    button:RegisterForClicks("AnyUp", "AnyDown")
    buttons[index] = button
    return button
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

local function IsUsableUtility(item)
    if Helpers and Helpers.CanPlayerUseUtility then
        return Helpers.CanPlayerUseUtility(item)
    end
    if item.itemID then
        if PlayerHasToy and PlayerHasToy(item.itemID) then
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
    -- Sort by name
    table.sort(dataCache, function(a, b)
        return ConfigHelpers.GetEntryName(a) < ConfigHelpers.GetEntryName(b)
    end)
end

local function IsHearthstoneEntry(item)
    if not item then return false end
    if item.category and item.category:lower():find("hearth") then return true end
    if item.name and item.name:lower():find("hearthstone") then return true end
    if item.spellName and item.spellName:lower():find("hearthstone") then return true end
    if item.keywords then
        for _, k in ipairs(item.keywords) do
            if type(k) == "string" and (k:lower():find("hearth") or k:lower():find("home") or k:lower():find("inn")) then
                return true
            end
        end
    end
    return false
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
    if not dataCache then return end
    if selectedTab == TAB_TELEPORT then
        -- Group by destination
        local byDest = {}
        for _, item in ipairs(dataCache) do
            if IsTeleportEntry(item) and not IsHearthstoneEntry(item) and MatchesFilter(item) and MatchesSearch(item, query) then
                local dest = item.destination or item.name or item.spellName or "?"
                byDest[dest] = byDest[dest] or {}
                table.insert(byDest[dest], item)
            end
        end
        for dest, group in pairs(byDest) do
            table.insert(filteredData, { destination = dest, options = group, currentIndex = 1 })
        end
    else
        for _, item in ipairs(dataCache) do
            local matchesTab = (selectedTab == TAB_UTILITY and IsUtilityEntry(item))
                or (selectedTab == TAB_HEARTHSTONE and IsHearthstoneEntry(item))
            if matchesTab and MatchesFilter(item) and MatchesSearch(item, query) then
                table.insert(filteredData, item)
            end
        end
    end
end


local function ApplyActionAttributes(button, item)
    if BannerController and BannerController.ApplyActionAttributes then
        BannerController.ApplyActionAttributes(button, item)
        return
    end
    if SharedUI and SharedUI.ApplyActionAttributes then
        SharedUI.ApplyActionAttributes(button, item)
        return
    end
    if item.spellID then
        button:SetAttribute("type", "spell")
        button:SetAttribute("spell", item.spellID)
    elseif item.itemID then
        button:SetAttribute("type", "macro")
        button:SetAttribute("macrotext", "/use item:" .. tostring(item.itemID))
    end
end


local function LayoutButtons()

    if not content or not scrollFrame then return end
    local width = scrollFrame:GetWidth() or 0
    if width <= 0 then
        width = frame and frame.Inset and frame.Inset:GetWidth() or 520
    end
    content:SetWidth(width)
    local columns = math.max(2, math.floor((width + GRID_PADDING) / 220))

    for i, button in ipairs(buttons) do
        button:Hide()
    end
    if not filteredData then return end
    local col, row = 0, 0

    for index, entry in ipairs(filteredData) do
        local button = EnsureButton(index)
        local data = entry.options and entry.options[entry.currentIndex or 1] or entry
        button.data = data
        if SharedUI and SharedUI.GetEntryLabel then
            button.name:SetText(SharedUI.GetEntryLabel(data))
        else
            button.name:SetText(ConfigHelpers.GetEntryName(data))
        end
        button.category:SetText(GetEntryDescription(data))
        button.icon:SetTexture(ConfigHelpers.GetIconForEntry(data))
        ApplyActionAttributes(button, data)

        -- Navigation arrows for grouped entries
        if entry.options then
            if not button.leftArrow then
                button.leftArrow = CreateFrame("Button", nil, button)
                button.leftArrow:SetSize(18, 18)
                button.leftArrow:SetPoint("LEFT", button, "LEFT", 2, 0)
                button.leftArrow:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
                button.leftArrow:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
                button.leftArrow:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
                button.leftArrow:SetScript("OnClick", function()
                    entry.currentIndex = ((entry.currentIndex or 1) - 2) % #entry.options + 1
                    LayoutButtons()
                end)
            end
            if not button.rightArrow then
                button.rightArrow = CreateFrame("Button", nil, button)
                button.rightArrow:SetSize(18, 18)
                button.rightArrow:SetPoint("LEFT", button.leftArrow, "RIGHT", 2, 0)
                button.rightArrow:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
                button.rightArrow:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
                button.rightArrow:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
                button.rightArrow:SetScript("OnClick", function()
                    entry.currentIndex = ((entry.currentIndex or 1) % #entry.options) + 1
                    LayoutButtons()
                end)
            end
            button.leftArrow:Show()
            button.rightArrow:Show()
            if button.hotkey then button.hotkey:Hide() end
        else
            if button.leftArrow then button.leftArrow:Hide() end
            if button.rightArrow then button.rightArrow:Hide() end
            -- Hotkey label
            if button.hotkey then
                local key, btnName = nil, button:GetName()
                if btnName then
                    if data.itemID then
                        key = GetBindingKey("CLICK " .. btnName .. ":LeftButton")
                    elseif data.spellID then
                        key = GetBindingKey("CLICK " .. btnName .. ":LeftButton")
                    end
                end
                if key then
                    button.hotkey:SetText(key)
                    button.hotkey:Show()
                else
                    button.hotkey:SetText("")
                    button.hotkey:Hide()
                end
            end
        end

        -- Cooldown logic
        local isOnCooldown, start, duration, enable = false, 0, 0, 0
        if data.itemID and C_Item and C_Item.GetItemCooldown then
            start, duration, enable = C_Item.GetItemCooldown(data.itemID)
        elseif data.spellID and C_Spell and C_Spell.GetSpellCooldown then
            start, duration, enable = C_Spell.GetSpellCooldown(data.spellID)
        end
        if enable and enable ~= 0 and duration and duration > 0 then
            isOnCooldown = true
        end
        if isOnCooldown then
            button.icon:SetDesaturated(true)
            button.cooldown:SetCooldown(start, duration)
            button.cooldown:Show()
            local remaining = (start + duration - GetTime())
            if button.cooldownText then
                if remaining > 0 then
                    button.cooldownText:SetText(math.ceil(remaining))
                    button.cooldownText:Show()
                else
                    button.cooldownText:SetText("")
                    button.cooldownText:Hide()
                end
            end
        else
            button.icon:SetDesaturated(false)
            button.cooldown:Hide()
            if button.cooldownText then
                button.cooldownText:SetText("")
                button.cooldownText:Hide()
            end
        end
        button:SetScript("OnClick", nil)
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

local function UpdateTabSelection(value, teleportTab, utilityTab, hearthTab)
    selectedTab = value or TAB_UTILITY
    RefreshLayout()
    if PanelTemplates_SetTab then
        local tabIdx = 1
        if value == TAB_TELEPORT then tabIdx = 1 end
        if value == TAB_UTILITY then tabIdx = 2 end
        if value == TAB_HEARTHSTONE then tabIdx = 3 end
        PanelTemplates_SetTab(teleportTab:GetParent(), tabIdx)
    else
        local active, inactive1, inactive2
        if value == TAB_TELEPORT then
            active, inactive1, inactive2 = teleportTab, utilityTab, hearthTab
        elseif value == TAB_HEARTHSTONE then
            active, inactive1, inactive2 = hearthTab, utilityTab, teleportTab
        else
            active, inactive1, inactive2 = utilityTab, teleportTab, hearthTab
        end
        if active and active.GetFontString then
            active:GetFontString():SetTextColor(1, 0.82, 0)
        end
        if inactive1 and inactive1.GetFontString then
            inactive1:GetFontString():SetTextColor(0.7, 0.7, 0.7)
        end
        if inactive2 and inactive2.GetFontString then
            inactive2:GetFontString():SetTextColor(0.7, 0.7, 0.7)
        end
        if active and active.SetButtonState then
            active:SetButtonState("PUSHED", true)
        end
        if inactive1 and inactive1.SetButtonState then
            inactive1:SetButtonState("NORMAL", false)
        end
        if inactive2 and inactive2.SetButtonState then
            inactive2:SetButtonState("NORMAL", false)
        end
    end
    RefreshLayout()
end

local function CreateTabButtons(parent, anchor)
    local teleportTab = CreateFrame("Button", "$parentTab1", parent, "PanelTabButtonTemplate")
    local utilityTab = CreateFrame("Button", "$parentTab2", parent, "PanelTabButtonTemplate")
    local hearthTab = CreateFrame("Button", "$parentTab3", parent, "PanelTabButtonTemplate")

    teleportTab:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 12, 2)
    utilityTab:SetPoint("LEFT", teleportTab, "RIGHT", -16, 0)
    hearthTab:SetPoint("LEFT", utilityTab, "RIGHT", -16, 0)

    if PanelTemplates_SetNumTabs then
        PanelTemplates_SetNumTabs(parent, 3)
    end
    teleportTab:SetText(Lstr("utility.tab.teleport", "Teleports"))
    teleportTab:SetScript("OnClick", function()
        UpdateTabSelection(TAB_TELEPORT, teleportTab, utilityTab, hearthTab)
    end)

    utilityTab:SetText(Lstr("utility.tab.utility", "Utility"))
    utilityTab:SetScript("OnClick", function()
        UpdateTabSelection(TAB_UTILITY, teleportTab, utilityTab, hearthTab)
    end)

    hearthTab:SetText(Lstr("utility.tab.hearthstone", "Hearthstones"))
    hearthTab:SetScript("OnClick", function()
        UpdateTabSelection(TAB_HEARTHSTONE, teleportTab, utilityTab, hearthTab)
    end)

    UpdateTabSelection(selectedTab, teleportTab, utilityTab, hearthTab)
end

EnsureFrame = function()
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
        frame.TitleText:ClearAllPoints()
        frame.TitleText:SetPoint("LEFT", frame, "TOPLEFT", 60, -4)
        frame.TitleText:SetPoint("RIGHT", frame.CloseButton, "LEFT", -120, 0)
        frame.TitleText:SetJustifyH("LEFT")
        frame.TitleText:Show()
    end
    local icon = MINIMAP_ICON_TEXTURE or "Interface\\Icons\\INV_Misc_QuestionMark"
    if frame.Portrait then
        frame.Portrait:SetTexture(icon)
    elseif frame.PortraitContainer and frame.PortraitContainer.portrait then
        frame.PortraitContainer.portrait:SetTexture(icon)
    end
    if frame.CloseButton then
        frame.CloseButton:SetScript("OnClick", function()
            frame:Hide()
        end)
    end

    frame.Inset = CreateFrame("Frame", nil, frame, "InsetFrameTemplate3")
    frame.Inset:SetPoint("TOPLEFT", 4, -56)
    frame.Inset:SetPoint("BOTTOMRIGHT", -6, 28)

    searchBox = CreateFrame("EditBox", nil, frame, "SearchBoxTemplate")
    searchBox:SetSize(220, 20)
    searchBox:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -24, -32)
    searchBox:SetScript("OnTextChanged", function()
        if searchBox.Instructions then
            if searchBox:GetText() == "" then
                searchBox.Instructions:Show()
            else
                searchBox.Instructions:Hide()
            end
        end
        RefreshLayout()
    end)
    if searchBox.Instructions then
        searchBox.Instructions:SetText(Lstr("utility.search.placeholder", "Search utility...") or "Search utility...")
        searchBox.Instructions:SetPoint("LEFT", searchBox, "LEFT", 6, 0)
        searchBox.Instructions:SetJustifyH("LEFT")
        searchBox.Instructions:Show()
    end

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

SLASH_NOZUI1 = "/nozui"
SlashCmdList["NOZUI"] = function()
    UtilityUI.Show()
end


function UtilityUI.Show()
    EnsureFrame():Show()
end

function UtilityUI.Hide()
    if frame then
        frame:Hide()
    end
end