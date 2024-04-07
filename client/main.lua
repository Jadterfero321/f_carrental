local npcc1 = false
local npcc2 = false
local npcc3 = false



------------------------
----------BLIP----------
------------------------

Citizen.CreateThread(function ()
    if Config.blip == true then
        blipp = CreateBlip(Config.blipc.x, Config.blipc.y, Config.blipc.z, Config.blipSprite, 11, Config.blipName)
    end
end)

Citizen.CreateThread(function ()
    SpawnNPC1()
end)

------------------------
-------SPAWN-NPC--------
------------------------

function SpawnNPC1()
    local peds = {
        { type=4, model=Config.npc}
    }

    for k, v in pairs(peds) do
        local hash = GetHashKey(v.model)
        RequestModel(hash)

        while not HasModelLoaded(hash) do
            Citizen.Wait(1)
        end

        --- SPAWN NPC---
        startNPC = CreatePed(v.type, hash, Config.blipc.x, Config.blipc.y, Config.blipc.z -1, Config.bliph, true, true)

        SetEntityInvincible(startNPC, true)
        SetEntityAsMissionEntity(startNPC, true)
        SetBlockingOfNonTemporaryEvents(startNPC, true)
        FreezeEntityPosition(startNPC, true)
    end
end


------------------------
-------BLIP CREATE------
------------------------

function CreateBlip(x, y, z, sprite, color, name)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
    SetBlipDisplay(blip, 6)
    return blip
end

------------------------
        --CAR SPAWNER--
------------------------
function CarSpawn()
    local ModelHash = Config.car -- Use Compile-time hashes to get the hash of this model
    if not IsModelInCdimage(ModelHash) then return end
    RequestModel(ModelHash) -- Request the model
    while not HasModelLoaded(ModelHash) do -- Waits for the model to load
      Wait(0)
    end
    local MyPed = PlayerPedId()
    local Vehicle = CreateVehicle(ModelHash, Config.carSpawnCords.x, Config.carSpawnCords.y, Config.carSpawnCords.z, Config.carSpawnCrodsh, true, false) -- Spawns a networked vehicle on your current coords
    SetModelAsNoLongerNeeded(ModelHash)
end

AddEventHandler('spawnCar', function()
    CarSpawn()
end)

------------------------
        --QTARGET ZONES--
------------------------
RegisterNetEvent('carrental_start_menu', function (arg)
    lib.registerContext({
        id = 'carrental_start_menu',
        title = 'Car Rental',
        options = {
            {
                title = 'Pick a vehicle'
            },
            {
                title = 'Dubsta',
                description = 'Dubsta is the best 4x4 vehicle',
                icon = 'car',
                event = 'spawnCar',
            },
        
        }
    })
    lib.showContext('carrental_start_menu')
end)

exports.ox_target:addBoxZone({
    coords = vector3(-1039.5309, -2730.9858, 20.2144),
    size = vec3(2, 2, 2),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'Rent a vehicle',
            event = 'carrental_start_menu',
            icon = 'fas fa-briefcase',
            label = 'Rent a vehicle',
        }
    }
})


