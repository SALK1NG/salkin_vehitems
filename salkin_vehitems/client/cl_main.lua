Main = {
    Vehs = {},
    My = nil
}

function Main:StoreVeh()
    if self.My ~= nil then
        local pedvehplate = GetVehicleNumberPlateText(self.My)
        local myvehplate = GetVehicleNumberPlateText(self.My)

        if Config.Settings.VehNeedsToBeStoped then
            if GetEntitySpeed(self.My) > 1 then
                self:Notify("You need to stop the vehicle first", 'error', 2500)
                return
            end
        end

        if pedvehplate == myvehplate then
            local vehmodel = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(self.My)))
            TriggerServerEvent('salkin_vehitems:returnitem', vehmodel)
            DeleteVehicle(self.My)
            self.My = nil
            self:Notify("Vehicle Stored", 'success', 2500)
        else
            self:Notify("This is not your vehicle", 'error', 2500)
            return
        end
    else
        self:Notify("No vehicle nearby to store", 'error', 2500)
    end
end


function Main:SpawnVehicle(data)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    model = type(data) == 'string' and GetHashKey(data) or data

    -- Überprüfen, ob das Modell vorhanden ist
    if not IsModelInCdimage(model) then return end

    -- Sicherstellen, dass die Koordinaten korrekt sind
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end

    -- Fahrzeugmodell laden
    self:LoadModel(model)

    -- Fahrzeug erstellen
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z - 1, coords.w, false, false)

    -- Fahrzeug in der Tabelle speichern
    self.Vehs[coords] = veh
    self.My = veh

    -- Warten, um sicherzustellen, dass das Fahrzeug im Netzwerk registriert ist
    Citizen.Wait(1000)  -- Warten für 1 Sekunde, um sicherzustellen, dass das Fahrzeug korrekt registriert wurde

    -- Überprüfen, ob das Fahrzeug existiert
    if DoesEntityExist(veh) then
        -- Netzwerk-ID abrufen
        local netid = NetworkGetNetworkIdFromEntity(veh)
        -- Sicherstellen, dass das Fahrzeug im Netzwerk verfügbar ist
        SetVehicleHasBeenOwnedByPlayer(veh, true)
        SetVehicleNeedsToBeHotwired(veh, false)
        SetVehRadioStation(veh, 'OFF')
        SetVehicleFuelLevel(veh, 100.0)
        SetModelAsNoLongerNeeded(model)
        SetVehicleOnGroundProperly(veh)

        -- Spieler in das Fahrzeug teleportieren
        TaskWarpPedIntoVehicle(ped, veh, -1)

        -- Fahrzeugschlüssel und -besitzer festlegen
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))

        -- Benachrichtigung anzeigen
        self:Notify("Spawned Item Vehicle " .. data, 'success', 2500)
        -- Fahrzeug auf der Karte anzeigen, falls konfiguriert
        if Config.Settings.CarBlip then
            local CarBlips = AddBlipForEntity(veh)
            SetBlipScale(CarBlips, 0.6)
            SetBlipSprite(CarBlips, 672)
            SetBlipColour(CarBlips, 5)

            SetBlipDisplay(CarBlips, 4)
            SetBlipAsShortRange(CarBlips, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName('Rental Car')
            EndTextCommandSetBlipName(CarBlips)
        end
    else
        -- Falls das Fahrzeug nicht existiert, eine Fehlermeldung ausgeben
        print("Fehler: Fahrzeug konnte nicht erstellt werden.")
    end
end


function Main:LoadModel(model)
    if HasModelLoaded(model) then return end
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(0)
	end
end

function Main:Notify(txt,tp,time) -- QBCore notify
    if Config.Settings.Framework == "ESX" then 
        ESX.ShowNotification(txt)
    end
end

RegisterNetEvent('salkin_vehitems:spawnvehicle',function(data)
    Main:SpawnVehicle(data)
end)



Citizen.CreateThread(function()
    exports.ox_target:addGlobalVehicle({
        {
            name = 'salkin_vehitems:storeVehicle',
            icon = 'fa-solid fa-car',
            label = "Store Vehicle",
            onSelect = function(data)
                Main:StoreVeh()
            end
        }
    })
end)

