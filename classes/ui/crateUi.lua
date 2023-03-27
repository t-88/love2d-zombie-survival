require "utils"
local Entity = require "./classes/entity"
local CrateUI = Entity:new()
function CrateUI:new(offset,obj)
    obj = obj or Entity:new()
    setmetatable(obj,self)
    self.__index = self

    self.items = {}
    self.offset = offset or {x = 0,y = 0}
    self.visible = false


    return deepcopy(obj)
end

function CrateUI:addItem(item)
    local crateItem = {
        spriteID = item.spriteID,
        onSelecte = item.onSelecte,
        aabb = {
            x = (#self.items % 2) * 50 + 5 * (#self.items % 2) + 1 + self.offset.x,
            y = math.floor(#self.items / 2) * 50  + 5 * (math.floor(#self.items / 2) + 1) + self.offset.y,
            w = 50,
            h = 50,
        },
    }

    table.insert(self.items,crateItem)
end


function CrateUI:update(systems)
    if not self.visible then return end

    if love.mouse.isDown(1) then
        for  i = #self.items , 1 , -1 do 
            local mouseWithOffset = {
                x = systems.mouse.aabb.x - systems.camera.offset.x,
                y = systems.mouse.aabb.y - systems.camera.offset.y,
                w = systems.mouse.aabb.w,
                h = systems.mouse.aabb.h,
            }
            if aabbToAABB(mouseWithOffset  ,self.items[i].aabb)   then
                if self.items[i].onSelecte() then
                    table.remove(self.items,i)
                end
            end
        end
    end
end

function CrateUI:render(systems)
    if not self.visible then return end
    love.graphics.push()
    love.graphics.translate(systems.camera.offset.x,systems.camera.offset.y)

    setColor(0,0,0,0.6)
    drawRect("fill",self.offset.x,self.offset.y,15 + 50 * 2,15 + 50 * 2 , 5)
    for index , item in pairs(self.items) do 
        setColor(1,1,1,0.5)
        -- local indexx = index - 1
        drawRect("fill",
            item.aabb.x + 5,
            item.aabb.y,
            50,
            50,
            5
        )
        setColor(1,1,1,1)
        love.graphics.draw(systems.sprites[item.spriteID],item.aabb.x + 5,item.aabb.y ,0 , 1.5 , 1.54)
    end 
    setColor(1,1,1,1)

    

    love.graphics.pop()

end







return CrateUI