-- room.lua
local currentBGM
local newBGM

room = {}

function room.load(path)
    map = sti(path)

    local polyAmt = 0
    local rectAmt = 0
    local elipseAmt = 0

    polyWalls = {}
    rectWalls = {}
    ellipseWalls = {}

    -- how tf you get this shit to NOT RESTART WHEN RELOADING THE STATE!! Press 1 to restart the state btw
    newBGM = love.audio.newSource(map.properties['backgroundMusic'], 'stream')
    if currentBGM ~= newBGM then
        if currentBGM then currentBGM:stop() end
        currentBGM = newBGM
    end

    for i, obj in pairs(map.layers["collision"].objects) do
        if obj.shape == "polygon" then
            polyAmt = polyAmt + 1
            print("polygon #" .. polyAmt)

            local verts = {}
            for i, objPoint in ipairs(obj.polygon) do
                table.insert(verts, objPoint.x)
                table.insert(verts, objPoint.y)
            end

            for i, vert in ipairs(verts) do
                print(vert)
            end

            local wall = world:newPolygonCollider(verts)
            wall:setType('static')
            
            table.insert(polyWalls, wall)
        end
        if obj.shape == "rectangle" then
            rectAmt = rectAmt + 1
            print("rectangle #" .. rectAmt)
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(rectWalls, wall)
        end
        if obj.shape == "ellipse" then
            rectAmt = rectAmt + 1
            print("ellipse #" .. rectAmt)
            local wall = world:newCircleCollider(obj.x + obj.width/2, obj.y + obj.width/2, obj.width/2)
            wall:setType('static')
            table.insert(ellipseWalls, wall)
        end
    end
end

function room.update(dt)
    currentBGM:play()
    currentBGM:setLooping(true)
end

function room.draw()
    for i, layer in ipairs(map.layers) do
        if layer.type == "tilelayer" then
            layer:draw()
        end
    end
end


return room