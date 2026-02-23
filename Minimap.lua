local ldb = LibStub("LibDataBroker-1.1")
local icon = LibStub("LibDBIcon-1.0")

local dataobj = ldb:NewDataObject("Nozmie", {
    type = "launcher",
    text = "Nozmie",
    icon = "Interface\\Icons\\Spell_Holy_BorrowedTime",
    OnClick = function(self, button)
        if button == "LeftButton" and _G.Nozmie_ShowLastBanner then
            _G.Nozmie_ShowLastBanner()
        elseif button == "RightButton" and _G.Nozmie_Settings then
            _G.Nozmie_Settings.Show()
        end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddLine("Nozmie")
        tooltip:AddLine("Left-click: Show last banner", 1, 1, 1)
        tooltip:AddLine("Right-click: Open settings", 1, 1, 1)
    end
})

local Minimap = {}

function Minimap.UpdateVisibility()
    if not icon then
        return
    end

    if NozmieDB.minimapIcon then
        icon:Show("Nozmie")
    else
        icon:Hide("Nozmie")
    end
end

function Minimap.Initialize()
    if NozmieDB.minimapIcon and icon and dataobj then
        icon:Register("Nozmie", dataobj, NozmieDB.minimapIcon)
        icon:RegisterCallback("onMinimapIconMoved", function(event, name, position)
            if name == "Nozmie" then
                NozmieDB.minimap.position = position
            end
        end)
    end

    Minimap.UpdateVisibility()
end

function Nozmie_ToggleMinimapIcon()
    NozmieDB.minimapIcon = not NozmieDB.minimapIcon
    Minimap.UpdateVisibility()
end

_G.Nozmie_Minimap = Minimap
