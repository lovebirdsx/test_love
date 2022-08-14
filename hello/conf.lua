local Config = require('common.config')

-- 参考 https://love2d.org/wiki/Config_Files
function love.conf(t)
    Config.configLove2d(t)
end