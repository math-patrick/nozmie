local Helpers = EasyPort_Helpers
local Detector = {}

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
        if teleportData.keywords and not uniqueNames[teleportData.name] then
            for _, keyword in ipairs(teleportData.keywords) do
                if lowerMessage:find(keyword, 1, true) then
                    if Helpers.CanPlayerUseTeleport(teleportData) then
                        if IsHearthstone(teleportData) then
                            table.insert(hearthstones, teleportData)
                        else
                            table.insert(matches, teleportData)
                        end
                        uniqueNames[teleportData.name] = true
                    end
                    break
                end
            end
        end
    end
    
    if #hearthstones > 0 then
        ShuffleTable(hearthstones)
        for _, hs in ipairs(hearthstones) do
            table.insert(matches, hs)
        end
    end
    
    return matches
end

_G.EasyPort_Detector = Detector
