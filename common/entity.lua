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
    -- local c = self.color
    -- love.graphics.setColor(c.r, c.g, c.b, c.a)
    -- love.graphics.circle('line', self.pos.x, self.pos.y, self.size)
    -- love.graphics.printf(self.pos:tostring(), self.pos.x - 100, self.pos.y + 10, 200, 'center')
end

---@param worldToScreen Transform
function M:drawUi(worldToScreen)
    local c = self.color
    love.graphics.setColor(c.r, c.g, c.b, c.a)
    local x, y = worldToScreen:transformPoint(self.pos.x, self.pos.y)
    love.graphics.circle('line', x, y, self.size)
    love.graphics.printf(self.pos:tostring(), x - 100, y + 10, 200, 'center')
end

function M:genSnapshot()
    ---@type Entity
    local s = {}
    s.name = self.name
    s.size = self.size
    s.pos = self.pos:genSnapshot()
    s.color = self.color:genSnapshot()

    return s
end

---@param s Entity
function M:applySnapshot(s)
    self.name = s.name
    self.size = s.size
    self.pos:applySnapshot(s.pos)
    self.color:applySnapshot(s.color)
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

    t.pos = t.pos or Vector2.new()
    t.color = t.color or Color.new(1, 1, 1, 1)

    setmetatable(t, {__index = M})
    return t
end

return M
