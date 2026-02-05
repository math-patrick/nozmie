-- ============================================================================
-- Nozmie - Banner Controller Module
-- Manages banner behavior, navigation, cooldown updates, and click handling
-- ============================================================================

local Config = Nozmie_Config
local Helpers = Nozmie_Helpers
local BannerUI = Nozmie_BannerUI

local BannerController = {}
local RefreshBannerDisplay

local Locale = _G.Nozmie_Locale
local function Lstr(key, fallback)
    if Locale and Locale.GetString then
        return Locale.GetString(key, fallback)
    end
    return fallback or key
end

local STACK_GAP = 8
local lastOptions

local function GetOptionKey(data)
    if data.spellID then
        return "spell:" .. data.spellID
    end
    if data.itemID then
        return "item:" .. data.itemID
    end
    return "name:" .. tostring(data.name or data.spellName or "")
end

local function GetBaseAnchor(root)
    if not root.baseAnchor then
        local point, relativeTo, relativePoint, xOfs, yOfs = root:GetPoint()
        root.baseAnchor = {
            point = point or "BOTTOM",
            relativeTo = relativeTo or UIParent,
            relativePoint = relativePoint or "BOTTOM",
            xOfs = xOfs or 0,
            yOfs = yOfs or 0,
        }
    end
    return root.baseAnchor
end

local function GetStackAnchor(root, index)
    local base = GetBaseAnchor(root)
    return {
        point = base.point,
        relativeTo = base.relativeTo,
        relativePoint = base.relativePoint,
        xOfs = base.xOfs,
        yOfs = base.yOfs + (Config.BANNER.HEIGHT + STACK_GAP) * index,
    }
end

local function ApplyAnchor(frame, anchor)
    frame:ClearAllPoints()
    frame:SetPoint(anchor.point, anchor.relativeTo, anchor.relativePoint, anchor.xOfs, anchor.yOfs)
end

local function SlideToAnchor(frame, anchor, duration, onFinished)
    local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
    relativeTo = relativeTo or UIParent
    local dx = (anchor.xOfs or 0) - (xOfs or 0)
    local dy = (anchor.yOfs or 0) - (yOfs or 0)

    if dx == 0 and dy == 0 then
        ApplyAnchor(frame, anchor)
        if onFinished then onFinished() end
        return
    end

    if frame.slideAnim then
        frame.slideAnim:Stop()
    end

    frame.slideAnim = frame:CreateAnimationGroup()
    local translate = frame.slideAnim:CreateAnimation("Translation")
    translate:SetDuration(duration or 0.2)
    translate:SetOffset(dx, dy)
    frame.slideAnim:SetScript("OnFinished", function()
        ApplyAnchor(frame, anchor)
        if onFinished then onFinished() end
    end)
    frame.slideAnim:Play()
end

local function ReflowStack(root)
    if not root.stack then return end
    for index, frame in ipairs(root.stack) do
        local anchor = GetStackAnchor(root, index)
        SlideToAnchor(frame, anchor, 0.2)
    end
end

local function PromoteNextBanner(root)
    if not root.stack or #root.stack == 0 then
        return
    end

    local nextBanner = table.remove(root.stack, 1)
    local baseAnchor = GetBaseAnchor(root)

    root.ignoreHide = true
    root:SetAlpha(0)

    SlideToAnchor(nextBanner, baseAnchor, 0.2, function()
        root.options = nextBanner.options
        root.currentIndex = nextBanner.currentIndex or 1
        root.newItemUntil = nil
        root.isOnCooldown = false
        root.cooldownData = nil
        RefreshBannerDisplay(root)
        root:Show()
        UIFrameFadeIn(root, 0.2, 0, 1)
        nextBanner.ignoreHide = true
        nextBanner:Hide()
        nextBanner.ignoreHide = false
        ReflowStack(root)
        root.ignoreHide = false
    end)
end


local function UpdateBannerForCooldown(banner, data, remaining)
    banner.icon:SetDesaturated(true)
    banner.title:SetTextColor(unpack(Config.COLORS.TEXT_COOLDOWN))
    banner:SetBackdropColor(unpack(Config.COLORS.BACKDROP_COOLDOWN))
    banner.isOnCooldown = true
    banner.cooldownData = {
        remaining = remaining,
        data = data
    }

    local cooldownTitle = string.format(Lstr("banner.cooldownTitle", "%s is on cooldown"), data.spellName or data.name)
    banner.title:SetText(cooldownTitle)

    local timeText = Helpers.FormatCooldownTime(remaining)
    if Helpers.IsInAnyGroup() then
        local suffix = Lstr("banner.cooldownSuffix", " - Click to announce")
        banner.subtitle:SetText("|cffff0000" .. timeText .. "|r |cff888888" .. suffix .. "|r")
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
    local actionVerb = Lstr("banner.action.use", "Use")
    if data.category == "M+ Dungeon" or data.category == "Raid" or data.category == "Delve" or data.category == "Home" or
        data.category == "Class" or data.category == "Toy" then
        actionVerb = Lstr("banner.action.teleport", "Teleport to")
    elseif data.category and data.category:find("Utility") then
        if data.destination and
            (data.destination:find("Repair") or data.destination:find("Mailbox") or data.destination:find("Transmog") or
                data.destination:find("Anvil")) then
            actionVerb = Lstr("banner.action.summon", "Summon")
        elseif data.keywords and
            (tContains(data.keywords, "buff") or tContains(data.keywords, "fort") or tContains(data.keywords, "motw") or
                tContains(data.keywords, "intellect")) then
            actionVerb = Lstr("banner.action.cast", "Cast")
        else
            actionVerb = Lstr("banner.action.use", "Use")
        end
    end

    local text = string.format(Lstr("banner.titleWithDestination", "%s %s?"), actionVerb, data.destination or data.name)

    banner.title:SetText(text)

    -- Context-aware subtitle
    local actionText = Lstr("banner.actionText.use", "use")
    if actionVerb == Lstr("banner.action.teleport", "Teleport to") then
        actionText = Lstr("banner.actionText.teleport", "teleport")
    elseif actionVerb == Lstr("banner.action.cast", "Cast") then
        actionText = Lstr("banner.actionText.cast", "cast")
    elseif actionVerb == Lstr("banner.action.summon", "Summon") then
        actionText = Lstr("banner.actionText.summon", "summon")
    end

    -- Show target player if casting on someone specific
    local targetInfo = ""
    local playerName = UnitName("player")
    if data.targetPlayer and data.targetPlayer ~= playerName then
        targetInfo = string.format(" |cff00ff00" .. Lstr("banner.targetInfo", " on %s") .. "|r", data.targetPlayer)
    end

    if totalOptions > 1 then
        local prefix = string.format(Lstr("banner.subtitlePrefix", "Click to %s%s"), actionText, targetInfo)
        local count = string.format(Lstr("banner.subtitleCount", "%d/%d"), currentIndex, totalOptions)
        local suffix = Lstr("banner.subtitleSuffix", "Right-click to announce")
        banner.subtitle:SetText("|cff888888" .. prefix .. " • |r|cff00ff00" .. count .. "|r |cff888888• " .. suffix .. "|r")
    else
        local prefix = string.format(Lstr("banner.subtitlePrefix", "Click to %s%s"), actionText, targetInfo)
        local suffix = Lstr("banner.subtitleSuffix", "Right-click to announce")
        banner.subtitle:SetText("|cff888888" .. prefix .. " • " .. suffix .. "|r")
    end
end

local function UpdateBannerIcon(banner, data)
    if data.spellID then
        local iconTexture = C_Spell.GetSpellTexture(data.spellID)
        if iconTexture then banner.icon:SetTexture(iconTexture) end
        
        -- Use macro targeting for buff spells when a target player is specified
        local playerName = UnitName("player")
        if data.targetPlayer and data.targetPlayer ~= playerName and (data.category and data.category:find("Utility")) then
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
    -- Prevent right-click from triggering secure actions
    banner:SetAttribute("type2", "none")
    banner:SetAttribute("macrotext2", nil)
    banner:SetAttribute("spell2", nil)
    banner:SetAttribute("item2", nil)
end

RefreshBannerDisplay = function(banner)
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

function BannerController.ShowWithOptions(banner, teleportOptions, isStacked)
    lastOptions = teleportOptions
    if not isStacked and banner:IsShown() then
        banner.stack = banner.stack or {}
        local stackedBanner = BannerUI.CreateBanner()
        stackedBanner.stackRoot = banner
        table.insert(banner.stack, stackedBanner)
        BannerController.ShowWithOptions(stackedBanner, teleportOptions, true)
        local anchor = GetStackAnchor(banner, #banner.stack)
        ApplyAnchor(stackedBanner, anchor)
        return
    end

    if banner.updateTimer then
        banner.updateTimer:Cancel()
    end
    
    if banner.autoHideTimer then
        banner.autoHideTimer:Cancel()
    end

    banner.options = teleportOptions
    banner.currentIndex = 1

    if #banner.options > 1 then
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
        -- Cancel auto-hide timer when user interacts with banner
        if self.autoHideTimer then
            self.autoHideTimer:Cancel()
        end
        
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
                    local message = string.format(Lstr("banner.cooldownAnnounce", "%s is on cooldown (%s)"),
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

    banner:SetScript("OnHide", function(self)
        if self.ignoreHide then return end
        if self.updateTimer then
            self.updateTimer:Cancel()
            self.updateTimer = nil
        end
        if self.autoHideTimer then
            self.autoHideTimer:Cancel()
            self.autoHideTimer = nil
        end
        local root = self.stackRoot or self
        if self ~= root then
            if root.stack then
                for index, frame in ipairs(root.stack) do
                    if frame == self then
                        table.remove(root.stack, index)
                        break
                    end
                end
            end
            ReflowStack(root)
            return
        end

        if root.stack and #root.stack > 0 then
            PromoteNextBanner(root)
        end
    end)

    if not banner.stackRoot then
        Helpers.LoadBannerPosition(banner)
        banner.baseAnchor = nil
        GetBaseAnchor(banner)
    end
    banner:SetAlpha(0)
    banner:Show()
    UIFrameFadeIn(banner, 0.4, 0, 1)
    
    -- Auto-hide banner if enabled
    local Settings = Nozmie_Settings
    if Settings.Get("autoHideBanner") then
        local timeout = Settings.Get("bannerTimeout") or 10
        banner.autoHideTimer = C_Timer.NewTimer(timeout, function()
            if banner:IsShown() and not banner.isOnCooldown then
                UIFrameFadeOut(banner, 0.3, 1, 0)
                C_Timer.After(0.3, function()
                    banner:Hide()
                    if banner.updateTimer then
                        banner.updateTimer:Cancel()
                    end
                end)
            end
        end)
    end
end

function BannerController.GetLastOptions()
    return lastOptions
end

_G.Nozmie_BannerController = BannerController
