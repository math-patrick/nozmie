-- ============================================================================
-- EasyPort - Banner Controller Module
-- Manages banner behavior, navigation, cooldown updates, and click handling
-- ============================================================================

local Config = EasyPort_Config
local Helpers = EasyPort_Helpers

local BannerController = {}

local function UpdateBannerForCooldown(banner, data, remaining)
    banner.icon:SetDesaturated(true)
    banner.title:SetTextColor(unpack(Config.COLORS.TEXT_COOLDOWN))
    banner:SetBackdropColor(unpack(Config.COLORS.BACKDROP_COOLDOWN))
    banner.isOnCooldown = true
    banner.cooldownData = {
        remaining = remaining,
        data = data
    }

    banner.title:SetText(string.format("%s is on Cooldown", data.spellName or data.name))

    local timeText = Helpers.FormatCooldownTime(remaining)
    if Helpers.IsInAnyGroup() then
        banner.subtitle:SetText("|cffff0000" .. timeText .. "|r |cff888888- Click to announce|r")
    else
        banner.subtitle:SetText("|cffff0000" .. timeText .. "|r")
    end
end

local function UpdateBannerForReady(banner, data, totalOptions, currentIndex)
    banner.icon:SetDesaturated(false)
    banner.title:SetTextColor(unpack(Config.COLORS.TEXT_NORMAL))
    banner:SetBackdropColor(unpack(Config.COLORS.BACKDROP_NORMAL))
    banner.isOnCooldown = false

    -- Context-aware action text based on category
    local actionVerb = "Use"
    if data.category == "M+ Dungeon" or data.category == "Raid" or data.category == "Delve" or data.category == "Home" or
        data.category == "Mage" or data.category == "Druid" or data.category == "Shaman" or data.category ==
        "Death Knight" or data.category == "Monk" or data.category == "Demon Hunter" or data.category == "Toy" then
        actionVerb = "Teleport to"
    elseif data.category and data.category:find("Utility") then
        if data.destination and
            (data.destination:find("Repair") or data.destination:find("Mailbox") or data.destination:find("Transmog") or
                data.destination:find("Anvil")) then
            actionVerb = "Summon"
        elseif data.keywords and
            (tContains(data.keywords, "buff") or tContains(data.keywords, "fort") or tContains(data.keywords, "motw") or
                tContains(data.keywords, "intellect")) then
            actionVerb = "Cast"
        else
            actionVerb = "Use"
        end
    end

    local text = data.destination and (actionVerb .. " " .. data.destination .. "?") or
                     (actionVerb .. " " .. data.name .. "?")

    banner.title:SetText(text)

    -- Context-aware subtitle
    local actionText = "use"
    if actionVerb == "Teleport to" then
        actionText = "teleport"
    elseif actionVerb == "Cast" then
        actionText = "cast"
    elseif actionVerb == "Summon" then
        actionText = "summon"
    end

    -- Show target player if casting on someone specific
    local targetInfo = ""
    if data.targetPlayer then
        targetInfo = string.format(" |cff00ff00on %s|r", data.targetPlayer)
    end

    if totalOptions > 1 then
        banner.subtitle:SetText(string.format(
            "|cff888888Click to %s%s • |r|cff00ff00%d/%d|r |cff888888• Right-click to announce|r", actionText,
            targetInfo, currentIndex, totalOptions))
    else
        banner.subtitle:SetText(string.format("|cff888888Click to %s%s • Right-click to announce|r", actionText, targetInfo))
    end
end

local function UpdateBannerIcon(banner, data)
    if data.spellID then
        local iconTexture = C_Spell.GetSpellTexture(data.spellID)
        if iconTexture then banner.icon:SetTexture(iconTexture) end
        
        -- Use macro targeting for buff spells when a target player is specified
        if data.targetPlayer and (data.category and data.category:find("Utility")) then
            banner:SetAttribute("type", "macro")
            banner:SetAttribute("macrotext", "/cast [@" .. data.targetPlayer .. "] " .. data.spellName)
        else
            banner:SetAttribute("type", "spell")
            banner:SetAttribute("spell", data.spellName)
        end
    elseif data.itemID then
        local iconTexture = C_Item.GetItemIconByID(data.itemID)
        if iconTexture then banner.icon:SetTexture(iconTexture) end
        
        -- Use macro for all items (toys, mounts, consumables)
        banner:SetAttribute("type", "macro")
        banner:SetAttribute("macrotext", "/use item:" .. data.itemID)
    end
end

local function RefreshBannerDisplay(banner)
    local data = banner.options[banner.currentIndex]
    banner.activeData = data
    
    UpdateBannerIcon(banner, data)
    
    local cooldown = Helpers.GetCooldownRemaining(data)
    if cooldown > 0 then
        UpdateBannerForCooldown(banner, data, cooldown)
    else
        UpdateBannerForReady(banner, data, #banner.options, banner.currentIndex)
    end
end

local function CreateNavigationArrows(banner)
    if not banner.leftArrow then
        banner.leftArrow = CreateFrame("Button", nil, banner)
        banner.leftArrow:SetSize(20, 20)
        banner.leftArrow:SetPoint("TOP", banner.icon, "BOTTOM", -11, 2)
        banner.leftArrow:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
        banner.leftArrow:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
        banner.leftArrow:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
        banner.leftArrow:SetScript("OnClick", function()
            banner.currentIndex = (banner.currentIndex - 2) % #banner.options + 1
            RefreshBannerDisplay(banner)
        end)
    end

    if not banner.rightArrow then
        banner.rightArrow = CreateFrame("Button", nil, banner)
        banner.rightArrow:SetSize(20, 20)
        banner.rightArrow:SetPoint("LEFT", banner.leftArrow, "RIGHT", 2, 0)
        banner.rightArrow:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
        banner.rightArrow:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
        banner.rightArrow:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
        banner.rightArrow:SetScript("OnClick", function()
            banner.currentIndex = banner.currentIndex % #banner.options + 1
            RefreshBannerDisplay(banner)
        end)
    end
end

function BannerController.ShowWithOptions(banner, teleportOptions)
    if banner.updateTimer then
        banner.updateTimer:Cancel()
    end

    banner.options = teleportOptions
    banner.currentIndex = 1

    if #teleportOptions > 1 then
        CreateNavigationArrows(banner)
        banner.leftArrow:Show()
        banner.rightArrow:Show()
    else
        if banner.leftArrow then
            banner.leftArrow:Hide()
        end
        if banner.rightArrow then
            banner.rightArrow:Hide()
        end
    end

    RefreshBannerDisplay(banner)
    banner.updateTimer = C_Timer.NewTicker(0.5, function()
        RefreshBannerDisplay(banner)
    end)
    
    banner.lastAnnounceTime = 0  -- Initialize announce debounce
    
    banner:SetScript("PostClick", function(self, button)
        -- Handle right-click for announcements
        if button == "RightButton" then
            local data = self.options[self.currentIndex]
            if data then
                local now = GetTime()
                if now - self.lastAnnounceTime > 1 then  -- 1 second debounce
                    Helpers.AnnounceUtility(data)
                    self.lastAnnounceTime = now
                end
            end
            return
        end
        
        -- Left-click behavior (original working logic)
        if self.isOnCooldown and Helpers.IsInAnyGroup() and self.cooldownData then
            local now = GetTime()
            if now - self.lastAnnounceTime > 1 then  -- 1 second debounce
                local message = string.format("%s is on cooldown (%s)",
                    self.cooldownData.data.spellName or self.cooldownData.data.name,
                    Helpers.FormatCooldownTime(self.cooldownData.remaining))
                SendChatMessage(message, Helpers.GetGroupChatChannel())
                self.lastAnnounceTime = now
            end
        end
        UIFrameFadeOut(self, 0.2, 1, 0)
        C_Timer.After(0.2, function()
            self:Hide()
        end)
    end)

    Helpers.LoadBannerPosition(banner)
    banner:SetAlpha(0)
    banner:Show()
    UIFrameFadeIn(banner, 0.4, 0, 1)
end

_G.EasyPort_BannerController = BannerController
