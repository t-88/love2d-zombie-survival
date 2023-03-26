require "utils"
local Drop = require "./classes/drop"
local Rifle = require "./classes/weapons/rifle"
local Shootgun = require "./classes/weapons/shootgun"
local Pistol = require "./classes/weapons/pistol"
local LightBomb = require "./classes/weapons/lightBomb"

local WeaponManager = {}
function WeaponManager:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    
    self.player = nil
    self.weapons = {Pistol:new()}

    self.weaponChanged = false
    self.weaponeDroped = false
    self.pickedAWeapon = false

    self.drops = {}
    self.lightBombs = {}

    return deepcopy(obj)
end


function WeaponManager:init(player,sprites,camera,width,height)
    self.currWeaponAABB = {}
    self.currWeaponAABB.w = 120
    self.currWeaponAABB.h = 80
    self.currWeaponAABB.x = width - self.currWeaponAABB.w  - 10
    self.currWeaponAABB.y = height - self.currWeaponAABB.h - 10

    self.secondWeaponAABB   = {}
    self.secondWeaponAABB.w = 100
    self.secondWeaponAABB.h = 60
    self.secondWeaponAABB.x = width - self.secondWeaponAABB.w  - 20
    self.secondWeaponAABB.y = height - self.secondWeaponAABB.h - 25 - self.currWeaponAABB.h


    self.player = player
    self.sprites = sprites
    self.camera = camera
end


function WeaponManager:addWeapon(weapon)
    weapon.player = self.player
    table.insert(self.weapons,weapon)
end

function WeaponManager:update()
    if #self.weapons == 0 then goto skip_weapon_update end

    self.weapons[1]:update(self.player)

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
        if self.weapons[1].spriteName == "lightBomb" then
            local bomb = table.remove(self.weapons,1)
            bomb:drop(
                self.player.aabb.x -  10,
                self.player.aabb.y - 10,
                {x = math.cos(self.player.rotation) , y = math.sin(self.player.rotation)}
            )
            self.camera:addSprite(bomb) 
            table.insert(self.lightBombs,bomb)
        
        else 
            local drop = Drop:new(
                self.player.aabb.x,
                self.player.aabb.y,
                {x = math.cos(self.player.rotation) , y = math.sin(self.player.rotation)},
                self.weapons[1].spriteName,
                self.weapons[1].scale
            )
            self.camera:addSprite(drop) 
            table.insert(self.drops,drop)
    
            drop:init(
                self.player,
                table.remove(self.weapons,1),
                self.camera.offset,
                function() 
                    if love.keyboard.isDown("e") and not self.pickedAWeapon then
                        self.pickedAWeapon = true
                        table.insert(self.weapons,drop.entity)
                        drop.dead = true
                    elseif not love.keyboard.isDown("e") then
                        self.pickedAWeapon = false
                    end
                end
            )
        end 

    elseif not love.keyboard.isDown("q") then self.weaponeDroped = false end 



    :: skip_weapon_update ::

    for i = #self.drops , 1 , -1 do 
        self.drops[i]:update()
        if self.drops[i].dead then table.remove(self.drops,i) end
    end
    for i = #self.lightBombs , 1 , -1 do 
        self.lightBombs[i]:update()
        if self.lightBombs[i].empty then table.remove(self.lightBombs,i) end
    end
end

function WeaponManager:render()

    -- setColor(0,0,1,1)
    -- drawRect('fill',self.currWeaponAABB.x, self.currWeaponAABB.y, self.currWeaponAABB.w , self.currWeaponAABB.h,5)
    -- setColor(1,1,1,1)

    -- setColor(1,0,1,1)
    -- drawRect('fill',self.secondWeaponAABB.x, self.secondWeaponAABB.y, self.secondWeaponAABB.w , self.secondWeaponAABB.h,5)
    -- setColor(1,1,1,1)
    -- if #self.weapons ~= 0 then 
    --     self.weapons[1]:render(self.player)

    --     love.graphics.push()
    --         love.graphics.translate(self.currWeaponAABB.x + 5, self.currWeaponAABB.y - 15)
    --         love.graphics.scale(3.5, 3.5)
    --         love.graphics.draw(self.sprites[self.weapons[1].spriteName])
    --     love.graphics.pop()
    
    --     if #self.weapons >= 2  then
    --         love.graphics.push()
    --             love.graphics.translate(self.secondWeaponAABB.x + 10, self.secondWeaponAABB.y - 10)
    --             love.graphics.scale(2.5, 2.5)
    --             love.graphics.draw(self.sprites[self.weapons[2].spriteName])
    --         love.graphics.pop()
    --     end

    --     love.graphics.print(self.weapons[1].ammo,self.currWeaponAABB.x + self.currWeaponAABB.w - 20 ,self.currWeaponAABB.y)
    --     love.graphics.print(self.weapons[1].currAmmo,self.currWeaponAABB.x ,self.currWeaponAABB.y)

    -- end

    -- for _ , drop in pairs(self.drops) do 
    --     drop:render()
    -- end
end



return WeaponManager