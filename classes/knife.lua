require "utils"
local Entity =  require "./classes/entity" 

local Knife = {}
function Knife:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.damage = 3 
    self.hitBoxSize = {w = 10,h = 30}
    self.rotation = 0
    self.player = nil

    return deepcopy(obj)
end

function Knife:hit()
    if self.used then return end

end

function Knife:update(player)
    local mouseX , mouseY = love.mouse.getPosition()
    self.rotation = math.atan2(mouseY - player.aabb.y,mouseX - player.aabb.x)


    if love.mouse.isDown(1) then
        self:hit()
    else 
        self.used = false
    end
end

function Knife:render(player)

    love.graphics.push()
        love.graphics.translate(player.aabb.x,player.aabb.y)
        love.graphics.rotate(self.rotation)
        love.graphics.rectangle('line',0,0,self.hitBoxSize.w,self.hitBoxSize.h)
    love.graphics.pop()
end




return Knife