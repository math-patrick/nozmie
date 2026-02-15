local ClassSpellsData = {{
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
}, {
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
}, -- Evoker Utilities
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
    name = "Astral Recall",
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

ClassSpells = {
    ClassSpellsData = ClassSpellsData,
    ClassTeleports = ClassTeleports
}
