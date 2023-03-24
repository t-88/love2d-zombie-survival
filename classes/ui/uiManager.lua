require 'utils'
local InventoryBar = require "classes/ui/inventoryBar"
local currWeapon = require "classes/ui/currWeapon"
local Bars = require "classes/ui/bars"

local UiManager = {}
function UiManager:new(obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self
    
    self.inventoryBar = InventoryBar:new()
    self.currWeapon = currWeapon:new()
    self.bars = Bars:new()
    self.children = {
        self.inventoryBar,
        self.currWeapon,
        self.bars

    }
    



    return obj
end

function UiManager:update()
    for _ , child in pairs(self.children) do 
        child:update()
    end
end

function UiManager:render()

    for _ , child in pairs(self.children) do 
        child:render()
    end
end

return UiManager