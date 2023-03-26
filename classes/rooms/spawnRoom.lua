require "utils"
local Entity = require "./classes/entity"
-- local Chest = require "./classes/chest"
local Room = require "./classes/room"
local Zombie = require "./classes/zombie"


local SpawnRoom = Room:new()
function SpawnRoom:new(gridSize,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.id = "spawn"

    self.chestIsOpened = false





    return deepcopy(obj)
end


function SpawnRoom:init()
  
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

end




return SpawnRoom