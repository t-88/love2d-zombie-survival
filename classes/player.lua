require "utils"
local Entity = require "./classes/entity"
local systems = require "systems"


local Player = Entity:new()
function Player:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.speed = 120
    self.aabb.x = 400
    self.aabb.y = 400
    self.rotation = 0
    self.bullets = {}
    self.health = 10
    
    return deepcopy(obj)
end


function Player:takeDamage(damage) 
    self.health = self.health - damage
    print("player took",damage,"damage") 
end

function Player:onBulletHitZombie(bullet , zombie)  
    for i = 1 , #self.bullets do
        if bullet == self.bullets[i] then
            bullet.dead = true
            table.remove(self.bullets,i)
            break
        end
    end 

    zombie.health = zombie.health - math.abs(bullet:getDamage())
    bullet.dead = true
    print('zombie health:',zombie.health, 'bullet damage',bullet:getDamage())
end

function Player:shoot(bullet)
    for _ , zombie in pairs(systems.zombieManagers[systems.currRoom].zombies) do 
        systems.collistionManager:addCollistionAABB(bullet,zombie,function(bullet , zombie)  self:onBulletHitZombie(bullet , zombie) end) 
    end

    for _ , wall in pairs(systems.roomManager.rooms[systems.currRoom].walls) do 
        systems.collistionManagers[systems.currRoom]:addCollistionAABB(bullet,wall,function(bullet , wall)  bullet.dead = true end) 
    end


    systems.cameraManager.cameras[systems.currRoom]:shake(systems.weaponManager.weapons[1].shakeVel)
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

    local mouseX , mouseY = love.mouse.getPosition()
    self.rotation = math.atan2(mouseY - self.aabb.y,mouseX - self.aabb.x)

end

function Player:move()
    

    self.aabb.x = self.aabb.x + self.vel.x * love.timer.getDelta()
    self.aabb.y = self.aabb.y + self.vel.y * love.timer.getDelta()

    self.vel = {x = 0 , y = 0}
end
function Player:update()
    self:input()
    self:move()
end

function Player:render()
-- love.graphics.rectangle("fill", self.aabb.x , self.aabb.y, self.aabb.w,self.aabb.h)

    love.graphics.push()
    love.graphics.translate(self.aabb.x, self.aabb.y)
    love.graphics.draw(systems.sprites.player.idle,0,0,self.rotation,0.25,0.25,100,100)
    love.graphics.pop()
end



return Player