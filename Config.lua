-- ============================================================================
-- Nozmie - Configuration Module
-- Banner dimensions, colors, and chat events
-- ============================================================================

local Config = {
    BANNER = {
        WIDTH = 420,
        HEIGHT = 68
    },
    
    COLORS = {
        BACKDROP_NORMAL = {0.05, 0.06, 0.08, 0.92},
        BACKDROP_COOLDOWN = {0.05, 0.06, 0.08, 0.75},
        BORDER_NORMAL = {0.25, 0.3, 0.35, 0.9},
        BORDER_HOVER = {0.6, 0.7, 0.85, 1},
        TEXT_NORMAL = {0.95, 0.96, 1},
        TEXT_COOLDOWN = {0.6, 0.6, 0.6},
        ACCENT = {0.24, 0.55, 0.95, 1},
        ACCENT_SOFT = {0.24, 0.55, 0.95, 0.35}
    },
    
    CHAT_EVENTS = {
        "CHAT_MSG_SAY",
        "CHAT_MSG_PARTY",
        "CHAT_MSG_RAID",
        "CHAT_MSG_GUILD",
        "CHAT_MSG_WHISPER"
    }
}

_G.Nozmie_Config = Config
