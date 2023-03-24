require "utils"
local Entity = require "./classes/entity"

local Crate = Entity:new()
function Crate:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self


    self.size = 4
    self.aabb.w = 50
    self.aabb.h = 50


    self.itmes = {}
    self.used = false
    
    return deepcopy(obj)
end

function Crate:update()
    if self.size > 2 then
        self.size = self.size - love.timer.getDelta() * 2
    elseif self.size > 1 then
        self.size = self.size - love.timer.getDelta() 
    else 
        self.size = 1
    end
end

function Crate:render()
    setColor(self.color[1],self.color[2],self.color[3],self.color[4])
    love.graphics.push()
        love.graphics.translate(self.aabb.x , self.aabb.y)
        love.graphics.scale(self.size)
        love.graphics.rectangle("line", -self.aabb.w/2,- self.aabb.h/2, self.aabb.w, self.aabb.h)
    love.graphics.pop()
    setColor(1,1,1,1)
end

return Crate