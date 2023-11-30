Config = {}

Config.DevMode = false

Config.PromptsKeys = {
    ['OPEN_MENU'] = { label = "Press", key = 0x760A9C6F},
}

Config.Travelling = {

    ['SaintDenis'] = { 

        IsGuarma = false,

        BlipData = {
            Allowed = true,
            Name    = "Saint Denis Travelling Port Side",
            Sprite  = 2033397166,
        },

        ActionDistance          = 2.0,

        MainLocation            = {x = 2671.13, y = -1552.96, z = 46.47, h = 0}, -- The location where you can start the travelling.
        SpawnLocation           = {x = 1269.242, y = -6854.48, z = 43.318, h = 244.54634094238}, -- The spawn location when travelling from Saint Denis to Guarma.

        AllowTravelPayments     = true,
        PromptFooterDescription = "Saint Denis Travelling Port Side",

        LoadingScreenLabels     = {
            ['1'] = "Guarma", 
            ['2'] = "El Bahia Del Paz.", 
            ['3'] = "The boat has sailed, our destination is Guarma harbour.",
        },

        -- You can create as many payment methods you'd like, such as money payments or documents to be removed / not (items).
        -- #1 Currency can return an account type (0 - 3):
        -- 0: dollars | 1: cents | 2: gold | 3: donate coins.
        --
        -- #2 Currency can also return items, for example a passport: `currency = "passport"`.
        -- (!) When cost == 0, it will not remove any item (for example this is required for passports who are not guests but Citizens)
        PaymentTypes = {

            { menuLabel = "Travel With Citizen Passport", currency = "guarma_citizen_passport", cost = 0, success = "", error = "~e~You don't have any passport for travelling."},
            { menuLabel = "Travel With Guest Passport",   currency = "guarma_guest_passport",   cost = 1, success = "", error = "~e~You don't have any guest passport for travelling."},

            { menuLabel = "Travel By Paying 5$",          currency = 0,                         cost = 5, success = "", error = "~e~You don't have enough money for travelling."},
    
        },
        
    },

    ['Guarma'] = {

        IsGuarma = true,

        BlipData = {
            Allowed = true,
            Name    = "Guarma Travelling Port Side",
            Sprite  = 2033397166,
        },

        ActionDistance          = 2.0,

        MainLocation            = {x = 1266.666, y = -6852.54, z = 43.318, h = 62.740345001221}, -- The location where you can start the travelling.
        SpawnLocation           = {x = 2670.899, y = -1548.12, z = 45.969, h = 0.72131073474884}, -- The spawn location when travelling from Guarma to Saint Denis.

        AllowTravelPayments     = false, -- No need to pay again or request for passport for returning to saint denis.
        MenuLabel               = "Travel to Saint Denis", -- This option (MenuLabel) is required when AllowTravelPayments is set to false.

        LoadingScreenLabels     = {
            ['1'] = "Mainland", 
            ['2'] = "Saint Denis Harbour.", 
            ['3'] = "The boat has sailed, our destination is Saint Denis harbour.",
        },

        PromptFooterDescription = "Guarma Travelling Port Side",
    },

}

-----------------------------------------------------------
--[[ Notification Functions  ]]--
-----------------------------------------------------------

-- @param source is always null when called from client.
-- @param messageType returns "success" or "error" depends when and where the message is sent.
function SendNotification(source, message, messageType)

    if not source then
        TriggerEvent('tpz_core:sendRightTipNotification', message, 3000)
    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', source, message, 3000)
    end
  
end
