require "utils"
local Entity = require "./classes/entity"

local Zombie = Entity:new()
function Zombie:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.color = {1 , 0 , 0 , 1}
    self.health = 10

    self.target = nil
    self.detectRaduis = 200
    
    self.attackRaduis = 30
    self.dashRaduis = 80
    self.dashPenlaty = 0
    
    self.attackDelay = 0.1
    self.attackTimer = 0

    self.spriteInfo = {}

    self.spriteName = "zombie"
    self.scale = 3
    self.speed = 100


    self.offset = {
        x = 0,
        y = 0,
    }

    self.origin = {
        x = 10,
        y = 10,
    }


    self.raduis = 30
    return deepcopy(obj)
end



function Zombie:fellowTarget(target) 
    self.rotation = math.atan2(target.aabb.y - self.aabb.y,target.aabb.x - self.aabb.x) 
    self.vel.x = self.vel.x + math.cos(self.rotation)
    self.vel.y = self.vel.y + math.sin(self.rotation)


    self.aabb.x = self.aabb.x + self.speed * self.vel.x * love.timer.getDelta()
    self.aabb.y = self.aabb.y + self.speed * self.vel.y * love.timer.getDelta()


    self.vel = {x = 0 , y  = 0}
end
function Zombie:update(target,sounds) 
    if self.health <= 0 then
        self.dead = true
        return
    end

    self:fellowTarget(target)
    
end


return Zombie