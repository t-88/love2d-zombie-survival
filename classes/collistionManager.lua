require "utils"
local CollistionManager = {}
function CollistionManager:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.onCollistion = {}
    self.onStatic = {}
    
    return deepcopy(obj)
end


function CollistionManager:addCollistionAABB(entity1,entity2,callback,callbackNot)
    callbackNot = callbackNot or function() end
    local collistionCallback = {entity1 = entity1,entity2 = entity2,callback = callback,callbackNot = callbackNot}
    table.insert(self.onCollistion,collistionCallback)
end

function CollistionManager:addCollistionWithStatic(entity1,entity2,callback)
    local collistionCallback = {entity1 = entity1,entity2 = entity2,callback = callback}
    table.insert(self.onStatic,collistionCallback)
end

function CollistionManager:update()
    for i = #self.onCollistion , 1 , -1 do 
        if AABB(self.onCollistion[i].entity1.aabb,self.onCollistion[i].entity2.aabb) then
            if self.onCollistion[i].entity1.dead or self.onCollistion[i].entity2.dead then
                table.remove(self.onCollistion,i)
            else
                self.onCollistion[i].callback(self.onCollistion[i].entity1,self.onCollistion[i].entity2)
            end
        else 
            self.onCollistion[i].callbackNot(self.onCollistion[i].entity1,self.onCollistion[i].entity2)
        end
    end

    for i = #self.onStatic , 1 , -1 do 
        if AABB(self.onStatic[i].entity1.aabb,self.onStatic[i].entity2.aabb) then
            if self.onStatic[i].entity2.dead then
                table.remove(self.onStatic,i)
            else
                local depthAndNormal = {}
                rectToRect(self.onStatic[i].entity1,self.onStatic[i].entity2,depthAndNormal)
                self.onStatic[i].entity2.aabb.x = self.onStatic[i].entity2.aabb.x - depthAndNormal.depth * depthAndNormal.normal[1]  
                self.onStatic[i].entity2.aabb.y = self.onStatic[i].entity2.aabb.y - depthAndNormal.depth * depthAndNormal.normal[2]  

                self.onStatic[i].callback(self.onStatic[i].entity1,self.onStatic[i].entity2)
            end 
        end
    end


end

return CollistionManager