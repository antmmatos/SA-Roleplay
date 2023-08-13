SetMapName('San Andreas')

local newPlayer =
'INSERT INTO `users` SET `uId` = ?, `accounts` = ?, `identifier` = ?, `group` = ?, `firstname` = ?, `lastname` = ?, `dateofbirth` = ?, `sex` = ?, `height` = ?'
local loadPlayer =
'SELECT `accounts`, `job`, `job_grade`, `group`, `position`, `inventory`, `skin`, `metadata`, `firstname`, `lastname`, `dateofbirth`, `sex`, `height` FROM `users` WHERE identifier = ?'

AddEventHandler('esx:onPlayerJoined', function(src, char, data)
	while not next(ESX.Jobs) do
		Wait(50)
	end

	if not ESX.Players[src] then
		local identifier = char .. ':' .. ESX.GetIdentifier(src)
		if data then
			createESXPlayer(identifier, src, data)
		else
			loadESXPlayer(identifier, src, false)
		end
	end
end)

function createESXPlayer(identifier, playerId, data)
	local accounts = {}

	for account, money in pairs(Config.StartingAccountMoney) do
		accounts[account] = money
	end

	local identifiers = GetPlayerIdentifiers(playerId)
	local discordId
	for _, v in pairs(identifiers) do
		if string.match(v, 'discord:') then
			discordId = string.gsub(v, 'discord:', '')
			break
		end
	end
	if not discordId then
		DropPlayer(playerId, 'Ocorreu um erro ao carregar a personagem. Entra em contacto com a equipa.')
	end

	local uId = MySQL.scalar.await('SELECT `ID` FROM `discord_whitelist` WHERE `DiscordID` = ?', { discordId })

	if not uId then
		DropPlayer(playerId, 'Ocorreu um erro ao carregar a personagem. Entra em contacto com a equipa.')
	end

	MySQL.prepare(newPlayer,
		{ uId, json.encode(accounts), identifier, "user", data.firstname, data.lastname, data.dateofbirth, data.sex,
			data.height }, function()
			loadESXPlayer(identifier, playerId, true)
		end)
end

function loadESXPlayer(identifier, playerId, isNew)
	local userData = {
		accounts = {},
		inventory = {},
		job = {},
		playerName = GetPlayerName(playerId),
		weight = 0,
		metadata = {}
	}
	local result = MySQL.prepare.await(loadPlayer, { identifier })
	local job, grade, jobObject, gradeObject = result.job, tostring(result.job_grade)
	local foundAccounts, foundItems = {}, {}

	-- Accounts
	if result.accounts and result.accounts ~= '' then
		local accounts = json.decode(result.accounts)

		for account, money in pairs(accounts) do
			foundAccounts[account] = money
		end
	end

	for account, data in pairs(Config.Accounts) do
		if data.round == nil then
			data.round = true
		end
		local index = #userData.accounts + 1
		userData.accounts[index] = {
			name = account,
			money = foundAccounts[account] or Config.StartingAccountMoney[account] or 0,
			label = data.label,
			round = data.round,
			index = index
		}
	end

	-- Job
	if ESX.DoesJobExist(job, grade) then
		jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
	else
		print(('[^3WARNING^7] Ignoring invalid job for ^5%s^7 [job: ^5%s^7, grade: ^5%s^7]'):format(identifier, job,
			grade))
		job, grade = 'unemployed', '0'
		jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
	end

	userData.job.id = jobObject.id
	userData.job.name = jobObject.name
	userData.job.label = jobObject.label

	userData.job.grade = tonumber(grade)
	userData.job.grade_name = gradeObject.name
	userData.job.grade_label = gradeObject.label
	userData.job.grade_salary = gradeObject.salary

	userData.job.skin_male = {}
	userData.job.skin_female = {}

	if gradeObject.skin_male then
		userData.job.skin_male = json.decode(gradeObject.skin_male)
	end
	if gradeObject.skin_female then
		userData.job.skin_female = json.decode(gradeObject.skin_female)
	end

	if result.inventory and result.inventory ~= '' then
		userData.inventory = json.decode(result.inventory)
	else
		userData.inventory = {}
	end

	-- Group
	if result.group then
			userData.group = result.group
	else
		userData.group = 'user'
	end

	-- Position
	userData.coords = json.decode(result.position) or Config.DefaultSpawns[math.random(#Config.DefaultSpawns)]

	-- Skin
	if result.skin and result.skin ~= '' then
		userData.skin = json.decode(result.skin)
	else
		if userData.sex == 'f' then
			userData.skin = { sex = 1 }
		else
			userData.skin = { sex = 0 }
		end
	end

	-- Identity
	if result.firstname and result.firstname ~= '' then
		userData.firstname = result.firstname
		userData.lastname = result.lastname
		userData.playerName = userData.firstname .. ' ' .. userData.lastname
		if result.dateofbirth then
			userData.dateofbirth = result.dateofbirth
		end
		if result.sex then
			userData.sex = result.sex
		end
		if result.height then
			userData.height = result.height
		end
	end

	if result.metadata and result.metadata ~= '' then
		local metadata = json.decode(result.metadata)
		userData.metadata = metadata
	end

	local xPlayer = CreateExtendedPlayer(playerId, identifier, userData.group, userData.accounts, userData.inventory,
		userData.weight, userData.job, userData.playerName, userData.coords, userData.metadata)
	ESX.Players[playerId] = xPlayer
	Core.playersByIdentifier[identifier] = xPlayer

	if userData.firstname then
		xPlayer.set('firstName', userData.firstname)
		xPlayer.set('lastName', userData.lastname)
		if userData.dateofbirth then
			xPlayer.set('dateofbirth', userData.dateofbirth)
		end
		if userData.sex then
			xPlayer.set('sex', userData.sex)
		end
		if userData.height then
			xPlayer.set('height', userData.height)
		end
	end

	TriggerEvent('esx:playerLoaded', playerId, xPlayer, isNew)

	xPlayer.triggerEvent('esx:playerLoaded',
		{
			accounts = xPlayer.getAccounts(),
			coords = userData.coords,
			identifier = xPlayer.getIdentifier(),
			inventory = xPlayer.getInventory(),
			job = xPlayer.getJob(),
			maxWeight = xPlayer.getMaxWeight(),
			money = xPlayer.getMoney(),
			sex = xPlayer.get("sex") or "m",
			firstName = xPlayer.get("firstName") or "John",
			lastName = xPlayer.get("lastName") or "Doe",
			dateofbirth = xPlayer.get("dateofbirth") or "01/01/2000",
			height = xPlayer.get("height") or 120,
			dead = false,
			metadata = xPlayer.getMeta()
		}, isNew,
		userData.skin)

	exports.ox_inventory:setPlayerInventory(xPlayer, userData.inventory)

	if isNew then
		for account, money in pairs(Config.StartingAccountMoney) do
			if account == 'money' or account == 'black_money' then
				exports.ox_inventory:AddItem(playerId, account, money)
			end
		end
	end
	xPlayer.triggerEvent('esx:registerSuggestions', Core.RegisteredCommands)
	print(('[^2INFO^0] Player ^5"%s"^0 has connected to the server. ID: ^5%s^7'):format(xPlayer.getName(), playerId))
end

AddEventHandler('chatMessage', function(playerId, _, message)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	if message:sub(1, 1) == '/' and playerId > 0 then
		CancelEvent()
		local commandName = message:sub(1):gmatch("%w+")()
		xPlayer.showNotification(TranslateCap('commanderror_invalidcommand', commandName))
	end
end)

AddEventHandler('playerDropped', function(reason)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		TriggerEvent('esx:playerDropped', playerId, reason)

		Core.playersByIdentifier[xPlayer.identifier] = nil
		Core.SavePlayer(xPlayer, function()
			ESX.Players[playerId] = nil
		end)
	end
end)

AddEventHandler('esx:playerLogout', function(playerId, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	if xPlayer then
		TriggerEvent('esx:playerDropped', playerId)

		Core.playersByIdentifier[xPlayer.identifier] = nil
		Core.SavePlayer(xPlayer, function()
			ESX.Players[playerId] = nil
			if cb then
				cb()
			end
		end)
	end
	TriggerClientEvent("esx:onPlayerLogout", playerId)
end)

ESX.RegisterServerCallback('esx:getPlayerData', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb({
		identifier = xPlayer.identifier,
		accounts = xPlayer.getAccounts(),
		inventory = xPlayer.getInventory(),
		job = xPlayer.getJob(),
		money = xPlayer.getMoney(),
		position = xPlayer.getCoords(true),
		metadata = xPlayer.getMeta()
	})
end)

ESX.RegisterServerCallback('esx:getGameBuild', function(_, cb)
	cb(tonumber(GetConvar("sv_enforceGameBuild", 1604)))
end)

ESX.RegisterServerCallback('esx:getOtherPlayerData', function(_, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	cb({
		identifier = xPlayer.identifier,
		accounts = xPlayer.getAccounts(),
		inventory = xPlayer.getInventory(),
		job = xPlayer.getJob(),
		money = xPlayer.getMoney(),
		position = xPlayer.getCoords(true),
		metadata = xPlayer.getMeta()
	})
end)

ESX.RegisterServerCallback('esx:getPlayerNames', function(source, cb, players)
	players[source] = nil

	for playerId, _ in pairs(players) do
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer then
			players[playerId] = xPlayer.getName()
		else
			players[playerId] = nil
		end
	end

	cb(players)
end)

ESX.RegisterServerCallback("esx:spawnVehicle", function(source, cb, vehData)
	local ped = GetPlayerPed(source)
	ESX.OneSync.SpawnVehicle(vehData.model or `ADDER`, vehData.coords or GetEntityCoords(ped), vehData.coords.w or 0.0,
		vehData.props or {}, function(id)
			if vehData.warp then
				local vehicle = NetworkGetEntityFromNetworkId(id)
				local timeout = 0
				while GetVehiclePedIsIn(ped) ~= vehicle and timeout <= 15 do
					Wait(0)
					TaskWarpPedIntoVehicle(ped, vehicle, -1)
					timeout += 1
				end
			end
			cb(id)
		end)
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if eventData.secondsRemaining == 60 then
		CreateThread(function()
			Wait(50000)
			Core.SavePlayers()
		end)
	end
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function()
	Core.SavePlayers()
end)
