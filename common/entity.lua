local Color = require('common.color')
local Vector2 = require('common.vector2')

---@class Entity
local M = {}

M.pos = Vector2.new(0, 0)
M.size = 10
M.color = Color.White
M.name = 'entity'
---@type EntityWorld
M.world = nil

function M:draw()
    local c = self.color
    love.graphics.setColor(c.r, c.g, c.b, c.a)
    love.graphics.circle('line', self.pos.x, self.pos.y, self.size)
    love.graphics.printf(self.pos:tostring(), self.pos.x - 100, self.pos.y + 10, 200, 'center')
end

function M:genSnapshot()
end

---@return string
function M:toString()
    return string.format('%s %s', self.name, self.pos)
end

---@param t Entity
function M.new(t)
    if not t then
        error('new entity with nil')
        return nil
    end

    if not t.world then
        error('new entity without world')
        return nil
    end

    setmetatable(t, {__index = M})
    return t
end

return M
