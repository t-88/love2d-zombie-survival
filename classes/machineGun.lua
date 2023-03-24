require "utils"
local Entity = require "./classes/entity"
local Bar = require "./classes/ui/bar"


local MachineGun = Entity:new()
function MachineGun:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.aabb.x = 400
    self.aabb.y = 400
    self.aabb.w = 35
    self.aabb.h = 35

    self.player = {}
    self.interationRaduis = 40
    self.progrationPrecentage = 0
    

    self.allStates = {
        notActive = "not-active",
        active = "active",
    }

    self.bar = Bar:new(0,0,100,self.aabb.x - 10,self.aabb.y - 40,60,10)
    self.state = self.allStates.notActive
    return deepcopy(obj)
end


function MachineGun:update()
    local distance = (self:getCenterOfRect().x - self.player.aabb.x) * (self:getCenterOfRect().x - self.player.aabb.x) +  (self:getCenterOfRect().y - self.player.aabb.y) * (self:getCenterOfRect().y - self.player.aabb.y)
    if distance <= self.interationRaduis * self.interationRaduis then
        self.state = self.allStates.active
    else
        self.state = self.allStates.notActive
    end

    if(self.state == self.allStates.active) then
        if love.keyboard.isDown("e") then
            self.progrationPrecentage = self.progrationPrecentage  + 0.2 
            self.bar:setVal(self.progrationPrecentage)
        end
    end

end

function MachineGun:renderDebug()
    love.graphics.print(math.floor(self.progrationPrecentage),self.aabb.x + 15,self.aabb.y - 20)
    if self.state == self.allStates.active then
        love.graphics.print("press E to fix",self.aabb.x - 20,self.aabb.y - 40)
        -- setColor(1,1,1,1)
    end
    -- love.graphics.circle("lisne", self.aabb.x + self.aabb.w / 2, self.aabb.y + self.aabb.h / 2, self.interationRaduis)    
    -- setColor(1,1,1,1)s

end

function MachineGun:render()
    setColor(self.color[1],self.color[2],self.color[3],self.color[4])
    love.graphics.rectangle("fill", self.aabb.x, self.aabb.y, self.aabb.w, self.aabb.h)
    setColor(1,1,1,1)


    self.bar:render()

    self:renderDebug()
end
return MachineGun