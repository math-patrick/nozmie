-- ============================================================================
-- Nozmie - Initialization Module
-- Event registration, chat filtering, and slash commands
-- ============================================================================

local Config = Nozmie_Config
local Detector = Nozmie_Detector
local BannerUI = Nozmie_BannerUI
local BannerController = Nozmie_BannerController
local Settings = Nozmie_Settings

local addon = CreateFrame("Frame")
local banner

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
    elseif cmd:match("^test%s+(.+)") then
        local testMessage = cmd:match("^test%s+(.+)")
        print("|cff00ff00Nozmie:|r Testing: '" .. testMessage .. "'")
        OnChatMessage(nil, nil, testMessage)
    else
        print("|cff00ff00Nozmie:|r Commands:")
        print("  /noz - Open settings")
        print("  /noz settings - Open settings")
        print("  /noz debug - Show statistics")
        print("  /noz test <keyword> - Test detection")
    end
end

local function Initialize()
    print("|cff00ff00Nozmie:|r Initializing...")
    
    banner = BannerUI.CreateBanner()
    
    for _, event in ipairs(Config.CHAT_EVENTS) do
        ChatFrame_AddMessageEventFilter(event, OnChatMessage)
    end
    
    SLASH_NOZMIE1 = "/nozmie"
    SLASH_NOZMIE2 = "/noz"
    SlashCmdList["NOZMIE"] = HandleCommand
    
    print("|cff00ff00Nozmie|r loaded! Type |cff00ff00/noz|r for help.")
end

addon:RegisterEvent("ADDON_LOADED")
addon:SetScript("OnEvent", function(self, event, loadedAddon)
    if loadedAddon == "Nozmie" then
        Initialize()
        self:UnregisterEvent("ADDON_LOADED")
    end
end)
