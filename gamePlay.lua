require "utils"
local Zombie = require "./classes/zombie"


local GamePlay = {}
function GamePlay:new(systems,shaders,changeState,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.systems = systems
    self.shaders = shaders
    self.changeState = changeState



    return obj
end

function GamePlay:init()
    self.systems.camera.sprites = {}
    self.systems.camera:init(self.systems)



    self.systems.player.health = 100
    self.systems.player.aabb.x = 400
    self.systems.player.aabb.y = 400 


    self.systems.crateManager.crates = {}   
    self.systems.crateManager:init(self.systems.player,self.systems.camera,self.systems.uiManager,self.systems.items)
    self.systems.crateManager:spawnACrate(300,300,true)



    self.systems.zombieManager:init()   
    self.systems.nextCrateTime = 0

    self.systems.sounds["assault"]:play()


end


function GamePlay:update()
    self.systems.mouse.aabb.x , self.systems.mouse.aabb.y = love.mouse.getPosition() 

    self.systems.collistionManager:update()
    self.systems.zombieManager:update()
    self.systems.crateManager:update()
    self.systems.weaponManager:update()
    self.systems.bulletManager:update()
    self.systems.camera:update(self.systems.player)
    self.systems.player:update()
    self.systems.uiManager:update()


    if self.systems.player.health <= 0 then self.changeState("gameOver") end


    self.systems.nextCrateTime = self.systems.nextCrateTime + love.timer.getDelta()
    if self.systems.nextCrateTime > self.systems.maxCrateTime then
        self.systems.nextCrateTime = 0
        self.systems.crateManager:spawnACrate(
            love.math.random(-self.systems.camera.offset.x + 100 , self.systems.width  -  self.systems.camera.offset.x - 100),
            love.math.random(-self.systems.camera.offset.y + 100 , self.systems.height - self.systems.camera.offset.y - 100)
        )
    end
end

function GamePlay:setLightSources()
    self.shaders.addLightSource(
        {x = self.systems.player.aabb.x + self.systems.camera.offset.x,y = self.systems.player.aabb.y + self.systems.camera.offset.y},
        {1,1,1},
        30
    )

    for _ , bullet in pairs(self.systems.bulletManager.bullets) do
        self.shaders.addLightSource(
        {x = bullet.aabb.x + self.systems.camera.offset.x,y = bullet.aabb.y + self.systems.camera.offset.y},
        {1,1,1},
        120
       )
    end

    for _ , lightBomb in pairs(self.systems.weaponManager.lightBombs) do
        self.shaders.addLightSource(
        {x = lightBomb.aabb.x + self.systems.camera.offset.x,y = lightBomb.aabb.y + self.systems.camera.offset.y},
        {1,0,0},
        lightBomb.intensity
       )
    end
    

    local crate = self.systems.crateManager.crates[#self.systems.crateManager.crates]
    if crate and not crate.empty then
        self.shaders.addLightSource(
            {x = crate.aabb.x + self.systems.camera.offset.x,y = crate.aabb.y + self.systems.camera.offset.y},
            {41/255,171/255,135/255},
            80
       )   
    end

end


function GamePlay:render()
    local crateLight = self.systems.crateManager.crates[#self.systems.crateManager.crates] ~= nil and 1 or 0
    self.shaders.applyShadows(self.systems.width,self.systems.height,1 + #self.systems.bulletManager.bullets + self.systems.player.shootEffect.alive + crateLight + #self.systems.weaponManager.lightBombs)
    self:setLightSources()

    self.systems.camera:render()
    self.systems.zombieManager:render()

    love.graphics.setShader()


    self.systems.uiManager:render(systems)
end



return GamePlay