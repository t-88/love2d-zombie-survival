require "utils"
local Drop = require "./classes/drop"

local WeaponManager = {}
function WeaponManager:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    
    self.player = nil
    self.weapons = {}
    self.currWeaponIndex = 1

    self.weaponChanged = false
    self.weaponeDroped = false
    self.pickedAWeapon = false

    self.drops = {}

        
    

    return deepcopy(obj)
end

function WeaponManager:setPlayer(player)
    self.player = player

end 

function WeaponManager:setSystems(systems)
    self.systems = systems 
end
function WeaponManager:init()
    self.currWeaponAABB = {}
    self.currWeaponAABB.w = 120
    self.currWeaponAABB.h = 80
    self.currWeaponAABB.x = self.systems.width - self.currWeaponAABB.w  - 10
    self.currWeaponAABB.y = self.systems.height - self.currWeaponAABB.h - 10

    self.secondWeaponAABB   = {}
    self.secondWeaponAABB.w = 100
    self.secondWeaponAABB.h = 60
    self.secondWeaponAABB.x = self.systems.width - self.secondWeaponAABB.w  - 20
    self.secondWeaponAABB.y = self.systems.height - self.secondWeaponAABB.h - 25 - self.currWeaponAABB.h


end



function WeaponManager:addWeapon(weapon)
    table.insert(self.weapons,weapon)
end

function WeaponManager:update()
    if #self.weapons == 0 then goto skip_weapon end
    self.weapons[self.currWeaponIndex]:update(self.player)

    if #self.weapons == 2 then
        if love.keyboard.isDown('2') and not self.weaponChanged then
            local weapon = table.remove(self.weapons,1)
            table.insert(self.weapons,weapon)
            self.weaponChanged = true
        elseif not love.keyboard.isDown('2') then
            self.weaponChanged = false
        end
    end



    if love.keyboard.isDown("q") and not self.weaponeDroped then
        self.weaponeDroped = true


        local drop = Drop:new(self.systems.player.aabb.x,self.systems.player.aabb.y,{x = math.cos(self.systems.player.rotation) , y = math.sin(self.systems.player.rotation)} ,self.systems.sprites[self.weapons[1].id])
        drop.entity = table.remove(self.weapons,1)
        table.insert(self.drops,drop)
         

        self.systems.getCurrCollistionManager():addCollistionAABB(
            drop,
            self.systems.player,
            function (drop) 
                drop.isActive = true
                if not self.pickedAWeapon and love.keyboard.isDown('e') then
                    self.pickedAWeapon = true
                    table.insert(self.weapons,drop.entity)

                    for _ , some_drop in pairs(self.drops) do 
                        if some_drop == drop then
                            some_drop.dead = true
                            table.remove(self.drops,_)
                            break
                        end
                    end
                end
                if not love.keyboard.isDown('e') then
                    self.pickedAWeapon = false
                end 
            end,
            function (drop) drop.isActive = false end
        )



    elseif not love.keyboard.isDown("q") then
        self.weaponeDroped = false
    end 
    :: skip_weapon ::


    for _ , drop in pairs(self.drops) do 
        drop:update()
    end
end

function WeaponManager:render()

    setColor(0,0,1,1)
    drawRect('fill',self.currWeaponAABB.x, self.currWeaponAABB.y, self.currWeaponAABB.w , self.currWeaponAABB.h,5)
    setColor(1,1,1,1)

    setColor(1,0,1,1)
    drawRect('fill',self.secondWeaponAABB.x, self.secondWeaponAABB.y, self.secondWeaponAABB.w , self.secondWeaponAABB.h,5)
    setColor(1,1,1,1)
    if #self.weapons ~= 0 then 
        self.weapons[self.currWeaponIndex]:render(self.player)

        love.graphics.push()
            love.graphics.translate(self.currWeaponAABB.x + 5, self.currWeaponAABB.y - 15)
            love.graphics.scale(3.5, 3.5)
            love.graphics.draw(self.systems.sprites[self.weapons[1].id])
        love.graphics.pop()
    
        if #self.weapons >= 2  then
            love.graphics.push()
                love.graphics.translate(self.secondWeaponAABB.x + 10, self.secondWeaponAABB.y - 10)
                love.graphics.scale(2.5, 2.5)
                love.graphics.draw(self.systems.sprites[self.weapons[2].id])
            love.graphics.pop()
        end

        love.graphics.print(self.weapons[1].ammo,self.currWeaponAABB.x + self.currWeaponAABB.w - 20 ,self.currWeaponAABB.y)
        love.graphics.print(self.weapons[1].currAmmo,self.currWeaponAABB.x ,self.currWeaponAABB.y)

    end

    

    for _ , drop in pairs(self.drops) do 
        drop:render()
    end




    
end



return WeaponManager