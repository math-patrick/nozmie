-- ============================================================================
-- Nozmie - Initialization Module
-- Event registration, chat filtering, and slash commands
-- ============================================================================

local Config = Nozmie_Config
local Detector = Nozmie_Detector
local BannerUI = Nozmie_BannerUI
local BannerController = Nozmie_BannerController
local Settings = Nozmie_Settings
local Minimap = Nozmie_Minimap

local addon = CreateFrame("Frame")
local banner
local pendingMatches = {}

local function QueueMatches(matches)
    for _, match in ipairs(matches) do
        table.insert(pendingMatches, match)
    end
end

_G.Nozmie_ShowOptions = function(options)
    if not options or #options == 0 then
        return
    end
    if InCombatLockdown() then
        QueueMatches(options)
        return
    end
    BannerController.ShowWithOptions(banner, options)
end

_G.Nozmie_ShowLastBanner = function()
    local last = BannerController.GetLastOptions()
    if last and #last > 0 then
        _G.Nozmie_ShowOptions(last)
    else
        print("|cff00ff00Nozmie:|r No recent banner to show.")
    end
end

local function OnChatMessage(self, event, message, sender)
    -- Check if addon is enabled
    if not Settings.Get("enabled") then
        return false
    end
    
    -- Check if this chat type should be monitored
    local shouldMonitor = false
    if event == "CHAT_MSG_SAY" and Settings.Get("detectInSay") then
        shouldMonitor = true
    elseif event == "CHAT_MSG_PARTY" and Settings.Get("detectInParty") then
        shouldMonitor = true
    elseif event == "CHAT_MSG_RAID" and Settings.Get("detectInRaid") then
        shouldMonitor = true
    elseif event == "CHAT_MSG_GUILD" and Settings.Get("detectInGuild") then
        shouldMonitor = true
    elseif event == "CHAT_MSG_WHISPER" and Settings.Get("detectInWhisper") then
        shouldMonitor = true
    end
    
    if not shouldMonitor then
        return false
    end
    
    local matches = Detector.FindMatchingTeleports(message, sender)
    if #matches > 0 and Settings.Get("showBanner") then
        if InCombatLockdown() then
            QueueMatches(matches)
            return false
        end
        BannerController.ShowWithOptions(banner, matches)
    end
    return false
end

local function PrintStats()
    print("|cff00ff00Nozmie:|r Loaded " .. #Nozmie_Data .. " teleport options")
    local counts = {}
    for _, data in ipairs(Nozmie_Data) do
        counts[data.category] = (counts[data.category] or 0) + 1
    end
    for category, count in pairs(counts) do
        print("  " .. category .. ": " .. count)
    end
end

local function HandleCommand(args)
    local cmd = args:lower():trim()
    
    if cmd == "debug" or cmd == "count" then
        PrintStats()
    elseif cmd == "settings" or cmd == "config" or cmd == "options" or cmd == "" then
        Settings.Show()
    elseif cmd:match("^blacklist%s+(.+)") then
        local words = args:match("^blacklist%s+(.+)")
        Settings.Set("blacklistedWords", words)
        print("|cff00ff00Nozmie:|r Blacklist updated to: |cffFFFFFF" .. words)
    elseif cmd == "blacklist" then
        local current = Settings.Get("blacklistedWords") or ""
        if current == "" then
            print("|cff00ff00Nozmie:|r No blacklisted words set.")
        else
            print("|cff00ff00Nozmie:|r Current blacklist: |cffFFFFFF" .. current)
        end
        print("|cffFFFFFF  Usage: /noz blacklist <word1, word2, ...>")
    elseif cmd:match("^test%s+(.+)") then
        local testMessage = cmd:match("^test%s+(.+)")
        print("|cff00ff00Nozmie:|r Testing: '" .. testMessage .. "'")
        OnChatMessage(nil, nil, testMessage)
    elseif cmd == "minimap" or cmd == "mm" then
        Settings.Set("minimapIcon", not Settings.Get("minimapIcon"))
        if Minimap then
            Minimap.UpdateVisibility()
        end
        print("|cff00ff00Nozmie:|r Minimap icon " .. (Settings.Get("minimapIcon") and "enabled" or "disabled") .. ".")
    elseif cmd == "last" then
        _G.Nozmie_ShowLastBanner()
    else
        print("|cff00ff00Nozmie:|r Commands:")
        print("  /noz - Open settings")
        print("  /noz settings - Open settings")
        print("  /noz debug - Show statistics")
        print("  /noz minimap - Toggle minimap icon")
        print("  /noz last - Show last banner")
        print("  /noz blacklist - View current blacklist")
        print("  /noz blacklist <words> - Set blacklisted words (comma-separated)")
        print("  /noz test <keyword> - Test detection")
    end
end

local function Initialize()
    print("|cff00ff00Nozmie:|r Initializing...")
    
    -- Initialize settings database
    Settings.InitializeDB()
    
    -- Create settings panel
    Settings.CreatePanel()
    
    -- Create banner
    banner = BannerUI.CreateBanner()
    
    if Minimap then
        Minimap.Initialize()
    end
    
    -- Register chat event filters
    for _, event in ipairs(Config.CHAT_EVENTS) do
        ChatFrame_AddMessageEventFilter(event, OnChatMessage)
    end
    
    -- Register slash commands
    SLASH_NOZMIE1 = "/nozmie"
    SLASH_NOZMIE2 = "/noz"
    SlashCmdList["NOZMIE"] = HandleCommand
    
    print("|cff00ff00Nozmie|r loaded! Type |cff00ff00/noz|r for settings.")
end

addon:RegisterEvent("ADDON_LOADED")
addon:RegisterEvent("PLAYER_REGEN_ENABLED")
addon:SetScript("OnEvent", function(self, event, loadedAddon)
    if event == "PLAYER_REGEN_ENABLED" then
        if #pendingMatches > 0 and Settings.Get("showBanner") then
            local queued = pendingMatches
            pendingMatches = {}
            BannerController.ShowWithOptions(banner, queued)
        end
        return
    end
    if loadedAddon == "Nozmie" then
        Initialize()
        self:UnregisterEvent("ADDON_LOADED")
    end
end)
