require('common.util')

local ScreenDebug = require('common.screen_debug')
local Config = require('common.config')

local Box2 = require('common.box2')
local Vector2 = require('common.vector2')
local World = require('common.world')
local Entity = require('common.entity')
local Color = require('common.color')

local MouseDragState = {
    Idle = 0,
    Prepare = 1,
    Dragging = 2,
}

local screenScale = 1
local screenRect = Box2.new(Vector2.new(0, 0), Vector2.new(love.graphics.getDimensions()))
local viewportPos = Vector2.new(screenRect:getCenter())
local worldToScreen = love.math.newTransform()
local screenToWorld = love.math.newTransform()
local mousePos = Vector2.new(0, 0)
local mouseWheelMoved = Vector2.new(0, 0)
local mousePressedTime = 0
local mousePressedPos = Vector2.new(0, 0)
local mousePressedWorldPos = Vector2.new(0, 0)
local mouseReleaseTime = 0
local mouseReleasedPos = Vector2.new(0, 0)
local mouseMoveDistanceFromPressed = 0
local mouseDragState = MouseDragState.Idle

local world = World.new()

local function updateTransform()
    worldToScreen:setTransformation(viewportPos.x, viewportPos.y, 0, screenScale, screenScale, 0, 0, 0, 0)
    screenToWorld = worldToScreen:inverse()
end

local function updateDragPos()
    
end

---@param pos Vector2 | nil
---@return Entity
local function createEntity(pos)
    if not pos then
        local sw, sh = screenRect:getSize()
        local x, y = screenToWorld:transformPoint(math.random(-sw / 2, sw / 2), math.random(-sh / 2, sh / 2))
        pos = Vector2.new(math.floor(x), math.floor(y))
    end

    local entity = Entity.new({
        world = world,
        name = 'E' .. world:genEntityId(),
        color = Color.Green,
        pos = Vector2.new(pos.x, pos.y)
    })
    return entity
end

---@param pos Vector2
local function onMouseButtonDown(pos)
    local px, py = screenToWorld:transformPoint(pos.x, pos.y)    
    world:addEntity(createEntity(Vector2.new(math.floor(px), math.floor(py))))
end

---@type Vector2
local dragStartWorldPos = Vector2.new()

---@param pos Vector2
local function onMouseButtonDragStart(pos)
    dragStartWorldPos = Vector2.new(screenToWorld:transformPoint(pos.x, pos.y))
end

---@param pos Vector2
local function onMouseButtonDrag(pos)
    local mouseWorldPos = Vector2.new(screenToWorld:transformPoint(pos.x, pos.y))
    local worldOffset = mouseWorldPos - mousePressedWorldPos
    printf('worldOffset: %s', worldOffset)
    viewportPos = viewportPos + worldOffset
    updateTransform()
end

---@param pos Vector2
local function onMouseButtonDragEnd(pos)
    print('onMouseButtonDragEnd', pos)
end

local function updateDrawDebug()
    ScreenDebug.reset()
    ScreenDebug.printf('viewPortPos: %s DragStartWorldPos: %s', viewportPos, dragStartWorldPos)
    ScreenDebug.printf('Mouse: %s Scale: %g', mousePos, screenScale)
    ScreenDebug.printf('World: %s', world)
end

local function updateMouse()
    if mouseDragState == MouseDragState.Prepare then
        if love.timer.getTime() - mousePressedTime > Config.DragDetectTime then
            mouseDragState = MouseDragState.Dragging
            onMouseButtonDragStart(mousePos)
        end
    end
end

function love.load()
    for i = 1, 10 do
        world:addEntity(createEntity())
    end

    updateTransform()
end

local keyFunMap = {
    escape = function() love.event.quit(0) end,
}

function love.update(dt)
    updateMouse()
    updateDrawDebug()
end

function love.resize(w, h)
    screenRect:setSize(w, h)
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        mousePressedTime = love.timer.getTime()
        mouseMoveDistanceFromPressed = 0
        mousePressedPos:set(x, y)
        mousePressedWorldPos:set(screenToWorld:transformPoint(x, y))

        if mouseDragState == MouseDragState.Idle then
            mouseDragState = MouseDragState.Prepare
        end
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        mouseReleaseTime = love.timer.getTime()
        mouseReleasedPos:set(x, y)
        
        if Vector2.distance(mousePressedPos, mouseReleasedPos) < 10  then
            onMouseButtonDown(mouseReleasedPos)
        end

        if mouseDragState == MouseDragState.Dragging then
            onMouseButtonDragEnd(mousePos)
        end

        mouseDragState = MouseDragState.Idle
    end
end

function love.mousemoved(x, y, dx, dy)
    mousePos:set(x, y)
    mouseMoveDistanceFromPressed = mouseMoveDistanceFromPressed + math.sqrt(dx * dx, dy * dy)

    if mouseDragState == MouseDragState.Dragging then
        onMouseButtonDrag(mousePos)
    end

    updateDragPos()
end

function love.wheelmoved(x, y)
    mouseWheelMoved.x = x
    mouseWheelMoved.y = y
    local s = screenScale + (y * screenScale * Config.ScaleRate)
    if s > Config.MaxScale then
        s = Config.MaxScale
    elseif s < Config.MinScale then
        s = Config.MinScale
    end
    screenScale = s
    updateTransform()
end

function love.keypressed(key, scancode, isrepeat)
    local keyFun = keyFunMap[key]
    if keyFun then keyFun() end
end

function love.draw()
    if mouseDragState == MouseDragState.Dragging then
        drawLine(mousePressedPos, mousePos, Color.Green)
    end
    
    love.graphics.replaceTransform(worldToScreen)
    
    if mouseDragState == MouseDragState.Dragging then
        local pos1 = Vector2.new(screenToWorld:transformPoint(mousePressedPos.x, mousePressedPos.y))
        local pos2 = Vector2.new(screenToWorld:transformPoint(mousePos.x, mousePos.y))
        drawLine(pos1, pos2, Color.Red)
    end

    world:draw()
    love.graphics.reset()
    ScreenDebug.draw()
end
