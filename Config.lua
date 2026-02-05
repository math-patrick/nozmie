local Config = {
    BANNER = {
        WIDTH = 320,
        HEIGHT = 60
    },
    
    COLORS = {
        BACKDROP_NORMAL = {0.05, 0.05, 0.15, 0.95},
        BACKDROP_COOLDOWN = {0.03, 0.03, 0.1, 0.95},
        BORDER_NORMAL = {0.3, 0.6, 1, 1},
        BORDER_HOVER = {0.5, 0.8, 1, 1},
        TEXT_NORMAL = {1, 1, 1},
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
