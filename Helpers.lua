local Helpers = {}

function Helpers.SaveBannerPosition(banner)
    local point, _, relativePoint, xOfs, yOfs = banner:GetPoint()
    EasyPortDB = EasyPortDB or {}
    EasyPortDB.position = {point = point, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs}
end

function Helpers.LoadBannerPosition(banner)
    if EasyPortDB and EasyPortDB.position then
        local p = EasyPortDB.position
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

function Helpers.GetCooldownRemaining(data)
    if data.spellID then
        local info = C_Spell.GetSpellCooldown(data.spellID)
        if info and info.startTime > 0 then
            local remaining = info.startTime + info.duration - GetTime()
            if remaining > 0 then return remaining end
        end
    elseif data.itemID then
        local start, duration = C_Item.GetItemCooldown(data.itemID)
        if start > 0 and duration > 0 then
            local remaining = start + duration - GetTime()
            if remaining > 0 then return remaining end
        end
    end
    return 0
end

function Helpers.CanPlayerUseTeleport(data)
    if data.itemID then
        if PlayerHasToy(data.itemID) then return true end
        if C_Item.GetItemCount(data.itemID, true, false, false) > 0 then return true end
    end
    
    if data.spellID then
        if IsSpellKnown(data.spellID) or IsPlayerSpell(data.spellID) then return true end
    end
    
    return false
end

_G.EasyPort_Helpers = Helpers
