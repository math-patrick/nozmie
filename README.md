# Nozmie

Lightweight WoW addon that detects teleport and utility requests from chat and shows a one-click banner.

## Features
- Smart chat detection in Say, Party, Raid, Guild, and Whisper.
- One-click banner with cooldown feedback and announcements.
- Stacked banners for multiple matches.
- Minimap button, blacklist support, and saved position.

## Commands
- `/noz` or `/nozmie` - Open settings.
- `/noz minimap` - Toggle minimap icon.
- `/noz last` - Show last banner.
- `/noz blacklist` - Show blacklist.
- `/noz blacklist <words>` - Set blacklist (comma-separated).

## Supported Content (High-Level)
- Mythic+ dungeons across multiple expansions.
- Raid teleports.
- Mage teleports and portals.
- Class utilities (buffs, summons).
- Hearthstones and teleport toys.
- Utility services (repair, mailbox, transmog).

## Notes
- Portals can be prioritized over teleports via settings.
- Only known spells and owned items/toys are shown.
- Minimap icon can be toggled on in settings.
- Blacklist is possible in settings.

## File Structure
```
Data.lua
Config.lua
Detector.lua
Helpers.lua
BannerUI.lua
BannerController.lua
Settings.lua
Init.lua
Minimap.lua
```
