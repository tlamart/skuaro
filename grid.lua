local Object = require "classic"

local corner = Object:extend()
local cell = Object:extend()
local grid = Object:extend()

function corner:new()
    self.x = 0
    self.y = 0
    self.size = 10
    self.fill = false
    self.locked = false
end

function corner:draw(x, y)
    local mode = self.fill and "fill" or "line"
    love.graphics.circle(mode, x, y, self.size)
    if self.fill == false then
        love.graphics.setColor(0, 0, 0)
        love.graphics.circle("fill", x, y, self.size - 1)
        love.graphics.setColor(1, 1, 1)
    end
end

function cell:new(size)
    self.size = size
    self.value = 0
    self.corners = {}
end

function cell:draw(x, y)
    love.graphics.rectangle("line", x, y, self.size, self.size)
    love.graphics.print(self.value, x + self.size / 2 - 10, y + self.size / 2 - 20, 0, 3, 3)
end

local function isfill(c)
    if c.fill == true and c.locked == true then
        return 1
    else
        return 0
    end
end

local function islocked(c)
    if c.fill == false and c.locked == true then
        return 1
    else
        return 0
    end
end

local function min_value(index, size, corners)
    index = index + math.floor((index - 1) / size)
    local min = 0
    min = min + isfill(corners[index])
    min = min + isfill(corners[index + 1])
    min = min + isfill(corners[index + 1 + size])
    min = min + isfill(corners[index + 2 + size])
    return min
end

local function max_value(index, size, corners)
    index = index + math.floor((index - 1) / size)
    local max = 4
    max = max - islocked(corners[index])
    max = max - islocked(corners[index + 1])
    max = max - islocked(corners[index + 1 + size])
    max = max - islocked(corners[index + 2 + size])
    return max
end

local function no_fill_locked(corner)
    corner.fill = false
    corner.locked = true
end

local function fill_locked(corner)
    corner.fill = true
    corner.locked = true
end

local function map_corner(index, fct, corners, size)
    index = index + math.floor((index - 1) / size)
    fct(corners[index])
    fct(corners[index + 1])
    fct(corners[index + 1 + size])
    fct(corners[index + 2 + size])
end

local function count_corners(index, corners, size)
    local corner_count = 0
    index = index + math.floor((index - 1) / size)
    for _, i in ipairs({index, index + 1, index + 1 + size, index + 2 + size}) do
        if corners[i].fill and corners[i].locked then
            corner_count = corner_count + 1
        end
    end
    return corner_count
end

local function set_corners(grid, index, corners, size)
    local corner_count = 0
    local corner_index = 0
    if grid[index].value == 0 then
        map_corner(index, no_fill_locked, corners, size)
    elseif grid[index].value == 4 then
        map_corner(index, fill_locked, corners, size)
    else
        corner_count = count_corners(index, corners, size)
        corner_index = index + math.floor((index - 1) / size)
        for _, i in ipairs({corner_index, corner_index + 1, corner_index + 1 + size, corner_index + 2 + size}) do
            if corner_count < grid[index].value and corners[i].locked == false and corners[i].fill == false then
                fill_locked(corners[i])
                corner_count = corner_count + 1
            else
                corners[i].locked = true
            end
        end
    end
end

local function unlock_unfill_all(corners)
    for i = 1, #corners do
        corners[i].fill = false
        corners[i].locked = false
    end
end

local function print_grid(grid, size)
    print(
        grid[1].value .. grid[2].value .. grid[3].value .. grid[4].value .. "\n" ..
        grid[5].value .. grid[6].value .. grid[7].value .. grid[8].value .. "\n" ..
        grid[9].value .. grid[10].value .. grid[11].value ..  grid[12].value .."\n" ..
        grid[13].value .. grid[14].value .. grid[15].value ..  grid[16].value .."\n"
    )
end

local function init_cell_value(array, size, corners)
    math.randomseed(os.time())
    local index = math.random(1, #array)
    if arg[2] == "debug" then index = 7 end
    array[index].value = math.random(0, 1) * 4
    if arg[2] == "debug" then array[index].value = 0 end
    set_corners(array, index, corners, size)
    if arg[2] == "debug" then print_grid(array, size) end
    for i = index + 1, #array do
        array[i].value = math.random(min_value(i, size, corners), max_value(i, size, corners))
        set_corners(array, i, corners, size)
        if arg[2] == "debug" then print_grid(array, size) end
    end
    for i = index - 1, 1, -1 do
        array[i].value = math.random(min_value(i, size, corners), max_value(i, size, corners))
        set_corners(array, i, corners, size)
        if arg[2] == "debug" then print_grid(array, size) end
    end
    unlock_unfill_all(corners)
end

function grid:new(size)
    -- self.width, self.height = love.window.getDesktopDimensions()
    self.width, self.height = 800, 600
    self.cell_size = self.width < self.height and self.width or self.height
    self.cell_size = self.cell_size / (size + 1)
    self.size = size
    self.grid = {}
    self.corners = {}
    for i = 1, size * size do
        table.insert(self.grid, cell(self.cell_size))
    end
    for i = 1, (size + 1) * (size + 1) do
        table.insert(self.corners, corner())
    end
    init_cell_value(self.grid, size, self.corners)
end

function grid:draw_cell()
    local y = (self.height - (self.cell_size * self.size)) / 2
    local xstart = (self.width - (self.cell_size * self.size)) / 2
    for i = 0, self.size - 1 do
        local x = xstart
        for j = 1, self.size do
            self.grid[i * self.size + j]:draw(x, y)
            x = x + self.cell_size
        end
        y = y + self.cell_size
    end
end

function grid:draw_corner()
    local y = (self.height - (self.cell_size * self.size)) / 2
    local xstart = (self.width - (self.cell_size * self.size)) / 2
    for i = 0, self.size do
        local x = xstart
        for j = 1, self.size + 1 do
            self.corners[i * (self.size + 1) + j]:draw(x, y, 20)
            x = x + self.cell_size
        end
        y = y + self.cell_size
    end
end

function grid:draw()
    self:draw_cell()
    self:draw_corner()
end

return grid
