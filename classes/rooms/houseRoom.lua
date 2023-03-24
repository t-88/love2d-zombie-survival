require "utils"
local Entity = require "./classes/entity"
local Room = require "./classes/room"

local HouseRoom = Room:new()
function HouseRoom:new(gridSize,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.id = "house"


    
    return deepcopy(obj)
end

function HouseRoom:checkBounderies() 
    if self.systems.player.aabb.x > self.systems.width + 10 then
        self.systems.currRoom = "spawn"
        self.systems.player.aabb.x =  10
    end
end
function HouseRoom:update()
    self:checkBounderies()
end

function HouseRoom:render()
end


return HouseRoom