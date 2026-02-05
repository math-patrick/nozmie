-- EasyPort UI Module
-- Creates and manages the teleport banner

local EasyPort_UI = {}

-- Create the teleport banner
function EasyPort_UI:CreateBanner()
    local banner = CreateFrame("Button", "EasyPortBanner", UIParent, "SecureActionButtonTemplate, BackdropTemplate")
    banner:SetSize(320, 60)
    banner:SetPoint("BOTTOM", ChatFrame1, "TOP", 0, 20)
    banner:SetFrameStrata("HIGH")
    banner:SetAttribute("type", "macro")
    banner:RegisterForClicks("AnyUp", "AnyDown")
    banner:Hide()
    
    -- Make frame movable but don't use Edit Mode
    banner:SetMovable(true)
    banner:SetClampedToScreen(true)
    banner:SetUserPlaced(true)
    banner:EnableMouse(true)
    banner:RegisterForDrag("LeftButton")
    
    -- Backdrop
    banner:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {left = 4, right = 4, top = 4, bottom = 4}
    })
    banner:SetBackdropColor(0.05, 0.05, 0.15, 0.95)
    banner:SetBackdropBorderColor(0.3, 0.6, 1, 1)
    
    -- Hover effects
    local shine = banner:CreateTexture(nil, "OVERLAY")
    shine:SetTexture("Interface\\Cooldown\\star4")
    shine:SetSize(40, 40)
    shine:SetPoint("LEFT", 15, 0)
    shine:SetVertexColor(0.5, 0.8, 1, 0)
    shine:SetBlendMode("ADD")
    
    banner:SetScript("OnEnter", function(self)
        UIFrameFadeIn(shine, 0.3, 0, 0.6)
        self:SetBackdropBorderColor(0.5, 0.8, 1, 1)
    end)
    banner:SetScript("OnLeave", function(self)
        UIFrameFadeOut(shine, 0.3, 0.6, 0)
        self:SetBackdropBorderColor(0.3, 0.6, 1, 1)
    end)
    
    -- Icon
    local iconFrame = CreateFrame("Frame", nil, banner)
    iconFrame:SetSize(40, 40)
    iconFrame:SetPoint("LEFT", 12, 0)
    
    local icon = iconFrame:CreateTexture(nil, "ARTWORK")
    icon:SetSize(36, 36)
    icon:SetPoint("CENTER")
    icon:SetTexture("Interface\\Icons\\Spell_Arcane_TeleportDalaran")
    icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    banner.icon = icon  -- Store for dynamic updates
    
    -- Text
    local text = banner:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    text:SetPoint("LEFT", iconFrame, "RIGHT", 15, 4)
    text:SetPoint("RIGHT", -40, 4)
    text:SetTextColor(1, 1, 1)
    text:SetJustifyH("LEFT")
    text:SetShadowColor(0, 0, 0, 1)
    text:SetShadowOffset(2, -2)
    banner.text = text
    
    -- Subtitle
    local subtext = banner:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    subtext:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -2)
    subtext:SetPoint("RIGHT", -40, 0)
    subtext:SetText("|cff888888Click to teleport|r")
    subtext:SetJustifyH("LEFT")
    subtext:SetShadowColor(0, 0, 0, 0.8)
    subtext:SetShadowOffset(1, -1)
    banner.subtext = subtext
    
    -- Close button
    local closeBtn = CreateFrame("Button", nil, banner)
    closeBtn:SetSize(24, 24)
    closeBtn:SetPoint("RIGHT", -8, 0)
    closeBtn:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
    closeBtn:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
    closeBtn:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
    closeBtn:SetScript("OnClick", function() banner:Hide() end)
    closeBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Close")
        GameTooltip:Show()
    end)
    closeBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    
    -- Dragging (only when not in combat and banner is visible)
    banner:SetScript("OnDragStart", function(self)
        if not InCombatLockdown() then
            self:StartMoving()
        end
    end)
    banner:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        -- Save position
        local point, _, relativePoint, xOfs, yOfs = self:GetPoint()
        if not EasyPortDB then EasyPortDB = {} end
        EasyPortDB.position = {
            point = point,
            relativePoint = relativePoint,
            xOfs = xOfs,
            yOfs = yOfs
        }
    end)
    
    -- Load saved position
    if EasyPortDB and EasyPortDB.position then
        local pos = EasyPortDB.position
        banner:ClearAllPoints()
        banner:SetPoint(pos.point, UIParent, pos.relativePoint, pos.xOfs, pos.yOfs)
    end
    
    return banner
end

-- Show the banner with animation
function EasyPort_UI:ShowBanner(banner, matches)
    -- Hide previous buttons if any
    if banner.optionButtons then
        for _, btn in ipairs(banner.optionButtons) do
            btn:Hide()
            if btn.updateTimer then
                btn.updateTimer:Cancel()
            end
        end
    end
    banner.optionButtons = {}
    
    -- Stop any existing cooldown update
    if banner.cooldownTimer then
        banner.cooldownTimer:Cancel()
    end
    
    -- Store all matches and current index for carousel
    banner.allMatches = matches
    banner.currentIndex = 1
    
    -- Function to update display for current selection
    local function UpdateCarouselDisplay()
        local data = banner.allMatches[banner.currentIndex]
        banner.currentData = data
        banner:SetSize(320, 60)  -- Reset to default size
        
        -- Update icon based on spell/item
        if data.spellID then
            local iconTexture = C_Spell.GetSpellTexture(data.spellID)
            if iconTexture then
                banner.icon:SetTexture(iconTexture)
            end
            banner:SetAttribute("type", "spell")
            banner:SetAttribute("spell", data.spellName)
        elseif data.itemID then
            local iconTexture = C_Item.GetItemIconByID(data.itemID)
            if iconTexture then
                banner.icon:SetTexture(iconTexture)
            end
            banner:SetAttribute("type", "item")
            banner:SetAttribute("item", "item:" .. data.itemID)
        end
        
        -- Update cooldown display
        local function UpdateCooldown()
            local cooldownRemaining = 0
            local onCooldown = false
            
            if data.spellID then
                local spellInfo = C_Spell.GetSpellCooldown(data.spellID)
                if spellInfo and spellInfo.startTime > 0 then
                    cooldownRemaining = spellInfo.startTime + spellInfo.duration - GetTime()
                    if cooldownRemaining > 0 then
                        onCooldown = true
                    end
                end
            elseif data.itemID then
                local start, duration = C_Item.GetItemCooldown(data.itemID)
                if start > 0 and duration > 0 then
                    cooldownRemaining = start + duration - GetTime()
                    if cooldownRemaining > 0 then
                        onCooldown = true
                    end
                end
            end
            
            local inGroup = IsInGroup() or IsInRaid() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
            
            if onCooldown and cooldownRemaining > 0 then
                -- Grey out and show cooldown
                banner.icon:SetDesaturated(true)
                banner.text:SetTextColor(0.5, 0.5, 0.5)
                banner:SetBackdropColor(0.03, 0.03, 0.1, 0.95)
                banner.isOnCooldown = true
                banner.cooldownData = {remaining = cooldownRemaining, data = data}
                
                local minutes = math.floor(cooldownRemaining / 60)
                local seconds = math.floor(cooldownRemaining % 60)
                local timeStr = minutes > 0 and string.format("%dm %ds", minutes, seconds) or string.format("%ds", seconds)
                local displayName = data.spellName or data.name
                banner.text:SetText(string.format("%s is on Cooldown", displayName))
                
                if inGroup then
                    banner.subtext:SetText("|cffff0000" .. timeStr .. "|r |cff888888- Click to announce|r")
                else
                    banner.subtext:SetText(string.format("|cffff0000%s|r", timeStr))
                end
            else
                -- Ready to use
                banner.icon:SetDesaturated(false)
                banner.text:SetTextColor(1, 1, 1)
                banner:SetBackdropColor(0.05, 0.05, 0.15, 0.95)
                banner.isOnCooldown = false
                
                -- Determine text based on type
                local displayText
                if data.destination then
                    displayText = "Teleport to " .. data.destination .. "?"
                elseif data.itemID then
                    displayText = "Use " .. data.name .. "?"
                else
                    displayText = "Teleport to " .. data.name .. "?"
                end
                
                banner.text:SetText(displayText)
                
                -- Show carousel counter if multiple options
                if #banner.allMatches > 1 then
                    banner.subtext:SetText(string.format("|cff888888Click to use • |r|cff00ff00%d/%d|r", banner.currentIndex, #banner.allMatches))
                else
                    banner.subtext:SetText("|cff888888Click to teleport|r")
                end
            end
        end
        
        UpdateCooldown()
        
        -- Update every second
        if banner.cooldownTimer then
            banner.cooldownTimer:Cancel()
        end
        banner.cooldownTimer = C_Timer.NewTicker(0.5, UpdateCooldown)
    end
    
    -- Create or show navigation arrows if multiple options
    if #matches > 1 then
        -- Left arrow
        if not banner.leftArrow then
            banner.leftArrow = CreateFrame("Button", nil, banner)
            banner.leftArrow:SetSize(20, 20)
            banner.leftArrow:SetPoint("TOP", banner.icon, "BOTTOM", -11, 2)
            banner.leftArrow:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
            banner.leftArrow:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
            banner.leftArrow:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
            banner.leftArrow:SetScript("OnClick", function()
                banner.currentIndex = banner.currentIndex - 1
                if banner.currentIndex < 1 then
                    banner.currentIndex = #banner.allMatches
                end
                UpdateCarouselDisplay()
            end)
        end
        banner.leftArrow:Show()
        
        -- Right arrow
        if not banner.rightArrow then
            banner.rightArrow = CreateFrame("Button", nil, banner)
            banner.rightArrow:SetSize(20, 20)
            banner.rightArrow:SetPoint("LEFT", banner.leftArrow, "RIGHT", 2, 0)
            banner.rightArrow:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
            banner.rightArrow:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
            banner.rightArrow:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
            banner.rightArrow:SetScript("OnClick", function()
                banner.currentIndex = banner.currentIndex + 1
                if banner.currentIndex > #banner.allMatches then
                    banner.currentIndex = 1
                end
                UpdateCarouselDisplay()
            end)
        end
        banner.rightArrow:Show()
    else
        -- Hide arrows if only one option
        if banner.leftArrow then banner.leftArrow:Hide() end
        if banner.rightArrow then banner.rightArrow:Hide() end
    end
    
    -- Initial display
    UpdateCarouselDisplay()
    
    -- Handle clicks
    banner:SetScript("PostClick", function(self)
        if self.isOnCooldown then
            local inGroup = IsInGroup() or IsInRaid() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
            if inGroup and self.cooldownData then
                local cd = self.cooldownData
                local minutes = math.floor(cd.remaining / 60)
                local seconds = math.floor(cd.remaining % 60)
                local timeStr = minutes > 0 and string.format("%dm %ds", minutes, seconds) or string.format("%ds", seconds)
                
                local channel = IsInRaid() and "RAID" or (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "PARTY")
                local displayName = cd.data.spellName or cd.data.name
                local message = string.format("%s is on cooldown (%s)", displayName, timeStr)
                SendChatMessage(message, channel)
            end
        end
        
        -- Hide banner
        UIFrameFadeOut(self, 0.2, 1, 0)
        C_Timer.After(0.2, function() self:Hide() end)
    end)
    
    -- Restore saved position or use default
    if EasyPortDB and EasyPortDB.position then
        local pos = EasyPortDB.position
        banner:ClearAllPoints()
        banner:SetPoint(pos.point, UIParent, pos.relativePoint, pos.xOfs, pos.yOfs)
    else
        banner:ClearAllPoints()
        banner:SetPoint("BOTTOM", ChatFrame1, "TOP", 0, 20)
    end
    banner:SetAlpha(0)
    banner:Show()
    
    UIFrameFadeIn(banner, 0.4, 0, 1)
end

-- Export to global scope
_G.EasyPort_UI = EasyPort_UI
