local insideMarker = nil
AccessibleTraders = nil

CreateThread(function()
    Wait(500)

    while true or AccessibleTraders == nil do
        VORPCore.RpcCall("m_trader:server:getJob", function(job)
            local jobValidTraders = {}

            for _, traderData in pairs(Config.Traders) do
                if not traderData.job.enabled or traderData.job.enabled and traderData.job.value == job then
                    table.insert(jobValidTraders, traderData)
                end
            end

            AccessibleTraders = jobValidTraders

            UpdateBlips()
            UpdatePeds()
        end)

        Wait(25000)
    end
end)

CreateThread(function()
    Wait(750)

    while true do Wait(1)
        local inTraderData = FetchInsideMarker()
        DrawDisplayMarkers()

        if inTraderData and inTraderData.prompt.data and not inTraderData.prompt.data:isEnabled() and not IsMenuOpen() then
            inTraderData.prompt.data:setEnabledAndVisible(true)
            HandlePrompt()
        end
    end
end)

HandlePrompt = function()
    CreateThread(function()
        while true do Wait(0)
            if insideMarker then
                insideMarker.prompt.data:handleEvents()
            end
        end
    end)
end

FetchInsideMarker = function()
    local playerCoords = GetEntityCoords(PlayerPedId())

    if AccessibleTraders then
        for _, traderData in pairs(AccessibleTraders) do
            local distance = #(playerCoords - traderData.marker.location)

            if insideMarker and insideMarker.prompt.data:isEnabled() and IsMenuOpen() then
                insideMarker.prompt.data:setEnabledAndVisible(false)
            elseif distance < traderData.marker.size then
                insideMarker = traderData
                return traderData
            elseif insideMarker and traderData == insideMarker then
                insideMarker.prompt.data:setEnabledAndVisible(false)
                insideMarker = nil
            end
        end
    end

    return nil
end

IsMenuOpen = function()
    return MenuData.IsOpen("default", GetCurrentResourceName(), Config.Default.menuName)
end

DrawDisplayMarkers = function()
    local playerCoords = GetEntityCoords(PlayerPedId())

    if AccessibleTraders then
        for _, traderData in pairs(AccessibleTraders) do
            local distance = #(playerCoords - traderData.marker.location)

            if distance < traderData.marker.displayDistance then
                local markerData = traderData.marker
                local location = markerData.location
                local colour = markerData.colour

                Citizen.InvokeNative(0x2A32FAA57B937173, 0x07DCE236, location.x, location.y, location.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, markerData.size, markerData.size, markerData.size, colour.r, colour.g, colour.b, 100, false, true, 2, false, false, false, false)
            end
        end
    end
end