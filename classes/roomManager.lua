require "utils"
local SpawnRoom = require "./classes/rooms/spawnRoom"



local RoomManager = {}
function RoomManager:new(gridSize,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.spawnRoom = SpawnRoom:new(  gridSize)

    

    self.rooms = {self.spawnRoom}

    return deepcopy(obj)
end

function RoomManager:setSystems(systems)
    for _ ,room in pairs(self.rooms) do 
        room:setSystems(systems)
    end
end

function RoomManager:update()
    self.rooms[1]:update()
end

function RoomManager:render()
    self.rooms[1]:render()
end

return RoomManager