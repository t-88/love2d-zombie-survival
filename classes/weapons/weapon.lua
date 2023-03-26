require "utils"
local Entity = require "./classes/entity"


local Weapon = Entity:new()
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

    
    self.reloadTime = 1
    self.reloadDelay = 1
    self.haveToReload = false

    return deepcopy(obj)
end


function Weapon:reload()
    if love.keyboard.isDown("r") and not self.haveToReload and not self.used then
        self.haveToReload = true
    end

    if self.haveToReload then
        self.reloadTime = self.reloadTime - love.timer.getDelta()
        if self.reloadTime < 0 then
            self.haveToReload = false
            self.reloadTime = self.reloadDelay

            if self.ammo+ self.currAmmo >= self.maxCurrAmmo then
                self.ammo = self.ammo - self.maxCurrAmmo + self.currAmmo 
                self.currAmmo = self.maxCurrAmmo
            else 
                self.currAmmo = self.currAmmo + self.ammo 
                self.ammo = 0 
            end
            
        end
    end
end

function Weapon:update()
end

function Weapon:render()
end

return Weapon