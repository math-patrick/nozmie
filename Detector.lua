-- ============================================================================
-- Nozmie - Detector Module
-- Finds matching teleports/utilities from chat messages with smart filtering
-- ============================================================================
local Helpers = Nozmie_Helpers
local Detector = {}

local function ShuffleTable(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
end

local function EscapePattern(text)
    return (text:gsub("(%W)", "%%%1"))
end

local function MatchesKeyword(message, keyword)
    if not message or not keyword or keyword == "" then
        return false
    end
    local pattern = "%f[%w]" .. EscapePattern(keyword) .. "%f[%W]"
    return message:find(pattern) ~= nil
end

local function HasSuppression(list, key)
    if not list then
        return false
    end
    for _, entry in ipairs(list) do
        if entry == key then
            return true
        end
    end
    return false
end

local function ShouldSuppressByList(list, keys)
    if not list or #list == 0 then
        return false
    end
    for _, key in ipairs(keys) do
        if HasSuppression(list, key) then
            return true
        end
    end
    return false
end

local function IsPortalSpell(teleportData)
    local spellName = teleportData.spellName or ""
    return spellName:find("^Portal:") or spellName:find("^Ancient Portal:")
end

local function IsTeleport(teleportData)
    local spellName = teleportData.spellName or ""
    return spellName:find("^Teleport:") or spellName:find("^Ancient Teleport:")
end

local function IsServiceOption(data)
    local destination = data.destination or ""
    return destination:find("Repair") or destination:find("Mailbox") or destination:find("Anvil") or destination:find("Transmog")
end

local function IsHearthstone(data)
    return data.category == "Home"
end

local function ShouldSuppressOption(data, settings, inInstance)
    if not settings or not settings.Get then
        return false
    end

    local isClass = data.category == "Class" or data.category == "Class Utility"
    local isUtility = data.category and data.category == "Utility"
    local isMPlus = data.category == "M+ Dungeon"
    local isRaid = data.category == "Raid"
    local isDelve = data.category == "Delve"
    local isPortal = IsPortalSpell(data)
    local isTeleport = IsTeleport(data)
    local isHearthstone = IsHearthstone(data)
    local isMount = data.actionType == "mount"
    local isService = IsServiceOption(data)

    local keys = {}
    if isMount then table.insert(keys, "mount") end
    if isClass then table.insert(keys, "class") end

    -- Grouped: Portals/Teleports/M+ Dungeons/Raids
    if isMPlus or isRaid or isTeleport or isPortal or isDelve or isHearthstone then
        table.insert(keys, "teleports")
    end

    -- Grouped: Utility/Service (Mail, Repair, Transmog)
    if isUtility or isService then
        table.insert(keys, "utilityservice")
    end

    if ShouldSuppressByList(settings.Get("suppressGlobalList"), keys) then
        return true
    end

    if inInstance and ShouldSuppressByList(settings.Get("suppressInstanceList"), keys) then
        return true
    end

    return false
end

function Detector.FindMatchingTeleports(message, sender)
    local lowerMessage = message:lower()
    local matches, hearthstones, currents = {}, {}, {}
    local Settings = Nozmie_Settings
    local preferPortals = Settings and Settings.Get and Settings.Get("preferPortals")

    -- Blacklist check
    if Settings then
        local blacklist = Settings.Get("blacklistedWords") or ""
        if blacklist ~= "" then
            for word in blacklist:gmatch("([^,]+)") do
                local trimmedWord = word:match("^%s*(.-)%s*$"):lower()
                if trimmedWord ~= "" and lowerMessage:find(trimmedWord, 1, true) then
                    return {}
                end
            end
        end
    end

    -- Player/instance context
    local targetPlayer = sender and sender:match("([^-]+)") or sender
    local playerName = UnitName("player")
    if playerName and targetPlayer == playerName then
        targetPlayer = nil
    end
    local inInstance = IsInInstance()

    for _, teleportData in ipairs(Nozmie_Data) do
        if teleportData.keywords then
            for _, keyword in ipairs(teleportData.keywords) do
                if MatchesKeyword(lowerMessage, keyword) and Helpers.CanPlayerUseUtility(teleportData) then
                    if not ShouldSuppressOption(teleportData, Settings, inInstance) then
                        local teleportCopy = {}
                        for k, v in pairs(teleportData) do
                            teleportCopy[k] = v
                        end
                        if targetPlayer and teleportCopy.category and
                            (teleportCopy.category:find("Utility") or teleportCopy.spellName == "Levitate" or
                                teleportCopy.spellName == "Slow Fall") then
                            teleportCopy.targetPlayer = targetPlayer
                        end
                        if teleportCopy.current then
                            table.insert(currents, teleportCopy)
                        elseif IsHearthstone(teleportCopy) then
                            table.insert(hearthstones, teleportCopy)
                        else
                            -- Portal prioritization: if preferPortals is enabled, prefer portals over teleports with same name
                            if preferPortals and teleportCopy.spellName and teleportCopy.spellName:find("^Teleport:") then
                                -- Try to find a matching portal in matches and replace if found
                                local found = false
                                for i, t in ipairs(matches) do
                                    if t.spellName and t.spellName:gsub("^Portal:", "Teleport:") ==
                                        teleportCopy.spellName then
                                        -- If t is a portal, keep it; if t is a teleport, replace with portal
                                        if IsPortalSpell(t) then
                                            found = true
                                            break
                                        else
                                            matches[i] = teleportCopy
                                            found = true
                                            break
                                        end
                                    end
                                end
                                if not found then
                                    table.insert(matches, teleportCopy)
                                end
                            else
                                table.insert(matches, teleportCopy)
                            end
                        end
                    end
                    break
                end
            end
        end
    end

    -- Randomize hearthstones
    if #hearthstones > 1 then
        ShuffleTable(hearthstones)
    end

    -- Sort matches: cooldowns last
    local ready, oncd = {}, {}
    for _, t in ipairs(matches) do
        if Helpers.GetCooldownRemaining(t) > 0 then
            table.insert(oncd, t)
        else
            table.insert(ready, t)
        end
    end

    -- Compose result: current > ready > hearthstones > cooldowns
    local result = {}
    for _, t in ipairs(currents) do
        table.insert(result, t)
    end
    for _, t in ipairs(ready) do
        table.insert(result, t)
    end
    for _, t in ipairs(hearthstones) do
        table.insert(result, t)
    end
    for _, t in ipairs(oncd) do
        table.insert(result, t)
    end

    return result
end

_G.Nozmie_Detector = Detector
