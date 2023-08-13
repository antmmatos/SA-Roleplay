local IS_SERVER = IsDuplicityVersion()
local table_unpack = table.unpack
local debug = debug
local debug_getinfo = debug.getinfo
local msgpack = msgpack
local msgpack_pack = msgpack.pack
local msgpack_unpack = msgpack.unpack
local msgpack_pack_args = msgpack.pack_args
local PENDING = 0
local REJECTING = 2
local REJECTED = 4

local function ensure(obj, typeof, opt_typeof, errMessage)
    local objtype = type(obj)
    local di = debug_getinfo(2)
    local errMessage = errMessage or
        (opt_typeof == nil and (di.name .. ' expected %s, but got %s') or (di.name .. ' expected %s or %s, but got %s'))
    if typeof ~= 'function' then
        if objtype ~= typeof and objtype ~= opt_typeof then
            error((errMessage):format(typeof, (opt_typeof == nil and objtype or opt_typeof), objtype))
        end
    else
        if objtype == 'table' and not rawget(obj, '__cfx_functionReference') then
            error((errMessage):format(typeof, (opt_typeof == nil and objtype or opt_typeof), objtype))
        end
    end
end

if IS_SERVER then
    _G.RegisterServerCallback = function(args)
        ensure(args, 'table');
        ensure(args.eventName, 'string');
        ensure(args.eventCallback, 'function')
        local eventCallback = args.eventCallback
        local eventName = args.eventName
        local eventData = RegisterNetEvent('SA__server_callback:' .. eventName, function(packed, src, cb)
            local source = tonumber(source)
            if not source then
                cb(msgpack_pack_args(eventCallback(src, table_unpack(msgpack_unpack(packed)))))
            else
                TriggerClientEvent(('SA__client_callback_response:%s:%s'):format(eventName, source), source,
                    msgpack_pack_args(eventCallback(source, table_unpack(msgpack_unpack(packed)))))
            end
        end)
        return eventData
    end
    _G.UnregisterServerCallback = function(eventData)
        RemoveEventHandler(eventData)
    end
    _G.TriggerClientCallback = function(args)
        ensure(args, 'table');
        ensure(args.source, 'string', 'number');
        ensure(args.eventName, 'string');
        ensure(args.args, 'table', 'nil');
        ensure(args.timeout, 'number', 'nil');
        ensure(args.timedout, 'function', 'nil');
        ensure(args.callback, 'function', 'nil')
        if tonumber(args.source) >= 0 then
            local ticket = tostring(args.source) .. 'x' .. tostring(GetGameTimer())
            local prom = promise.new()
            local eventCallback = args.callback
            local eventData = RegisterNetEvent(
                ('SA__callback_retval:%s:%s:%s'):format(args.source, args.eventName, ticket), function(packed)
                    if eventCallback and prom.state == PENDING then eventCallback(table_unpack(msgpack_unpack(packed))) end
                    prom:resolve(table_unpack(msgpack_unpack(packed)))
                end)
            TriggerClientEvent(('SA__client_callback:%s'):format(args.eventName), args.source,
                msgpack_pack(args.args or {}), ticket)
            if args.timeout ~= nil and args.timedout then
                local timedout = args.timedout
                SetTimeout(args.timeout * 1000, function()
                    if
                        prom.state == PENDING or
                        prom.state == REJECTED or
                        prom.state == REJECTING
                    then
                        timedout(prom.state)
                        if prom.state == PENDING then prom:reject() end
                        RemoveEventHandler(eventData)
                    end
                end)
            end
            if not eventCallback then
                local result = Citizen.Await(prom)
                RemoveEventHandler(eventData)
                return result
            end
        else
            error 'source should be equal too or higher than 0'
        end
    end
    _G.TriggerServerCallback = function(args)
        ensure(args, 'table');
        ensure(args.source, 'string', 'number');
        ensure(args.eventName, 'string');
        ensure(args.args, 'table', 'nil');
        ensure(args.timeout, 'number', 'nil');
        ensure(args.timedout, 'function', 'nil');
        ensure(args.callback, 'function', 'nil')
        local prom = promise.new()
        local eventCallback = args.callback
        local eventName = args.eventName
        TriggerEvent('SA__server_callback:' .. eventName, msgpack_pack(args.args or {}), args.source,
            function(packed)
                if eventCallback and prom.state == PENDING then eventCallback(table_unpack(msgpack_unpack(packed))) end
                prom:resolve(table_unpack(msgpack_unpack(packed)))
            end)

        if args.timeout ~= nil and args.timedout then
            local timedout = args.timedout
            SetTimeout(args.timeout * 1000, function()
                if
                    prom.state == PENDING or
                    prom.state == REJECTED or
                    prom.state == REJECTING
                then
                    timedout(prom.state)
                    if prom.state == PENDING then prom:reject() end
                end
            end)
        end
        if not eventCallback then
            return Citizen.Await(prom)
        end
    end
end


if not IS_SERVER then
    local SERVER_ID = GetPlayerServerId(PlayerId())
    _G.RegisterClientCallback = function(args)
        ensure(args, 'table');
        ensure(args.eventName, 'string');
        ensure(args.eventCallback, 'function')
        local eventCallback = args.eventCallback
        local eventName = args.eventName
        local eventData = RegisterNetEvent('SA__client_callback:' .. eventName, function(packed, ticket)
            if type(ticket) == 'function' then
                ticket(msgpack_pack_args(eventCallback(table_unpack(msgpack_unpack(packed)))))
            else
                TriggerServerEvent(('SA__callback_retval:%s:%s:%s'):format(SERVER_ID, eventName, ticket),
                    msgpack_pack_args(eventCallback(table_unpack(msgpack_unpack(packed)))))
            end
        end)
        return eventData
    end
    _G.UnregisterClientCallback = function(eventData)
        RemoveEventHandler(eventData)
    end
    _G.TriggerServerCallback = function(args)
        ensure(args, 'table');
        ensure(args.args, 'table', 'nil');
        ensure(args.eventName, 'string');
        ensure(args.timeout, 'number', 'nil');
        ensure(args.timedout, 'function', 'nil');
        ensure(args.callback, 'function', 'nil')
        local prom = promise.new()
        local eventCallback = args.callback
        local eventData = RegisterNetEvent(
            ('SA__client_callback_response:%s:%s'):format(args.eventName, SERVER_ID),
            function(packed)
                if eventCallback and prom.state == PENDING then eventCallback(table_unpack(msgpack_unpack(packed))) end
                prom:resolve(table_unpack(msgpack_unpack(packed)))
            end)
        TriggerServerEvent('SA__server_callback:' .. args.eventName, msgpack_pack(args.args))
        if args.timeout ~= nil and args.timedout then
            local timedout = args.timedout
            SetTimeout(args.timeout * 1000, function()
                if
                    prom.state == PENDING or
                    prom.state == REJECTED or
                    prom.state == REJECTING
                then
                    timedout(prom.state)
                    if prom.state == PENDING then prom:reject() end
                    RemoveEventHandler(eventData)
                end
            end)
        end
        if not eventCallback then
            local result = Citizen.Await(prom)
            RemoveEventHandler(eventData)
            return result
        end
    end
    _G.TriggerClientCallback = function(args)
        ensure(args, 'table');
        ensure(args.eventName, 'string');
        ensure(args.args, 'table', 'nil');
        ensure(args.timeout, 'number', 'nil');
        ensure(args.timedout, 'function', 'nil');
        ensure(args.callback, 'function', 'nil')
        local prom = promise.new()
        local eventCallback = args.callback
        local eventName = args.eventName
        TriggerEvent('SA__client_callback:' .. eventName, msgpack_pack(args.args or {}),
            function(packed)
                if eventCallback and prom.state == PENDING then eventCallback(table_unpack(msgpack_unpack(packed))) end
                prom:resolve(table_unpack(msgpack_unpack(packed)))
            end)
        if args.timeout ~= nil and args.timedout then
            local timedout = args.timedout
            SetTimeout(args.timeout * 1000, function()
                if
                    prom.state == PENDING or
                    prom.state == REJECTED or
                    prom.state == REJECTING
                then
                    timedout(prom.state)
                    if prom.state == PENDING then prom:reject() end
                end
            end)
        end
        if not eventCallback then
            return Citizen.Await(prom)
        end
    end
end
