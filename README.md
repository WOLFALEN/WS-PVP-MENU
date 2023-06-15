# PVP MENU

**what is mMenu?**

This is a weapon, vehicle spawner and a teleporting menu. It's also known as a PvP menu that can be used only in a red zone (This is optional). 



**Please read:**

Keybind : - F3

If you want players to access the menu in only red zones or any other coords. Go to line and do the following:

```
        dist = #(vector3(-227.3,-2622.93,6.05)-pos) <------------ change this to your own coords
        if dist <= 140 then <-------------- distance where the player will be able to open the menu

            inZone = true <------- change to false
        else
            inZone = false <------- change to true
        end

```

![Screenshot 2023-06-15 121647](https://github.com/WOLFALEN/WS-PVP-MENU/assets/123537406/a332ff19-81cb-4ef3-a31c-61619a0114a6)

