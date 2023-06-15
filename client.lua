local lastvehic = nil
local inZone = false

local AllWeapons = {
    "WEAPON_PISTOL",
    "WEAPON_COMBATPISTOL",
    "WEAPON_APPISTOL",
    "WEAPON_DOUBLEACTION",
    "WEAPON_ASSAULTRIFLE",
    "WEAPON_CARBINERIFLE",
    "WEAPON_ADVANCEDRIFLE",
    "WEAPON_SNIPERRIFLE",
    "WEAPON_HEAVYSNIPER",
    "WEAPON_RAILGUN",
    "WEAPON_FIREEXTINGUISHER",
    "WEAPON_FLARE",
    "WEAPON_SNOWBALL",
    "WEAPON_FLASHLIGHT",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_REVOLVER",  
}


function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, true)
end

local timers = {
    health = 0,
    armour = 0,
    bus = 0,
    invincibility = 0,
}

local cooldowns = {
    health = 15,
    armour = 15,
    bus = 60,
    invincibility = 5
}



function notify(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
    DrawNotification(true, false)
end

function setInvincibility()
    timers.invincibility = cooldowns.invincibility
end

RMenu.Add('combat', 'main', RageUI.CreateMenu("~r~WOLF DEVELOPMENTS","",0,100)) ------ change this to whatever you want
RMenu:Get('combat', 'main'):SetSubtitle("BY WOLF STUDIO")------ change this to whatever you want
RMenu.Add('combat', 'weapons', RageUI.CreateSubMenu(RMenu:Get('combat','main'), "Weapon Spawner", "~b~Choose your weapon", nil, nil))
RMenu.Add('combat', 'vehicles', RageUI.CreateSubMenu(RMenu:Get('combat','main'), "Vehicle Spawner", "~b~Select a vehicle", nil, nil))
RMenu.Add('combat', 'teleport', RageUI.CreateSubMenu(RMenu:Get('combat','main'), "Teleporter", "~b~Select a location to teleport to", nil, nil))

RageUI.CreateWhile(1.0, RMenu:Get('combat', 'main'), 170, function()
    RageUI.IsVisible(RMenu:Get('combat', 'main'), true, true, true, function()
        if not inZone then
            RageUI.Button("~g~Health", "Select to add your health", { }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    if timers.health <= 0 then
                        timers.health = cooldowns.health
                        SetEntityHealth(PlayerPedId(), 200)
                        notify("~g~Replenished your health")
                    else
                        notify(string.format("~r~You must wait another %ss before you can replenish your health again!", timers.health))
                    end
                end
            end, nil)

            RageUI.Button("~b~Armour", "Select to add your armour", { }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    if timers.armour <= 0 then
                        timers.armour = cooldowns.armour
                        SetPedArmour(PlayerPedId(), 100)
                        Notify("~g~Replenished your armour")
                    else
                        Notify(string.format("~r~You must wait another %ss before you can replenish your armour again!", timers.armour))
                    end
                end
            end, nil)

            if Config.TeleportMenu == true then
                RageUI.Button("~b~Teleport Menu", "Select to open the teleport menu", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Selected) then end
                end, RMenu:Get('combat','teleport'))
            end

            if Config.WeaponMenu == true then
                RageUI.Button("~p~Weapon Spawner", "Select to open the weapon spawner", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        -- loop through all weapons and give them to the player
                        for k,v in pairs(AllWeapons) do
                            local weaponHash = GetHashKey(v)
                            GiveWeaponToPed(GetPlayerPed(-1), weaponHash, 999, true, true)
                            SetPedInfiniteAmmo(PlayerPedId(), true)
                        end
                    end
                end, RMenu:Get('combat','weapons'))
            end

            if Config.Suicide == true then
                RageUI.Button("~r~Suicide", "~r~Select to kill yourself", { }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        SetEntityHealth(PlayerPedId(), 0)
                        Notify("~g~You ~r~Died")
                    end
            end, nil)
        end

            RageUI.Button("~c~Clear Loadout", "Select to reset your loadout", { }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    RemoveAllPedWeapons(GetPlayerPed(-1), true)
                    TriggerEvent("alert:toast", "DemonRZMENU", "Removed all weapons!", "dark", "success", 4000)
                end
            end, nil)
        else
            Notify("~r~You cannot use this menu in this area!")
        end
    end, function()
    end)
    RageUI.IsVisible(RMenu:Get('combat', 'weapons'),true,true,true,function()
        for name, values in ipairs(Config.Weapons) do
            RageUI.Button(tostring(values.name), string.format("%s", values.description),{ }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    GiveWeaponToPed(PlayerPedId(), GetHashKey(values.id), 9999, false, true)
                end
            end)
        end 
    end, function()
        ---Panels
    end)

    RageUI.IsVisible(RMenu:Get('combat', 'vehicles'),true,true,true,function()
        for name, values in ipairs(Config.Vehicles) do
            RageUI.Button(tostring(values.name), string.format("Select to spawn a %s", values.name),{ }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    if (values.name == "Bus" and timers.bus <= 0) or values.name ~= "Bus" then
                        if values.name == "Bus" then
                            timers.bus = cooldowns.bus
                        end
                        RequestModel(GetHashKey(values.id))
                        while not HasModelLoaded(GetHashKey(values.id)) do
                            Citizen.Wait(100)
                        end
                        local playerPed = PlayerPedId()
                        local pos = GetEntityCoords(playerPed)
                        local vehicle = CreateVehicle(GetHashKey(values.id), pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)
                        SetPedIntoVehicle(playerPed, vehicle, -1)
                        if lastvehic ~= nil then
                            SetEntityAsMissionEntity(lastvehic, true, true)
                            DeleteVehicle(lastvehic)
                        end
                        lastvehic = vehicle
                    else
                        notify(string.format("~r~You cannot spawn another bus for %ss",timers.bus))
                    end
                end
            end)
        end 
    end, function()
        ---Panels
    end)

    RageUI.IsVisible(RMenu:Get('combat', 'teleport'),true,true,true,function()
        for name, values in ipairs(Config.locations) do
            RageUI.Button(tostring(values.name), string.format("Select to teleport to %s", values.name),{ }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local playerPed = PlayerPedId()
                    teleport()
                end
            end)
        end 
    end, function()
        ---Panels
    end)
end)

Citizen.CreateThread(function()
    while true do
        for k,_ in pairs(timers) do
            timers[k] = timers[k]-1
        end
        -- checking of distance to redzone
        local pos = GetEntityCoords(PlayerPedId())
        dist = #(vector3(-227.3,-2622.93,6.05)-pos)
        if dist <= 140 then
            inZone = true ------- change to false and set line 191 to true if you want the menu to open in a specific location! 
        else
            inZone = false
        end
        if timers.invincibility > 0 then
            SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), true)
            TriggerServerEvent("K9:sv_combatSetEntityAlpha", 190)
            SetEntityAlpha(GetPlayerPed(-1), 190)
        elseif timers.invincibility == 0 then
            SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), false)
            TriggerServerEvent("K9:sv_combatSetEntityAlpha", 255)
            SetEntityAlpha(GetPlayerPed(-1), 255)
            HudWeaponWheelIgnoreControlInput(false)
        end
        Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        while timers.invincibility > 0 do
            HudWeaponWheelIgnoreControlInput(true)
            Wait(0)
        end
        Wait(400)
    end
end)

RegisterNetEvent("K9:cl_combatSetEntityAlpha")
AddEventHandler("K9:cl_combatSetEntityAlpha", function(entity, value)
    SetEntityAlpha(entity, value)
end)

function teleport()
	local playerPed = PlayerPedId()
	local waypointBlip = GetFirstBlipInfoId(GetWaypointBlipEnumId())

	if DoesEntityExist(playerPed) then
		if DoesBlipExist(waypointBlip) then
            local waypointBlip = GetFirstBlipInfoId(GetWaypointBlipEnumId())
            local blipPos = GetBlipInfoIdCoord(waypointBlip) -- GetGpsWaypointRouteEnd(false, 0, 0)
        
            local z = GetHeightmapTopZForPosition(blipPos.x, blipPos.y)
            local _, gz = GetGroundZFor_3dCoord(blipPos.x, blipPos.y, z, true)

			cFromTop()
			setInvincibility()
			local waypointCoords = GetBlipInfoIdCoord(waypointBlip)
			setInvincibility()

            SetEntityCoords(PlayerPedId(), blipPos.x, blipPos.y, z, true, false, false, false)
            FreezeEntityPosition(PlayerPedId(), true)

			repeat
				Citizen.Wait(50)
				_, gz = GetGroundZFor_3dCoord(blipPos.x, blipPos.y, z, true)
			until gz ~= 0
            SetEntityCoords(PlayerPedId(), blipPos.x, blipPos.y, gz, true, false, false, false)
            FreezeEntityPosition(PlayerPedId(), false)
		end
	end
end

function cFromTop()
    cam  = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 96.358459472656,-611.05651855469,10000.0, -90.0, 0.0, -168.0, 45.0, true, 2)
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 96.358459472656,-611.05651855469,1500.00, -90.0, 0.0, -168.0, 45.0, true, 2)
    RenderScriptCams(1, 1, 0, 0, 0)
    Wait(0) -- Needed to load map
    SetFocusPosAndVel(GetCamCoord(cam), 0.0, 0.0, 0.0)
    SetCamActiveWithInterp(cam2, cam, 10000, 1, 1)
    Wait(0)
    SetFocusPosAndVel(GetCamCoord(cam2), 0.0, 0.0, 0.0)
    Wait(8000)
    cFromTopEnd()
end

function cFromTopEnd()
    c = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 96.358459472656,-611.05651855469,4000.0, -90.0, 0.0, -168.0, 45.0, true, 2)
    SetCamActiveWithInterp(c, cam2, 2000, 1, 1)
    FinalEnd()
end

function FinalEnd()
    DoScreenFadeOut(500)
    SetFocusEntity(GetPlayerPed(-1))
    inProgress = false
    RenderScriptCams(0, 1, 2000, 1, 0)
    Wait(1500)
    DoScreenFadeIn(500)
    PlaySoundFrontend(-1,Config.OnPlayerFocus.data[1], Config.OnPlayerFocus.data[2])
    DestroyAllCams(true)
    isOnEndScreen = false
    cam,cam2,cam3,cam4,cam5,cam6,cam7,cam8,cam9 = nil
end
