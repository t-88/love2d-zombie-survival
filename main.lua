local Player = require "./classes/player"
local Zombie = require "./classes/zombie"
local Entity = require "./classes/entity"

local Rifle = require "./classes/weapons/rifle"


local systems = require "systems"
local shaders = require "shaders"


local player




local background 
local truck


local tmpEnemy = {}
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    player = Player:new()
    systems.initSys(player)
    shaders.init()







    local zombie = Zombie:new()
    systems.zombieManager:addZombie(zombie)
    systems.camera:addSprite(zombie)

    systems.weaponManager:addWeapon(Rifle:new())



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