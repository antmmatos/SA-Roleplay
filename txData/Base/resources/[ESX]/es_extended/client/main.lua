local pickups = {}

RegisterNetEvent("esx:requestModel", function(model)
	ESX.Streaming.RequestModel(model)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
	ESX.PlayerData = xPlayer

	Wait(3000)

	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
end)

RegisterNetEvent('esx:setMaxWeight')
AddEventHandler('esx:setMaxWeight', function(newMaxWeight) ESX.SetPlayerData("maxWeight", newMaxWeight) end)

local function onPlayerSpawn()
	ESX.SetPlayerData('ped', PlayerPedId())
	ESX.SetPlayerData('dead', false)
end

AddEventHandler('playerSpawned', onPlayerSpawn)
AddEventHandler('esx:onPlayerSpawn', onPlayerSpawn)

AddEventHandler('esx:onPlayerDeath', function()
	ESX.SetPlayerData('ped', PlayerPedId())
	ESX.SetPlayerData('dead', true)
end)


AddStateBagChangeHandler('VehicleProperties', nil, function(bagName, _, value)
	if not value then
		return
	end

	local netId = bagName:gsub('entity:', '')
	local timer = GetGameTimer()
	while not NetworkDoesEntityExistWithNetworkId(tonumber(netId)) do
		Wait(0)
		if GetGameTimer() - timer > 10000 then
			return
		end
	end

	local vehicle = NetToVeh(tonumber(netId))
	local timer2 = GetGameTimer()
	while NetworkGetEntityOwner(vehicle) ~= PlayerId() do
		Wait(0)
		if GetGameTimer() - timer2 > 10000 then
			return
		end
	end

	ESX.Game.SetVehicleProperties(vehicle, value)
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for i = 1, #(ESX.PlayerData.accounts) do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
			break
		end
	end

	ESX.SetPlayerData('accounts', ESX.PlayerData.accounts)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
	ESX.SetPlayerData('job', Job)
end)

RegisterNetEvent('esx:registerSuggestions')
AddEventHandler('esx:registerSuggestions', function(registeredCommands)
	for name, command in pairs(registeredCommands) do
		if command.suggestion then
			TriggerEvent('chat:addSuggestion', ('/%s'):format(name), command.suggestion.help, command.suggestion.arguments)
		end
	end
end)

ESX.RegisterClientCallback("esx:GetVehicleType", function(cb, model)
	cb(ESX.GetVehicleType(model))
end)

RegisterNetEvent('esx:updatePlayerData', function(key, val)
	ESX.SetPlayerData(key, val)
end)
