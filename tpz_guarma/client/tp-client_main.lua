
local LoadedPlayer = false

-----------------------------------------------------------
--[[ Base Events  ]]--
-----------------------------------------------------------

-- Removing / Deleting blips on resource stop.
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    for locId, locationConfig in pairs(Config.Travelling) do

        if locationConfig.BlipHandle then
            RemoveBlip(locationConfig.BlipHandle)
        end
    end
end)

-- Creating prompts & loading location blips.
RegisterNetEvent('tpz_core:isPlayerReady')
AddEventHandler("tpz_core:isPlayerReady", function()

    if Config.DevMode then 
        return 
    end

    CreateLocationPrompts()

    -- Create location blips.
    for locId, locationConfig in pairs(Config.Travelling) do

        if locationConfig.BlipData.Allowed then
            AddBlip(locId)
        end
    end

    LoadedPlayer = true
end)


-- Creating prompts & loading location blips (devmode)
if Config.DevMode then

    Citizen.CreateThread(function ()

        CreateLocationPrompts()

        -- Create location blips.
        for locId, locationConfig in pairs(Config.Travelling) do

            if locationConfig.BlipData.Allowed then
                AddBlip(locId)
            end
        end

        LoadedPlayer = true

    end)

end

-----------------------------------------------------------
--[[ Threads  ]]--
-----------------------------------------------------------

Citizen.CreateThread(function()
	while true do

        Citizen.Wait(0)

        local sleep        = true

        local player       = PlayerPedId()
        local isPlayerDead = IsEntityDead(player)

        if LoadedPlayer and not isPlayerDead and not OpenedMenu then 
            local coords = GetEntityCoords(player)

            for locId, locationConfig in pairs(Config.Travelling) do

                local coordsDist = vector3(coords.x, coords.y, coords.z)
                local coordsLoc = vector3(locationConfig.MainLocation.x, locationConfig.MainLocation.y, locationConfig.MainLocation.z)
                local distance = #(coordsDist - coordsLoc)

                if (distance <= locationConfig.ActionDistance) then
                    sleep = false

                    local promptGroup, promptList = GetPromptData()

                    local label = CreateVarString(10, 'LITERAL_STRING', locationConfig.PromptFooterDescription)
                    PromptSetActiveGroupThisFrame(promptGroup, label)
                    
                    for i, prompt in pairs (promptList) do
    
                        if PromptHasHoldModeCompleted(prompt.prompt) then

                            if prompt.action == "OPEN_MENU" then

                                OpenTravellingMenu(locId)
                            end

                            Wait(1000)
                        end

                    end

                end

            end

        end

        if sleep then
            Citizen.Wait(1250)
        end
    end

end)

