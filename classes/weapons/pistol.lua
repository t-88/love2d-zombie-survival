require "utils"
local Entity = require "./classes/entity"
local Weapon = require "./classes/weapons/weapon"
local Bullet = require "./classes/weapons/bullet"


local Pistol = Weapon:new()
function Pistol:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    
    self.used = false

    self.bullet = Bullet:new()
    self.bullet.speed = 1500
    self.bullet.damage = 4


    self.ammo = 25
    self.currAmmo = 13
    self.maxCurrAmmo = 13

    self.shakeVel = {x = 2 , y = 2}
    
    self.reloadSoundEffect =  "pistolReload"
    

    self.reloadTime = 0.2
    self.reloadDelay = 0.2

    self.scale = 2

    self.spriteName = "pistol"



    return deepcopy(obj)
end

function Pistol:shoot(player,sounds)
    if player.isInCrate then return end 
    if not self.used and self.currAmmo == 0 and not self.reload then self.reload = true  end

    if not self.used and self.currAmmo > 0 then
        self.currAmmo =  self.currAmmo - 1
        sounds["pistolShot"]:play() 

        self.bullet.aabb.x = player.aabb.x + 10 + 20 * math.cos(player.rotation)
        self.bullet.aabb.y = player.aabb.y + 10 + 20 *  math.sin(player.rotation)
        self.bullet.rotation = player.rotation

        player:shoot(deepcopy(self.bullet))
        self.used = true
    end 

end

function Pistol:update(player,sounds)
    if love.mouse.isDown(1) then
        self:shoot(player,sounds)
    elseif not love.mouse.isDown(1) then
        self.used = false
    end 

    self:reload()

end

function Pistol:render()
end


return Pistol