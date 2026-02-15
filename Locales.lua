Nozmie_Locales = Nozmie_Locales or {}

local Locale = {}

function Locale.GetLocale()
    return GetLocale() or "enUS"
end

local function GetLocaleTable(locale)
    return Nozmie_Locales[locale] or Nozmie_Locales["enUS"] or {}
end

function Locale.GetString(key, fallback)
    local locale = Locale.GetLocale()
    local data = GetLocaleTable(locale)
    local strings = data.strings or {}
    local value = strings[key]
    if value == nil then
        local en = Nozmie_Locales["enUS"]
        value = en and en.strings and en.strings[key] or nil
    end
    return value or fallback or key
end

function Locale.ApplyKeywordAliases(dataList)
    local locale = Locale.GetLocale()
    local data = GetLocaleTable(locale)
    local aliases = data.keywordsByName or {}
    local enAliases = (Nozmie_Locales["enUS"] and Nozmie_Locales["enUS"].keywordsByName) or {}

    for _, item in ipairs(dataList or {}) do
        if item and item.name and item.keywords then
            local extra = aliases[item.name] or enAliases[item.name]
            if extra then
                for _, kw in ipairs(extra) do
                    local found = false
                    for _, existing in ipairs(item.keywords) do
                        if existing == kw then
                            found = true
                            break
                        end
                    end
                    if not found then
                        table.insert(item.keywords, kw)
                    end
                end
            end
        end
    end
end

_G.Nozmie_Locale = Locale
