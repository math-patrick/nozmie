-- ============================================================================
-- Nozmie - Helpers Module
-- Utility functions for cooldowns, player checks, formatting, and positioning
-- ============================================================================

local Helpers = {}

function Helpers.SaveBannerPosition(banner)
    local root = banner.stackRoot or banner
    local point, _, relativePoint, xOfs, yOfs = root:GetPoint()
    NozmieDB = NozmieDB or {}
    NozmieDB.position = {point = point, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs}
    if root.baseAnchor then
        root.baseAnchor = nil
    end
end

function Helpers.LoadBannerPosition(banner)
    if NozmieDB and NozmieDB.position then
        local p = NozmieDB.position
        banner:ClearAllPoints()
        banner:SetPoint(p.point, UIParent, p.relativePoint, p.xOfs, p.yOfs)
    else
        banner:ClearAllPoints()
        banner:SetPoint("BOTTOM", ChatFrame1, "TOP", 0, 20)
    end
end

function Helpers.FormatCooldownTime(seconds)
    local mins = math.floor(seconds / 60)
    local secs = math.floor(seconds % 60)
    return mins > 0 and string.format("%dm %ds", mins, secs) or string.format("%ds", secs)
end

function Helpers.IsInAnyGroup()
    return IsInGroup() or IsInRaid() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
end

function Helpers.GetGroupChatChannel()
    if IsInRaid() then return "RAID" end
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then return "INSTANCE_CHAT" end
    return "PARTY"
end

function Helpers.CreateAnnouncementMessage(data)
    local cooldown = Helpers.GetCooldownRemaining(data)
    
    -- Determine action verb based on category
    local actionVerb = "use"
    local nounForm = "utility"
    
    if data.category == "M+ Dungeon" or data.category == "Raid" or data.category == "Delve" or 
       data.category == "Home" or data.category == "Class" or data.category == "Toy" then
        actionVerb = "teleport"
        nounForm = "portal"
    elseif data.category and data.category:find("Utility") then
        if data.destination and (data.destination:find("Repair") or data.destination:find("Mailbox") or 
           data.destination:find("Transmog") or data.destination:find("Anvil")) then
            actionVerb = "summon"
            nounForm = data.name
        elseif data.keywords and (tContains(data.keywords, "buff") or tContains(data.keywords, "fort") or 
                tContains(data.keywords, "motw") or tContains(data.keywords, "intellect")) then
            actionVerb = "cast"
            nounForm = data.name
        end
    end
    
    if cooldown > 0 then
        -- On cooldown
        local timeText = Helpers.FormatCooldownTime(cooldown)
        if nounForm == "portal" then
            return string.format("%s to %s ready in %s", nounForm:sub(1,1):upper()..nounForm:sub(2), data.destination or data.name, timeText)
        else
            return string.format("%s ready in %s", data.name, timeText)
        end
    else
        -- Ready to use
        if nounForm == "portal" then
            return string.format("I can %s to %s!", actionVerb, data.destination or data.name)
        elseif data.destination and (data.destination:find("Repair") or data.destination:find("Mailbox") or data.destination:find("Anvil")) then
            return string.format("I can %s %s!", actionVerb, data.destination)
        else
            return string.format("I can %s %s!", actionVerb, data.name)
        end
    end
end

function Helpers.AnnounceUtility(data)
    local message = Helpers.CreateAnnouncementMessage(data)
    
    if Helpers.IsInAnyGroup() then
        SendChatMessage(message, Helpers.GetGroupChatChannel())
    else
        SendChatMessage(message, "SAY")
    end
end

function Helpers.GetCooldownRemaining(data)
    if data.spellID then
        local info = C_Spell.GetSpellCooldown(data.spellID)
        -- Check if info exists and values are not tainted/secret
        if info and info.startTime and info.duration and type(info.startTime) == "number" and type(info.duration) == "number" then
            local ok, remaining = pcall(function()
                if info.startTime > 0 and info.duration > 0 then
                    return info.startTime + info.duration - GetTime()
                end
                return 0
            end)
            if ok and remaining and remaining > 0 then
                return remaining
            end
        end
    elseif data.itemID then
        local start, duration = C_Item.GetItemCooldown(data.itemID)
        -- Check if values are not tainted/secret
        if start and duration and type(start) == "number" and type(duration) == "number" then
            local ok, remaining = pcall(function()
                if start > 0 and duration > 0 then
                    return start + duration - GetTime()
                end
                return 0
            end)
            if ok and remaining and remaining > 0 then
                return remaining
            end
        end
    end
    return 0
end

function Helpers.CanPlayerUseTeleport(data)
    if data.itemID then
        -- Check if it's a toy
        if PlayerHasToy(data.itemID) then return true end
        
        -- Check if it's a regular item in inventory
        if C_Item.GetItemCount(data.itemID, true, false, false) > 0 then return true end
        
        -- Check if it's a learned mount
        if data.keywords and tContains(data.keywords, "mount") then
            -- Don't show mounts if they can't be used in current zone
            if IsIndoors() or IsMounted() then
                return false
            end
            -- Method 1: Try getting mount from item
            local mountID = C_MountJournal.GetMountFromItem(data.itemID)
            if mountID then
                local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mountID)
                if isCollected then
                    -- Store mountID for use by action buttons
                    data.mountID = mountID
                    -- Check if mount can be summoned in current zone
                    if data.spellID then
                        local usable = C_Spell.IsSpellUsable(data.spellID)
                        return usable
                    end
                    return true
                end
            end
            
            -- Method 2: Check if mount spell is known (for mounts that use spells)
            if data.spellName then
                -- Iterate through player's mounts to find by name
                local numMounts = C_MountJournal.GetNumMounts()
                for i = 1, numMounts do
                    local name, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(i)
                    if isCollected and name and name == data.spellName then
                        -- Store mountID for use by action buttons
                        data.mountID = i
                        -- Check if mount can be summoned in current zone
                        if data.spellID then
                            local usable = C_Spell.IsSpellUsable(data.spellID)
                            return usable
                        end
                        return true
                    end
                end
            end
        end
    end
    
    if data.spellID then
        if IsSpellKnown(data.spellID) or IsPlayerSpell(data.spellID) then return true end
    end
    
    return false
end

_G.Nozmie_Helpers = Helpers
