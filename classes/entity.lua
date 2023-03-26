require "utils"
local Entity = {}
function Entity:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    

    self.aabb = {x = 0 ,y = 0 , w = 30 , h = 30}
    self.raduis = 10

    self.color = {1 , 1 , 1 , 1}
    self.vel = {x = 0 , y = 0}

    self.speed = 50
    self.rotation = 0
    self.dead = false

    self.offset = {x = 0 , y = 0}
    self.origin = {
        x= 0,
        y= 0,
    }

    self.zIndex = 0
    self.rotationOffset = 0
    return deepcopy(obj)
end

function Entity:initSprite(spriteName,scale)
    self.spriteInfo = {
        sprite = spriteName,
        rotation = 0,
        aabb = self.aabb,
        scale = scale,
    }
end


function Entity:getCenterOfRect()
    return {x = self.aabb.x + self.aabb.w / 2, y = self.aabb.y + self.aabb.h / 2}
end

function Entity:update()end
function Entity:render()end

return Entity