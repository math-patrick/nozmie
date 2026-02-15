local Helpers = {}
local lastAnnounce = {
    message = nil,
    time = 0
}
local Locale = _G.Nozmie_Locale
local function Lstr(key, fallback)
    if Locale and Locale.GetString then
        return Locale.GetString(key, fallback)
    end
    return fallback or key
end

function Helpers.SaveBannerPosition(banner)
    local root = banner.stackRoot or banner
    local point, _, relativePoint, xOfs, yOfs = root:GetPoint()
    NozmieDB = NozmieDB or {}
    NozmieDB.position = {
        point = point,
        relativePoint = relativePoint,
        xOfs = xOfs,
        yOfs = yOfs
    }
    if root.baseAnchor then
        root.baseAnchor = nil
    end
end

function Helpers.LoadBannerPosition(banner)
    if NozmieDB and NozmieDB.position then
        local p = NozmieDB.position
        banner:ClearAllPoints()
        banner:SetPoint(p.point, UIParent, p.relativePoint, p.xOfs, p.yOfs)
        return
    end
    banner:ClearAllPoints()
    banner:SetPoint("BOTTOM", ChatFrame1, "TOP", 0, 20)
end

function Helpers.FormatCooldownTime(seconds)
    local mins = math.floor(seconds / 60)
    local secs = math.floor(seconds % 60)
    if mins > 0 then
        return string.format("%dm %ds", mins, secs)
    end
    return string.format("%ds", secs)
end

function Helpers.IsInAnyGroup()
    return IsInGroup() or IsInRaid() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
end

function Helpers.GetGroupChatChannel()
    if IsInRaid() then
        return "RAID"
    end
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        return "INSTANCE_CHAT"
    end
    return "PARTY"
end

function Helpers.GetChannelFromEvent(event)
    if event == "CHAT_MSG_SAY" then
        return "SAY"
    end
    if event == "CHAT_MSG_PARTY" then
        return "PARTY"
    end
    if event == "CHAT_MSG_RAID" then
        return "RAID"
    end
    if event == "CHAT_MSG_GUILD" then
        return "GUILD"
    end
    if event == "CHAT_MSG_WHISPER" then
        return "WHISPER"
    end
    if event == "CHAT_MSG_INSTANCE_CHAT" then
        return "INSTANCE_CHAT"
    end
    return nil
end

function Helpers.SendMessageForEvent(message, event, sender)
    local channel = Helpers.GetChannelFromEvent(event)
    if not channel then
        return false
    end
    if channel == "WHISPER" then
        if not sender or sender == "" then
            return false
        end
        C_ChatInfo.SendChatMessage(message, channel, nil, sender)
        return true
    end
    C_ChatInfo.SendChatMessage(message, channel)
    return true
end

function Helpers.MarkAnnounce(message)
    lastAnnounce.message = message
    lastAnnounce.time = GetTime()
end

function Helpers.IsRecentAnnounce(message, window)
    if not lastAnnounce.message then
        return false
    end
    local limit = window or 2
    return message == lastAnnounce.message and (GetTime() - lastAnnounce.time) <= limit
end

function Helpers.CreateAnnouncementMessage(data)
    local cooldown = Helpers.GetCooldownRemaining(data)
    local actionVerb = Lstr("announce.action.use", "use")
    local nounForm = "utility"
    if data.category == "M+ Dungeon" or data.category == "Raid" or data.category == "Delve" or data.category == "Home" or
        data.category == "Class" or data.category == "Toy" then
        actionVerb = Lstr("announce.action.teleport", "teleport")
        nounForm = "portal"
    elseif data.category and data.category:find("Utility") then
        if data.destination and
            (data.destination:find("Repair") or data.destination:find("Mailbox") or data.destination:find("Transmog") or
                data.destination:find("Anvil")) then
            actionVerb = Lstr("announce.action.summon", "summon")
            nounForm = data.name
        elseif data.keywords and
            (tContains(data.keywords, "buff") or tContains(data.keywords, "fort") or tContains(data.keywords, "motw") or
                tContains(data.keywords, "intellect")) then
            actionVerb = Lstr("announce.action.cast", "cast")
            nounForm = data.name
        end
    end
    if cooldown > 0 then
        local timeText = Helpers.FormatCooldownTime(cooldown)
        if nounForm == "portal" then
            local portalNoun = Lstr("announce.noun.portal", "Portal")
            return string.format(Lstr("announce.portalReadyIn", "%s to %s ready in %s"), portalNoun,
                data.destination or data.name, timeText)
        end
        return string.format(Lstr("announce.readyIn", "%s ready in %s"), data.name, timeText)
    end
    if nounForm == "portal" then
        return string.format(Lstr("announce.canTeleport", "I can %s to %s!"), actionVerb, data.destination or data.name)
    end
    if data.destination and
        (data.destination:find("Repair") or data.destination:find("Mailbox") or data.destination:find("Anvil")) then
        return string.format(Lstr("announce.canUseDestination", "I can %s %s!"), actionVerb, data.destination)
    end
    return string.format(Lstr("announce.canUseName", "I can %s %s!"), actionVerb, data.name)
end

function Helpers.AnnounceUtility(data, event, sender)
    local message = Helpers.CreateAnnouncementMessage(data)
    if event and Helpers.SendMessageForEvent(message, event, sender) then
        Helpers.MarkAnnounce(message)
        return
    end
    if Helpers.IsInAnyGroup() then
        C_ChatInfo.SendChatMessage(message, Helpers.GetGroupChatChannel())
    else
        C_ChatInfo.SendChatMessage(message, "SAY")
    end
    Helpers.MarkAnnounce(message)
end

function Helpers.GetCooldownRemaining(data)
    if data.preferItem and data.itemID then
        local start, duration = C_Item.GetItemCooldown(data.itemID)
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
    if data.spellID then
        local info = C_Spell.GetSpellCooldown(data.spellID)
        if info and info.startTime and info.duration and type(info.startTime) == "number" and type(info.duration) ==
            "number" then
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

local function CanUsePet(data)
    if not C_PetJournal or not C_PetJournal.GetNumPets or not data.petName then
        return false
    end
    for i = 1, C_PetJournal.GetNumPets() do
        local _, _, _, customName, _, _, _, petNameFromJournal = C_PetJournal.GetPetInfoByIndex(i)
        if petNameFromJournal == data.petName or customName == data.petName then
            return true
        end
    end
    return false
end

local function CanUseItem(data)
    return data.itemID and C_Item.GetItemCount(data.itemID, true, false, false) > 0
end

local function CanUseMount(data)
    if data.actionType ~= "mount" or (IsIndoors and IsIndoors()) then
        return false
    end
    local mountID = data.mountId or
                        (C_MountJournal and C_MountJournal.GetMountFromItem and
                            C_MountJournal.GetMountFromItem(data.itemID))
    if not mountID then
        return false
    end
    local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mountID)
    return isCollected
end

local function CanUseToy(data)
    return (type(PlayerHasToy) == "function" and PlayerHasToy(data.itemID))
end

local function CanUseSpell(data)
    return data.spellID and C_Spell and C_Spell.IsSpellKnown and C_Spell.IsSpellKnown(data.spellID, false)
end

function Helpers.CanPlayerUseUtility(data)
    if data.actionType == "pet" then
        return CanUsePet(data)
    elseif data.actionType == "item" then
        return CanUseItem(data)
    elseif data.actionType == "mount" then
        return CanUseMount(data)
    elseif data.actionType == "toy" then
        return CanUseToy(data)
    elseif data.actionType == "spell" then
        return CanUseSpell(data)
    end
    return false
end

_G.Nozmie_Helpers = Helpers
