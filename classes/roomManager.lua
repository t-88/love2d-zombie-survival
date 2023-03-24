require "utils"
local SpawnRoom = require "./classes/rooms/spawnRoom"
local HouseRoom = require "./classes/rooms/houseRoom"
local Car1Room = require "./classes/rooms/car1Room"
local ChestRoom = require "./classes/rooms/chestRoom"
local DangerRoom = require "./classes/rooms/dangerRoom"


local RoomManager = {}
function RoomManager:new(gridSize,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.spawnRoom = SpawnRoom:new(  gridSize)
    self.houseRoom = HouseRoom:new(  gridSize)
    self.car1Room = Car1Room:new(    gridSize)
    self.chestRoom = ChestRoom:new(  gridSize)
    self.dangerRoom = DangerRoom:new(gridSize)
    

    self.rooms = {
        spawn = self.spawnRoom,
        house =  self.houseRoom,    
        car1 =  self.car1Room,
        chest = self.chestRoom,
        danger = self.dangerRoom,
    }

    return deepcopy(obj)
end

function RoomManager:setSystems(systems)
    for _ ,room in pairs(self.rooms) do 
        room:setSystems(systems)
    end
end

function RoomManager:update(currRoom)
    self.rooms[currRoom]:update()
end

function RoomManager:render(currRoom)
    self.rooms[currRoom]:render()
end

return RoomManager