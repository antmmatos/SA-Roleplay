local weaponPickups = { `PICKUP_WEAPON_CARBINERIFLE`, `PICKUP_WEAPON_PISTOL`, `PICKUP_WEAPON_PUMPSHOTGUN` }
for i = 1, #weaponPickups do
    ToggleUsePickupsForPlayer(PlayerId(), weaponPickups[i], false)
end