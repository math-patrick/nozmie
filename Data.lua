-- EasyPort Data Module
-- Contains all teleport spells, items, and toys organized by category
-- Each entry has keywords array for detection in chat

-- ============================================================================
-- MYTHIC+ DUNGEONS
-- ============================================================================

-- The War Within Season 3 (Current)
local WarWithinSeason3 = {
    {
        name = "Ara-Kara, City of Echoes",
        spellID = 445424,
        spellName = "Path of the Ruined City",
        category = "M+ Dungeon",
        keywords = {"ara-kara", "ara kara", "arakara", "city of echoes"}
    },
    {
        name = "The Dawnbreaker",
        spellID = 445417,
        spellName = "Path of the Arathi Flagship",
        category = "M+ Dungeon",
        keywords = {"dawnbreaker", "dawn breaker", "arathi flagship"}
    },
    {
        name = "Floodgate",
        spellID = 445444,
        spellName = "Path of Circuit Breaker",
        category = "M+ Dungeon",
        keywords = {"floodgate", "flood gate", "circuit breaker"}
    },
    {
        name = "Priory of the Sacred Flame",
        spellID = 445269,
        spellName = "Path of the Light's Reverence",
        category = "M+ Dungeon",
        keywords = {"priory", "sacred flame", "lights reverence"}
    },
    {
        name = "Eco-Dome Al'dani",
        spellID = 445416,
        spellName = "Path of the Eco-Dome",
        category = "M+ Dungeon",
        keywords = {"eco-dome", "eco dome", "ecodome", "aldani"}
    }
}

-- Shadowlands Dungeons
local ShadowlandsDungeons = {
    {
        name = "Halls of Atonement",
        spellID = 354464,
        spellName = "Path of the Sinful Soul",
        category = "M+ Dungeon",
        keywords = {"halls", "halls of atonement", "hoa", "atonement"}
    },
    {
        name = "Plaguefall",
        spellID = 354462,
        spellName = "Path of the Plagued",
        category = "M+ Dungeon",
        keywords = {"plaguefall", "plague fall", "pf"}
    },
    {
        name = "Mists of Tirna Scithe",
        spellID = 354463,
        spellName = "Path of the Misty Forest",
        category = "M+ Dungeon",
        keywords = {"mists", "tirna scithe", "tirna", "mots"}
    },
    {
        name = "The Necrotic Wake",
        spellID = 354465,
        spellName = "Path of the Courageous",
        category = "M+ Dungeon",
        keywords = {"necrotic", "necrotic wake", "nw", "wake"}
    },
    {
        name = "Sanguine Depths",
        spellID = 354469,
        spellName = "Path of the Stone Warden",
        category = "M+ Dungeon",
        keywords = {"sanguine", "sanguine depths", "sd", "depths"}
    },
    {
        name = "Tazavesh, the Veiled Market",
        spellID = 367416,
        spellName = "Path of the Streetwise Merchant",
        category = "M+ Dungeon",
        keywords = {"tazavesh", "taza", "veiled market"}
    }
}

-- ============================================================================
-- HEARTHSTONES & HOME TELEPORTS
-- ============================================================================

local Hearthstones = {
    {
        name = "Hearthstone",
        spellID = 8690,
        spellName = "Hearthstone",
        category = "Home",
        cooldown = "30 min",
        keywords = {"hearthstone", "hearth", "home", "inn"}
    },
    {
        name = "Garrison Hearthstone",
        spellID = 171253,
        spellName = "Garrison Hearthstone",
        category = "Home",
        cooldown = "20 min",
        keywords = {"garrison", "garrison hearth"}
    },
    {
        name = "Dalaran Hearthstone",
        spellID = 140192,
        spellName = "Dalaran Hearthstone",
        category = "Home",
        cooldown = "20 min",
        keywords = {"dalaran", "dal", "dalaran hearth"}
    }
}

-- ============================================================================
-- MAGE TELEPORTS
-- ============================================================================

local MageTeleports = {
    -- Alliance Cities
    {
        name = "Stormwind",
        spellID = 3561,
        spellName = "Teleport: Stormwind",
        category = "Mage",
        faction = "Alliance",
        keywords = {"stormwind", "sw", "storm wind"}
    },
    {
        name = "Ironforge",
        spellID = 3562,
        spellName = "Teleport: Ironforge",
        category = "Mage",
        faction = "Alliance",
        keywords = {"ironforge", "iron forge"}
    },
    {
        name = "Darnassus",
        spellID = 3565,
        spellName = "Teleport: Darnassus",
        category = "Mage",
        faction = "Alliance",
        keywords = {"darnassus", "darn"}
    },
    {
        name = "Exodar",
        spellID = 32271,
        spellName = "Teleport: Exodar",
        category = "Mage",
        faction = "Alliance",
        keywords = {"exodar"}
    },
    {
        name = "Boralus",
        spellID = 281403,
        spellName = "Teleport: Boralus",
        category = "Mage",
        faction = "Alliance",
        keywords = {"boralus"}
    },
    
    -- Horde Cities
    {
        name = "Orgrimmar",
        spellID = 3567,
        spellName = "Teleport: Orgrimmar",
        category = "Mage",
        faction = "Horde",
        keywords = {"orgrimmar", "org"}
    },
    {
        name = "Undercity",
        spellID = 3563,
        spellName = "Teleport: Undercity",
        category = "Mage",
        faction = "Horde",
        keywords = {"undercity", "uc", "under city"}
    },
    {
        name = "Thunder Bluff",
        spellID = 3566,
        spellName = "Teleport: Thunder Bluff",
        category = "Mage",
        faction = "Horde",
        keywords = {"thunder bluff", "thunderbluff", "tb"}
    },
    {
        name = "Silvermoon",
        spellID = 32272,
        spellName = "Teleport: Silvermoon",
        category = "Mage",
        faction = "Horde",
        keywords = {"silvermoon", "silver moon", "sm"}
    },
    {
        name = "Dazar'alor",
        spellID = 281404,
        spellName = "Teleport: Dazar'alor",
        category = "Mage",
        faction = "Horde",
        keywords = {"dazaralor", "dazar", "dazar'alor"}
    },
    
    -- Neutral Cities
    {
        name = "Shattrath",
        spellID = 33690,
        spellName = "Teleport: Shattrath",
        category = "Mage",
        faction = "Neutral",
        keywords = {"shattrath", "shatt"}
    },
    {
        name = "Dalaran (Northrend)",
        spellID = 53140,
        spellName = "Teleport: Dalaran - Northrend",
        category = "Mage",
        faction = "Neutral",
        keywords = {"dalaran", "dal", "northrend dal"}
    },
    {
        name = "Dalaran (Broken Isles)",
        spellID = 224869,
        spellName = "Teleport: Dalaran - Broken Isles",
        category = "Mage",
        faction = "Neutral",
        keywords = {"dalaran", "dal", "legion dal", "broken isles"}
    },
    {
        name = "Vale of Eternal Blossoms",
        spellID = 132621,
        spellName = "Teleport: Vale of Eternal Blossoms",
        category = "Mage",
        faction = "Neutral",
        keywords = {"vale", "vale of eternal blossoms"}
    },
    {
        name = "Oribos",
        spellID = 344597,
        spellName = "Teleport: Oribos",
        category = "Mage",
        faction = "Neutral",
        keywords = {"oribos"}
    },
    {
        name = "Valdrakken",
        spellID = 395277,
        spellName = "Teleport: Valdrakken",
        category = "Mage",
        faction = "Neutral",
        keywords = {"valdrakken", "vald"}
    }
}

-- ============================================================================
-- CLASS TELEPORTS
-- ============================================================================

local ClassTeleports = {
    -- Druid
    {
        name = "Moonglade",
        spellID = 18960,
        spellName = "Teleport: Moonglade",
        category = "Druid",
        keywords = {"moonglade"}
    },
    {
        name = "Emerald Dreamway",
        spellID = 193753,
        spellName = "Dreamwalk",
        category = "Druid",
        keywords = {"dreamway", "dream way", "emerald dreamway"}
    },
    
    -- Death Knight
    {
        name = "Ebon Hold",
        spellID = 50977,
        spellName = "Death Gate",
        category = "Death Knight",
        keywords = {"ebon hold", "death gate", "acherus"}
    },
    
    -- Monk
    {
        name = "Peak of Serenity",
        spellID = 126892,
        spellName = "Zen Pilgrimage",
        category = "Monk",
        keywords = {"peak", "peak of serenity", "monk class hall"}
    },
    
    -- Shaman
    {
        name = "Home Location",
        spellID = 556,
        spellName = "Astral Recall",
        category = "Shaman",
        cooldown = "10 min",
        keywords = {"astral recall", "shaman hearth"}
    },
    
    -- Demon Hunter
    {
        name = "Fel Hammer",
        spellID = 189838,
        spellName = "Fel Hammer",
        category = "Demon Hunter",
        keywords = {"fel hammer", "dh class hall"}
    }
}

-- ============================================================================
-- TELEPORT TOYS
-- ============================================================================

local TeleportToys = {
    {
        name = "Ring of the Kirin Tor",
        itemID = 40586,
        spellName = "Ring of the Kirin Tor",
        category = "Toy",
        cooldown = "30 min",
        destination = "Dalaran (Northrend)",
        keywords = {"dalaran", "dal", "northrend"}
    },
    {
        name = "Jaina's Locket",
        itemID = 52251,
        spellName = "Jaina's Locket",
        category = "Toy",
        cooldown = "1 hour",
        destination = "Dalaran (Northrend)",
        keywords = {"dalaran", "dal", "northrend", "jaina"}
    },
    {
        name = "Cloak of Coordination",
        itemID = 65274,
        spellName = "Cloak of Coordination",
        category = "Toy",
        cooldown = "2 hours",
        destination = "Capital City",
        keywords = {"capital", "guild", "city"}
    },
    {
        name = "The Innkeeper's Daughter",
        itemID = 64488,
        spellName = "The Innkeeper's Daughter",
        category = "Toy",
        cooldown = "30 min",
        destination = "Home",
        keywords = {"home", "inn"}
    },
    {
        name = "Wormhole Generator: Northrend",
        itemID = 48933,
        spellName = "Wormhole Generator: Northrend",
        category = "Toy",
        cooldown = "4 hours",
        destination = "Northrend (Random)",
        keywords = {"northrend", "wormhole"}
    },
    {
        name = "Wormhole Generator: Pandaria",
        itemID = 87215,
        spellName = "Wormhole Generator: Pandaria",
        category = "Toy",
        cooldown = "15 min",
        destination = "Pandaria (Random)",
        keywords = {"pandaria", "wormhole", "mop"}
    },
    {
        name = "Wormhole Centrifuge",
        itemID = 112059,
        spellName = "Wormhole Centrifuge",
        category = "Toy",
        cooldown = "4 hours",
        destination = "Draenor (Random)",
        keywords = {"draenor", "wormhole", "wod"}
    },
    {
        name = "Wormhole Generator: Argus",
        itemID = 151652,
        spellName = "Wormhole Generator: Argus",
        category = "Toy",
        cooldown = "15 min",
        destination = "Argus (Random)",
        keywords = {"argus", "wormhole"}
    },
    {
        name = "Time-Lost Artifact",
        itemID = 103678,
        spellName = "Time-Lost Artifact",
        category = "Item",
        cooldown = "1 min",
        destination = "Timeless Isle",
        keywords = {"timeless isle", "timeless"}
    },
    {
        name = "Admiral's Compass",
        itemID = 128353,
        spellName = "Admiral's Compass",
        category = "Item",
        cooldown = "4 hours",
        destination = "Garrison Shipyard",
        keywords = {"garrison", "shipyard"}
    },
    {
        name = "Flight Master's Whistle",
        itemID = 141605,
        spellName = "Flight Master's Whistle",
        category = "Item",
        cooldown = "5 min",
        destination = "Nearest Flight Point",
        keywords = {"flight", "whistle", "fly"}
    }
}


-- ============================================================================
-- COMBINE ALL DATA
-- ============================================================================

EasyPort_DungeonData = {}

-- Merge all tables into one flat array
for _, v in ipairs(WarWithinSeason3) do
    table.insert(EasyPort_DungeonData, v)
end
for _, v in ipairs(ShadowlandsDungeons) do
    table.insert(EasyPort_DungeonData, v)
end
for _, v in ipairs(Hearthstones) do
    table.insert(EasyPort_DungeonData, v)
end
for _, v in ipairs(MageTeleports) do
    table.insert(EasyPort_DungeonData, v)
end
for _, v in ipairs(ClassTeleports) do
    table.insert(EasyPort_DungeonData, v)
end
for _, v in ipairs(TeleportToys) do
    table.insert(EasyPort_DungeonData, v)
end

-- Export category tables for potential future use
_G.EasyPort_Categories = {
    WarWithinSeason3 = WarWithinSeason3,
    ShadowlandsDungeons = ShadowlandsDungeons,
    Hearthstones = Hearthstones,
    MageTeleports = MageTeleports,
    ClassTeleports = ClassTeleports,
    TeleportToys = TeleportToys,
    TeleportItems = TeleportItems
}
