

local SharedUI = _G.Nozmie_SharedUI

local function SetButtonIcon(button, item)
    if SharedUI and SharedUI.GetIconForEntry then
        button.icon:SetTexture(SharedUI.GetIconForEntry(item))
    else
        button.icon:SetTexture("Interface/Icons/INV_Misc_QuestionMark")
    end
end
local selectedTab = "UTILITY"
local TAB_UTILITY = "UTILITY"
local TAB_TELEPORT = "TELEPORT"
local TAB_HEARTHSTONE = "HEARTHSTONE"

local function HasKeyword(item, keyword)
    if not item or not item.keywords or not keyword then return false end
    keyword = keyword:lower()
    for _, k in ipairs(item.keywords) do
        if type(k) == "string" and k:lower() == keyword then
            return true
        end
    end
    return false
end

local function GetEntryName(item)
    if not item then return "" end
    return item.name or item.spellName or item.destination or "?"
end
local function IsUtilityEntry(item)
    if not item or not item.category then return false end
    -- Only true for pure utility, not teleports, toys, portals, home, etc.
    local cat = item.category
    if (cat == "Utility" or cat == "Service" or cat == "Class Utility") then
        return true
    end
    return false
end

local function IsTeleportEntry(item)
    if not item or not item.category then return false end
    -- Exclude class buffs and utility spells
    local cat = item.category
    if cat == "Utility" or cat == "Service" or cat == "Class Utility" then
        return false
    end
    -- Exclude known buffs (e.g., Blessing of the Bronze)
    if item.name and (item.name:lower():find("blessing of the bronze") or item.name:lower():find("mark of the wild") or item.name:lower():find("source of magic")) then return false end
    return item.category:find("Teleport") or item.category:find("Portal") or item.category:find("M+ Dungeon") or item.category:find("Raid") or item.category:find("Delve") or item.category:find("Class") or item.category:find("Toy") or item.category:find("Home")
end
local UtilityUI = {}
local filteredData = {}
local pinnedFavorite = nil
local compactView = false
local buttons = {}
local GRID_PADDING = 8
local ROW_HEIGHT = 44
local ICON_SIZE = 36
local frame
local content

local function EnsureButton(index)
    if buttons[index] then
        return buttons[index]
    end
    local ButtonModule = _G.Nozmie_UtilityButton
    if not ButtonModule or not ButtonModule.Create then
        error("Nozmie_UtilityButton module not loaded or missing Create function")
    end
    local button = ButtonModule.Create(content, ICON_SIZE, ROW_HEIGHT)
    buttons[index] = button
    -- Tab navigation removed
    return button
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

local function GetFavoriteKey(item)
    if item.itemID then return "item:"..item.itemID end
    if item.spellID then return "spell:"..item.spellID end
    if item.petName then return "pet:"..item.petName end
    return item.name or "?"
end

local function IsFavorite(item)
    if not NozmieDB or not NozmieDB.favorites then return false end
    return NozmieDB.favorites[GetFavoriteKey(item)]
end

local function SetFavorite(item, value)
    if not NozmieDB then NozmieDB = {} end
    if not NozmieDB.favorites then NozmieDB.favorites = {} end
    NozmieDB.favorites[GetFavoriteKey(item)] = value and true or nil
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
    -- Sort: favorites first, then by name
    table.sort(dataCache, function(a, b)
        local fa, fb = IsFavorite(a), IsFavorite(b)
        if fa and not fb then return true end
        if not fa and fb then return false end
        return GetEntryName(a) < GetEntryName(b)
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
    -- Pin favorite logic
    if NozmieDB and NozmieDB.pinnedFavorite then
        pinnedFavorite = NozmieDB.pinnedFavorite
    else
        pinnedFavorite = nil
    end
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
        -- Pin favorite at the top if it matches
        if pinnedFavorite then
            for dest, group in pairs(byDest) do
                for _, item in ipairs(group) do
                    if GetFavoriteKey(item) == pinnedFavorite then
                        table.insert(filteredData, { destination = dest, options = group, currentIndex = 1 })
                        byDest[dest] = nil
                        break
                    end
                end
            end
        end
        for dest, group in pairs(byDest) do
            table.insert(filteredData, { destination = dest, options = group, currentIndex = 1 })
        end
    else
        local others = {}
        local pinned = nil
        for _, item in ipairs(dataCache) do
            local matchesTab = (selectedTab == TAB_UTILITY and IsUtilityEntry(item))
                or (selectedTab == TAB_HEARTHSTONE and IsHearthstoneEntry(item))
            if matchesTab and MatchesFilter(item) and MatchesSearch(item, query) then
                if pinnedFavorite and GetFavoriteKey(item) == pinnedFavorite then
                    pinned = item
                else
                    table.insert(others, item)
                end
            end
        end
        if pinned then
            table.insert(filteredData, pinned)
        end
        for _, item in ipairs(others) do
            table.insert(filteredData, item)
        end
    end
end


local function ApplyActionAttributes(button, item)
    if SharedUI and SharedUI.ApplyActionAttributes then
        SharedUI.ApplyActionAttributes(button, item)
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

    if not filteredData then return end
    local col = 0
    local row = 0

    for index, entry in ipairs(filteredData) do
        if entry.isSeparator then
            -- No separator logic needed with new tab structure; skip
            row = row + 1
        elseif entry.options then
            -- Teleport group: show destination as main label, allow cycling
            local button = EnsureButton(index)
            button.data = entry.options[entry.currentIndex or 1]
            if SharedUI and SharedUI.GetEntryLabel then
                button.name:SetText(SharedUI.GetEntryLabel(button.data))
            else
                button.name:SetText(entry.destination or GetEntryName(button.data))
            end
            button.category:SetText(GetEntryDescription(button.data))
            SetButtonIcon(button, button.data)
            ApplyActionAttributes(button, button.data)
            -- Arrow navigation (left/right)
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
            -- Hotkey label
            if button.hotkey then button.hotkey:Hide() end
            -- Favorite star logic: show if current option is favorite
            local cur = entry.options[entry.currentIndex or 1]
            if not button.favoriteStar then
                button.favoriteStar = button:CreateTexture(nil, "OVERLAY")
                button.favoriteStar:SetSize(18, 18)
                button.favoriteStar:SetPoint("RIGHT", button, "RIGHT", -4, 0)
                button.favoriteStar:SetTexture("Interface\\COMMON\\ReputationStar")
            end
            if IsFavorite(cur) then
                button.favoriteStar:Show()
            else
                button.favoriteStar:Hide()
            end
            -- Right-click to toggle favorite for current option
            if not button.favoriteBtn then
                button.favoriteBtn = CreateFrame("Button", nil, button)
                button.favoriteBtn:SetSize(24, 24)
                button.favoriteBtn:SetPoint("RIGHT", button, "RIGHT", -2, 0)
                button.favoriteBtn:SetAlpha(0.01)
                button.favoriteBtn:RegisterForClicks("AnyUp", "AnyDown")
                button.favoriteBtn:SetScript("OnClick", function(self, btn)
                    if btn == "RightButton" then
                        local isFav = IsFavorite(cur)
                        SetFavorite(cur, not isFav)
                        if RefreshLayout then RefreshLayout() end
                    end
                end)
            end
            button.favoriteBtn:Show()
            -- Cooldown logic for current option
            local cur = entry.options[entry.currentIndex or 1]
            local isOnCooldown = false
            local start, duration, enable = 0, 0, 0
            if cur.itemID and C_Item and C_Item.GetItemCooldown then
                start, duration, enable = C_Item.GetItemCooldown(cur.itemID)
            elseif cur.spellID and C_Spell and C_Spell.GetSpellCooldown then
                start, duration, enable = C_Spell.GetSpellCooldown(cur.spellID)
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
        else
            -- ...existing code for non-grouped entries...
            local button = EnsureButton(index)
            button.data = entry
            if SharedUI and SharedUI.GetEntryLabel then
                button.name:SetText(SharedUI.GetEntryLabel(entry))
            else
                button.name:SetText(GetEntryName(entry))
            end
            button.category:SetText(GetEntryDescription(entry))
            SetButtonIcon(button, entry)
            ApplyActionAttributes(button, entry)
            -- Update hotkey label
            if button.hotkey then
                local key = nil
                local btnName = button:GetName()
                if btnName then
                    if entry.itemID then
                        key = GetBindingKey("CLICK " .. btnName .. ":LeftButton")
                    elseif entry.spellID then
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
            -- Favorite star: only show for favorites, right-click to toggle
            if not button.favoriteStar then
                button.favoriteStar = button:CreateTexture(nil, "OVERLAY")
                button.favoriteStar:SetSize(18, 18)
                button.favoriteStar:SetPoint("RIGHT", button, "RIGHT", -4, 0)
                button.favoriteStar:SetTexture("Interface\\COMMON\\ReputationStar")
            end
            if IsFavorite(entry) then
                button.favoriteStar:Show()
            else
                button.favoriteStar:Hide()
            end
            -- Cooldown logic
            local isOnCooldown = false
            local start, duration, enable = 0, 0, 0
            if entry.itemID and C_Item and C_Item.GetItemCooldown then
                start, duration, enable = C_Item.GetItemCooldown(entry.itemID)
            elseif entry.spellID and C_Spell and C_Spell.GetSpellCooldown then
                start, duration, enable = C_Spell.GetSpellCooldown(entry.spellID)
            end
            if enable and enable ~= 0 and duration and duration > 0 then
                isOnCooldown = true
            end
            if isOnCooldown then
                button.icon:SetDesaturated(true)
                button.cooldown:SetCooldown(start, duration)
                button.cooldown:Show()
                -- Show cooldown text
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
            -- Only set OnClick for non-secure fallback, and avoid blocked actions
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
        if value == TAB_TELEPORT then tabIdx = 2 end
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

    -- Set the frame title on the title bar, aligned with the close button
    if frame.TitleText then
        frame.TitleText:SetText(Lstr("utility.title", "Utility"))
        frame.TitleText:ClearAllPoints()
        frame.TitleText:SetPoint("LEFT", frame, "TOPLEFT", 60, -4)
        frame.TitleText:SetPoint("RIGHT", frame.CloseButton, "LEFT", -120, 0)
        frame.TitleText:SetJustifyH("LEFT")
        frame.TitleText:Show()
        -- Add compact/list view toggle button
        if not frame.CompactToggle then
            frame.CompactToggle = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
            frame.CompactToggle:SetSize(24, 24)
            frame.CompactToggle:SetPoint("RIGHT", frame.CloseButton, "LEFT", -36, 0)
            frame.CompactToggle:SetText("≡")
            frame.CompactToggle:SetScript("OnClick", function()
                compactView = not compactView
                if compactView then
                    ROW_HEIGHT = 28
                    ICON_SIZE = 20
                else
                    ROW_HEIGHT = 44
                    ICON_SIZE = 36
                end
                -- Clear buttons to force recreation
                for i, btn in ipairs(buttons) do
                    btn:Hide()
                    buttons[i] = nil
                end
                RefreshLayout()
            end)
            frame.CompactToggle:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(compactView and "Switch to Grid View" or "Switch to List View", 1, 1, 1)
                GameTooltip:Show()
            end)
            frame.CompactToggle:SetScript("OnLeave", function() GameTooltip:Hide() end)
        end
        -- Add help/info button
        if not frame.InfoButton then
            frame.InfoButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
            frame.InfoButton:SetSize(24, 24)
            frame.InfoButton:SetPoint("RIGHT", frame.CloseButton, "LEFT", -6, 0)
            frame.InfoButton:SetText("?")
            frame.InfoButton:SetScript("OnClick", function()
                StaticPopup_Show("NOZMIE_UTILITY_HELP")
            end)
            frame.InfoButton:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(Lstr("utility.help.tooltip", "How to use the Utility page"), 1, 1, 1)
                GameTooltip:AddLine("- Double-click star to pin favorite\n- ≡ toggles compact/list view\n- Search: Filter utilities\n- Drag to move window", 1, 1, 1)
                GameTooltip:Show()
            end)
            frame.InfoButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
        end
        -- Register help popup
        if not StaticPopupDialogs["NOZMIE_UTILITY_HELP"] then
            StaticPopupDialogs["NOZMIE_UTILITY_HELP"] = {
                text = Lstr("utility.help.text", "\124cffffd200Nozmie Utility Page\124r\n\n- Double-click star to pin favorite\n- ≡ toggles compact/list view\n- Search: Filter utilities\n- Drag to move window"),
                button1 = OKAY,
                timeout = 0,
                whileDead = true,
                hideOnEscape = true,
            }
        end
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

    -- Reduce header size since only search remains
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
