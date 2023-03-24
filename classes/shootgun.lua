require "utils"
local Entity = require "./classes/entity"
local Weapon = require "./classes/weapon"
local Bullet = require "./classes/bullet"

local ShootGun = Weapon:new()
function ShootGun:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    
    self.used = false

    self.bullet = Bullet:new()


    self.bullet.speed = 2000
    self.bullet.aabb.w = 10
    self.bullet.aabb.h = 10

    self.bullet.initLifeSpace = 0.08
    self.bullet.lifeSpan = self.bullet.initLifeSpace
    self.bullet.damage = 4
    self.bullet.minDamage = 0.5
    self.bullet.mapDamageToLifeSpan = true

    self.spread = 3.14 - 2.9
    self.shakeVel = {x = 8 , y = 8}

    self.id = "shootgun"

    return deepcopy(obj)
end

function ShootGun:shoot(player)
    if not self.used then
        
        self.bullet.aabb.x = player.aabb.x
        self.bullet.aabb.y = player.aabb.y
        self.bullet.rotation = player.rotation
        
        local  tmpBullet 
        local spreadAngle
        
        for i = 1 , 6 do 
            tmpBullet = deepcopy(self.bullet)
            spreadAngle = love.math.random(-self.spread * 100,self.spread * 100) / 100
            tmpBullet.rotation = tmpBullet.rotation + spreadAngle
            tmpBullet.speed = tmpBullet.speed - love.math.random(6) * 150
            player:shoot(deepcopy(tmpBullet))
        end
        
        self.used = true
    end 

end

function ShootGun:update(player)
    if love.mouse.isDown(1) then
        self:shoot(player)
    elseif not love.mouse.isDown(1) then
        self.used = false
    end 

    
end

function ShootGun:render()
end


return ShootGun