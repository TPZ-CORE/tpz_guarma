---@diagnostic disable: undefined-global
MenuData = {}

TriggerEvent("menuapi:getData", function(call)
    MenuData = call
end)

OpenedMenu = false


function OpenTravellingMenu(index)
    OpenedMenu = true

    local _player = PlayerPedId()
    TaskStandStill(_player, -1)
    
    local config   = Config.Travelling[index]
    local elements = {}

    if config.AllowTravelPayments then

        for _, method in pairs (config.PaymentTypes) do
            table.insert(elements, {label = method.menuLabel, value = method.currency, cost = method.cost, error = method.error, desc = ""})
        end

    else
        table.insert(elements, {label = config.MenuLabel, value = "free", desc = ""})
    end

    MenuData.Open('default', GetCurrentResourceName(), 'main',

    {
        title    = Locales['MENU_TITLE'],
        subtext  = Locales['MENU_SUB_TEXT'],
        align    = "left",
        elements = elements,
        lastmenu = "notMenu"
    },

    function(data, menu)
        if (data.current == "backup") then
            TaskStandStill(PlayerPedId(), 1)
            OpenedMenu = false
            return
        end
        
        local isFreeTravelling  = false
        local isAllowedToTravel = false
        local finished          = false

        if data.current.value == "free" then
            isFreeTravelling = true
        end

        menu.close()
        OpenedMenu = false

        if not isFreeTravelling then
            TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_guarma:hasSelectedPaymentMethod", function(cb)
                isAllowedToTravel = cb

                if not isAllowedToTravel then
                    SendNotification(nil, data.current.error, "error")
                    TaskStandStill(PlayerPedId(), 1)
                end

                finished = true

            end, {currency = data.current.value, cost = data.current.cost})

        else

            isAllowedToTravel = true
            finished = true
        end

        while not finished do
            Wait(100)
        end

        if isAllowedToTravel then

            menu.close()

            TaskStandStill(PlayerPedId(), 1)
            DoScreenFadeIn(1000)
    
            if not config.IsGuarma then
    
                Citizen.InvokeNative(0x1E5B70E53DB661E5, 0, 0, 0, config.LoadingScreenLabels['1'], config.LoadingScreenLabels['2'], config.LoadingScreenLabels['3'])
    
                Citizen.InvokeNative(0xA657EC9DBC6CC900, 1935063277) -- Native setting Minimap by hash, can be either Guarma or World
                Citizen.InvokeNative(0xE8770EE02AEE45C2, 1) -- Set Guarma Water Type
                Citizen.InvokeNative(0x74E2261D2A66849A, true) -- Set Guarma Horizon Status
    
            else
    
                Citizen.InvokeNative(0x1E5B70E53DB661E5, 0, 0, 0, config.LoadingScreenLabels['1'], config.LoadingScreenLabels['2'], config.LoadingScreenLabels['3'])
    
                Citizen.InvokeNative(0x74E2261D2A66849A, 0)
                Citizen.InvokeNative(0xA657EC9DBC6CC900, -1868977180)
                Citizen.InvokeNative(0xE8770EE02AEE45C2, 0)
            end
    
            Wait(3000)
    
            exports.tpz_core:rClientAPI().teleportToCoords(config.SpawnLocation.x, config.SpawnLocation.y, config.SpawnLocation.z, config.SpawnLocation.h)
    
            Wait(20000)
    
            ShutdownLoadingScreen()
    
            DoScreenFadeIn(6000)

        end
      
    end,

    function(data, menu)
        TaskStandStill(PlayerPedId(), 1)
        OpenedMenu = false
        menu.close()
    end)

end