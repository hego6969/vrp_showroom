--[[
    FiveM Scripts
    Copyright C 2018  Sighmir
    Converted to oxmysql by ChatGPT
]]

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_showroom")
Gclient = Tunnel.getInterface("vRP_garages","vRP_showroom")

local cfg = module("vrp_showroom","cfg/showroom")
local vehgarage = cfg


local function format_thousand(amount)
    local formatted = tostring(amount)
    local k
    while true do
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", '%1.%2')
        if k == 0 then break end
    end
    return formatted
end


CreateThread(function()
    MySQL.query.await([[
        ALTER TABLE vrp_user_vehicles ADD IF NOT EXISTS veh_type varchar(255) NOT NULL DEFAULT 'default'
    ]])
    MySQL.query.await([[
        ALTER TABLE vrp_user_vehicles ADD IF NOT EXISTS vehicle_plate varchar(255) NOT NULL
    ]])
end)


local function addCustomVehicle(user_id, vehicle, plate, veh_type)
    MySQL.insert.await(
        'INSERT IGNORE INTO vrp_user_vehicles(user_id, vehicle, vehicle_plate, veh_type) VALUES (?, ?, ?, ?)',
        { user_id, vehicle, plate, veh_type }
    )
end


function getPrice(category, model)
    for i,v in ipairs(vehshop.menu[category].buttons) do
        if v.model == model then
            return v.costs
        end
    end
    return nil
end

RegisterServerEvent('veh_SR:CheckMoneyForVeh')
AddEventHandler('veh_SR:CheckMoneyForVeh', function(category, vehicle, price, veh_type, isXZ, isDM)
    local user_id = tonumber(vRP.getUserId({source}))
    local player = vRP.getUserSource({user_id})

    local pvehicle = MySQL.query.await(
        'SELECT * FROM vrp_user_vehicles WHERE user_id = ? AND vehicle = ?',
        { user_id, vehicle }
    )

    if #pvehicle > 0 then
        TriggerClientEvent('mythic_notify:client:SendAlert', player, { type = 'error', text = 'Du ejer allerede dette køretøj!' })
    else
        local actual_price = getPrice(category, vehicle)
        if actual_price == nil then
            print("Vehicle "..vehicle.." from the category "..category.." doesn't have a price set in cfg/showroom.lua")
            TriggerClientEvent('mythic_notify:client:SendAlert', player, { type = 'error', text = 'Dette køretøj er ikke på lager!' })
            return
        end
        if actual_price ~= price then
            print("Player with ID "..user_id.." is suspected of Cheat Engine.")
        end	

        if vRP.tryFullPayment({user_id, actual_price}) then
            vRP.getUserIdentity({user_id, function(identity)
                addCustomVehicle(user_id, vehicle, "P "..identity.registration, veh_type)
            end})
            TriggerClientEvent('veh_SR:CloseMenu', player)
            TriggerClientEvent('mythic_notify:client:SendAlert', player, { type = 'success', text = 'Du købte køretøjet!' })
            TriggerClientEvent('mythic_notify:client:SendAlert', player, { type = 'inform', text = 'Find køretøjet i din garage!' })

            PerformHttpRequest(
                'https://discordapp.com/api/webhooks/706489384282751089/ytynfcAu_dTc_E0wfSvYUOSdaG9rNyIdzVrVnSuLA17wtPnR4qG4XtDzGTCKOnePBggX',
                function(err, text, headers) end, 'POST',
                json.encode({
                    username = "Server "..GetConvar("servernumber", "0").." - Showroom",
                    content = "**"..user_id.."** har lige købt en **"..vehicle.."** for: **"..format_thousand(actual_price).."**"
                }),
                { ['Content-Type'] = 'application/json' }
            )
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', player, { type = 'error', text = 'Du har ikke penge nok!' })
        end
    end
end)

RegisterServerEvent('veh_SR:CheckMoneyForBasicVeh')
AddEventHandler('veh_SR:CheckMoneyForBasicVeh', function(user_id, vehicle, price ,veh_type)
    local player = vRP.getUserSource({user_id})

    local pvehicle = MySQL.query.await(
        'SELECT * FROM vrp_user_vehicles WHERE user_id = ? AND vehicle = ?',
        { user_id, vehicle }
    )

    if #pvehicle > 0 then
        TriggerClientEvent('mythic_notify:client:SendAlert', player, { type = 'error', text = 'Du ejer allerede dette køretøj!' })
        vRP.giveMoney({user_id, price})
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', player, { type = 'success', text = 'Du købte køretøjet!' })
        vRP.getUserIdentity({user_id, function(identity)
            addCustomVehicle(user_id, vehicle, "P "..identity.registration, veh_type)
        end})
        Gclient.spawnBoughtVehicle(player,{veh_type, vehicle})
    end
end)