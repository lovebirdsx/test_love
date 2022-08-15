require ('common.util')

local Config = require('common.config')
local Color = require('common.color')

local M = {} ---@class WorldGrid

---@param e Entity
function M:addEntity(e)
    if self._entityMap[e.id] then
        error(string.format('add already exist entity by id %g', e.id))
    end
    self._entityMap[e.id] = e
    self._entityCount = self._entityCount + 1
end

---@param e Entity
function M:remEntity(e)
    local e0 = self._entityMap[e.id]
    if not e0 then
        error(string.format('remove not exist entity by id %g', e.id))
    end

    self._entityMap[e.id] = nil
    self._entityCount = self._entityCount - 1
end

---@param cb fun(e: Entity)
function M:foreachEntity(cb)
    for _, entity in pairs(self._entityMap) do
        cb(entity)
    end
end

function M:draw()
    drawRect(self.box.min, self.box.max, Color.Green)
    self:foreachEntity(function(e) e:draw() end)
end

---@param worldToScreen Transform
function M:drawUi(worldToScreen)
    self:foreachEntity(function(e) e:drawUi(worldToScreen) end)
end

---@param indent string
function M:tostring(indent)
    local strs = {}
    local cx, cy = self.box:getCenter()
    local gx, gy = Config.posToGridIndex(cx, cy)
    table.insert(strs, string.format('%sGrid: (%g,%g) Entity Count = %g', indent, gx, gy, self._entityCount))
    self:foreachEntity(function (e) 
        table.insert(strs, string.format('%s\t%s', indent, e))
    end)
    return table.concat(strs, '\n')
end

M.__index = M
M.__tostring = M.tostring

---@param box Box2
function M.new(box)
    ---@type WorldGrid
    local t = {}
    t.box = box
    t._entityCount = 0
    t._entityMap = {} ---@type table<number, Entity>

    setmetatable(t, M)
    return t
end

return M