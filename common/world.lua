local Entity = require('common.entity')
local table = require('common.tableex')

---@class EntityWorld
local M = {}

---@type Entity[]
M.entities = {}
M.entityId = 1

---@param e Entity
function M:addEntity(e)
    if not e then
        error('Add empty entity')
        return;
    end

    table.insert(self.entities, e)
end

---@param e Entity
function M:remEntity(e)
    table.remove(self.entities, table.indexof(self.entities, e))
end

---@return number
function M:genEntityId()
    local result = self.entityId
    self.entityId = self.entityId + 1
    return result;
end

function M:toString()
    local strs = {}
    table.insert(strs, 'Entity count ' .. #self.entities)
    -- for i = 1, #self.entities do
    --     local e = self.entities[i]
    --     table.insert(strs, '\t' .. e:toString())
    -- end
    return table.concat(strs, '\n')
end

function M:genSnapshot()
    ---@type EntityWorld
    local s = {}
    local entites = {}
    for i = 1, #self.entities do
        local e = self.entities[i]
        table.insert(entites, e:genSnapshot())
    end
    s.entities = entites
    s.entityId = self.entityId
    return s
end

---@param s EntityWorld
function M:applySnapshot(s)
    local entities = {}
    for i = 1, #s.entities do
        local e = Entity.new({world = self})
        e:applySnapshot(s.entities[i])
        table.insert(entities, e)
    end
    self.entities = entities
    self.entityId = s.entityId
end

function M:draw()
    for i = 1, #self.entities do
        local e = self.entities[i]
        e:draw()
    end
end

M.__index = M
M.__tostring = M.toString

---@return EntityWorld
function M.new()
    return setmetatable({}, M)
end

return M
