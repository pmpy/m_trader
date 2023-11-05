local menuElementsData -- Store elements in variable to automatically update menu when someone sells

RegisterNetEvent("m_trader:client:updateTrader", function(traderIndex, itemName)
    menuElementsData = RemoveTraderMenuElement(itemName)

    if #menuElementsData == 1 then -- Only sell all button left
        MenuData.CloseAll()
    else
        HandleTraderMenu(traderIndex)
    end
end)

RegisterNetEvent("m_trader:client:closeTrader", function()
    MenuData.CloseAll()
    menuElementsData = nil
end)

OpenTrader = function(traderIndex)
    local traderData = Config.Traders[traderIndex]

    if traderData then
        FetchItemsToSell(traderIndex, function(itemsToSell)
            if #itemsToSell == 0 then
                VORPCore.NotifyRightTip("You have nothing this trader wants..", 4000)
            else
                menuElementsData = FormatTraderMenuElements(traderData, itemsToSell)
                HandleTraderMenu(traderIndex)
            end
        end)
    end
end

HandleTraderMenu = function(traderIndex)
    local traderData = Config.Traders[traderIndex]

    MenuData.CloseAll()
    MenuData.Open('default', GetCurrentResourceName(), Config.Default.traderMenuName, {
        title    = traderData.menu.title,
        subtext  = traderData.menu.subtext,
        align    = traderData.menu.align,
        elements = menuElementsData,
    },
    function(data, menu)
        local selectedItem = data.current.value

        if selectedItem == "menu_sell_all" then
            TriggerServerEvent("m_trader:server:sellAll", traderIndex)
        else
            TriggerServerEvent("m_trader:server:sellPelt", traderIndex, selectedItem)
        end
    end,
    function(data, menu)
        menu.close()
        menuElementsData = nil
    end)
end

RemoveTraderMenuElement = function(itemName)
    local toReturn = {}

    for _, elementData in pairs(menuElementsData) do
        if elementData.value ~= itemName then
            table.insert(toReturn, elementData)
        end
    end

    return toReturn
end

FormatTraderMenuElements = function(traderData, items)
    local elements = {}
    local totalPrice = 0.0

    for _, itemData in pairs(items) do
        local itemPrice = FetchItemPrice(traderData, itemData.name)

        totalPrice = totalPrice + (itemData.count * itemPrice)

        table.insert(elements, {
            label = itemData.count .. "x " ..itemData.label .. " | $" .. (itemData.count * itemPrice),
            value = itemData.name,
            desc = "Price Per Pelt: $" .. itemPrice .. (itemData.count > 1 and " | Total Price: $" .. (itemData.count * itemPrice) or ""),
        })
    end

    if #elements > 1 then
        table.insert(elements, {
            label = "Sell All Pelts | $" .. totalPrice,
            desc = "Sell all your pelts on you for $" .. totalPrice,
            value = "menu_sell_all"
        })
    end

    return elements
end

FetchItemsToSell = function(traderIndex, cb)
    local traderData = Config.Traders[traderIndex]

    VORPCore.RpcCall("m_trader:server:getInventory", function(inventory)
        local itemsToSell = {}

        for _, itemData in pairs(inventory) do
            if Config.Prices[itemData.name] and not table.containsValue(traderData.blacklistedItems, itemData.name) then
                table.insert(itemsToSell, {
                    label = itemData.label,
                    name = itemData.name,
                    count = itemData.count,
                })
            end
        end

        cb(itemsToSell)
    end)
end