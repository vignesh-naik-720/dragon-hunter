local Player = require("player")
local Map = require("map")
local Dragon = require("dragon")

local score = 0
local popups = {}
local particles = {}
local shakeDuration = 0
local shakeIntensity = 0
local lastDragonState = "IDLE"

local gameState = "START"
local firstScoreAchieved = false

function love.load()
    love.window.setMode(1280, 720, {resizable=true, vsync=true})
    love.window.setTitle("Dragon Hunter Extreme")

    love.graphics.setBackgroundColor(0.85, 1, 0.85)
    love.graphics.setDefaultFilter("nearest", "nearest")

    mainFont = love.graphics.newFont(24)
    pixelFontLarge = love.graphics.newFont(80)
    love.graphics.setFont(mainFont)

    map = Map.new()
    player = Player.new(96, 96)
    dragon = Dragon.new(map)
end

function love.update(dt)
    if gameState == "LOST" then
        if love.keyboard.isDown("r") then love.event.quit("restart") end
        return
    end

    player:update(dt, map)

    if gameState == "START" then
        if love.keyboard.isDown("w", "a", "s", "d", "up", "down", "left", "right") then
            gameState = "PLAYING"
        end
        return
    end

    if firstScoreAchieved and lastDragonState == "IDLE" and dragon.state == "FLYING" then
        local penalty = 20
        score = score - penalty

        if score <= 0 then
            score = 0
            gameState = "LOST"
        end

        table.insert(popups, {
            x = dragon.x, y = dragon.y, val = "-" .. penalty,
            timer = 1.2, scale = 0, maxScale = 3.0, rotation = 0, isNegative = true
        })
    end
    lastDragonState = dragon.state

    local points = dragon:update(dt, player)
    
    if points > 0 then
        score = score + points
        firstScoreAchieved = true

        local anchorX, anchorY = player.x, player.y
        shakeDuration = 0.3
        shakeIntensity = 10

        for i = 1, 25 do
            table.insert(particles, {
                x = anchorX, y = anchorY,
                vx = love.math.random(-250, 250), vy = love.math.random(-250, 250),
                life = 1.2, size = love.math.random(3, 6), color = {1, 1, 0}
            })
        end

        table.insert(popups, {
            x = anchorX, y = anchorY - 40,
            val = "+" .. points,
            timer = 1.2, scale = 0, maxScale = 3.5,
            rotation = love.math.random(-0.1, 0.1), isNegative = false
        })
    end

    if shakeDuration > 0 then shakeDuration = shakeDuration - dt end
    for i = #particles, 1, -1 do
        local p = particles[i]
        p.x, p.y = p.x + p.vx * dt, p.y + p.vy * dt
        p.life = p.life - dt
        if p.life <= 0 then table.remove(particles, i) end
    end
    for i = #popups, 1, -1 do
        local p = popups[i]
        if p.scale < p.maxScale then p.scale = p.scale + 15 * dt end
        p.y = p.y - 60 * dt
        p.timer = p.timer - dt
        if p.timer <= 0 then table.remove(popups, i) end
    end
end

function love.draw()
    local camX = love.graphics.getWidth() / 2 - player.x
    local camY = love.graphics.getHeight() / 2 - player.y

    if shakeDuration > 0 then
        camX = camX + love.math.random(-shakeIntensity, shakeIntensity)
        camY = camY + love.math.random(-shakeIntensity, shakeIntensity)
    end

    love.graphics.push()
    love.graphics.translate(camX, camY)
    map:draw()
    dragon:draw()
    player:draw()

    for _, p in ipairs(particles) do
        love.graphics.setColor(1, 0.9, 0, p.life)
        love.graphics.circle("fill", p.x, p.y, p.size * p.life)
    end

    for _, p in ipairs(popups) do
        if p.isNegative then love.graphics.setColor(1, 0, 0, p.timer)
        else love.graphics.setColor(1, 0.8, 0, p.timer) end
        love.graphics.print(p.val, p.x, p.y, p.rotation, p.scale, p.scale, 20, 10)
    end
    love.graphics.pop()

    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    if gameState == "START" then
        love.graphics.setColor(0, 0, 0, 0.6)
        love.graphics.rectangle("fill", 0, 0, screenW, screenH)

        love.graphics.setColor(0, 0.4, 0, 0.8)
        love.graphics.rectangle("fill", screenW/2 - 300, screenH/2 - 120, 600, 240, 15)
        love.graphics.setColor(0, 1, 0.2)
        love.graphics.setLineWidth(5)
        love.graphics.rectangle("line", screenW/2 - 300, screenH/2 - 120, 600, 240, 15)

        love.graphics.setFont(pixelFontLarge)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf("START!", 4, screenH/2 - 76, screenW, "center")
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("START!", 0, screenH/2 - 80, screenW, "center")

        love.graphics.setFont(mainFont)
        love.graphics.printf("MOVE TO BEGIN THE HUNT", 0, screenH/2 + 50, screenW, "center")

    elseif gameState == "LOST" then
        love.graphics.setColor(0.1, 0, 0, 0.85)
        love.graphics.rectangle("fill", 0, 0, screenW, screenH)

        love.graphics.setColor(0.5, 0, 0, 0.8)
        love.graphics.rectangle("fill", screenW/2 - 350, screenH/2 - 120, 700, 240, 15)
        love.graphics.setColor(1, 0.2, 0.2)
        love.graphics.setLineWidth(5)
        love.graphics.rectangle("line", screenW/2 - 350, screenH/2 - 120, 700, 240, 15)

        love.graphics.setFont(pixelFontLarge)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf("YOU LOST!", 4, screenH/2 - 76, screenW, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("YOU LOST!", 0, screenH/2 - 80, screenW, "center")

        love.graphics.setFont(mainFont)
        love.graphics.printf("PRESS 'R' TO RESTART", 0, screenH/2 + 50, screenW, "center")
    end

    if gameState ~= "START" then
        love.graphics.setFont(mainFont)
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 20, 20, 250, 75, 10)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("SCORE: " .. score, 40, 30, 0, 1.2)
        local status = (dragon.state == "FLYING") and "FLYING!" or "Time: " .. math.ceil(dragon.timer) .. "s"
        love.graphics.print(status, 40, 55, 0, 0.9)
    end
end