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

local Locale = _G.Nozmie_Locale
local function Lstr(key, fallback)
    if Locale and Locale.GetString then
        return Locale.GetString(key, fallback)
    end
    return fallback or key
end

-- Initialize settings database
function SettingsModule.InitializeDB()
    if not NozmieDB then
        NozmieDB = {}
    end
    
    -- Default settings with their default values
    local defaults = {
        enabled = true,
        showBanner = true,
        preferPortals = true,
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
    local categoryName = Lstr("addon.name", "Nozmie")
    category, layout = _G.Settings.RegisterVerticalLayoutCategory(categoryName)
    _G.Settings.RegisterAddOnCategory(category)
    
    -- Add version info
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(Lstr("settings.title", "Nozmie - Teleport & Utility Helper")))
    
    -- General Section
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(Lstr("settings.section.general", "General")))
    
    local variable, name, tooltip = "enabled", Lstr("settings.enable", "Enable Nozmie"), Lstr("settings.enable.tooltip", "Enable or disable teleport detection")
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    local variable, name, tooltip = "showBanner", Lstr("settings.showBanner", "Show Banner"), Lstr("settings.showBanner.tooltip", "Display the teleport banner when matches are found")
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)

    local variable, name, tooltip = "preferPortals", Lstr("settings.preferPortals", "Prefer Portals"), Lstr("settings.preferPortals.tooltip", "Prioritize portals over teleports when both match")
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    local variable, name, tooltip = "autoHideBanner", Lstr("settings.autoHideBanner", "Auto-hide Banner"), Lstr("settings.autoHideBanner.tooltip", "Automatically hide banner after timeout")
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    local variable, name, tooltip = "hideDragIcon", Lstr("settings.hideDragIcon", "Hide Drag Icon"), Lstr("settings.hideDragIcon.tooltip", "Hide the drag handle on the banner")
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, false)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    local variable, name, tooltip = "minimapIcon", Lstr("settings.minimapIcon", "Minimap Icon"), Lstr("settings.minimapIcon.tooltip", "Show a minimap icon for reopening the last banner")
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, false)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    setting:SetValueChangedCallback(function()
        if _G.Nozmie_Minimap then
            _G.Nozmie_Minimap.UpdateVisibility()
        end
    end)
    
    local variable, name, tooltip = "bannerTimeout", Lstr("settings.bannerTimeout", "Banner Timeout (Seconds)"), Lstr("settings.bannerTimeout.tooltip", "How long to display the banner before auto-hiding (3-30 seconds)")
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Number, name, 10)
    local options = _G.Settings.CreateSliderOptions(3, 30, 1)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
        return string.format("%d sec", value)
    end)
    _G.Settings.CreateSlider(category, setting, options, tooltip)
    
    -- Chat Detection Section
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(Lstr("settings.section.chat", "Chat Detection")))
    
    local variable, name, tooltip = "detectInSay", Lstr("settings.detectInSay", "Detect in Say"), Lstr("settings.detectInSay.tooltip", "Monitor /say chat for teleport requests")
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    local variable, name, tooltip = "detectInParty", Lstr("settings.detectInParty", "Detect in Party"), Lstr("settings.detectInParty.tooltip", "Monitor party chat for teleport requests")
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    local variable, name, tooltip = "detectInRaid", Lstr("settings.detectInRaid", "Detect in Raid"), Lstr("settings.detectInRaid.tooltip", "Monitor raid chat for teleport requests")
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    local variable, name, tooltip = "detectInGuild", Lstr("settings.detectInGuild", "Detect in Guild"), Lstr("settings.detectInGuild.tooltip", "Monitor guild chat for teleport requests")
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    local variable, name, tooltip = "detectInWhisper", Lstr("settings.detectInWhisper", "Detect in Whisper"), Lstr("settings.detectInWhisper.tooltip", "Monitor whispers for teleport requests")
    local setting = _G.Settings.RegisterAddOnSetting(category, "Nozmie_" .. variable, variable, NozmieDB, _G.Settings.VarType.Boolean, name, true)
    _G.Settings.CreateCheckbox(category, setting, tooltip)
    
    -- Blacklist Section
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(Lstr("settings.section.blacklist", "Blacklist")))
    
    local variable, name, tooltip = "editBlacklist", Lstr("blacklist.edit", "Edit Blacklisted Words"), Lstr("blacklist.edit.tooltip", "Open a dialog to edit blacklisted words (comma-separated).")
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
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(Lstr("settings.section.reset", "Reset")))
    
    local variable, name, tooltip = "resetSettings", Lstr("reset.settings", "Reset Settings"), Lstr("reset.settings.tooltip", "Reset all Nozmie settings to their default values.")
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
    text = Lstr("popup.blacklist.text", "Set blacklisted words (comma-separated):"),
    button1 = Lstr("popup.blacklist.save", "Save"),
    button2 = Lstr("popup.blacklist.cancel", "Cancel"),
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
        local message = string.format(Lstr("cmd.blacklist.updated", "Blacklist updated to: %s"), "|cffFFFFFF" .. value .. "|r")
        print("|cff00ff00Nozmie:|r " .. message)
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
    text = Lstr("popup.reset.text", "Reset all Nozmie settings to default values?\n\n|cffFF0000This will reload your UI.|r"),
    button1 = Lstr("popup.reset.reset", "Reset"),
    button2 = Lstr("popup.reset.cancel", "Cancel"),
    OnAccept = function()
        -- Reset to defaults
        NozmieDB.enabled = true
        NozmieDB.showBanner = true
        NozmieDB.preferPortals = true
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

