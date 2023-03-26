local utils = require "utils" 
local CollistionManager = require "./classes/collistionManager" 
local ZombieManager = require "./classes/zombieManager" 
local Zombie = require "./classes/zombie"
local Entity = require "./classes/entity"

local CrateManager = require "./classes/crateManager"
local WeaponManager = require "./classes/weapons/weaponManager"
local BulletManager = require "./classes/weapons/bulletManager"
local RoomManager = require "./classes/roomManager"
local Camera = require "./classes/camera"

local UiManager = require "./classes/ui/uiManager"


local Rifle = require "./classes/weapons/rifle"
local Shootgun = require "./classes/weapons/shootgun"


local systems = {}

systems.collistionManager = {}
systems.zombieManager = {}
systems.crateManager = {}
systems.weaponManager = {}
systems.bulletManager = {}
systems.roomManager = {}
systems.camera = {}
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
    systems.width  = systems.widthGrid * (systems.gridSize + 5) 
    systems.height  = systems.heightGrid * (systems.gridSize + 5)
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

    systems.offset = {x = 0 , y = 0}
    systems.bounderies = {bottom = 1050,top = 175,left = 175,right = 1400}
    systems.background = Entity:new()
    systems.background.spriteName = "background"
    systems.background.aabb.x = -700    
    systems.background.aabb.y =  -100  
    systems.background.scale = 3.7
    systems.background.zIndex = -99



    systems.sprites = {
        arrow = love.graphics.newImage("assets/arrow.png"),
        pistol = love.graphics.newImage("assets/pistol.png"),
        shootgun = love.graphics.newImage("assets/shotgun.png"),
        rifle = love.graphics.newImage("assets/rifal.png"),
        player = love.graphics.newImage("assets/player/player_walkready3.png"),
        background = love.graphics.newImage("assets/map_bg.png"),
        zombie = love.graphics.newImage("assets/enemy/enemy.png"),
        bulletDefault =  love.graphics.newImage("assets/bullet-default.png"),
        crate =  love.graphics.newImage("assets/crate.png"),
        crateOutlined =  love.graphics.newImage("assets/crate-outlined.png"),
    }


    systems.crateManager = CrateManager:new()
    systems.bulletManager = BulletManager:new()


    systems.camera = Camera:new()
    systems.camera:init(systems)
    systems.camera.smallRect = {x = systems.gridSize * 5,y = systems.gridSize * 4 , w = systems.gridSize * 13 , h = systems.gridSize * 10}
    systems.camera.fixed = false
    systems.camera.color = {1,0,0,1}
    systems.camera.startShake = true
 


    systems.weaponManager = WeaponManager:new()
    systems.zombieManager = ZombieManager:new()
    systems.collistionManager = CollistionManager:new() 




    systems.weaponManager:setSystems(systems)
    systems.zombieManager:setSystems(systems)

    systems.weaponManager:init()
    systems.weaponManager:setPlayer(player)



    -- for _ , roomId in pairs(systems.roomsIds) do 
        -- systems.collistionManager[roomId] = CollistionManager:new() 
        -- systems.zombieManager[roomId] = ZombieManager:new()
        -- systems.zombieManager[roomId]:setPlayer(player)
        -- systems.zombieManager[roomId]:setSystems(systems)
    -- end


    systems.roomManager = RoomManager:new(systems.gridSize)
    systems.roomManager:setSystems(systems)

    systems.bulletManager:setSystems(systems)
    systems.collistionManager:setSystems(systems)
    systems.crateManager:setSystems(systems)
    systems.uiManager = UiManager:new()
    systems.uiManager:setSystems(systems)


    systems.playerCrateRotation = 0


end

systems.update = function()
    systems.mouse.aabb.x , systems.mouse.aabb.y = love.mouse.getPosition() 

    systems.collistionManager:update()
    systems.zombieManager:update()
    systems.crateManager:update()
    systems.weaponManager:update()
    systems.bulletManager:update()
    systems.roomManager:update(systems.currRoom)

    systems.camera:update(systems.player)




    systems.zombieSpawnTimer =  systems.zombieSpawnTimer - love.timer.getDelta() 
    if systems.zombieSpawnTimer < 0 and #systems.zombieManager.zombies < systems.maxZombieCount then 
        systems.zombieSpawnTimer = systems.zombieSpawnDelay

        local zombie = Zombie:new()

        if love.math.random(0,1) == 0 then
            zombie.aabb.x = love.math.random(-400,systems.width + 400) - systems.offset.x 
            zombie.aabb.y = love.math.random(0,1) * systems.height - systems.offset.y 
        else 
            zombie.aabb.x = love.math.random(0,1) * systems.width - systems.offset.x 
            zombie.aabb.y = love.math.random(-400,systems.height + 400) - systems.offset.y 
        end

        systems.zombieManager:addZombie(zombie)
        systems.camera:addSprite(zombie)

    
    end

    systems.uiManager:update()

end
systems.render = function()
    systems.camera:render()

    -- systems.roomManager:render(systems.currRoom)

    systems.crateManager:render()



    systems.zombieManager:render()

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

    return systems.collistionManager
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
        if not aabbToAABB(crateAABB,screenAABB) then
            systems.playerCrateRotation = math.atan2(systems.width - 200 - crateAABB.y,systems.height - 55 - crateAABB.x)
        end

    end

    setColor(1,0,0,1)
    love.graphics.draw(systems.sprites["arrow"],systems.width - 200,systems.height - 55,systems.playerCrateRotation,3,3,8,8)
    setColor(1,1,1,1)

end

return systems