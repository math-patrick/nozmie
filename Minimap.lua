-- ============================================================================
-- Nozmie - Minimap Module
-- Optional minimap icon that can reopen the last banner
-- ============================================================================

local MinimapModule = {}
local minimapButton

local function EnsureButton()
    if minimapButton then return minimapButton end

    minimapButton = CreateFrame("Button", "NozmieMinimapButton", Minimap)
    minimapButton:SetSize(32, 32)
    minimapButton:SetFrameStrata("MEDIUM")
    minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
    minimapButton:SetMovable(false)
    minimapButton:EnableMouse(true)
    minimapButton:RegisterForClicks("AnyUp")

    local bg = minimapButton:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    bg:SetSize(56, 56)
    bg:SetPoint("TOPLEFT", minimapButton, "TOPLEFT", -12, 12)

    local icon = minimapButton:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("Interface\\Icons\\Spell_Holy_BorrowedTime")
    icon:SetSize(18, 18)
    icon:SetPoint("CENTER", 0, 0)
    minimapButton.icon = icon

    minimapButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("Nozmie")
        local last = _G.Nozmie_BannerController and _G.Nozmie_BannerController.GetLastOptions and _G.Nozmie_BannerController.GetLastOptions()
        if last and last[1] then
            local name = last[1].spellName or last[1].name or "Unknown"
            GameTooltip:AddLine("Last banner: " .. name, 0.9, 0.9, 0.9)
        else
            GameTooltip:AddLine("Last banner: (none)", 0.7, 0.7, 0.7)
        end
        GameTooltip:AddLine("Left-click: Show last banner", 1, 1, 1)
        GameTooltip:AddLine("Right-click: Open settings", 1, 1, 1)
        GameTooltip:Show()
    end)
    minimapButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    minimapButton:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            if _G.Nozmie_ShowLastBanner then
                _G.Nozmie_ShowLastBanner()
            end
        elseif button == "RightButton" then
            if _G.Nozmie_Settings then
                _G.Nozmie_Settings.Show()
            end
        end
    end)

    return minimapButton
end

function MinimapModule.Initialize()
    EnsureButton()
    MinimapModule.UpdateVisibility()
end

function MinimapModule.UpdateVisibility()
    if not minimapButton then
        EnsureButton()
    end
    if NozmieDB and NozmieDB.minimapIcon then
        minimapButton:Show()
    else
        minimapButton:Hide()
    end
end

_G.Nozmie_Minimap = MinimapModule
