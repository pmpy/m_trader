VorpCore.addRpcCallback("m_trader:server:getJob", function(source, cb, args)
    local character = VorpCore.getUser(source).getUsedCharacter
    cb(character.job)
end)

VorpCore.addRpcCallback("m_trader:server:getInventory", function(source, cb, args)
    exports["vorp_inventory"]:getUserInventoryItems(source, function(inventory)
        cb(inventory)
    end)
end)