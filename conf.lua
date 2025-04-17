if love['_os'] == 'Web' then
    local _read = love.filesystem.read
    local _getinfo = love.filesystem.getInfo
    love.filesystem[('read')] = function(name, size)
        if _getinfo(name) then return _read(name, size) end
    end
    if math.log(8, 2) ~= 3 then
        -- Fix log function if it doesn't support base
        local log = math.log
        math[('log')] = function(x, base)
            return base and log(x) / log(base) or log(x)
        end
    end
end

function love.conf(t)
    local identity = 'Zenith_Clicker'
    local mobile = love._os == 'Android' or love._os == 'iOS'

    local fs = love.filesystem
    fs.setIdentity(identity)

    t.identity = 'Zenith_Clicker'
    t.externalstorage = true
    t.version = "11.4"
    t.gammacorrect = false
    t.appendidentity = true
    t.accelerometerjoystick = false
    if t.audio then
        t.audio.mic = false
        t.audio.mixwithsystem = true
    end

    local M = t.modules
    M.window, M.system, M.event, M.thread = true, true, true, true
    M.timer, M.math, M.data = true, true, true
    M.video, M.audio, M.sound = true, true, true
    M.graphics, M.font, M.image = true, true, true
    M.mouse, M.touch, M.keyboard, M.joystick = true, true, true, true
    M.physics = false

    local W = t.window
    W.vsync = 0
    W.msaa = 4
    W.depth = 0
    W.stencil = 0
    W.display = 1
    W.highdpi = true
    W.x, W.y = nil, nil
    W.borderless = mobile
    W.resizable = not mobile
    W.fullscreentype = mobile and 'exclusive' or 'desktop' -- Fullscreen type
    W.width, W.height = 1440, 900
    W.minwidth, W.minheight = 288, 180
    W.title = 'Zenith Clicker'

    if love._os == 'Linux' and fs.getInfo('assets/icon.png') then
        W.icon = 'assets/icon.png'
    end
end
