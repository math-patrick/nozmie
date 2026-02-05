-- EasyPort Data Module
-- Contains all teleport spells, items, and toys organized by category
-- Each entry has keywords array for detection in chat
-- ============================================================================
-- MYTHIC+ DUNGEONS
-- ============================================================================
-- The War Within Season 1
local WarWithinSeason1 = {{
    name = "Ara-Kara, City of Echoes",
    spellID = 445424,
    spellName = "Path of the Ruined City",
    category = "M+ Dungeon",
    keywords = {"ara-kara", "ara kara", "arakara", "city of echoes"}
}, {
    name = "City of Threads",
    spellID = 445414,
    spellName = "Path of the Nerub-ar City",
    category = "M+ Dungeon",
    keywords = {"city of threads", "threads", "nerub-ar city", "nerubar"}
}, {
    name = "The Stonevault",
    spellID = 445418,
    spellName = "Path of the Earthen Vault",
    category = "M+ Dungeon",
    keywords = {"stonevault", "stone vault", "earthen vault"}
}, {
    name = "The Dawnbreaker",
    spellID = 445417,
    spellName = "Path of the Arathi Flagship",
    category = "M+ Dungeon",
    keywords = {"dawnbreaker", "dawn breaker", "arathi flagship"}
}, {
    name = "Priory of the Sacred Flame",
    spellID = 445269,
    spellName = "Path of the Light's Reverence",
    category = "M+ Dungeon",
    keywords = {"priory", "sacred flame", "lights reverence"}
}, {
    name = "The Rookery",
    spellID = 445443,
    spellName = "Path of the Darkflame",
    category = "M+ Dungeon",
    keywords = {"rookery", "darkflame"}
}, {
    name = "Siege of Boralus",
    spellID = 410074,
    spellName = "Path of Boralus Harbor",
    category = "M+ Dungeon",
    keywords = {"siege", "boralus", "siege of boralus", "sob"}
}, {
    name = "Grim Batol",
    spellID = 424142,
    spellName = "Path of the Twilight Citadel",
    category = "M+ Dungeon",
    keywords = {"grim batol", "grim", "batol", "gb"}
}}

-- The War Within Season 2
local WarWithinSeason2 = {{
    name = "Cinderbrew Meadery",
    spellID = 470709,
    spellName = "Path of the Meadery",
    category = "M+ Dungeon",
    keywords = {"cinderbrew", "meadery", "cinder brew"}
}, {
    name = "Darkflame Cleft",
    spellID = 445262,
    spellName = "Path of the Darkflame Cleft",
    category = "M+ Dungeon",
    keywords = {"darkflame", "cleft", "darkflame cleft"}
}}

-- The War Within Season 3 (Current)
local WarWithinSeason3 = {{
    name = "Floodgate",
    spellID = 445444,
    spellName = "Path of Circuit Breaker",
    category = "M+ Dungeon",
    keywords = {"floodgate", "flood gate", "circuit breaker"}
}, {
    name = "Eco-Dome Al'dani",
    spellID = 445416,
    spellName = "Path of the Eco-Dome",
    category = "M+ Dungeon",
    keywords = {"eco-dome", "eco dome", "ecodome", "aldani"}
}, {
    name = "Undermine",
    spellID = 470711,
    spellName = "Path of the Full House",
    category = "M+ Dungeon",
    keywords = {"undermine", "full house"}
}, {
    name = "Manaforge Omega",
    spellID = 470710,
    spellName = "Path of the All-Devouring",
    category = "M+ Dungeon",
    keywords = {"manaforge", "omega", "k'aresh", "karesh", "all-devouring"}
}}

-- Midnight Season 1 (Future)
local MidnightSeason1 = {{
    name = "Pit of Saron",
    spellID = 999001, -- Placeholder - update when available
    spellName = "Path of the Frozen Halls",
    category = "M+ Dungeon",
    keywords = {"pit of saron", "pit", "saron", "pos"}
}, {
    name = "Skyreach",
    spellID = 999002, -- Placeholder - update when available
    spellName = "Path of the Arakkoa",
    category = "M+ Dungeon",
    keywords = {"skyreach", "sky reach"}
}, {
    name = "Seat of the Triumvirate",
    spellID = 999003, -- Placeholder - update when available
    spellName = "Path of the Void",
    category = "M+ Dungeon",
    keywords = {"seat", "triumvirate", "seat of the triumvirate", "sott"}
}, {
    name = "Algeth'ar Academy",
    spellID = 393273,
    spellName = "Path of the Draconic Diploma",
    category = "M+ Dungeon",
    keywords = {"algethar", "algeth'ar", "academy", "aa"}
}, {
    name = "Magisters' Terrace",
    spellID = 999004, -- Placeholder - update when available
    spellName = "Path of the Sun's Reach",
    category = "M+ Dungeon",
    keywords = {"magisters", "magister's terrace", "terrace", "mt"}
}, {
    name = "Maisara Caverns",
    spellID = 999005, -- Placeholder - update when available
    spellName = "Path of the Maisara",
    category = "M+ Dungeon",
    keywords = {"maisara", "caverns", "maisara caverns"}
}, {
    name = "Nexus-Point Xenas",
    spellID = 999006, -- Placeholder - update when available
    spellName = "Path of the Nexus",
    category = "M+ Dungeon",
    keywords = {"nexus-point", "xenas", "nexus point xenas"}
}, {
    name = "Windrunner Spire",
    spellID = 999007, -- Placeholder - update when available
    spellName = "Path of the Windrunner",
    category = "M+ Dungeon",
    keywords = {"windrunner", "spire", "windrunner spire"}
}}

-- Battle for Azeroth Dungeons
local BfADungeons = {{
    name = "Operation: Mechagon",
    spellID = 373190,
    spellName = "Path of the Mechagone",
    category = "M+ Dungeon",
    keywords = {"mechagon", "operation mechagon"}
}, {
    name = "Siege of Boralus",
    spellID = 410074,
    spellName = "Path of Boralus Harbor",
    category = "M+ Dungeon",
    keywords = {"siege", "boralus", "siege of boralus", "sob"}
}, {
    name = "Freehold",
    spellID = 410071,
    spellName = "Path of the Freebooter",
    category = "M+ Dungeon",
    keywords = {"freehold", "free hold", "freebooter"}
}, {
    name = "The Underrot",
    spellID = 410074,
    spellName = "Path of the Underrot",
    category = "M+ Dungeon",
    keywords = {"underrot", "under rot", "ur"}
}, {
    name = "Atal'Dazar",
    spellID = 410080,
    spellName = "Path of the Golden Serpent",
    category = "M+ Dungeon",
    keywords = {"atal'dazar", "ataldazar", "atal", "ad"}
}, {
    name = "Waycrest Manor",
    spellID = 424187,
    spellName = "Path of Drustvar",
    category = "M+ Dungeon",
    keywords = {"waycrest", "manor", "waycrest manor", "wm"}
}}

-- Dragonflight Dungeons
local DragonflightDungeons = {{
    name = "Ruby Life Pools",
    spellID = 393256,
    spellName = "Path of the Obsidian Hoard",
    category = "M+ Dungeon",
    keywords = {"ruby", "ruby life pools", "rlp", "life pools"}
}, {
    name = "The Nokhud Offensive",
    spellID = 393262,
    spellName = "Path of the Windswept Plains",
    category = "M+ Dungeon",
    keywords = {"nokhud", "nokhud offensive", "no"}
}, {
    name = "The Azure Vault",
    spellID = 393279,
    spellName = "Path of the Arcane Secrets",
    category = "M+ Dungeon",
    keywords = {"azure", "azure vault", "av"}
}, {
    name = "Algeth'ar Academy",
    spellID = 393273,
    spellName = "Path of Mastery",
    category = "M+ Dungeon",
    keywords = {"algethar", "algeth'ar", "academy", "aa"}
}, {
    name = "Brackenhide Hollow",
    spellID = 393267,
    spellName = "Path of the Rotting Woods",
    category = "M+ Dungeon",
    keywords = {"brackenhide", "bracken", "hollow", "bhh"}
}, {
    name = "Halls of Infusion",
    spellID = 393256,
    spellName = "Path of the Primal Prison",
    category = "M+ Dungeon",
    keywords = {"halls", "infusion", "halls of infusion", "hoi"}
}, {
    name = "Neltharus",
    spellID = 393222,
    spellName = "Path of the Obsidian Citadel",
    category = "M+ Dungeon",
    keywords = {"neltharus", "nelt"}
}, {
    name = "Uldaman: Legacy of Tyr",
    spellID = 393283,
    spellName = "Path of the Titan Halls",
    category = "M+ Dungeon",
    keywords = {"uldaman", "legacy of tyr", "uld"}
}, {
    name = "Neltharion's Lair",
    spellID = 410078,
    spellName = "Path of Huln's Mountain",
    category = "M+ Dungeon",
    keywords = {"neltharion", "neltharion's lair", "nl", "lair"}
}, {
    name = "Vortex Pinnacle",
    spellID = 393222,
    spellName = "Path of the Djinn",
    category = "M+ Dungeon",
    keywords = {"vortex", "pinnacle", "vortex pinnacle", "vp"}
}, {
    name = "Dawn of the Infinite",
    spellID = 424197,
    spellName = "Path of the Infinite",
    category = "M+ Dungeon",
    keywords = {"dawn", "infinite", "dawn of the infinite", "doti"}
}, {
    name = "Throne of the Tides",
    spellID = 424163,
    spellName = "Path of the Abyssal Maw",
    category = "M+ Dungeon",
    keywords = {"throne", "tides", "throne of the tides", "tot"}
}, {
    name = "Black Rook Hold",
    spellID = 424142,
    spellName = "Path of the Black Rook",
    category = "M+ Dungeon",
    keywords = {"black rook", "brh", "rook hold"}
}, {
    name = "Darkheart Thicket",
    spellID = 424153,
    spellName = "Path of Nightmare",
    category = "M+ Dungeon",
    keywords = {"darkheart", "thicket", "darkheart thicket", "dht"}
}}

-- Shadowlands Dungeons
local ShadowlandsDungeons = {{
    name = "Halls of Atonement",
    spellID = 354464,
    spellName = "Path of the Sinful Soul",
    category = "M+ Dungeon",
    keywords = {"halls", "halls of atonement", "hoa", "atonement"}
}, {
    name = "Plaguefall",
    spellID = 354462,
    spellName = "Path of the Plagued",
    category = "M+ Dungeon",
    keywords = {"plaguefall", "plague fall", "pf"}
}, {
    name = "Mists of Tirna Scithe",
    spellID = 354463,
    spellName = "Path of the Misty Forest",
    category = "M+ Dungeon",
    keywords = {"mists", "tirna scithe", "tirna", "mots"}
}, {
    name = "The Necrotic Wake",
    spellID = 354465,
    spellName = "Path of the Courageous",
    category = "M+ Dungeon",
    keywords = {"necrotic", "necrotic wake", "nw", "wake"}
}, {
    name = "Sanguine Depths",
    spellID = 354469,
    spellName = "Path of the Stone Warden",
    category = "M+ Dungeon",
    keywords = {"sanguine", "sanguine depths", "sd", "depths"}
}, {
    name = "Spires of Ascension",
    spellID = 354468,
    spellName = "Path of the Ascended",
    category = "M+ Dungeon",
    keywords = {"spires", "spires of ascension", "soa", "ascension"}
}, {
    name = "Theater of Pain",
    spellID = 354467,
    spellName = "Path of the Undefeated",
    category = "M+ Dungeon",
    keywords = {"theater", "theater of pain", "top", "pain"}
}, {
    name = "De Other Side",
    spellID = 354468,
    spellName = "Path of the Scheming Loa",
    category = "M+ Dungeon",
    keywords = {"de other side", "dos", "other side"}
}, {
    name = "Tazavesh, the Veiled Market",
    spellID = 367416,
    spellName = "Path of the Streetwise Merchant",
    category = "M+ Dungeon",
    keywords = {"tazavesh", "taza", "veiled market"}
}}

-- ============================================================================
-- HEARTHSTONES & HOME TELEPORTS
-- ============================================================================

local Hearthstones = {{
    name = "Hearthstone",
    itemID = 6948,
    spellID = 8690,
    spellName = "Hearthstone",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn"}
}, {
    name = "Garrison Hearthstone",
    itemID = 110560,
    spellID = 171253,
    spellName = "Garrison Hearthstone",
    category = "Home",
    cooldown = "20 min",
    keywords = {"garrison", "garrison hearth"}
}, {
    name = "Dalaran Hearthstone",
    itemID = 140192,
    spellID = 193759,
    spellName = "Dalaran Hearthstone",
    category = "Home",
    cooldown = "20 min",
    keywords = {"dalaran", "dal", "dalaran hearth"}
}, -- Hearthstone Toys (cosmetic variants)
{
    name = "Eternal Traveler's Hearthstone",
    itemID = 172179,
    spellID = 308742,
    spellName = "Eternal Traveler's Hearthstone",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "eternal"}
}, {
    name = "Brewfest Reveler's Hearthstone",
    itemID = 166747,
    spellID = 286331,
    spellName = "Brewfest Reveler's Hearthstone",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "brewfest"}
}, {
    name = "Headless Horseman's Hearthstone",
    itemID = 163045,
    spellID = 278559,
    spellName = "Headless Horseman's Hearthstone",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "horseman"}
}, {
    name = "Lunar Elder's Hearthstone",
    itemID = 165669,
    spellID = 278244,
    spellName = "Lunar Elder's Hearthstone",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "lunar"}
}, {
    name = "Peddlefeet's Lovely Hearthstone",
    itemID = 165802,
    spellID = 278880,
    spellName = "Peddlefeet's Lovely Hearthstone",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "peddlefeet"}
}, {
    name = "Noble Gardener's Hearthstone",
    itemID = 165802,
    spellID = 278559,
    spellName = "Noble Gardener's Hearthstone",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "noble"}
}, {
    name = "Fire Eater's Hearthstone",
    itemID = 166746,
    spellID = 286353,
    spellName = "Fire Eater's Hearthstone",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "fire eater"}
}, {
    name = "Greatfather Winter's Hearthstone",
    itemID = 162973,
    spellID = 278853,
    spellName = "Greatfather Winter's Hearthstone",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "winter"}
}, {
    name = "Holographic Digitalization Hearthstone",
    itemID = 168907,
    spellID = 298068,
    spellName = "Holographic Digitalization Hearthstone",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "holo"}
}, {
    name = "Dominated Hearthstone",
    itemID = 188952,
    spellID = 356389,
    spellName = "Dominated Hearthstone",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "dominated"}
}, {
    name = "Enlightened Hearthstone",
    itemID = 190237,
    spellID = 363799,
    spellName = "Enlightened Hearthstone",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "enlightened"}
}, {
    name = "Broker Translocation Matrix",
    itemID = 190196,
    spellID = 367013,
    spellName = "Broker Translocation Matrix",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "broker"}
}, {
    name = "Deepdweller's Earthen Hearthstone",
    itemID = 209035,
    spellID = 422284,
    spellName = "Deepdweller's Earthen Hearthstone",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "earthen"}
}, {
    name = "Stone of the Hearth",
    itemID = 210455,
    spellID = 424163,
    spellName = "Stone of the Hearth",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "stone"}
}, {
    name = "Timewalker's Hearthstone",
    itemID = 212337,
    spellID = 427335,
    spellName = "Timewalker's Hearthstone",
    category = "Home",
    cooldown = "30 min",
    keywords = {"hearthstone", "hearth", "home", "inn", "timewalker"}
}}

-- ============================================================================
-- MAGE TELEPORTS
-- ============================================================================

local MageTeleports = { -- Alliance Cities
{
    name = "Stormwind",
    spellID = 3561,
    spellName = "Teleport: Stormwind",
    category = "Mage",
    faction = "Alliance",
    keywords = {"stormwind", "sw", "storm wind"}
}, {
    name = "Ironforge",
    spellID = 3562,
    spellName = "Teleport: Ironforge",
    category = "Mage",
    faction = "Alliance",
    keywords = {"ironforge", "iron forge"}
}, {
    name = "Darnassus",
    spellID = 3565,
    spellName = "Teleport: Darnassus",
    category = "Mage",
    faction = "Alliance",
    keywords = {"darnassus", "darn"}
}, {
    name = "Exodar",
    spellID = 32271,
    spellName = "Teleport: Exodar",
    category = "Mage",
    faction = "Alliance",
    keywords = {"exodar"}
}, {
    name = "Boralus",
    spellID = 281403,
    spellName = "Teleport: Boralus",
    category = "Mage",
    faction = "Alliance",
    keywords = {"boralus"}
}, -- Horde Cities
{
    name = "Orgrimmar",
    spellID = 3567,
    spellName = "Teleport: Orgrimmar",
    category = "Mage",
    faction = "Horde",
    keywords = {"orgrimmar", "org"}
}, {
    name = "Undercity",
    spellID = 3563,
    spellName = "Teleport: Undercity",
    category = "Mage",
    faction = "Horde",
    keywords = {"undercity", "uc", "under city"}
}, {
    name = "Thunder Bluff",
    spellID = 3566,
    spellName = "Teleport: Thunder Bluff",
    category = "Mage",
    faction = "Horde",
    keywords = {"thunder bluff", "thunderbluff", "tb"}
}, {
    name = "Silvermoon",
    spellID = 32272,
    spellName = "Teleport: Silvermoon",
    category = "Mage",
    faction = "Horde",
    keywords = {"silvermoon", "silver moon", "sm"}
}, {
    name = "Dazar'alor",
    spellID = 281404,
    spellName = "Teleport: Dazar'alor",
    category = "Mage",
    faction = "Horde",
    keywords = {"dazaralor", "dazar", "dazar'alor"}
}, -- Neutral Cities
{
    name = "Shattrath",
    spellID = 33690,
    spellName = "Teleport: Shattrath",
    category = "Mage",
    faction = "Neutral",
    keywords = {"shattrath", "shatt"}
}, {
    name = "Dalaran (Northrend)",
    spellID = 53140,
    spellName = "Teleport: Dalaran - Northrend",
    category = "Mage",
    faction = "Neutral",
    keywords = {"dalaran", "dal", "northrend dal"}
}, {
    name = "Dalaran (Broken Isles)",
    spellID = 224869,
    spellName = "Teleport: Dalaran - Broken Isles",
    category = "Mage",
    faction = "Neutral",
    keywords = {"dalaran", "dal", "legion dal", "broken isles"}
}, {
    name = "Vale of Eternal Blossoms",
    spellID = 132621,
    spellName = "Teleport: Vale of Eternal Blossoms",
    category = "Mage",
    faction = "Neutral",
    keywords = {"vale", "vale of eternal blossoms"}
}, {
    name = "Oribos",
    spellID = 344597,
    spellName = "Teleport: Oribos",
    category = "Mage",
    faction = "Neutral",
    keywords = {"oribos"}
}, {
    name = "Valdrakken",
    spellID = 395277,
    spellName = "Teleport: Valdrakken",
    category = "Mage",
    faction = "Neutral",
    keywords = {"valdrakken", "vald"}
}}

-- ============================================================================
-- CLASS TELEPORTS
-- ============================================================================

local ClassTeleports = { -- Druid
{
    name = "Moonglade",
    spellID = 18960,
    spellName = "Teleport: Moonglade",
    category = "Druid",
    keywords = {"moonglade"}
}, {
    name = "Emerald Dreamway",
    spellID = 193753,
    spellName = "Dreamwalk",
    category = "Druid",
    keywords = {"dreamway", "dream way", "emerald dreamway"}
}, -- Death Knight
{
    name = "Ebon Hold",
    spellID = 50977,
    spellName = "Death Gate",
    category = "Death Knight",
    keywords = {"ebon hold", "death gate", "acherus"}
}, -- Monk
{
    name = "Peak of Serenity",
    spellID = 126892,
    spellName = "Zen Pilgrimage",
    category = "Monk",
    keywords = {"peak", "peak of serenity", "monk class hall"}
}, -- Shaman
{
    name = "Home Location",
    spellID = 556,
    spellName = "Astral Recall",
    category = "Shaman",
    cooldown = "10 min",
    keywords = {"astral recall", "shaman hearth"}
}, -- Demon Hunter
{
    name = "Fel Hammer",
    spellID = 189838,
    spellName = "Fel Hammer",
    category = "Demon Hunter",
    keywords = {"fel hammer", "dh class hall"}
}}

-- ============================================================================
-- RAID TELEPORTS
-- ============================================================================

local RaidTeleports = {{
    name = "Nerub-ar Palace",
    spellID = 445440,
    spellName = "Path of the Forgotten Kingdom",
    category = "Raid",
    keywords = {"nerub-ar", "nerubar", "palace", "raid"}
}, {
    name = "Castle Nathria",
    spellID = 354464,
    spellName = "Path of the Sinful Soul",
    category = "Raid",
    keywords = {"nathria", "castle nathria", "raid"}
}, {
    name = "Sanctum of Domination",
    spellID = 354467,
    spellName = "Path of the First Ones",
    category = "Raid",
    keywords = {"sanctum", "domination", "raid"}
}, {
    name = "Sepulcher of the First Ones",
    spellID = 373262,
    spellName = "Path of the Progenitor",
    category = "Raid",
    keywords = {"sepulcher", "first ones", "raid"}
}, {
    name = "Vault of the Incarnates",
    spellID = 393276,
    spellName = "Path of the Primal Prison",
    category = "Raid",
    keywords = {"vault", "incarnates", "raid", "voti"}
}, {
    name = "Aberrus, the Shadowed Crucible",
    spellID = 410078,
    spellName = "Path of the Bitter Legacy",
    category = "Raid",
    keywords = {"aberrus", "shadowed crucible", "raid"}
}, {
    name = "Amirdrassil, the Dream's Hope",
    spellID = 424142,
    spellName = "Path of the Dreamwalker",
    category = "Raid",
    keywords = {"amirdrassil", "dream's hope", "dreams hope", "raid"}
}}

-- ============================================================================
-- DELVE TELEPORTS
-- ============================================================================

local DelveTeleports = {{
    name = "Delve-O-bot 7001",
    itemID = 232450,
    spellName = "Delve-O-bot 7001",
    category = "Delve",
    cooldown = "15 min",
    destination = "Random Delve",
    keywords = {"delve", "delveobot", "delve-obot", "7001", "random", "bountiful"}
}, {
    name = "Delver's Mana-Bound Ethergate",
    itemID = 232407,
    spellName = "Delver's Mana-Bound Ethergate",
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
    category = "Mage Utility",
    keywords = {"cookies", "food", "mana buns", "refreshment", "table", "mage table"}
}, {
    name = "Arcane Intellect",
    spellID = 1459,
    spellName = "Arcane Intellect",
    category = "Mage Utility",
    keywords = {"intellect", "arcane intellect", "buff"}
}, -- Warlock Utilities
{
    name = "Ritual of Summoning",
    spellID = 698,
    spellName = "Ritual of Summoning",
    category = "Warlock Utility",
    keywords = {"summon", "summons", "lock summon", "warlock summon", "port"}
}, {
    name = "Create Soulwell",
    spellID = 29893,
    spellName = "Create Soulwell",
    category = "Warlock Utility",
    keywords = {"soulwell", "soul well", "lock well", "healthstones", "healthstone", "health stone", "hs", "lock rock",
                "cookie", "cookies"}
}, -- Priest Utilities
{
    name = "Power Word: Fortitude",
    spellID = 21562,
    spellName = "Power Word: Fortitude",
    category = "Priest Utility",
    keywords = {"fort", "fortitude", "stamina", "buff", "pw:f"}
}, -- Druid Utilities
{
    name = "Mark of the Wild",
    spellID = 1126,
    spellName = "Mark of the Wild",
    category = "Druid Utility",
    keywords = {"motw", "mark", "mark of the wild", "buff"}
}, -- Evoker Utilities
{
    name = "Blessing of the Bronze",
    spellID = 364342,
    spellName = "Blessing of the Bronze",
    category = "Evoker Utility",
    keywords = {"bronze", "blessing of the bronze", "botb", "buff", "cdr", "cooldown reduction"}
}, {
    name = "Source of Magic",
    spellID = 369459,
    spellName = "Source of Magic",
    category = "Evoker Utility",
    keywords = {"source", "source of magic", "evoker mana", "buff"}
}}

-- ============================================================================
-- TELEPORT TOYS
-- ============================================================================

local TeleportToys = {{
    name = "Ring of the Kirin Tor",
    itemID = 40586,
    spellName = "Ring of the Kirin Tor",
    category = "Toy",
    cooldown = "30 min",
    destination = "Dalaran (Northrend)",
    keywords = {"dalaran", "dal", "northrend"}
}, {
    name = "Jaina's Locket",
    itemID = 52251,
    spellName = "Jaina's Locket",
    category = "Toy",
    cooldown = "1 hour",
    destination = "Dalaran (Northrend)",
    keywords = {"dalaran", "dal", "northrend", "jaina"}
}, {
    name = "Cloak of Coordination",
    itemID = 65274,
    spellName = "Cloak of Coordination",
    category = "Toy",
    cooldown = "2 hours",
    destination = "Capital City",
    keywords = {"capital", "city"}
}, {
    name = "The Innkeeper's Daughter",
    itemID = 64488,
    spellName = "The Innkeeper's Daughter",
    category = "Toy",
    cooldown = "30 min",
    destination = "Home",
    keywords = {"home", "inn"}
}, {
    name = "Wormhole Generator: Northrend",
    itemID = 48933,
    spellName = "Wormhole Generator: Northrend",
    category = "Toy",
    cooldown = "4 hours",
    destination = "Northrend (Random)",
    keywords = {"northrend", "wormhole"}
}, {
    name = "Wormhole Generator: Pandaria",
    itemID = 87215,
    spellName = "Wormhole Generator: Pandaria",
    category = "Toy",
    cooldown = "15 min",
    destination = "Pandaria (Random)",
    keywords = {"pandaria", "wormhole", "mop"}
}, {
    name = "Wormhole Centrifuge",
    itemID = 112059,
    spellName = "Wormhole Centrifuge",
    category = "Toy",
    cooldown = "4 hours",
    destination = "Draenor (Random)",
    keywords = {"draenor", "wormhole", "wod"}
}, {
    name = "Wormhole Generator: Argus",
    itemID = 151652,
    spellName = "Wormhole Generator: Argus",
    category = "Toy",
    cooldown = "15 min",
    destination = "Argus (Random)",
    keywords = {"argus", "wormhole"}
}, {
    name = "Wormhole Generator: Kul Tiras",
    itemID = 168807,
    spellName = "Wormhole Generator: Kul Tiras",
    category = "Toy",
    cooldown = "15 min",
    destination = "Kul Tiras (Random)",
    keywords = {"kul tiras", "kultiras", "wormhole"}
}, {
    name = "Wormhole Generator: Zandalar",
    itemID = 168808,
    spellName = "Wormhole Generator: Zandalar",
    category = "Toy",
    cooldown = "15 min",
    destination = "Zandalar (Random)",
    keywords = {"zandalar", "wormhole"}
}, {
    name = "Wormhole Generator: Shadowlands",
    itemID = 172924,
    spellName = "Wormhole Generator: Shadowlands",
    category = "Toy",
    cooldown = "15 min",
    destination = "Shadowlands (Random)",
    keywords = {"shadowlands", "wormhole", "sl"}
}, {
    name = "Wormhole Generator: Khaz Algar",
    itemID = 221966,
    spellName = "Wormhole Generator: Khaz Algar",
    category = "Toy",
    cooldown = "15 min",
    destination = "Khaz Algar (Random)",
    keywords = {"khaz algar", "khazalgar", "wormhole", "tww"}
}, {
    name = "Time-Lost Artifact",
    itemID = 103678,
    spellName = "Time-Lost Artifact",
    category = "Toy",
    cooldown = "1 min",
    destination = "Timeless Isle",
    keywords = {"timeless isle", "timeless"}
}, {
    name = "Ultrasafe Transporter: Mechagon",
    itemID = 168807,
    spellName = "Ultrasafe Transporter: Mechagon",
    category = "Toy",
    cooldown = "1 hour",
    destination = "Mechagon",
    keywords = {"mechagon", "gnome", "transporter"}
}, {
    name = "Mole Machine",
    itemID = 115543,
    spellName = "Mole Machine",
    category = "Toy",
    cooldown = "30 min",
    destination = "Various",
    keywords = {"mole machine", "dark iron"}
}, {
    name = "Violet Seal of the Grand Magus",
    itemID = 142469,
    spellName = "Violet Seal of the Grand Magus",
    category = "Toy",
    cooldown = "4 hours",
    destination = "Karazhan",
    keywords = {"karazhan", "kara", "violet seal"}
}, {
    name = "Dalaran Hearthstone",
    itemID = 140192,
    spellName = "Dalaran Hearthstone",
    category = "Toy",
    cooldown = "20 min",
    destination = "Dalaran (Broken Isles)",
    keywords = {"dalaran", "dal", "legion"}
}, {
    name = "Fractured Necrolyte Skull",
    itemID = 32757,
    spellName = "Fractured Necrolyte Skull",
    category = "Toy",
    cooldown = "2 hours",
    destination = "Black Temple",
    keywords = {"black temple", "bt", "necrolyte", "skull"}
}, {
    name = "Unstable Portal Emitter",
    itemID = 227669,
    spellName = "Unstable Portal Emitter",
    category = "Toy",
    cooldown = "30 min",
    destination = "Random",
    keywords = {"portal", "emitter", "unstable", "random"}
}, {
    name = "Rechargable Reaves Battery",
    itemID = 132523,
    spellName = "Rechargable Reaves Battery",
    category = "Toy",
    cooldown = "1 hour",
    destination = "Broken Isles",
    keywords = {"reaves", "battery", "broken isles", "legion", "repair"}
}}

-- ============================================================================
-- REPAIR & MAILBOX UTILITIES
-- ============================================================================

local ServiceToys = {{
    name = "Jeeves",
    itemID = 49040,
    spellName = "Jeeves",
    category = "Utility",
    cooldown = "1 hour",
    destination = "Repair & Bank",
    keywords = {"jeeves", "repair", "vendor", "bank"}
}, {
    name = "Auto-Hammer",
    itemID = 23767,
    spellName = "Auto-Hammer",
    category = "Utility",
    cooldown = "1 hour",
    destination = "Repair",
    keywords = {"auto-hammer", "auto hammer", "repair"}
}, {
    name = "MOLL-E",
    itemID = 40768,
    spellName = "MOLL-E",
    category = "Utility",
    cooldown = "1 hour",
    destination = "Mailbox",
    keywords = {"moll-e", "molle", "mail", "mailbox"}
}, {
    name = "Katy's Stampwhistle",
    itemID = 156833,
    spellName = "Katy's Stampwhistle",
    category = "Utility",
    cooldown = "8 hours",
    destination = "Mailbox",
    keywords = {"mail", "mailbox"}
}, {
    name = "Radiant Lynx Whistle",
    itemID = 232417,
    spellName = "Radiant Lynx Whistle",
    category = "Utility",
    cooldown = "20 min",
    destination = "Mailbox",
    keywords = {"mail", "mailbox"}
}, {
    name = "Ohuna Perch",
    itemID = 198715,
    spellName = "Ohuna Perch",
    category = "Utility",
    cooldown = "20 min",
    destination = "Mailbox",
    keywords = {"mail", "mailbox"}
}, {
    name = "Rechargable Reaves Battery",
    itemID = 132523,
    spellName = "Rechargable Reaves Battery",
    category = "Utility",
    cooldown = "1 hour",
    destination = "Repair & Mailbox",
    keywords = {"reaves", "battery", "repair", "mail", "mailbox", "vendor"}
}, {
    name = "Reaves Battery",
    itemID = 132523,
    spellName = "Reaves Module: Repair Mode",
    category = "Utility",
    cooldown = "1 hour",
    destination = "Repair & More",
    keywords = {"reaves", "repair", "vendor"}
}, {
    name = "Traveler's Tundra Mammoth",
    itemID = 61425,
    spellName = "Traveler's Tundra Mammoth",
    category = "Utility",
    cooldown = "No CD",
    destination = "Repair & Vendor",
    keywords = {"mammoth", "tundra", "repair", "vendor"}
}, {
    name = "Grand Expedition Yak",
    itemID = 120968,
    spellName = "Grand Expedition Yak",
    category = "Utility",
    cooldown = "No CD",
    destination = "Repair & Transmog",
    keywords = {"yak", "expedition", "repair", "vendor", "transmog"}
}, {
    name = "Mighty Caravan Brutosaur",
    itemID = 163042,
    spellName = "Mighty Caravan Brutosaur",
    category = "Utility",
    cooldown = "No CD",
    destination = "Repair & AH",
    keywords = {"brutosaur", "bruto", "repair", "vendor", "auction", "ah", "longboy"}
}, {
    name = "Trader's Gilded Brutosaur",
    itemID = 229376,
    spellName = "Trader's Gilded Brutosaur",
    category = "Utility",
    cooldown = "No CD",
    destination = "Auction House",
    keywords = {"brutosaur", "bruto",  "auction", "ah", "longboy", "mailbox", "mail"}
}, {
    name = "Ethereal Transmogrifier",
    itemID = 119134,
    spellName = "Ethereal Transmogrifier",
    category = "Utility",
    cooldown = "No CD",
    destination = "Transmog",
    keywords = {"transmog", "transmogrifier", "ethereal", "mog", "xmog"}
}, {
    name = "Blingtron 7000",
    itemID = 168667,
    spellName = "Blingtron 7000",
    category = "Utility",
    cooldown = "4 hours",
    destination = "Daily Gift",
    keywords = {"blingtron", "bling", "blingtron 7000", "7000", "gift"}
}, {
    name = "Blingtron 6000",
    itemID = 132892,
    spellName = "Blingtron 6000",
    category = "Utility",
    cooldown = "4 hours",
    destination = "Daily Gift",
    keywords = {"blingtron", "bling", "blingtron 6000", "6000", "gift"}
}, {
    name = "Blingtron 5000",
    itemID = 87214,
    spellName = "Blingtron 5000",
    category = "Utility",
    cooldown = "4 hours",
    destination = "Daily Gift",
    keywords = {"blingtron", "bling", "blingtron 5000", "5000", "gift"}
}, {
    name = "Blingtron 4000",
    itemID = 111821,
    spellName = "Blingtron 4000",
    category = "Utility",
    cooldown = "4 hours",
    destination = "Daily Gift",
    keywords = {"blingtron", "bling", "blingtron 4000", "4000", "gift"}
}, {
    name = "Thermal Anvil",
    itemID = 87216,
    spellName = "Thermal Anvil",
    category = "Utility",
    cooldown = "15 min",
    destination = "Anvil",
    keywords = {"anvil", "thermal", "blacksmith", "forge"}
}}

-- ============================================================================
-- COMBINE ALL DATA
-- ============================================================================

EasyPort_DungeonData = {}

-- Merge all tables into one flat array
for _, v in ipairs(MidnightSeason1) do
    table.insert(EasyPort_DungeonData, v)
end
for _, v in ipairs(WarWithinSeason1) do
    table.insert(EasyPort_DungeonData, v)
end
for _, v in ipairs(WarWithinSeason2) do
    table.insert(EasyPort_DungeonData, v)
end
for _, v in ipairs(WarWithinSeason3) do
    table.insert(EasyPort_DungeonData, v)
end
for _, v in ipairs(DragonflightDungeons) do
    table.insert(EasyPort_DungeonData, v)
end
for _, v in ipairs(BfADungeons) do
    table.insert(EasyPort_DungeonData, v)
end
for _, v in ipairs(ShadowlandsDungeons) do
    table.insert(EasyPort_DungeonData, v)
end
for _, v in ipairs(RaidTeleports) do
    table.insert(EasyPort_DungeonData, v)
end
for _, v in ipairs(DelveTeleports) do
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
for _, v in ipairs(ClassUtilities) do
    table.insert(EasyPort_DungeonData, v)
end
for _, v in ipairs(TeleportToys) do
    table.insert(EasyPort_DungeonData, v)
end
for _, v in ipairs(ServiceToys) do
    table.insert(EasyPort_DungeonData, v)
end

-- Export category tables for potential future use
_G.EasyPort_Categories = {
    MidnightSeason1 = MidnightSeason1,
    WarWithinSeason1 = WarWithinSeason1,
    WarWithinSeason2 = WarWithinSeason2,
    WarWithinSeason3 = WarWithinSeason3,
    DragonflightDungeons = DragonflightDungeons,
    BfADungeons = BfADungeons,
    ShadowlandsDungeons = ShadowlandsDungeons,
    RaidTeleports = RaidTeleports,
    DelveTeleports = DelveTeleports,
    Hearthstones = Hearthstones,
    MageTeleports = MageTeleports,
    ClassTeleports = ClassTeleports,
    ClassUtilities = ClassUtilities,
    TeleportToys = TeleportToys,
    ServiceToys = ServiceToys
}
