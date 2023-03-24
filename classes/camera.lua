require "utils"
-- local systems = require "systems"

local Entity = require "./classes/entity"
local Camera = Entity:new()
function Camera:new(gridSize,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    self.fixed = false
    self.entities = {}
    self.offset = {x = 0, y = 0}
    self.savedOffset = self.offset

    self.shaking = false
    self.shakeVel = {x = 2 ,y =  2}
    self.shakeDead = 0.9
    
    return deepcopy(obj)
end

function Camera:addEntity(entity)
    table.insert(self.entities,entity)
end

function Camera:shake(shakeVel)
    self.savedOffset = deepcopy(self.offset)
    self.shakeVel = deepcopy(shakeVel)
    self.shaking = true
end

function Camera:update(target)

    if self.shaking then
        self.offset.x = self.savedOffset.x + math.random(-self.shakeVel.x,self.shakeVel.x) 
        self.offset.y = self.savedOffset.y + math.random(-self.shakeVel.y,self.shakeVel.y)
        
        self.shakeVel.x = self.shakeVel.x * self.shakeDead
        self.shakeVel.y = self.shakeVel.y * self.shakeDead

        if self.shakeVel.x <= 0.01 and self.shakeVel.y <= 0.01 then
            self.shaking = false
            self.offset.x = self.savedOffset.x
            self.offset.y = self.savedOffset.y
        end
    end 


    if self.fixed then return end
    if target.aabb.x + self.offset.x < self.smallRect.x then
        self.offset.x = self.smallRect.x - target.aabb.x 
    end 
    if target.aabb.x + self.offset.x > self.smallRect.x + self.smallRect.w then
        self.offset.x = self.smallRect.x + self.smallRect.w - target.aabb.x 
    end 
    if target.aabb.y + self.offset.y < self.smallRect.y then
        self.offset.y = self.smallRect.y - target.aabb.y 
    end 
    if target.aabb.y + self.offset.y > self.smallRect.y + self.smallRect.h then
        self.offset.y = self.smallRect.y + self.smallRect.h - target.aabb.y 
    end 
    

end


function Camera:render(target)
    -- setColor(self.color[1],self.color[2],self.color[3],self.color[4])
    -- drawRect('line',self.smallRect.x,self.smallRect.y,self.smallRect.w,self.smallRect.h)
    -- setColor(1,1,1,1)

    love.graphics.push()
    love.graphics.translate(self.offset.x,self.offset.y)
    
    for _ , entity in pairs(self.entities) do 
        entity:render()
    end
    target:render()

    love.graphics.pop()

    
end



return Camera