# Nozmie: Utility Helper

**A smart and elegant World of Warcraft addon for instant teleportation and utility spell detection.**

## 🌟 Features

### Core Features
- **Smart Detection** - Automatically detects teleports, utilities, and buff requests in chat
- **Player Targeting** - When someone asks for a buff (fort, lev, slow fall, etc.), it automatically targets them!
- **Beautiful Banner** - Elegant WoW-styled notification with ornate gold borders and proper fonts
- **One-Click Action** - Click the banner to instantly cast spells, use items, or summon utilities
- **Real-Time Cooldowns** - Shows remaining cooldown time with visual feedback (desaturated icons and countdown)
- **Smart Prioritization** - Items on cooldown appear last; mounts hidden when indoors or unusable
- **Group Announcements** - Right-click to announce utility availability; left-click on cooldown items announces time remaining
- **Debounce Protection** - Prevents accidental double-click announcements (1 second cooldown)
- **Works Everywhere** - Detects in Say, Party, Raid, Guild, and Whisper channels
- **Smart Filtering** - Only shows spells you know, items you have, and toys you've collected
- **Saved Position** - Drag anywhere on screen and it remembers your preferred location
- **Flexible Keywords** - Matches destination names with aliases (e.g., "dal" finds all Dalaran teleports)

### UI Features
- **Compact Design** - Small 16px drag/close icons positioned unobtrusively
- **WoW-Style Textures** - Uses DialogBox-Gold borders for authentic collection frame appearance
- **Proper Fonts** - SystemFont_Shadow_Large for titles with subtle gold/gray color scheme
- **Perfect Alignment** - Carefully tuned text positioning with no weird padding
- **Dynamic Icons** - Icons change based on currently displayed spell/item
- **Carousel Navigation** - Arrow buttons to browse multiple options instead of cluttered dropdowns

## 🎮 Supported Content

### Mythic+ Dungeons
**The War Within (All Seasons)**
- Season 3: Floodgate, Eco-Dome Al'dani, Undermine, Manaforge Omega
- Season 2: Cinderbrew Meadery, Darkflame Cleft  
- Season 1: Ara-Kara, City of Threads, Stonevault, Dawnbreaker, Priory, Rookery, Siege of Boralus, Grim Batol

**Dragonflight Dungeons**
- Ruby Life Pools, Nokhud Offensive, Azure Vault, Algeth'ar Academy
- Brackenhide Hollow, Halls of Infusion, Neltharus, Uldaman
- Neltharion's Lair, Vortex Pinnacle, Dawn of the Infinite, Throne of the Tides
- Black Rook Hold, Darkheart Thicket

**Shadowlands Dungeons**
- Halls of Atonement, Plaguefall, Mists of Tirna Scithe, Necrotic Wake
- Sanguine Depths, Spires of Ascension, Theater of Pain, De Other Side
- Tazavesh, the Veiled Market

**BfA Dungeons**
- Operation: Mechagon, Siege of Boralus, Freehold, The Underrot
- Atal'Dazar, Waycrest Manor

### Hearthstones & Home Teleports
- Standard Hearthstone + Garrison/Dalaran variants
- Cosmetic hearthstones: Eternal Traveler's, Brewfest, Headless Horseman, Lunar Elder's
- Holiday variants: Peddlefeet's, Noble Gardener's, Fire Eater's, Greatfather Winter's
- Special hearthstones: Holographic, Dominated, Enlightened, Broker Matrix, Deepdweller's, Stone of the Hearth, Timewalker's

### Class Teleports & Utilities
**Mage**
- Teleports: All major cities (Stormwind, Orgrimmar, Dalaran, etc.)
- Utilities: Conjure Refreshment, Arcane Intellect, Slow Fall

**Priest**
- Power Word: Fortitude, Levitate

**Druid**
- Teleport: Moonglade, Emerald Dreamway
- Utility: Mark of the Wild

**Warlock**
- Ritual of Summoning, Create Soulwell

**Death Knight**
- Death Gate (Ebon Hold)

**Monk**
- Zen Pilgrimage (Peak of Serenity)

**Shaman**
- Astral Recall (10 min CD hearthstone)

**Demon Hunter**
- Fel Hammer

**Evoker**
- Blessing of the Bronze, Source of Magic

### Raids
- Nerub-ar Palace, Castle Nathria, Sanctum of Domination
- Sepulcher of the First Ones, Vault of the Incarnates
- Aberrus, Amirdrassil

### Delves
- Delve-O-bot 7001 (Random Delve)
- Delver's Mana-Bound Ethergate (Dornogal)

### Teleport Toys & Items
- Wormhole Generators: Northrend, Pandaria, Draenor, Argus, Kul Tiras, Zandalar, Shadowlands, Khaz Algar
- Ring of the Kirin Tor, Jaina's Locket, Violet Seal of the Grand Magus
- Time-Lost Artifact, Ultrasafe Transporter: Mechagon, Fractured Necrolyte Skull
- Cloak of Coordination, Unstable Portal Emitter
- Mole Machine (Dark Iron Dwarf racial)

### Utility Services
**Repair & Vendors**
- Jeeves, Auto-Hammer, Rechargable Reaves Battery
- Mounts: Grand Expedition Yak, Traveler's Tundra Mammoth, Mighty Caravan Brutosaur, Trader's Gilded Brutosaur

**Mailbox**
- MOLL-E, Katy's Stampwhistle, Radiant Lynx Whistle, Ohuna Perch
- Trader's Gilded Brutosaur (mount)
- Cantrips (Nightborne racial), Pack Hobgoblin (Goblin racial)

**Transmog**
- Ethereal Transmogrifier, Deployable Attire Rearranger
- Grand Expedition Yak (mount)

**Other Utilities**
- Blingtron 4000/5000/6000/7000 (daily gifts)
- Thermal Anvil (blacksmithing)
- Argent Squire (bank & vendor)
- Mobile Banking (guild bank)
- Interdimensional Companion Repository (stable master)
- Pierre, Lil' Ragnaros, Little Wickerman, Bright Campfire (cooking fires)

## 🚀 How to Use

### Basic Usage
1. **See a keyword in chat** - The banner appears automatically when matches are detected
2. **Multiple options?** Use the arrow buttons below the icon to browse (shows X/Y counter)
3. **Click to use** - Left-click teleports/casts instantly
4. **Right-click to announce** - Shares the utility/teleport with your group
5. **Drag to move** - Grab the small drag icon (bottom-right) to reposition
6. **Close** - Click the X button (top-right) or the banner auto-hides after use

### Player Targeting for Buffs 🎯
**NEW!** When someone asks for a buff in chat, Nozmie automatically targets them:
- Someone says "lev" → Banner shows "Cast Levitate on PlayerName"
- Someone says "slow fall" → Casts Slow Fall on them
- Works with: Fort, Mark of the Wild, Arcane Intellect, all buff/utility spells
- Just click the banner and it casts on the person who asked!

### Cooldown Announcements
When an item is on cooldown and you're in a group:
- **Left-click** announces remaining cooldown time to party/raid/instance chat
- **Right-click** announces the utility normally
- Banner shows remaining time in red text

### Smart Behavior
- **Mounts** automatically hidden when indoors or already mounted
- **Cooldown items** appear last in the list (active items prioritized)
- **1-second debounce** prevents accidental double announcements
- **Realm names stripped** from player targeting for cross-realm compatibility

### Example Keywords
- `dal`, `dalaran` → Dalaran Hearthstone, Mage Teleport, Jaina's Locket, Kirin Tor rings
- `ara kara`, `city of echoes` → Ara-Kara dungeon teleport  
- `hearth`, `home`, `inn` → All hearthstone variants
- `jeeves`, `repair` → Jeeves, Yak mount, Auto-Hammer, Reaves
- `mail`, `mailbox` → MOLL-E, Katy's Stampwhistle, Brutosaur mounts
- `transmog`, `mog` → Ethereal Transmogrifier, Deployable Attire Rearranger, Yak
- `fort`, `fortitude` → Power Word: Fortitude (targets requester!)
- `lev`, `levitate` → Levitate (targets requester!)
- `slow fall`, `sf` → Slow Fall (targets requester!)
- `cookies`, `food`, `table` → Conjure Refreshment
- `summon`, `lock summon` → Ritual of Summoning
- `soulwell`, `healthstone` → Create Soulwell

## 🎨 Commands

- `/noz` or `/nozmie` - Show help
- `/noz debug` or `/noz count` - Show statistics about loaded teleports/utilities
- `/noz test <keyword>` - Test detection with a keyword (e.g., `/noz test dalaran`)

## 🐛 Known Issues

None currently reported! All major features tested and working.

## 🔮 Future Ideas

- Optional spellbook/collection frame UI for browsing all available utilities
- Sound effects on banner appearance  
- Additional language support
- Midnight Season 1 dungeon support (when available)

## 📝 Version History

### v5.0.0 (2026-02-05) - Major Feature Update
**Player Targeting System**
- NEW: Automatic player targeting for buff spells (Levitate, Slow Fall, Fort, Mark, etc.)
- Banner shows "Cast [Spell] on [Player]" when someone requests a buff
- Supports cross-realm players (strips realm names automatically)

**Smart Filtering & Prioritization**
- Mount detection: Won't show mounts when indoors, already mounted, or unusable in zone
- Cooldown priority: Items on cooldown automatically sorted to end of list
- Spell usability checks for mounts using C_Spell.IsSpellUsable()

**UI Improvements**
- WoW-style DialogBox-Gold textures for authentic appearance
- Smaller, more subtle icons (16px) positioned at top-right (close) and bottom-right (drag)
- SystemFont_Shadow_Large with 13px sizing for better readability
- Subtle dark gray color scheme instead of bright gold
- Perfect text alignment with no padding issues
- Debounce protection (1s cooldown) prevents double-click announcements

**New Utilities Added**
- Levitate, Slow Fall (with player targeting)
- Comprehensive repair utilities (Jeeves, Reaves, Auto-Hammer, utility mounts)
- Mailbox utilities (MOLL-E, Katy's, Lynx Whistle, Ohuna Perch, racial abilities)
- Transmog utilities (Ethereal Transmogrifier, Deployable Attire Rearranger)
- Service utilities (Blingtrons, cooking fires, stable master, guild bank)
- Vendor mounts (Yak, Mammoth, both Brutosaurs)

**Code Refactoring**
- Removed unused files (old Nozmie.lua, UI.lua, test files)
- Cleaner module separation (BannerUI, BannerController, Detector, Helpers)
- Better code organization and documentation

### v4.0.0 (2026-02-04)
- Carousel interface for multiple options
- Real-time cooldown tracking
- Group announcements
- Dynamic icons
- Comprehensive teleport database (100+ options)
- Position saving

### v1.0.0 (2026-02-03)
- Initial release
- Smart dungeon detection
- Animated banner UI
- War Within Season 3 support

## 💬 Support & Feedback

Found a bug or have a suggestion? Please report issues or request features!

## �️ Technical Details

### Architecture
- **Modular Design**: Separated into Config, Data, Detector, Helpers, BannerUI, BannerController, and Init
- **Event-Driven**: Uses ChatFrame message filters for efficient chat monitoring
- **Secure Actions**: Uses SecureActionButton for spell/item usage (works in combat)
- **Smart Caching**: Cooldown checks and mount usability validated in real-time
- **Clean Code**: No global pollution, proper namespacing with _G exports

### File Structure
```
Data.lua           - Database of 250+ teleports, utilities, and keywords
Config.lua         - Configuration (colors, chat events, banner dimensions)
Helpers.lua        - Utility functions (cooldowns, player checks, formatting)
Detector.lua       - Keyword matching and teleport discovery
BannerUI.lua       - Banner frame creation and styling
BannerController.lua - Banner behavior, navigation, and click handlers
Init.lua           - Initialization and event registration
```

### Performance
- Minimal memory footprint (~2-3 MB)
- Efficient keyword matching with early exits
- No continuous timers (only active when banner shown)
- Cooldown updates every 0.5s only when needed

## �📜 License

This addon is free to use and modify. Created with ❤️ for the WoW community.

---

**Enjoy your instant teleports!** ✨
