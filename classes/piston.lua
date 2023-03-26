require "utils"
local Entity = require "./classes/entity"
local Weapon = require "./classes/weapon"
local Bullet = require "./classes/bullet"


local Piston = Weapon:new()
function Piston:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    
    self.used = false

    self.bullet = Bullet:new()
    self.bullet.speed = 1500
    self.bullet.damage = 1

    self.shakeVel = {x = 2 , y = 2}
    

    self.id = "pistol"



    return deepcopy(obj)
end

function Piston:shoot(player)
    if not self.used then
        self.bullet.aabb.x = player.aabb.x + 10 + 20 * math.cos(player.rotation)
        self.bullet.aabb.y = player.aabb.y + 10 + 20 *  math.sin(player.rotation)
        self.bullet.rotation = player.rotation

        player:shoot(deepcopy(self.bullet))
        self.used = true
    end 

end

function Piston:update(player)
    if love.mouse.isDown(1) then
        self:shoot(player)
    elseif not love.mouse.isDown(1) then
        self.used = false
    end 
end

function Piston:render()
end


return Piston