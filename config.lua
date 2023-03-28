local systems = require "systems"

function love.config(t)
    t.width =  systems.width
    t.height = systems.height
    t.version = "11.4"
    t.console = false
end