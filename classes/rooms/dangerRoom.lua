require "utils"
local Entity = require "./classes/entity"
local Room = require "./classes/room"

local DangerRoom = Room:new()
function DangerRoom:new(gridSize,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.id = "danger"


    
    return deepcopy(obj)
end
function DangerRoom:checkBounderies() 
    if self.systems.player.aabb.y > self.systems.height + 10 then
        self.systems.currRoom = "spawn"
        self.systems.player.aabb.y =   10
    end
end
function DangerRoom:update()
    self:checkBounderies()
end

function DangerRoom:render()
end


return DangerRoom