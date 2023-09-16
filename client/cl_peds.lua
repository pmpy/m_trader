local peds = {}

UpdatePeds = function()
    for _, traderData in pairs(AccessibleTraders) do
        if not peds[traderData.name] and traderData.ped.enabled then
            local hashModel = GetHashKey(traderData.ped.model)
            local pedLocation = traderData.ped.location

            if IsModelValid(hashModel) then
                RequestModel(hashModel)
                while not HasModelLoaded(hashModel) do
                    Wait(100)
                end

                local ped = CreatePed(hashModel, pedLocation.x, pedLocation.y, pedLocation.z, pedLocation.w, false, true, true, true)
                Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
                SetEntityNoCollisionEntity(PlayerPedId(), ped, false)
                SetEntityCanBeDamaged(ped, false)
                SetEntityInvincible(ped, true)
                Wait(1000)
                FreezeEntityPosition(ped, true)
                SetBlockingOfNonTemporaryEvents(ped, true)

                peds[traderData.name] = ped
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