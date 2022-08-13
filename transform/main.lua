local Coordinate = require('transform.coordinate')
local Util = require('common.util')

local c1 = Coordinate.new({color = Util.GREEN, px = {x = 1000, y = 0}, py = {x = 0, y = 1000}})
local c2 = Coordinate.new({color = Util.BLUE, px = {x = 1000, y = 1000}, py = {x = -1000, y = 1000}})

function love.load()
    print('load')
end

function love.draw()
    c1:draw()
    c2:draw()
end
