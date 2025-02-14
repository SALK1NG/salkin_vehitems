if Config.Settings.Framework == "ESX" then 
    for k,v in pairs(Config.Items) do
        ESX.RegisterUsableItem(k, function(source)
            local src = source
            local xPlayer = ESX.GetPlayerFromId(src)
            xPlayer.removeInventoryItem(k, 1)
            TriggerClientEvent('salkin_vehitems:spawnvehicle',src,v)
            return
        end)
    end
end

RegisterNetEvent('salkin_vehitems:returnitem',function(data)
    local src = source
    if Config.Settings.Framework == "ESX" then 
        for k, v in pairs(Config.Items) do
            if v == data then
                item = k
                break
            end
        end
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.addInventoryItem(item, 1)
    end
end)
