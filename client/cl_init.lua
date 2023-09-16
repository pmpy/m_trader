MenuData = {}
VORPCore = {}

TriggerEvent("getCore", function(core)
    VORPCore = core
end)

TriggerEvent("redemrp_menu_base:getData", function(call)
    MenuData = call
end)

CreateThread(function() -- Automatically drop all markers to the ground on startup
    for index, traderData in ipairs(Config.Traders) do
        local location = traderData.marker.location
        Config.Traders[index].marker.location = vector3(location.x, location.y, location.z + traderData.marker.offset)

        local traderPrompt = Uiprompt:new(`INPUT_DYNAMIC_SCENARIO`, "Open " .. traderData.prompt.label, nil, false)
        traderPrompt:setHoldMode(true)

        traderPrompt:setOnHoldModeJustCompleted(function()
            OpenTrader(index)
        end)

        Config.Traders[index].prompt.data = traderPrompt
    end
end)