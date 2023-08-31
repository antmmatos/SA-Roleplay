function LogToDiscord(source, webhook, title, reason)
    local playerName = GetPlayerName(source)
    local playerHWIDs = ""
    for i = 1, GetNumPlayerTokens(source) do
        local token = GetPlayerToken(source, i)
        if token ~= nil then
            playerHWIDs = playerHWIDs .. "\n" .. token
        end
    end
    local identifiers = ExtractIdentifiers(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local embed = {
        {
            footer = {
                text = "SA Roleplay Logs | " .. os.date("%Y/%m/%d | %X") .. "",
            },
            title = "SA Roleplay Logs - " .. title,
            description =
                "**ID:** " ..
                source ..
                "**Nome:** " ..
                playerName ..
                "\n**HWID:** " ..
                playerHWIDs ..
                "\n**Steam Hex:** " ..
                identifiers.steam ..
                "\n**Discord ID:** " ..
                identifiers.discordid ..
                "\n**Discord Name:** " ..
                identifiers.discord ..
                "\n**License:** " ..
                identifiers.license ..
                "\n**License2:** " ..
                identifiers.license2 ..
                "\n**Live:** " ..
                identifiers.live ..
                "\n**Xbox:** " ..
                identifiers.xbl ..
                "\n**FiveM:** " ..
                identifiers.fivem ..
                "\n**IP:** " ..
                identifiers.ip,
            color = 524543
        }
    }
    if xPlayer then
        embed[1].description = embed[1].description .. "\n\n```Dados ESX```\n" ..
            "\n**ESX Name:** " ..
            xPlayer.getName() ..
            "\n**ESX Group:** " ..
            xPlayer.getGroup() ..
            "\n**ESX Job:** " ..
            xPlayer.getJob().label .. " - " .. xPlayer.getJob().grade_label ..
            "\n**ESX Money:** " ..
            xPlayer.getAccount("money").money ..
            "\n**ESX Bank:** " ..
            xPlayer.getAccount("bank").money
    end
    if reason then
        embed[1].description = embed[1].description .. "\n" .. reason
    end
    PerformHttpRequest(webhook, function(ERROR, DATA, RESULT)
    end, "POST", json.encode({
        embeds = embed,
        username = "SA Roleplay Logs - " .. title,
        avatar_url = "https://i.imgur.com/EbD2GWp.png"
    }), {
        ["Content-Type"] = "application/json"
    })
end

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local source = source
    LogToDiscord(source,
        "https://discord.com/api/webhooks/1146611798888427602/Rop4FxeQMkV5RQdMF6PtSeZ3nFkVQHuqYlaalO1XIWdLLIaMN5tCDxWxa8KyxzYlZIM8"
        , "Entrada", false)
    local identifiers = ExtractIdentifiers(source)
    local oldName = GetResourceKvpString("Logger:nameChanger:" .. identifiers.license)
    if oldName == nil then
        SetResourceKvp("Logger:nameChanger:" .. identifiers.license, GetPlayerName(source))
    else
        if oldName ~= GetPlayerName(source) then
            local log = "**Info:** " .. oldName .. " mudou o nome para " .. GetPlayerName(source)
            LogToDiscord(source,
                "https://discord.com/api/webhooks/1146612190808383588/2PmD8IWz90xgaD3cTLVi3Ha_IcM1nwtWLhUR401X0uG96Tneep0NQYbGp0rJYpje3u3i"
                , "Troca de Nome", log)
            SetResourceKvp("Logger:nameChanger:" .. identifiers.license, GetPlayerName(source))
        end
    end
end)

AddEventHandler("playerDropped", function(reason)
    LogToDiscord(source,
        "https://discord.com/api/webhooks/1146612153630081064/LO8fO3oZ_M1A33FQw-BlgYFoU4tHoHSQW7nNeA94ZRkVJ9zODI9h43DgvVU9-uYd3lpX"
        , "Saída (" .. (reason or "") .. ")", false)
end)

RegisterServerEvent('SA:Server:Logger:Morte')
AddEventHandler('SA:Server:Logger:Morte', function(Reason, IDKiller)
    local log
    local _source = source
    local pedCoords = GetEntityCoords(GetPlayerPed(_source))
    if IDKiller == 0 then
        log = "**Info:** " ..
            Reason or "Unknown" ..
            "**Coordenadas:** " ..
            pedCoords.x ..
            ", " ..
            pedCoords.y ..
            ", " ..
            pedCoords.z
    else
        local killerHWID = GetPlayerToken(IDKiller, 1)
        local killerIdentifiers = ExtractIdentifiers(IDKiller)
        local killerPed = GetPlayerPed(IDKiller)
        local killerCoords = GetEntityCoords(killerPed)
        local distance = #(pedCoords - killerCoords)
        log = "**Info:**" ..
            Reason or "Unknown" ..
            " (" .. distance .. "m)\n**Coordenadas:** " ..
            pedCoords.x ..
            ", " ..
            pedCoords.y ..
            ", " ..
            pedCoords.z .. "\n\n```Assassino```" ..
            "\n\n**Nome:** " ..
            GetPlayerName(IDKiller) ..
            "\n**ID do Assassino:** " ..
            IDKiller ..
            "\n**HWID:** " ..
            killerHWID ..
            "\n**Steam Hex:** " ..
            killerIdentifiers.steam ..
            "\n**Discord ID:** " ..
            killerIdentifiers.discordid ..
            "\n**Discord Name:** " ..
            killerIdentifiers.discord ..
            "\n**License:** " ..
            killerIdentifiers.license ..
            "\n**License2:** " ..
            killerIdentifiers.license2 ..
            "\n**Live:** " ..
            killerIdentifiers.live ..
            "\n**Xbox:** " ..
            killerIdentifiers.xbl ..
            "\n**FiveM:** " ..
            killerIdentifiers.fivem .. "\n**IP:** " .. killerIdentifiers.ip
    end
    LogToDiscord(source,
        "https://discord.com/api/webhooks/1146612225138753677/ZvsiXg1I-Hk_ymmtl-OsiA3kcRNpAjqvjlcZHOoxGNKxUhPNMmVumxUii9H3yEyiKups"
        , "Morte", log)
end)

RegisterServerEvent("SA:Server:Logger:Damage")
AddEventHandler("SA:Server:Logger:Damage", function()
    local iPed = GetPlayerPed(source)
    local cause = GetPedSourceOfDamage(iPed)
    local dType = GetEntityType(cause)
    local damageCause
    if dType == 0 then
        damageCause = 'próprios'
    elseif dType == 1 then
        if IsPedAPlayer(cause) then
            if GetVehiclePedIsIn(cause, false) ~= 0 then
                damageCause = GetPlayerName(getPlayerId(cause)) .. '(Veículo)'
            else
                damageCause = GetPlayerName(getPlayerId(cause))
            end
        else
            if GetVehiclePedIsIn(cause, false) ~= 0 then
                damageCause = 'AI (Veículo)'
            else
                damageCause = 'AI'
            end
        end
    elseif dType == 2 then
        driver = GetPedInVehicleSeat(cause, -1)
        if IsPedAPlayer(driver) then
            if GetPlayerName(cause) then
                damageCause = GetPlayerName(cause) .. ' com um veículo'
            else
                damageCause = 'veículo'
            end
        else
            damageCause = 'veículo'
        end
    elseif dType == 3 then
        damageCause = 'objeto'
    end
    local pedCoords = GetEntityCoords(GetPlayerPed(source))
    local log = "\n**Coordenadas:** " ..
        pedCoords.x ..
        ", " ..
        pedCoords.y ..
        ", " ..
        pedCoords.z ..
        "\n**Causa do dano:** " ..
        damageCause .. "\n**Vida do jogador:** " .. GetEntityHealth(GetPlayerPed(source))
    LogToDiscord(source,
        "https://discord.com/api/webhooks/1146612269673881721/S_jcSiWhUBsRx_TVDDDOIoNDL4jp4mXan33GM41V4dUuSoPNs9AAGDWN2k0-KIsrK4Oc"
        , "Dano", log)
end)

RegisterServerEvent("SA:Server:Logger:Tiros")
AddEventHandler("SA:Server:Logger:Tiros", function(arma, quantidadeDeTiros)
    local source = source
    local log = "**Info:** Tiros\n**Coordenadas:** " ..
        GetEntityCoords(GetPlayerPed(source)).x ..
        ", " ..
        GetEntityCoords(GetPlayerPed(source)).y ..
        ", " ..
        GetEntityCoords(GetPlayerPed(source)).z ..
        "\n**Arma:** " .. arma .. "\n**Tiros disparados:** " .. quantidadeDeTiros
    LogToDiscord(source,
        "https://discord.com/api/webhooks/1146612330772308109/7Iq6BXmPh-NeAFUfr5uQsgsOCsKbi-gOCM46hxA2259NMiyhhHnxaRxdYz2e-JFdvAUk"
        , "Tiros", log)
end)

AddEventHandler("explosionEvent", function(sender, ev)
    local source = sender
    local log = "**Info:** Explosão\n**Coordenadas:** " ..
        ev.posX ..
        ", " ..
        ev.posY ..
        ", " ..
        ev.posZ ..
        "\n**Tipo:** " ..
        ev.explosionType ..
        "\n**Dano:** " .. ev.damageScale
    LogToDiscord(source,
        "https://discord.com/api/webhooks/1146612391388401714/bQAIQ_SCS7HMTcXN8IB4H6ZsXVudzGdG1u-yVeN4Pa7a6Oa-dFIXVPGSnWvLWnS8eA-E"
        , "Explosão", log)
end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        discordid = "",
        license = "",
        license2 = "",
        xbl = "",
        live = "",
        fivem = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam:") then
            identifiers.steam = id
        elseif string.find(id, "ip:") then
            identifiers.ip = id
        elseif string.sub(id, 1, string.len("discord:")) == "discord:" then
            identifiers.discordid = string.sub(id, 9)
            identifiers.discord = "<@" .. identifiers.discordid .. ">"
        elseif string.find(id, "license:") then
            identifiers.license = id
        elseif string.find(id, "license2:") then
            identifiers.license2 = id
        elseif string.find(id, "xbl:") then
            identifiers.xbl = id
        elseif string.find(id, "live:") then
            identifiers.live = id
        elseif string.find(id, "fivem:") then
            identifiers.fivem = id
        end
    end

    return identifiers
end

function getPlayerId(ped)
    for k, v in pairs(GetPlayers()) do
        if GetPlayerPed(v) == ped then
            return v
        end
    end
end
