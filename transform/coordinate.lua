require('common.util')

---@class Coordinate
local Coordinate = {px={x = 100, y = 0}, py={x = 0, y = 100}, color=util.GREEN}
local center = {x=0, y=0}

function Coordinate:draw()
    drawLine(center, self.px, self.color)
    drawLine(center, self.py, self.color)
end

---@param t Coordinate
---@return Coordinate
function Coordinate.new(t)
    t = t or {}
    return setmetatable(t, {__index = Coordinate})
end

return Coordinate
