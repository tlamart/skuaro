if arg[2] == "debug" then
    require("lldebugger").start()
  end

function love.load()
    Object = require "classic"
    Button = require "ui"
    Alert = require "alert"
    Alert = Alert()
    Grid = require "grid"
    Grid = Grid(3)
end

function love.mousepressed(x, y, button)
    for _, c in ipairs(Grid.corners) do
        if math.abs(x - c.x) <= c.size and math.abs(y - c.y) <= c.size then
            c:toggle()
        end
    end
    for _, b in ipairs(Grid.ui) do
        if math.abs(x - (b.x + b.width / 2)) <= b.width / 2
        and math.abs(y - (b.y + b.height / 2)) <= b.height / 2
        then
            b.callback(b.arg)
        end
    end
end

function love.update(dt)
    if Alert.time > 0 then
        Alert.time = Alert.time - dt
    end
end

function love.draw()
    Grid:draw()
    Alert:draw()
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end