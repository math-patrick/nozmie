
-- ============================================================================
-- Nozmie - Data Module
-- Contains all teleport spells, items, and toys organized by category
-- Each entry has keywords array for detection in chat
-- ============================================================================
-- ============================================================================
-- MYTHIC+ DUNGEONS
-- ============================================================================
-- Battle for Azeroth Dungeons
local BfADungeons = {{
    name = "Operation: Mechagon",
    spellID = 373274,
    spellName = "Path of the Scrappy Prince",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"mechagon", "operation mechagon"}
}, {
    name = "Freehold",
    spellID = 410071,
    spellName = "Path of the Freebooter",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"freehold", "free hold", "freebooter"}
}, {
    name = "The Underrot",
    spellID = 410074,
    spellName = "Path of Festering Rot",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"underrot", "under rot"}
}, {
    name = "Atal'Dazar",
    spellID = 424187,
    spellName = "Path of the Golden Tomb",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"atal'dazar", "ataldazar", "atal"}
}, {
    name = "Waycrest Manor",
    spellID = 424167,
    spellName = "Path of Heart's Bane",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"waycrest", "manor", "waycrest manor", "wm"}
}, {
    name = "The MOTHERLODE!!",
    spellID = 467553,
    spellName = "Path of the Azerite Refinery",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"motherlode", "mother lode", "mld", "azerite"}
}, {
    name = "The MOTHERLODE!!",
    spellID = 467555,
    spellName = "Path of the Azerite Refinery",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"motherlode", "mother lode", "mld", "azerite"}
}}

-- Shadowlands Dungeons
local ShadowlandsDungeons = {{
    name = "Halls of Atonement",
    spellID = 354465,
    spellName = "Path of the Sinful Soul",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"halls", "halls of atonement", "hoa", "atonement"}
}, {
    name = "Plaguefall",
    spellID = 354463,
    spellName = "Path of the Plagued",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"plaguefall", "plague fall", "pf"}
}, {
    name = "Mists of Tirna Scithe",
    spellID = 354464,
    spellName = "Path of the Misty Forest",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"mists", "tirna scithe", "tirna", "mots"}
}, {
    name = "The Necrotic Wake",
    spellID = 354462,
    spellName = "Path of the Courageous",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"necrotic", "necrotic wake", "nw", "wake"}
}, {
    name = "Sanguine Depths",
    spellID = 354469,
    spellName = "Path of the Stone Warden",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"sanguine", "sanguine depths", "sd", "depths"}
}, {
    name = "Spires of Ascension",
    spellID = 354466,
    spellName = "Path of the Ascended",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"spires", "spires of ascension", "soa", "ascension"}
}, {
    name = "Theater of Pain",
    spellID = 354467,
    spellName = "Path of the Undefeated",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"theater", "theater of pain"}
}, {
    name = "De Other Side",
    spellID = 354468,
    spellName = "Path of the Scheming Loa",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"de other side", "dos"}
}, {
    name = "Tazavesh, the Veiled Market",
    spellID = 367416,
    spellName = "Path of the Streetwise Merchant",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"tazavesh", "taza", "veiled market"}
}}

-- Legion Dungeons
local LegionDungeons = {{
    name = "Halls of Valor",
    spellID = 393764,
    spellName = "Path of Proven Worth",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"halls of valor", "valor", "hov"}
}, {
    name = "Court of Stars",
    spellID = 393766,
    spellName = "Path of the Grand Magistrix",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"court of stars", "court", "cos"}
}, {
    name = "Darkheart Thicket",
    spellID = 424163,
    spellName = "Path of the Nightmare Lord",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"darkheart", "thicket", "dht"}
}, {
    name = "Black Rook Hold",
    spellID = 424153,
    spellName = "Path of Ancient Horrors",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"black rook", "rook hold", "brh"}
}, {
    name = "Neltharion's Lair",
    spellID = 410078,
    spellName = "Path of the Earth-Warder",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"neltharion", "lair", "nl"}
}, {
    name = "Karazhan",
    spellID = 373262,
    spellName = "Path of the Fallen Guardian",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"karazhan"}
}}

-- Cataclysm Dungeons
local CataclysmDungeons = {{
    name = "Vortex Pinnacle",
    spellID = 410080,
    spellName = "Path of Wind's Domain",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"vortex", "pinnacle", "vp"}
}, {
    name = "Throne of the Tides",
    spellID = 424142,
    spellName = "Path of the Tidehunter",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"throne", "tides", "tot"}
}}

-- Dragonflight Dungeons
local DragonflightDungeons = {{
    name = "Uldaman: Legacy of Tyr",
    spellID = 393222,
    spellName = "Path of the Watcher's Legacy",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"uldaman", "legacy of tyr"}
}, {
    name = "Ruby Life Pools",
    spellID = 393256,
    spellName = "Path of the Clutch Defender",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"ruby", "ruby life pools", "rlp", "life pools"}
}, {
    name = "The Nokhud Offensive",
    spellID = 393262,
    spellName = "Path of the Windswept Plains",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"nokhud", "nokhud offensive"}
}, {
    name = "The Azure Vault",
    spellID = 393279,
    spellName = "Path of Arcane Secrets",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"azure", "azure vault"}
}, {
    name = "Algeth'ar Academy",
    spellID = 393273,
    spellName = "Path of the Draconic Diploma",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"algethar", "algeth'ar", "academy"}
}, {
    name = "Neltharus",
    spellID = 393276,
    spellName = "Path of the Obsidian Hoard",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"neltharus", "nelth", "obsidian"}
}, {
    name = "Brackenhide Hollow",
    spellID = 393267,
    spellName = "Path of the Rotting Woods",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"brackenhide", "bracken", "hollow", "bhh"}
}, {
    name = "Halls of Infusion",
    spellID = 393283,
    spellName = "Path of the Titanic Reservoir",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"halls", "infusion", "halls of infusion", "hoi"}
}, {
    name = "Dawn of the Infinite",
    spellID = 424197,
    spellName = "Path of Twisted Time",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"dawn", "dawn of the infinite", "doti"}
}}

-- The War Within Season 1
local WarWithinSeason1 = {{
    name = "Ara-Kara, City of Echoes",
    spellID = 445417,
    spellName = "Path of the Ruined City",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"ara-kara", "ara kara", "arakara", "city of echoes", "ara"}
}, {
    name = "City of Threads",
    spellID = 445416,
    spellName = "Path of Nerubian Ascension",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"city of threads", "threads", "nerub-ar city", "nerubar"}
}, {
    name = "The Stonevault",
    spellID = 445269,
    spellName = "Path of the Corrupted Foundry",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"stonevault", "stone vault", "corrupted foundry"}
}, {
    name = "The Dawnbreaker",
    spellID = 445414,
    spellName = "Path of the Arathi Flagship",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"dawnbreaker", "dawn breaker", "arathi flagship"}
}, {
    name = "Priory of the Sacred Flame",
    spellID = 445444,
    spellName = "Path of the Light's Reverence",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"priory", "sacred flame", "lights reverence"}
}, {
    name = "The Rookery",
    spellID = 445443,
    spellName = "Path of the Fallen Stormriders",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"rookery", "fallen stormriders"}
}, {
    name = "Siege of Boralus",
    spellID = 445418,
    spellName = "Path of the Besieged Harbor",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"siege", "boralus", "siege of boralus"}
}, {
    name = "Siege of Boralus",
    spellID = 464256,
    spellName = "Path of the Besieged Harbor",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"siege", "boralus", "siege of boralus"}
}, {
    name = "Grim Batol",
    spellID = 445424,
    spellName = "Path of the Twilight Fortress",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"grim batol", "grim", "batol", "gb"}
}}

-- The War Within Season 2
local WarWithinSeason2 = {{
    name = "Cinderbrew Meadery",
    spellID = 445440,
    spellName = "Path of the Flaming Brewery",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"cinderbrew", "meadery", "cinder brew"}
}, {
    name = "Cinderbrew Meadery",
    spellID = 467546,
    spellName = "Path of the Waterworks",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"cinderbrew", "meadery", "cinder brew", "waterworks"}
}, {
    name = "Darkflame Cleft",
    spellID = 445441,
    spellName = "Path of the Warding Candles",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"darkflame", "cleft", "darkflame cleft"}
}}

-- The War Within Season 3 (Current)
local WarWithinSeason3 = {{
    name = "Floodgate",
    spellID = 1216786,
    spellName = "Path of Circuit Breaker",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"floodgate", "flood gate", "circuit breaker"}
}, {
    name = "Eco-Dome Al'dani",
    spellID = 1237215,
    spellName = "Path of the Eco-Dome",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"eco-dome", "eco dome", "ecodome", "aldani"}
}}

-- Midnight Season 1 (Future)
local MidnightSeason1 = {{
    name = "Pit of Saron",
    spellID = 999001, -- Placeholder - update when available
    spellName = "Path of the Frozen Halls",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"pit of saron", "pit", "saron"}
}, {
    name = "Skyreach",
    spellID = 999002, -- Placeholder - update when available
    spellName = "Path of the Arakkoa",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"skyreach", "sky reach"}
}, {
    name = "Seat of the Triumvirate",
    spellID = 999003, -- Placeholder - update when available
    spellName = "Path of the Void",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"seat", "triumvirate", "seat of the triumvirate", "sott"}
}, {
    name = "Magisters' Terrace",
    spellID = 999004, -- Placeholder - update when available
    spellName = "Path of the Sun's Reach",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"magisters", "magister's terrace", "terrace"}
}, {
    name = "Maisara Caverns",
    spellID = 999005, -- Placeholder - update when available
    spellName = "Path of the Maisara",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"maisara", "caverns", "maisara caverns"}
}, {
    name = "Nexus-Point Xenas",
    spellID = 999006, -- Placeholder - update when available
    spellName = "Path of the Nexus",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"nexus-point", "xenas", "nexus point xenas"}
}, {
    name = "Windrunner Spire",
    spellID = 999007, -- Placeholder - update when available
    spellName = "Path of the Windrunner",
    actionType = "spell",
    category = "M+ Dungeon",
    keywords = {"windrunner", "spire", "windrunner spire"}
}}

local DungeonSeasonPriorityNames = {
    MidnightSeason1 = {"Pit of Saron", "Skyreach", "Seat of the Triumvirate", "Magisters' Terrace", "Maisara Caverns",
                       "Nexus-Point Xenas", "Windrunner Spire"},
    WarWithinSeason3 = {"Eco-Dome Al'dani", "Ara-Kara, City of Echoes", "The Dawnbreaker", "Priory of the Sacred Flame", "Floodgate", "Halls of Atonement", "Tazavesh, the Veiled Market"}
}

local DungeonsByExpansion = {
    WarWithin = {
        Season1 = WarWithinSeason1,
        Season2 = WarWithinSeason2,
        Season3 = WarWithinSeason3
    },
    Midnight = {
        Season1 = MidnightSeason1
    },
    Dragonflight = DragonflightDungeons,
    Shadowlands = ShadowlandsDungeons,
    BattleForAzeroth = BfADungeons,
    Legion = LegionDungeons,
    Cataclysm = CataclysmDungeons
}

-- ============================================================================
-- HEARTHSTONES & HOME TELEPORTS
-- ============================================================================

local Hearthstones = {{
    name = "Hearthstone",
    itemID = 6948,
    spellID = 8690,
    spellName = "Hearthstone",
    actionType = "spell",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn"}
}, {
    name = "Garrison Hearthstone",
    itemID = 110560,
    spellID = 171253,
    spellName = "Garrison Hearthstone",
    actionType = "spell",
    category = "Home",
    cooldown = "20 min",
    keywords = {"garrison", "garrison hearth"}
}, {
    name = "Dark Portal",
    itemID = 93672,
    spellName = "Dark Portal",
    actionType = "item",
    category = "Home",
    cooldown = "No CD",
    keywords = {"dark portal"}
}, {
    name = "Ethereal Portal",
    itemID = 54452,
    spellName = "Ethereal Portal",
    actionType = "item",
    category = "Home",
    cooldown = "No CD",
    keywords = {"ethereal"}
}, {
    name = "Scroll of Recall",
    itemID = 37118,
    spellName = "Scroll of Recall",
    actionType = "item",
    category = "Home",
    cooldown = "No CD",
    keywords = {"scroll of recall", "recall"}
}, {
    name = "Scroll of Recall II",
    itemID = 44314,
    spellName = "Scroll of Recall II",
    actionType = "item",
    category = "Home",
    cooldown = "No CD",
    keywords = {"scroll of recall", "recall"}
}, {
    name = "Scroll of Recall III",
    itemID = 44315,
    spellName = "Scroll of Recall III",
    actionType = "item",
    category = "Home",
    cooldown = "No CD",
    keywords = {"scroll of recall", "recall"}
}, {
    name = "Astonishingly Scarlet Slippers",
    itemID = 142298,
    spellName = "Astonishingly Scarlet Slippers",
    actionType = "item",
    category = "Home",
    cooldown = "No CD",
    keywords = {"scarlet slippers", "slippers"}
}, {
    name = "Scroll of Town Portal",
    itemID = 142543,
    spellName = "Scroll of Town Portal",
    actionType = "item",
    category = "Home",
    cooldown = "No CD",
    keywords = {"town portal", "portal scroll"}
}, {
    name = "Tome of Town Portal",
    itemID = 142542,
    spellName = "Tome of Town Portal",
    actionType = "item",
    category = "Home",
    cooldown = "No CD",
    keywords = {"tome", "town portal"}
}, {
    name = "Dalaran Hearthstone",
    itemID = 140192,
    spellID = 193759,
    spellName = "Dalaran Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "20 min",
    keywords = {"dalaran", "dal", "dalaran hearth"}
}, -- Hearthstone Toys (cosmetic variants)
{
    name = "Eternal Traveler's Hearthstone",
    itemID = 172179,
    spellID = 308742,
    spellName = "Eternal Traveler's Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "eternal"}
}, {
    name = "Brewfest Reveler's Hearthstone",
    itemID = 166747,
    spellID = 286331,
    spellName = "Brewfest Reveler's Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "brewfest"}
}, {
    name = "Headless Horseman's Hearthstone",
    itemID = 163045,
    spellID = 278559,
    spellName = "Headless Horseman's Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "horseman"}
}, {
    name = "Lunar Elder's Hearthstone",
    itemID = 165669,
    spellID = 278244,
    spellName = "Lunar Elder's Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "lunar"}
}, {
    name = "Peddlefeet's Lovely Hearthstone",
    itemID = 165670,
    spellID = 278880,
    spellName = "Peddlefeet's Lovely Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "peddlefeet"}
}, {
    name = "Noble Gardener's Hearthstone",
    itemID = 165802,
    spellID = 278559,
    spellName = "Noble Gardener's Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "noble"}
}, {
    name = "Fire Eater's Hearthstone",
    itemID = 166746,
    spellID = 286353,
    spellName = "Fire Eater's Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "fire eater"}
}, {
    name = "Greatfather Winter's Hearthstone",
    itemID = 162973,
    spellID = 278853,
    spellName = "Greatfather Winter's Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "winter"}
}, {
    name = "Holographic Digitalization Hearthstone",
    itemID = 168907,
    spellID = 298068,
    spellName = "Holographic Digitalization Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "holo"}
}, {
    name = "Dominated Hearthstone",
    itemID = 188952,
    spellID = 356389,
    spellName = "Dominated Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "dominated"}
}, {
    name = "Enlightened Hearthstone",
    itemID = 190237,
    spellID = 363799,
    spellName = "Enlightened Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "enlightened"}
}, {
    name = "Broker Translocation Matrix",
    itemID = 190196,
    spellID = 367013,
    spellName = "Broker Translocation Matrix",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "broker"}
}, {
    name = "Deepdweller's Earthen Hearthstone",
    itemID = 208704,
    spellID = 422284,
    spellName = "Deepdweller's Earthen Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "earthen"}
}, {
    name = "Hearthstone of the Flame",
    itemID = 209035,
    spellName = "Hearthstone of the Flame",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "flame"}
}, {
    name = "Draenic Hologem",
    itemID = 210455,
    spellName = "Draenic Hologem",
    actionType = "item",
    category = "Home",
    cooldown = "No CD",
    keywords = {"hologem", "draenic", "draenei"}
}, {
    name = "Stone of the Hearth",
    itemID = 212337,
    spellName = "Stone of the Hearth",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn"}
}, {
    name = "Timewalker's Hearthstone",
    itemID = 193588,
    spellID = 427335,
    spellName = "Timewalker's Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "timewalker"}
}, {
    name = "Ohn'ir Windsage's Hearthstone",
    itemID = 200630,
    spellName = "Ohn'ir Windsage's Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "ohn'ir"}
}, {
    name = "Path of the Naaru",
    itemID = 206195,
    spellName = "Path of the Naaru",
    actionType = "item",
    category = "Home",
    cooldown = "No CD",
    keywords = {"naaru", "path"}
}, {
    name = "Notorious Thread's Hearthstone",
    itemID = 228940,
    spellName = "Notorious Thread's Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "thread"}
}, {
    name = "Redeployment Module",
    itemID = 235016,
    spellName = "Redeployment Module",
    actionType = "item",
    category = "Home",
    cooldown = "No CD",
    keywords = {"redeployment", "module"}
}, {
    name = "Explosive Hearthstone",
    itemID = 236687,
    spellName = "Explosive Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "explosive"}
}, {
    name = "P.O.S.T. Master's Express Hearthstone",
    itemID = 245970,
    spellName = "P.O.S.T. Master's Express Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "post"}
}, {
    name = "Cosmic Hearthstone",
    itemID = 246565,
    spellName = "Cosmic Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "cosmic"}
}, {
    name = "Timerunner's Hearthstone",
    itemID = 250411,
    spellName = "Timerunner's Hearthstone",
    actionType = "toy",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "timerunner"}
}, {
    name = "Naaru's Enfold",
    itemID = 263489,
    spellName = "Naaru's Enfold",
    actionType = "item",
    category = "Home",
    cooldown = "No CD",
    keywords = {"naaru", "enfold"}
}}

-- ============================================================================
-- MAGE TELEPORTS
-- ============================================================================

local MageTeleports = { -- Alliance Cities
{
    name = "Stormwind",
    spellID = 3561,
    spellName = "Teleport: Stormwind",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"stormwind", "sw", "storm wind"}
}, {
    name = "Ironforge",
    spellID = 3562,
    spellName = "Teleport: Ironforge",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"ironforge", "iron forge"}
}, {
    name = "Darnassus",
    spellID = 3565,
    spellName = "Teleport: Darnassus",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"darnassus", "darn"}
}, {
    name = "Exodar",
    spellID = 32271,
    spellName = "Teleport: Exodar",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"exodar"}
}, {
    name = "Boralus",
    spellID = 281403,
    spellName = "Teleport: Boralus",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"boralus"}
}, -- Horde Cities
{
    name = "Orgrimmar",
    spellID = 3567,
    spellName = "Teleport: Orgrimmar",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"orgrimmar", "org"}
}, {
    name = "Undercity",
    spellID = 3563,
    spellName = "Teleport: Undercity",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"undercity", "uc", "under city"}
}, {
    name = "Thunder Bluff",
    spellID = 3566,
    spellName = "Teleport: Thunder Bluff",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"thunder bluff", "thunderbluff", "tb"}
}, {
    name = "Silvermoon",
    spellID = 32272,
    spellName = "Teleport: Silvermoon",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"silvermoon", "silver moon", "sm"}
}, {
    name = "Dazar'alor",
    spellID = 281404,
    spellName = "Teleport: Dazar'alor",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"dazaralor", "dazar", "dazar'alor"}
}, -- Neutral Cities
{
    name = "Shattrath",
    spellID = 33690,
    spellName = "Teleport: Shattrath",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"shattrath", "shatt"}
}, {
    name = "Dalaran (Northrend)",
    spellID = 53140,
    spellName = "Teleport: Dalaran - Northrend",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"dalaran", "dal", "northrend dal"}
}, {
    name = "Dalaran (Broken Isles)",
    spellID = 224869,
    spellName = "Teleport: Dalaran - Broken Isles",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"dalaran", "dal", "legion dal", "broken isles"}
}, {
    name = "Vale of Eternal Blossoms",
    spellID = 132621,
    spellName = "Teleport: Vale of Eternal Blossoms",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"vale", "vale of eternal blossoms"}
}, {
    name = "Oribos",
    spellID = 344587,
    spellName = "Teleport: Oribos",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"oribos"}
}, {
    name = "Valdrakken",
    spellID = 395277,
    spellName = "Teleport: Valdrakken",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"valdrakken", "vald"}
}, {
    name = "Dornogal",
    spellID = 446540,
    spellName = "Teleport: Dornogal",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"dornogal"}
}, {
    name = "Stormshield",
    spellID = 176248,
    spellName = "Teleport: Stormshield",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"stormshield", "ashran"}
}, {
    name = "Warspear",
    spellID = 176242,
    spellName = "Teleport: Warspear",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"warspear", "ashran"}
}, {
    name = "Theramore",
    spellID = 49359,
    spellName = "Teleport: Theramore",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"theramore"}
}, {
    name = "Stonard",
    spellID = 49358,
    spellName = "Teleport: Stonard",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"stonard"}
}, {
    name = "Tol Barad",
    spellID = 88342,
    spellName = "Teleport: Tol Barad",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"tol barad"}
}, {
    name = "Tol Barad",
    spellID = 88344,
    spellName = "Teleport: Tol Barad",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"tol barad"}
}, {
    name = "Dalaran (Crater)",
    spellID = 120145,
    spellName = "Ancient Teleport: Dalaran",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"dalaran", "crater", "ancient"}
}, {
    name = "Dalaran (Northrend)",
    spellID = 53142,
    spellName = "Portal: Dalaran",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"dalaran", "northrend"}
}, {
    name = "Dalaran (Broken Isles)",
    spellID = 224871,
    spellName = "Portal: Dalaran - Broken Isles",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"dalaran", "broken isles", "legion"}
}, {
    name = "Stormwind",
    spellID = 10059,
    spellName = "Portal: Stormwind",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"stormwind", "sw"}
}, {
    name = "Ironforge",
    spellID = 11416,
    spellName = "Portal: Ironforge",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"ironforge"}
}, {
    name = "Darnassus",
    spellID = 11419,
    spellName = "Portal: Darnassus",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"darnassus"}
}, {
    name = "Exodar",
    spellID = 32266,
    spellName = "Portal: Exodar",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"exodar"}
}, {
    name = "Boralus",
    spellID = 281400,
    spellName = "Portal: Boralus",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"boralus"}
}, {
    name = "Orgrimmar",
    spellID = 11417,
    spellName = "Portal: Orgrimmar",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"orgrimmar", "org"}
}, {
    name = "Undercity",
    spellID = 11418,
    spellName = "Portal: Undercity",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"undercity", "uc"}
}, {
    name = "Thunder Bluff",
    spellID = 11420,
    spellName = "Portal: Thunder Bluff",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"thunder bluff", "tb"}
}, {
    name = "Silvermoon",
    spellID = 32267,
    spellName = "Portal: Silvermoon",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"silvermoon"}
}, {
    name = "Dazar'alor",
    spellID = 281402,
    spellName = "Portal: Dazar'alor",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"dazar'alor", "dazar"}
}, {
    name = "Shattrath",
    spellID = 35715,
    spellName = "Teleport: Shattrath",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"shattrath", "shatt"}
}, {
    name = "Shattrath",
    spellID = 33691,
    spellName = "Portal: Shattrath",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"shattrath"}
}, {
    name = "Shattrath",
    spellID = 35717,
    spellName = "Portal: Shattrath",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"shattrath"}
}, {
    name = "Vale of Eternal Blossoms",
    spellID = 132627,
    spellName = "Teleport: Vale of Eternal Blossoms",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"vale", "vale of eternal blossoms"}
}, {
    name = "Vale of Eternal Blossoms",
    spellID = 132620,
    spellName = "Portal: Vale of Eternal Blossoms",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"vale"}
}, {
    name = "Vale of Eternal Blossoms",
    spellID = 132622,
    spellName = "Portal: Vale of Eternal Blossoms",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"vale"}
}, {
    name = "Vale of Eternal Blossoms",
    spellID = 132624,
    spellName = "Portal: Vale of Eternal Blossoms",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"vale"}
}, {
    name = "Vale of Eternal Blossoms",
    spellID = 132626,
    spellName = "Portal: Vale of Eternal Blossoms",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"vale"}
}, {
    name = "Oribos",
    spellID = 344597,
    spellName = "Portal: Oribos",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"oribos"}
}, {
    name = "Valdrakken",
    spellID = 395289,
    spellName = "Portal: Valdrakken",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"valdrakken"}
}, {
    name = "Dornogal",
    spellID = 446534,
    spellName = "Portal: Dornogal",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"dornogal"}
}, {
    name = "Stormshield",
    spellID = 176246,
    spellName = "Portal: Stormshield",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"stormshield", "ashran"}
}, {
    name = "Warspear",
    spellID = 176244,
    spellName = "Portal: Warspear",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"warspear", "ashran"}
}, {
    name = "Theramore",
    spellID = 49360,
    spellName = "Portal: Theramore",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"theramore"}
}, {
    name = "Stonard",
    spellID = 49361,
    spellName = "Portal: Stonard",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"stonard"}
}, {
    name = "Tol Barad",
    spellID = 88345,
    spellName = "Portal: Tol Barad",
    actionType = "spell",
    category = "Class",
    faction = "Alliance",
    keywords = {"tol barad", "tb"}
}, {
    name = "Tol Barad",
    spellID = 88346,
    spellName = "Portal: Tol Barad",
    actionType = "spell",
    category = "Class",
    faction = "Horde",
    keywords = {"tol barad", "tb"}
}, {
    name = "Dalaran (Crater)",
    spellID = 120146,
    spellName = "Ancient Portal: Dalaran",
    actionType = "spell",
    category = "Class",
    faction = "Neutral",
    keywords = {"dalaran", "crater", "ancient"}
}}

-- ============================================================================
-- CLASS TELEPORTS
-- ============================================================================

local ClassTeleports = { -- Druid
{
    name = "Moonglade",
    spellID = 18960,
    spellName = "Teleport: Moonglade",
    actionType = "spell",
    category = "Class",
    keywords = {"moonglade"}
}, {
    name = "Emerald Dreamway",
    spellID = 193753,
    spellName = "Dreamwalk",
    actionType = "spell",
    category = "Class",
    keywords = {"dreamway", "dream way", "emerald dreamway"}
}, -- Death Knight
{
    name = "Ebon Hold",
    spellID = 50977,
    spellName = "Death Gate",
    actionType = "spell",
    category = "Class",
    keywords = {"ebon hold", "death gate", "acherus"}
}, -- Monk
{
    name = "Peak of Serenity",
    spellID = 126892,
    spellName = "Zen Pilgrimage",
    actionType = "spell",
    category = "Class",
    keywords = {"peak", "peak of serenity", "monk class hall"}
}, -- Shaman
{
    name = "Home Location",
    spellID = 556,
    spellName = "Astral Recall",
    actionType = "spell",
    category = "Class",
    cooldown = "10 min",
    keywords = {"astral recall", "shaman hearth"}
}, -- Demon Hunter
{
    name = "Fel Hammer",
    spellID = 189838,
    spellName = "Fel Hammer",
    actionType = "spell",
    category = "Class",
    keywords = {"fel hammer", "dh class hall"}
}, {
    name = "Hall of the Guardian",
    spellID = 193759,
    spellName = "Teleport: Hall of the Guardian",
    actionType = "spell",
    category = "Class",
    keywords = {"hall of the guardian", "guardian", "mage class hall"}
}}

-- ============================================================================
-- RAID TELEPORTS
-- ============================================================================

local RaidTeleports = {{
    name = "Castle Nathria",
    spellID = 373190,
    spellName = "Path of the Sire",
    actionType = "spell",
    category = "Raid",
    keywords = {"nathria", "castle nathria"}
}, {
    name = "Sanctum of Domination",
    spellID = 373191,
    spellName = "Path of the Tormented Soul",
    actionType = "spell",
    category = "Raid",
    keywords = {"sanctum", "domination"}
}, {
    name = "Sepulcher of the First Ones",
    spellID = 373192,
    spellName = "Path of the First Ones",
    actionType = "spell",
    category = "Raid",
    keywords = {"sepulcher", "first ones"}
}, {
    name = "Vault of the Incarnates",
    spellID = 432254,
    spellName = "Path of the Primal Prison",
    actionType = "spell",
    category = "Raid",
    keywords = {"vault", "incarnates", "voti"}
}, {
    name = "Aberrus, the Shadowed Crucible",
    spellID = 432257,
    spellName = "Path of the Bitter Legacy",
    actionType = "spell",
    category = "Raid",
    keywords = {"aberrus", "shadowed crucible"}
}, {
    name = "Amirdrassil, the Dream's Hope",
    spellID = 432258,
    spellName = "Path of the Scorching Dream",
    actionType = "spell",
    category = "Raid",
    keywords = {"amirdrassil", "dream's hope", "dreams hope"}
}, {
    name = "Manaforge Omega",
    spellID = 1239155,
    spellName = "Path of the All-Devouring",
    actionType = "spell",
    category = "Raid",
    keywords = {"manaforge", "omega", "k'aresh", "karesh"}
}, {
    name = "Liberation of Undermine",
    spellID = 1226482,
    spellName = "Path of the Full House",
    actionType = "spell",
    category = "Raid",
    keywords = {"undermine", "liberation"}
}}

-- ============================================================================
-- DELVE TELEPORTS
-- ============================================================================

local DelveTeleports = {{
    name = "Delve-O-bot 7001",
    itemID = 232450,
    spellName = "Delve-O-bot 7001",
    actionType = "item",
    category = "Delve",
    cooldown = "15 min",
    destination = "Random Delve",
    keywords = {"delve", "delveobot", "delve-obot", "7001", "random", "bountiful"}
}, {
    name = "Delver's Mana-Bound Ethergate",
    itemID = 232407,
    spellName = "Delver's Mana-Bound Ethergate",
    actionType = "item",
    category = "Delve",
    cooldown = "20 min",
    destination = "Dornogal",
    keywords = {"delve", "ethergate", "mana-bound", "dornogal"}
}}

-- ============================================================================
-- CLASS UTILITY SPELLS
-- ============================================================================

local ClassUtilities = { -- Mage Utilities
{
    name = "Conjure Refreshment",
    spellID = 190336,
    spellName = "Conjure Refreshment",
    actionType = "spell",
    category = "Class Utility",
    keywords = {"cookies", "food", "mana buns", "refreshment", "table", "mage table"}
}, {
    name = "Arcane Intellect",
    spellID = 1459,
    spellName = "Arcane Intellect",
    actionType = "spell",
    category = "Class Utility",
    keywords = {"intellect", "arcane intellect", "buff"}
}, {
    name = "Slow Fall",
    spellID = 130,
    spellName = "Slow Fall",
    actionType = "spell",
    category = "Class Utility",
    keywords = {"slow fall", "slowfall", "slow", "sf"}
}, -- Warlock Utilities
{
    name = "Ritual of Summoning",
    spellID = 698,
    spellName = "Ritual of Summoning",
    actionType = "spell",
    category = "Class Utility",
    keywords = {"summon", "resummon", "summ", "summons", "lock summon", "warlock summon"}
}, {
    name = "Create Soulwell",
    spellID = 29893,
    spellName = "Create Soulwell",
    actionType = "spell",
    category = "Class Utility",
    keywords = {"soulwell", "soul well", "lock well", "healthstones", "healthstone", "health stone", "hs", "lock rock",
                "cookie", "cookies", "buff"}
},{
    name = "Soulstone",
    spellID = 20707,
    spellName = "Soulstone",
    actionType = "spell",
    category = "Class Utility",
    keywords = {"soulstone", "soul stone", "buff", "ss"}
}, -- Priest Utilities
{
    name = "Power Word: Fortitude",
    spellID = 21562,
    spellName = "Power Word: Fortitude",
    actionType = "spell",
    category = "Class Utility",
    keywords = {"fort", "fortitude", "stamina", "buff", "pw:f"}
}, {
    name = "Levitate",
    spellID = 1706,
    spellName = "Levitate",
    actionType = "spell",
    category = "Class Utility",
    keywords = {"levitate"}
}, -- Druid Utilities
{
    name = "Battle Shout",
    spellID = 6673,
    spellName = "Battle Shout",
    actionType = "spell",
    category = "Class Utility",
    keywords = {"battle shout", "shout", "buff"}
}, -- Warrior Utility
{
    name = "Mark of the Wild",
    spellID = 1126,
    spellName = "Mark of the Wild",
    actionType = "spell",
    category = "Class Utility",
    keywords = {"motw", "mark", "mark of the wild", "buff"}
}, -- Shaman Utilities
{
    name = "Skyfury",
    spellID = 462854,
    spellName = "Skyfury",
    actionType = "spell",
    category = "Class Utility",
    keywords = {"skyfury", "buff", "sky fury"}
},  -- Evoker Utilities
{
    name = "Blessing of the Bronze",
    spellID = 364342,
    spellName = "Blessing of the Bronze",
    actionType = "spell",
    category = "Class Utility",
    keywords = {"blessing of the bronze", "botb", "buff"}
}, {
    name = "Source of Magic",
    spellID = 369459,
    spellName = "Source of Magic",
    actionType = "spell",
    category = "Class Utility",
    keywords = {"source", "source of magic", "evoker mana", "buff"}
}}

-- ============================================================================
-- TELEPORT TOYS
-- ============================================================================

local TeleportToys = {{
    name = "Ring of the Kirin Tor",
    itemID = 40586,
    spellName = "Ring of the Kirin Tor",
    actionType = "toy",
    category = "Toy",
    cooldown = "30 min",
    destination = "Dalaran (Northrend)",
    keywords = {"dalaran", "dal", "northrend"}
}, {
    name = "Jaina's Locket",
    itemID = 52251,
    spellName = "Jaina's Locket",
    actionType = "toy",
    category = "Toy",
    cooldown = "1 hour",
    destination = "Dalaran (Northrend)",
    keywords = {"dalaran", "dal", "northrend", "jaina"}
}, {
    name = "Cloak of Coordination",
    itemID = 65274,
    spellName = "Cloak of Coordination",
    actionType = "toy",
    category = "Toy",
    cooldown = "2 hours",
    destination = "Capital City",
    keywords = {"capital", "city", "stormwind", "orgrimmar", "coordination"}
}, {
    name = "The Innkeeper's Daughter",
    itemID = 64488,
    spellName = "The Innkeeper's Daughter",
    actionType = "toy",
    category = "Toy",
    cooldown = "30 min",
    destination = "Home",
    keywords = {"home", "inn"}
}, {
    name = "Wormhole Generator: Northrend",
    itemID = 48933,
    spellName = "Wormhole Generator: Northrend",
    actionType = "toy",
    category = "Toy",
    cooldown = "4 hours",
    destination = "Northrend (Random)",
    keywords = {"northrend", "wormhole", "borean tundra", "howling fjord", "dragonblight", "grizzly hills", "zul'drak",
                "sholazar", "storm peaks", "icecrown"}
}, {
    name = "Wormhole Generator: Pandaria",
    itemID = 87215,
    spellName = "Wormhole Generator: Pandaria",
    actionType = "toy",
    category = "Toy",
    cooldown = "15 min",
    destination = "Pandaria (Random)",
    keywords = {"pandaria", "wormhole", "mop", "jade forest", "krasarang", "krasarang wilds", "valley of the four winds",
                "kun-lai summit", "townlong steppes", "dread wastes", "vale of eternal blossoms"}
}, {
    name = "Wormhole Centrifuge",
    itemID = 112059,
    spellName = "Wormhole Centrifuge",
    actionType = "toy",
    category = "Toy",
    cooldown = "4 hours",
    destination = "Draenor (Random)",
    keywords = {"draenor", "wormhole", "wod", "frostfire ridge", "shadowmoon valley", "gorgrond", "talador",
                "spires of arak", "nagrand"}
}, {
    name = "Wormhole Generator: Argus",
    itemID = 151652,
    spellName = "Wormhole Generator: Argus",
    actionType = "toy",
    category = "Toy",
    cooldown = "15 min",
    destination = "Argus (Random)",
    keywords = {"argus", "wormhole", "krokuun", "antoran wastes", "mac'aree", "macaree"}
}, {
    name = "Wormhole Generator: Kul Tiras",
    itemID = 168807,
    spellName = "Wormhole Generator: Kul Tiras",
    actionType = "toy",
    category = "Toy",
    cooldown = "15 min",
    destination = "Kul Tiras (Random)",
    keywords = {"kul tiras", "kultiras", "wormhole", "tiragarde", "tiragarde sound", "drustvar", "stormsong",
                "stormsong valley"}
}, {
    name = "Wormhole Generator: Zandalar",
    itemID = 168808,
    spellName = "Wormhole Generator: Zandalar",
    actionType = "toy",
    category = "Toy",
    cooldown = "15 min",
    destination = "Zandalar (Random)",
    keywords = {"zandalar", "wormhole", "zuldazar", "nazmir", "vol'dun", "voldun"}
}, {
    name = "Wormhole Generator: Shadowlands",
    itemID = 172924,
    spellName = "Wormhole Generator: Shadowlands",
    actionType = "toy",
    category = "Toy",
    cooldown = "15 min",
    destination = "Shadowlands (Random)",
    keywords = {"shadowlands", "wormhole", "sl", "bastion", "maldraxxus", "ardenweald", "revendreth", "the maw", "maw"}
}, {
    name = "Wormhole Generator: Khaz Algar",
    itemID = 221966,
    spellName = "Wormhole Generator: Khaz Algar",
    actionType = "toy",
    category = "Toy",
    cooldown = "15 min",
    destination = "Khaz Algar (Random)",
    keywords = {"khaz algar", "khazalgar", "wormhole", "tww", "isle of dorn", "ringing deeps", "hallowfall",
                "azj-kahet", "azj kahet"}
}, {
    name = "Time-Lost Artifact",
    itemID = 103678,
    spellName = "Time-Lost Artifact",
    actionType = "toy",
    category = "Toy",
    cooldown = "1 min",
    destination = "Timeless Isle",
    keywords = {"timeless isle", "timeless"}
}, {
    name = "Ultrasafe Transporter: Mechagon",
    itemID = 167075,
    spellName = "Ultrasafe Transporter: Mechagon",
    actionType = "toy",
    category = "Toy",
    cooldown = "1 hour",
    destination = "Mechagon",
    keywords = {"mechagon", "gnome", "transporter"}
}, {
    name = "Mole Machine",
    itemID = 115543,
    spellName = "Mole Machine",
    actionType = "toy",
    category = "Toy",
    cooldown = "30 min",
    destination = "Various",
    keywords = {"mole machine", "dark iron"}
}, {
    name = "Violet Seal of the Grand Magus",
    itemID = 142469,
    spellName = "Violet Seal of the Grand Magus",
    actionType = "toy",
    category = "Toy",
    cooldown = "4 hours",
    destination = "Karazhan",
    keywords = {"karazhan"}
}, {
    name = "Fractured Necrolyte Skull",
    itemID = 151016,
    spellName = "Fractured Necrolyte Skull",
    actionType = "toy",
    category = "Toy",
    cooldown = "2 hours",
    destination = "Black Temple",
    keywords = {"black temple", "bt", "necrolyte", "skull"}
}, {
    name = "Unstable Portal Emitter",
    itemID = 227669,
    spellName = "Unstable Portal Emitter",
    actionType = "toy",
    category = "Toy",
    cooldown = "30 min",
    destination = "Random",
    keywords = {"emitter", "unstable", "random"}
}}

-- ============================================================================
-- REPAIR & MAILBOX UTILITIES
-- ============================================================================

local ServiceToys = {{
    name = "Jeeves",
    itemID = 49040,
    spellName = "Jeeves",
    actionType = "item",
    category = "Utility",
    cooldown = "1 hour",
    destination = "Jeeves",
    keywords = {"jeeves", "repair", "vendor", "bank"}
}, {
    name = "Auto-Hammer",
    itemID = 23767,
    spellName = "Auto-Hammer",
    actionType = "item",
    category = "Utility",
    cooldown = "1 hour",
    destination = "Repair",
    keywords = {"auto-hammer", "auto hammer", "repair"}
}, {
    name = "MOLL-E",
    itemID = 40768,
    spellName = "MOLL-E",
    actionType = "toy",
    category = "Utility",
    cooldown = "1 hour",
    destination = "Mailbox",
    keywords = {"moll-e", "molle", "mail", "mailbox"}
}, {
    name = "Katy's Stampwhistle",
    itemID = 156833,
    spellName = "Katy's Stampwhistle",
    actionType = "toy",
    category = "Utility",
    cooldown = "8 hours",
    destination = "Mailbox",
    keywords = {"mail", "mailbox"}
}, {
    name = "Radiant Lynx Whistle",
    itemID = 232417,
    spellName = "Radiant Lynx Whistle",
    actionType = "item",
    category = "Utility",
    cooldown = "20 min",
    destination = "Mailbox",
    keywords = {"mail", "mailbox"}
}, {
    name = "Ohuna Perch",
    itemID = 198715,
    spellName = "Ohuna Perch",
    actionType = "item",
    category = "Utility",
    cooldown = "20 min",
    destination = "Mailbox",
    keywords = {"mail", "mailbox"}
}, {
    name = "Flight Master's Whistle",
    itemID = 141605,
    spellName = "Flight Master's Whistle",
    actionType = "item",
    category = "Utility",
    cooldown = "15 min",
    destination = "Flight Master",
    keywords = {"flightmaster"}
}, {
    name = "Rechargeable Reaves Battery",
    itemID = 144341,
    spellName = "Rechargeable Reaves Battery",
    actionType = "item",
    category = "Utility",
    cooldown = "1 hour",
    destination = "Reaves",
    keywords = {"reaves", "repair"}
}, {
    name = "Reaves Battery",
    itemID = 132523,
    spellName = "Reaves Module: Repair Mode",
    actionType = "item",
    category = "Utility",
    cooldown = "1 hour",
    destination = "Reaves",
    keywords = {"reaves", "repair"}
}, {
    name = "Grand Expedition Yak",
    itemID = 84101,
    spellID = 122708,
    mountId = 460,
    spellName = "Grand Expedition Yak",
    actionType = "mount",
    category = "Utility",
    cooldown = "No CD",
    destination = "Repair & Transmog",
    keywords = {"yak", "expedition", "repair", "vendor", "transmog"}
}, {
    name = "Traveler's Tundra Mammoth",
    itemID = 44234,
    spellID = 61447,
    mountId = 284,
    spellName = "Traveler's Tundra Mammoth",
    actionType = "mount",
    category = "Utility",
    cooldown = "No CD",
    destination = "Repair & Vendor",
    keywords = {"mammoth", "tundra", "repair", "vendor"}
}, {
    name = "Mighty Caravan Brutosaur",
    itemID = 163042,
    spellID = 264058,
    mountId = 1039,
    spellName = "Mighty Caravan Brutosaur",
    actionType = "mount",
    category = "Utility",
    cooldown = "No CD",
    destination = "Auction House & Repair",
    keywords = {"brutosaur", "bruto", "vendor", "auction", "ah", "longboy"}
}, {
    name = "Trader's Gilded Brutosaur",
    itemID = 229418,
    spellID = 465235,
    mountId = 2265,
    spellName = "Trader's Gilded Brutosaur",
    actionType = "mount",
    category = "Utility",
    cooldown = "No CD",
    destination = "Auction House & Mailbox",
    keywords = {"brutosaur", "bruto", "auction", "ah", "gilded", "trader", "mailbox", "mail"}
}, {
    name = "Ethereal Transmogrifier",
    itemID = 206268,
    spellName = "Ethereal Transmogrifier",
    actionType = "toy",
    category = "Utility",
    cooldown = "No CD",
    destination = "Transmogrifier",
    keywords = {"transmog", "transmogrifier", "ethereal", "mog", "xmog"}
}, {
    name = "Blingtron 7000",
    itemID = 168667,
    spellName = "Blingtron 7000",
    actionType = "toy",
    category = "Utility",
    cooldown = "4 hours",
    destination = "Blingtron 7000",
    keywords = {"blingtron", "bling", "blingtron 7000", "7000"}
}, {
    name = "Blingtron 6000",
    itemID = 132892,
    spellName = "Blingtron 6000",
    actionType = "toy",
    category = "Utility",
    cooldown = "4 hours",
    destination = "Blingtron 6000",
    keywords = {"blingtron", "bling", "blingtron 6000", "6000"}
}, {
    name = "Blingtron 5000",
    itemID = 87214,
    spellName = "Blingtron 5000",
    actionType = "toy",
    category = "Utility",
    cooldown = "4 hours",
    destination = "Blingtron 5000",
    keywords = {"blingtron", "bling", "blingtron 5000", "5000"}
}, {
    name = "Blingtron 4000",
    itemID = 111821,
    spellName = "Blingtron 4000",
    actionType = "toy",
    category = "Utility",
    cooldown = "4 hours",
    destination = "Blingtron 4000",
    keywords = {"blingtron", "bling", "blingtron 4000", "4000"}
}, {
    name = "Thermal Anvil",
    itemID = 87216,
    spellName = "Thermal Anvil",
    actionType = "toy",
    category = "Utility",
    cooldown = "15 min",
    destination = "Anvil",
    keywords = {"anvil", "thermal", "blacksmith", "forge"}
}, {
    name = "Argent Squire",
    itemID = 67414,
    spellName = "Argent Squire",
    actionType = "toy",
    category = "Utility",
    cooldown = "8 hours",
    destination = "Bank & Vendor",
    keywords = {"argent", "squire", "bank", "vendor", "mailbox", "mail"}
}, {
    name = "Deployable Attire Rearranger",
    itemID = 153597,
    spellName = "Deployable Attire Rearranger",
    actionType = "toy",
    category = "Utility",
    cooldown = "10 min",
    destination = "Transmogrifier",
    keywords = {"transmog", "attire", "rearranger", "mog", "xmog"}
}, {
    name = "Mobile Banking",
    itemID = 183795,
    spellName = "Mobile Banking",
    actionType = "toy",
    category = "Utility",
    cooldown = "4 hours",
    destination = "Guild Bank",
    keywords = {"guild", "bank", "mobile", "banking"}
}, {
    name = "Interdimensional Companion Repository",
    itemID = 153510,
    spellName = "Interdimensional Companion Repository",
    actionType = "toy",
    category = "Utility",
    cooldown = "5 min",
    destination = "Stable Master",
    keywords = {"stable"}
}, {
    name = "Pierre",
    itemID = 94903,
    spellName = "Pierre",
    actionType = "toy",
    category = "Utility",
    cooldown = "10 min",
    destination = "Cooking Fire",
    keywords = {"pierre", "cooking"}
}, {
    name = "Lil' Ragnaros",
    itemID = 101771,
    spellName = "Lil' Ragnaros",
    actionType = "toy",
    category = "Utility",
    cooldown = "5 min",
    destination = "Cooking Fire",
    keywords = {"ragnaros", "lil ragnaros"}
}, {
    name = "Little Wickerman",
    itemID = 70722,
    spellName = "Little Wickerman",
    actionType = "toy",
    category = "Utility",
    cooldown = "10 min",
    destination = "Cooking Fire",
    keywords = {"wickerman", "wicker"}
}, {
    name = "Sturdy Love Fool",
    itemID = 144339,
    spellName = "Sturdy Love Fool",
    actionType = "toy",
    category = "Utility",
    cooldown = "No CD",
    destination = "Training Dummy",
    keywords = {"dummy", "training", "love fool", "sturdy"}
}, {
    name = "Turnip Punching Bag",
    itemID = 88375,
    spellName = "Turnip Punching Bag",
    actionType = "toy",
    category = "Utility",
    cooldown = "No CD",
    destination = "Training Dummy",
    keywords = {"dummy", "training", "turnip", "punching bag"}
}, {
    name = "Rubbery Fish Head",
    itemID = 199896,
    spellName = "Rubbery Fish Head",
    actionType = "toy",
    category = "Utility",
    cooldown = "No CD",
    destination = "Training Dummy",
    keywords = {"dummy", "training", "rubbery"}
}, {
    name = "Tuskarr Training Dummy",
    itemID = 199830,
    spellName = "Tuskarr Training Dummy",
    actionType = "toy",
    category = "Utility",
    cooldown = "No CD",
    destination = "Training Dummy",
    keywords = {"dummy", "training", "tuskarr"}
}, {
    name = "Black Dragon's Challenge Dummy",
    itemID = 201933,
    spellName = "Black Dragon's Challenge Dummy",
    actionType = "toy",
    category = "Utility",
    cooldown = "No CD",
    destination = "Training Dummy",
    keywords = {"dummy", "training", "black dragon", "challenge"}
}, {
    name = "Ancient Construct",
    itemID = 225556,
    spellName = "Ancient Construct",
    actionType = "toy",
    category = "Utility",
    cooldown = "No CD",
    destination = "Training Dummy",
    keywords = {"dummy", "training"}
}, {
    name = "Barrel of Fireworks",
    itemID = 219387,
    spellName = "Barrel of Fireworks",
    actionType = "toy",
    category = "Utility",
    cooldown = "No CD",
    destination = "Training Dummy",
    keywords = {"dummy", "training"}
}, {
    name = "Anatomical Dummy",
    itemID = 89614,
    spellName = "Anatomical Dummy",
    actionType = "toy",
    category = "Utility",
    cooldown = "No CD",
    destination = "Training Dummy",
    keywords = {"dummy", "training"}
}, {
    name = "Gnoll Targeting Barrel",
    itemID = 163201,
    spellName = "Gnoll Targeting Barrel",
    actionType = "toy",
    category = "Utility",
    cooldown = "No CD",
    destination = "Training Dummy",
    keywords = {"dummy", "training"}
},
-- {
--     name = "Drowned Hatchling",
--     petName = "Drowned Hatchling",
--     actionType = "pet",
--     category = "Utility",
--     cooldown = "No CD",
--     destination = "Oronu (Nazjatar)",
--     keywords = {"drowned hatchling", "oronu", "orunu"}
-- },  {
--     name = "Alvin the Anvil",
--     itemID = 191886,
--     spellName = "Alvin the Anvil",
--     actionType = "pet",
--     category = "Utility",
--     cooldown = "10 min",
--     destination = "Anvil",
--     keywords = {"alvin", "anvil"}
-- },
{
    name = "Bright Campfire",
    itemID = 33278,
    spellName = "Bright Campfire",
    actionType = "item",
    category = "Utility",
    cooldown = "No CD",
    destination = "Cooking Fire",
    keywords = {"campfire", "fire", "cooking", "camp"}
}, {
    name = "Cantrips",
    spellID = 255661,
    spellName = "Cantrips",
    actionType = "spell",
    category = "Utility",
    cooldown = "No CD",
    destination = "Mailbox",
    keywords = {"cantrips", "mail", "mailbox", "nightborne"}
}, {
    name = "Pack Hobgoblin",
    spellID = 69046,
    spellName = "Pack Hobgoblin",
    actionType = "spell",
    category = "Utility",
    cooldown = "10 min",
    destination = "Bank",
    keywords = {"hobgoblin", "pack", "bank", "goblin"}
}}

-- ============================================================================
-- COMBINE ALL DATA
-- ============================================================================

Nozmie_Data = {}

local function GetDataKey(item)
    if item.spellID then
        return "spell:" .. item.spellID
    end
    if item.itemID then
        return "item:" .. item.itemID
    end
    return "name:" .. tostring(item.name or item.spellName or "")
end

local seenData = {}
local function AddUnique(item)
    local key = GetDataKey(item)
    if not seenData[key] then
        table.insert(Nozmie_Data, item)
        seenData[key] = true
    end
end

-- Merge all tables into one flat array
for _, v in ipairs(MidnightSeason1) do
    AddUnique(v)
end
for _, v in ipairs(WarWithinSeason1) do
    AddUnique(v)
end
for _, v in ipairs(WarWithinSeason2) do
    AddUnique(v)
end
for _, v in ipairs(WarWithinSeason3) do
    AddUnique(v)
end
for _, v in ipairs(DragonflightDungeons) do
    AddUnique(v)
end
for _, v in ipairs(BfADungeons) do
    AddUnique(v)
end
for _, v in ipairs(ShadowlandsDungeons) do
    AddUnique(v)
end
for _, v in ipairs(LegionDungeons) do
    AddUnique(v)
end
for _, v in ipairs(CataclysmDungeons) do
    AddUnique(v)
end
for _, v in ipairs(RaidTeleports) do
    AddUnique(v)
end
for _, v in ipairs(DelveTeleports) do
    AddUnique(v)
end
for _, v in ipairs(Hearthstones) do
    AddUnique(v)
end
for _, v in ipairs(MageTeleports) do
    AddUnique(v)
end
for _, v in ipairs(ClassTeleports) do
    AddUnique(v)
end
for _, v in ipairs(ClassUtilities) do
    AddUnique(v)
end
for _, v in ipairs(TeleportToys) do
    AddUnique(v)
end
for _, v in ipairs(ServiceToys) do
    AddUnique(v)
end

if _G.Nozmie_Locale and _G.Nozmie_Locale.ApplyKeywordAliases then
    _G.Nozmie_Locale.ApplyKeywordAliases(Nozmie_Data)
end

-- Export category tables for potential future use
_G.Nozmie_Categories = {
    MidnightSeason1 = MidnightSeason1,
    WarWithinSeason1 = WarWithinSeason1,
    WarWithinSeason2 = WarWithinSeason2,
    WarWithinSeason3 = WarWithinSeason3,
    DragonflightDungeons = DragonflightDungeons,
    BfADungeons = BfADungeons,
    ShadowlandsDungeons = ShadowlandsDungeons,
    LegionDungeons = LegionDungeons,
    CataclysmDungeons = CataclysmDungeons,
    RaidTeleports = RaidTeleports,
    DelveTeleports = DelveTeleports,
    Hearthstones = Hearthstones,
    MageTeleports = MageTeleports,
    ClassTeleports = ClassTeleports,
    ClassUtilities = ClassUtilities,
    TeleportToys = TeleportToys,
    ServiceToys = ServiceToys
}

_G.Nozmie_DungeonSeasonPriorityNames = DungeonSeasonPriorityNames
_G.Nozmie_DungeonsByExpansion = DungeonsByExpansion
