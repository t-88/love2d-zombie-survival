require "utils"
local Zombie = require "./classes/zombie"
local Entity = require "./classes/entity"

local ZombieManager = {}
function ZombieManager:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    

    self.currLvl = 1
    self.spawnDelay = 1
    self.spawnTimer = 1
    self.maxLvl = 6
    self.killedZombieCount = 0 

    return deepcopy(obj)
end
 

function ZombieManager:setSystems(systems)
    self.systems = systems
end

function ZombieManager:init()
    self.currLvl = 1
    self.zombies = {}
    self.killedZombieCount = 0 

    self.lvls = {
        {time = 1 * 20,maxZs = 3},
        {time = 1 * 60,maxZs = 10},
        {time = 2 * 60,maxZs = 20},
        {time = 3 * 60,maxZs = 30},
        {time = 5 * 60,maxZs = 35},
        {time = 5 * 60,maxZs = 40},
    }
end


function ZombieManager:addZombie(zombie)
    self.systems.collistionManager:addCircleCollistion(
            zombie,
            self.systems.player,
            function() self.systems.player:takeDamage(1) end,
            nil,
            10,
            15
        )
    for _ , otherZombie in pairs(self.zombies) do 
        self.systems.collistionManager:addCircleCollistion(
            zombie,
            otherZombie,
            nil,
            nil,
            0.5
        )
    end
    table.insert(self.zombies,zombie)
    self.systems.camera:addSprite(zombie )
end


function ZombieManager:spawnZombie()
    self.spawnTimer =  self.spawnTimer - love.timer.getDelta() 


    if self.spawnTimer < 0 and #self.zombies < self.lvls[self.currLvl].maxZs then 
        self.spawnTimer = self.spawnDelay

        local zombie = Zombie:new()

        if love.math.random(0,1) == 0 then
            zombie.aabb.x = love.math.random(-400,self.systems.width + 400) - self.systems.camera.offset.x 
            zombie.aabb.y = love.math.random(0,1) * self.systems.height - self.systems.camera.offset.y 
        else 
            zombie.aabb.x = love.math.random(0,1) * self.systems.width - self.systems.camera.offset.x 
            zombie.aabb.y = love.math.random(-400,self.systems.height + 400) - self.systems.camera.offset.y 
        end

        self.systems.zombieManager:addZombie(zombie)
        self.systems.camera:addSprite(zombie)
    end

    if self.currLvl ~= self.maxLvl then
        self.lvls[self.currLvl].time = self.lvls[self.currLvl].time - love.timer.getDelta()  

        if self.lvls[self.currLvl].time < 0 then
            self.currLvl = self.currLvl + 1
        end 
    end 

end

function ZombieManager:update() 
    for i = #self.zombies , 1 , -1  do
        if self.zombies[i].dead then 


            local body = Entity:new()
            body.aabb.x = self.zombies[i].aabb.x; body.aabb.y = self.zombies[i].aabb.y
            body.rotation = self.zombies[i].rotation + 3.14/2
            body.origin = {x = 16 , y = 16}
            body.spriteName = "zombieBody"..love.math.random(1,4)
            body.scale = 3.2
            body.zIndex = -5
            self.systems.camera:addSprite(body)
            
            table.remove(self.zombies,i)
            self.killedZombieCount = self.killedZombieCount + 1

            goto skip_dead_zombie_update
        end
        
        local inRangeWithLightBomb  = false
        local zombieCircle = {x = self.zombies[i].aabb.x ,y = self.zombies[i].aabb.y ,raduis = self.zombies[i].raduis}
        for _ , lightBomb in pairs(self.systems.weaponManager.lightBombs) do 
            local lightBombCircle = {x = lightBomb.aabb.x ,y = lightBomb.aabb.y ,raduis = lightBomb.raduis}

            if circleToCircle(lightBombCircle,zombieCircle) then
                    inRangeWithLightBomb = true
                    self.zombies[i]:update(lightBomb,self.systems.sounds)
                break
            end
        end
        if not inRangeWithLightBomb then self.zombies[i]:update(self.systems.player,self.systems.sounds) end
        


        ::skip_dead_zombie_update::
    end
    self:spawnZombie()
end

function ZombieManager:render() 
    love.graphics.push()
    love.graphics.translate(self.systems.camera.offset.x, self.systems.camera.offset.y)
    for _ , zombie in pairs(self.zombies) do 
        zombie:render(self.systems)
    end
    love.graphics.pop()

end



return ZombieManager