MVS = {}
MVS.Script_Locale = {
    Police_Notify = false,
    isActive = false
}

MVS.Script_Option = {
    Framework = "QB",  -- QB, ESX, NON-FRAMEWORK
    Lockpick_Item_Name = "lockpick",
    Lockpick_Delete_Count = 1,
    Lockpick_Police_Notify = true,
    maV_RealisticPark_Integrated = true
}

MVS.Vehicle_Black_List = {
    ['BMX'] = true,
    ['CRUISER'] = true,
    ['FIXTER'] = true,
    ['SCORCHER'] = true,
    ['TRIBIKE'] = true,
    ['TRIBIKE2'] = true,
    ['TRIBIKE3'] = true,
    ['FLATBED'] = true,
    ['BOXVILLE2'] = true,
    ['BENSON'] = true,
    ['PHANTOM'] = true,
    ['RUBBLE'] = true,
    ['RUMPO'] = true,
    ['YOUGA2'] = true,
    ['BOXVILLE'] = true,
    ['TAXI'] = true,
    ['DINGHY'] = true
}

MVS.Keys = {
    With_Pick = "M", -- Only ESX, QB use framework
    Force_Vehicle = "H",
    Toggle_Lock = "L"
}



MVS.Locale = {
    ["with_a_pick"] = "With a Pick",
    ["force_vehicle"] = "Force to Start Vehicle",
    ["police_notify"] = "An attempt is made to steal the vehicle.",
    ["no_lockpick"] = "No items on you.",
    ["failed"] = "You failed",
    ["toggle_lock_register_key_mapping"] = "[HOTWIRE] Vehicle Locking" ,
    ["vehicle_lock"] = "Vehicle locked",
    ["vehicle_unlock"] = "Vehicle unlocked"
}

MVS.Police_Dispatch = function(stats)

    if stats == "force" then
        if math.random(1,20) < 15 then 
            TriggerEvent("Wiz-PolisBildirim:BildirimGonder", MVS.Locale["police_notify"], false) 
        end
    elseif stats == "lockpick" then
        if math.random(1,100) < 15 then 
            TriggerEvent("Wiz-PolisBildirim:BildirimGonder", MVS.Locale["police_notify"], false) 
        end
    end

end

MVS.Client_Notify = function(text, type)
    TriggerEvent("notification", text, type)
end

MVS.Lockpick_Skill = function()
    local status = false
    local stop = false
    local finished3 = exports["maV-skillbar"]:taskBar(math.random(1, 2), math.random(1, 2))
    stop = true
    if not finished3 then
        MVS.Script_Locale.isActive = false
        status = false
        stop = false
    else
        MVS.Script_Locale.isActive = false
        status = true
        stop = false
    end

    while stop do
        Wait(5)
    end
    return status
end


MVS.Keys_Option = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}