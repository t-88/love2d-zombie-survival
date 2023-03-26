require "utils"
local BulletManager = {}
function BulletManager:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    
    self.bullets = {}

    return deepcopy(obj)
end


function BulletManager:setSystems(systems)
    self.systems = systems
end     


function BulletManager:addBullet(bullet)     
    table.insert(self.bullets,bullet)
    self.systems.camera:addSprite(bullet)
    
end

function BulletManager:update() 
    for i = #self.bullets, 1 , -1 do 
        self.bullets[i]:update()
        if self.bullets[i].dead then
            table.remove(self.bullets,i)
        end
    end


end



return BulletManager