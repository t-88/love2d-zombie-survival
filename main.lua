local Player = require "./classes/player"
local Zombie = require "./classes/zombie"
local Entity = require "./classes/entity"

local Piston =require "./classes/piston"
local Shootgun =require "./classes/shootgun"
local Rifle = require "./classes/rifle"

local systems = require "systems"
local maps = require "maps"
local shaders = require "shaders"


local player
local piston
local rifle
local shootgun



local background 
local truck


local tmpEnemy = {}
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    player = Player:new()
    systems.initSys(player)
    maps.init()
    shaders.init()



    local background = Entity:new()
    background.spriteName = "background"
    background.aabb.x = -700    
    background.aabb.y =  -100  
    background.scale = 3.7
    background.zIndex = -99

    systems.cameraManager.cameras[systems.currRoom].background = background

    rifle = Rifle:new()
    piston = Piston:new()
    shootgun = Shootgun:new()
    -- systems.weaponManager:addWeapon(rifle)
    systems.weaponManager:addWeapon(shootgun)

    -- shaders.shadow = love.graphics.newShader(lightShaderText)

    local zombie = Zombie:new()
    systems.zombieManagers[systems.currRoom]:addZombie(zombie)
    systems.cameraManager.cameras[systems.currRoom]:addSprite(zombie)

    local zombie = Zombie:new()
    zombie.aabb.y = 100
    zombie.aabb.x = 100
    systems.zombieManagers[systems.currRoom]:addZombie(zombie)
    systems.cameraManager.cameras[systems.currRoom]:addSprite(zombie)    



end

function love.update()
    if love.keyboard.isDown("escape") then love.event.quit() end

    player:update()
    systems.update()


end



function addLightSources()
    local count = 0 

    shaders.addLightSource(count,
        {x = systems.player.aabb.x + systems.offset.x,y = systems.player.aabb.y + systems.offset.y},
        {1,1,1},
        30
    )
    count = count + 1

    for _ , bullet in pairs(systems.bulletManager.bullets) do
        shaders.addLightSource(count,
        {x = bullet.aabb.x + systems.offset.x,y = bullet.aabb.y + systems.offset.y},
        {1,1,1},
        120
       )
        count = count + 1
    end
    
    if player.shootEffect.alive == 1  then
        shaders.addLightSource(count,
        {x = player.shootEffect.x ,y = player.shootEffect.y},
        player.shootEffect.color,
        player.shootEffect.intensity
       ) 

    count = count + 1
    end


    local crate = systems.crateManager.crates[#systems.crateManager.crates]
    if crate and not crate.empty then
        shaders.addLightSource(
            count,
            {x = crate.aabb.x + systems.offset.x,y = crate.aabb.y + systems.offset.y},
            {41/255,171/255,135/255},
            80
       )   
    end
    count = count + 1

end

function love.draw()
    
    local crateLight = systems.crateManager.crates[#systems.crateManager.crates] ~= nil and 1 or 0
    shaders.applyShadows(systems.width,systems.height,1 + #systems.bulletManager.bullets + player.shootEffect.alive + crateLight)
    addLightSources()
    


    systems.render()
    love.graphics.setShader()
    systems.renderUI()



end