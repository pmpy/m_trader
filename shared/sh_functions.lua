FetchItemPrice = function(traderData, itemName)
    local price

    if traderData.itemMultipliers[itemName] then
        price = Config.Prices[itemName] * traderData.itemMultipliers[itemName]
    elseif traderData.overallMultiplier > 1.0 then
        price = Config.Prices[itemName] * traderData.overallMultiplier
    else
        price = Config.Prices[itemName]
    end

    return string.format("%.2f", price)
end

table.containsValue = function(array, value)
    for _, v in ipairs(array) do
        if v == value then
            return true
        end
    end
    return false
end