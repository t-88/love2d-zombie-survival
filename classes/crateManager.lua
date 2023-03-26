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

function crateManager:init(player,camera,uiManager,items)
    self.player = player
    self.camera = camera
    self.uiManager = uiManager
    self.items = items
end


function crateManager:spawnACrate()
    if not self.ones then return end
    self.ones = false   

    local crate = Crate:new(
        love.mouse.getX(),
        love.mouse.getY()
        -- love.math.random(40,self.systems.fullWidth - 40),
        -- love.math.random(40,self.systems.fullHeight - 40)
    )
    crate:init(self.player,self.camera.offset)
    
    for i = 1 , 4 do 
        crate.crateUi:addItem(self.items[1])
    end

    self.uiManager:add(crate.crateUi)
    self.camera:addSprite(crate)
    table.insert(self.crates,crate) 
end

function crateManager:update()
    for i = #self.crates , 1 , -1 do
        self.crates[i]:update()
    end 

    if love.keyboard.isDown("space") then
        self:spawnACrate()
    else 
        self.ones = true
    end
end

return crateManager