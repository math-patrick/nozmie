local Config = EasyPort_Config
local Helpers = EasyPort_Helpers

local SpellbookTab = {}
local tabButton
local contentFrame
local scrollFrame
local teleportButtons = {}

local function GetAvailableTeleportsByCategory()
    local categories = {}
    
    for _, data in ipairs(EasyPort_DungeonData) do
        if Helpers.CanPlayerUseTeleport(data) then
            local cat = data.category or "Other"
            if not categories[cat] then
                categories[cat] = {}
            end
            table.insert(categories[cat], data)
        end
    end
    
    return categories
end

local function UseTeleport(data)
    if InCombatLockdown() then
        print("|cff00ff00EasyPort:|r Cannot use teleports in combat")
        return
    end
    
    if data.spellID then
        CastSpellByID(data.spellID)
    elseif data.itemID then
        UseItemByName(data.itemID)
    end
end

local function CreateTeleportButton(parent, data, index)
    local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
    button:SetSize(200, 32)
    button:SetPoint("TOPLEFT", 10, -10 - ((index - 1) * 36))
    
    button:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 12,
        insets = {left = 3, right = 3, top = 3, bottom = 3}
    })
    button:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
    button:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
    
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(24, 24)
    icon:SetPoint("LEFT", 6, 0)
    
    if data.spellID then
        local iconTexture = C_Spell.GetSpellTexture(data.spellID)
        if iconTexture then icon:SetTexture(iconTexture) end
    elseif data.itemID then
        local iconTexture = C_Item.GetItemIconByID(data.itemID)
        if iconTexture then icon:SetTexture(iconTexture) end
    end
    icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    
    local name = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    name:SetPoint("LEFT", icon, "RIGHT", 8, 0)
    name:SetPoint("RIGHT", -8, 0)
    name:SetJustifyH("LEFT")
    name:SetText(data.name)
    
    local cooldown = Helpers.GetCooldownRemaining(data)
    if cooldown > 0 then
        icon:SetDesaturated(true)
        name:SetTextColor(0.5, 0.5, 0.5)
        button:SetBackdropColor(0.05, 0.05, 0.05, 0.8)
    else
        icon:SetDesaturated(false)
        name:SetTextColor(1, 1, 1)
    end
    
    button:SetScript("OnClick", function()
        UseTeleport(data)
    end)
    
    button:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.8, 0.9, 1, 1)
        self:SetBackdropColor(0.15, 0.15, 0.2, 0.9)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(data.name, 1, 1, 1)
        
        if data.destination then
            GameTooltip:AddLine("Destination: " .. data.destination, 0.7, 0.7, 0.7)
        end
        
        local cd = Helpers.GetCooldownRemaining(data)
        if cd > 0 then
            GameTooltip:AddLine("Cooldown: " .. Helpers.FormatCooldownTime(cd), 1, 0.3, 0.3)
        elseif data.cooldown then
            GameTooltip:AddLine("Cooldown: " .. data.cooldown, 0.5, 0.5, 0.5)
        end
        
        GameTooltip:Show()
    end)
    
    button:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
        local cd = Helpers.GetCooldownRemaining(self.data)
        if cd > 0 then
            self:SetBackdropColor(0.05, 0.05, 0.05, 0.8)
        else
            self:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
        end
        GameTooltip:Hide()
    end)
    
    button.data = data
    return button
end

local function UpdateTeleportList()
    for _, btn in ipairs(teleportButtons) do
        btn:Hide()
    end
    wipe(teleportButtons)
    
    local categories = GetAvailableTeleportsByCategory()
    local yOffset = 0
    
    local categoryOrder = {"M+ Dungeon", "Home", "Mage", "Druid", "Shaman", "Death Knight", "Monk"}
    
    for _, categoryName in ipairs(categoryOrder) do
        local teleports = categories[categoryName]
        if teleports and #teleports > 0 then
            local header = scrollFrame.content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            header:SetPoint("TOPLEFT", 10, -yOffset - 10)
            header:SetText(categoryName)
            header:SetTextColor(1, 0.82, 0)
            table.insert(teleportButtons, header)
            
            yOffset = yOffset + 35
            
            for i, data in ipairs(teleports) do
                local btn = CreateTeleportButton(scrollFrame.content, data, 1)
                btn:ClearAllPoints()
                btn:SetPoint("TOPLEFT", 10, -yOffset - 10)
                table.insert(teleportButtons, btn)
                yOffset = yOffset + 36
            end
            
            yOffset = yOffset + 10
        end
    end
    
    for categoryName, teleports in pairs(categories) do
        local found = false
        for _, cat in ipairs(categoryOrder) do
            if cat == categoryName then found = true; break end
        end
        
        if not found and #teleports > 0 then
            local header = scrollFrame.content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            header:SetPoint("TOPLEFT", 10, -yOffset - 10)
            header:SetText(categoryName)
            header:SetTextColor(1, 0.82, 0)
            table.insert(teleportButtons, header)
            
            yOffset = yOffset + 35
            
            for i, data in ipairs(teleports) do
                local btn = CreateTeleportButton(scrollFrame.content, data, 1)
                btn:ClearAllPoints()
                btn:SetPoint("TOPLEFT", 10, -yOffset - 10)
                table.insert(teleportButtons, btn)
                yOffset = yOffset + 36
            end
            
            yOffset = yOffset + 10
        end
    end
    
    scrollFrame.content:SetHeight(math.max(yOffset + 20, 400))
end

local function CreateContentFrame()
    if contentFrame then return end
    
    contentFrame = CreateFrame("Frame", "EasyPortSpellbookFrame", UIParent, "BasicFrameTemplateWithInset")
    contentFrame:SetSize(300, 450)
    contentFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    contentFrame:SetMovable(true)
    contentFrame:EnableMouse(true)
    contentFrame:RegisterForDrag("LeftButton")
    contentFrame:SetScript("OnDragStart", contentFrame.StartMoving)
    contentFrame:SetScript("OnDragStop", contentFrame.StopMovingOrSizing)
    contentFrame:SetClampedToScreen(true)
    contentFrame:Hide()
    
    scrollFrame = CreateFrame("ScrollFrame", nil, contentFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 12, -32)
    scrollFrame:SetPoint("BOTTOMRIGHT", -28, 12)
    
    scrollFrame.content = CreateFrame("Frame", nil, scrollFrame)
    scrollFrame.content:SetSize(240, 400)
    scrollFrame:SetScrollChild(scrollFrame.content)
    
    contentFrame.TitleText:SetText("Available Portals")
    
    contentFrame.CloseButton:HookScript("OnClick", function() contentFrame:Hide() end)
    
    UpdateTeleportList()
    C_Timer.NewTicker(1, UpdateTeleportList)
end

local function ToggleEasyPortTab()
    if not contentFrame then CreateContentFrame() end
    
    if contentFrame:IsShown() then
        contentFrame:Hide()
    else
        contentFrame:SetAlpha(0)
        contentFrame:Show()
        
        local fadeIn = contentFrame:CreateAnimationGroup()
        local alpha = fadeIn:CreateAnimation("Alpha")
        alpha:SetFromAlpha(0)
        alpha:SetToAlpha(1)
        alpha:SetDuration(0.15)
        alpha:SetSmoothing("OUT")
        fadeIn:Play()
        
        UpdateTeleportList()
    end
end

function SpellbookTab.Initialize()
    if tabButton then return end
    
    tabButton = CreateFrame("Button", "EasyPortMinimapButton", Minimap)
    tabButton:SetSize(32, 32)
    tabButton:SetFrameStrata("MEDIUM")
    tabButton:SetFrameLevel(8)
    tabButton:RegisterForClicks("AnyUp")
    tabButton:RegisterForDrag("LeftButton")
    tabButton:SetMovable(true)
    
    local angle = 210
    local x = math.cos(angle) * 80
    local y = math.sin(angle) * 80
    tabButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
    
    local bg = tabButton:CreateTexture(nil, "BACKGROUND")
    bg:SetSize(20, 20)
    bg:SetPoint("CENTER")
    bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    
    local border = tabButton:CreateTexture(nil, "OVERLAY")
    border:SetSize(52, 52)
    border:SetPoint("TOPLEFT")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    
    local icon = tabButton:CreateTexture(nil, "ARTWORK")
    icon:SetSize(20, 20)
    icon:SetPoint("CENTER")
    icon:SetTexture("Interface\\Icons\\Spell_Arcane_TeleportDalaran")
    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    
    tabButton:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            ToggleEasyPortTab()
        end
    end)
    
    tabButton:SetScript("OnDragStart", function(self)
        self:LockHighlight()
        self:SetScript("OnUpdate", function(self)
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            px, py = px / scale, py / scale
            
            local angle = math.atan2(py - my, px - mx)
            local x = math.cos(angle) * 80
            local y = math.sin(angle) * 80
            
            self:ClearAllPoints()
            self:SetPoint("CENTER", Minimap, "CENTER", x, y)
        end)
    end)
    
    tabButton:SetScript("OnDragStop", function(self)
        self:UnlockHighlight()
        self:SetScript("OnUpdate", nil)
    end)
    
    tabButton:SetScript("OnEnter", function(self)
        self:LockHighlight()
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("EasyPort", 1, 1, 1)
        GameTooltip:AddLine("Click to view all teleports", 0.7, 0.7, 0.7)
        GameTooltip:AddLine("Drag to move", 0.5, 0.5, 0.5)
        GameTooltip:Show()
    end)
    
    tabButton:SetScript("OnLeave", function(self)
        self:UnlockHighlight()
        GameTooltip:Hide()
    end)
    
    tabButton:Show()
end

function SpellbookTab.Toggle()
    ToggleEasyPortTab()
end

_G.EasyPort_SpellbookTab = SpellbookTab
