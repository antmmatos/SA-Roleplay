local savedCoords = {}
local allAdmins = {}
local staffTag = {}
local visuals = {}

local groupList = {
    ["user"] = { label = "User", level = 0 },
    ["estagiario"] = { label = "Estagiário", level = 1 },
    ["suporte"] = { label = "Suporte", level = 2 },
    ["staff"] = { label = "Staff", level = 3 },
    ["admin"] = { label = "Administrador", level = 4 },
    ["owner"] = { label = "Fundador", level = 5 },
}

AddEventHandler("esx:playerLoaded", function(playerId)
    TriggerClientEvent("Natural:Client:StaffManagement:UpdateTag", playerId, staffTag)
end)

function isAllowedTo(source, group)
    if source == 0 then return true end
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local playerGroup = xPlayer.getGroup()
    local playerLevel = groupList[playerGroup].level
    local targetLevel = groupList[group].level

    if (allAdmins[source] and targetLevel <= playerLevel) or playerLevel >= 4 then
        return true
    else
        if playerLevel >= targetLevel and not allAdmins[source] then
            TriggerClientEvent("esx:showNotification", source,
                "É necessário ter o modo admin ligado para utilizar este comando.", "warning")
        else
            TriggerClientEvent("esx:showNotification", source,
                "Este comando está autorizado apenas para " .. groupList[group].label .. " ou superior.",
                "warning")
        end
        return false
    end
end

RegisterCommand("admin", function(source, args, raw)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    local playerLevel = groupList[playerGroup].level
    TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
    if playerLevel >= 4 then
        TriggerClientEvent("esx:showNotification", source,
            "Não é necessário entrar em modo admin com o cargo " .. groupList[playerGroup].label .. ".", "error")
        return
    elseif playerLevel >= 1 then
        if (allAdmins[source]) then
            allAdmins[source] = false
            TriggerClientEvent("esx:showNotification", -1, GetPlayerName(source) .. " saiu do modo admin.",
                "success")
            staffTag[source] = nil
        else
            allAdmins[source] = true
            TriggerClientEvent("esx:showNotification", -1, GetPlayerName(source) .. " entrou em modo admin.",
                "success")
            staffTag[source] = "~b~STAFF"
        end
        TriggerClientEvent("Natural:Client:StaffManagement:UpdateTag", -1, staffTag)
    else
        TriggerClientEvent("esx:showNotification", source,
            "Este comando está autorizado apenas para Estagiário ou superior.", "error")
    end
end, false)

RegisterCommand("slay", function(source, args, raw)
    if isAllowedTo(source, "estagiario") then
        if args[1] and tonumber(args[1]) then
            local targetId = tonumber(args[1])
            TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
            TriggerClientEvent("Natural:Client:StaffManagement:SlayPlayer", targetId)
        end
    end
end, false)

RegisterCommand("tpm", function(source, args, raw)
    if isAllowedTo(source, "estagiario") then
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
        TriggerClientEvent("Natural:Client:StaffManagement:TPM", source)
    end
end, false)

RegisterCommand("bring", function(source, args, raw)
    if isAllowedTo(source, "estagiario") then
        if args[1] and tonumber(args[1]) then
            local xPlayer = ESX.GetPlayerFromId(source)
            local xTarget = ESX.GetPlayerFromId(tonumber(args[1]))
            if xTarget then
                local targetCoords = xTarget.getCoords()
                local playerCoords = xPlayer.getCoords()
                savedCoords[tonumber(args[1])] = targetCoords
                xTarget.setCoords(playerCoords)
                TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
            end
        end
    end
end, false)

RegisterCommand("bringback", function(source, args, raw)
    if isAllowedTo(source, "estagiario") then
        if args[1] and tonumber(args[1]) then
            local targetId = tonumber(args[1])
            local xTarget = ESX.GetPlayerFromId(targetId)
            local playerCoords = savedCoords[targetId]
            if playerCoords then
                xTarget.setCoords(playerCoords)
                savedCoords[targetId] = nil
            end
            TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
        end
    end
end, false)

RegisterCommand("goto", function(source, args, raw)
    if isAllowedTo(source, "estagiario") then
        if args[1] and tonumber(args[1]) then
            local xPlayer = ESX.GetPlayerFromId(source)
            local xTarget = ESX.GetPlayerFromId(tonumber(args[1]))
            if xTarget then
                local targetCoords = xTarget.getCoords()
                local playerCoords = xPlayer.getCoords()
                savedCoords[source] = playerCoords
                xPlayer.setCoords(targetCoords)
            end
        end
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
    end
end, false)

RegisterCommand("goback", function(source, args, raw)
    if isAllowedTo(source, "estagiario") then
        local playerCoords = savedCoords[source]
        if playerCoords then
            local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.setCoords(playerCoords)
            savedCoords[source] = nil
        end
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
    end
end, false)

RegisterCommand("dv", function(source, args, raw)
    if isAllowedTo(source, "estagiario") then
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)
        if vehicle ~= 0 then
            DeleteEntity(vehicle)
        else
            local xPlayer = ESX.GetPlayerFromId(source)
            local Vehicles = ESX.OneSync.GetVehiclesInArea(xPlayer.getCoords(true), tonumber(args[1]) or 5)
            for i = 1, #Vehicles do
                local Vehicle = NetworkGetEntityFromNetworkId(Vehicles[i])
                if DoesEntityExist(Vehicle) then
                    DeleteEntity(Vehicle)
                end
            end
        end
    end
end, false)

RegisterCommand("car", function(source, args, raw)
    if isAllowedTo(source, "admin") then
        if args[1] then
            local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.triggerEvent('Natural:Client:StaffManagement:SpawnVehicle', args[1])
            TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
        end
    end
end, false)

RegisterCommand("setjob", function(source, args, raw)
    if isAllowedTo(source, "suporte") then
        if args[1] and tonumber(args[1]) and args[2] and args[3] and tonumber(args[3]) then
            local xTarget = ESX.GetPlayerFromId(args[1])
            if xTarget then
                if ESX.DoesJobExist(args[2], args[3]) then
                    xTarget.setJob(args[2], args[3])
                    TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
                end
            end
        end
    end
end, false)

RegisterCommand("tp", function(source, args, raw)
    if isAllowedTo(source, "admin") then
        if args[1] and tonumber(args[1]) and args[2] and tonumber(args[2]) and args[3] and tonumber(args[3]) then
            if tonumber(args[1]) and tonumber(args[2]) and tonumber(args[3]) then
                local xPlayer = ESX.GetPlayerFromId(source)
                xPlayer.setCoords({
                    x = tonumber(args[1]),
                    y = tonumber(args[2]),
                    z = tonumber(args[3])
                })
                TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
            end
        end
    end
end, false)

RegisterCommand("skin", function(source, args, raw)
    if isAllowedTo(source, "staff") then
        if args[1] and tonumber(args[1]) then
            TriggerClientEvent("esx_skin:openSaveableMenu", tonumber(args[1]))
        else
            TriggerClientEvent("esx_skin:openSaveableMenu", source)
        end
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
    end
end, false)

RegisterCommand("heal", function(source, args, raw)
    if isAllowedTo(source, "estagiario") then
        if args[1] and tonumber(args[1]) then
            local xPlayerArgs = ESX.GetPlayerFromId(args[1])
            if xPlayerArgs then
                xPlayerArgs.triggerEvent("esx_status:set", "hunger", 1000000)
                xPlayerArgs.triggerEvent("esx_status:set", "thirst", 1000000)
                xPlayerArgs.triggerEvent("esx_status:set", "stress", 0)
            end
        else
            local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.triggerEvent("esx_status:set", "hunger", 1000000)
            xPlayer.triggerEvent("esx_status:set", "thirst", 1000000)
            xPlayer.triggerEvent("esx_status:set", "stress", 0)
        end
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
    end
end, false)

RegisterCommand("revive", function(source, args, raw)
    if isAllowedTo(source, "estagiario") then
        if args[1] and tonumber(args[1]) then
            if GetPlayerName(tonumber(args[1])) ~= nil then
                TriggerClientEvent("esx_ambulancejob:revive", tonumber(args[1]))
            end
        else
            TriggerClientEvent("esx_ambulancejob:revive", source)
        end
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
    end
end, false)

RegisterCommand('giveaccountmoney', function(source, args, raw)
    if isAllowedTo(source, "admin") then
        if args[1] and tonumber(args[1]) and args[2] and args[3] and tonumber(args[3]) then
            local xTarget = ESX.GetPlayerFromId(args[1])
            if xTarget then
                if xTarget.getAccount(args[2]) then
                    xTarget.addAccountMoney(args[2], tonumber(args[3]))
                    TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
                else
                    TriggerClientEvent('esx:showNotification', source,
                        "Conta inválida", "error")
                end
            end
        end
    end
end)

RegisterCommand('giveitem', function(source, args, raw)
    if isAllowedTo(source, "admin") then
        if args[1] and tonumber(args[1]) and args[2] and args[3] and tonumber(args[3]) then
            local xPlayer = ESX.GetPlayerFromId(args[1])
            if xPlayer then
                if xPlayer.canCarryItem(args[2], tonumber(args[3])) then
                    xPlayer.addInventoryItem(args[2], args[3])
                    TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
                else
                    TriggerClientEvent('esx:showNotification', source,
                        "O jogador tem o inventário cheio", "error")
                end
            end
        end
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
    end
end)

RegisterCommand('giveweapon', function(source, args, raw)
    if isAllowedTo(source, "admin") then
        if args[1] and tonumber(args[1]) and args[2] and args[3] and tonumber(args[3]) then
            local xPlayer = ESX.GetPlayerFromId(args[1])
            if xPlayer then
                if not xPlayer.hasWeapon(args[2]) then
                    xPlayer.addWeapon(args[2], tonumber(args[3]))
                    TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
                else
                    TriggerClientEvent('esx:showNotification', source,
                        "O jogador já tem essa arma", "error")
                end
            end
        end
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
    end
end)

RegisterCommand("clear", function(source, args, raw)
    TriggerClientEvent('chat:client:ClearChat', source)
end)

RegisterCommand('clearall', function(source, args, raw)
    if isAllowedTo(source, "staff") then
        TriggerClientEvent('chat:client:ClearChat', -1)
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
    end
end)

RegisterCommand("refreshjobs", function(source, args, raw)
    if isAllowedTo(source, "admin") then
        ESX.RefreshJobs()
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
    end
end)

RegisterCommand('clearinventory', function(source, args, raw)
    if isAllowedTo(source, "staff") then
        if not args[1] or not tonumber(args[1]) then return end
        local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
        if not xPlayer then return end
        for k, v in ipairs(xPlayer.inventory) do
            if v.count > 0 then
                xPlayer.setInventoryItem(v.name, 0)
            end
        end
        TriggerEvent('esx:playerInventoryCleared', xPlayer)
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
    end
end)

RegisterCommand('setgroup', function(source, args, raw)
    if isAllowedTo(source, "admin") then
        local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
        if not xPlayer then return end
        xPlayer.setGroup(args[2])
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
    end
end)

RegisterCommand("tx", function(source, args, raw)
    if isAllowedTo(source, "estagiario") then
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
        TriggerClientEvent("Natural:Client:StaffManagement:txAdmin", source, args)
    end
end)

RegisterCommand('givevip', function(source, args, raw)
    if isAllowedTo(source, "admin") and tonumber(args[1]) then
        MySQL.query("SELECT * FROM vipcars", {}, function(result)
            TriggerClientEvent("Natural:Client:StaffManagement:GiveVIPMenu", source, tonumber(args[1]), result)
            TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
        end)
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
    end
end)

RegisterCommand('adminlist', function(source, args, raw)
    if allAdmins == nil then
        TriggerClientEvent("esx:showNotification", source, "Não há ninguém em modo admin.")
        return
    end
    local list = ""
    if isAllowedTo(source, "admin") then
        for k, v in pairs(allAdmins) do
            if v == true then
                list = list .. ", " .. GetPlayerName(k)
            end
        end
        if list ~= "" then
            TriggerClientEvent("esx:showNotification", source,
                "Os staffs que estão em modo admin são" .. list .. ".")
        else
            TriggerClientEvent("esx:showNotification", source, "Não há ninguém em modo admin.")
        end
    end
end)

RegisterCommand('player', function(source, args, raw)
    if isAllowedTo(source, "suporte") then
        local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
        if not xPlayer then return end
        TriggerClientEvent("Natural:Client:StaffManagement:PlayerMenu", source, {
            accounts = xPlayer.getAccounts(),
            identifier = xPlayer.getIdentifier(),
            job = xPlayer.getJob(),
            sex = xPlayer.get("sex") or "m",
            firstName = xPlayer.get("firstName") or "John",
            lastName = xPlayer.get("lastName") or "Doe",
            dateofbirth = xPlayer.get("dateofbirth") or "01/01/2000",
            height = xPlayer.get("height") or 120
        }, xPlayer.getGroup(), args[1])
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
    end
end)

RegisterCommand('plate', function(source, args, raw)
    if isAllowedTo(source, "suporte") then
        MySQL.query("SELECT * FROM owned_vehicles WHERE plate = ?", { args[1] }, function(result)
            if result[1] then
                local xPlayer = ESX.GetPlayerFromIdentifier(result[1].owner)
                local vehicles = GetAllVehicles()
                local plate = args[1]
                local vehicle = "Não encontrado"
                local counter = 0
                for k, v in pairs(vehicles) do
                    if plate:gsub(" ", "") == GetVehicleNumberPlateText(v):gsub(" ", "") then
                        vehicle = v
                        counter = counter + 1
                    end
                end
                if xPlayer then
                    TriggerClientEvent("Natural:Client:StaffManagement:PlateMenu", source, {
                        model = DoesEntityExist(vehicle) and GetEntityModel(vehicle) or "Não encontrado",
                        counter = counter,
                        plate = result[1].plate,
                        accounts = xPlayer.getAccounts(),
                        identifier = xPlayer.getIdentifier(),
                        job = xPlayer.getJob(),
                        sex = xPlayer.get("sex") or "m",
                        firstName = xPlayer.get("firstName") or "John",
                        lastName = xPlayer.get("lastName") or "Doe",
                        dateofbirth = xPlayer.get("dateofbirth") or "01/01/2000",
                        height = xPlayer.get("height") or 120
                    }, xPlayer.getGroup(), xPlayer.source)
                else
                    MySQL.query("SELECT * FROM users WHERE identifier = ?", { result[1].owner }, function(result2)
                        TriggerClientEvent("Natural:Client:StaffManagement:PlateMenu", source, {
                            model = DoesEntityExist(vehicle) and GetEntityModel(vehicle) or "Não encontrado",
                            counter = counter,
                            plate = result2[1].plate,
                            accounts = json.decode(result2.accounts),
                            identifier = result[1].owner,
                            job = {
                                name = result2.job,
                                label = "Não encontrado",
                                grade = result2.job_grade,
                                grade_label = "Não encontrado",
                            },
                            sex = result2.sex or "Não encontrado",
                            firstName = result2.firstname or "Não encontrado",
                            lastName = result2.lastname or "Não encontrado",
                            dateofbirth = result2.dateofbirth or "Não encontrado",
                            height = result2.height or "Não encontrado"
                        }, xPlayer.getGroup(), "Offline")
                    end)
                end
            else
                TriggerClientEvent("esx:showNotification", source,
                    "Não foi encontrado nenhum veículo com essa matrícula",
                    "error")
            end
        end)
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
    end
end)

RegisterServerEvent("Natural:Server:StaffManagement:GiveVIP")
AddEventHandler("Natural:Server:StaffManagement:GiveVIP", function(target, carro, label)
    local _source = source
    if isAllowedTo(_source, "admin") then
        local xPlayer = ESX.GetPlayerFromId(_source)
        local xTarget = ESX.GetPlayerFromId(target)
        MySQL.query(
            "INSERT INTO owned_vehicles (owner, plate, vehicle, type, parking, stored, impoundTime, location) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
            , {
                xTarget.identifier,
                carro.plate,
                json.encode(carro),
                "car",
                "legion",
                1,
                "",
                ""
            }, function(result)
                TriggerClientEvent("esx:showNotification", xTarget.source,
                    "Recebeste um carro VIP: " .. label, "success")
                TriggerClientEvent("esx:showNotification", xPlayer.source,
                    "Deste um carro VIP (" .. label .. ") ao " .. xTarget.name, "success")
                exports["NaturalScripting"]:LogToDiscord(_source,
                    "https://discord.com/api/webhooks/1107320590139936918/db4mW3vbFgwdFqRhEeuXS9M8x0V3JM5nxjPqk98xHcZ5UcdoaP-k34SME1VAyyTrZ7Gm"
                    , "Carro VIP",
                    "**Info: ** O jogador " ..
                    xPlayer.name ..
                    " (" ..
                    xPlayer.identifier ..
                    ") deu um carro VIP (" .. label .. ") ao " .. xTarget.name .. " (" .. xTarget.identifier .. ")")
            end)
    end
end)

RegisterCommand("tag", function(source, args, raw)
    local _source = source
    if isAllowedTo(_source, "admin") then
        if staffTag[_source] then
            staffTag[_source] = nil
            TriggerClientEvent("Natural:Client:StaffManagement:UpdateTag", -1, staffTag)
            return
        end
        if not args[1] then
            local xPlayer = ESX.GetPlayerFromId(_source)
            if xPlayer.getGroup() == "admin" then
                staffTag[_source] = "~r~ADMINISTRADOR"
            elseif xPlayer.getGroup() == "owner" then
                staffTag[_source] = "~y~Fundador"
            end
        else
            if args[1] == "admin" then
                staffTag[_source] = "~r~ADMINISTRADOR"
            elseif args[1] == "owner" then
                staffTag[_source] = "~y~Fundador"
            end
        end
        TriggerEvent("Natural:Server:StaffManagement:LogSystem", raw, source)
        TriggerClientEvent("Natural:Client:StaffManagement:UpdateTag", -1, staffTag)
    end
end)

RegisterCommand('clsveh', function(source, args, raw)
    if not isAllowedTo(source, "staff") then return end
    for _, v in pairs(GetAllVehicles()) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end
end)

RegisterCommand('clspeds', function(source, args, raw)
    if not isAllowedTo(source, "staff") then return end
    for _, v in pairs(GetAllPeds()) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end
end)

RegisterCommand('clsobj', function(source, args, raw)
    if not isAllowedTo(source, "staff") then return end
    for _, v in pairs(GetAllObjects()) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end
end)

RegisterCommand("print", function(source, args, rawCommand)
    local _source = source
    if not args[1] then
        return
    end
    if not isAllowedTo(_source, "admin") then
        return
    end
    if source ~= 0 then
        local screenshot = TriggerClientCallback {
            source = tonumber(args[1]),
            eventName = 'Natural:Client:StaffManagement:RequestScreenshot'
        }
        ScreenshotCommand(screenshot, _source, args[1])
    else
        local screenshot = TriggerClientCallback {
            source = tonumber(args[1]),
            eventName = 'Natural:Client:StaffManagement:RequestScreenshot'
        }
        ScreenshotCommand(screenshot, "Console", args[1])
    end
end)

function ScreenshotCommand(link, source, player)
    local message
    if source == "Console" then
        message = "Screenshot from Player " .. GetPlayerName(player) ..
            " with ID: " .. player .. " requested by Console."
    else
        message = "Screenshot from Player " .. GetPlayerName(player) ..
            " with ID: " .. player .. " requested by " .. GetPlayerName(source) .. " with ID: " .. source ..
            "."
    end
    local logembed = { {
        color = "15536915",
        title = "**StaffManagement**",
        description = message,
        image = {
            url = link
        },
        footer = {
            text = "Natural Roleplay | " .. os.date("%Y/%m/%d %X")
        }
    } }
    PerformHttpRequest(
        "https://discord.com/api/webhooks/1107321306925514873/hCNWgugXonE_WhbZMc6hLc_ZIdoz8oDVx7eEil7wihOyXM-l-bWk8FcQRQwQb4UGF04Y",
        function(err, text, headers)
        end, 'POST', json.encode({
            username = "Natural Roleplay | Screenshot Requests",
            embeds = logembed
        }), {
            ['Content-Type'] = 'application/json'
        })
end

RegisterCommand("visuals", function(source, args, rawCommand)
    if isAllowedTo(source, "estagiario") then
        if not visuals[source] then
            visuals[source] = true
            TriggerClientEvent("Natural:Client:StaffManagement:Visuals", source)
            Citizen.CreateThread(function()
                while visuals[source] do
                    Citizen.Wait(500)
                    local allPlayers = {}
                    for k, v in pairs(GetPlayers()) do
                        if tonumber(v) ~= tonumber(source) then
                            local ped = GetPlayerPed(v)
                            table.insert(allPlayers,
                                {
                                    coords = GetEntityCoords(ped),
                                    name = GetPlayerName(v),
                                    id = v,
                                    health = GetEntityHealth(ped),
                                    armour = GetPedArmour(ped)
                                })
                        end
                    end
                    TriggerClientEvent("Natural:Client:StaffManagement:UpdatePlayerList", source, allPlayers)
                end
            end)
        else
            visuals[source] = false
            TriggerClientEvent("Natural:Client:StaffManagement:Visuals", source)
        end
    end
end)
