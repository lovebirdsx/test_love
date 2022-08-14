---@class Vector2
local M = {}

function M:tostring()
    return string.format('(%g, %g)', self.x, self.y)
end

function M:genSnapshot()
    ---@type Vector2
    local s = {}
    s.x = self.x
    s.y = self.y
    return s
end

---@param s Vector2
function M:applySnapshot(s)
    self.x = s.x
    self.y = s.y
end

---@param x number
---@param y number
function M:set(x, y)
    self.x, self.y = x, y
end

---@param n number
function M:mul(n)
    self.x = self.x * n
    self.y = self.y * n
end

---@return number
function M:magnitude()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function M:normalize()
    local d = self:magnitude()
    self.x = self.x / d
    self.y = self.y / d
end

---@return Vector2
function M:clone()
    return M.new(self.x, self.y)
end

---@param v1 Vector2
---@param v2 Vector2
function M.distance(v1, v2)
    local dx = v1.x - v2.x
    local dy = v1.y - v2.y
    return math.sqrt(dx * dx + dy * dy)
end

---@param v1 Vector2
---@param v2 Vector2
function M._sub(v1, v2)
    return M.new(v1.x - v2.x, v1.y - v2.y)
end

---@param v Vector2
function M._unm(v)
    return M.new(-v.x, -v.y)
end

---@param v1 Vector2
---@param v2 Vector2
function M._add(v1, v2)
    return M.new(v1.x + v2.x, v1.y + v2.y)
end

---@param v Vector2
function M.inverse(v)
    return M.new(-v.x, -v.y)
end

M.x = 0
M.y = 0
M.__index = M
M.__tostring = M.tostring
M.__add = M._add
M.__sub = M._sub
M.__unm = M._unm

---@param x number
---@param y number
---@return Vector2
function M.new(x, y)
    local t = {x = x, y = y}
    setmetatable(t, M)
    return t
end

return M