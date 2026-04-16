# 🛒 CS-Shops - QBCore NPC Shop System

A lightweight and optimized NPC-based shop system for FiveM QBCore servers. This resource allows players to interact with NPCs to open shop inventories using **ox_target** and **ox_inventory**.

---

## ✨ Features

- **NPC-Based Shops**: Create shop locations with interactive NPCs
- **ox_target Integration**: Modern interaction system with targeting
- **ox_inventory Compatible**: Seamless integration with ox_inventory framework
- **Performance Optimized**: Minimal resource usage with efficient code
- **Multi-Location Support**: Easy configuration for multiple shop locations
- **Auto Cleanup**: Automatic resource cleanup on resource restart
- **Customizable NPCs**: Support for different NPC models and configurations

---

## 📋 Requirements

The following dependencies must be running on your server:

- **qb-core** - QBCore framework
- **ox_target** - Targeting and interaction system
- **ox_inventory** - Inventory management system

---

## 📁 Installation Guide

### Step 1: Download and Extract

1. Download the resource files
2. Extract the files into your resources folder:
   ```
   resources/cs-shops/
   ```

### Step 2: Add to Server Configuration

Add the following line to your `server.cfg`:

```cfg
ensure cs-shops
```

Make sure this line comes **after** the core dependencies:

```cfg
ensure qb-core
ensure ox_target
ensure ox_inventory
ensure cs-shops
```

### Step 3: Verify Installation

Start your server and check the console for any errors. The resource should load without warnings.

---

## ⚙️ Configuration

### File Structure

```
cs-shops/
├── fxmanifest.lua      (Resource manifest)
├── client.lua          (Client-side script)
└── readme.md           (This file)
```

### Configuring Shop Locations

To add or modify shop locations, edit the `generalShops` table in `client.lua`:

```lua
local generalShops = { 
    vector4(24.4572, -1346.4485, 28.4970, 270.0),      -- Shop Location 1
    vector4(-3039.6, 584.26, 7.91, 10.67),             -- Shop Location 2
    vector4(-3243.04, 999.98, 12.83, 346.44),          -- Shop Location 3
}
```

**Parameters:**
- `X, Y, Z` - NPC coordinates
- `W` - NPC heading/rotation (0-360 degrees)

---

## 🎮 Usage

### For Players

1. Navigate to any shop location
2. Target the shopkeeper NPC with ox_target
3. Select "Open Shop" from the interaction menu
4. Browse and purchase items from the shop inventory

### For Administrators

To add new shop locations:

1. Open `client.lua`
2. Locate the `generalShops` table
3. Add a new vector4 with the desired coordinates and heading
4. Save the file and restart the resource

Example:
```lua
local generalShops = { 
    vector4(24.4572, -1346.4485, 28.4970, 270.0),
    vector4(-3039.6, 584.26, 7.91, 10.67),
    vector4(-3243.04, 999.98, 12.83, 346.44),
    vector4(100.5, 200.3, 15.0, 90.0),  -- New location
}
```

---

## 🔧 Technical Details

### Resource Manifest (fxmanifest.lua)

```lua
fx_version 'cerulean'
game 'gta5'

client_script 'client.lua'

dependencies {
    'qb-core',
    'ox_target',
    'ox_inventory'
}
```

### Client Script Overview (client.lua)

The script performs the following operations:

1. **NPC Model Loading**: Pre-loads the shopkeeper model
2. **NPC Spawning**: Creates NPCs at specified locations
3. **NPC Configuration**: Makes NPCs invincible and immovable
4. **Interaction Setup**: Registers ox_target interactions
5. **Resource Cleanup**: Removes entities on resource stop

Key features in the code:

```lua
local peds = {}

local generalShops = { 
    vector4(24.4572, -1346.4485, 28.4970, 270.0),
    vector4(-3039.6, 584.26, 7.91, 10.67),
    vector4(-3243.04, 999.98, 12.83, 346.44),
}

CreateThread(function()
    local model = `mp_m_shopkeep_01`
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    for i = 1, #generalShops do
        local coords = generalShops[i]

        local ped = CreatePed(0, model, coords.x, coords.y, coords.z - 1, coords.w, false, true)

        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        exports.ox_target:addLocalEntity(ped, {
            {
                label = 'Open Shop',
                icon = 'fa-solid fa-shop',
                onSelect = function()
                    exports.ox_inventory:openInventory('shop', {
                        type = 'General'
                    })
                end
            }
        })

        peds[#peds + 1] = ped
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    for i = 1, #peds do
        if DoesEntityExist(peds[i]) then
            DeleteEntity(peds[i])
        end
    end
end)
```

---

## ⚙️ Important Configuration

### ox_inventory (REQUIRED)

Make sure your shop exists in:

```
ox_inventory/data/shops.lua
```

Example:

```lua
General = {
    name = 'Shop',
    inventory = {
        { name = 'burger', price = 10 },
        { name = 'water', price = 10 },
    }
}
```

⚠️ **IMPORTANT:**

* Do NOT use `locations` if using NPC system
* Do NOT use `id` unless using indexed shops

---

## 🚀 Server.cfg Setup

```cfg
ensure ox_lib
ensure ox_target
ensure ox_inventory
ensure qb-npc-shops
```

---

## ❌ Common Issues

### Shop opens then closes

* Remove `locations` from shops.lua
* Do NOT use `id`
* Ensure player is loaded

---

### Shop not opening

* Check if ox_inventory is started
* Check F8 console for errors
* Ensure item names exist

---

## 🔧 Customization

### Add new shop

```lua
vector4(x, y, z, heading)
```

---

### Change shop type

```lua
type = 'General'
```

---

## 📌 Notes

* ox_inventory uses config-based items (not SQL)
* Keep your code optimized (avoid unnecessary loops)
* Always test with server restart (not refresh)

---

## ❤️ Credits

* Overextended (ox_inventory / ox_target)
* QBCore Framework

---
