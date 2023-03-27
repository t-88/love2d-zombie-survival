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

function crateManager:init(player,camera,uiManager,items)
    self.player = player
    self.camera = camera
    self.uiManager = uiManager
    self.items = items
end


function crateManager:spawnACrate(x,y,all)
    local crate = Crate:new(x,y)
    crate:init(self.player,self.camera.offset)
    
    all = all or false
    local maxItems = all and 4 or love.math.random(1,4) 
    for i = 1 , maxItems do 
        crate.crateUi:addItem(self.items[love.math.random(1,4)])
    end

    self.uiManager:add(crate.crateUi)
    self.camera:addSprite(crate)
    table.insert(self.crates,crate) 
end

function crateManager:update()
    for i = #self.crates , 1 , -1 do
        self.crates[i]:update()
    end 
end

return crateManager