Config = {}

Config.Default = {
    menuName = "pelt_trader_menu"
}

Config.Traders = {
    {
        name = "valentine_trader",
        prompt = {
            label = "Valentine Pelt Trader",
            data = nil -- Don't touch this variable :)
        },
        menu = {
            title = "Valentine | Pelt Trader",
            align = 'top-right',
            subtext = ''
        },
        blip = { -- Blip on map
            enabled = true,
            label = "Valentine Pelt Trader",
            location = vector3(-333.63, 769.69, 116.4),
            sprite = -1406874050
        },
        ped = {
            enabled = true,
            model = "u_m_m_sdtrapper_01",
            location = vector4(-333.19, 769.62, 116.39, 100.84) -- x, y, z, heading / w
        },
        marker = {
            location = vector3(-334.01, 769.5, 116.4),
            offset = -0.5, -- How much to drop marker down
            displayDistance = 50, -- View distance
            size = 1.5, -- Default Size
            colour = {
                r = 255,
                g = 0,
                b = 0
            }
        },
        job = { -- Enable / Distance job locking
            enabled = false,
            value = ""
        },
        itemMultipliers = { -- Specific items price multiplier
            -- ['item_name'] = 1.0
        },
        blacklistedItems = { -- Items this trader will not to buy
            -- 'item_name',
        },
        overallMultiplier = 1.0 -- Overall items price multiplier, setting lower than 1.0 will make items worth less value
    },
}

-- List of items and prices that can be sold at traders
Config.Prices = {
    -- ['item_name'] = 5,
    ['wolfpelt'] = 1.5,
    ['coyote_pelt'] = 1.35,
    ['boaskin'] = 1,
    ['rams'] = 1,
}