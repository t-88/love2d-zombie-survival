require "utils"
local CollistionManager = {}
function CollistionManager:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.onCollistion = {}
    self.onCircleCollistionWithResponse = {}
    self.onCircleCollistionStatic = {}
    self.onStatic = {}
    
    return deepcopy(obj)
end

function CollistionManager:setSystems(systems)
    self.systems = systems
end     
function CollistionManager:addCollistionAABB(entity1,entity2,callback,callbackNot)
    callbackNot = callbackNot or function() end
    local collistionCallback = {entity1 = entity1,entity2 = entity2,callback = callback,callbackNot = callbackNot}
    table.insert(self.onCollistion,collistionCallback)
end

function CollistionManager:addCircleCollistion(entity1,entity2,callback,callbackNot,collistionPush)
    callbackNot = callbackNot or function() end
    callback = callback or function() end
    local collistionCallback = {
        entity1 = entity1,
        entity2 = entity2,
        callback = callback,
        callbackNot = callbackNot,  
        collistionPush = collistionPush or 1,
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




function CollistionManager:addCollistionWithStatic(entity1,entity2,callback)
    local collistionCallback = {entity1 = entity1,entity2 = entity2,callback = callback}
    table.insert(self.onStatic,collistionCallback)
end

function CollistionManager:update()
    for i = #self.onCollistion , 1 , -1 do 
        if self.onCollistion[i].entity1.dead or self.onCollistion[i].entity2.dead then
            table.remove(self.onCollistion,i)
            goto skip_aabb_collistion_check
        end 

        local entity1 =  { 
            x = self.onCollistion[i].entity1.aabb.x + self.systems.offset.x, 
            y = self.onCollistion[i].entity1.aabb.y + self.systems.offset.y, 
            w = self.onCollistion[i].entity1.aabb.w, 
            h = self.onCollistion[i].entity1.aabb.h, 
                       }
        local entity2 =  { 
            x = self.onCollistion[i].entity2.aabb.x + self.systems.offset.x, 
            y = self.onCollistion[i].entity2.aabb.y + self.systems.offset.y, 
            w = self.onCollistion[i].entity2.aabb.w, 
            h = self.onCollistion[i].entity2.aabb.h, 
        }    
       
        if AABB(entity1,entity2) then
            self.onCollistion[i].callback(self.onCollistion[i].entity1,self.onCollistion[i].entity2)
        else 
            self.onCollistion[i].callbackNot(self.onCollistion[i].entity1,self.onCollistion[i].entity2)
        end

        ::skip_aabb_collistion_check::
    end


    for i = #self.onCircleCollistionWithResponse , 1 , -1 do
        if self.onCircleCollistionWithResponse[i].entity1.dead or self.onCircleCollistionWithResponse[i].entity2.dead then
            table.remove(self.onCircleCollistionWithResponse,i)
            goto skip_circle_collistion_response_check
        end         


        local entity1 = {   
            x = self.onCircleCollistionWithResponse[i].entity1.aabb.x + self.systems.offset.x,
            y = self.onCircleCollistionWithResponse[i].entity1.aabb.y + self.systems.offset.y,
            raduis = self.onCircleCollistionWithResponse[i].entity1.raduis
        }
        local entity2 = {   
            x = self.onCircleCollistionWithResponse[i].entity2.aabb.x + self.systems.offset.x,
            y = self.onCircleCollistionWithResponse[i].entity2.aabb.y + self.systems.offset.y,
            raduis = self.onCircleCollistionWithResponse[i].entity2.raduis
        }                        

        local collistionResponse = {}
        collided , collistionResponse.normal,collistionResponse.depth = circleToCircleResponse(entity1,entity2)
        if  collided then
            self.onCircleCollistionWithResponse[i].entity2.aabb.x = self.onCircleCollistionWithResponse[i].entity2.aabb.x + collistionResponse.depth * self.onCircleCollistionWithResponse[i].collistionPush * collistionResponse.normal.x  
            self.onCircleCollistionWithResponse[i].entity2.aabb.y = self.onCircleCollistionWithResponse[i].entity2.aabb.y + collistionResponse.depth * self.onCircleCollistionWithResponse[i].collistionPush * collistionResponse.normal.y  
            
            self.onCircleCollistionWithResponse[i].entity1.aabb.x = self.onCircleCollistionWithResponse[i].entity1.aabb.x - collistionResponse.depth * (1 - self.onCircleCollistionWithResponse[i].collistionPush) * collistionResponse.normal.x  
            self.onCircleCollistionWithResponse[i].entity1.aabb.y = self.onCircleCollistionWithResponse[i].entity1.aabb.y - collistionResponse.depth * (1 - self.onCircleCollistionWithResponse[i].collistionPush) * collistionResponse.normal.y  

            

            self.onCircleCollistionWithResponse[i].callback(self.onCircleCollistionWithResponse[i].entity1,self.onCircleCollistionWithResponse[i].entity2)
        end

        ::skip_circle_collistion_response_check::
    end 

    for i = #self.onCircleCollistionStatic , 1 , -1 do
        local entity2 = {   
            x = self.onCircleCollistionStatic[i].entity2.aabb.x + self.systems.offset.x,
            y = self.onCircleCollistionStatic[i].entity2.aabb.y + self.systems.offset.y,
            raduis = self.onCircleCollistionStatic[i].entity2.raduis
        } 
        local entity1 = {   
            x = self.onCircleCollistionStatic[i].entity1.aabb.x + self.systems.offset.x,
            y = self.onCircleCollistionStatic[i].entity1.aabb.y + self.systems.offset.y,
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

    -- for i = #self.onStatic , 1 , -1 do 
    --     if AABB(self.onStatic[i].entity1.aabb,self.onStatic[i].entity2.aabb) then
    --         if self.onStatic[i].entity2.dead then
    --             table.remove(self.onStatic,i)
    --         else
    --             local depthAndNormal = {}
    --             rectToRect(self.onStatic[i].entity1,self.onStatic[i].entity2,depthAndNormal)
    --             self.onStatic[i].entity2.aabb.x = self.onStatic[i].entity2.aabb.x - depthAndNormal.depth * depthAndNormal.normal[1]  
    --             self.onStatic[i].entity2.aabb.y = self.onStatic[i].entity2.aabb.y - depthAndNormal.depth * depthAndNormal.normal[2]  

    --             self.onStatic[i].callback(self.onStatic[i].entity1,self.onStatic[i].entity2)
    --         end 
    --     end
    -- end


end

return CollistionManager