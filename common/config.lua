local M = {
    width = 1024,
    height = 768,
    display = 2,
}

---@param pos Point
---@return Point
function M:translate(pos)
    return {x = pos.x + self.width / 2, y = -pos.y + self.height / 2}
end

return M
