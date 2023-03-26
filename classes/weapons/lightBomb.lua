require "utils"
local Entity = require "./classes/entity"
local Weapon = require "./classes/weapons/weapon"


local lightBomb = Weapon:new()
function lightBomb:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    self.used = false

    self.scale = 2


    self.vel = {x = 15,y = 15}
    self.friction = 0.96 
    self.isDroped = false

    self.deadTimer = 15
    self.empty = false
    self.origin = {
        x = 16,
        y = 16,
    }
    self.intensity = 35

    self.spriteName = "lightBomb"
    self.raduis = 200

    return deepcopy(obj)
end
function lightBomb:drop(x,y,dir)
    self.isDroped = true
    self.dir = dir
    self.aabb.x = x
    self.aabb.y = y
end


function lightBomb:update(player)
    if self.isDroped then
        self.aabb.x = self.aabb.x + self.dir.x * self.vel.x  
        self.aabb.y = self.aabb.y + self.dir.y *  self.vel.y

        self.vel.x = self.vel.x  * self.friction
        self.vel.y = self.vel.y  * self.friction

        if self.vel.x < 0.1 and self.vel.y < 0.1 then
            self.isDroped = false
        end
        return
    end

    self.deadTimer = self.deadTimer - love.timer.getDelta()
    self.intensity = self.intensity + love.timer.getDelta() * 3
    if self.deadTimer < 0 then
        self.empty = true
    end

end


return lightBomb