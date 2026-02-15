Nozmie_Data = {}

local function AddAll(tbl)
    for _, v in ipairs(tbl or {}) do
        table.insert(Nozmie_Data, v)
    end
end

AddAll(ClassSpells)
AddAll(Expansions)
AddAll(Hearthstones)
AddAll(MageTeleports)
AddAll(TeleportToys)
AddAll(ServiceToys)
AddAll(DelveTeleports)

if _G.Nozmie_Locale and _G.Nozmie_Locale.ApplyKeywordAliases then
    _G.Nozmie_Locale.ApplyKeywordAliases(Nozmie_Data)
end
