Citizen.CreateThread(function()
    local ped
    local id
    while true do
        id = PlayerId()
        SetPlayerHealthRechargeMultiplier(id, 0.0)
        DisablePlayerVehicleRewards(id)
        Wait(5)
    end
end)
