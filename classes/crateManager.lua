require "utils"
local Crate = require "./classes/crate"

local crateManager = {}
function crateManager:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    

    self.crates = {}

    return deepcopy(obj)
end

function crateManager:spawnACrate()
    table.insert(self.crates,Crate:new()) 
    self.crates[#self.crates].aabb.x = love.math.random(love.graphics.getWidth() - 10)
    self.crates[#self.crates].aabb.y = love.math.random(love.graphics.getHeight() - 10)

end

function crateManager:update()
    for _ , crate in pairs(self.crates) do
        crate:update()
    end 
end


function crateManager:render()
    for _ , crate in pairs(self.crates) do
        crate:render()
    end 
end

return crateManager