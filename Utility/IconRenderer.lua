local Locale = _G.Nozmie_Locale
local function Lstr(key, fallback)
    if Locale and Locale.GetString then
        return Locale.GetString(key, fallback)
    end
    return fallback or key
end

local IconRenderer = {}

function IconRenderer.CreateIconFrame(parent, iconSize)
    iconSize = iconSize or 36
    local frameSize = iconSize + 20
    
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(frameSize, frameSize)
    frame:SetClipsChildren(false)
    frame:EnableMouse(false)

    -- Inner icon texture (what gets replaced at runtime)
    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetSize(iconSize, iconSize)
    icon:SetPoint("CENTER")
    icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    frame.icon = icon

    -- Border frame (for texture replacements)
    local border = frame:CreateTexture(nil, "OVERLAY")
    border:SetSize(frameSize, frameSize)
    border:SetPoint("CENTER")
    border:SetTexture("Interface\\Buttons\\UI-Quickslot2")
    border:SetAlpha(0.85)
    frame.border = border

    return frame
end

function IconRenderer.ApplyTooltip(iconFrame)
    iconFrame:EnableMouse(true)
    
    iconFrame:SetScript("OnEnter", function(self)
        local parent = self:GetParent()
        local data = parent.activeData or parent.data
        if not data then return end
        
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if data.preferItem and data.itemID then
            GameTooltip:SetItemByID(data.itemID)
        elseif data.spellID then
            GameTooltip:SetSpellByID(data.spellID)
        elseif data.itemID then
            GameTooltip:SetItemByID(data.itemID)
        else
            GameTooltip:SetText(data.spellName or data.name or Lstr("minimap.title", "Nozmie"))
        end
        GameTooltip:Show()
    end)
    
    iconFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

_G.Nozmie_IconRenderer = IconRenderer
