require "utils"
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
    zombie.target = self.systems.player
    self.systems.collistionManager:addCircleCollistion(
            zombie,
            self.systems.player,
            nil,
            nil,
            0.5
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
end

function ZombieManager:update() 
    for i = #self.zombies , 1 , -1  do  
        self.zombies[i]:update(self.systems)
        if self.zombies[i].dead then
            table.remove(self.zombies,i)
        end
    end
end

function ZombieManager:render() 
    love.graphics.push()
    love.graphics.translate(self.systems.offset.x, self.systems.offset.y)
    for _ , zombie in pairs(self.zombies) do 
        zombie:render(self.systems)
    end
    love.graphics.pop()

end



return ZombieManager