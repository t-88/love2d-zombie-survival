require "utils"
local CrateUi = require "classes/ui/crateUi"

local UiManager = {}
function UiManager:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    

    self.children = {
    }
    



    return obj
end
function UiManager:add(child)
    table.insert(self.children,child)
end
    function UiManager:setSystems(systems)
    self.systems = systems
end
function UiManager:update()
    for i = #self.children , 1 , -1 do 
        self.children[i]:update(self.systems)
        if self.children[i].dead then
            table.remove(self.children,i)    
        end
    end
end

function UiManager:render()

    for _ , child in pairs(self.children) do 
        child:render(self.systems)
    end
end

return UiManager