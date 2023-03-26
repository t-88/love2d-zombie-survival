require "utils"
local Zombie = require "./classes/zombie"

local ZombieManager = {}
function ZombieManager:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    
    self.zombies = {}
    self.player = {}

    return deepcopy(obj)
end
 

function ZombieManager:setSystems(systems)
    self.systems = systems
end

function ZombieManager:addZombie(zombie)
    self.systems.collistionManager:addCircleCollistion(
            zombie,
            self.systems.player,
            function() self.systems.player:takeDamage(1) end,
            nil,
            20,
            10
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

function ZombieManager:update() 
    for i = #self.zombies , 1 , -1  do
        if self.zombies[i].dead then table.remove(self.zombies,i) end
        
        local inRangeWithLightBomb  = false
        local zombieCircle = {x = self.zombies[i].aabb.x ,y = self.zombies[i].aabb.y ,raduis = self.zombies[i].raduis}
        for _ , lightBomb in pairs(self.systems.weaponManager.lightBombs) do 
            local lightBombCircle = {x = lightBomb.aabb.x ,y = lightBomb.aabb.y ,raduis = lightBomb.raduis}

            if circleToCircle(lightBombCircle,zombieCircle) then
                inRangeWithLightBomb = true
                    self.zombies[i]:update(lightBomb)
                break
            end
        end
        if not inRangeWithLightBomb then self.zombies[i]:update(self.systems.player) end
        
    end
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