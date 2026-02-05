-- ============================================================================
-- Nozmie - Minimap Module
-- Optional minimap icon that can reopen the last banner
-- ============================================================================

local MinimapModule = {}
local minimapButton

local Locale = _G.Nozmie_Locale
local function Lstr(key, fallback)
    if Locale and Locale.GetString then
        return Locale.GetString(key, fallback)
    end
    return fallback or key
end

local function GetAngle()
    if not NozmieDB then
        return 225
    end
    return NozmieDB.minimapAngle or 225
end

local function SetAngle(angle)
    NozmieDB = NozmieDB or {}
    NozmieDB.minimapAngle = angle
end

local function UpdatePosition()
    if not minimapButton then return end
    local angle = math.rad(GetAngle())
    local radius = (Minimap:GetWidth() / 2) + 5
    local x = math.cos(angle) * radius
    local y = math.sin(angle) * radius
    minimapButton:ClearAllPoints()
    minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

local function EnsureButton()
    if minimapButton then return minimapButton end

    minimapButton = CreateFrame("Button", "NozmieMinimapButton", Minimap)
    minimapButton:SetSize(32, 32)
    minimapButton:SetFrameStrata("MEDIUM")
    minimapButton:SetFrameLevel(Minimap:GetFrameLevel() + 8)
    minimapButton:EnableMouse(true)
    minimapButton:RegisterForClicks("AnyUp")
    minimapButton:RegisterForDrag("LeftButton")
    minimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    local icon = minimapButton:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("Interface\\Icons\\Spell_Holy_BorrowedTime")
    icon:SetSize(24, 24)
    icon:SetPoint("CENTER", 0, 0)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    if icon.AddMaskTexture then
        local mask = minimapButton:CreateMaskTexture()
        mask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mask:SetAllPoints(icon)
        icon:AddMaskTexture(mask)
    elseif icon.SetMaskTexture then
        local minimapMask = Minimap and Minimap.GetMaskTexture and Minimap:GetMaskTexture() or nil
        if minimapMask then
            icon:SetMaskTexture(minimapMask)
        else
            icon:SetMaskTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask")
        end
    end
    minimapButton.icon = icon
    local highlight = minimapButton:GetHighlightTexture()
    if highlight then
        highlight:SetBlendMode("ADD")
        highlight:SetAlpha(0.8)
    end

    minimapButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText(Lstr("minimap.title", "Nozmie"))
        local last = _G.Nozmie_BannerController and _G.Nozmie_BannerController.GetLastOptions and _G.Nozmie_BannerController.GetLastOptions()
        if last and last[1] then
            local name = last[1].spellName or last[1].name or Lstr("minimap.unknown", "Unknown")
            local lastLine = string.format(Lstr("minimap.lastBanner", "Last banner: %s"), name)
            GameTooltip:AddLine(lastLine, 0.9, 0.9, 0.9)
        else
            GameTooltip:AddLine(Lstr("minimap.lastBannerNone", "Last banner: (none)"), 0.7, 0.7, 0.7)
        end
        GameTooltip:AddLine(Lstr("minimap.leftClick", "Left-click: Show last banner"), 1, 1, 1)
        GameTooltip:AddLine(Lstr("minimap.rightClick", "Right-click: Open settings"), 1, 1, 1)
        GameTooltip:AddLine(Lstr("minimap.drag", "Drag: Move minimap icon"), 1, 1, 1)
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

    minimapButton:SetScript("OnDragStart", function(self)
        self.isDragging = true
        self:SetScript("OnUpdate", function()
            local mx, my = Minimap:GetCenter()
            local cx, cy = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            cx, cy = cx / scale, cy / scale
            local angle = math.deg(math.atan2(cy - my, cx - mx))
            SetAngle(angle)
            UpdatePosition()
        end)
    end)

    minimapButton:SetScript("OnDragStop", function(self)
        self.isDragging = false
        self:SetScript("OnUpdate", nil)
        UpdatePosition()
    end)

    UpdatePosition()
    return minimapButton
end

function MinimapModule.Initialize()
    EnsureButton()
    MinimapModule.UpdateVisibility()
end

function MinimapModule.UpdateVisibility()
    EnsureButton()
    if NozmieDB and NozmieDB.minimapIcon then
        minimapButton:Show()
    else
        minimapButton:Hide()
    end
end

_G.Nozmie_Minimap = MinimapModule
