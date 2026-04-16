local peds = {}

local generalShops = {
    vector4(24.4572, -1346.4485, 28.4970, 270.0), -- shop 1
    vector4(-3039.6, 584.26, 7.91, 10.67),        -- shop 2
    vector4(-3243.04, 999.98, 12.83, 346.44),     -- shop 3
    vector4(1727.99, 6415.62, 35.04, 240.88),     -- shop 4
    vector4(1697.74, 4923.07, 42.06, 326.33),     -- shop 5
    vector4(1959.13, 3741.55, 32.34, 297.58),     -- shop 6
    vector4(549.33, 2669.88, 42.16, 99.73),       -- shop 7
    vector4(2676.39, 3279.96, 55.24, 337.33),     -- shop 8
    vector4(2555.52, 380.78, 108.62, 343.83),     -- shop 9
    vector4(372.97, 328.03, 103.57, 252.27),      -- shop 10

}

CreateThread(function()
    local model = "mp_m_shopkeep_01"
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
                    exports.ox_inventory:openInventory('shop', { type = 'General', id = i })
                end
            }
        })

        peds[#peds + 1] = ped
    end
end)

-- resource stop pe sab delete
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    for i = 1, #peds do
        if DoesEntityExist(peds[i]) then
            DeleteEntity(peds[i])
        end
    end
end)
