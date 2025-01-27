local corner = Object:extend()

function corner:new(x, y)
    self.x = x
    self.y = y
    self.size = 10
    self.fill = false
    self.locked = false
end

function corner:draw()
    local mode = self.fill and "fill" or "line"
    love.graphics.circle(mode, self.x, self.y, self.size)
    if self.fill == false then
        love.graphics.setColor(0, 0, 0)
        love.graphics.circle("fill", self.x, self.y, self.size - 1)
        love.graphics.setColor(1, 1, 1)
    end
end

function corner:isfilled()
    return self.fill == true and self.locked == true
end

function corner:isempty()
    return self.fill == false and self.locked == true
end

function corner:toempty()
    self.fill = false
    self.locked = true
end

function corner:tofill()
    self.fill = true
    self.locked = true
end

function corner:toggle()
    if self.fill == true then
        self.fill = false
    else
        self.fill = true
    end
    self.locked = true
end

return corner