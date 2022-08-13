local config = require('common.config')

-- 参考 https://love2d.org/wiki/Config_Files
function love.conf(t)
    t.window.title = "Hello"
    t.window.x = config.X
    t.window.y = config.Y
    t.window.width = config.Width
    t.window.height = config.Height
    t.window.display = config.Display
end