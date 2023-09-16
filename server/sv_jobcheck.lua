VorpCore.addRpcCallback("m_trader:server:getJob", function(source, cb, args)
    local character = VorpCore.getUser(source).getUsedCharacter
    cb(character.job)
end)