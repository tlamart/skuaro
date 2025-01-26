if arg[2] == "debug" then
    require("lldebugger").start()
  end

function love.load()
    Grid = require "grid"
    Grid = Grid(3)
end

function love.mousepressed(x, y, button)
    for _, c in ipairs(Grid.corners) do
        if math.abs(x - c.x) <= c.size and math.abs(y - c.y) <= c.size then
            if c.fill == true then
                c.fill = false
            else
                c.fill = true
            end
        end
    end
end

function love.update()
end

function love.draw()
    Grid:draw()
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end