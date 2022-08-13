local config = require('common.config')

local M = {}

---@param p1 Vector2
---@param p2 Vector2
---@param c Color
function M:drawLine(p1, p2, c)
    c = c or self.WHITE
    love.graphics.setColor(c.r, c.g, c.b, c.a)
    love.graphics.line(p1.x, p1.y, p2.x, p2.y)
end

return M
