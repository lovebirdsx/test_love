local lu = require('common.luaunit')
local json = require('common.json')

TestJson = {}

function TestJson:test1()
    local t1 = {a = 1, b = 'hello'}
    local s = json.encode(t1)
    local t2 = json.decode(s)
    lu.assertEquals(t1, t2)
end
