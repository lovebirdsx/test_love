local M = {
    MaxScale = 2, -- 屏幕的最大缩放
    MinScale = 1 / 8, -- 屏幕的最小缩放
    ScaleRate = .25, -- 鼠标滚轮进行缩放时的比例参数
    WorldFile = 'World.json', -- 世界存储的文件位置
}

-- 参考 https://love2d.org/wiki/Config_Files
function M.configLove2d(t)
    t.identity = nil                    -- The name of the save directory (string)
    t.appendidentity = false            -- Search files in source directory before save directory (boolean)
    t.version = '11.3'                  -- The LÖVE version this game was made for (string)
    t.console = true                   -- Attach a console (boolean, Windows only)
    t.accelerometerjoystick = true      -- Enable the accelerometer on iOS and Android by exposing it as a Joystick (boolean)
    t.externalstorage = false           -- True to save files (and read from the save directory) in external storage on Android (boolean) 
    t.gammacorrect = false              -- Enable gamma-correct rendering, when supported by the system (boolean)

    t.audio.mic = false                 -- Request and use microphone capabilities in Android (boolean)
    t.audio.mixwithsystem = true        -- Keep background music playing when opening LOVE (boolean, iOS and Android only)

    t.window.title = 'transform' 
    t.window.x = 1                    -- The x-coordinate of the window's position in the specified display (number)
    t.window.y = 30                    -- The y-coordinate of the window's position in the specified display (number)
    t.window.width = 960                -- The window width (number)
    t.window.height = 1020               -- The window height (number)
    t.window.resizable = true          -- Let the window be user-resizable (boolean)
    t.window.borderless = false         -- Remove all border visuals from the window (boolean)
    t.window.display = 2                -- Index of the monitor to show the window in (number)
    t.window.icon = nil                 -- Filepath to an image to use as the window's icon (string)
    t.window.minwidth = 1               -- Minimum window width if the window is resizable (number)
    t.window.minheight = 1              -- Minimum window height if the window is resizable (number)
    t.window.fullscreen = false         -- Enable fullscreen (boolean)
    t.window.fullscreentype = 'desktop' -- Choose between 'desktop' fullscreen or 'exclusive' fullscreen mode (string)
    t.window.vsync = 1                  -- Vertical sync mode (number)
    t.window.msaa = 0                   -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.depth = nil                -- The number of bits per sample in the depth buffer
    t.window.stencil = nil              -- The number of bits per sample in the stencil buffer
    t.window.highdpi = false            -- Enable high-dpi mode for the window on a Retina display (boolean)
    t.window.usedpiscale = true         -- Enable automatic DPI scaling when highdpi is set to true as well (boolean)

    t.modules.event = true
    t.modules.font = true
    t.modules.graphics = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.window = true
    t.modules.keyboard = true
    t.modules.timer = true
    
    t.modules.system = false
    t.modules.image = false
    t.modules.audio = false
    t.modules.data = false
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.sound = false
    t.modules.thread = false
    t.modules.touch = false
    t.modules.video = false
end

return M
