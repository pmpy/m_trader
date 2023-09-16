RegisterNetEvent("m_trader:server:sellPelt", function(traderIndex, itemName)
    local traderData = Config.Traders[traderIndex]
    local character = VorpCore.getUser(source).getUsedCharacter

    if not character then return end
    if not traderData then return end
    if not Config.Prices[itemName] then return end
    if traderData.blacklistedItems[itemName] then return end

    local item = exports["vorp_inventory"]:getItemByName(source, itemName)
    local price = FetchItemPrice(traderData, item.name)
    local totalPrice = item.count * price
    if not item then return end

    local itemRemoved = exports["vorp_inventory"]:subItem(source, item.name, item.count)
    if itemRemoved then
        character.addCurrency(0, totalPrice)
        VorpCore.NotifyRightTip(source, "You sold " .. item.count .. "x " .. item.label .. " for $" .. totalPrice, 4000)
        TriggerClientEvent("m_trader:client:updateTrader", source, traderIndex, itemName)
    end
end)

RegisterNetEvent("m_trader:server:sellAll", function(traderIndex)
    local traderData = Config.Traders[traderIndex]
    local character = VorpCore.getUser(source).getUsedCharacter

    if not character then return end
    if not traderData then return end

    FetchTotalPriceToSellAll(source, traderIndex, function(itemsToSell)
        local totalPrice = 0.0
        local totalPeltsSold = 0

        for _, item in pairs(itemsToSell) do
            local itemRemoved = exports["vorp_inventory"]:subItem(source, item.name, item.count)
            if itemRemoved then
                totalPeltsSold = totalPeltsSold + item.count
                totalPrice = totalPrice + item.price
            end
        end

        if totalPrice > 0 and totalPeltsSold > 0 then
            character.addCurrency(0, totalPrice)
            VorpCore.NotifyRightTip(source, "You sold " .. totalPeltsSold .. "x Pelts for $" .. totalPrice, 4000)
        else
            VorpCore.NotifyRightTip(source, "You sold nothing..?", 4000)
        end

        TriggerClientEvent("m_trader:client:closeTrader", source)
    end)
end)

FetchTotalPriceToSellAll = function(source, traderIndex, cb)
    local traderData = Config.Traders[traderIndex]

    exports["vorp_inventory"]:getUserInventoryItems(source, function(inventory)
        local itemsToSell = {}

        for _, item in pairs(inventory) do
            if Config.Prices[item.name] and not table.containsValue(traderData.blacklistedItems, item.name) then
                local itemPrice = FetchItemPrice(traderData, item.name)

                table.insert(itemsToSell, {
                    name = item.name,
                    count = item.count,
                    price = item.count * itemPrice
                })
            end
        end

        cb(itemsToSell)
    end)
end