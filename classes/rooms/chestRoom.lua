require "utils"
local Entity = require "./classes/entity"
local Room = require "./classes/room"

local ChestRoom = Room:new()
function ChestRoom:new(gridSize,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.id = "house"


    
    return deepcopy(obj)
end
function ChestRoom:checkBounderies() 
    if self.systems.player.aabb.y < - 10 then
        self.systems.currRoom = "spawn"
        self.systems.player.aabb.y = self.systems.height -  10
    end
end
function ChestRoom:update()
    self:checkBounderies()
end

function ChestRoom:render()
end


return ChestRoom