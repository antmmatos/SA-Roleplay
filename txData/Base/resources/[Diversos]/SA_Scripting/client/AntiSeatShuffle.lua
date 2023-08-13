Citizen.CreateThread(function()
    local ped
    local vehicle
    local seat
    while true do
        Citizen.Wait(0)
        ped = PlayerPedId()
        vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= nil and vehicle ~= 0 then
            local driver = GetPedInVehicleSeat(vehicle, -1)
            SetPedConfigFlag(ped, 184, true)
            if GetIsTaskActive(ped, 165) then
                seat = 0
                if driver == ped then
                    seat = -1
                end
                SetPedIntoVehicle(ped, vehicle, seat)
            else
                Citizen.Wait(100)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)
