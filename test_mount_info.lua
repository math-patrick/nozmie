-- Test script to check mount spell IDs
local mounts = {
    {name = "Traveler's Tundra Mammoth", itemID = 61425},
    {name = "Grand Expedition Yak", itemID = 120968},
    {name = "Mighty Caravan Brutosaur", itemID = 163042},
    {name = "Trader's Gilded Brutosaur", itemID = 229376}
}

print("=== Mount Spell ID Test ===")
for _, mount in ipairs(mounts) do
    local mountID = C_MountJournal.GetMountFromItem(mount.itemID)
    if mountID then
        local name, spellID, icon = C_MountJournal.GetMountInfoByID(mountID)
        print(mount.name .. ": spellID=" .. (spellID or "nil") .. ", icon=" .. (icon or "nil"))
    else
        print(mount.name .. ": Not found via item")
    end
end
