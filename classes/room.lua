require "utils"

local Room = {}
function Room:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.player = nil
    self.id = ""
    self.boundaryRules = {}

    
    return deepcopy(obj)
end

function Room:init()
    
end

function Room:setSystems(systems)
    self.systems = systems
    self:init()
end


function Room:update()
end


function Room:render()
end


return Room