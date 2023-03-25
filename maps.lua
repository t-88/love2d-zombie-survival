local systems = require "systems"
local maps = {}


maps.init =  function()
    maps.sprites = {
        background = love.graphics.newImage("assets/map_bg.png"),
        trash = love.graphics.newImage("assets/post-apoc-tds/decor_trash.png"),
        road = love.graphics.newImage("assets/post-apoc-tds/road.png"),
        car1 = love.graphics.newImage("assets/post-apoc-tds/car1.png"),
        car2 = love.graphics.newImage("assets/post-apoc-tds/car2.png"),
        enemyBody = love.graphics.newImage("assets/post-apoc-tds/enemy_deathchest5exp.png"),
        -- wall1 = love.graphics.newImage("assets/future-tds/background/wall_window_1.png"),
        
        
    }

    maps[systems.roomsIds[1]] = {}
    table.insert(maps[systems.roomsIds[1]],{x = 0 , y = 0 ,sprite =  maps.sprites.background})
    table.insert(maps[systems.roomsIds[1]],{x = 300 , y = 350 , sprite =  maps.sprites.trash,scale = 2})
    table.insert(maps[systems.roomsIds[1]],{x = 140 , y = 350 , sprite =  maps.sprites.trash,scale = 2})
    table.insert(maps[systems.roomsIds[1]],{x = 100 , y = 65 , sprite =  maps.sprites.trash,scale = 2})
    table.insert(maps[systems.roomsIds[1]],{x = 665 , y = 235 , sprite =  maps.sprites.trash,scale = 2})
    table.insert(maps[systems.roomsIds[1]],{x = 0 , y = 550 , sprite =  maps.sprites.road,rotation = -3.14 / 2})
    table.insert(maps[systems.roomsIds[1]],{x = 125 , y = 550 , sprite =  maps.sprites.road,rotation = -3.14 / 2})
    table.insert(maps[systems.roomsIds[1]],{x = 250 , y = 550 , sprite =  maps.sprites.road,rotation = -3.14 / 2})
    table.insert(maps[systems.roomsIds[1]],{x = 375 , y = 550 , sprite =  maps.sprites.road,rotation = -3.14 / 2})
    table.insert(maps[systems.roomsIds[1]],{x = 500 , y = 550 , sprite =  maps.sprites.road,rotation = -3.14 / 2})
    table.insert(maps[systems.roomsIds[1]],{x = 625 , y = 550 , sprite =  maps.sprites.road,rotation = -3.14 / 2})
    table.insert(maps[systems.roomsIds[1]],{x = 750 , y = 550 , sprite =  maps.sprites.road,rotation = -3.14 / 2})
    table.insert(maps[systems.roomsIds[1]],{x = 220 , y = 110 , sprite =  maps.sprites.car1,scale = 3.2,rotation = 3.14 / 2})
    table.insert(maps[systems.roomsIds[1]],{x = 740 , y = 230 , sprite =  maps.sprites.enemyBody,scale = 3,rotation = 3.14 / 4})
    table.insert(maps[systems.roomsIds[1]],{x = 700 , y = 256 , sprite =  maps.sprites.car2,scale = 3.2,rotation = 3.14 / 4})
    
    -- maps[systems.roomsIds[1]] = {
        -- background = {x = 0 , y = 0 ,sprite =  maps.sprites.background},
        -- trash = {x = 300 , y = 350 , sprite =  maps.sprites.trash,scale = 2},
    -- }

end



















return maps