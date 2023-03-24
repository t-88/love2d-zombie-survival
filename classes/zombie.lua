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
    
    
    self.allStates = {
        fellow = 'fellow',
        attack = 'attack',
        notActive =  'not-active',
    }
    self.state = 'not-active' 
    
    return deepcopy(obj)
end

function Zombie:fellowTarget() 
    local rotation = math.atan2(self.target.aabb.y - self.aabb.y,self.target.aabb.x - self.aabb.x) 
    self.vel.x = self.vel.x + math.cos(rotation)
    self.vel.y = self.vel.y + math.sin(rotation)


    self.aabb.x = self.aabb.x + self.speed * self.vel.x * love.timer.getDelta()
    self.aabb.y = self.aabb.y + self.speed * self.vel.y * love.timer.getDelta()


    self.vel = {x = 0 , y  = 0}
end
function Zombie:update() 
    if self.health <= 0 then
        self.dead = true
    end

    if not self.target then goto end_state_machine end 


    if self.state == self.allStates.notActive then
        local distance = (self:getCenterOfRect().x - self.target.aabb.x) * (self:getCenterOfRect().x - self.target.aabb.x) + (self:getCenterOfRect().y - self.target.aabb.y) * (self:getCenterOfRect().y - self.target.aabb.y) 
        if distance <= self.detectRaduis * self.detectRaduis then
            self.state = self.allStates.fellow
        end
    elseif self.state == self.allStates.fellow then
        local distance = (self:getCenterOfRect().x - self.target.aabb.x) * (self:getCenterOfRect().x - self.target.aabb.x) + (self:getCenterOfRect().y - self.target.aabb.y) * (self:getCenterOfRect().y - self.target.aabb.y) 
        self:fellowTarget()
        if distance <= self.attackRaduis * self.attackRaduis then
            self.state = self.allStates.attack
        end
    elseif self.state == self.allStates.attack then
        self.attackTimer = self.attackTimer  + love.timer.getDelta()
        if self.attackTimer > self.attackDelay then
            self.target:takeDamage(2)
            self.attackTimer = 0
            self.state = self.allStates.fellow
        end 
    end

    

    ::end_state_machine::
end

function Zombie:stateRendering()
    if self.state == self.allStates.notActive then
        love.graphics.circle("line", self.aabb.x + self.aabb.w / 2, self.aabb.y + self.aabb.h / 2,self.detectRaduis)
    elseif self.state == self.allStates.fellow then
        love.graphics.circle("line", self.aabb.x + self.aabb.w / 2, self.aabb.y + self.aabb.h / 2,self.attackRaduis)
    end
end

function Zombie:render()
    setColor(self.color[1],self.color[2],self.color[3],self.color[4])
    love.graphics.rectangle("fill",self.aabb.x,self.aabb.y,self.aabb.w,self.aabb.h)
    setColor(1,1,1,1)

    self:stateRendering()
end

return Zombie