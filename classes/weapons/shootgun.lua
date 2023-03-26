require "utils"
local Entity = require "./classes/entity"
local Weapon = require "./classes/weapons/weapon"
local Bullet = require "./classes/weapons/bullet"

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

    self.bullet.initLifeSpace = 0.06 
    self.bullet.lifeSpan = self.bullet.initLifeSpace
    self.bullet.damage = 20
    self.bullet.minDamage = 0.5
    self.bullet.mapDamageToLifeSpan = true

    self.spread = 3.14 - 2.6
    self.shakeVel = {x = 8 , y = 8}

    self.ammo = 10
    self.currAmmo = 5
    self.maxCurrAmmo = 5

    self.shootEffect = {
        timer = 0,
        intensity = 10,
        x = 0,
        y = 0,
        color = {1,0,0}
    }

    self.reload = false
    self.reloadTime = 1
    self.reloadDelay = 1

    self.id = "shootgun"

    return deepcopy(obj)
end

function ShootGun:shoot(player)
    if player.isInCrate then return end 


    if not self.used and self.currAmmo == 0 and not self.reload then
        self.reload = true 
    end 
    if not self.used and self.currAmmo > 0 then
        self.currAmmo = self.currAmmo - 1
        self.bullet.aabb.x = player.aabb.x  + 10 + 20 * math.cos(player.rotation)
        self.bullet.aabb.y = player.aabb.y  + 10 + 20 *  math.sin(player.rotation)
        self.bullet.rotation = player.rotation
        
        local  tmpBullet 
        local spreadAngle

        self.shootEffect.x = self.bullet.aabb.x
        self.shootEffect.y = self.bullet.aabb.y
        player:addShootEffect(deepcopy(self.shootEffect))

        
        for i = 1 , 20 do 
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


    if love.keyboard.isDown("r") and not self.reload and not self.used then
        self.reload = true
    end

    if self.reload then
        self.reloadTime = self.reloadTime - love.timer.getDelta()
        if self.reloadTime < 0 then
            self.reload = false
            self.reloadTime = self.reloadDelay

            if self.ammo+ self.currAmmo >= self.maxCurrAmmo then
                self.ammo = self.ammo - self.maxCurrAmmo + self.currAmmo 
                self.currAmmo = self.maxCurrAmmo
            else 
                self.currAmmo = self.currAmmo + self.ammo 
                self.ammo = 0 
            end
            
        end
    end

    
end

function ShootGun:render()
end


return ShootGun