local utils = require "utils" 
local CollistionManager = require "./classes/collistionManager" 
local ZombieManager = require "./classes/zombieManager" 
local CrateManager = require "./classes/crateManager"
local WeaponManager = require "./classes/weaponManager"
local BulletManager = require "./classes/bulletManager"
local RoomManager = require "./classes/roomManager"
local CameraManager = require "./classes/cameraManager"


local systems = {}

systems.collistionManagers = {}
systems.zombieManagers = {}
systems.crateManager = {}
systems.weaponManager = {}
systems.bulletManager = {}
systems.roomManager = {}
systems.cameraManager = {}
systems.mouse = {aabb = {x = 0 , y = 0 ,w = 5 , h = 5}} 
systems.sprites = {} 




systems.initSys = function (player)
    systems.gridSize = 35
    systems.widthGrid  = 22  --math.floor(love.graphics.getWidth()   / systems.gridSize)
    systems.heightGrid  = 17 --math.floor(love.graphics.getHeight()   / systems.gridSize)
    systems.width  = systems.widthGrid * systems.gridSize
    systems.height  = systems.heightGrid * systems.gridSize
    love.window.setMode(systems.width, systems.height)

    systems.player = player
    player.aabb.x = systems.gridSize * systems.widthGrid / 2
    player.aabb.y = systems.gridSize * systems.heightGrid / 2


    systems.sprites = {
        pistol = love.graphics.newImage("assets/pistol.png"),
        shootgun = love.graphics.newImage("assets/shotgun.png"),
        rifle = love.graphics.newImage("assets/rifal.png"),
        pistolAmmo = love.graphics.newImage("assets/pistol-ammo.png"),
    
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




    for _ , roomId in pairs(systems.roomsIds) do 
        systems.collistionManagers[roomId] = CollistionManager:new() 
        systems.zombieManagers[roomId] = ZombieManager:new()
    end
    systems.roomManager = RoomManager:new(systems.gridSize)
    systems.roomManager:setSystems(systems)


    systems.weaponManager = WeaponManager:new()
    systems.weaponManager:setSystems(systems)
    systems.weaponManager:setPlayer(player)
    systems.weaponManager:init()






    for _ , zombieManager in pairs(systems.zombieManagers) do
        zombieManager:setPlayer(player)
    end


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
end
systems.render = function()
    systems.zombieManagers[systems.currRoom]:render()
    systems.crateManager:render()
    systems.bulletManager:render()
    systems.roomManager:render(systems.currRoom)
    systems.cameraManager:render(systems.currRoom)

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

end

return systems