# Nozmie

Lightweight WoW addon that detects teleport and utility requests from chat and shows a one-click banner.

## Features
- Multi-select chat detection channels (Say, Party, Raid, Guild, Whisper).
- One-click banner with cooldown feedback and announcements.
- Stacked banners for multiple matches.
- Minimap button, blacklist support, and saved position.
- Suppression filters for global and instance-only categories.

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
- Keyword matching uses whole-word detection to prevent partial matches.

## Ultimas Mudancas
- Atualizacao das configuracoes: canais de chat e supressoes sao menus de selecao multipla; a lista negra virou um unico botao.
- As opcoes de supressao agora suportam listas globais e apenas em instancias.
- Visuais do banner mudaram para um estilo classico de dialogo do WoW, com moldura no icone e espacamento refinado.
- O canal de guilda agora vem desativado por padrao.
- A deteccao de palavras agora exige correspondencia de palavra inteira.

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
