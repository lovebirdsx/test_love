---@class Color
local M = {}

function M:toString()
    return string.format('(%g, %g, %g, %g)', self.r, self.g, self.b, self.a)
end

function M:genSnapshot()
    ---@type Color
    local s = {}
    s.r = self.r
    s.g = self.g
    s.b = self.b
    s.a = self.a
    return s
end

---@param s Color
function M:applySnapshot(s)
    self.r = s.r
    self.g = s.g
    self.b = s.b
    self.a = s.a
end

M.r = 1
M.g = 1
M.b = 1
M.a = 1
M.__tostring = M.toString

---@return Color
function M.new(r, g, b, a)
    local t = { r = r, g = g, b = b, a = a, }
    return setmetatable(t, {__index = M})
end

---@return Color
function M.random(a)
    local r = math.random()
    local g = math.random()
    local b = math.random()
    return M.new(r, g, b, a)
end

M.White = M.new(1, 1, 1, 1)
M.Red = M.new(1, 0, 0, 1)
M.Green = M.new(0, 1, 0, 1)
M.Blue = M.new(0, 0, 1, 1)

return M
