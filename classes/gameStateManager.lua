require "utils"
local MainMenu = require "mainMenu"
local GameOver = require "gameOver"
local GamePlay = require "gamePlay"

local GameStateManager = {}


function GameStateManager:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    
    self.systems = nil



    self.currState = "mainMenu"

    return obj
end

function GameStateManager:changeState(state)
    self.currState = state
    love.mouse.setCursor()

    for k,v in pairs(self.systems.zombieManager.zombies) do 
        self.systems.zombieManager.zombies[k].dead = true
        table.remove(self.systems.zombieManager.zombies, k)
    end    
    for k,v in pairs(self.systems.crateManager.crates) do 
        self.systems.crateManager.crates[k].dead = true
        table.remove(self.systems.crateManager.crates, k)
    end        

    self.states[self.currState]:init()
end

function GameStateManager:load(systems,shaders)
    self.systems = systems
    self.shaders = shaders



    self.mainMenu = MainMenu:new(systems,shaders,function(state) self:changeState(state) end)
    self.gamePlay = GamePlay:new(systems,shaders,function(state) self:changeState(state) end)
    self.gameOver = GameOver:new(systems,shaders,function(state) self:changeState(state) end)
    self.states = {gamePlay = self.gamePlay,mainMenu = self.mainMenu,gameOver = self.gameOver}


    self.states[self.currState]:init()

end

function GameStateManager:update()
    self.states[self.currState]:update()
end

function GameStateManager:render()
    self.states[self.currState]:render()

end



return GameStateManager