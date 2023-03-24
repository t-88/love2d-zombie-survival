local Player = require "./classes/player"
local Zombie = require "./classes/zombie"

local Piston =require "./classes/piston"
local Shootgun =require "./classes/shootgun"
local Rifle = require "./classes/rifle"

local systems = require "systems"


local player
local zombie
local piston
local rifle
local shootgun


local lightShader
local lightShaderText = [[
    #define NUM_LIGHTS 32
    struct Light {
        vec2 pos;
        vec3 diffuse;
        float power;
    };

    extern Light lights[NUM_LIGHTS];
    extern int lightCount;

    const float constant = 1.0;
    const float linear = 0.09;
    const float quadratic = 0.09;

    extern vec2 screen; 

    vec4 effect(vec4 color , Image image , vec2 uvs , vec2 screen_coords) {
        vec4 pixel = Texel(image,uvs);

        vec2 norm_screen = screen_coords / screen;
        vec3 diffuse = vec3(0);

        for(int i = 0; i < lightCount; i++) {
            Light light = lights[i];
            vec2 norm_pos = light.pos / screen;

            float dis =  length(norm_pos - norm_screen) * light.power;
            float attenuation = 1.0 / (constant + linear * dis + quadratic * (dis * dis)); 
        
            diffuse += light.diffuse * attenuation;
        }
        diffuse = clamp(diffuse,0.0,1.0);

        return pixel * vec4(diffuse,1.0);
    }
]]



function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    player = Player:new()
    systems.initSys(player)
    -- roomManager = RoomManager:new()



    rifle = Rifle:new()
    piston = Piston:new()
    shootgun = Shootgun:new()
    systems.weaponManager:addWeapon(rifle)
    systems.weaponManager:addWeapon(shootgun)

    lightShader = love.graphics.newShader(lightShaderText)
end

function love.update()
    if love.keyboard.isDown("escape") then love.event.quit() end

    -- roomManager:update()
    player:update()
    systems.update()

end

function addLightSource(index,pos,diffuse,power)
    lightShader:send("lights["..index.."].pos",{pos.x,pos.y})
    lightShader:send("lights["..index.."].diffuse",diffuse)
    lightShader:send("lights["..index.."].power",power)
end

function love.draw()
    local count = 0 

    love.graphics.setShader(lightShader)
        lightShader:send("screen",{
            love.graphics.getWidth(),
            love.graphics.getHeight()
        })
        lightShader:send("lightCount",1 + #systems.bulletManager.bullets)
        addLightSource(count,
                     {x = systems.player.aabb.x + systems.player.aabb.w / 2,y = systems.player.aabb.y + systems.player.aabb.h / 2},
                     {1,1,1},
                     55
                    )

                
        count = count + 1
        for _ , bullet in pairs(systems.bulletManager.bullets) do
            addLightSource(count,
            {x = bullet.aabb.x,y = bullet.aabb.y},
            {1,1,1},
            80
           )
            count = count + 1
        end


        systems.render()
    love.graphics.setShader()
    
    systems.renderUI()



end