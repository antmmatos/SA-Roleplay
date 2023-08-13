AddEventHandler("Natural:Server:StaffManagement:LogSystem", function(commandExecuted, playerId)
    if playerId == 0 then return end
    local log = "**Info:**\n\tComando: " .. commandExecuted
    exports["NaturalScripting"]:LogToDiscord(playerId,
        "https://discord.com/api/webhooks/1107320380894494750/PkUfLszGNXml97t9m3WQNeu07OBZcH5f09RbIeCfKmeq3gPLy5ghlHSUKHU8tm29_4eh"
        , "Comandos Staff", log)
end)

AddEventHandler("Natural:Server:StaffManagement:txAdmin:LogSystem", function(playerId, commandExecuted)
    if playerId == 0 then return end
    local log = "**Info:**\n\t[" .. playerId ..
        "] " .. GetPlayerName(playerId) .. " executou a ação: " .. commandExecuted
    exports["NaturalScripting"]:LogToDiscord(playerId,
        "https://discord.com/api/webhooks/1107323088699412611/YMAQvVr0J7QEGGJc7KH-EvstI2alCVjQdGyKqbkYdd1eTuS2d_0q9D-hBaU7AjBZOqQt"
        , "txAdmin", log)
end)
