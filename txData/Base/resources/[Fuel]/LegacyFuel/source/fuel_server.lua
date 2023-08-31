RegisterServerEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	local amount = ESX.Math.Round(price)

	if price > 0 then
		xPlayer.removeAccountMoney('bank', amount)
	end
end)

RegisterServerEvent('fuel:givenada')
AddEventHandler('fuel:givenada', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	local amount = ESX.Math.Round(price)

	if price > 0 then
		xPlayer.removeAccountMoney('bank', amount)
		xPlayer.addInventoryItem("WEAPON_PETROLCAN", 1)
	end
end)
