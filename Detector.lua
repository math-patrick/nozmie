local Helpers = EasyPort_Helpers
local Detector = {}

function Detector.FindMatchingTeleports(message)
    local lowerMessage = message:lower()
    local matches = {}
    local uniqueNames = {}
    
    for _, teleportData in ipairs(EasyPort_DungeonData) do
        if teleportData.keywords and not uniqueNames[teleportData.name] then
            for _, keyword in ipairs(teleportData.keywords) do
                if lowerMessage:find(keyword, 1, true) then
                    if Helpers.CanPlayerUseTeleport(teleportData) then
                        table.insert(matches, teleportData)
                        uniqueNames[teleportData.name] = true
                    end
                    break
                end
            end
        end
    end
    
    return matches
end

_G.EasyPort_Detector = Detector
