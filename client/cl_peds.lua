local peds = {}

CreateThread(function()
    while true do Wait(5000)
        UpdatePeds()
    end
end)

UpdatePeds = function()
    for _, traderData in pairs(AccessibleTraders) do
        if traderData.ped.enabled then
            local hashModel = GetHashKey(traderData.ped.model)
            local pedLocation = traderData.ped.location
            local distance = #(GetEntityCoords(PlayerPedId()) - vector3(pedLocation.x, pedLocation.y, pedLocation.z))

            RequestModel(hashModel)
            while not HasModelLoaded(hashModel) do Wait(1) end

            if not peds[traderData.name] and distance <= traderData.ped.spawnDistance and IsModelValid(hashModel) then
                local groundedZ = GetGroundedCoords(pedLocation.x, pedLocation.y)
                local ped = CreatePed(hashModel, pedLocation.x, pedLocation.y, groundedZ and groundedZ or pedLocation.z, pedLocation.w, false, true, true, true)

                Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
                SetEntityNoCollisionEntity(PlayerPedId(), ped, false)
                SetEntityCanBeDamaged(ped, false)
                SetEntityInvincible(ped, true)
                Wait(1000)
                FreezeEntityPosition(ped, true)
                SetBlockingOfNonTemporaryEvents(ped, true)

                peds[traderData.name] = ped
            elseif distance > traderData.ped.spawnDistance and peds[traderData.name] then
                DeleteEntity(peds[traderData.name])
                peds[traderData.name] = nil
            end
        end
    end

    for traderName, ped in pairs(peds) do
        if not IsAccessibleTrader(traderName) then
            DeleteEntity(ped)
        end
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for _, ped in pairs(peds) do
        DeleteEntity(ped)
    end
end)

GetGroundedCoords = function(x, y)
    for height = 1, 1000 do
        local foundGround, groundZ, normal = GetGroundZAndNormalFor_3dCoord(x, y, height + 0.0)
        if foundGround then
            return groundZ
        end
        Wait(1)
    end
    return nil
end