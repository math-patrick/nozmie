-- ============================================================================
-- Nozmie - Settings Module
-- In-game settings panel accessible via ESC > Options > Addons > Nozmie
-- ============================================================================

local SettingsModule = {}
local category
local actionSettings = {
    editBlacklist = false,
    resetSettings = false,
    helpInfo = false,
}

-- Initialize settings database
function SettingsModule.InitializeDB()
    if not NozmieDB then
        NozmieDB = {}
    end
    
    -- Default settings with their default values
    local defaults = {
        enabled = true,
        showBanner = true,
        autoHideBanner = true,
        hideDragIcon = false,
        minimapIcon = false,
        bannerTimeout = 10,
        detectInSay = true,
        detectInParty = true,
        detectInRaid = true,
        detectInGuild = true,
        detectInWhisper = true,
        blacklistedWords = "",
    }
    
    -- Apply defaults for any missing settings
    for key, value in pairs(defaults) do
        if NozmieDB[key] == nil then
            NozmieDB[key] = value
        end
    end
end

-- Get a setting value
function SettingsModule.Get(key)
    SettingsModule.InitializeDB()
    return NozmieDB[key]
end

-- Set a setting value
function SettingsModule.Set(key, value)
    SettingsModule.InitializeDB()
    NozmieDB[key] = value
end

-- Create the settings panel using modern Settings API
function SettingsModule.CreatePanel()
    -- Initialize database first
    SettingsModule.InitializeDB()
    
    -- Create main category with vertical layout
    local categoryName = "Nozmie"
    category, layout = _G.Settings.RegisterVerticalLayoutCategory(categoryName)
    _G.Settings.RegisterAddOnCategory(category)
    
    -- Add version info
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Nozmie - Teleport & Utility Helper"))
    
    -- General Section
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("General"))
    
    local variable, name, tooltip = "enabled", "Enable Nozmie", "Enable or disable teleport detection"
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    local variable, name, tooltip = "showBanner", "Show Banner", "Display the teleport banner when matches are found"
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    local variable, name, tooltip = "autoHideBanner", "Auto-hide Banner", "Automatically hide banner after timeout"
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    local variable, name, tooltip = "hideDragIcon", "Hide Drag Icon", "Hide the drag handle on the banner"
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, false)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    local variable, name, tooltip = "minimapIcon", "Minimap Icon", "Show a minimap icon for reopening the last banner"
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, false)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    setting:SetValueChangedCallback(function()
        if _G.Nozmie_Minimap then
            _G.Nozmie_Minimap.UpdateVisibility()
        end
    end)
    
    local variable, name, tooltip = "bannerTimeout", "Banner Timeout (Seconds)", "How long to display the banner before auto-hiding (3-30 seconds)"
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Number, name, 10)
    local options = _G.Settings.CreateSliderOptions(3, 30, 1)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
        return string.format("%d sec", value)
    end)
    _G.Settings.CreateSlider(category, setting, options, tooltip)
    
    -- Chat Detection Section
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Chat Detection"))
    
    local variable, name, tooltip = "detectInSay", "Detect in Say", "Monitor /say chat for teleport requests"
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    local variable, name, tooltip = "detectInParty", "Detect in Party", "Monitor party chat for teleport requests"
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    local variable, name, tooltip = "detectInRaid", "Detect in Raid", "Monitor raid chat for teleport requests"
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    local variable, name, tooltip = "detectInGuild", "Detect in Guild", "Monitor guild chat for teleport requests"
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    local variable, name, tooltip = "detectInWhisper", "Detect in Whisper", "Monitor whispers for teleport requests"
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    -- Blacklist Section
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Blacklist"))
    
    local variable, name, tooltip = "editBlacklist", "Edit Blacklisted Words", "Open a dialog to edit blacklisted words (comma-separated)."
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, actionSettings, _G.Settings.VarType.Boolean, name, false)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    setting:SetValueChangedCallback(function()
        if actionSettings.editBlacklist then
            actionSettings.editBlacklist = false
            if setting.SetValue then
                setting:SetValue(false)
            end
            StaticPopup_Show("NOZMIE_BLACKLIST_INPUT")
        end
    end)
    
    -- Reset Section
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Reset"))
    
    local variable, name, tooltip = "resetSettings", "Reset Settings", "Reset all Nozmie settings to their default values."
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, actionSettings, _G.Settings.VarType.Boolean, name, false)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    setting:SetValueChangedCallback(function()
        if actionSettings.resetSettings then
            actionSettings.resetSettings = false
            if setting.SetValue then
                setting:SetValue(false)
            end
            StaticPopup_Show("NOZMIE_RESET_SETTINGS")
        end
    end)
    
    return category
end

-- Show settings panel
function SettingsModule.Show()
    if category then
        _G.Settings.OpenToCategory(category:GetID())
    end
end

-- Confirmation dialog for blacklist editing
StaticPopupDialogs["NOZMIE_BLACKLIST_INPUT"] = {
    text = "Set blacklisted words (comma-separated):",
    button1 = "Save",
    button2 = "Cancel",
    hasEditBox = true,
    editBoxWidth = 260,
    OnShow = function(self)
        local editBox = self.editBox or self:GetEditBox()
        local current = SettingsModule.Get("blacklistedWords") or ""
        editBox:SetText(current)
        editBox:SetAutoFocus(true)
        editBox:HighlightText()
    end,
    OnAccept = function(self)
        local editBox = self.editBox or self:GetEditBox()
        local value = editBox:GetText() or ""
        SettingsModule.Set("blacklistedWords", value)
        print("|cff00ff00Nozmie:|r Blacklist updated to: |cffFFFFFF" .. value)
    end,
    OnHide = function(self)
        local editBox = self.editBox or self:GetEditBox()
        editBox:SetText("")
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}


-- Confirmation dialog for reset
StaticPopupDialogs["NOZMIE_RESET_SETTINGS"] = {
    text = "Reset all Nozmie settings to default values?\n\n|cffFF0000This will reload your UI.|r",
    button1 = "Reset",
    button2 = "Cancel",
    OnAccept = function()
        -- Reset to defaults
        NozmieDB.enabled = true
        NozmieDB.showBanner = true
        NozmieDB.autoHideBanner = true
        NozmieDB.hideDragIcon = false
        NozmieDB.minimapIcon = false
        NozmieDB.bannerTimeout = 10
        NozmieDB.detectInSay = true
        NozmieDB.detectInParty = true
        NozmieDB.detectInRaid = true
        NozmieDB.detectInGuild = true
        NozmieDB.detectInWhisper = true
        NozmieDB.blacklistedWords = ""
        -- Reload UI to apply changes
        ReloadUI()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

_G.Nozmie_Settings = SettingsModule

