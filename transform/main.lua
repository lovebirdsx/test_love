local ScreenDebug = require('common.screen_debug')

local Box2D = require('common.box2d')
local Vector2 = require('common.vector2')
local World = require('common.world')
local Entity = require('common.entity')
local Color = require('common.color')

local scale = 1 -- 当前视口的放缩
local trans = Vector2.new(0, 0) -- 当前视口的位置
local screenRect = Box2D.newByCenterSize(Vector2.new(0, 0), Vector2.new(love.graphics.getDimensions())) -- 屏幕窗口
local worldToScreen = love.math.newTransform() -- 世界到屏幕的变换
local screenToWorld = love.math.newTransform() -- 屏幕到世界的变换
local mousePos = Vector2.new(0, 0)
local mouseWheelMoved = Vector2.new(0, 0)

local world = World.new()

function updateTransform()
    local w, h = screenRect:getSize()
    worldToScreen:setTransformation(w / 2, h / 2, 0, 1 / scale, 1 / scale, 0, 0, 0, 0)
end

function love.load()
    local sw, sh = screenRect:getSize()
    for i = 1, 10 do
        local pos = Vector2.new(math.random(-sw / 2, sw / 2), math.random(-sh / 2, sh / 2))
        local e = Entity.new({name = 'E' .. i, color = Color.random(0.5), pos = pos})
        world:addEntity(e)
    end

    updateTransform()
end

local keyFunMap = {
    escape = function() love.event.quit(0) end,
}

function love.update(dt)
    ScreenDebug.reset()
    ScreenDebug.printf('Scree: %s Scale: %g', screenRect:toString(), scale)
    ScreenDebug.printf('Mouse: %s Last Wheel: %s', mousePos:toString(), mouseWheelMoved:toString())
    ScreenDebug.printf('World: %s', world:toString())
end

function love.resize(w, h)
    screenRect:setSize(w, h)
    worldToScreen:scale(0.5)
end

function love.mousemoved(x, y, dx, dy)
    mousePos.x = x
    mousePos.y = y
end

function love.wheelmoved(x, y)
    mouseWheelMoved.x = x
    mouseWheelMoved.y = y
    local s = scale + (y)
    if s > 8 then
        s = 8
    elseif s < 1 then
        s = 1
    end
    scale = s
    updateTransform()
end

function love.keypressed(key, scancode, isrepeat)
    local keyFun = keyFunMap[key]
    if keyFun then keyFun() end
end

function love.draw()
    love.graphics.replaceTransform(worldToScreen)
    world:draw()
    love.graphics.reset()
    ScreenDebug.draw()
end
