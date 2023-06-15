Config = {}

-------------------------------------- MENUS --------------------------------------------
Config.TeleportMenu = true
Config.VehicleSpawnMenu = true
Config.WeaponMenu = true
------------------------------------- OPTIONS -------------------------------------------
Config.Suicide = true
-------------------------------------------------------------------------------------------------- 
Config.Vehicles = {
    [1] = {
         name = "Bugatti Divo 2019",
         id = "divo",   
     },
    [2] = {
         name = "Bus",
         id = "bus"
     },	
 }

 Config.locations = {
    [1] = {
        coords = vector3(-278.27,-1630.33,31.85),
        heading = 169.82,
        name = "TELEPORT TO WAYPOINT",
	    },  
}

Config.Weapons = {
    [1] = {
        name = "Get All Weapons",
        id = "weapon_appistol",
        description = "Spawn in an ~r~All Weapons"
    },
}

Config.OnPlayerFocus = {
    enabled = false, -- Play sound when cam is on player
    data = {"CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET"}
}
Config.OnPlayerFocuse = {
    enabled = false, -- Play sound when cam is on player
    data = {"RACE_PLACED", "HUD_AWARDS"}
}