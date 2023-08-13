ESX = {}
ESX.Players = {}
ESX.Jobs = {}
ESX.Items = {}
Core = {}
Core.UsableItemsCallbacks = {}
Core.RegisteredCommands = {}
Core.Pickups = {}
Core.PickupId = 0
Core.PlayerFunctionOverrides = {}
Core.DatabaseConnected = false
Core.playersByIdentifier = {}

Core.vehicleTypesByModel = {}

AddEventHandler("esx:getSharedObject", function()
	local Invoke = GetInvokingResource()
	print(("[^1ERROR^7] Resource ^5%s^7 Used the ^5getSharedObject^7 Event, this event ^1no longer exists!^7 Visit https://documentation.esx-framework.org/tutorials/tutorials-esx/sharedevent for how to fix!")
		:format(Invoke))
end)

exports('getSharedObject', function()
	return ESX
end)

Config.PlayerFunctionOverride = 'OxInventory'
SetConvarReplicated('inventory:framework', 'esx')
SetConvarReplicated('inventory:weight', 250 * 1000)

local function StartDBSync()
	CreateThread(function()
		while true do
			Wait(10 * 60 * 1000)
			Core.SavePlayers()
		end
	end)
end

MySQL.ready(function()
	Core.DatabaseConnected = true
	TriggerEvent('__cfx_export_ox_inventory_Items', function(ref)
		if ref then
			ESX.Items = ref()
		end
	end)

	AddEventHandler('ox_inventory:itemList', function(items)
		ESX.Items = items
	end)

	while not next(ESX.Items) do
		Wait(0)
	end

	ESX.RefreshJobs()

	print(('[^2INFO^7] ESX ^5Legacy %s^0 initialized!'):format(GetResourceMetadata(GetCurrentResourceName(), "version", 0)))

	StartDBSync()
	StartPayCheck()
end)
