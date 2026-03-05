local Player = {}
Player.__index = Player

function Player.new(x, y)
    local self = setmetatable({}, Player)
    self.x, self.y = x, y
    
    self.size = 52 
    self.speed = 280 
    self.direction = 1
    
    self.sprite = love.graphics.newImage("sprite.png")
    
    local maxDim = math.max(self.sprite:getWidth(), self.sprite:getHeight())
    self.scale = self.size / maxDim
    
    return self
end

function Player:update(dt, map)
    local mx, my = 0, 0
    
    if love.keyboard.isDown("w", "up") then my = -1 end
    if love.keyboard.isDown("s", "down") then my = 1 end
    if love.keyboard.isDown("a", "left") then 
        mx = -1 
        self.direction = -1
    end
    if love.keyboard.isDown("d", "right") then 
        mx = 1 
        self.direction = 1
    end

    if mx ~= 0 and my ~= 0 then
        mx, my = mx * 0.7071, my * 0.7071
    end

    local nextX = self.x + mx * self.speed * dt
    local nextY = self.y + my * self.speed * dt

    
    if not map:collides(nextX, self.y, self.size) then 
        self.x = nextX 
    end
    if not map:collides(self.x, nextY, self.size) then 
        self.y = nextY 
    end
end

function Player:draw()
    love.graphics.setColor(1, 1, 1)
    
    love.graphics.draw(
        self.sprite, 
        self.x, 
        self.y, 
        0, 
        self.scale * self.direction, 
        self.scale, 
        self.sprite:getWidth()/2, 
        self.sprite:getHeight()/2
    )
end

return Player