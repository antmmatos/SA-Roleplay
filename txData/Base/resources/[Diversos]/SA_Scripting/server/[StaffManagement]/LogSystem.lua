AddEventHandler("SA:Server:StaffManagement:LogSystem", function(commandExecuted, playerId)
    if playerId == 0 then return end
    local log = "**Info:**\n\tComando: " .. commandExecuted
    exports["SA_Scripting"]:LogToDiscord(playerId,
        "https://discord.com/api/webhooks/1146622048521691197/EqbrBL9UtejvqrNJ3CV3wQ4WPL3IIE2Ax0Y9xdCCgd4I1bioAfCZBGUHdiDn4ez5njAS"
        , "Comandos Staff", log)
end)

AddEventHandler("SA:Server:StaffManagement:txAdmin:LogSystem", function(playerId, commandExecuted)
    if playerId == 0 then return end
    local log = "**Info:**\n\t" .. GetPlayerName(playerId) .. " executou a ação: " .. commandExecuted
    exports["SA_Scripting"]:LogToDiscord(playerId,
        "https://discord.com/api/webhooks/1146622109800468601/buS7Gu3QanDyTGxJjh2_0MODfM7dS9YI8Ke63Uzwfld7u-TCdMLn9I9gYCFYR27CeGjc"
        , "txAdmin", log)
end)
