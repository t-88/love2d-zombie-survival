require "utils"
local CrateUi = require "classes/ui/crateUi"

local UiManager = {}
function UiManager:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    

    self.children = {
    }
    


    self.gunsUi = {
        shootgun = {
            scale = 3.2 , 
            x = 125,
            y = 100,
            drawAmmo = function(width,height,currAmmo)
                setColor(1,0,0,0.6)
                for i = 0 , 4 do 
                    if i >=  currAmmo then setColor(1,1,1,0.6)  end
                    drawRect("fill",width,height - 6 * i,8,4)
                end 
            end
        },
        rifle = {
            scale = 3.3 , 
            x = 125,
            y = 100,
            drawAmmo = function(width,height,currAmmo)
                setColor(1,0,0,0.6)
                for j = 0 , 2 do 
                    for i = 0 , 9 do
                        if (i  + j * 9) >=  currAmmo then setColor(1,1,1,0.6)  end
                        drawRect("fill",width - (8) * j,height - (4) * i,5,2)
                    end 
                end 
            end
        },
        pistol = {
            scale = 4 , 
            x = 125,
            y = 110,
            drawAmmo = function(width,height,currAmmo)
                setColor(1,0,0,0.6)
                for j = 0 , 1 do 
                    for i = 0 , 6 do
                        if (i  + j * 6) >=  currAmmo then setColor(1,1,1,0.6)  end
                        drawRect("fill",width - (8) * j,height - (4) * i,6,3)
                    end 
                end 
            end
        },
        lightBomb = {
            scale = 4 , 
            x = 135,
            y = 110,

        }
    }




    return obj
end
function UiManager:add(child)
    table.insert(self.children,child)
end
function UiManager:setSystems(systems)
    self.systems = systems
end
function UiManager:update()
    for i = #self.children , 1 , -1 do 
        self.children[i]:update(self.systems)
        if self.children[i].dead then
            table.remove(self.children,i)    
        end
    end
end

function UiManager:render()

    for _ , child in pairs(self.children) do 
        child:render(self.systems)
    end
    
    
    setColor(0,0,0,0.6)
    drawRect('fill',self.systems.width - 130,self.systems.height - 80,120,70,10)
    drawRect('fill',self.systems.width - 120,self.systems.height - 145,90,60,10)
    setColor(1,1,1)
    
    local primaryWeapon = self.systems.weaponManager.weapons[1]
    local secondWeapon = self.systems.weaponManager.weapons[2]
    if primaryWeapon then
        love.graphics.draw(self.systems.sprites[primaryWeapon.spriteName],self.systems.width - self.gunsUi[primaryWeapon.spriteName].x,self.systems.height - self.gunsUi[primaryWeapon.spriteName].y,0, self.gunsUi[primaryWeapon.spriteName].scale)
        
        setColor(1,1,1)
        love.graphics.print(primaryWeapon.ammo,self.systems.width - 125,self.systems.height - 30)
        self.gunsUi[primaryWeapon.spriteName].drawAmmo(self.systems.width - 140,self.systems.height - 20,primaryWeapon.currAmmo)
    end
    if secondWeapon then
        love.graphics.draw(self.systems.sprites[secondWeapon.spriteName],self.systems.width - self.gunsUi[secondWeapon.spriteName].x  + 15,self.systems.height - self.gunsUi[secondWeapon.spriteName].y - 55,0, self.gunsUi[secondWeapon.spriteName].scale- 1)
    end


    setColor(1,1,1,0.5)
    drawRect('line',self.systems.width - 210,10,200,20,5)
    setColor(1,0,0,0.8)
    drawRect('fill',
             self.systems.width - 210+ map(self.systems.player.health,0,100,200,0),
             10,
             map(self.systems.player.health,0,100,0,200),
             20,
             5
    )
    setColor(1,1,1,1)





end

return UiManager