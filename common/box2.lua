local Vector2 = require('common.vector2')

---@class Box2
local M = {}

M.min = Vector2.new(0, 0)
M.max = Vector2.new(0, 0)

---@return number, number
function M:getSize()
    return self.max.x - self.min.x, self.max.y - self.min.y
end

---@return Vector2
function M:getSizeV()
    return Vector2.new(self:getSize())
end

---@param w number
---@param h number
function M:setSize(w, h)
    local cx, cy = self:getCenter()
    self.min.x = cx - w / 2
    self.min.y = cy - h / 2
    self.max.x = cx + w / 2
    self.max.y = cy + h / 2
end

---@return number, number
function M:getCenter()
    local minX, minY = self.min.x, self.min.y
    local maxX, maxY = self.max.x, self.max.y
    return minX + (maxX - minX) / 2, minY + (maxY - minY) / 2
end

function M:getCenterV()
    return Vector2.new(self:getCenter())
end

---@return string
function M:toString()
    local sizeX, sizeY = self:getSize()
    local centerX, centerY = self:getCenter()
    return string.format('center = (%g, %g) size = (%g, %g)', centerX, centerY, sizeX, sizeY)
end

M.__index = M
M.__tostring = M.toString

---@param min Vector2
---@param max Vector2
---@return Box2
function M.new(min, max)
    local t = {
        min = min or M.min,
        max = max or M.max,
    }
    return setmetatable(t, M)
end

---@param center Vector2
---@param size Vector2
function M.newByCenterSize(center, size)
    local min = Vector2.new(center.x - size.x / 2, center.y - size.y / 2)
    local max = Vector2.new(center.x + size.x / 2, center.y + size.y / 2)
    return M.new(min, max)
end

return M
