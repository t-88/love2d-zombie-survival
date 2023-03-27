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
local Shotgun = require "./classes/weapons/shotgun"
local LightBomb = require "./classes/weapons/lightBomb"

local Zombie = require "./classes/zombie"
local Entity = require "./classes/entity"

require "slam"



local systems = {}
systems.gridSize = 35
systems.widthGrid  = 22  
systems.heightGrid  = 17 
systems.width  = systems.widthGrid * (systems.gridSize + 5) 
systems.height  = systems.heightGrid * (systems.gridSize + 5)



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
        shotgun = love.graphics.newImage("assets/shotgun.png"),
        shotgunOutlined = love.graphics.newImage("assets/shotgun-outlined.png"),
        rifle = love.graphics.newImage("assets/rifal.png"),
        rifleOutlined = love.graphics.newImage("assets/rifal-outlined.png"),
        player = love.graphics.newImage("assets/player/player_walkready3.png"),
        background = love.graphics.newImage("assets/map_bg.png"),
        zombie = love.graphics.newImage("assets/enemy/enemy.png"),
        bulletDefault =  love.graphics.newImage("assets/bullet-default.png"),
        crate =  love.graphics.newImage("assets/crate.png"),
        crateOutlined =  love.graphics.newImage("assets/crate-outlined.png"),
        zombieBody1 = love.graphics.newImage("assets/enemy_deathchest3exp.png"),
        zombieBody2 = love.graphics.newImage("assets/enemy_deathchest4.png"),
        zombieBody3 = love.graphics.newImage("assets/enemy_deathchest4exp.png"),
        zombieBody4 = love.graphics.newImage("assets/enemy_deathchest5.png"),
    }
    systems.sounds = {
        zombieAttack = love.audio.newSource("assets/sounds/growling-zombie-104988.wav","static"),
        zombieSound = love.audio.newSource("assets/sounds/chew-21768.wav","static"),
        shotgunReload = love.audio.newSource("assets/sounds/shotgunreload.wav","static"),
        pistolReload = love.audio.newSource("assets/sounds/pistolreload.wav","static"),
        pistolShot = love.audio.newSource("assets/sounds/pistolshot.wav","static"),
        shotgunShot = love.audio.newSource("assets/sounds/shotgunshot.wav","static"),
        rifleReload = love.audio.newSource("assets/sounds/riflereload.wav","static"),
        rifleShot = love.audio.newSource("assets/sounds/rifleshot.wav","static"),
        bulletHit = love.audio.newSource("assets/sounds/bullethit.wav","static"),

        waitingGame = love.audio.newSource("assets/sounds/Waiting_game.wav","stream"),
        war = love.audio.newSource("assets/sounds/war.wav","stream"),
        assault = love.audio.newSource("assets/sounds/assault.wav","stream"),
        
        
    }
    systems.sounds["rifleReload"]:setVolume(0.02)
    systems.sounds["shotgunReload"]: setVolume(0.2)
    systems.sounds["pistolReload"]:setVolume(0.2)

    systems.sounds["rifleShot"]:setVolume(0.01)
    systems.sounds["pistolShot"]:setVolume(0.1)
    systems.sounds["shotgunShot"]:setVolume(0.1)

    systems.sounds["bulletHit"]:setVolume(0.03)

    systems.sounds["zombieSound"]:setVolume(0.1)


    systems.sounds["waitingGame"]:setVolume(0.3)
    systems.sounds["war"]:setVolume(0.3)
    systems.sounds["assault"]:setVolume(0.3)


    systems.sounds["waitingGame"]:setLooping(true)
    systems.sounds["war"]:setLooping(true)
    systems.sounds["assault"]:setLooping(true)

    
    
    
end
systems.screenDimSetup = function()

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
                systems.weaponManager:addWeapon(Rifle:new())
                return true
            end
            return false
        end
    )

    systems.addCrateItem(
        "pistol",
        function() 
            if #systems.weaponManager.weapons < 2 then
                systems.weaponManager:addWeapon(Pistol:new())
                return true
            end
            return false
        end
    )
    systems.addCrateItem(
        "shotgun",
        function() 
            if #systems.weaponManager.weapons < 2 then
                systems.weaponManager:addWeapon(Shotgun:new())
                return true
            end
            return false
        end
    )
    systems.addCrateItem(
        "lightBomb",
        function() 
            if #systems.weaponManager.weapons < 2 then
                systems.weaponManager:addWeapon(LightBomb:new())
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


    systems.font = love.graphics.newFont("assets/Minecraft.ttf", 32)
    love.graphics.setFont(systems.font)


    systems.player = player


    systems.nextCrateTime = 0
    systems.maxCrateTime = 30


    systems.crateManager = CrateManager:new()
    systems.bulletManager = BulletManager:new()
    systems.weaponManager = WeaponManager:new()
    systems.zombieManager = ZombieManager:new()
    systems.collistionManager = CollistionManager:new() 
    systems.camera = Camera:new()
    systems.uiManager = UiManager:new()


    -- systems.camera:init(systems)
    systems.camera.smallRect = {x = systems.gridSize * 5,y = systems.gridSize * 4 , w = systems.gridSize * 13 , h = systems.gridSize * 10}
    systems.camera.fixed = false
    systems.camera.color = {1,0,0,1}
    systems.camera.startShake = true
 

    systems.zombieManager:setSystems(systems)
    systems.weaponManager:init(systems.player,systems.sprites,systems.camera,systems.width,systems.height,systems.sounds)




    systems.bulletManager:init(systems.camera)
    systems.collistionManager:init(systems.camera.offset)
    systems.crateManager:init(systems.player,systems.camera,systems.uiManager,systems.items)
    systems.uiManager:setSystems(systems)


end

systems.update = function()
    systems.mouse.aabb.x , systems.mouse.aabb.y = love.mouse.getPosition() 

    systems.player:update()
    systems.collistionManager:update()
    systems.zombieManager:update()
    systems.crateManager:update()
    systems.weaponManager:update()
    systems.bulletManager:update()

    systems.camera:update(systems.player)






    systems.uiManager:update()

end


systems.render = function()
    systems.camera:render()
    systems.zombieManager:render()
end


systems.renderUI = function()
    systems.weaponManager:render()
    systems.uiManager:render(systems)
end

return systems