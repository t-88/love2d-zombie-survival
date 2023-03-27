require "utils"
local Entity = require "./classes/entity"
local Weapon = require "./classes/weapons/weapon"
local Bullet = require "./classes/weapons/bullet"

local ShotGun = Weapon:new()
function ShotGun:new(obj)
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
    self.bullet.damage = 20
    self.bullet.minDamage = 0.5
    self.bullet.mapDamageToLifeSpan = true

    self.spread = 3.14 - 2.6
    self.shakeVel = {x = 8 , y = 8}

    self.ammo = 10
    self.currAmmo = 5
    self.maxCurrAmmo = 5

    self.kill = false

    self.shootEffect = {
        timer = 0,
        intensity = 10,
        x = 0,
        y = 0,
        color = {1,0,0}
    }

    self.reloadTime = 1
    self.reloadDelay = 1
    self.scale = 1.5

    self.spriteName = "shotgun"
    self.reloadSoundEffect =  "shotgunReload"


    return deepcopy(obj)
end

function ShotGun:shoot(player,sounds)
    if player.isInCrate then return end 


    if not self.used and self.currAmmo == 0 and not self.reload then self.reload = true  end
    
    
    if not self.used and self.currAmmo > 0 then
        self.currAmmo = self.currAmmo - 1
        sounds["shotgunShot"]:play() 


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

function ShotGun:update(player,sounds)
    if love.mouse.isDown(1) then
        self:shoot(player,sounds)
    elseif not love.mouse.isDown(1) then
        self.used = false
    end 


    self:reload()

    
end

function ShotGun:render()
end


return ShotGun