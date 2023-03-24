require 'utils'
local Bar = {}
function Bar:new(val,min,max,x,y,w,h,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.aabb = {x = x or 0, y = y or 0 , w = w or 0 , h = h or 0 }
    
    self.max = max or 100
    self.min = min or 0
    self:setVal(val or self.max)

    self.slope = self.aabb.w / (self.max - self.min)



    return deepcopy(obj)
end




function Bar:setVal(val)
    val = self.max - val   
    if val > self.max then val = self.max end
    if val < self.min then val = self.min end
    self.val = val
end


function Bar:update()
end

function Bar:render()
    love.graphics.rectangle('line', self.aabb.x , self.aabb.y, self.aabb.w, self.aabb.h)


    local offset = 0 + self.slope * (self.val - self.min)
    
    love.graphics.rectangle('fill',  self.aabb.x + offset  , self.aabb.y, self.aabb.w - offset , self.aabb.h)
end

return Bar