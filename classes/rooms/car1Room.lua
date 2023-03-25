require "utils"
local Entity = require "./classes/entity"
local Room = require "./classes/room"

local Car1Room = Room:new()
function Car1Room:new(gridSize,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.id = "car1"


    
    return deepcopy(obj)
end
function Car1Room:checkBounderies() 
    if self.systems.player.aabb.x < - 10 then
    self.systems.currRoom = "spawn"
        self.systems.player.aabb.x = self.systems.width -  10
    end
end
function Car1Room:update()
    self:checkBounderies()
end

function Car1Room:render()
end


return Car1Room