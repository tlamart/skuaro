local corner = require "corner"
local cell = require "cell"
local grid = Object:extend()

local function min_value(index, size, corners)
    index = index + math.floor((index - 1) / size)
    local min = 0
    min = min + (corners[index]:isfilled() and 1 or 0)
    min = min + (corners[index + 1]:isfilled() and 1 or 0)
    min = min + (corners[index + 1 + size]:isfilled() and 1 or 0)
    min = min + (corners[index + 2 + size]:isfilled() and 1 or 0)
    return min
end

local function max_value(index, size, corners)
    index = index + math.floor((index - 1) / size)
    local max = 4
    max = max - (corners[index]:isempty() and 1 or 0)
    max = max - (corners[index + 1]:isempty() and 1 or 0)
    max = max - (corners[index + 1 + size]:isempty() and 1 or 0)
    max = max - (corners[index + 2 + size]:isempty() and 1 or 0)
    return max
end

local function no_fill_locked(c)
    c.fill = false
    c.locked = true
end

local function fill_locked(c)
    c.fill = true
    c.locked = true
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

local function init_cell_value(array, size, corners)
    math.randomseed(os.time())
    local index = math.random(1, #array)
    array[index].value = math.random(0, 1) * 4
    set_corners(array, index, corners, size)
    for i = index + 1, #array do
        array[i].value = math.random(min_value(i, size, corners), max_value(i, size, corners))
        set_corners(array, i, corners, size)
    end
    for i = index - 1, 1, -1 do
        array[i].value = math.random(min_value(i, size, corners), max_value(i, size, corners))
        set_corners(array, i, corners, size)
    end
    unlock_unfill_all(corners)
end

local function reset_grid()
    Grid:reset()
end

local function check_answer(b, arg)
    local arr = arg[1]
    local crnr = arg[2]
    local s = arg[3]
    for i, val in ipairs(arr) do
        if count_corners(i, crnr, s) ~= val.value then
            Alert:message("Incorrect...", 3)
            return
        end
    end
    Alert:message("Congratulations !", 3)
    b.text = "New one"
    b.callback = reset_grid
end


function grid:new(size)
    self.width, self.height = love.graphics.getDimensions()
    self.cell_size = self.width < self.height and self.width or self.height
    self.cell_size = self.cell_size / (size + 1)
    self.size = size
    self.grid = {}
    self.corners = {}
    self.ui = {
        Button(self.width / 2, self.height - 50, 100, 40, "check", check_answer, self.grid, self.corners, self.size)
    }
    self.ui[1]:center()
    local y = (self.height - (self.cell_size * self.size)) / 2
    local xstart = (self.width - (self.cell_size * self.size)) / 2
    local x = xstart
    for i = 1, size * size do
        table.insert(self.grid, cell(self.cell_size))
    end
    for i = 1, (size + 1) * (size + 1) do
        table.insert(self.corners, corner(x, y))
        if i % (size + 1) == 0 then
            x = xstart
            y = y + self.cell_size
        else
            x = x + self.cell_size
        end
    end
    init_cell_value(self.grid, size, self.corners)
end

function grid:reset()
    unlock_unfill_all(self.corners)
    init_cell_value(self.grid, self.size, self.corners)
    self.ui[1].text = "check"
    self.ui[1].callback = check_answer
    Alert.time = 0
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
    for _, c in ipairs(self.corners) do
        c:draw()
    end
end

function grid:draw()
    self:draw_cell()
    self:draw_corner()
    for _, b in ipairs(self.ui) do
        b:draw()
    end
end

return grid
