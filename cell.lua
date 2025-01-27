local cell = Object:extend()

function cell:new(size)
    self.size = size
    self.value = 0
end

function cell:draw(x, y)
    love.graphics.rectangle("line", x, y, self.size, self.size)
    love.graphics.print(self.value, x + self.size / 2 - 10, y + self.size / 2 - 20, 0, 3, 3)
end

return cell