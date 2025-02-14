Config = {}
Config.Debug = false

ESX = exports["es_extended"]:getSharedObject() -- uncomment if you use ESX

Config.Settings = {
    Framework = "ESX", -- Framework
    CarBlip = true, -- Blip for your car
    StoreVehKey = 'j', -- keybind for storing the vehicle (can be changed from the game keybinds)
    VehNeedsToBeStoped = true, -- if set to true the vehicle needs to be stoped before it can be stored
}

Config.Items = {
    -- Template = ['item_name'] = "vehicle_model" --
    ['rc_car'] = 'rcbandito',
    ['wheelchair'] = 'iak_wheelchair',
}