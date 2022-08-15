local lu = require('common.luaunit')

TestTable = {}

local function getTableSize(t)
    local count = 0
    for _, _ in pairs(t) do
        count = count + 1
    end
    return count
end

function TestTable:test2()
    local t = {a = 1, b = 2}
    lu.assertEquals(getTableSize(t), 2)

    t.a = nil
    lu.assertEquals(getTableSize(t), 1)
end
