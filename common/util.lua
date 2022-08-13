local config = require('common.config')

---@class Point
---@field public x number
---@field public y number

---@class Color
---@field public r number
---@field public g number
---@field public b number
---@field public a number

local M = {    
    WHITE = {r=1, g=1, b=1, a=1},
    RED = {r=1, g=0, b=0, a=1},
    GREEN = {r=0, g=1, b=0, a=1},
    BLUE = {r=0, g=0, b=1, a=1},
}

---@param p1 Point
---@param p2 Point
---@param c Color
function M:drawLine(p1, p2, c)
    local sa = config:translate(p1)
    local sb = config:translate(p2)
    c = c or self.WHITE
    love.graphics.setColor(c.r, c.g, c.b, c.a)
    love.graphics.line(sa.x, sa.y, sb.x, sb.y)
end

return M
