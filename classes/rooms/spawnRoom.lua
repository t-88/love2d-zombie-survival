require "utils"
local Entity = require "./classes/entity"
local Piston = require "./classes/piston"
local Chest = require "./classes/chest"
local Room = require "./classes/room"
local Zombie = require "./classes/zombie"


local SpawnRoom = Room:new()
function SpawnRoom:new(gridSize,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.id = "spawn"

    self.chestIsOpened = false


    self.Mychest = nil



    return deepcopy(obj)
end


function SpawnRoom:init()
    local gz =  self.systems.gridSize

    self.truck = {}
    self.truck.sprite = love.graphics.newImage("assets/truck.png")
    self.truck.aabb = {x = gz * 8, y = gz * 12}

    self.car = Entity:new()
    self.car.aabb.x = gz * 8 
    self.car.aabb.y = gz * 12
    self.car.aabb.w = gz * 6
    self.car.aabb.h = gz * 3
    
    self.Mychest = Chest:new(self.car.aabb.x - 5 , self.car.aabb.y + 10, 80 , self.car.aabb.h - 20)
    self.Mychest:init(self.systems,self.id)
    self.Mychest.color = {1,0,0,1}


    local pistol = Piston:new()
    self.Mychest:addItem("pistol",
    pistol,
    function(item) 
        if #self.systems.weaponManager.weapons == 2 then return false end
        self.systems.weaponManager:addWeapon(item)
        return true
    end)
    self.Mychest:addItem("pistolAmmo",function() return false end)




    self.wall = Entity:new()
    self.walls = {}

    self.wall.aabb = {x = gz * 2 , y = gz * 4 , w = gz * 3 , h = gz}
    -- table.insert(self.walls,deepcopy(self.wall))
    self.wall.aabb = {x = gz * 0 , y = gz * 10 , w = gz * 4 , h = gz* 2}
    -- table.insert(self.walls,deepcopy(self.wall))
    self.wall.aabb = {x = gz * 18 , y = gz * 8 , w = gz * 2 , h = gz* 1}
    -- table.insert(self.walls,deepcopy(self.wall))
    self.wall.aabb = {x = gz * 19 , y = gz * 9 , w = gz * 2 , h = gz* 1}
    -- table.insert(self.walls,deepcopy(self.wall))
    self.wall.aabb = {x = gz * (self.systems.widthGrid - 1) , y = gz * (self.systems.heightGrid - 2) , w = gz * 1 , h = gz* 2}
    -- table.insert(self.walls,deepcopy(self.wall))
    self.wall.aabb = {x = gz * (self.systems.widthGrid - 2) , y = gz * (self.systems.heightGrid - 1) , w = gz * 1 , h = gz* 1}
    -- table.insert(self.walls,deepcopy(self.wall))


    


    -- self.systems.cameraManager.cameras[self.id]:addEntity(self.car)
    -- self.systems.collistionManagers[self.id]:addCollistionWithStatic(self.car,self.systems.player,function()   end)

    -- self.systems.cameraManager.cameras[self.id]:addEntity(self.Mychest)


    -- for _ , wall in pairs(self.walls) do 
        -- self.systems.cameraManager.cameras[self.id]:addEntity(wall)
        -- self.systems.collistionManagers[self.id]:addCollistionWithStatic(wall,self.systems.player,function()  end)
-- end
end


function SpawnRoom:checkBounderies(player) 
    if self.systems.player.aabb.x < -10 then
        self.systems.currRoom = "house"
        self.systems.player.aabb.x = self.systems.width - 10
    end
    if self.systems.player.aabb.x > self.systems.width + 10 then
        self.systems.currRoom = "car1"
        self.systems.player.aabb.x = 10
    end
    if self.systems.player.aabb.y > self.systems.height + 10 then
        self.systems.currRoom = "chest"
        self.systems.player.aabb.y = 10
    end

    if self.systems.player.aabb.y < - 10 then
        self.systems.currRoom = "danger"
        self.systems.player.aabb.y = self.systems.height + 10
    end
end

function SpawnRoom:update()
    -- self:checkBounderies()
    self.Mychest:update()
    -- self.camera:update(self.systems.player)
end

function SpawnRoom:render()
    -- drawRect("fill",self.car.aabb.x,self.car.aabb.y,self.car.aabb.w,self.car.aabb.h)    
    -- self.camera:render(self.systems.player)
    -- self.Mychest:render()
    -- love.graphics.push()
    -- love.graphics.translate(self.truck.aabb.x,self.truck.aabb.y)
    -- love.graphics.scale(1.2,1.2)
    -- love.graphics.draw(self.truck.sprite)
    -- love.graphics.pop()
end


return SpawnRoom