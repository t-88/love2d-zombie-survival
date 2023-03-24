require "utils"
local Entity = require "./classes/entity"

local Drop = Entity:new()
function Drop:new(x,y,dir, sprite,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    
    self.dir = dir

    self.vel = {x = 4,y = 4}
    self.friction = 0.92 +love.math.random(0,2) / 100 

    self.isDroped = false

    self.sprite = sprite or nil
    self.aabb  = { x = x, y = y , w = sprite:getWidth() , h = sprite:getHeight()}
    self.isActive = false    
    self.index = 0
    self.entity = nil

    return deepcopy(obj)
end


function Drop:update()
    if self.isDroped then
        return
    end

    self.aabb.x = self.aabb.x + self.dir.x * self.vel.x 
    self.aabb.y = self.aabb.y + self.dir.y * self.vel.y 


    self.vel.x = self.vel.x * self.friction
    self.vel.y = self.vel.y * self.friction


    if self.vel.x < 0.1 and self.vel.y < 0.1 then
        self.isDroped = true    
    end 

    
end

function Drop:render()
    if self.isActive and self.isDroped then
        setColor(1,1,0,1)
    end
    if self.sprite == nil then
    drawRect("fill",self.aabb.x,self.aabb.y,self.aabb.w,self.aabb.h)
    else    
        love.graphics.push()
        love.graphics.translate(self.aabb.x,self.aabb.y)
        love.graphics.scale(1.5,1.5)
        love.graphics.draw(self.sprite)
        love.graphics.pop()
    
    end
    setColor(1,1,1,1)

end

return Drop