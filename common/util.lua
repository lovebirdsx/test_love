---@param p1 Vector2
---@param p2 Vector2
---@param c Color
function drawLine(p1, p2, c)
    if c then
        love.graphics.setColor(c.r, c.g, c.b, c.a)
    end
    love.graphics.line(p1.x, p1.y, p2.x, p2.y)
end

---@param fmt string
function printf(fmt, ...)
    print(string.format(fmt, ...))
end
