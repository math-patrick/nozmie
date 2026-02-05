local Config = {
    BANNER = {
        WIDTH = 400,
        HEIGHT = 60
    },
    
    COLORS = {
        BACKDROP_NORMAL = {0, 0, 0, 0.7},  -- Dark semi-transparent
        BACKDROP_COOLDOWN = {0, 0, 0, 0.6},
        BORDER_NORMAL = {0.3, 0.3, 0.35, 0.8},  -- Subtle dark border
        BORDER_HOVER = {0.5, 0.5, 0.6, 1},  -- Slightly brighter on hover
        TEXT_NORMAL = {0.9, 0.9, 0.95},  -- Subtle light text
        TEXT_COOLDOWN = {0.5, 0.5, 0.5}
    },
    
    CHAT_EVENTS = {
        "CHAT_MSG_SAY",
        "CHAT_MSG_PARTY",
        "CHAT_MSG_RAID",
        "CHAT_MSG_GUILD",
        "CHAT_MSG_WHISPER"
    }
}

_G.EasyPort_Config = Config
