-- Utility/Button.lua
-- DRY, KISS, Clean button creation for UtilityUI

local Button = {}

function Button.Create(parent, iconSize, rowHeight)
    local button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate")
    button:SetSize(1, rowHeight)
    button:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2")
    if button:GetHighlightTexture() then
        button:GetHighlightTexture():SetBlendMode("ADD")
        button:GetHighlightTexture():SetAllPoints(button)
    end
    button.icon = button.Icon or button.icon
    if not button.icon then
        button.icon = button:CreateTexture(nil, "ARTWORK")
    end
    button.icon:SetSize(iconSize, iconSize)
    button.icon:SetPoint("LEFT", button, "LEFT", 14, 0)
    button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    button.border = button.IconBorder or button.Border
    if not button.border then
        button.border = button:CreateTexture(nil, "OVERLAY")
        button.border:SetTexture("Interface\\Buttons\\UI-Quickslot2")
    end
    button.border:SetSize(iconSize + 22, iconSize + 22)
    button.border:SetPoint("CENTER", button.icon, "CENTER", 0, 0)
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
