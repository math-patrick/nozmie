local Config = EasyPort_Config
local Helpers = EasyPort_Helpers

local BannerController = {}

local function UpdateBannerForCooldown(banner, data, remaining)
    banner.icon:SetDesaturated(true)
    banner.title:SetTextColor(unpack(Config.COLORS.TEXT_COOLDOWN))
    banner:SetBackdropColor(unpack(Config.COLORS.BACKDROP_COOLDOWN))
    banner.isOnCooldown = true
    banner.cooldownData = {remaining = remaining, data = data}
    
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
    
    local text = data.destination and ("Teleport to " .. data.destination .. "?")
        or data.itemID and ("Use " .. data.name .. "?")
        or ("Teleport to " .. data.name .. "?")
    
    banner.title:SetText(text)
    
    if totalOptions > 1 then
        banner.subtitle:SetText(string.format("|cff888888Click to use • |r|cff00ff00%d/%d|r", currentIndex, totalOptions))
    else
        banner.subtitle:SetText("|cff888888Click to teleport|r")
    end
end

local function UpdateBannerIcon(banner, data)
    if data.spellID then
        local iconTexture = C_Spell.GetSpellTexture(data.spellID)
        if iconTexture then banner.icon:SetTexture(iconTexture) end
        banner:SetAttribute("type", "spell")
        banner:SetAttribute("spell", data.spellName)
    elseif data.itemID then
        local iconTexture = C_Item.GetItemIconByID(data.itemID)
        if iconTexture then banner.icon:SetTexture(iconTexture) end
        
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
        if banner.leftArrow then banner.leftArrow:Hide() end
        if banner.rightArrow then banner.rightArrow:Hide() end
    end
    
    RefreshBannerDisplay(banner)
    banner.updateTimer = C_Timer.NewTicker(0.5, function() RefreshBannerDisplay(banner) end)
    
    banner:SetScript("PostClick", function(self)
        if self.isOnCooldown and Helpers.IsInAnyGroup() and self.cooldownData then
            local message = string.format("%s is on cooldown (%s)", 
                self.cooldownData.data.spellName or self.cooldownData.data.name,
                Helpers.FormatCooldownTime(self.cooldownData.remaining))
            SendChatMessage(message, Helpers.GetGroupChatChannel())
        end
        UIFrameFadeOut(self, 0.2, 1, 0)
        C_Timer.After(0.2, function() self:Hide() end)
    end)
    
    Helpers.LoadBannerPosition(banner)
    banner:SetAlpha(0)
    banner:Show()
    UIFrameFadeIn(banner, 0.4, 0, 1)
end

_G.EasyPort_BannerController = BannerController
