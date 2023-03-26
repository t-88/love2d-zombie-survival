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

    self.systems = nil

    self.allStates = {
        fellow = 'fellow',
        attack = 'attack',
        notActive =  'not-active',
    }
    self.state = 'fellow' 
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
function Zombie:update(target) 
    if self.health <= 0 then
        self.dead = true
    end


    if self.state == self.allStates.notActive then
        local distance = (self:getCenterOfRect().x - target.aabb.x) * (self:getCenterOfRect().x - target.aabb.x) + (self:getCenterOfRect().y - target.aabb.y) * (self:getCenterOfRect().y - target.aabb.y) 
        if distance <= self.detectRaduis * self.detectRaduis then
            self.state = self.allStates.fellow
        end
    elseif self.state == self.allStates.fellow then
        local distance = (self:getCenterOfRect().x - target.aabb.x) * (self:getCenterOfRect().x - target.aabb.x) + (self:getCenterOfRect().y - target.aabb.y) * (self:getCenterOfRect().y - target.aabb.y) 
        self:fellowTarget(target)
        if distance <= self.attackRaduis * self.attackRaduis then
            self.state = self.allStates.attack
        end
    elseif self.state == self.allStates.attack then
        self.attackTimer = self.attackTimer  + love.timer.getDelta()
        if self.attackTimer > self.attackDelay then
            if target.spriteName ~= "lightBomb"  then
                target:takeDamage(2)
                self.attackTimer = 0
                self.state = self.allStates.fellow
            end 
        end 
    end

    

    ::end_state_machine::
end


return Zombie