require "utils"
local Entity = require "./classes/entity"

local Drop = Entity:new()
function Drop:new(x,y,dir,spriteName,scale,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    
    self.dir = dir

    self.vel = {x = 6,y = 6}
    self.friction = 0.92 +love.math.random(0,2) / 100 
    self.isDroped = false

    self.spriteName = spriteName or nil
    self.savedSpriteName = spriteName or nil
    self.scale = scale or 1.4   
    self.aabb  = { x = x, y = y , w = 20 , h = 20}
    self.rotation = love.math.random(0,314) / 100
    
    self.isActive = false    

    self.index = 0
    self.raduis = 20
    self.entity = nil

    return deepcopy(obj)
end


function Drop:init(player,item,offset,callback)
    self.player = player
    self.entity = item
    self.offset = offset
    self.callback = callback or function() end
end


function Drop:update()
    if not self.isDroped then
        self.aabb.x = self.aabb.x + self.dir.x * self.vel.x 
        self.aabb.y = self.aabb.y + self.dir.y * self.vel.y 
    
    
        self.vel.x = self.vel.x * self.friction
        self.vel.y = self.vel.y * self.friction
    
    
        if self.vel.x < 0.1 and self.vel.y < 0.1 then
            self.isDroped = true    
        end 
    else 
        local playerCircle = {x = self.player.aabb.x,y = self.player.aabb.y,raduis = self.player.raduis}
        local dropCircle = {x = self.aabb.x,y = self.aabb.y,raduis = self.raduis}
        if circleToCircle(playerCircle,dropCircle) then
            self.spriteName =  self.savedSpriteName.."Outlined"
            self.callback()
        else 
            self.spriteName =  self.savedSpriteName
        end
    end
end


return Drop