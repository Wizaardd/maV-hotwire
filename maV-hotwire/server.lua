SearchedVehicles = {}


Vehicle_Keys = {}

defaultData= LoadResourceFile(GetCurrentResourceName(), "./Vehicle_Keys.json") 
Vehicle_Keys = json.decode(defaultData)

FRA = nil

local allSQLSavedVehicle = {}







CreateThread(function()
    if MVS.Script_Option.Framework ~= "NON-FRAMEWORK" then
        if MVS.Script_Option.Framework == "ESX" then
            FRA = exports["es_extended"]:getSharedObject()
            while FRA == nil do
                FRA = exports["es_extended"]:getSharedObject()
                Citizen.Wait(200)
            end
        elseif MVS.Script_Option.Framework == "QB" then
            FRA = exports["qb-core"]:GetCoreObject()
            while FRA == nil do
                FRA = exports["qb-core"]:GetCoreObject()
                Citizen.Wait(200)
            end
        end
    end
end)

local function GetPlayer(src)
	dd = nil
	if MVS.Script_Option.Framework ~= "NON-FRAMEWORK" then
		if MVS.Script_Option.Framework == "ESX" then
			dd = FRA.GetPlayerFromId(src).identifier
		elseif MVS.Script_Option.Framework == "QB" then
			dd = FRA.Functions.GetPlayer(src).citizenid
		end
	else
		local license  = false
		for k,v in pairs(GetPlayerIdentifiers(src))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
				dd = license
			end
		end
	end
	return dd
end


RegisterNetEvent('maV-hotwire:server:RefreshKeys', function()
	local src = source

	local identifier = GetPlayer(src)
	TriggerClientEvent('maV-hotwire:client:RefreshKeys', src, Vehicle_Keys[identifier])
end)



local vehicleKeys = {}

RegisterNetEvent('wiz-hotwire:addKeys',function(plate)
    local src = source
	local ident = GetPlayer(src)

	if Vehicle_Keys[ident] ~= nil then
		table.insert(Vehicle_Keys[ident], {plate = plate})
    	TriggerClientEvent('wiz-hotwire:client:addKeys',src,plate)
	else
		Vehicle_Keys[ident] = {}
		table.insert(Vehicle_Keys[ident], {plate = plate})
		TriggerClientEvent('wiz-hotwire:client:addKeys',src,plate)
	end
	SaveResourceFile(GetCurrentResourceName(), "./Vehicle_Keys.json", json.encode(Vehicle_Keys, { indent = true }), -1)

end)

RegisterNetEvent('maV-hotwire:server:inventory-checkitem', function(xx, vehicle, Plate)
    local src = source
	if MVS.Script_Option.Framework ~= "NON-FRAMEWORK" then
		if MVS.Script_Option.Framework == "ESX" then
			local xPlayer = FRA.GetPlayerFromId(src)
			local xItem = xPlayer.getInventoryItem(xx)
	

			if xItem ~= nil and xItem.count >= MVS.Script_Option.Lockpick_Delete_Count then
				xPlayer.removeInventoryItem(xx, MVS.Script_Option.Lockpick_Delete_Count)
				TriggerClientEvent('maV-hotwire:client:inventory-checkitem', src, true, vehicle, Plate)
			else
				TriggerClientEvent('maV-hotwire:client:inventory-checkitem', src, false, vehicle, Plate)
			end
		elseif MVS.Script_Option.Framework == "QB" then
			local Player = FRA.Functions.GetPlayer(src)
			local xItem = Player.Functions.GetItemByName(xx)

			if xItem ~= nil then
				Player.Functions.RemoveItem(xx, MVS.Script_Option.Lockpick_Delete_Count)
				TriggerClientEvent('maV-hotwire:client:inventory-checkitem', src, true, vehicle, Plate)

			else
				TriggerClientEvent('maV-hotwire:client:inventory-checkitem', src, false, vehicle, Plate)

			end
		end
	
	end

end)


function trim(s)
    if s ~= nil then
		return s:match("^%s*(.-)%s*$")
	else
		return nil
    end
end

