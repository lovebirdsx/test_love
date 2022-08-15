---@param c Color
function setColor(c)
    if c then
        love.graphics.setColor(c.r, c.g, c.b, c.a)
    end
end

---@param p1 Vector2
---@param p2 Vector2
---@param c Color
function drawLine(p1, p2, c)
    setColor(c)
    love.graphics.line(p1.x, p1.y, p2.x, p2.y)
end

---@param p Vector2
---@param radius number
---@param c Color
function drawCircle(p, radius, c)
    setColor(c)
    love.graphics.circle('line', p.x, p.y, radius)
end

---@param p1 Vector2
---@param p2 Vector2
---@param c Color
function drawRect(p1, p2, c)
    setColor(c)
    local x1, y1 = p1.x, p1.y
    local x2, y2 = p2.x, p2.y
    love.graphics.rectangle('line', math.min(x1, x2), math.min(y1, y2), math.abs(x1 - x2), math.abs(y1 - y2))
end

---@param fmt string
function printf(fmt, ...)
    print(string.format(fmt, ...))
end
