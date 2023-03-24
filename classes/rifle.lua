require "utils"
local Entity = require "./classes/entity"
local Weapon = require "./classes/weapon"
local Bullet = require "./classes/bullet"

local Rifle = Weapon:new()
function Rifle:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    
    self.used = false
    self.shootDelay = 0.1
    self.shootTimer = 0

    self.bullet = Bullet:new()



    self.bullet.speed = 1800
    self.bullet.lifeSpan = 0.8
    self.bullet.damage = 1.8
    self.bullet.aabb.w = 4
    self.bullet.aabb.h = 4


    self.initSpread = 0
    self.maxSpreapd = 0.15
    self.spread = self.initSpread
    self.shakeVel = {x = 3 , y = 3}

    self.id = "rifle"



    return deepcopy(obj)
end

function Rifle:shoot(player)
    if not self.used then
        self.bullet.aabb.x = player.aabb.x
        self.bullet.aabb.y = player.aabb.y
        if self.spread > self.maxSpreapd then
            self.spread = self.maxSpreapd
        end


        local tmpBullet = deepcopy(self.bullet) 
        tmpBullet.rotation = player.rotation + love.math.random(-self.spread* 100,self.spread * 100) / 100
        
        player:shoot(deepcopy(tmpBullet))

        self.spread = self.spread + 0.015
        self.used = true


    end 

end

function Rifle:update(player)
    if love.mouse.isDown(1) then
        self:shoot(player)
    elseif not love.mouse.isDown(1) then
        self.spread = math.max(self.initSpread,self.spread - 0.03)

        self.used = false
    end 

    if self.used then
        self.shootTimer = self.shootTimer + love.timer.getDelta()
        if self.shootTimer > self.shootDelay then
            self.shootTimer = 0 
            self.used = false
        end
    end

    
end

function Rifle:render()
end


return Rifle