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

    self.empty = false

    self.origin = {
        x = 10,
        y = 10,
    }
    self.rotation = love.math.random(0,314) / 100
    self.raduis = 30

    self.isOpen = false
    self.isOnTheGround = false
    self.renderIndex = 0
    self.zIndex = 1
    return deepcopy(obj)
end
function Crate:init(player,offset)
    self.player = player
    self.offset = offset
end

function Crate:update(systems)
    if self.scale > self.minScale then self.scale = self.scale - love.timer.getDelta() 
    else  
        self.scale = self.minScale
        self.isOnTheGround = true
        self.zIndex = -1
    end

    if #self.crateUi.items == 0 then self.empty = true end
    
    if self.empty then
        self.spriteName = "crate"
        self.isOpen = false
        self.crateUi.visible = false
        self.player.isInCrate = false
        return
    end 

    if not self.isOnTheGround then return end

    local entity2 = {   
        x = self.player.aabb.x + self.offset.x,
        y = self.player.aabb.y + self.offset.y,
        raduis = self.player.raduis
    } 
    local entity1 = {   
        x = self.aabb.x + self.offset.x,
        y = self.aabb.y + self.offset.y,
        raduis = self.raduis + 10
    } 
    if circleToCircle(entity1,entity2) then
        self.spriteName = "crateOutlined"
        if not self.isOpen and love.keyboard.isDown("e") and not self.player.isInCrate then
            self.isOpen = true
            self.crateUi.visible = true
            self.player.isInCrate = true
        end
    else 
        self.spriteName = "crate"
        if self.isOpen then
            self.isOpen = false
            self.crateUi.visible = false
            self.player.isInCrate = false
        end
    end


end

return Crate