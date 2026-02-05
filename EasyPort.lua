-- EasyPort: Mythic+ Dungeon Teleport Helper
-- Main addon file

local addonName = "EasyPort"
local EasyPort = CreateFrame("Frame")

-- Initialize banner
local banner

-- Detect teleport options in chat
local function DetectDungeon(self, event, msg, ...)
    local lowerMsg = msg:lower()
    local matches = {}
    local addedOptions = {}  -- Track which options we've already added
    
    -- Search through all teleport options
    for _, data in ipairs(EasyPort_DungeonData) do
        -- Check each keyword for this teleport option
        if data.keywords and not addedOptions[data.name] then
            local keywordMatch = false
            for _, keyword in ipairs(data.keywords) do
                if lowerMsg:find(keyword, 1, true) then
                    keywordMatch = true
                    break
                end
            end
            
            if keywordMatch then
                -- Check if player can use this teleport
                local canUse = false
                
                -- Check itemID first (hearthstones, toys, items)
                if data.itemID then
                    -- For toys, check if player has it
                    if PlayerHasToy(data.itemID) then
                        canUse = true
                    -- For items, check if player has it in bags
                    elseif C_Item.GetItemCount(data.itemID, false, false, false) > 0 then
                        canUse = true
                    end
                elseif data.spellID then
                    -- Check if it's a spell (either known or granted by item)
                    if IsSpellKnown(data.spellID) or IsPlayerSpell(data.spellID) then
                        canUse = true
                    end
                end
                
                if canUse then
                    table.insert(matches, data)
                    addedOptions[data.name] = true  -- Mark as added
                end
            end
        end
    end
    
    -- Show banner if we found matching teleports
    if #matches > 0 then
        EasyPort_UI:ShowBanner(banner, matches)
    end
    
    return false
end

-- Initialize addon
local function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" and ... == addonName then
        -- Create banner
        banner = EasyPort_UI:CreateBanner()
        
        -- Register chat filters
        ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", DetectDungeon)
        ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", DetectDungeon)
        ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", DetectDungeon)
        ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", DetectDungeon)
        ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", DetectDungeon)
        
        -- Debug command
        SLASH_EASYPORT1 = "/easyport"
        SLASH_EASYPORT2 = "/ep"
        SlashCmdList["EASYPORT"] = function(msg)
            if msg == "debug" or msg == "count" then
                print("|cff00ff00EasyPort:|r Loaded " .. #EasyPort_DungeonData .. " teleport options")
                local categories = {}
                for _, data in ipairs(EasyPort_DungeonData) do
                    categories[data.category] = (categories[data.category] or 0) + 1
                end
                for cat, count in pairs(categories) do
                    print("  " .. cat .. ": " .. count)
                end
            elseif msg:match("^test%s+(.+)") then
                local testMsg = msg:match("^test%s+(.+)")
                print("|cff00ff00EasyPort:|r Testing keyword: '" .. testMsg .. "'")
                DetectDungeon(nil, nil, testMsg)
            else
                print("|cff00ff00EasyPort:|r Commands:")
                print("  /ep debug - Show loaded data count")
                print("  /ep test <keyword> - Test keyword detection")
            end
        end
        
        EasyPort:UnregisterEvent("ADDON_LOADED")
    end
end

EasyPort:RegisterEvent("ADDON_LOADED")
EasyPort:SetScript("OnEvent", OnEvent)

EasyPort:RegisterEvent("ADDON_LOADED")
EasyPort:SetScript("OnEvent", OnEvent)
