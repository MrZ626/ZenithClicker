---@type Zenitha.Scene
local scene = {}

local t1, t2 = .26, .42

function scene.load()
    love.keyboard.setKeyRepeat(false)
end

scene.keyDown = TRUE

function scene.update(dt)
    dt = math.min(dt, 1 / 26)
    if TASK.lock('init') then
    elseif t1 > 0 then
        t1 = t1 - dt
        if t1 <= 0 then
            TEXTS.load:set("GETTING READY TO SPECTATE...")
            BGM.setMaxSources(42)
            BGM.load(FILE.load('module/bgm_data.lua', '-luaon'))
            SFX.load('assets/sfx.ogg', FILE.load('module/sfx_data.lua', '-luaon'))
            SFX.load('garbagewindup_5', 'assets/windup_5.ogg')
            TASK.new(Daemon_Slow)
            TASK.new(Daemon_Fast)
            ---@diagnostic disable-next-line
            local _ = TEXTURE.panel.glass_a, TEXTURE.panel.glass_b, TEXTURE.panel.throb_a, TEXTURE.panel.throb_b
            for i = 2, 9 do TEXTURE.towerBG[i]:setWrap('mirroredrepeat', 'mirroredrepeat') end
            TEXTURE.towerBG[1]:setWrap('mirroredrepeat', 'clampzero')
            TEXTURE.towerBG[10]:setWrap('mirroredrepeat', 'clampzero')
            _, _ = TEXTURE.moon, TEXTURE.stars
        end
    elseif t2 > 0 then
        t2 = t2 - dt
        if t2 <= 0 then
            PlayBGM('f0')
            SCN.swapTo('tower')
        end
    end
end

function scene.draw()
    GC.setColor(.2, .2, .2)
    GC.strokeDraw('full', 5, TEXTS.load, 800, 500, 0, 1.6, 2, TEXTS.load:getWidth() / 2, TEXTS.load:getHeight() / 2)
    GC.setColor(.4, .4, .4)
    GC.strokeDraw('full', 3, TEXTS.load, 800, 500, 0, 1.6, 2, TEXTS.load:getWidth() / 2, TEXTS.load:getHeight() / 2)
    GC.setColor(.6, .6, .6)
    GC.strokeDraw('full', 1, TEXTS.load, 800, 500, 0, 1.6, 2, TEXTS.load:getWidth() / 2, TEXTS.load:getHeight() / 2)
    GC.setColor(.9, .9, .9)
    GC.mDraw(TEXTS.load, 800, 500, 0, 1.6, 2)
end

return scene
