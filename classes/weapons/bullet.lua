require "utils"
local Entity = require "./classes/entity"

local Bullet = Entity:new()
function Bullet:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    self.aabb.w = 10
    self.aabb.h = 10
    self.lifeSpan = 1000
    self.initLifeSpace = 1000
    self.damage = 1
    self.minDamage = 1
    self.mapDamageToLifeSpan  = false


    self.spriteName = "bulletDefault"
    self.scale = 3

    self.raduis = 20
    self.origin = {
        x = -8,
        y = 0,
    }
    return deepcopy(obj)
end


function Bullet:getDamage()
    if self.mapDamageToLifeSpan then
        local damage = self.damage -  (1 - (self.lifeSpan / self.initLifeSpace))  * self.damage
        if damage < self.minDamage then
            damage = self.minDamage
        end 
        return  damage
    end
    
    return self.damage

end

function Bullet:update()
    if self.dead then
        return
    end

    self.aabb.x = self.aabb.x + math.cos(self.rotation) * self.speed  * love.timer.getDelta()
    self.aabb.y = self.aabb.y + math.sin(self.rotation) * self.speed  * love.timer.getDelta()

    if self.lifeSpan > 0 then
        self.lifeSpan = self.lifeSpan - love.timer.getDelta()
    else
        self.dead = true 
    end

end

return Bullet