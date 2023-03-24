require "utils"
local Camera = require "./classes/camera"

local CameraManager = {}
function CameraManager:new(systems,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self


    self.spawnCamera = Camera:new()
    self.spawnCamera.smallRect = {x = systems.gridSize * 4,y = systems.gridSize * 4 , w = systems.gridSize * 14 , h = systems.gridSize * 10}
    self.spawnCamera.fixed = true
    self.spawnCamera.color = {1,0,0,1}

    self.spawnCamera.startShake = true

    self.car1Camera = Camera:new()
    self.car1Camera.smallRect = {x = systems.gridSize * 4,y = systems.gridSize * 4 , w = systems.gridSize * 14 , h = systems.gridSize * 10}
    self.car1Camera.fixed = true
    self.car1Camera.color = {0,1,0,1}



    self.houseCamera = Camera:new()
    self.houseCamera.smallRect = {x = systems.gridSize * 4,y = systems.gridSize * 4 , w = systems.gridSize * 14 , h = systems.gridSize * 10}
    self.houseCamera.fixed = true
    self.houseCamera.color = {0,0,1,1}

    self.dangerCamera = Camera:new()
    self.dangerCamera.smallRect = {x = systems.gridSize * 4,y = systems.gridSize * 4 , w = systems.gridSize * 14 , h = systems.gridSize * 10}
    self.dangerCamera.fixed = true
    self.dangerCamera.color = {1,0,1,1}

    self.chestCamera = Camera:new()
    self.chestCamera.smallRect = {x = systems.gridSize * 4,y = systems.gridSize * 4 , w = systems.gridSize * 14 , h = systems.gridSize * 10}
    self.chestCamera.fixed = true
    self.chestCamera.color = {1,1,1,1}

    self.cameras = {
        spawn = self.spawnCamera,
        house = self.houseCamera,
        danger = self.dangerCamera,
        car1 = self.car1Camera,
        chest = self.chestCamera
    }

    return obj
end

function CameraManager:setSystems(systems)
    self.systems = systems
end


function CameraManager:update(currRoom)
    self.cameras[currRoom]:update(self.systems.player)
end

function CameraManager:render(currRoom)
    self.cameras[currRoom]:render(self.systems.player)
end

return CameraManager