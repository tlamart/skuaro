local alert = Object:extend()

function alert:new()
    self.text = ""
    self.time = 0
end

function alert:message(text, time)
    self.text = text
    self.time = time
end

function alert:draw()
    if self.time > 0 then
        local width, height = love.graphics.getDimensions()
        love.graphics.print(self.text, width / 2, 10, 0, 1.5, 1.5, #self.text * 3, 0)
    end
end

return alert