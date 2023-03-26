require "utils"
local Crate = require "./classes/crate"


local crateManager = {}
function crateManager:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    

    self.crates = {}
    self.ones = true

    return deepcopy(obj)
end

function crateManager:setSystems(systems)
    self.systems = systems
end


function crateManager:spawnACrate()
    if not self.ones then return end

    local crate = Crate:new(
        love.mouse.getX(),
        love.mouse.getY()
        -- love.math.random(40,self.systems.fullWidth - 40),
        -- love.math.random(40,self.systems.fullHeight - 40)
    )

    self.ones = false   
    for i = 1 , 4 do 
        crate.crateUi:addItem(self.systems.items[1])
    end
    self.systems.uiManager:add(crate.crateUi)
    table.insert(self.crates,crate) 

    self.systems.cameraManager.cameras[self.systems.currRoom]:addSprite(crate)
end

function crateManager:update()
    for i = #self.crates , 1 , -1 do
        self.crates[i]:update(self.systems)
        if #self.crates[i].crateUi.items == 0 then
            self.crates[i].empty = true
        end
    end 

    if love.keyboard.isDown("space") then
        self:spawnACrate()
    else 
        self.ones = true
    end
end


function crateManager:render()
    -- for _ , crate in pairs(self.crates) do
        -- crate:render()
    -- end 
end

return crateManager