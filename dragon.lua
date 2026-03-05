local Dragon = {}
Dragon.__index = Dragon

function Dragon.new(map)
    local self = setmetatable({}, Dragon)
    self.map = map
    self.sprite = love.graphics.newImage("dragon.png")
    
    self.size = 85 
    local maxDim = math.max(self.sprite:getWidth(), self.sprite:getHeight())
    self.scale = self.size / maxDim
    
    self.timer = 0
    self.maxTime = 6
    self.direction = 1
    self.hitFlash = 0
    self.state = "IDLE"
    self.targetX = 0
    self.targetY = 0
    self.flySpeed = 400

    self:spawn(true)
    return self
end

function Dragon:spawn(isTeleport)
    local valid = false
    local tx, ty
    while not valid do
        tx = love.math.random(1, #self.map.tiles[1])
        ty = love.math.random(1, #self.map.tiles)
        if self.map.tiles[ty] and self.map.tiles[ty][tx] == 0 then
            valid = true
        end
    end

    local newX = (tx - 0.5) * self.map.tileSize
    local newY = (ty - 0.5) * self.map.tileSize

    if isTeleport then
        self.x = newX
        self.y = newY
        self.state = "IDLE"
    else
        self.targetX = newX
        self.targetY = newY
        self.state = "FLYING"
    end
    
    self.timer = self.maxTime
end

function Dragon:update(dt, player)
    if self.hitFlash > 0 then self.hitFlash = self.hitFlash - dt end

    if self.state == "IDLE" then
        self.timer = self.timer - dt

        if self.timer <= 0 then
            self:spawn(false)
        end

        if player.x < self.x then self.direction = -1 else self.direction = 1 end

        local dx, dy = self.x - player.x, self.y - player.y
        local distance = math.sqrt(dx*dx + dy*dy)

        if distance < (self.size * 0.4 + player.size * 0.4) then
            self.hitFlash = 0.15
            local p = math.ceil(self.timer * 20)
            self:spawn(true)
            return p
        end

    elseif self.state == "FLYING" then
        local dx = self.targetX - self.x
        local dy = self.targetY - self.y
        local dist = math.sqrt(dx*dx + dy*dy)

        if dx < 0 then self.direction = -1 else self.direction = 1 end

        if dist > 5 then
            self.x = self.x + (dx / dist) * self.flySpeed * dt
            self.y = self.y + (dy / dist) * self.flySpeed * dt
        else
            self.x = self.targetX
            self.y = self.targetY
            self.state = "IDLE"
        end
    end
    
    return 0
end

function Dragon:draw()
    local time = love.timer.getTime()

    local hoverAmp = (self.state == "IDLE") and 12 or 5
    local hover = hoverAmp * math.sin(time * 3.5)
    local pulse = 0.06 * math.sin(time * 10)

    if self.hitFlash > 0 then
        love.graphics.setColor(2, 2, 2, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.draw(
        self.sprite, 
        self.x, 
        self.y + hover, 
        0, 
        self.scale * (1 + pulse) * self.direction, 
        self.scale * (1 + pulse), 
        self.sprite:getWidth()/2, 
        self.sprite:getHeight()/2
    )
    
    love.graphics.setColor(1, 1, 1, 1)
end

return Dragon