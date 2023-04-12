require "utils"
local CollistionManager = {}
function CollistionManager:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.onCircleCollistionWithResponse = {}
    self.onCircleCollistionStatic = {}
    
    return deepcopy(obj)
end

function CollistionManager:init(offset)
    self.offset = offset
end     

-- function CollistionManager:addCollistionAABB(entity1,entity2,callback,callbackNot)
    -- callbackNot = callbackNot or function() end
    -- local collistionCallback = {entity1 = entity1,entity2 = entity2,callback = callback,callbackNot = callbackNot}
    -- table.insert(self.onCollistion,collistionCallback)
-- end

function CollistionManager:addCircleCollistion(entity1,entity2,callback,callbackNot,collistionPush1,collistionPush2)
    callbackNot = callbackNot or function() end
    callback = callback or function() end
    local collistionCallback = {
        entity1 = entity1,
        entity2 = entity2,
        callback = callback,
        callbackNot = callbackNot,  
        collistionPush1 = collistionPush1 or 1,
        collistionPush2 = collistionPush2 or 1 - collistionPush1,
    }
    table.insert(self.onCircleCollistionWithResponse,collistionCallback)
end

function CollistionManager:addCircleCollistionStatic(entity1,entity2)
    local collistionCallback = {
        entity1 = entity1,
        entity2 = entity2,
    }
    table.insert(self.onCircleCollistionStatic,collistionCallback)

end



function CollistionManager:update()

    for i = #self.onCircleCollistionWithResponse , 1 , -1 do
        if self.onCircleCollistionWithResponse[i].entity1.dead or self.onCircleCollistionWithResponse[i].entity2.dead then
            table.remove(self.onCircleCollistionWithResponse,i)
            goto skip_circle_collistion_response_check
        end         


        local entity1 = {   
            x = self.onCircleCollistionWithResponse[i].entity1.aabb.x + self.offset.x,
            y = self.onCircleCollistionWithResponse[i].entity1.aabb.y + self.offset.y,
            raduis = self.onCircleCollistionWithResponse[i].entity1.raduis
        }
        local entity2 = {   
            x = self.onCircleCollistionWithResponse[i].entity2.aabb.x + self.offset.x,
            y = self.onCircleCollistionWithResponse[i].entity2.aabb.y + self.offset.y,
            raduis = self.onCircleCollistionWithResponse[i].entity2.raduis
        }                        

        local collistionResponse = {}
        collided , collistionResponse.normal,collistionResponse.depth = circleToCircleResponse(entity1,entity2)
        if  collided then
            self.onCircleCollistionWithResponse[i].entity2.aabb.x = self.onCircleCollistionWithResponse[i].entity2.aabb.x + collistionResponse.depth * self.onCircleCollistionWithResponse[i].collistionPush1 * collistionResponse.normal.x  
            self.onCircleCollistionWithResponse[i].entity2.aabb.y = self.onCircleCollistionWithResponse[i].entity2.aabb.y + collistionResponse.depth * self.onCircleCollistionWithResponse[i].collistionPush1 * collistionResponse.normal.y  
            
            self.onCircleCollistionWithResponse[i].entity1.aabb.x = self.onCircleCollistionWithResponse[i].entity1.aabb.x - collistionResponse.depth * self.onCircleCollistionWithResponse[i].collistionPush2 * collistionResponse.normal.x  
            self.onCircleCollistionWithResponse[i].entity1.aabb.y = self.onCircleCollistionWithResponse[i].entity1.aabb.y - collistionResponse.depth * self.onCircleCollistionWithResponse[i].collistionPush2 * collistionResponse.normal.y  

            

            self.onCircleCollistionWithResponse[i].callback(self.onCircleCollistionWithResponse[i].entity1,self.onCircleCollistionWithResponse[i].entity2)
        end

        ::skip_circle_collistion_response_check::
    end 

    for i = #self.onCircleCollistionStatic , 1 , -1 do
        local entity2 = {   
            x = self.onCircleCollistionStatic[i].entity2.aabb.x + self.offset.x,
            y = self.onCircleCollistionStatic[i].entity2.aabb.y + self.offset.y,
            raduis = self.onCircleCollistionStatic[i].entity2.raduis
        } 
        local entity1 = {   
            x = self.onCircleCollistionStatic[i].entity1.aabb.x + self.offset.x,
            y = self.onCircleCollistionStatic[i].entity1.aabb.y + self.offset.y,
            raduis = self.onCircleCollistionStatic[i].entity1.raduis
        } 


        if self.onCircleCollistionStatic[i].entity1.dead or self.onCircleCollistionStatic[i].entity2.dead then
            table.remove(self.onCircleCollistionStatic,i)
            goto skip_circle_collistion_static_check
        end  


        local collistionResponse = {}
        collided , collistionResponse.normal,collistionResponse.depth = circleToCircleResponse(entity1,entity2)
        if  collided then
            self.onCircleCollistionStatic[i].entity2.aabb.x = self.onCircleCollistionStatic[i].entity2.aabb.x + collistionResponse.depth * collistionResponse.normal.x  
            self.onCircleCollistionStatic[i].entity2.aabb.y = self.onCircleCollistionStatic[i].entity2.aabb.y + collistionResponse.depth * collistionResponse.normal.y  
        end
        
    
        ::skip_circle_collistion_static_check::
    end


end

return CollistionManager