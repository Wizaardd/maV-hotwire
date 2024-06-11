FRA = nil
Keys = {}
PlayerData = {}
SearchedVeh = {}
bildirimgitti = false

scriptxd = true

CreateThread(function()
    TriggerServerEvent('maV-hotwire:server:RefreshKeys')
    if MVS.Script_Option.Framework ~= "NON-FRAMEWORK" then
        if MVS.Script_Option.Framework == "ESX" then
            FRA = exports["es_extended"]:getSharedObject()
            while FRA == nil do
                FRA = exports["es_extended"]:getSharedObject()
                Citizen.Wait(200)
            end
        elseif MVS.Script_Option.Framework == "QB" then
            FRA = exports["es_extended"]:getSharedObject()
            while FRA == nil do
                FRA = exports["es_extended"]:getSharedObject()
                Citizen.Wait(200)
            end
        end
    end
end)




RegisterNetEvent('esx:playerLoaded', function(a)
    TriggerServerEvent('maV-hotwire:server:RefreshKeys')
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('maV-hotwire:server:RefreshKeys')
end)

RegisterNetEvent('maV-hotwire:client:RefreshKeys', function(data)
    if data then
        for i = 1, #data, 1 do
            Keys[data[i].plate] = true
        end
    end
end)


RegisterNetEvent('wiz-hotwire:client:addKeys', function(data)
    Keys[data] = true
end)
RegisterNetEvent('wiz-hotwire:client:removeKeys',function(plate)
    Keys[plate] = nil
end)

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.30, 0.30)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 250
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local baslar = false

Citizen.CreateThread(function()
    while true do
        local wait = 2000
        if IsPedInAnyVehicle(PlayerPedId(),false) and scriptxd ~= false then
            local vehicle = GetVehiclePedIsIn(PlayerPedId())
            local Plate = GetVehicleNumberPlateText(vehicle)
            local vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 1.25, 0.35)
            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() and not MVS.Vehicle_Black_List[GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))] then
                if Keys[Plate] ~= true then
                    wait = 2
                    text = ""
                    if MVS.Script_Option.Framework ~= "NON-FRAMEWORK" then
                        text = '['..MVS.Keys.With_Pick..'] - '..MVS.Locale["with_a_pick"]..' | ['..MVS.Keys.Force_Vehicle..'] - '..MVS.Locale["force_vehicle"]
                    else
                        text = '['..MVS.Keys.Force_Vehicle..'] - '..MVS.Locale["force_vehicle"]
                    end
                    if IsControlJustPressed(1, MVS.Keys_Option[MVS.Keys.With_Pick]) and MVS.Script_Option.Framework ~= "NON-FRAMEWORK" then
                        TriggerServerEvent('maV-hotwire:server:inventory-checkitem', MVS.Script_Option.Lockpick_Item_Name, vehicle, Plate)
                    end
                        
                    if IsControlJustPressed(0, MVS.Keys_Option[MVS.Keys.Force_Vehicle]) then
                        MVS.Police_Dispatch("force")
                        local bildirim = true
                        local sure = math.random(20000, 30000)
                        SetVehicleAlarm(vehicle, true)
                        SetVehicleAlarmTimeLeft(vehicle, sure + 4500)
                        local finished = MVS.Lockpick_Skill()
                        if not finished then
                            MVS.Client_Notify(MVS.Locale["failed"], 2)
                        else
                            
                            DisableControlAction(0, 23) 
                            TriggerServerEvent('wiz-hotwire:addKeys',Plate)
                            SetVehicleEngineOn(vehicle,true)
                                        
                        end
                    end
                    DrawText3D(vehicleCoords.x,vehicleCoords.y,vehicleCoords.z,text)
                end
            end
        end
        
        Citizen.Wait(wait)  
    end
end)

RegisterNetEvent('maV-hotwire:client:inventory-checkitem', function(dd, vehicle, Plate)
    if dd then
        MVS.Police_Dispatch("lockpick")
        local sure31 = math.random(5000, 15000)
        SetVehicleAlarm(vehicle, true)
        SetVehicleAlarmTimeLeft(vehicle, sure31)
        MVS.Script_Locale.isActive = true

        
        local finished3 = MVS.Lockpick_Skill()
        if not finished3 then
            MVS.Client_Notify(MVS.Locale["failed"], 2)
        else
 
            DisableControlAction(0, 23) 
            TriggerServerEvent('wiz-hotwire:addKeys',Plate)
 
            SetVehicleEngineOn(vehicle,true)
                
        end
        
        
        
    else
        MVS.Client_Notify(MVS.Locale["no_lockpick"], 2)
    end

end)



Citizen.CreateThread(function()
    while true do
        local wait = 2000
        local veh = GetVehiclePedIsIn(PlayerPedId() , false)
        local Plate = GetVehicleNumberPlateText(veh)
        if scriptxd ~= false and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() and Keys[Plate] ~= true then
            wait = 1
            SetVehicleEngineOn(veh, false)
        end
        Citizen.Wait(wait)
    end
end)

local hasKilledNPC = false
Citizen.CreateThread(function()
    while true do
        local wait = 500

        if IsPedShooting(PlayerPedId()) then
            wait = 1
            hasKilledNPC = true
        end

            
        if GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= nil and GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= 0 and not gotKeys then
            wait = 1
            local curveh = GetVehiclePedIsTryingToEnter(PlayerPedId())
            local plate1 = GetVehicleNumberPlateText(curveh)
            local pedDriver = GetPedInVehicleSeat(curveh, -1)
            if DoesEntityExist(pedDriver) and IsEntityDead(pedDriver) and not IsPedAPlayer(pedDriver) and hasKilledNPC then
                hasKilledNPC = false
                gotKeys = true
                TriggerServerEvent('wiz-hotwire:addKeys',plate1)
                SetVehicleEngineOn(vehicle,true)
                gotKeys = false
            end
        end
        Citizen.Wait(wait)
    end
end)




function loadModel(prop)
	while not HasModelLoaded(prop) do
		RequestModel(prop)
		Citizen.Wait(10)
	end
end

AddKeys = function(plate)
    if plate ~= nil then
        TriggerServerEvent('wiz-hotwire:addKeys',plate)
    end
end

StopHotwire = function()
    scriptxd = false
end

StartHotwire = function()
    scriptxd = true
end

RegisterNetEvent('hotwire-ver')
AddEventHandler('hotwire-ver', function(plate)
    if IsPedInAnyVehicle(PlayerPedId(),false)  then
        local vehicle = GetVehiclePedIsIn(PlayerPedId())
        local Plate = GetVehicleNumberPlateText(vehicle)
        local vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 1.25, 0.35)
        if plate == Plate then
            TriggerServerEvent('wiz-hotwire:addKeys',Plate)
            SetVehicleEngineOn(vehicle,true)
        else
            TriggerEvent('notification', "Yanlış Anahtar", 2)
        end
    end

end)


local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

function GetClosestVehicle(coords)
    local ped = PlayerPedId()
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestVehicle = -1
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - coords)

        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end
    return closestVehicle, closestDistance
end


RegisterKeyMapping('+toggleLock', MVS.Locale["toggle_lock_register_key_mapping"], 'keyboard', MVS.Keys.Toggle_Lock)

RegisterCommand('+toggleLock', function()
    local pPed = PlayerPedId()
    local coords = GetEntityCoords(PlayerPedId())
    vehicle = GetClosestVehicle()
    local Plate = GetVehicleNumberPlateText(vehicle)
    if Keys[Plate] == true then
        local lock = GetVehicleDoorLockStatus(vehicle)
        if lock == 1 or lock == 0 then
            local prop = GetHashKey('p_car_keys_01')
            loadModel(prop)
            local keyFob = CreateObject(prop, 1.0, 1.0, 1.0, 1, 1, 0)
            AttachEntityToEntity(keyFob, pPed, GetPedBoneIndex(pPed, 57005), 0.09, 0.04, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

            loadAnimDict("anim@mp_player_intmenu@key_fob@")
            TaskPlayAnim(PlayerPedId(), 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3.0, 3.0, -1, 49, 0, false, false, false)
            TriggerServerEvent('maV-realisticpark:Vehicle:Locked', Plate, 2)
            SetVehicleDoorShut(vehicle, 0, false)
            SetVehicleDoorShut(vehicle, 1, false)
            SetVehicleDoorShut(vehicle, 2, false)
            SetVehicleDoorShut(vehicle, 3, false)
            SetVehicleDoorsLocked(vehicle, 2)
            PlayVehicleDoorCloseSound(vehicle, 1)
            SetVehicleLights(vehicle, 2)
            SetVehicleLights(vehicle, 0)
            SetVehicleLights(vehicle, 2)
            SetVehicleLights(vehicle, 0)
            MVS.Client_Notify(MVS.Locale["vehicle_lock"], 1)
            Citizen.Wait(1250)
            DeleteObject(keyFob)
            ClearPedTasks(PlayerPedId())
        elseif lock == 2 then
            local prop = GetHashKey('p_car_keys_01')
            loadModel(prop)
            local keyFob = CreateObject(prop, 1.0, 1.0, 1.0, 1, 1, 0)
            AttachEntityToEntity(keyFob, pPed, GetPedBoneIndex(pPed, 57005), 0.09, 0.04, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
            loadAnimDict("anim@mp_player_intmenu@key_fob@")
            TaskPlayAnim(PlayerPedId(), 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3.0, 3.0, -1, 49, 0, false, false, false)
        
            SetVehicleDoorsLocked(vehicle, 1)
            TriggerServerEvent('maV-realisticpark:Vehicle:Locked', Plate, 1)
            PlayVehicleDoorOpenSound(vehicle, 0)
            SetVehicleLights(vehicle, 2)
            SetVehicleLights(vehicle, 0)
            SetVehicleLights(vehicle, 2)
            SetVehicleLights(vehicle, 0)
            MVS.Client_Notify(MVS.Locale["vehicle_unlock"], 1)
            Citizen.Wait(1250)
            DeleteObject(keyFob)
            ClearPedTasks(PlayerPedId())
        end
    end
end)


RegisterCommand('calistir', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    SetVehicleEngineOn(vehicle,true)
end)
