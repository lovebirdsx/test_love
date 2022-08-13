local Color = require('common.color')
local Vector2 = require('common.vector2')

---@class Entity
local M = {}

M.pos = Vector2.new(0, 0)
M.size = 10
M.color = Color.White
M.name = 'entity'

function M:draw()
    local c = self.color
    love.graphics.setColor(c.r, c.g, c.b, c.a)
    love.graphics.circle('line', self.pos.x, self.pos.y, self.size)
end

---@return string
function M:toString()
    return string.format('%s %s', self.name, self.pos:toString())
end

---@param t Entity
function M.new(t)
    t = t or {}
    setmetatable(t, {__index = M})
    return t
end

return M
