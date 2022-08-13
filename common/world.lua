---@class World
local M = {}

---@type Entity[]
M.entities = {}

---@param e Entity
function M:addEntity(e)
    table.insert(self.entities, e)
end

---@param e Entity
function M:remEntity(e)
    table.remove(self.entities, table.indexof(self.entities, e))
end

function M:toString()
    local strs = {}
    table.insert(strs, 'Entity count ' .. #self.entities)
    for i = 1, #self.entities do
        local e = self.entities[i]
        table.insert(strs, '\t' .. e:toString())
    end
    return table.concat(strs, '\n')
end

function M:draw()
    for i = 1, #self.entities do
        local e = self.entities[i]
        e:draw()
    end
end

---@return World
function M.new()
    return setmetatable({}, {__index = M})
end

return M
