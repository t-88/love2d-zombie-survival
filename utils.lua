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



function projectRect(vertices, axis,  minAndMax) 
    minAndMax.max =  -1000000
    minAndMax.min = 1000000
    for i = 1 , 4 do
        local dot = vertices[i][1] * axis[1] + vertices[i][2] * axis[2]
        if (dot > minAndMax.max) then minAndMax.max = dot end
        if (dot < minAndMax.min) then minAndMax.min = dot end
    end
end

function rectToRect( rect1, rect2,depthAndNormal)
    local vertices1 = {
        {rect1.aabb.x ,rect1.aabb.y},
        {rect1.aabb.x + rect1.aabb.w ,rect1.aabb.y},
        {rect1.aabb.x + rect1.aabb.w ,rect1.aabb.y + rect1.aabb.h},
        {rect1.aabb.x,rect1.aabb.y + rect1.aabb.h},
    }
    local vertices2 = {
        {rect2.aabb.x ,rect2.aabb.y},
        {rect2.aabb.x + rect2.aabb.w ,rect2.aabb.y},
        {rect2.aabb.x + rect2.aabb.w ,rect2.aabb.y + rect2.aabb.h},
        {rect2.aabb.x,rect2.aabb.y + rect2.aabb.h},
    }


    depthAndNormal.normal = {0,0}
    depthAndNormal.depth = 1000000
    local minAndMaxA = {min = 0, max = 0}
    local minAndMaxB = {min = 0, max = 0}
    local dir = {}
    local axis = {}

    for i = 1 , 4 do 
        local va = vertices1[i]grid = {} 

        function initShared()
            nodeSize = 30
            SCREEN_WIDTH =  math.floor(SCREEN_WIDTH/nodeSize) * nodeSize
            SCREEN_HEIGHT = math.floor(SCREEN_HEIGHT/nodeSize) * nodeSize
            love.window.setMode(SCREEN_WIDTH ,SCREEN_HEIGHT)
            grid = Grid:new(SCREEN_WIDTH ,SCREEN_HEIGHT ,nodeSize)
        end
        local vb
        if (i + 1) % 4 == 0 then
            vb = vertices1[1]
        else 
            vb = vertices1[(i + 1) % 4]
        end

        dir = {va[1] - vb[1],va[2] - vb[2]}
        axis = {-dir[1],dir[2]}

        local mag = math.sqrt(axis[1] * axis[1] + axis[2] * axis[2])  
        axis[1] = axis[1] / mag 
        axis[2] = axis[2] / mag 

        projectRect(vertices1,axis,minAndMaxA)
        projectRect(vertices2,axis,minAndMaxB)

        if (minAndMaxA.min >= minAndMaxB.max) or  (minAndMaxB.min >= minAndMaxA.max) then
            return false
        end
        local axisDepth = math.min(minAndMaxB.max - minAndMaxA.min , minAndMaxA.max - minAndMaxB.min)
        if(depthAndNormal.depth > axisDepth) then
            depthAndNormal.depth = axisDepth
            depthAndNormal.normal = axis
        end
    end

    for i = 1 , 4 do 
        local va = vertices2[i]
        local vb
        if (i + 1) % 4 == 0 then
            vb = vertices2[1]
        else 
            vb = vertices2[(i + 1) % 4]
        end

        dir = {va[1] - vb[1],va[2] - vb[2]}
        axis = {-dir[1],dir[2]}

        local mag = math.sqrt(axis[1] * axis[1] + axis[2] * axis[2])  
        axis[1] = axis[1] / mag 
        axis[2] = axis[2] / mag 

        projectRect(vertices1,axis,minAndMaxA)
        projectRect(vertices2,axis,minAndMaxB)

        if (minAndMaxA.min >= minAndMaxB.max) or (minAndMaxB.min >= minAndMaxA.max) then
            return false
        end
        local axisDepth = math.min(minAndMaxB.max - minAndMaxA.min , minAndMaxA.max - minAndMaxB.min)
        if(depthAndNormal.depth > axisDepth) then
            depthAndNormal.depth = axisDepth
            depthAndNormal.normal = axis
        end
    end

    local centerA = {rect1.aabb.x + rect1.aabb.w / 2,rect1.aabb.y + rect1.aabb.h / 2}
    local centerB = {rect2.aabb.x + rect2.aabb.w / 2,rect2.aabb.y + rect2.aabb.h / 2}

    dir = {centerB[1] - centerA[1],centerB[2] - centerA[2]}
    local normal = dir[1] * depthAndNormal.normal[1] + dir[2] * depthAndNormal.normal[2] 
    if(normal > 0)  then
        depthAndNormal.normal[1] =  depthAndNormal.normal[1] * -1
        depthAndNormal.normal[2] =  depthAndNormal.normal[2] * -1
    end

    return true
end



function AABB(aabb1,aabb2)
    return aabb1.x < aabb2.x + aabb2.w and aabb1.y < aabb2.y + aabb2.h and  aabb1.x + aabb1.w > aabb2.x  and   aabb1.y + aabb1.h > aabb2.y  
end



setColor = love.graphics.setColor
drawRect = love.graphics.rectangle