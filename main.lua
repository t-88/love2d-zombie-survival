local Player = require "./classes/player"

local GameStateManager = require "./classes/gameStateManager"
local systems = require "systems"
local shaders = require "shaders"


local player
local gameStateManager

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    player = Player:new()
    systems.init(player)
    shaders.init()

    gameStateManager = GameStateManager:new()
    gameStateManager:load(systems,shaders)
end

function love.update()
    if love.keyboard.isDown("escape") then love.event.quit() end
    gameStateManager:update()



end




function love.draw()
    
    gameStateManager:render()


end