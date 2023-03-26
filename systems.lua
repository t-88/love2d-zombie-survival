local utils = require "utils" 
local CollistionManager = require "./classes/collistionManager" 
local ZombieManager = require "./classes/zombieManager" 
local Zombie = require "./classes/zombie"
local CrateManager = require "./classes/crateManager"
local WeaponManager = require "./classes/weaponManager"
local BulletManager = require "./classes/bulletManager"
local RoomManager = require "./classes/roomManager"
local CameraManager = require "./classes/cameraManager"
local UiManager = require "./classes/ui/uiManager"


local Rifle = require "./classes/rifle"
local Pistol = require "./classes/piston"
local Shootgun = require "./classes/shootgun"


local systems = {}

systems.collistionManagers = {}
systems.zombieManagers = {}
systems.crateManager = {}
systems.weaponManager = {}
systems.bulletManager = {}
systems.roomManager = {}
systems.cameraManager = {}
systems.uiManager = {}
systems.mouse = {aabb = {x = 0 , y = 0 ,w = 5 , h = 5}} 
systems.sprites = {} 
systems.zombieSpawnDelay = 1000
systems.zombieSpawnTimer = 1000


systems.maxZombieCount = 20
systems.killedCount = 0


systems.initSys = function (player)
    systems.gridSize = 35
    systems.widthGrid  = 22  --math.floor(love.graphics.getWidth()   / systems.gridSize)
    systems.heightGrid  = 17 --math.floor(love.graphics.getHeight()   / systems.gridSize)
    systems.width  = systems.widthGrid * systems.gridSize
    systems.height  = systems.heightGrid * systems.gridSize
    systems.fullWidth  = 1500
    systems.fullHeight  = 1150

    love.window.setMode(systems.width, systems.height)


    systems.items = {
        {
            spriteID = "rifle",
            onSelecte = function() 
                if #systems.weaponManager.weapons < 2 then
                    print('asdsd')
                    table.insert(systems.weaponManager.weapons,Rifle:new())
                    return true
                end
                return false
            end
        },
        {
            spriteID = "pistol",
            onSelecte = function() 
                if #systems.weaponManager.weapons < 2 then
                    table.insert(systems.weaponManager.weapons,Pistol:new())
                    return true
                end
                return false
            end
        },
        {
            spriteID = "shootgun",
            onSelecte = function() 
                if #systems.weaponManager.weapons < 2 then
                    table.insert(systems.weaponManager.weapons,Shootgun:new())
                    return true
                end
                return false
            end
        },
    }

    systems.player = player

    systems.scale = 2
    systems.bounderies = {
        bottom = 1050,
        top = 175,
        left = 175,
        right = 1400,
    }
    systems.offset = {x = 0 , y = 0}





    systems.sprites = {
        arrow = love.graphics.newImage("assets/arrow.png"),
        pistol = love.graphics.newImage("assets/pistol.png"),
        shootgun = love.graphics.newImage("assets/shotgun.png"),
        rifle = love.graphics.newImage("assets/rifal.png"),
        pistolAmmo = love.graphics.newImage("assets/pistol-ammo.png"),
        player = love.graphics.newImage("assets/player/player_walkready3.png"),

        -- zombie = {
            -- idle = love.graphics.newImage("assets/enemy/enemy.png"),
        -- },
        background = love.graphics.newImage("assets/map_bg.png"),
        zombie = love.graphics.newImage("assets/enemy/enemy.png"),
        bulletDefault =  love.graphics.newImage("assets/bullet-default.png"),
        crate =  love.graphics.newImage("assets/crate.png"),
        crateOutlined =  love.graphics.newImage("assets/crate-outlined.png"),
    }


    systems.roomsIds = {
        "spawn",  -- main
        "car1",   -- right
        "danger", -- top
        "house",  -- left
        "chest",  -- down
    }
    systems.currRoom = "spawn"

    
    systems.crateManager = CrateManager:new()

    systems.bulletManager = BulletManager:new()
    systems.cameraManager = CameraManager:new(systems)
    systems.cameraManager:setSystems(systems)






    systems.weaponManager = WeaponManager:new()
    systems.weaponManager:setSystems(systems)
    systems.weaponManager:setPlayer(player)
    systems.weaponManager:init()



    for _ , roomId in pairs(systems.roomsIds) do 
        systems.collistionManagers[roomId] = CollistionManager:new() 
        systems.zombieManagers[roomId] = ZombieManager:new()
        systems.zombieManagers[roomId]:setPlayer(player)
        systems.zombieManagers[roomId]:setSystems(systems)
    end


    systems.roomManager = RoomManager:new(systems.gridSize)
    systems.roomManager:setSystems(systems)

    systems.bulletManager:setSystems(systems)
    systems.collistionManagers[systems.currRoom]:setSystems(systems)
    systems.crateManager:setSystems(systems)
    systems.uiManager = UiManager:new()
    systems.uiManager:setSystems(systems)


    systems.playerCrateRotation = 0


end

systems.update = function()
    systems.mouse.aabb.x , systems.mouse.aabb.y = love.mouse.getPosition() 

    systems.collistionManagers[systems.currRoom]:update()
    systems.zombieManagers[systems.currRoom]:update()
    systems.crateManager:update()
    systems.weaponManager:update()
    systems.bulletManager:update()
    systems.roomManager:update(systems.currRoom)
    systems.cameraManager:update(systems.currRoom)




    systems.zombieSpawnTimer =  systems.zombieSpawnTimer - love.timer.getDelta() 
    if systems.zombieSpawnTimer < 0 and #systems.zombieManagers[systems.currRoom].zombies < systems.maxZombieCount then 
        systems.zombieSpawnTimer = systems.zombieSpawnDelay

        local zombie = Zombie:new()

        if love.math.random(0,1) == 0 then
            zombie.aabb.x = love.math.random(-400,systems.width + 400) - systems.offset.x 
            zombie.aabb.y = love.math.random(0,1) * systems.height - systems.offset.y 
        else 
            zombie.aabb.x = love.math.random(0,1) * systems.width - systems.offset.x 
            zombie.aabb.y = love.math.random(-400,systems.height + 400) - systems.offset.y 
        end

        systems.zombieManagers[systems.currRoom]:addZombie(zombie)
        systems.cameraManager.cameras[systems.currRoom]:addSprite(zombie)
    
    end

    systems.uiManager:update()

end
systems.render = function()
    systems.cameraManager:render(systems.currRoom)
    -- systems.roomManager:render(systems.currRoom)

    systems.bulletManager:render()
    systems.crateManager:render()



    systems.zombieManagers[systems.currRoom]:render()

    systems.uiManager:render(systems)

end

systems.renderGrid = function()
    for y = 0 , systems.heightGrid do 
        for x = 0 , systems.widthGrid do 
            drawRect('line',x * systems.gridSize,y * systems.gridSize, systems.gridSize,systems.gridSize)
        end
    end
end

systems.getCurrCollistionManager = function()

    return systems.collistionManagers[systems.currRoom]
end

systems.renderUI = function()
    systems.weaponManager:render()


    love.graphics.circle("line",systems.width - 200,systems.height - 60 , 35)
    local crate = systems.crateManager.crates[#systems.crateManager.crates]
    if crate then
        crateAABB = {
            x = crate.aabb.x + systems.offset.x,
            y = crate.aabb.y + systems.offset.y,
            w = crate.aabb.w + systems.offset.x,
            h = crate.aabb.h + systems.offset.y,
        }
        local screenAABB = {x = systems.offset.x , y = systems.offset.y , w = systems.width + systems.offset.x,h = systems.height + systems.offset.y}
        if not AABB(crateAABB,screenAABB) then
            systems.playerCrateRotation = math.atan2(systems.width - 200 - crateAABB.y,systems.height - 55 - crateAABB.x)
        end

    end

    setColor(1,0,0,1)
    love.graphics.draw(systems.sprites["arrow"],systems.width - 200,systems.height - 55,systems.playerCrateRotation,3,3,8,8)
    setColor(1,1,1,1)

end

return systems