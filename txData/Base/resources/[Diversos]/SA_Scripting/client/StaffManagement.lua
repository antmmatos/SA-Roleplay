local isNamesOn = false
local playerList = {}

RegisterNetEvent("SA:Client:StaffManagement:SlayPlayer")
AddEventHandler("SA:Client:StaffManagement:SlayPlayer", function()
    SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent("SA:Client:StaffManagement:TPM")
AddEventHandler("SA:Client:StaffManagement:TPM", function()
    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords.x, waypointCoords.y, height + 0.0)
            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, height + 0.0)
            if foundGround then
                break
            end
            Citizen.Wait(5)
        end
    end
end)

RegisterNetEvent("SA:Client:StaffManagement:txAdmin", function(args)
    exports["monitor"]:txadmin(nil, args)
end)

RegisterNetEvent('SA:Client:StaffManagement:SpawnVehicle')
AddEventHandler('SA:Client:StaffManagement:SpawnVehicle', function(vehicle)
    if IsModelInCdimage(GetHashKey(vehicle)) then
        local ped = PlayerPedId()
        local playerCoords, playerHeading = GetEntityCoords(ped), GetEntityHeading(ped)
        ESX.Game.SpawnVehicle(vehicle, playerCoords, playerHeading, function(vehicle)
            TaskWarpPedIntoVehicle(ped, vehicle, -1)
        end)
    else
        ESX.ShowNotification("Veículo não encontrado", "error")
    end
end)

RegisterNetEvent("SA:Client:StaffManagement:PlayerMenu")
AddEventHandler("SA:Client:StaffManagement:PlayerMenu", function(playerData, group, id)
    local playerAccounts = {}
    for k, v in pairs(playerData.accounts) do
        playerAccounts[v.name] = v.money
    end
    local elements = {}
    table.insert(elements, { label = "Name: " .. playerData.firstName .. " " .. playerData.lastName, value = nil })
    table.insert(elements, { label = "Birthdate: " .. playerData.dateofbirth, value = nil })
    table.insert(elements, { label = "Height: " .. playerData.height, value = nil })
    table.insert(elements, { label = "ID: " .. id, value = nil })
    table.insert(elements, { label = "Identifier: " .. playerData.identifier, value = nil })
    table.insert(elements, { label = "Job: " .. playerData.job.label .. " (" .. playerData.job.name .. ")", value = nil })
    table.insert(elements,
        { label = "Job Grade: " .. playerData.job.grade_label .. " (" .. playerData.job.grade .. ")", value = nil })
    table.insert(elements, { label = "Bank: " .. playerAccounts["bank"], value = nil })
    table.insert(elements, { label = "Money: " .. playerAccounts["money"], value = nil })
    table.insert(elements, { label = "Black money: " .. playerAccounts["black_money"], value = nil })
    table.insert(elements, { label = "Group: " .. group, value = nil })
    table.insert(elements, { label = "Open inventory", value = "openinventory" })
    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "PlayerMenu", {
        title = "Player Menu",
        align = "top-right",
        elements = elements
    }, function(data, menu)
        if data.current.value == "openinventory" then
            ESX.TriggerServerCallback("SA:Server:StaffManagement:OpenInventory", function ()
                menu.close()
            end, id)
        end
    end, function(data, menu)
        menu.close()
    end)
end)

RegisterNetEvent("SA:Client:StaffManagement:PlateMenu")
AddEventHandler("SA:Client:StaffManagement:PlateMenu", function(data, group, id)
    local playerAccounts = {}
    for k, v in pairs(data.accounts) do
        playerAccounts[v.name] = v.money
    end
    local elements = {}
    local model = GetDisplayNameFromVehicleModel(data.model) ~= "CARNOTFOUND" and
        GetDisplayNameFromVehicleModel(data.model) or "Não encontrado"
    table.insert(elements, { label = "--------Vehicle Info--------", value = nil })
    table.insert(elements, { label = "Plate: " .. data.plate, value = nil })
    table.insert(elements, { label = "Entities found: " .. tostring(data.counter), value = nil })
    table.insert(elements, { label = "Model: " .. model, value = nil })
    table.insert(elements, { label = "", value = nil })
    table.insert(elements, { label = "--------Player Info--------", value = nil })
    table.insert(elements, { label = "Name: " .. data.firstName .. " " .. data.lastName, value = nil })
    table.insert(elements, { label = "Birthdate: " .. data.dateofbirth, value = nil })
    table.insert(elements, { label = "Height: " .. data.height, value = nil })
    table.insert(elements, { label = "ID: " .. id, value = nil })
    table.insert(elements, { label = "Identifier: " .. data.identifier, value = nil })
    table.insert(elements, { label = "Job: " .. data.job.label .. " (" .. data.job.name .. ")", value = nil })
    table.insert(elements,
        { label = "Job Grade: " .. data.job.grade_label .. " (" .. data.job.grade .. ")", value = nil })
    table.insert(elements, { label = "Bank: " .. playerAccounts["bank"], value = nil })
    table.insert(elements, { label = "Money: " .. playerAccounts["money"], value = nil })
    table.insert(elements, { label = "Black money: " .. playerAccounts["black_money"], value = nil })
    table.insert(elements, { label = "Group: " .. group, value = nil })
    table.insert(elements, { label = "Open inventory", value = "openinventory" })
    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "PlayerMenu", {
        title = "Player Menu",
        align = "top-left",
        elements = elements
    }, function(data, menu)
        if data.current.value == "openinventory" then
            ExecuteCommand("openinv " .. id)
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)
end)

RegisterNetEvent("SA:Client:StaffManagement:GiveVIPMenu")
AddEventHandler("SA:Client:StaffManagement:GiveVIPMenu", function(target, carTable)
    local elements = {}
    for i = 1, #carTable, 1 do
        table.insert(elements, { label = carTable[i].CarLabel, value = carTable[i].CarID })
    end
    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "GiveVipMenu", {
        title = "Give VIP",
        align = "top-left",
        elements = elements
    }, function(data, menu)
        ESX.Game.SpawnVehicle(data.current.value, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()),
            function(vehicle)
                TriggerServerEvent("SA:Server:StaffManagement:GiveVIP", target, ESX.Game.GetVehicleProperties(vehicle),
                    data.current.label)
                ESX.Game.DeleteVehicle(vehicle)
            end, true)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end)

RegisterClientCallback {
    eventName = 'SA:Client:StaffManagement:RequestScreenshot',
    eventCallback = function(...)
        ScreenPlayer = nil
        local promise = promise.new()
        exports['screenshot-basic']:requestScreenshotUpload("http://185.113.141.96/", 'files[]',
            { quality = 1, encoding = 'webp' }, function(data)
                resp = json.decode(data)
                ScreenPlayer = resp.files[1].url
                promise:resolve(ScreenPlayer)
            end)
        Citizen.Await(promise)
        return ScreenPlayer
    end
}

RegisterNetEvent("SA:Client:StaffManagement:Visuals", function()
    isNamesOn = not isNamesOn
    Citizen.CreateThread(function()
        while isNamesOn do
            Citizen.Wait(1)
            for i = 1, #playerList, 1 do
                local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
                local x2, y2, z2 = table.unpack(playerList[i].coords)
                DrawText3DNames(vector3(x2, y2, z2 + (0.8 + 3.5 * 0.1)),
                    "~y~" .. playerList[i].id .. "  |  ~g~" .. playerList[i].name .. "~n~~r~Health~w~: " ..
                    playerList[i].health .. " | ~b~Armor~w~: " .. playerList[i].armour)
                DrawLine(x, y, z, x2, y2, z2, 82, 5, 237, 255)
            end
        end
    end)
end)

RegisterNetEvent("SA:Client:StaffManagement:UpdatePlayerList", function(tLines)
    playerList = tLines
end)

DrawText3DNames = function(coords, text)
    local x, y, z = table.unpack(coords)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local dist = #(GetGameplayCamCoords() - vec(x, y, z))

    local scale = (4.00001 / dist) * 1
    if scale > 0.2 then
        scale = 0.2
    elseif scale < 0.15 then
        scale = 0.15
    end

    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextFont(comicSans and fontId or 4)
        SetTextScale(scale, scale)
        SetTextProportional(true)
        SetTextColour(210, 210, 210, 180)
        SetTextCentre(true)
        SetTextDropshadow(50, 210, 210, 210, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y - 0.025)
    end
end
