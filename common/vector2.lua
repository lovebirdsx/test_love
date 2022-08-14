---@class Vector2
local M = {}

function M:tostring()
    return string.format('(%g, %g)', self.x, self.y)
end

---@param x number
---@param y number
function M:set(x, y)
    self.x, self.y = x, y
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

---@param x number
---@param y number
---@return Vector2
function M.new(x, y)
    local t = {x = x, y = y}
    setmetatable(t, M)
    return t
end

return M