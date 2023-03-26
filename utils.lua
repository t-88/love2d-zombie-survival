-- Save copied tables in `copies`, indexed by original table.
function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function circleToCircleResponse(entity1,entity2) 
    local diff = {
        x = entity1.x - entity2.x,
        y = entity1.y - entity2.y,
    }
    local magSqr = ((diff.x * diff.x) + (diff.y * diff.y)) 
    if  magSqr < (entity1.raduis + entity2.raduis) * (entity1.raduis + entity2.raduis) then
        local distance = math.sqrt(magSqr)
        diff.x = diff.x / distance
        diff.y = diff.y / distance
        distance =  distance - (entity1.raduis + entity2.raduis)

        return  true , diff , distance
    end
    return false 

end

function circleToCircle(entity1,entity2)
    local diff = {
        x = entity1.x - entity2.x,
        y = entity1.y - entity2.y,
    }
    local magSqr = ((diff.x * diff.x) + (diff.y * diff.y)) 
    if  magSqr < (entity1.raduis + entity2.raduis) * (entity1.raduis + entity2.raduis) then
        return  true
    end
    return false 
end

function aabbToAABB(aabb1,aabb2)
    return aabb1.x < aabb2.x + aabb2.w and aabb1.y < aabb2.y + aabb2.h and  aabb1.x + aabb1.w > aabb2.x  and   aabb1.y + aabb1.h > aabb2.y  
end

function map(x,  in_min,  in_max,  out_min,  out_max)
    local range1 = in_max - in_min
    local range2 = out_max - out_min
    local val = x - in_min

    return val * (range2 / range1) + out_min
end



setColor = love.graphics.setColor
drawRect = love.graphics.rectangle