local shaders = {}
local shadowShaderCode = [[
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


shaders.init = function()
    shaders.shadow = love.graphics.newShader(shadowShaderCode)

end


return shaders