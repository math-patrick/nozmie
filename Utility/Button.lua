local IconRenderer = _G.Nozmie_IconRenderer

local Button = {}

function Button.Create(parent, iconSize, rowHeight)
    local button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate")
    button:SetSize(1, rowHeight)
    button:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2")
    if button:GetHighlightTexture() then
        button:GetHighlightTexture():SetBlendMode("ADD")
        button:GetHighlightTexture():SetAllPoints(button)
    end
    button:SetClipsChildren(false)

    local iconFrame = IconRenderer.CreateIconFrame(button, iconSize)
    iconFrame:SetPoint("LEFT", button, "LEFT", 14, 0)
    button.icon = iconFrame.icon
    button.name = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    button.name:SetPoint("TOPLEFT", button.icon, "TOPRIGHT", 12, -4)
    button.name:SetPoint("RIGHT", button, "RIGHT", -10, 0)
    button.name:SetJustifyH("LEFT")
    button.category = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    button.category:SetPoint("TOPLEFT", button.name, "BOTTOMLEFT", 0, -2)
    button.category:SetPoint("RIGHT", button.name, "RIGHT", 0, 0)
    button.category:SetJustifyH("LEFT")
    button:EnableMouse(true)
    button:RegisterForClicks("AnyUp", "AnyDown")
    button.cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
    button.cooldown:SetAllPoints(button.icon)
    button.cooldown:Hide()
    button.cooldownText = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    button.cooldownText:SetPoint("CENTER", button.icon, "CENTER", 0, 0)
    button.cooldownText:SetText("")
    button.cooldownText:Hide()
    button:SetScript("OnEnter", function(self)
        local data = self.data
        if not data then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if data.itemID then
            GameTooltip:SetItemByID(data.itemID)
        elseif data.spellID then
            GameTooltip:SetSpellByID(data.spellID)
        else
            GameTooltip:SetText(data.name or "")
        end
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    return button
end

_G.Nozmie_UtilityButton = Button
