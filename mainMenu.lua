require 'utils'
local MainMenu = {}
function MainMenu:new(systems,shaders,changeState,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self


    self.shaders = shaders
    self.systems = systems

    self.playAABB = {
        x = 300,
        y = 300,
        h = systems.font:getHeight() * 3,
        w  = systems.font:getWidth("Play") * 3
    }
    self.exitAABB = {
        x = 300,
        y = 450,
        h = systems.font:getHeight() * 3,
        w  = systems.font:getWidth("Exit") * 3
    }

    self.buttonHover = false
    self.changeState = changeState

    self.cursorHand = love.mouse.getSystemCursor("hand")


    
    return obj
end

function MainMenu:init()
    self.mouseDown = true
    self.systems.sounds["waitingGame"]:play()
end

function MainMenu:update()
    self.buttonHover = false
    love.mouse.setCursor()

    local mouseAABB = {
        x = love.mouse.getX(),
        y = love.mouse.getY(),
        w = 5,
        h = 5,
    }
    if aabbToAABB(mouseAABB,self.playAABB) then
        love.mouse.setCursor(self.cursorHand)
        if love.mouse.isDown(1) and not self.mouseDown then
            self.changeState("gamePlay")
            self.systems.sounds["waitingGame"]:stop()

        end
    elseif aabbToAABB(mouseAABB,self.exitAABB) then
        love.mouse.setCursor(self.cursorHand)
        if love.mouse.isDown(1) and not self.mouseDown then
            self.systems.sounds["waitingGame"]:stop()
            love.event.quit()
        end
    end


    if  not love.mouse.isDown(1) then self.mouseDown = false end
end

function MainMenu:render()
    self.shaders.applyShadows(self.systems.width,self.systems.height,5)
    self.shaders.addLightSource({x = 100, y = 80},{132/255,22/255,23/255},35)
    self.shaders.addLightSource({x = 800, y = 80},{132/255,22/255,23/255},35)
    self.shaders.addLightSource({x = 400, y = 80},{132/255,22/255,23/255},35)
    love.graphics.print("Zombie Survival",50,60,0,3,3)
    
    
    self.shaders.addLightSource({x = love.mouse.getX(), y = love.mouse.getY()},{1,0,0},55)
    
    love.graphics.print("Play",300,300,0,3,3)
    love.graphics.print("Exit",300,450,0,3,3)
end



return MainMenu