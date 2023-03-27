require 'utils'
local GameOver = {}
function GameOver:new(systems,shaders,changeState,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self


    self.shaders = shaders
    self.systems = systems

    self.restartAABB = {
        x = 230,
        y = 300,
        h = systems.font:getHeight() * 3,
        w  = systems.font:getWidth("Restart") * 3
    }
    self.backAABB = {
        x = 300,
        y = 450,
        h = systems.font:getHeight() * 3,
        w  = systems.font:getWidth("Back") * 3
    }

    self.buttonHover = false
    self.onPlay = onPlay

    self.cursorHand = love.mouse.getSystemCursor("hand")

    self.changeState = changeState 
    
    return obj
end


function GameOver:init()
    self.mouseDown = true
    self.systems.sounds["assault"]:stop()
    self.systems.sounds["war"]:play()

end

function GameOver:update()
    self.buttonHover = false
    love.mouse.setCursor()

    local mouseAABB = {
        x = love.mouse.getX(),
        y = love.mouse.getY(),
        w = 5,
        h = 5,
    }
    if aabbToAABB(mouseAABB,self.restartAABB) then
        love.mouse.setCursor(self.cursorHand)
        if love.mouse.isDown(1) and not self.mouseDown then
            self.systems.sounds["war"]:stop()
            self.changeState("gamePlay")
        end
    elseif aabbToAABB(mouseAABB,self.backAABB) then
        love.mouse.setCursor(self.cursorHand)
        if love.mouse.isDown(1) and not self.mouseDown then
            self.systems.sounds["war"]:stop()
            self.changeState("mainMenu")
        end
    end

    if  not love.mouse.isDown(1) then self.mouseDown = false end


end

function GameOver:render()
    self.shaders.applyShadows(self.systems.width,self.systems.height,5)
    self.shaders.addLightSource({x = 100, y = 80},{132/255,22/255,23/255},35)
    self.shaders.addLightSource({x = 400, y = 80},{132/255,22/255,23/255},35)
    self.shaders.addLightSource({x = 750, y = 80},{132/255,22/255,23/255},35)
    love.graphics.print("U are Dead :(",100,60,0,3,3)
    love.graphics.print("U Killed: "..self.systems.zombieManager.killedZombieCount,300,150,0,1.5,1.5)
    
    
    self.shaders.addLightSource({x = love.mouse.getX(), y = love.mouse.getY()},{1,0,0},55)
    
    love.graphics.print("Restart",self.restartAABB.x,self.restartAABB.y,0,3,3)
    love.graphics.print("Back",self.backAABB.x,self.backAABB.y,0,3,3)
end



return GameOver