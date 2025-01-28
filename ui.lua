local button = Object:extend()

function button:new(x, y, width, height, text, callback, ...)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.text = text
    self.callback = callback
    self.arg = {...}
end

function button:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.print(self.text, self.x + self.width / 2, self.y + self.height / 2, 0, 1.5, 1.5, #self.text * 3.5, 7)
end

function button:click()
    self.callback(self, self.arg)
end

function button:center()
    local width = love.graphics.getWidth()
    self.x = width / 2 - self.width / 2
end

return button