local table = require('common.tableex')

local Entity = require('common.entity')
local Config = require('common.config')
local WroldGrid = require('common.world_grid')
local Box2 = require('common.box2')
local Vector2 = require('common.vector2')

---@class EntityWorld
local M = {}

---@param e Entity
function M:addEntity(e)
    if not e then
        error('Add nil entity')
        return;
    end

    local hash = Config.posToHash(e.pos.x, e.pos.y)
    local grid = self._gridMap[hash]
    if not grid then
        local gx, gy = Config.posToGridIndex(e.pos.x, e.pos.y)
        local minX = gx * Config.GridWidth
        local minY = gy * Config.GridHeight
        local min = Vector2.new(minX, minY)
        local max = Vector2.new(minX + Config.GridWidth, minY + Config.GridHeight)
        grid = WroldGrid.new(Box2.new(min, max))
        self._gridMap[hash] = grid
    end

    grid:addEntity(e)
    self._entityCount = self._entityCount + 1
end

---@param e Entity
function M:remEntity(e)
    local hash = Config.posToHash(e.pos.x, e.pos.y)
    local grid = self._gridMap[hash]
    if not grid then
        local gx, gy = Config.posToGridIndex(e.pos.x, e.pos.y)
        error(string.format('[%s] no grid for (%g, %g)', e, gx, gy))
    end

    grid:remEntity(e)
    self._entityCount = self._entityCount - 1
end

function M:clearAll()
    self._gridMap = {}
    self._entityCount = 0
end

---@return number
function M:genEntityId()
    local result = self._entityId
    self._entityId = self._entityId + 1
    return result;
end

---@param verbose boolean
function M:toString()
    local strs = {}
    table.insert(strs, 'Entity count ' .. self._entityCount)
    if self.verbose then
        for _, grid in pairs(self._gridMap) do
            table.insert(strs, grid:tostring('\t'))
        end
    end
    
    return table.concat(strs, '\n')
end

function M:genSnapshot()
    local entities = {}
    for _, grid in pairs(self._gridMap) do
        grid:foreachEntity(function (e) table.insert(entities, e) end)
    end

    local s = {} ---@type EntityWorld
    local entitesData = {} ---@type Entity []
    for i = 1, #entities do
        local e = entities[i]
        table.insert(entitesData, e:genSnapshot())
    end

    s._entities = entitesData
    s._entityId = self._entityId
    s.verbose = self.verbose
    return s
end

---@param s EntityWorld
function M:applySnapshot(s)
    self:clearAll()
    for i = 1, #s._entities do
        local e = Entity.new({world = self})
        e:applySnapshot(s._entities[i])
        self:addEntity(e)
    end
    self._entityId = s._entityId
    self.verbose = s.verbose
end

function M:draw()
    for _, grid in pairs(self._gridMap) do
        grid:draw()
    end
end

---@param worldToScreen Transform
function M:drawUi(worldToScreen)
    for _, grid in pairs(self._gridMap) do
        grid:drawUi(worldToScreen)
    end
end

M.__index = M
M.__tostring = M.toString

function M.new()
    local t = {} ---@class EntityWorld
    t._entityCount = 0
    t._entityId = 1
    t.verbose = false
    t._gridMap = {} ---@type table<number, WorldGrid>
    setmetatable(t, M)
    return t
end

return M
