local systems = require "systems"

function love.config(t)
    t.width =  systems.width
    t.height = systems.height
end