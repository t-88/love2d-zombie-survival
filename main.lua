local Player = require "./classes/player"

local systems = require "systems"
local shaders = require "shaders"


local player

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    player = Player:new()
    systems.init(player)
    shaders.init()
end

function love.update()
    if love.keyboard.isDown("escape") then love.event.quit() end

    player:update()
    systems.update()
end



function addLightSources()
    shaders.addLightSource(
        {x = systems.player.aabb.x + systems.camera.offset.x,y = systems.player.aabb.y + systems.camera.offset.y},
        {1,1,1},
        30
    )

    for _ , bullet in pairs(systems.bulletManager.bullets) do
        shaders.addLightSource(
        {x = bullet.aabb.x + systems.camera.offset.x,y = bullet.aabb.y + systems.camera.offset.y},
        {1,1,1},
        120
       )
    end

    for _ , lightBomb in pairs(systems.weaponManager.lightBombs) do
        shaders.addLightSource(
        {x = lightBomb.aabb.x + systems.camera.offset.x,y = lightBomb.aabb.y + systems.camera.offset.y},
        {1,0,0},
        lightBomb.intensity
       )
    end
    
    if player.shootEffect.alive == 1  then
        shaders.addLightSource(
        {x = player.shootEffect.x ,y = player.shootEffect.y},
        player.shootEffect.color,
        player.shootEffect.intensity
       ) 
    end


    local crate = systems.crateManager.crates[#systems.crateManager.crates]
    if crate and not crate.empty then
        shaders.addLightSource(
            {x = crate.aabb.x + systems.camera.offset.x,y = crate.aabb.y + systems.camera.offset.y},
            {41/255,171/255,135/255},
            80
       )   
    end

end

function love.draw()
    
    -- local crateLight = systems.crateManager.crates[#systems.crateManager.crates] ~= nil and 1 or 0
    -- shaders.applyShadows(systems.width,systems.height,1 + #systems.bulletManager.bullets + player.shootEffect.alive + crateLight + #systems.weaponManager.lightBombs)
    -- addLightSources()

    systems.render()
    love.graphics.setShader()

    
    systems.renderUI()
end