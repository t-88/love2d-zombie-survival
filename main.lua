local Player = require "./classes/player"
local Zombie = require "./classes/zombie"

local Piston =require "./classes/piston"
local Shootgun =require "./classes/shootgun"
local Rifle = require "./classes/rifle"

local systems = require "systems"
local maps = require "maps"
local shaders = require "shaders"


local player
local zombie
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



    local background = {
        sprite = "background",
        aabb = {x = -700 , y = -100} , 
        scale = 3.7,
        rotation = 0,
    }
    systems.cameraManager.cameras[systems.currRoom]:addSprite(background)
    -- roomManager = RoomManager:new()

    -- tmpEnemy = {
    --     sprite = systems.sprites.zombie.idle,
    --     x = -700 , y = -100 , 
    --     scale = 3,
    --     rotation = 0,
    -- }

    local zombie = Zombie:new()
    zombie:initSprite(systems.sprites.zombie.idle)
    systems.zombieManagers[systems.currRoom]:addZombie(zombie)
    systems.cameraManager.cameras[systems.currRoom]:addSprite(zombie.spriteInfo)


    rifle = Rifle:new()
    piston = Piston:new()
    shootgun = Shootgun:new()
    systems.weaponManager:addWeapon(rifle)
    systems.weaponManager:addWeapon(shootgun)

    -- shaders.shadow = love.graphics.newShader(lightShaderText)



    


end

function love.update()
    if love.keyboard.isDown("escape") then love.event.quit() end

    tmpEnemy.x = systems.zombieManagers[systems.currRoom].zombies[1].aabb.x
    tmpEnemy.y = systems.zombieManagers[systems.currRoom].zombies[1].aabb.y
    tmpEnemy.rotation = systems.zombieManagers[systems.currRoom].zombies[1].rotation

    -- roomManager:update()
    player:update()
    systems.update()


end

function addLightSource(index,pos,diffuse,power)
    shaders.shadow:send("lights["..index.."].pos",{pos.x,pos.y})
    shaders.shadow:send("lights["..index.."].diffuse",diffuse)
    shaders.shadow:send("lights["..index.."].power",power)
end

function love.draw()
    local count = 0 
    love.graphics.setShader(shaders.shadow)
        shaders.shadow:send("screen",{
            love.graphics.getWidth(),
            love.graphics.getHeight()
        })
        shaders.shadow:send("lightCount",1 + #systems.bulletManager.bullets)
        addLightSource(count,
                     {x = systems.player.aabb.x + systems.offset.x,y = systems.player.aabb.y + systems.offset.y},
                     {1,1,1},
                     30
                    )

                
        count = count + 1
        for _ , bullet in pairs(systems.bulletManager.bullets) do
            addLightSource(count,
            {x = bullet.aabb.x,y = bullet.aabb.y},
            {1,1,1},
            80
           )
            count = count + 1
        end
        

        systems.render()
        love.graphics.setShader()
        systems.renderUI()



end