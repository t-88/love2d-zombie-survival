local utils = require "utils" 

local CollistionManager = require "./classes/collistionManager" 
local ZombieManager = require "./classes/zombieManager" 
local CrateManager = require "./classes/crateManager"
local WeaponManager = require "./classes/weapons/weaponManager"
local BulletManager = require "./classes/weapons/bulletManager"
local UiManager = require "./classes/ui/uiManager"


local Camera = require "./classes/camera"

local Pistol = require "./classes/weapons/pistol"
local Rifle = require "./classes/weapons/rifle"
local Shootgun = require "./classes/weapons/shootgun"

local Zombie = require "./classes/zombie"
local Entity = require "./classes/entity"



local systems = {}

systems.collistionManager = {}
systems.zombieManager = {}
systems.crateManager = {}
systems.weaponManager = {}
systems.bulletManager = {}
systems.camera = {}
systems.uiManager = {}
systems.mouse = {aabb = {x = 0 , y = 0 ,w = 5 , h = 5}} 
systems.sprites = {} 


systems.zombieSpawnDelay = 0.5 * 10000
systems.zombieSpawnTimer = 0.5 * 10000
systems.maxZombieCount = 20
systems.killedCount = 0


systems.loadSprites = function()
    systems.sprites = {
        lightBomb = love.graphics.newImage("assets/lightBomb.png"),
        pistol = love.graphics.newImage("assets/pistol.png"),
        pistolOutlined = love.graphics.newImage("assets/pistol-outlined.png"),
        shootgun = love.graphics.newImage("assets/shotgun.png"),
        shootgunOutlined = love.graphics.newImage("assets/shotgun-outlined.png"),
        rifle = love.graphics.newImage("assets/rifal.png"),
        rifleOutlined = love.graphics.newImage("assets/rifal-outlined.png"),
        player = love.graphics.newImage("assets/player/player_walkready3.png"),
        background = love.graphics.newImage("assets/map_bg.png"),
        zombie = love.graphics.newImage("assets/enemy/enemy.png"),
        bulletDefault =  love.graphics.newImage("assets/bullet-default.png"),
        crate =  love.graphics.newImage("assets/crate.png"),
        crateOutlined =  love.graphics.newImage("assets/crate-outlined.png"),
        arrow = love.graphics.newImage("assets/arrow.png"),
        uiTile = love.graphics.newImage("assets/uiTile.png"),
    }
end
systems.screenDimSetup = function()
    systems.gridSize = 35
    
    systems.widthGrid  = 22  
    systems.heightGrid  = 17 

    systems.width  = systems.widthGrid * (systems.gridSize + 5) 
    systems.height  = systems.heightGrid * (systems.gridSize + 5)
    
    systems.fullWidth  = 1500
    systems.fullHeight  = 1150
    
    love.window.setMode(systems.width, systems.height)


    systems.bounderies = {bottom = 1050,top = 175,left = 175,right = 1400}

    systems.background = Entity:new()
    systems.background.spriteName = "background"
    systems.background.aabb = {x = -700, y =  -100 , systems.background.aabb.w , systems.background.aabb.h }      
    systems.background.scale = 3.7
    systems.background.zIndex = -99
end
systems.addCrateItem = function(spriteID,onSelecte)
    table.insert(systems.items,{spriteID = spriteID, onSelecte = onSelecte})
end
systems.setupCrateItems = function()
    systems.items = {}
    systems.addCrateItem(
        "rifle",
        function() 
            if #systems.weaponManager.weapons < 2 then
                table.insert(systems.weaponManager.weapons,Rifle:new())
                return true
            end
            return false
        end
    )

    systems.addCrateItem(
        "pistol",
        function() 
            if #systems.weaponManager.weapons < 2 then
                table.insert(systems.weaponManager.weapons,Pistol:new())
                return true
            end
            return false
        end
    )
    systems.addCrateItem(
        "shootgun",
        function() 
            if #systems.weaponManager.weapons < 2 then
                table.insert(systems.weaponManager.weapons,Shootgun:new())
                return true
            end
            return false
        end
    )
end



systems.init = function (player)
    systems.loadSprites()
    systems.screenDimSetup()
    systems.setupCrateItems()


    systems.player = player





    systems.crateManager = CrateManager:new()
    systems.bulletManager = BulletManager:new()
    systems.weaponManager = WeaponManager:new()
    systems.zombieManager = ZombieManager:new()
    systems.collistionManager = CollistionManager:new() 
    systems.camera = Camera:new()
    systems.uiManager = UiManager:new()


    systems.camera:init(systems)
    systems.camera.smallRect = {x = systems.gridSize * 5,y = systems.gridSize * 4 , w = systems.gridSize * 13 , h = systems.gridSize * 10}
    systems.camera.fixed = false
    systems.camera.color = {1,0,0,1}
    systems.camera.startShake = true
 

    -- systems.weaponManager:setSystems(systems)
    systems.zombieManager:setSystems(systems)

    systems.weaponManager:init(systems.player,systems.sprites,systems.camera,systems.width,systems.height)
    -- systems.weaponManager:setPlayer(player)




    systems.bulletManager:init(systems.camera)
    systems.collistionManager:init(systems.camera.offset)
    systems.crateManager:init(systems.player,systems.camera,systems.uiManager,systems.items)
    systems.uiManager:setSystems(systems)


    systems.playerCrateRotation = 0


    systems.zombieManager:addZombie(Zombie:new())
end

systems.update = function()
    systems.mouse.aabb.x , systems.mouse.aabb.y = love.mouse.getPosition() 

    systems.collistionManager:update()
    systems.zombieManager:update()
    systems.crateManager:update()
    systems.weaponManager:update()
    systems.bulletManager:update()

    systems.camera:update(systems.player)




    systems.zombieSpawnTimer =  systems.zombieSpawnTimer - love.timer.getDelta() 
    if systems.zombieSpawnTimer < 0 and #systems.zombieManager.zombies < systems.maxZombieCount then 
        systems.zombieSpawnTimer = systems.zombieSpawnDelay

        local zombie = Zombie:new()

        if love.math.random(0,1) == 0 then
            zombie.aabb.x = love.math.random(-400,systems.width + 400) - systems.camera.offset.x 
            zombie.aabb.y = love.math.random(0,1) * systems.height - systems.camera.offset.y 
        else 
            zombie.aabb.x = love.math.random(0,1) * systems.width - systems.camera.offset.x 
            zombie.aabb.y = love.math.random(-400,systems.height + 400) - systems.camera.offset.y 
        end

        systems.zombieManager:addZombie(zombie)
        systems.camera:addSprite(zombie)

    
    end

    systems.uiManager:update()

end
systems.render = function()
    systems.camera:render()



    systems.zombieManager:render()


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


    -- local crate = systems.crateManager.crates[#systems.crateManager.crates]
    -- if crate then
    --     crateAABB = {
    --         x = crate.aabb.x + systems.camera.offset.x,
    --         y = crate.aabb.y + systems.camera.offset.y,
    --         w = crate.aabb.w + systems.camera.offset.x,
    --         h = crate.aabb.h + systems.camera.offset.y,
    --     }
    --     local screenAABB = {x = systems.camera.offset.x , y = systems.camera.offset.y , w = systems.width + systems.camera.offset.x,h = systems.height + systems.camera.offset.y}
    --     if not aabbToAABB(crateAABB,screenAABB) then
    --         systems.playerCrateRotation = math.atan2(systems.width - 200 - crateAABB.y,systems.height - 55 - crateAABB.x)
    --     end

    -- end

    -- love.graphics.circle("line",systems.width - 200,systems.height - 60 , 35)
    -- setColor(1,0,0,1)
    -- love.graphics.draw(systems.sprites["arrow"],systems.width - 200,systems.height - 55,systems.playerCrateRotation,3,3,8,8)
    -- setColor(1,1,1,1)

    systems.uiManager:render(systems)


end

return systems