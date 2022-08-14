local lu = require('common.luaunit')
local Vector2 = require('common.vector2')

TestVector = {}

function TestVector:testNormalize()
    local v = Vector2.new(100, 100)
    v:normalize()
    lu.assertAlmostEquals(v:magnitude(), 1)
end
