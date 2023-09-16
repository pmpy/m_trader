IsAccessibleTrader = function(traderName)
    for _, traderData in pairs(AccessibleTraders) do
        if traderData.name == traderName then
            return true
        end
    end

    return false
end