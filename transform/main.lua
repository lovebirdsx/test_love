require('common.util')

local json = require('common.json')

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

local LeftButton = 1
local RightButton = 2
local MiddleButton = 3

local screenScale = .5
local screenRect = Box2.new(Vector2.new(0, 0), Vector2.new(love.graphics.getDimensions()))
local viewportPos = Vector2.new()
local worldToScreen = love.math.newTransform()
local screenToWorld = love.math.newTransform()
local mousePos = Vector2.new(0, 0)
local mousePressed = {false, false, false} ---@type boolean[]
local mousePressedTimes = {0, 0, 0} ---@type number[]
local mousePressedPoses = {Vector2.new(), Vector2.new(), Vector2.new()} ---@type Vector2[]
local mousePressedWorldPoses = {Vector2.new(), Vector2.new(), Vector2.new()} ---@type Vector2[]
local viewportPosWhileMousePressed = {Vector2.new(), Vector2.new(), Vector2.new()} ---@type Vector2[]
local mouseReleaseTimes = {0, 0, 0} ---@type number[]
local mouseReleasedPoses = {Vector2.new(), Vector2.new(), Vector2.new()} ---@type Vector2[]
local screenToWorldWhileMousePressed = {} ---@type Transform[]

local world = World.new()

local function updateTransform()
    local sw, sh = screenRect:getSize()
    worldToScreen:setTransformation(
        -viewportPos.x * screenScale,
        -viewportPos.y * screenScale,
        0,
        screenScale, screenScale,
        -sw / 2 / screenScale, -sh / 2 / screenScale,
        0, 0
    )
    screenToWorld = worldToScreen:inverse()
end

---@param p Vector2
local function screenPosToWorld(p)
    return Vector2.new(screenToWorld:transformPoint(p.x, p.y))
end

---@param p Vector2
local function worldPosToScreen(p)
    return Vector2.new(worldToScreen:transformPoint(p.x, p.y))
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

local function updateDrawDebug()
    ScreenDebug.reset()
    ScreenDebug.printf('Fps: %g ViewPortPos: %s ', love.timer.getFPS(), viewportPos)
    ScreenDebug.printf('Mouse: %s Scale: %g', mousePos, screenScale)
    ScreenDebug.printf('World: %s', world)
end

local function loadWorld()
    local s = love.filesystem.read(Config.WorldFile)
    if not s then return end

    local worldSnapshot = json.decode(s)
    world:applySnapshot(worldSnapshot)
    printf('load world form %s succeed', Config.WorldFile)
end

local function saveWorld()
    local worldSnapshot = world:genSnapshot()
    local ok, err = love.filesystem.write(Config.WorldFile, json.encode(worldSnapshot))
    if not ok then
        error(string.format('save world to %s failed', Config.WorldFile))
        return;
    end

    printf('save world to %s succeed', Config.WorldFile)
end

function love.load()
    loadWorld()
    updateTransform()
end

function love.quit()
    saveWorld()
	return false
end

local keyFunMap = {
    escape = function() love.event.quit(0) end,
    s = function() saveWorld() end,
    l = function() loadWorld() end,
}

function love.update(dt)
    updateDrawDebug()
end

function love.resize(w, h)
    screenRect:setSize(w, h)
end

function love.mousepressed(x, y, button, istouch)
    mousePressed[button] = true
    mousePressedTimes[button] = love.timer.getTime()
    mousePressedPoses[button]:set(x, y)
    mousePressedWorldPoses[button]:set(screenToWorld:transformPoint(x, y))
    viewportPosWhileMousePressed[button]:set(viewportPos.x, viewportPos.y)
    screenToWorldWhileMousePressed[button] = screenToWorld:clone()

    if button == RightButton then
        love.mouse.setCursor(love.mouse.getSystemCursor('hand'))
    end
end

function love.mousereleased(x, y, button)
    mousePressed[button] = false
    mouseReleaseTimes[button] = love.timer.getTime()
    mouseReleasedPoses[button]:set(x, y)

    if button == LeftButton then
        if Vector2.distance(mousePressedPoses[button], mouseReleasedPoses[button]) < 10  then
            onMouseButtonDown(mouseReleasedPoses[button])
        end
    elseif button == RightButton then
        love.mouse.setCursor(love.mouse.getSystemCursor('arrow'))
    end
end

function love.mousemoved(x, y, dx, dy)
    mousePos:set(x, y)

    if mousePressed[RightButton] then
        viewportPos =
            viewportPosWhileMousePressed[RightButton]
            - Vector2.new(screenToWorldWhileMousePressed[RightButton]:transformPoint(x, y))
            + mousePressedWorldPoses[RightButton]
        updateTransform()
    end
end

function love.wheelmoved(x, y)
    local s = screenScale + (y * screenScale * Config.ScaleRate)
    if s > Config.MaxScale then
        s = Config.MaxScale
    elseif s < Config.MinScale then
        s = Config.MinScale
    end

    local mouseWorldPos = screenPosToWorld(mousePos)

    screenScale = s
    updateTransform()

    -- 滚轮缩放时, 是以鼠标所在位置进行缩放
    -- 鼠标所在位置和屏幕中心的位置保持不变
    local mouseWorldPos2 = screenPosToWorld(mousePos)
    viewportPos = viewportPos + (mouseWorldPos - mouseWorldPos2)
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
