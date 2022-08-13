local config = require('common.config')

function love.conf(t)
    t.window.title = "Hello"
    t.window.width = config.width
    t.window.height = config.height
    t.window.display = config.display
end