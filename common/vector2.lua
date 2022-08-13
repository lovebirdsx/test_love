---@class Vector2
local M = {}

M.x = 0
M.y = 0

function M:toString()
    return string.format('(%g, %g)', self.x, self.y)
end

---@param x number
---@param y number
function M.new(x, y)
    local t = {x = x, y = y}
    setmetatable(t, {__index = M})
    return t
end

return M