require "utils"
local Entity = require "./classes/entity"


local Weapon = {}
function Weapon:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    
    self.damage = 10
    self.ammo = 10
    self.currAmmo = 10
    self.maxCurrAmmo = 10
    
    self.useDelay = 1
    self.useTimer = 0
    self.shakeVel = {x = 2 , y = 2}
    


    return deepcopy(obj)
end


function Weapon:update()
end

function Weapon:render()
end

return Weapon