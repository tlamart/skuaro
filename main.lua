if arg[2] == "debug" then
    require("lldebugger").start()
  end

function love.load()
    Grid = require "grid"
    Grid = Grid(4)
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