require 'utils'
local InventoryBarItem = {}
function InventoryBarItem:new(x,y,w,h,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.aabb = {x = x or 0 , y = y  or 0 , w = w or 0, h = h or 0}


    return deepcopy(obj)
end

function InventoryBarItem:update()

end

function InventoryBarItem:render()
    love.graphics.setColor(1,0,1,0.5)
    love.graphics.rectangle('fill', self.aabb.x, self.aabb.y, self.aabb.w, self.aabb.h)
    love.graphics.setColor(1,1,1,1)
end

return InventoryBarItem