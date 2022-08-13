local Color = require('common.color')

local M = {}

local strs = {}

function M.reset()
    strs = {}
end

function M.printf(fmt, ...)
    local s = string.format(fmt, ...)
    table.insert(strs, s)
end

function M.draw()
    if #strs <= 0 then return end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(table.concat(strs, '\n'), 10, 10)
end

return M
