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

function ZombieManager:setPlayer(player)
    self.player = player
end 

function ZombieManager:setSystems(systems)
    self.systems = systems
end

function ZombieManager:addZombie(zombie)
    zombie.target = self.player 
    table.insert(self.zombies,zombie)
end

function ZombieManager:update() 
    for i = #self.zombies , 1 , -1  do  
        self.zombies[i]:update(self.systems)
        if self.zombies[i].dead then
            table.remove(self.zombies,_)
        end
    end
end

function ZombieManager:render() 
    for _ , zombie in pairs(self.zombies) do 
        zombie:render(self.systems)
    end
end



return ZombieManager