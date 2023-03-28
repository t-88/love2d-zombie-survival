require "utils"
local Entity = require "./classes/entity"
local Weapon = require "./classes/weapons/weapon"
local Bullet = require "./classes/weapons/bullet"

local Rifle = Weapon:new()
function Rifle:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    
    self.used = false
    self.shootDelay = 0.06
    self.shootTimer = 0

    self.bullet = Bullet:new()



    self.bullet.speed = 1800
    self.bullet.lifeSpan = 0.8
    self.bullet.damage = 3.5
    self.bullet.aabb.w = 10
    self.bullet.aabb.h = 10

    self.ammo = 120
    self.currAmmo = 30
    self.maxCurrAmmo = 30

    self.shootEffect = {
        timer = 0,
        intensity = 30,
        x = 0,
        y = 0,
        color = {1,1,0},
    }


    self.initSpread = 0
    self.maxSpreapd = 0.15
    self.spread = self.initSpread
    self.shakeVel = {x = 2 , y = 2 }
    self.scale = 1.5

    self.spriteName = "rifle"
    self.reloadSoundEffect =  "rifleReload"




    return deepcopy(obj)
end

function Rifle:shoot(player,sounds)
    if player.isInCrate then return end 
    if not self.used and self.currAmmo == 0 and not self.haveToReload then self.haveToReload = true  end

    if not self.used and self.currAmmo > 0 then
        self.currAmmo =  self.currAmmo - 1
        sounds["rifleShot"]:play() 


        self.bullet.aabb.x = player.aabb.x + 10 + 20 * math.cos(player.rotation)
        self.bullet.aabb.y = player.aabb.y + 10 + 20 *  math.sin(player.rotation)
        if self.spread > self.maxSpreapd then
            self.spread = self.maxSpreapd
        end


        local tmpBullet = deepcopy(self.bullet) 
        tmpBullet.rotation = player.rotation + love.math.random(-self.spread* 100,self.spread * 100) / 100
        
        player:shoot(deepcopy(tmpBullet))
        self.shootEffect.x = self.bullet.aabb.x
        self.shootEffect.y = self.bullet.aabb.y
        player:addShootEffect(deepcopy(self.shootEffect))


        self.spread = self.spread + 0.015
        self.used = true


    end 

end

function Rifle:update(player,sounds)
    if love.mouse.isDown(1) then
        self:shoot(player,sounds )
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

self:reload()


    
end

function Rifle:render()
end


return Rifle