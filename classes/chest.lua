require "utils"
local Entity = require "./classes/entity"

local Chest = Entity:new()
function Chest:new(x,y,w,h,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    self.aabb = {x = x , y = y , w = w , h = h}



    self.items = {}
    self.itemCount = 0

    self.itemsAABB = {}
    for i = 0 , 2 do
        table.insert(
            self.itemsAABB,   
            {aabb = {x = x + 35 * i + 5 , y = y  + 5 - 60  ,w =  30 , h = 30}})
    end
    self.itemsSprites = {}

    self.active = false
    self.pickedItem = false


    return deepcopy(obj)
end

function Chest:init(systems,roomId)
    self.systems = systems
    systems.collistionManagers[roomId]:addCollistionAABB(self,systems.player,function() self:collide() end , function() self:endCollide() end)

end
function Chest:addItem(spriteId,item,callback)
    table.insert(self.itemsSprites,{id = spriteId, item = item,  index = #self.itemsSprites + 1,callback = callback})
end

function Chest:collide()
    if love.keyboard.isDown("e") and not self.active then
        self.active = true
    end
end

function Chest:endCollide()
    self.active = false
end


function Chest:update()
    if self.active and love.mouse.isDown(1)  and not self.pickedItem then
        for _ , sprite in pairs(self.itemsSprites) do 
                if AABB(self.systems.mouse.aabb,self.itemsAABB[sprite.index].aabb) then
                    if sprite.callback(sprite.item) then
                        table.remove(self.itemsSprites,_)
                        self.pickedItem = true

                        break;
                    end
                end
        end 
    elseif not love.mouse.isDown(1) then
        self.pickedItem = false
    end
end


function Chest:render()
    setColor(self.color[1],self.color[2],self.color[3],self.color[4])
    drawRect("fill",self.aabb.x , self.aabb.y , self.aabb.w ,self.aabb.h)
    setColor(1,1,1,1)

    if self.active then 
        setColor(0,1,0,1)

        drawRect("fill",self.aabb.x , self.aabb.y - 60 , 30 * 3 +  20 , 40)

        setColor(1,0,0.5,1)
        for i = 1 , #self.itemsAABB do 
            drawRect('fill',self.itemsAABB[i].aabb.x ,self.itemsAABB[i].aabb.y,self.itemsAABB[i].aabb.w,self.itemsAABB[i].aabb.h )
        end
        setColor(1,1,1,1)

        for _ , sprite in pairs(self.itemsSprites) do
            love.graphics.draw(self.systems.sprites[sprite.id],self.itemsAABB[sprite.index].aabb.x ,self.itemsAABB[sprite.index].aabb.y)
        end
    end
end


return Chest