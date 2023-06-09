require "utils"
local Entity = require "./classes/entity"
local systems = require "systems"


local Player = Entity:new()
function Player:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.speed = 200
    self.rotation = 0
    self.bullets = {}
    self.health = 20
    self.isInCrate = false

    self.spriteName = "player"

    self.shootEffect = {
        timer = 0,
        intensity = 0,
        x = 0,
        y = 0,
        color = {1,1,1},
        alive = 0,
    }

    self.scale = 3
    self.origin = {
        x = 14,
        y = 20
    }
    self.rotationOffset = 3.14 / 2    
    self.raduis = 20
    return deepcopy(obj)
end


function Player:takeDamage(damage) 
    self.health = self.health - damage

    systems.sounds["zombieSound"]:play()

end

function Player:onBulletHitZombie(bullet , zombie)  
    zombie.health = zombie.health - math.abs(bullet:getDamage())
    systems.sounds["bulletHit"]:play()

    if bullet.kill then
        bullet.dead = true
    end
end
function Player:addShootEffect(shootEffect)
    self.shootEffect.timer = shootEffect.timer
    self.shootEffect.intensity = shootEffect.intensity
    self.shootEffect.x = shootEffect.x
    self.shootEffect.y = shootEffect.y
    self.shootEffect.color = shootEffect.color
    self.shootEffect.alive = 1 
    
end

function Player:shoot(bullet)
    if self.isInCrate then return end
    for _ , zombie in pairs(systems.zombieManager.zombies) do 
        systems.collistionManager:addCircleCollistion(
        bullet,
        zombie,
        function(bullet , zombie)  self:onBulletHitZombie(bullet , zombie) end,
        nil,
        0.3
    ) 
    end

    systems.camera:shake(systems.weaponManager.weapons[1].shakeVel)
    systems.bulletManager:addBullet(bullet)
end

function Player:input()
    if love.keyboard.isDown("a") then
        self.vel.x = -self.speed
    end
    if love.keyboard.isDown("d") then
        self.vel.x = self.speed
    end
    if love.keyboard.isDown("w") then
        self.vel.y = -self.speed
    end
    if love.keyboard.isDown("s") then
        self.vel.y = self.speed
    end
    if self.vel.x ~= 0 and self.vel.y ~= 0 then
        local mag = math.sqrt(self.vel.x * self.vel.x + self.vel.y * self.vel.y)
        self.vel.x = self.vel.x / mag  * self.speed
        self.vel.y = self.vel.y / mag  * self.speed
    end

    local mouseX , mouseY = systems.mouse.aabb.x  ,systems.mouse.aabb.y
    self.rotation = math.atan2(mouseY - self.aabb.y - systems.camera.offset.y,mouseX - self.aabb.x - systems.camera.offset.x)

end

function Player:move()
    

    self.aabb.x = self.aabb.x + self.vel.x * love.timer.getDelta()
    self.aabb.y = self.aabb.y + self.vel.y * love.timer.getDelta()


    if self.aabb.x > systems.fullWidth + 125 then
        self.aabb.x = systems.fullWidth + 125
    end
    if self.aabb.x < 10 then
        self.aabb.x = 10
    end
    if self.aabb.y < 10 then
        self.aabb.y = 10
    end
    if self.aabb.y > systems.fullHeight + 65 then
        self.aabb.y = systems.fullHeight + 65
    end


    self.vel = {x = 0 , y = 0}
end

function Player:updateShootEffect()
    if self.shootEffect.alive == 0 then return end
    self.shootEffect.timer = self.shootEffect.timer - love.timer.getDelta()
    if self.shootEffect.timer < 0 then
        self.shootEffect.alive = 0
    end
    
end

function Player:update()
    self:input()
    self:move()
    self:updateShootEffect()
end

function Player:render()


    -- love.graphics.push()
    -- love.graphics.translate(self.aabb.x + 10, self.aabb.y + 10)
    -- love.graphics.draw(systems.sprites.player.idle,0,0,self.rotation + 3.14 / 2,3 ,3 ,14,20)
    -- love.graphics.pop()



    -- setColor(0,0,1,1)
    -- love.graphics.circle("fill",self.aabb.x,self.aabb.y,self.raduis)
    -- setColor(1,1,1,1)


end



return Player