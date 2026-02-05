local Config = EasyPort_Config
local Detector = EasyPort_Detector
local BannerUI = EasyPort_BannerUI
local BannerController = EasyPort_BannerController

local addon = CreateFrame("Frame")
local banner

local function OnChatMessage(self, event, message)
    local matches = Detector.FindMatchingTeleports(message)
    if #matches > 0 then
        BannerController.ShowWithOptions(banner, matches)
    end
    return false
end

local function PrintStats()
    print("|cff00ff00EasyPort:|r Loaded " .. #EasyPort_DungeonData .. " teleport options")
    local counts = {}
    for _, data in ipairs(EasyPort_DungeonData) do
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
    elseif cmd:match("^test%s+(.+)") then
        local testMessage = cmd:match("^test%s+(.+)")
        print("|cff00ff00EasyPort:|r Testing: '" .. testMessage .. "'")
        OnChatMessage(nil, nil, testMessage)
    else
        print("|cff00ff00EasyPort:|r Commands:")
        print("  /ep debug - Show statistics")
        print("  /ep test <keyword> - Test detection")
    end
end

local function Initialize()
    print("|cff00ff00EasyPort:|r Initializing...")
    
    banner = BannerUI.CreateBanner()
    
    for _, event in ipairs(Config.CHAT_EVENTS) do
        ChatFrame_AddMessageEventFilter(event, OnChatMessage)
    end
    
    SLASH_EASYPORT1 = "/easyport"
    SLASH_EASYPORT2 = "/ep"
    SlashCmdList["EASYPORT"] = HandleCommand
    
    print("|cff00ff00EasyPort|r loaded! Type |cff00ff00/ep|r for help.")
end

addon:RegisterEvent("ADDON_LOADED")
addon:SetScript("OnEvent", function(self, event, loadedAddon)
    if loadedAddon == "EasyPort" then
        Initialize()
        self:UnregisterEvent("ADDON_LOADED")
    end
end)
