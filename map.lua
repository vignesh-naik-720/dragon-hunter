local Map = {}
Map.__index = Map

function Map.new()
    local self = setmetatable({}, Map)
    
    self.tileSize = 64
    self.tiles = {
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,2,2,0,0,0,0,0,1,0,0,0,0,0,2,2,2,0,0,0,2,2,0,1},
        {1,0,2,2,0,0,0,0,0,0,0,0,0,0,0,2,0,2,0,0,0,2,2,0,1},
        {1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,2,2,2,0,0,0,0,0,1,1,1,1,0,0,0,1},
        {1,0,1,1,1,0,0,0,0,2,0,2,0,0,0,0,0,0,1,1,0,0,0,0,1},
        {1,0,1,0,1,0,0,0,0,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,1,1,1,0,0,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,0,0,0,1,1,1,0,0,1},
        {1,0,0,0,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,1},
        {1,0,0,0,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
    }

    self.images = {
        grass = love.graphics.newImage("grass.png"),
        tree = love.graphics.newImage("tree.png"),
        rock = love.graphics.newImage("rock.png")
    }

    self.scales = {}
    for k, img in pairs(self.images) do
        self.scales[k] = {
            x = self.tileSize / img:getWidth(),
            y = self.tileSize / img:getHeight()
        }
    end
    return self
end

function Map:draw()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[y] do
            local tx, ty = (x-1)*self.tileSize, (y-1)*self.tileSize
            
            love.graphics.setColor(1,1,1)
            love.graphics.draw(self.images.grass, tx, ty, 0, self.scales.grass.x, self.scales.grass.y)
            local tile = self.tiles[y][x]
            if tile == 1 then
                love.graphics.draw(self.images.tree, tx, ty, 0, self.scales.tree.x, self.scales.tree.y)
            elseif tile == 2 then
                love.graphics.draw(self.images.rock, tx, ty, 0, self.scales.rock.x, self.scales.rock.y)
            end
        end
    end
end

function Map:collides(px, py, size)
    local half = size * 0.4
    local corners = {{px-half, py-half}, {px+half, py-half}, {px-half, py+half}, {px+half, py+half}}
    for _, c in ipairs(corners) do
        local tx = math.floor(c[1] / self.tileSize) + 1
        local ty = math.floor(c[2] / self.tileSize) + 1
        local tile = self.tiles[ty] and self.tiles[ty][tx]
        if tile == 1 or tile == 2 then return true end
    end
    return false
end

return Map