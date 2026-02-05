-- ============================================================================
-- Nozmie - Banner UI Module
-- Creates and styles the notification banner frame
-- ============================================================================

local Config = Nozmie_Config
local Helpers = Nozmie_Helpers

local BannerUI = {}

local function CreateButton(parent, size, point, textures, tooltip, onClick)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(size, size)
    btn:SetPoint(unpack(point))
    
    if textures then
        if textures.normal or textures[1] then btn:SetNormalTexture(textures.normal or textures[1]) end
        if textures.highlight then btn:SetHighlightTexture(textures.highlight) end
        if textures.pushed then btn:SetPushedTexture(textures.pushed) end
    end
    
    if onClick then btn:SetScript("OnClick", onClick) end
    
    if tooltip then
        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(tooltip)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end
    
    return btn
end

local function CreateBannerIcon(parent)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(40, 40)
    frame:SetPoint("LEFT", 12, 0)
    frame:EnableMouse(true)
    
    local texture = frame:CreateTexture(nil, "ARTWORK")
    texture:SetSize(36, 36)
    texture:SetPoint("CENTER")
    texture:SetTexture("Interface\\Icons\\Spell_Arcane_TeleportDalaran")
    texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)

    frame:SetScript("OnEnter", function(self)
        local banner = self:GetParent()
        local data = banner and banner.activeData or nil
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if data then
            if data.spellID then
                GameTooltip:SetSpellByID(data.spellID)
            elseif data.itemID then
                GameTooltip:SetItemByID(data.itemID)
            else
                GameTooltip:SetText(data.spellName or data.name or "Nozmie")
            end
        else
            GameTooltip:SetText("Nozmie")
        end
        GameTooltip:Show()
    end)
    frame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    
    return texture, frame
end

local function CreateBannerText(parent, iconFrame)
    local title = parent:CreateFontString(nil, "OVERLAY")
    title:SetFontObject("SystemFont_Shadow_Large")
    title:SetFont(title:GetFont(), 13)  -- Slightly smaller font
    title:SetPoint("LEFT", iconFrame, "RIGHT", 15, 4)
    title:SetPoint("RIGHT", -40, 4)
    title:SetTextColor(0.9, 0.9, 0.95)  -- Subtle light color
    title:SetJustifyH("LEFT")
    title:SetShadowColor(0, 0, 0, 1)
    title:SetShadowOffset(1, -1)
    
    local subtitle = parent:CreateFontString(nil, "OVERLAY")
    subtitle:SetFontObject("GameFontHighlightSmall")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
    subtitle:SetPoint("RIGHT", -40, 0)
    subtitle:SetText("|cff999999Click to teleport|r")  -- Subtle gray
    subtitle:SetJustifyH("LEFT")
    subtitle:SetShadowColor(0, 0, 0, 1)
    subtitle:SetShadowOffset(1, -1)
    
    return title, subtitle
end

function BannerUI.CreateBanner()
    local banner = CreateFrame("Button", "NozmieBanner", UIParent, "SecureActionButtonTemplate, BackdropTemplate")
    banner:SetSize(Config.BANNER.WIDTH, Config.BANNER.HEIGHT)
    banner:SetFrameStrata("HIGH")
    banner:SetAttribute("type", "macro")
    banner:RegisterForClicks("AnyUp", "AnyDown")
    banner:RegisterForDrag("LeftButton")
    banner:SetMovable(true)
    banner:SetClampedToScreen(true)
    banner:SetUserPlaced(true)
    banner:EnableMouse(true)
    banner:Hide()
    
    banner:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = {left = 11, right = 12, top = 12, bottom = 11}
    })
    banner:SetBackdropColor(unpack(Config.COLORS.BACKDROP_NORMAL))
    banner:SetBackdropBorderColor(unpack(Config.COLORS.BORDER_NORMAL))
    
    local shine = banner:CreateTexture(nil, "OVERLAY")
    shine:SetTexture("Interface\\Cooldown\\star4")
    shine:SetSize(40, 40)
    shine:SetPoint("LEFT", 15, 0)
    shine:SetVertexColor(0.5, 0.8, 1, 0)
    shine:SetBlendMode("ADD")
    
    banner:SetScript("OnEnter", function(self)
        UIFrameFadeIn(shine, 0.3, 0, 0.6)
        self:SetBackdropBorderColor(unpack(Config.COLORS.BORDER_HOVER))
    end)
    banner:SetScript("OnLeave", function(self)
        UIFrameFadeOut(shine, 0.3, 0.6, 0)
        self:SetBackdropBorderColor(unpack(Config.COLORS.BORDER_NORMAL))
    end)
    
    local iconFrame
    banner.icon, iconFrame = CreateBannerIcon(banner)
    banner.title, banner.subtitle = CreateBannerText(banner, iconFrame)
    
    local dragButton = CreateButton(banner, 16, {"BOTTOMRIGHT", -8, 8}, {
        normal = "Interface\\Cursor\\UI-Cursor-Move",
        highlight = "Interface\\Cursor\\UI-Cursor-Move"
    }, "Drag to move")
    if dragButton:GetHighlightTexture() then
        dragButton:GetHighlightTexture():SetAlpha(0.5)
    end
    dragButton:EnableMouse(true)
    dragButton:RegisterForDrag("LeftButton")
    dragButton:SetScript("OnDragStart", function() if not InCombatLockdown() then banner:StartMoving() end end)
    dragButton:SetScript("OnDragStop", function() banner:StopMovingOrSizing(); Helpers.SaveBannerPosition(banner) end)
    banner.dragButton = dragButton
    
    CreateButton(banner, 16, {"TOPRIGHT", -8, -8}, {
        normal = "Interface\\Buttons\\UI-Panel-MinimizeButton-Up",
        highlight = "Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight",
        pushed = "Interface\\Buttons\\UI-Panel-MinimizeButton-Down"
    }, "Close", function() banner:Hide() end)
    
    banner.isDragging = false
    banner:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" and IsAltKeyDown() and not InCombatLockdown() then
            self:StartMoving()
            self.isDragging = true
        end
    end)
    banner:SetScript("OnMouseUp", function(self, button)
        if self.isDragging then
            self:StopMovingOrSizing()
            self.isDragging = false
            Helpers.SaveBannerPosition(self)
        end
    end)
    banner:SetScript("OnShow", function(self)
        local Settings = Nozmie_Settings
        if Settings and Settings.Get("hideDragIcon") then
            if self.dragButton then self.dragButton:Hide() end
        else
            if self.dragButton then self.dragButton:Show() end
        end
    end)
    
    Helpers.LoadBannerPosition(banner)
    return banner
end

_G.Nozmie_BannerUI = BannerUI
