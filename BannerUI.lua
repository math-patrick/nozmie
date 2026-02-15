-- ============================================================================
-- Nozmie - Banner UI Module
-- Creates and styles the notification banner frame
-- ============================================================================
local Config = Nozmie_Config
local Helpers = Nozmie_Helpers

local BannerUI = {}

local Locale = _G.Nozmie_Locale
local function Lstr(key, fallback)
    if Locale and Locale.GetString then
        return Locale.GetString(key, fallback)
    end
    return fallback or key
end

local function CreateButton(parent, size, point, textures, tooltip, onClick)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(size, size)
    btn:SetPoint(unpack(point))

    if textures then
        if textures.normal or textures[1] then
            btn:SetNormalTexture(textures.normal or textures[1])
        end
        if textures.highlight then
            btn:SetHighlightTexture(textures.highlight)
        end
        if textures.pushed then
            btn:SetPushedTexture(textures.pushed)
        end
    end

    if onClick then
        btn:SetScript("OnClick", onClick)
    end

    if tooltip then
        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(tooltip)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    return btn
end

local function CreateBannerIcon(parent)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(44, 44)
    frame:SetPoint("LEFT", 14, 0)
    frame:EnableMouse(true)

    local background = frame:CreateTexture(nil, "BACKGROUND")
    background:SetSize(38, 38)
    background:SetPoint("CENTER")
    background:SetTexture("Interface\\Buttons\\WHITE8x8")
    background:SetVertexColor(0, 0, 0, 0.35)

    local iconBorder = frame:CreateTexture(nil, "BORDER")
    iconBorder:SetSize(36, 36)
    iconBorder:SetPoint("CENTER")
    iconBorder:SetTexture("Interface\\Buttons\\WHITE8x8")
    iconBorder:SetVertexColor(0, 0, 0, 0.8)

    local texture = frame:CreateTexture(nil, "ARTWORK")
    texture:SetSize(32, 32)
    texture:SetPoint("CENTER")
    texture:SetTexture("Interface\\Icons\\Spell_Arcane_TeleportDalaran")
    texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)

    local border = frame:CreateTexture(nil, "OVERLAY")
    border:SetSize(52, 52)
    border:SetPoint("CENTER")
    border:SetTexture("Interface\\Buttons\\UI-Quickslot2")
    border:SetAlpha(0.85)

    frame:SetScript("OnEnter", function(self)
        local banner = self:GetParent()
        local data = banner and banner.activeData or nil
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if data then
            if data.preferItem and data.itemID then
                GameTooltip:SetItemByID(data.itemID)
            elseif data.spellID then
                GameTooltip:SetSpellByID(data.spellID)
            elseif data.itemID then
                GameTooltip:SetItemByID(data.itemID)
            else
                GameTooltip:SetText(data.spellName or data.name or Lstr("minimap.title", "Nozmie"))
            end
        else
            GameTooltip:SetText(Lstr("minimap.title", "Nozmie"))
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
    title:SetFont(title:GetFont(), 14)
    title:SetPoint("LEFT", iconFrame, "RIGHT", 14, 8)
    title:SetPoint("RIGHT", -46, 8)
    title:SetTextColor(0.9, 0.9, 0.95) -- Subtle light color
    title:SetJustifyH("LEFT")
    title:SetShadowColor(0, 0, 0, 1)
    title:SetShadowOffset(1, -1)

    local subtitle = parent:CreateFontString(nil, "OVERLAY")
    subtitle:SetFontObject("GameFontHighlightSmall")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
    subtitle:SetPoint("RIGHT", -40, 0)
    subtitle:SetText("|cff999999" .. Lstr("banner.clickToTeleport", "Click to teleport") .. "|r") -- Subtle gray
    subtitle:SetJustifyH("LEFT")
    subtitle:SetShadowColor(0, 0, 0, 1)
    subtitle:SetShadowOffset(1, -1)

    return title, subtitle
end

function BannerUI.CreateBanner()
    local banner = CreateFrame("Button", nil, UIParent, "SecureActionButtonTemplate, BackdropTemplate")
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
        insets = {
            left = 11,
            right = 12,
            top = 12,
            bottom = 11
        }
    })
    banner:SetBackdropColor(unpack(Config.COLORS.BACKDROP_NORMAL))
    banner:SetBackdropBorderColor(1, 0.85, 0.4, 0.9)

    local inner = banner:CreateTexture(nil, "BACKGROUND")
    inner:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background-Dark")
    inner:SetPoint("TOPLEFT", 6, -6)
    inner:SetPoint("BOTTOMRIGHT", -6, 6)
    inner:SetVertexColor(1, 1, 1, 0.85)

    banner:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(unpack(Config.COLORS.BORDER_HOVER))
    end)
    banner:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(unpack(Config.COLORS.BORDER_NORMAL))
    end)

    local iconFrame
    banner.icon, iconFrame = CreateBannerIcon(banner)
    banner.title, banner.subtitle = CreateBannerText(banner, iconFrame)

    local dragButton = CreateButton(banner, 16, {"BOTTOMRIGHT", -10, 10}, {
        normal = "Interface\\Cursor\\UI-Cursor-Move",
        highlight = "Interface\\Cursor\\UI-Cursor-Move"
    }, Lstr("ui.dragToMove", "Drag to move"))
    if dragButton:GetHighlightTexture() then
        dragButton:GetHighlightTexture():SetAlpha(0.5)
    end
    dragButton:EnableMouse(true)
    dragButton:RegisterForDrag("LeftButton")
    dragButton:SetScript("OnDragStart", function()
        if not InCombatLockdown() then
            banner:StartMoving()
        end
    end)
    dragButton:SetScript("OnDragStop", function()
        banner:StopMovingOrSizing();
        Helpers.SaveBannerPosition(banner)
    end)
    banner.dragButton = dragButton

    CreateButton(banner, 16, {"TOPRIGHT", -10, -10}, {
        normal = "Interface\\Buttons\\UI-Panel-MinimizeButton-Up",
        highlight = "Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight",
        pushed = "Interface\\Buttons\\UI-Panel-MinimizeButton-Down"
    }, Lstr("ui.close", "Close"), function()
        banner:Hide()
    end)

    banner:SetScript("OnShow", function(self)
        local Settings = Nozmie_Settings
        if Settings and Settings.Get("hideDragIcon") then
            if self.dragButton then
                self.dragButton:Hide()
            end
        else
            if self.dragButton then
                self.dragButton:Show()
            end
        end
    end)

    Helpers.LoadBannerPosition(banner)
    return banner
end

_G.Nozmie_BannerUI = BannerUI
