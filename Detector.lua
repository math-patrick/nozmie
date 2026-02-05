-- ============================================================================
-- Nozmie - Detector Module
-- Finds matching teleports/utilities from chat messages with smart filtering
-- ============================================================================
local Helpers = Nozmie_Helpers
local Detector = {}

local seasonNamePriority = {
    MidnightSeason1 = 0,
    WarWithinSeason3 = 1
}

local function GetSeasonPriorityByName(name)
    if not _G.Nozmie_DungeonSeasonPriorityNames or not name then
        return nil
    end
    for seasonKey, names in pairs(_G.Nozmie_DungeonSeasonPriorityNames) do
        if seasonNamePriority[seasonKey] then
            for _, dungeonName in ipairs(names) do
                if dungeonName == name then
                    return seasonNamePriority[seasonKey]
                end
            end
        end
    end
    return nil
end

local function GetCategoryPriority(teleportData)
    -- Define priority order for categories (lower number = higher priority)
    local categoryPriority = {
        ["M+ Dungeon"] = 1,
        ["Raid"] = 2,
        ["Delve"] = 3,
        ["Home"] = 4,
        ["Class"] = 5,
        ["Toy"] = 6
    }

    -- Check which season/expansion the teleport belongs to
    local seasonPriority = GetSeasonPriorityByName(teleportData.name) or 999
    if seasonPriority == 999 then
        for categoryName, categoryData in pairs(Nozmie_Categories) do
        for _, item in ipairs(categoryData) do
            if item.name == teleportData.name then
                if categoryName == "MidnightSeason1" then
                    seasonPriority = 0 -- Future season (when active, highest priority)
                elseif categoryName == "WarWithinSeason3" then
                    seasonPriority = 1 -- Current season highest priority
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
    if not teleportData.keywords then
        return false
    end
    for _, keyword in ipairs(teleportData.keywords) do
        if keyword == "hearthstone" or keyword == "hearth" then
            return true
        end
    end
    return false
end

local function IsPortalSpell(teleportData)
    local spellName = teleportData.spellName or ""
    return spellName:find("^Portal:") or spellName:find("^Ancient Portal:")
end

local function ChoosePreferredMatch(existing, candidate, preferPortals)
    if not existing then
        return candidate
    end
    if preferPortals then
        local existingPortal = IsPortalSpell(existing)
        local candidatePortal = IsPortalSpell(candidate)
        if existingPortal ~= candidatePortal then
            return candidatePortal and candidate or existing
        end
    end
    local existingPriority = GetCategoryPriority(existing)
    local candidatePriority = GetCategoryPriority(candidate)
    if candidatePriority < existingPriority then
        return candidate
    end
    return existing
end

function Detector.FindMatchingTeleports(message, sender)
    local lowerMessage = message:lower()
    local matches = {}
    local hearthstones = {}
    local preferPortals = Nozmie_Settings and Nozmie_Settings.Get and Nozmie_Settings.Get("preferPortals")
    
    -- Check blacklisted words
    local Settings = Nozmie_Settings
    if Settings then
        local blacklist = Settings.Get("blacklistedWords") or ""
        if blacklist ~= "" then
            -- Split by comma and check each word
            for word in blacklist:gmatch("([^,]+)") do
                local trimmedWord = word:match("^%s*(.-)%s*$"):lower()  -- trim and lowercase
                if trimmedWord ~= "" and lowerMessage:find(trimmedWord, 1, true) then
                    return {}  -- Return empty if blacklisted word found
                end
            end
        end
    end

    -- Extract player name without realm suffix if present
    local targetPlayer = sender
    if targetPlayer then
        targetPlayer = targetPlayer:match("([^-]+)") or targetPlayer
    end
    local playerName = UnitName("player")
    if playerName and targetPlayer == playerName then
        targetPlayer = nil
    end

    for _, teleportData in ipairs(Nozmie_Data) do
        if teleportData.keywords then
            local shouldMatch = false

            for _, keyword in ipairs(teleportData.keywords) do
                if lowerMessage:find(keyword, 1, true) then
                    shouldMatch = true
                    break
                end
            end

            if shouldMatch and Helpers.CanPlayerUseTeleport(teleportData) then
                -- Clone the teleport data to avoid modifying the original
                local teleportCopy = {}
                for k, v in pairs(teleportData) do
                    teleportCopy[k] = v
                end

                -- Add sender info for buff spells
                if targetPlayer and teleportCopy.category and
                    (teleportCopy.category:find("Utility") or teleportCopy.spellName == "Levitate" or
                        teleportCopy.spellName == "Slow Fall") then
                    teleportCopy.targetPlayer = targetPlayer
                end

                if IsHearthstone(teleportCopy) then
                    table.insert(hearthstones, teleportCopy)
                else
                    table.insert(matches, teleportCopy)
                end
            end
        end
    end

    if #matches > 1 then
        local byName = {}
        for _, teleport in ipairs(matches) do
            local key = teleport.name or teleport.spellName or ""
            byName[key] = ChoosePreferredMatch(byName[key], teleport, preferPortals)
        end
        matches = {}
        for _, teleport in pairs(byName) do
            table.insert(matches, teleport)
        end
    end

    if #hearthstones > 0 then
        ShuffleTable(hearthstones)
        for _, hs in ipairs(hearthstones) do
            table.insert(matches, hs)
        end
    end

    table.sort(matches, function(a, b)
        local aPriority = GetCategoryPriority(a)
        local bPriority = GetCategoryPriority(b)
        if aPriority ~= bPriority then
            return aPriority < bPriority
        end

        local aCooldown = Helpers.GetCooldownRemaining(a)
        local bCooldown = Helpers.GetCooldownRemaining(b)
        if (aCooldown > 0) ~= (bCooldown > 0) then
            return aCooldown == 0
        end

        return (a.name or a.spellName or "") < (b.name or b.spellName or "")
    end)

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

_G.Nozmie_Detector = Detector
