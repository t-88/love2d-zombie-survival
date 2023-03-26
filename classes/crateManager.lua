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

    local crate = Crate:new(love.mouse.getX(),love.mouse.getY())
    self.ones = false   
    for i = 1 , 4 do 
        crate.crateUi:addItem(self.systems.items[1])
    end
    self.systems.uiManager:add(crate.crateUi)
    table.insert(self.crates,crate) 

    -- self.crates[#self.crates].renderIndex = #self.systems.cameraManager.cameras[self.systems.currRoom].sprites + 1 

    self.systems.cameraManager.cameras[self.systems.currRoom]:addSprite(crate)

    -- self.systems.collistionManagers[self.systems.currRoom]:addCircleCollistionStatic(
    --     self.crates[#self.crates],
    --     self.systems.player
    -- )

end

function crateManager:update()
    for _ , crate in pairs(self.crates) do
        crate:update(self.systems)
    end 

    if love.keyboard.isDown("space") then
        self:spawnACrate()
    else 
        self.ones = true
    end
end


function crateManager:render()
    for _ , crate in pairs(self.crates) do
        crate:render()
    end 
end

return crateManager