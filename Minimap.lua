-- Nozmie Minimap Icon using LibDataBroker and LibDBIcon
local ldb = LibStub("LibDataBroker-1.1")
local icon = LibStub("LibDBIcon-1.0")

NozmieDB = NozmieDB or {}
NozmieDB.minimap = NozmieDB.minimap or { hide = false }

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
    end,
})

function Nozmie_ToggleMinimapIcon()
    NozmieDB.minimap.hide = not NozmieDB.minimap.hide
    if NozmieDB.minimap.hide then
        icon:Hide("Nozmie")
    else
        icon:Show("Nozmie")
    end
end

if icon and dataobj then
    icon:Register("Nozmie", dataobj, NozmieDB.minimap)
end
