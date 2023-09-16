local blips = {}

UpdateBlips = function()
    for _, traderData in pairs(AccessibleTraders) do
        if not blips[traderData.name] and traderData.blip.enabled then
            local blipLocation = traderData.blip.location

            local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, vector3(blipLocation.x, blipLocation.y, blipLocation.z))
			SetBlipSprite(blip, traderData.blip.sprite)
			SetBlipScale(blip, 0.2)
			Citizen.InvokeNative(0x9CB1A1623062F402, blip, traderData.blip.label)

            blips[traderData.name] = blip
        end
    end

    for traderName, blip in pairs(blips) do
        if not IsAccessibleTrader(traderName) then
            RemoveBlip(blip)
        end
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for _, blip in pairs(blips) do
        RemoveBlip(blip)
    end
end)