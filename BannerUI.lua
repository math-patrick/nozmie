local Config = EasyPort_Config
local Helpers = EasyPort_Helpers

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
    
    local texture = frame:CreateTexture(nil, "ARTWORK")
    texture:SetSize(36, 36)
    texture:SetPoint("CENTER")
    texture:SetTexture("Interface\\Icons\\Spell_Arcane_TeleportDalaran")
    texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    
    return texture, frame
end

local function CreateBannerText(parent, iconFrame)
    local title = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("LEFT", iconFrame, "RIGHT", 15, 4)
    title:SetPoint("RIGHT", -40, 4)
    title:SetTextColor(unpack(Config.COLORS.TEXT_NORMAL))
    title:SetJustifyH("LEFT")
    title:SetShadowColor(0, 0, 0, 1)
    title:SetShadowOffset(2, -2)
    
    local subtitle = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
    subtitle:SetPoint("RIGHT", -40, 0)
    subtitle:SetText("|cff888888Click to teleport|r")
    subtitle:SetJustifyH("LEFT")
    subtitle:SetShadowColor(0, 0, 0, 0.8)
    subtitle:SetShadowOffset(1, -1)
    
    return title, subtitle
end

function BannerUI.CreateBanner()
    local banner = CreateFrame("Button", "EasyPortBanner", UIParent, "SecureActionButtonTemplate, BackdropTemplate")
    banner:SetSize(Config.BANNER.WIDTH, Config.BANNER.HEIGHT)
    banner:SetFrameStrata("HIGH")
    banner:SetAttribute("type", "macro")
    banner:RegisterForClicks("AnyUp", "AnyDown")
    banner:SetMovable(true)
    banner:SetClampedToScreen(true)
    banner:SetUserPlaced(true)
    banner:EnableMouse(true)
    banner:Hide()
    
    banner:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {left = 4, right = 4, top = 4, bottom = 4}
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
    
    local dragButton = CreateButton(banner, 24, {"RIGHT", -36, 0}, {
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
    
    CreateButton(banner, 24, {"RIGHT", -8, 0}, {
        normal = "Interface\\Buttons\\UI-Panel-MinimizeButton-Up",
        highlight = "Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight",
        pushed = "Interface\\Buttons\\UI-Panel-MinimizeButton-Down"
    }, "Close", function() banner:Hide() end)
    
    Helpers.LoadBannerPosition(banner)
    return banner
end

_G.EasyPort_BannerUI = BannerUI
