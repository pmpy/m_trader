IsAccessibleTrader = function(traderName)
    for _, traderData in pairs(AccessibleTraders) do
        if traderData.name == traderName then
            return true
        end
    end

    return false
end

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