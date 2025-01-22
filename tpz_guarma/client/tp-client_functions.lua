
--[[-------------------------------------------------------
 Prompts
]]---------------------------------------------------------

local Prompts     = GetRandomIntInRange(0, 0xffffff)
local PromptsList = {}

CreateLocationPrompts = function()

    for index, tprompt in pairs (Config.PromptsKeys) do

		local str = tprompt.label
		local keyPress = tprompt.key
	
		local dPrompt = PromptRegisterBegin()
		PromptSetControlAction(dPrompt, keyPress)
		str = CreateVarString(10, 'LITERAL_STRING', str)
		PromptSetText(dPrompt, str)
		PromptSetEnabled(dPrompt, 1)
		PromptSetVisible(dPrompt, 1)
		PromptSetStandardMode(dPrompt, 1)
		PromptSetHoldMode(dPrompt, 1000)
		PromptSetGroup(dPrompt, Prompts)
		Citizen.InvokeNative(0xC5F428EE08FA7F2C, dPrompt, true)
		PromptRegisterEnd(dPrompt)
	
		table.insert(PromptsList, {prompt = dPrompt, action = index})

    end

end

GetPromptData = function ()
    return Prompts, PromptsList
end

--[[-------------------------------------------------------
 Events
]]---------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    Citizen.InvokeNative(0x00EDE88D4D13CF59, Prompts) -- UiPromptDelete

    Prompts     = nil
    PromptsList = nil
end)

--[[-------------------------------------------------------
 Blips Management
]]---------------------------------------------------------

function AddBlip(Store)
	Config.Travelling[Store].BlipHandle = N_0x554d9d53f696d002(1664425300, Config.Travelling[Store].MainLocation.x, Config.Travelling[Store].MainLocation.y, Config.Travelling[Store].MainLocation.z)

	SetBlipSprite(Config.Travelling[Store].BlipHandle, Config.Travelling[Store].BlipData.Sprite, 1)
	SetBlipScale(Config.Travelling[Store].BlipHandle, 0.2)
	Citizen.InvokeNative(0x9CB1A1623062F402, Config.Travelling[Store].BlipHandle, Config.Travelling[Store].BlipData.Name)

	Citizen.InvokeNative(0x662D364ABF16DE2F, Config.Travelling[Store].BlipHandle, 0xF91DD38D)
end
