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
    
    -- Single option - simple click to teleport
    if #matches == 1 then
        local data = matches[1]
        banner:SetSize(320, 60)  -- Reset to default size
        banner.currentData = data
        
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
        local function UpdateSingleCooldown()
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
                banner.text:SetText(string.format("%s is on Cooldown", data.name))
                
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
                banner.subtext:SetText("|cff888888Click to teleport|r")
            end
        end
        
        UpdateSingleCooldown()
        
        -- Update every second
        banner.cooldownTimer = C_Timer.NewTicker(0.5, UpdateSingleCooldown)
        
        -- Handle clicks on cooldown
        banner:SetScript("PostClick", function(self)
            if self.isOnCooldown then
                local inGroup = IsInGroup() or IsInRaid() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
                if inGroup and self.cooldownData then
                    local cd = self.cooldownData
                    local minutes = math.floor(cd.remaining / 60)
                    local seconds = math.floor(cd.remaining % 60)
                    local timeStr = minutes > 0 and string.format("%dm %ds", minutes, seconds) or string.format("%ds", seconds)
                    
                    local channel = IsInRaid() and "RAID" or (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "PARTY")
                    local message = string.format("%s is on cooldown (%s)", cd.data.name, timeStr)
                    SendChatMessage(message, channel)
                end
            end
            
            -- Hide banner
            UIFrameFadeOut(self, 0.2, 1, 0)
            C_Timer.After(0.2, function() self:Hide() end)
        end)
    
    -- Multiple options - show selection buttons
    else
        banner.text:SetText("Choose teleport:")
        banner:SetAttribute("type", nil)
        banner:SetAlpha(1)
        banner:SetBackdropColor(0.05, 0.05, 0.15, 0.95)
        
        -- Create option buttons
        for i, data in ipairs(matches) do
            local btn = banner.optionButtons[i] or CreateFrame("Button", nil, banner, "SecureActionButtonTemplate, BackdropTemplate")
            btn:SetSize(300, 28)
            btn:SetPoint("TOP", banner, "BOTTOM", 0, -(i-1) * 30 - 5)
            btn:RegisterForClicks("AnyUp", "AnyDown")
            btn.data = data
            
            -- Button backdrop
            if not btn.bg then
                btn:SetBackdrop({
                    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
                    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                    tile = true,
                    tileSize = 16,
                    edgeSize = 12,
                    insets = {left = 3, right = 3, top = 3, bottom = 3}
                })
                btn:SetBackdropColor(0.1, 0.1, 0.2, 0.9)
                btn:SetBackdropBorderColor(0.3, 0.6, 1, 1)
                btn.bg = true
            end
            
            -- Button text
            if not btn.label then
                btn.label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                btn.label:SetPoint("LEFT", 8, 0)
                btn.label:SetPoint("RIGHT", -8, 0)
                btn.label:SetJustifyH("LEFT")
            end
            
            -- Set up teleport action
            if data.spellID then
                btn:SetAttribute("type", "spell")
                btn:SetAttribute("spell", data.spellName)
            elseif data.itemID then
                btn:SetAttribute("type", "item")
                btn:SetAttribute("item", "item:" .. data.itemID)
            end
            
            -- Update cooldown display
            local function UpdateButtonCooldown()
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
                    btn.label:SetTextColor(0.5, 0.5, 0.5)
                    btn:SetBackdropColor(0.05, 0.05, 0.1, 0.9)
                    btn.isOnCooldown = true
                    btn.cooldownData = {remaining = cooldownRemaining, data = data}
                    
                    local minutes = math.floor(cooldownRemaining / 60)
                    local seconds = math.floor(cooldownRemaining % 60)
                    local timeStr = minutes > 0 and string.format("%dm %ds", minutes, seconds) or string.format("%ds", seconds)
                    
                    if inGroup then
                        btn.label:SetText(string.format("%s |cff00ff00[%s]|r |cffff0000(%s)|r |cff888888- Click to announce|r", data.name, data.category, timeStr))
                    else
                        btn.label:SetText(string.format("%s |cff00ff00[%s]|r |cffff0000(%s)|r", data.name, data.category, timeStr))
                    end
                else
                    -- Ready to use
                    btn.label:SetTextColor(1, 1, 1)
                    btn:SetBackdropColor(0.1, 0.1, 0.2, 0.9)
                    btn.isOnCooldown = false
                    local cooldownText = data.cooldown and (" |cff888888(" .. data.cooldown .. ")|r") or ""
                    btn.label:SetText(data.name .. " |cff00ff00[" .. data.category .. "]|r" .. cooldownText)
                end
            end
            
            UpdateButtonCooldown()
            
            -- Update every 0.5 seconds
            btn.updateTimer = C_Timer.NewTicker(0.5, UpdateButtonCooldown)
            
            -- Hide banner after click
            btn:SetScript("PostClick", function(self)
                if self.isOnCooldown then
                    local inGroup = IsInGroup() or IsInRaid() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
                    if inGroup and self.cooldownData then
                        local cd = self.cooldownData
                        local minutes = math.floor(cd.remaining / 60)
                        local seconds = math.floor(cd.remaining % 60)
                        local timeStr = minutes > 0 and string.format("%dm %ds", minutes, seconds) or string.format("%ds", seconds)
                        
                        local channel = IsInRaid() and "RAID" or (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "PARTY")
                        local message = string.format("%s is on cooldown (%s)", cd.data.name, timeStr)
                        SendChatMessage(message, channel)
                    end
                end
                
                UIFrameFadeOut(banner, 0.2, 1, 0)
                C_Timer.After(0.2, function()
                    banner:Hide()
                    for _, b in ipairs(banner.optionButtons) do
                        b:Hide()
                        if b.updateTimer then
                            b.updateTimer:Cancel()
                        end
                    end
                end)
            end)
            
            -- Hover effect
            btn:SetScript("OnEnter", function(self)
                local r, g, b = self.label:GetTextColor()
                if r == 1 and g == 1 and b == 1 then  -- Only highlight if not on cooldown
                    self:SetBackdropBorderColor(0.5, 0.8, 1, 1)
                end
            end)
            btn:SetScript("OnLeave", function(self)
                self:SetBackdropBorderColor(0.3, 0.6, 1, 1)
            end)
            
            btn:Show()
            table.insert(banner.optionButtons, btn)
        end
        
        -- Adjust banner height for multiple options
        banner:SetSize(320, 60 + (#matches * 30) + 10)
    end
    
    banner:ClearAllPoints()
    banner:SetPoint("BOTTOM", ChatFrame1, "TOP", 0, 20)
    banner:SetAlpha(0)
    banner:Show()
    
    UIFrameFadeIn(banner, 0.4, 0, 1)
end

-- Export to global scope
_G.EasyPort_UI = EasyPort_UI
