---@type Zenitha.Scene
local scene = {}

local t1, t2 = .26, .42

function scene.load()
    love.keyboard.setKeyRepeat(false)
end

scene.keyDown = TRUE

function scene.update(dt)
    dt = math.min(dt, 1 / 30)
    if TASK.lock('init') then
    elseif t1 > 0 then
        t1 = t1 - dt
        if t1 <= 0 then
            TEXTS.load:set("GETTING READY TO SPECTATE...")
            BGM.setMaxSources(11)
            BGM.load(FILE.load('module/bgm_data.lua', '-luaon'))
            SFX.load('assets/sfx.ogg', FILE.load('module/sfx_data.lua', '-luaon'))
            SFX.setVol(.872)
            GAME.updateBgm('init')
            TASK.new(Daemon_Sync)
            TASK.new(Daemon_Beat)
            TASK.new(Daemon_Floor)
            ---@diagnostic disable-next-line
            local _ = TEXTURE.glass_a, TEXTURE.glass_b, TEXTURE.throb_a, TEXTURE.throb_b
            for i=1,10 do TEXTURE.floorBG[i]:setWrap('repeat', 'repeat') end
        end
    elseif t2 > 0 then
        t2 = t2 - dt
        if t2 <= 0 then
            SCN.swapTo('tower')
        end
    end
end

function scene.draw()
    GC.setColor(.2, .2, .2)
    GC.strokeDraw('full', 7, TEXTS.load, 800, 500, 0, 1.26, 2, TEXTS.load:getWidth() / 2, TEXTS.load:getHeight() / 2)
    GC.setColor(.4, .4, .4)
    GC.strokeDraw('full', 4, TEXTS.load, 800, 500, 0, 1.26, 2, TEXTS.load:getWidth() / 2, TEXTS.load:getHeight() / 2)
    GC.setColor(.6, .6, .6)
    GC.strokeDraw('full', 2, TEXTS.load, 800, 500, 0, 1.26, 2, TEXTS.load:getWidth() / 2, TEXTS.load:getHeight() / 2)
    GC.setColor(.9, .9, .9)
    GC.mDraw(TEXTS.load, 800, 500, 0, 1.26, 2)
end

return scene
