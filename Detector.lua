local Helpers = EasyPort_Helpers
local Detector = {}

local function GetCategoryPriority(teleportData)
    -- Define priority order for categories (lower number = higher priority)
    local categoryPriority = {
        ["M+ Dungeon"] = 1,
        ["Raid"] = 2,
        ["Delve"] = 3,
        ["Home"] = 4,
        ["Mage"] = 5,
        ["Druid"] = 6,
        ["Shaman"] = 7,
        ["Death Knight"] = 8,
        ["Monk"] = 9,
        ["Demon Hunter"] = 10,
        ["Toy"] = 11
    }
    
    -- Check which season/expansion the teleport belongs to
    local seasonPriority = 999
    for categoryName, categoryData in pairs(EasyPort_Categories) do
        for _, item in ipairs(categoryData) do
            if item.name == teleportData.name then
                if categoryName == "MidnightSeason1" then
                    seasonPriority = 0  -- Future season (when active, highest priority)
                elseif categoryName == "WarWithinSeason3" then
                    seasonPriority = 1  -- Current season highest priority
                elseif categoryName == "WarWithinSeason2" then
                    seasonPriority = 2
                elseif categoryName == "WarWithinSeason1" then
                    seasonPriority = 3
                elseif categoryName == "DragonflightDungeons" then
                    seasonPriority = 4
                elseif categoryName == "BfADungeons" then
                    seasonPriority = 5
                elseif categoryName == "ShadowlandsDungeons" then
                    seasonPriority = 6
                elseif categoryName == "RaidTeleports" then
                    seasonPriority = 7
                else
                    seasonPriority = 10
                end
                break
            end
        end
    end
    
    local catPriority = categoryPriority[teleportData.category] or 99
    -- Return combined priority: season first, then category
    return seasonPriority * 100 + catPriority
end

local function ShuffleTable(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
end

local function IsHearthstone(teleportData)
    if not teleportData.keywords then return false end
    for _, keyword in ipairs(teleportData.keywords) do
        if keyword == "hearthstone" or keyword == "hearth" then
            return true
        end
    end
    return false
end

function Detector.FindMatchingTeleports(message)
    local lowerMessage = message:lower()
    local matches = {}
    local hearthstones = {}
    local uniqueNames = {}
    
    for _, teleportData in ipairs(EasyPort_DungeonData) do
        if not uniqueNames[teleportData.name] and teleportData.keywords then
            local shouldMatch = false
            
            for _, keyword in ipairs(teleportData.keywords) do
                if lowerMessage:find(keyword, 1, true) then
                    shouldMatch = true
                    break
                end
            end
            
            if shouldMatch and Helpers.CanPlayerUseTeleport(teleportData) then
                if IsHearthstone(teleportData) then
                    table.insert(hearthstones, teleportData)
                else
                    table.insert(matches, teleportData)
                end
                uniqueNames[teleportData.name] = true
            end
        end
    end
    
    if #hearthstones > 0 then
        ShuffleTable(hearthstones)
        for _, hs in ipairs(hearthstones) do
            table.insert(matches, hs)
        end
    end
    
    -- Deduplicate by spell ID, keeping highest priority (current season) version
    local seenSpells = {}
    local dedupedMatches = {}
    
    for _, teleport in ipairs(matches) do
        if teleport.spellID then
            local existing = seenSpells[teleport.spellID]
            if existing then
                -- Keep the one with higher priority (lower number)
                local existingPriority = GetCategoryPriority(existing)
                local newPriority = GetCategoryPriority(teleport)
                if newPriority < existingPriority then
                    -- Replace with higher priority version
                    seenSpells[teleport.spellID] = teleport
                    -- Find and replace in deduped list
                    for i, t in ipairs(dedupedMatches) do
                        if t.spellID == teleport.spellID then
                            dedupedMatches[i] = teleport
                            break
                        end
                    end
                end
            else
                seenSpells[teleport.spellID] = teleport
                table.insert(dedupedMatches, teleport)
            end
        else
            -- Items without spellID (just itemID) - keep as is
            table.insert(dedupedMatches, teleport)
        end
    end
    
    return dedupedMatches
end

_G.EasyPort_Detector = Detector
