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

function ZombieManager:addZombie(zombie)
    zombie.target = self.player 
    table.insert(self.zombies,zombie)
end

function ZombieManager:update() 
    local deadZombiesIndxes = {}
    for _ , zombie in pairs(self.zombies) do 
        if zombie.dead then
            table.insert(deadZombiesIndxes,_)
        end
        zombie:update()
    end


    for i = #deadZombiesIndxes , 1 ,-1 do 
        table.remove(self.zombies,deadZombiesIndxes[i])
    end
end

function ZombieManager:render() 
    for _ , zombie in pairs(self.zombies) do 
        zombie:render()
    end
end



return ZombieManager