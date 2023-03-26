require "utils"
local Entity = require "./classes/entity"
local CrateUi = require "./classes/ui/crateUi"

local Crate = Entity:new()
function Crate:new(x,y,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self


    self.size = 4
    self.aabb.w = 50
    self.aabb.h = 50
    self.aabb.x = x 
    self.aabb.y = y

    self.crateUi = CrateUi:new({x=x,y=y})


    self.itmes = {}
    self.used = false

    self.spriteName = "crate"
    self.maxScale = 5
    self.minScale = 2.8
    self.scale = self.maxScale

    self.origin = {
        x = 10,
        y = 10,
    }
    self.rotation = love.math.random(0,314) / 100
    self.raduis = 30

    self.isOpen = false
    self.isOnTheGround = false
    self.renderIndex = 0
    return deepcopy(obj)
end
function Crate:update(systems)
    if self.scale > self.minScale then self.scale = self.scale - love.timer.getDelta() 
    else  
        self.scale = self.minScale
        self.isOnTheGround = true
    end


    local entity2 = {   
        x = systems.player.aabb.x + systems.offset.x,
        y = systems.player.aabb.y + systems.offset.y,
        raduis = systems.player.raduis
    } 
    local entity1 = {   
        x = self.aabb.x + systems.offset.x,
        y = self.aabb.y + systems.offset.y,
        raduis = self.raduis + 10
    } 
    if circleToCircle(entity1,entity2) then
        self.spriteName = "crateOutlined"
        if not self.isOpen and love.keyboard.isDown("e") then
            self.isOpen = true
            self.crateUi.visible = true
            systems.player.isInCrate = true
        end
    else 
        if self.isOpen then
            self.spriteName = "crate"
            self.isOpen = false
            self.crateUi.visible = false
            systems.player.isInCrate = false
        end
    end

end

function Crate:render()
    setColor(self.color[1],self.color[2],self.color[3],self.color[4])
        -- love.graphics.circle("fill", self.aabb.x , self.aabb.y, self.raduis)
    setColor(1,1,1,1)
end

return Crate