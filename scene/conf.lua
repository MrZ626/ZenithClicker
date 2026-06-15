---@type Zenitha.Scene
local scene = {}


-- 1. Video & Audio
-- 2. User
-- 3. Album
local page = 1
local maxPage = 3
local uidList = {} ---@type ({uid: string, modTime?: string} | false)[]

local anonUser
local resetall_cnt, resetall_anim, lastClear

local clr = {
    D = { COLOR.HEX '191E31FF' },
    L = { COLOR.HEX '4D67A6FF' },
    T = { COLOR.HEX '6F82ACFF' },
    LT = { COLOR.HEX 'B0CCEBFF' },
    cbFill = { COLOR.HEX '0B0E17FF' },
    cbFrame = { COLOR.HEX '6A82A7FF' },
}
local colorRev = false
local bindBuffer
local playingBgmTitle = 'Philosophyz'
local playingBgmLength = 2202.8
local playingBgmLengthStr = '22:02.8'
local songList = {
    f0 = "Dr Ocelot - Watchful Eye",
    f1 = "Dr Ocelot - Divine Registration",
    f2 = "Dr Ocelot - Zenith Hotel",
    f3 = "Dr Ocelot - Empty Prayers",
    f4 = "Dr Ocelot - Crowd Control",
    f5 = "Dr Ocelot - Phantom Memories",
    f6 = "Dr Ocelot - Echo",
    f7 = "Dr Ocelot - Cryptic Chemistry",
    f8 = "Dr Ocelot - Chrono Flux",
    f9 = "Dr Ocelot - Broken Record",
    f10 = "petrtech - Deified Validation",
    tera = "Dr Ocelot - Schnellfeuer BULLET",

    f0r = "Dr Ocelot - Awaiting Judgement",
    f1r = "Dr Ocelot - Desecrated Ruins",
    f2r = "Dr Ocelot - The Age of Vanity",
    f3r = "Dr Ocelot - A Rigged Game",
    f4r = "Dr Ocelot - Spectacles of Violence",
    f5r = "Dr Ocelot - The Past Repeats",
    f6r = "Dr Ocelot - Damning Evidence",
    f7r = "Dr Ocelot - Cryptic Heresy",
    f8r = "Dr Ocelot - Futile Ambition",
    f9r = "Dr Ocelot - Mere Sacrifices",
    f10r = "petrtech - Pseudo-Apotheosis",
    terar = "Dr Ocelot - Kugelhagel OVERDRIVE",

    fomg = "Ronezkj15 - Strained Endurance",
    f0_EX = "Dr Ocelot - Watchful Eye (EX)",
    f0r_EX = "Dr Ocelot - Awaiting Judgement (EX)",
    f1_EX = "Dr Ocelot - Infernal Registration",
    f1r_EX = "Dr Ocelot - Desecrated Ruins (EX)",
}
local bgmColors = {
    f1 = { COLOR.HEX 'E46A24' },
    f2 = { COLOR.HEX 'F1CC80' },
    f3 = { COLOR.HEX '804200' },
    f4 = { COLOR.HEX '8E1D1D' },
    f5 = { COLOR.HEX 'B8C1C1' },
    f6 = { COLOR.HEX 'EAA380' },
    f7 = { COLOR.HEX '70B5E1' },
    f8 = { COLOR.HEX 'F16A77' },
    f9 = { COLOR.HEX '3DA878' },
    f10 = { COLOR.HEX 'AD80F5' },
    f1r = { COLOR.HEX 'E46A24' },
    f2r = { COLOR.HEX 'F1CC80' },
    f3r = { COLOR.HEX '804200' },
    f4r = { COLOR.HEX '8E1D1D' },
    f5r = { COLOR.HEX 'B8C1C1' },
    f6r = { COLOR.HEX 'EAA380' },
    f7r = { COLOR.HEX '70B5E1' },
    f8r = { COLOR.HEX 'F16A77' },
    f9r = { COLOR.HEX '3DA878' },
    f10r = { COLOR.HEX 'AD80F5' },

    f0 = { COLOR.HEX '8C2B15' },
    f0r = { COLOR.HEX '8C2B15' },
    tera = { COLOR.HEX 'C0C0C0' },
    terar = { COLOR.HEX 'C0C0C0' },
    fomg = { COLOR.HEX '004C89' },
}
local bgmHeight = {
    [0] = Floors[0].top,
    Floors[0].top,
    Floors[1].top,
    Floors[2].top,
    Floors[3].top,
    Floors[4].top,
    Floors[5].top,
    Floors[6].top,
    Floors[7].top,
    Floors[8].top,
    Floors[9].top + 10,
    Floors[9].top + 26, -- special
}

local function refreshWidgets()
    for _, W in next, scene.widgetList do W:setVisible() end
end

local function timePast(t1, t2)
    if not t1 then return "unknown" end
    local diff = math.abs(t2 - t1)
    local unit
    if diff < 60 then
        return "just now"
    elseif diff < 3600 then
        diff = math.floor(diff / 60)
        unit = 'm'
    elseif diff < 86400 then
        diff = math.floor(diff / 3600)
        unit = 'h'
    elseif diff < 2592000 then
        diff = math.floor(diff / 86400)
        unit = 'd'
    elseif diff < 31536000 then
        diff = math.floor(diff / 2592000)
        unit = 'mo'
    else
        diff = math.floor(diff / 31536000)
        unit = 'y'
    end
    return diff .. unit .. (t2 > t1 and " ago" or " from future")
end
local function refreshUID()
    anonUser = STAT.uid:sub(1, 5) == 'ANON-'
    TABLE.clear(uidList)
    uidList[0] = { uid = "Active Profile:   " .. STAT.uid, modTime = "just now" }
    for i = 1, 3 do
        local dat = FILE.safeLoad('save' .. i .. "/stat.luaon")
        uidList[i] = dat and { uid = dat.uid, modTime = timePast(dat.modTime, os.time()) } or false
    end
end

local sp = { f0 = 1, f1 = 1, f0r = 1, f1r = 1 }
local function refreshSongInfo()
    if sp[SongNamePlaying] then
        playingBgmTitle = songList[SongNamePlaying .. (GAME.mod.EX > 0 and '_EX' or '')]
    else
        playingBgmTitle = songList[SongNamePlaying] or "Rewrite"
    end
    playingBgmLength = BGM.getDuration()
    playingBgmLengthStr = STRING.time_simp(playingBgmLength)
    GAME.refreshRPC()
end

function scene.load()
    MSG.clear()
    bindBuffer = nil
    resetall_cnt, resetall_anim, lastClear = 0, 0, false

    SetMouseVisible(true)
    if GAME.anyRev ~= colorRev then
        colorRev = GAME.anyRev
        for _, C in next, clr do
            C[1], C[3] = C[3], C[1]
        end
    end
    TASK.unlock('changeName')
    TASK.unlock('changeAboutme')
    TASK.unlock('export')
    TASK.unlock('import')
    TASK.unlock('rebind_control')
    TASK.unlock('just_saved')
    refreshWidgets()
    refreshSongInfo()
    refreshUID()
end

-- function scene.unload()
--     SaveStat()
-- end

local bindHint = {
    "CARD-1",
    "CARD-2",
    "CARD-3",
    "CARD-4",
    "CARD-5",
    "CARD-6",
    "CARD-7",
    "CARD-8",
    "CARD-9",
    "CARD-1 (2nd)",
    "CARD-2 (2nd)",
    "CARD-3 (2nd)",
    "CARD-4 (2nd)",
    "CARD-5 (2nd)",
    "CARD-6 (2nd)",
    "CARD-7 (2nd)",
    "CARD-8 (2nd)",
    "CARD-9 (2nd)",
    "COMMIT",
    "RESET",
    "LEFTCLK",
    "RIGHTCLK",
}

local KBisDown = love.keyboard.isDown
local function isLegalKey(key)
    if key:find('ctrl') or key:find('alt') or key == 'f1' or key == 'f2' or key == 'tab' or key == '`' then
        SFX.play('finessefault', .626)
        return false
    elseif key:match('^f%d%d?$') then
        return false
    else
        return true
    end
end
function scene.keyDown(key, isRep)
    if isRep then return true end
    if bindBuffer then
        if key == 'escape' then
            bindBuffer = nil
            MSG('dark', "Keybinding cancelled")
            SFX.play('staffwarning')
        elseif isLegalKey(key) then
            if TABLE.find(bindBuffer, key) then
                MSG('dark', "Keybinding should not repeat!", 1)
                SFX.play('finessefault')
            else
                table.insert(bindBuffer, key)
                if #bindBuffer >= 22 then
                    CONF.keybind = bindBuffer
                    bindBuffer = nil
                    SaveConf()
                    MSG('dark', "Keybinding updated.")
                    SFX.play('social_notify_major')
                else
                    SFX.play('irs')
                end
            end
        end
    else
        if key == 'escape' or key == 'f1' then
            SaveConf()
            SFX.play('menuclick')
            SCN.back('none')
        elseif MATH.between(tonumber(key) or 0, 1, maxPage) then
            local p = tonumber(key)
            if p and p ~= page then
                page = p
                SFX.play('menuclick')
                refreshWidgets()
            end
        elseif page == 3 then
            if key == 'left' then
                TASK.removeTask_code(Task_MusicEnd)
                BGM.set('all', 'seek', math.max(BGM.tell() - (KBisDown('lctrl', 'rctrl') and 26 or 5), 0))
            elseif key == 'right' then
                TASK.removeTask_code(Task_MusicEnd)
                BGM.set('all', 'seek', math.min(BGM.tell() + (KBisDown('lctrl', 'rctrl') and 26 or 5), BGM.getDuration()))
            elseif key == 'home' then
                TASK.removeTask_code(Task_MusicEnd)
                BGM.set('all', 'seek', 0)
            elseif key == 'end' then
                TASK.new(Task_MusicEnd, true)
            elseif key == 'space' then
                BgmLooping, BgmNeedSkip = false, false
            end
            return true
        end
    end
    ZENITHA._cursor.active = true
    return true
end

scene.resize = refreshWidgets

-- Panel size
local w, h = 900, 830
local baseX, baseY = 800 - w / 2, 500 - h / 2 + 10

local gc = love.graphics
local gc_replaceTransform = gc.replaceTransform
local gc_draw, gc_setColor, gc_rectangle = gc.draw, gc.setColor, gc.rectangle
local gc_print, gc_printf = gc.print, gc.printf
local gc_ucs_move, gc_ucs_back = GC.ucs_move, GC.ucs_back
local gc_setAlpha, gc_mRect, gc_mStr = GC.setAlpha, GC.mRect, GC.mStr
local setFont = FONT.set
local function drawSliderComponents(y, title, t1, t2, value)
    gc_ucs_move(0, y)
    gc_setColor(0, 0, 0, .26)
    gc_mRect('fill', w / 2, 0, w - 40, 65, 5)
    gc_mRect('fill', w - 90, 0, 123, 48, 3)
    setFont(30)
    gc_setColor(clr.T)
    gc_print(title, 40, -20, 0, .85, 1)
    gc_setAlpha(.42)
    gc_print(t1, 326, 5, 0, .5)
    gc_printf(t2, w - 355, 5, 355, 'right', 0, .5)
    gc_setColor(clr.T)
    gc_mStr(value, w - 100, -20)
    gc_setColor(clr.L)
    gc_print("%", w - 60, -20, 0, .85, 1)
    gc_ucs_back()
end

local playing
function scene.update(dt)
    if SongNamePlaying ~= playing then
        refreshSongInfo()
        playing = SongNamePlaying
    end
    if page == 3 and (BgmPlaying == 'tera' or BgmPlaying == 'terar') then
        GAME.height = GAME.height + dt * (BgmPlaying == 'tera' and 20 or 42) * (GAME.height >= 1650 and .2 or 1)
        if GAME.height >= 1726 then GAME.bgH, GAME.height = -30, -30 end
        dt = dt * 2.6
    end
    GAME.bgH = MATH.expApproach(GAME.bgH, GAME.height, dt * 1.6)
    StarPS:moveTo(0, -GAME.bgH * 2 * BgScale)
    StarPS:update(dt)
    if not TASK.getLock('reset_all') then resetall_cnt = 0 end
    resetall_anim = MATH.expApproach(resetall_anim, resetall_cnt / 16, dt * 12)
end

function scene.draw()
    DrawBG(CONF.bgBrightness)

    -- Panel
    gc_replaceTransform(SCR.xOy)
    gc.translate(baseX, baseY)
    gc_setColor(clr.D)
    gc_rectangle('fill', 0, 0, w, h)
    gc_setColor(0, 0, 0, .26)
    gc_rectangle('fill', 3, 3, w - 6, h - 6)
    gc_setColor(1, 1, 1, .1)
    gc_rectangle('fill', 0, 0, w, 3)
    gc_setColor(1, 1, 1, .04)
    gc_rectangle('fill', 0, 3, 3, h + 3)

    local t = love.timer.getTime()
    if page == 1 then
        -- Sliders
        drawSliderComponents(120, "EFFECT VOLUME", "QUIET (F3)", "LOUD (F3)", CONF.sfx)
        drawSliderComponents(200, "MUSIC VOLUME", "QUIET (F4)", "LOUD (F4)", CONF.bgm)
        drawSliderComponents(430, "CARD  BRIGHTNESS", "DARK (F5)", "BRIGHT (F6)", CONF.cardBrightness)
        drawSliderComponents(510, "BG  BRIGHTNESS", "DARK (F7)", "BRIGHT (F8)", CONF.bgBrightness)

        -- Keybind
        if bindBuffer then
            setFont(30)
            gc_print("Press key for...", 600, 670, 0, .872)
            gc_print(bindHint[#bindBuffer + 1], 600, 700, 0, .872)
        end
    elseif page == 2 then
        if resetall_anim > .1 then
            local t2 = MATH.iLerp(.1, 1, resetall_anim)
            gc_setColor(1, 1, 1, t2 * .42)
            GC.mDraw(TEXTURE.warning, w / 2, h / 2, 0, MATH.lerp(1, 2.6, t2) ^ 2.6)
            GC.setLineWidth(2)
            gc_setColor(1, t % .16 < .08 and 0 or 1, 0, resetall_anim * 2)
            gc_mRect('line', 450, 420, 520, 140, 20)
        end
        gc_setColor((anonUser and -t or TASK.getLock('just_saved') or 0) % .5, 0, 0, .26)
        gc_mRect('fill', 450, 420, 520, 140, 20)
        gc_setColor(1, t % .16 < .08 and .2 + resetall_anim * .6 or .2, .2, resetall_anim ^ .26 * .26)
        gc_mRect('fill', 450, 420, 520 * resetall_anim, 140, 20)
        gc_setColor(1, 1, 1, .1)
        setFont(50)
        gc_print("0", 200, 345)
        setFont(30)
        gc_setColor(clr.LT)
        gc_mStr(uidList[0].uid, 450, 360)
        for i = 1, 3 do
            local y = 220 + 330 + (i - 1) * 90
            gc_setColor(1, 1, 1, .1)
            setFont(50)
            gc_print(i, 30, y - 45)
            setFont(30)
            gc_setColor(0, 0, 0, .26)
            gc_mRect('fill', 450, y, 860, 80, 20)
            gc_setColor(clr.L)
            if uidList[i] then
                gc_mStr(uidList[i].modTime, 140, y - 20 + 15)
                gc_setColor(clr.LT)
                gc_mStr(uidList[i].uid, 140, y - 20 - 15)
            else
                gc_mStr("[empty]", 140, y - 20)
            end
        end
    elseif page == 3 then
        -- Music player
        local len = 800

        local playTime = BGM.tell()

        gc_ucs_move(50, 120)

        -- Time
        setFont(30)
        gc_setColor(clr.T)
        gc_print(STRING.time_simp(playTime), 0, 49, 0, .626)
        gc_print(playingBgmLengthStr, len - 45, 49, 0, .626)

        -- Repeat marks
        local data = BgmData[BgmPlaying]
        if BgmLooping then
            if data.loop[1] == 0 then
                gc_print('D.C.', len * data.loop[2] / playingBgmLength, 35, 0, .3)
            else
                gc_print('S', len * data.loop[1] / playingBgmLength, 35, 0, .3)
                gc_print('D.S.', len * data.loop[2] / playingBgmLength, 35, 0, .3)
            end
        end

        -- Progress bar
        gc_setColor(clr.L)
        gc_rectangle('fill', 0, 46, len, 4)
        if BgmPlaying == 'tera' then
            gc_setColor(COLOR.rainbow_light(2.6 * t))
        elseif BgmPlaying == 'terar' then
            gc_setColor(COLOR.rainbow_light(20 * t))
        else
            gc_setColor(bgmColors[SongNamePlaying])
        end
        gc_rectangle('fill', 0, 46, len * playTime / playingBgmLength, 4)

        -- Ambient Glow
        gc.push('transform')
        gc_replaceTransform(SCR.origin)
        if BgmPlaying == 'tera' or BgmPlaying == 'terar' then
            gc_setAlpha(.42)
        else
            gc_setAlpha(.26 - .12 * MusicBeat)
        end
        gc_draw(TEXTURE.transition, 0, 0, 0, .42 / 128 * SCR.w, SCR.h)
        gc_draw(TEXTURE.transition, SCR.w, 0, 0, -.42 / 128 * SCR.w, SCR.h)
        gc.pop()

        -- Title
        gc_setAlpha(1)
        gc_mStr(playingBgmTitle, len / 2, 0)
        if not (BgmPlaying == 'tera' or BgmPlaying == 'terar') then
            gc_setColor(1, 1, 1, MATH.lerp(.62, .26, MusicBeat))
            gc_mStr(playingBgmTitle, len / 2, -1.26)
        end
        gc_setColor(clr.LT)
        gc_setAlpha(.26)
        gc_printf(data.meta, len / 2, 56, 2 * len, 'center', 0, .42, .42, len)

        -- Skip marks
        if BgmNeedSkip then
            local alpha = .26 + .62 * (-2.6 * t % 1)
            gc_setColor(COLOR.C)
            gc_setAlpha(alpha)
            gc_mRect('fill', len * BgmNeedSkip[1] / playingBgmLength, 48, 2, 9)
            gc_setColor(COLOR.O)
            gc_setAlpha(alpha)
            gc_mRect('fill', len * BgmNeedSkip[2] / playingBgmLength, 48, 2, 9)
        end
        gc_ucs_back()
    end

    -- Top bar & title
    gc_replaceTransform(SCR.xOy_u)
    gc_setColor(clr.D)
    gc_rectangle('fill', -1300, 0, 2600, 70)
    gc_setColor(clr.L)
    gc_setAlpha(.626)
    gc_rectangle('fill', -1300, 70, 2600, 3)
    gc_replaceTransform(SCR.xOy_ul)
    gc_setColor(clr.L)
    setFont(50)
    if GAME.anyRev then
        gc_print("CONFIG", 15, 68, 0, 1, -1)
    else
        gc_print("CONFIG", 15, 0)
    end

    -- Bottom bar & text
    gc_replaceTransform(SCR.xOy_d)
    gc_setColor(clr.D)
    gc_rectangle('fill', -1300, 0, 2600, -50)
    gc_setColor(clr.L)
    gc_setAlpha(.626)
    gc_rectangle('fill', -1300, -50, 2600, -3)
    gc_replaceTransform(SCR.xOy_dl)
    gc_setColor(clr.L)
    setFont(30)
    gc_print("TWEAK YOUR SETTINGS FOR A BETTER CLICKING EXPERIENCE", 15, -45, 0, .85, 1)
end

-- widget lists of each page, will be registered to scene.widgetList at the end
local pages = {}

local videoY = baseY + 360
pages[1] = {
    WIDGET.new { -- title
        type = 'text', alignX = 'left',
        text = "AUDIO",
        color = clr.T,
        fontSize = 50,
        x = baseX + 30, y = baseY + 50,
    },
    WIDGET.new { -- sfx
        type = 'slider',
        x = baseX + 240 + 85, y = baseY + 110, w = 400,
        axis = { 0, 100, 10 },
        frameColor = 'dD', fillColor = clr.D,
        disp = function() return CONF.sfx end,
        code = function(value)
            CONF.sfx = value
            ApplySettings()
        end,
        sound_drag = 'rotate',
    },
    WIDGET.new { -- bgm
        type = 'slider',
        x = baseX + 240 + 85, y = baseY + 190, w = 400,
        axis = { 0, 100, 10 },
        frameColor = 'dD', fillColor = clr.D,
        disp = function() return CONF.bgm end,
        code = function(value)
            CONF.bgm = value
            ApplySettings()
        end,
        sound_drag = 'rotate',
    },
    WIDGET.new { -- mute
        type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "MUTE ON UNFOCUS",
        x = baseX + 55, y = baseY + 280,
        disp = function() return CONF.autoMute end,
        code = function() CONF.autoMute = not CONF.autoMute end,
    },
    -- Video
    WIDGET.new { -- title
        type = 'text', alignX = 'left',
        text = "VIDEO",
        color = clr.T,
        fontSize = 50,
        x = baseX + 30, y = videoY + 0,
    },
    WIDGET.new { -- card brightness
        type = 'slider',
        x = baseX + 240 + 85, y = videoY + 60, w = 400,
        axis = { 80, 100, 5 },
        frameColor = 'dD', fillColor = clr.D,
        disp = function() return CONF.cardBrightness end,
        code = function(value) CONF.cardBrightness = value end,
        sound_drag = 'rotate',
    },
    WIDGET.new { -- bg brightness
        type = 'slider',
        x = baseX + 240 + 85, y = videoY + 140, w = 400,
        axis = { 30, 80, 10 },
        frameColor = 'dD', fillColor = clr.D,
        disp = function() return CONF.bgBrightness end,
        code = function(value) CONF.bgBrightness = value end,
        sound_drag = 'rotate',
    },
    WIDGET.new { -- fancy
        type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "FANCY BACKGROUND  (F9)",
        x = baseX + 55, y = videoY + 230,
        disp = function() return CONF.bg end,
        code = WIDGET.c_pressKey 'f9',
    },
    WIDGET.new { -- star
        type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "STAR FORCE  (F10)",
        x = baseX + 55, y = videoY + 300,
        disp = function() return not CONF.syscursor end,
        code = WIDGET.c_pressKey 'f10',
    },
    WIDGET.new { -- fullscreen
        type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "FULLSCREEN  (F11)",
        x = baseX + 55, y = videoY + 370,
        disp = function() return CONF.fullscreen end,
        code = WIDGET.c_pressKey 'f11',
    },
    -- Keybind
    WIDGET.new {
        type = 'button',
        x = baseX + 730, y = baseY + 770, w = 260, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "REBIND  KEY",
        onClick = function()
            if bindBuffer then
                bindBuffer = {}
                SFX.play('b2bcharge_danger', .8)
            else
                -- MSG.clear()
                if TASK.lock('rebind_control', 12) then
                    SFX.play('notify')
                    MSG('dark', {
                            "Current Keybinding:\n" ..
                            table.concat(TABLE.sub(CONF.keybind, 1, 9), ', ') .. "\n" ..
                            table.concat(TABLE.sub(CONF.keybind, 10, 18), ', ') .. "\n" ..
                            "Commit: " .. CONF.keybind[19] .. "\n" ..
                            "Reset: " .. CONF.keybind[20] .. "\n" ..
                            "Click L/R: " .. CONF.keybind[21] .. ", " .. CONF.keybind[22] .. "\n",
                            COLOR.F, "PRESS AGAIN TO REBIND\n",
                            COLOR.LD, "(F1-F12 ` Tab Ctrl Alt are not allowed)"
                        },
                        12
                    )
                else
                    TASK.unlock('rebind_control')
                    bindBuffer = {}
                    SFX.play('b2bcharge_danger', .8)
                end
            end
        end,
    },
}

local profY = baseY + 220
pages[2] = {
    WIDGET.new { -- title
        type = 'text', alignX = 'left',
        text = "ACCOUNT",
        color = clr.T,
        fontSize = 50,
        x = baseX + 30, y = baseY + 50,
    },
    WIDGET.new {
        name = 'changeName', type = 'button',
        x = baseX + 230, y = baseY + 130, w = 380, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "CHANGE  USERNAME",
        onClick = function()
            -- MSG.clear()
            local newName = CLIPBOARD.get()
            if #newName == 0 then
                MSG('dark', "No data in clipboard")
                return
            end
            newName = newName:trim()
            if TASK.lock('changeName', 2.6) then
                SFX.play('notify')
                MSG('dark', "Change your name to clipboard text? ('" .. newName .. "')\nPress again to confirm", 2.6)
                return
            end
            TASK.unlock('changeName')
            newName = newName:upper()
            if #newName < 3 or #newName > 16 or newName:find('[^A-Z0-9_%-]') then
                MSG('dark', "New name must be 3-16 characters long and contain the following: A-Z, 0-9, -, _")
                SFX.play('staffwarning')
                return
            end
            if newName == STAT.uid then
                MSG('dark', "New name is the same as the old one.")
                SFX.play('staffwarning')
                return
            end
            if newName:match('^ANON[-_]') then
                MSG('dark', "You can’t enter ANON as your new name.")
                SFX.play('staffwarning')
                return
            end
            STAT.uid = newName
            SaveStat()
            SFX.play('supporter')
            MSG('dark', "Your name was changed to " .. STAT.uid)
            if SCN.cur == 'stat' then RefreshProfile() end
            refreshUID()
            IssueAchv('identity')
        end,
    },
    WIDGET.new {
        name = 'changeAboutme', type = 'button',
        x = baseX + 640, y = baseY + 130, w = 380, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "CHANGE  ABOUT ME",
        onClick = function()
            -- MSG.clear()
            local newText = CLIPBOARD.get()
            if #newText == 0 then
                MSG('dark', "No data in clipboard")
                return
            end
            newText = newText:trim()
            if TASK.lock('changeAboutme', 2.6) then
                SFX.play('notify')
                MSG('dark', "Change your about me text to clipboard text?\nPress again to confirm", 2.6)
                return
            end
            TASK.unlock('changeAboutme')
            repeat
                if type(newText) ~= 'string' then
                    MSG('dark', "No data in clipboard")
                    break
                end
                if #newText < 1 or #newText > 260 or newText:find('[^\32-\126]') then
                    MSG('dark', "Text must be 1-260 characters long and contain visible ASCII characters")
                    break
                end
                if newText == STAT.aboutme then
                    MSG('dark', "New text is the same as the old one")
                    break
                end
                STAT.aboutme = newText
                SaveStat()
                SFX.play('supporter')
                MSG('dark', "Your About Me text has been updated.")
                if SCN.cur == 'stat' then RefreshProfile() end
                IssueAchv('identity')
                return
            until true
            SFX.play('staffwarning')
        end,
    },
    WIDGET.new { -- title
        type = 'text', alignX = 'left',
        text = "PROFILE",
        color = clr.T,
        fontSize = 50,
        x = baseX + 30, y = profY + 0,
    },
    WIDGET.new {
        name = 'export', type = 'button',
        x = baseX + 230, y = profY + 80, w = 380, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "EXPORT  PROGRESS",
        onClick = function()
            -- MSG.clear()
            if TestMode then
                SFX.play('staffwarning')
                MSG('dark', "You are not a good person.")
                return
            end
            if TASK.lock('export', 2.6) then
                SFX.play('notify')
                MSG('dark', "Export your progress to clipboard?\nPress again to confirm", 2.6)
                return
            end
            TASK.unlock('export')
            CLIPBOARD.set(STRING.packTable(STAT) .. ',' .. STRING.packTable(BEST) .. ',' .. STRING.packTable(ACHV))
            MSG('dark', "Progress exported!")
            SFX.play('social_notify_minor')
        end,
    },
    WIDGET.new {
        name = 'import', type = 'button',
        x = baseX + 640, y = profY + 80, w = 380, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "IMPORT  PROGRESS",
        onClick = function()
            -- MSG.clear()
            local data = CLIPBOARD.get():filterASCII():trim()
            if #data <= 26 then
                if data == '' then
                    MSG('dark', "No data in clipboard")
                elseif data == 'cmd' then
                    SFX.play('cutin_superlobby', 1, 0, Tone(-2))
                    SCN.go('_console')
                elseif data == 'old_hitbox' then
                    CONF.oldHitbox = not CONF.oldHitbox
                    MSG('dark', "Force old hitbox: " .. (CONF.oldHitbox and "ON" or "OFF"))
                    SFX.play(CONF.oldHitbox and 'social_online' or 'social_offline')
                    TEXTS.version:set(SYSTEM .. (CONF.oldHitbox and " T" or " V") .. (require 'version'.verStr))
                elseif data == 'true_ending' then
                    SFX.play('warp')
                    SCN.go('ending', 'warp')
                elseif data == 'test' then
                    if STAT.srActive then
                        STAT.srActive = false
                        SaveStat()
                    end
                    TestMode = true
                    SFX.play('maintenance')
                elseif data == 'dev' then
                    MSG('dark', OverDevProgressText)
                elseif data == 'UseAltName' then
                    UseAltName()
                    SFX.play('social_dm')
                elseif data == 'resubmit' then
                    if DAILYCMD then
                        ASYNC.runCmd('submitDaily', DAILYCMD)
                        MSG('info', "Re-submitting Daily Challenge score...")
                        SFX.play('social_invite')
                    else
                        MSG('warn', "No buffered Daily Challenge score")
                        SFX.play('failure', 1, 0, Tone(0))
                    end
                else
                    local msg = "Invalid code '" .. data .. "' in clipboard."
                    if MATH.roll(.26) then
                        msg = msg .. "\n" .. TABLE.getRandom {
                            "Try 'cmd'",
                            "Try 'cooldown'",
                            "Try 'old_hitbox'",
                            "Try 'test'",
                            "Try 'dev'",
                            "Try 'repo'",
                            MATH.coin("Try 'mp'", "Try 'music'"),
                            "Try 'f" .. STAT.maxFloor .. "'",
                            STAT.clicker and "Try 'true_ending'" or nil,
                        }
                    end
                    MSG('dark', msg)
                    SFX.play('staffwarning')
                    return
                end
                LOG('info', "Secret: " .. data)
                return
            end
            if TASK.lock('import', 4.2) then
                SFX.play('notify')
                MSG('dark',
                    "Import data from clipboard text?\nThe version must match; all progress you made so far will be permanently lost!\nPress again to confirm",
                    4.2)
                return
            end
            TASK.unlock('import')
            local d3 = STRING.split(data, ',')
            local suc1, res1 = pcall(STRING.unpackTable, d3[1])
            local suc2, res2 = pcall(STRING.unpackTable, d3[2])
            local suc3, res3
            if d3[3] then
                suc3, res3 = pcall(STRING.unpackTable, d3[3])
            else
                suc3, res3 = true, {}
            end
            if not suc1 or not suc2 or not suc3 then
                MSG('dark', "Invalid data format")
                SFX.play('staffwarning')
                return
            elseif res1.version > STAT.version then
                MSG('error', "Cannot import data from future versions\nPlease update your game first!")
                SFX.play('staffwarning')
                return
            elseif res1.mod and res1.mod ~= 'vanilla' then
                MSG('dark', "Cannot import data from modded version")
                SFX.play('staffwarning')
                return
            end
            TABLE.update(STAT, res1)
            BEST, ACHV = res2, res3
            setmetatable(BEST.highScore, Metatable.best_highscore)
            GAME.refreshLockState()
            setmetatable(BEST.speedrun, Metatable.best_speedrun)
            if STAT.system ~= SYSTEM then
                STAT.system = SYSTEM
                IssueAchv('zenith_relocation')
            end
            Initialize(true)
            if TestMode then
                MSG('dark', "Progress imported, but won't be saved.")
            else
                MSG('dark', "Progress imported!")
            end
            SFX.play('social_notify_major')
        end,
    },
    WIDGET.new {
        name = 'resetall', type = 'button',
        x = baseX + 450, y = profY + 220, w = 260, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "RESET ALL",
        onClick = function()
            if not (uidList[1] or uidList[2] or uidList[3]) then
                SFX.play('staffwarning')
                MSG('dark', "You must have at least 1 backup before resetting all progress!")
                return
            end
            local instaReset = anonUser or TASK.getLock('just_saved')
            if TASK.lock('reset_all', 2.6) then
                resetall_cnt = 0
                lastClear = false
                SFX.play('hyperalert')
                if instaReset then
                    MSG('warn', "Reset all progress? Press again to confirm.", 2.6)
                else
                    MSG('info', "Reset all progress? Spam to confirm.", 2.6)
                end
                return
            end
            if not instaReset and not TASK.forceLock('reset_all', 1) and resetall_cnt < 16 then
                resetall_cnt = resetall_cnt + 1
                local spin = MATH.roll(.26)
                local clear = spin and 's' .. math.random(2) or 'c' .. math.random(2, 4)
                SFX.play(spin and 'clearspin' or clear == 'c4' and 'clearquad' or 'clearline')
                SFX.play('combo_' .. resetall_cnt .. ((clear == 's2' or clear == 'c4') and '_power' or ''))
                if GAME.mod.AS == 1 then
                    if clear == lastClear then
                        for _ = 1, 2 do SFX.play('wound') end
                        resetall_cnt = math.max(resetall_cnt - 2, 0)
                    elseif MATH.roll(.26) then
                        SFX.play('wound_repel')
                    end
                elseif GAME.mod.AS == 2 then
                    if clear == lastClear then
                        for _ = 1, 3 do SFX.play('wound') end
                        TASK.unlock('reset_all')
                        SaveConf()
                        SCN.back('none')
                    end
                end
                lastClear = clear
                return
            end
            FILE.delete('stat.luaon')
            FILE.delete('achv.luaon')
            FILE.delete('best.luaon')
            TASK.unlock('reset_all')
            if not instaReset then SFX.play('combo_16_power') end
            SFX.play('clearquad')
            SFX.play('inject')
            SFX.play('thunder' .. math.random(6))
            MSG.clear()
            SCN._pop()
            SCN.swapTo('joining', 'fade', 'reset')
        end,
    },
}
local function saveSlot(i)
    if TestMode then
        SFX.play('staffwarning')
        MSG('dark', "You are not a good person.")
        return
    end
    if uidList[i] and STAT.uid ~= uidList[i].uid and not uidList[i].uid:match("^ANON%-") then
        SFX.play('staffwarning')
        MSG('dark', "For safety, you can only update a backup with same username", 4.2)
        return
    end
    TASK.unlock('save_slot' .. i)
    TASK.lock('just_saved', 10)
    SaveStat()
    FILE.createDirectory('save' .. i)
    FILE.copy('stat.luaon', 'save' .. i .. '/stat.luaon')
    FILE.copy('achv.luaon', 'save' .. i .. '/achv.luaon')
    FILE.copy('best.luaon', 'save' .. i .. '/best.luaon')
    uidList[i] = { uid = STAT.uid, modTime = "just now" }
    SFX.play('allclear')
    MSG('check', "Progress backed up to slot " .. i .. "!", 2.6)
    WIDGET._reset()
end
local function loadSlot(i)
    if not anonUser then
        local hasBackup
        for _, user in next, uidList do
            if user and STAT.uid == user.uid then
                hasBackup = true
                break
            end
        end
        if not hasBackup then
            SFX.play('staffwarning')
            MSG('dark', "For safety, you can only load a backup when current save is backed up", 4.2)
            return
        end
    end

    if TASK.lock('load_slot' .. i, 2.6) then
        SFX.play('hyperalert')
        MSG('warn', "Load from slot " .. i .. "? Current save will be overwritten. Press again to confirm.", 4.2)
        return
    end
    TASK.unlock('load_slot' .. i)
    FILE.copy('save' .. i .. '/stat.luaon', 'stat.luaon')
    FILE.copy('save' .. i .. '/achv.luaon', 'achv.luaon')
    FILE.copy('save' .. i .. '/best.luaon', 'best.luaon')
    SFX.play('levelup'); SFX.play('levelup')
    SCN._pop()
    SCN.swapTo('joining', 'fade', 'load')
end
local function clearSlot(i)
    if uidList[i] and STAT.uid ~= uidList[i].uid and not uidList[i].uid:match("^ANON%-") then
        SFX.play('staffwarning')
        MSG('dark', "For safety, you can only delete a backup with same username", 4.2)
        return
    end
    if TASK.lock('clear_slot' .. i, 2.6) then
        SFX.play('hyperalert')
        MSG('warn', "Clear slot " .. i .. "? This action cannot be undone. Press again to confirm.", 4.2)
        return
    end
    TASK.unlock('clear_slot' .. i)
    TASK.unlock('just_saved')
    FILE.delete('save' .. i)
    uidList[i] = false
    SFX.play('clearquad')
    SFX.play('inject')
    SFX.play('thunder' .. math.random(6))
    MSG.clear()
    WIDGET._reset()
end
local slBtnTextColor = { 0, 0, 0, .62 }
for i = 1, 3 do
    local y = profY + 330 + (i - 1) * 90
    TABLE.append(pages[2], {
        WIDGET.new {
            name = 'save' .. i, type = 'button',
            x = baseX + 355, y = y, w = 160, h = 50,
            fontSize = 30, color = 'lG', textColor = slBtnTextColor, text = "BACKUP",
            onClick = function() saveSlot(i) end,
        },
        WIDGET.new {
            name = 'load' .. i, type = 'button',
            x = baseX + 555, y = y, w = 160, h = 50,
            fontSize = 30, color = 'lY', textColor = slBtnTextColor, text = "LOAD",
            onClick = function() loadSlot(i) end,
            visibleFunc = function() return page == 2 and uidList[i] end,
        },
        WIDGET.new {
            name = 'clear' .. i, type = 'button',
            x = baseX + 755, y = y, w = 160, h = 50,
            fontSize = 30, color = 'lR', textColor = slBtnTextColor, text = "CLEAR",
            onClick = function() clearSlot(i) end,
            visibleFunc = function() return page == 2 and uidList[i] end,
        },
    })
end

local albumY = baseY + 250
pages[3] = {
    WIDGET.new { -- title
        type = 'text', alignX = 'left',
        text = "ALBUM",
        color = clr.T,
        fontSize = 50,
        x = baseX + 30, y = baseY + 50,
    },
    WIDGET.new { -- -30s
        type = 'button',
        x = baseX + 130, y = albumY, w = 150, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "-30s",
        onClick = function()
            TASK.removeTask_code(Task_MusicEnd)
            BGM.set('all', 'seek', math.max(BGM.tell() - 30, 0))
        end,
    },
    WIDGET.new { -- -5s
        type = 'button',
        x = baseX + 330, y = albumY, w = 150, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "-5s",
        onClick = function()
            TASK.removeTask_code(Task_MusicEnd)
            BGM.set('all', 'seek', math.max(BGM.tell() - 5, 0))
        end,
    },
    WIDGET.new { -- +5s
        type = 'button',
        x = baseX + 540, y = albumY, w = 150, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "+5s",
        onClick = function()
            TASK.removeTask_code(Task_MusicEnd)
            BGM.set('all', 'seek', math.min(BGM.tell() + 5, BGM.getDuration()))
        end,
    },
    WIDGET.new { -- +30s
        type = 'button',
        x = baseX + 740, y = albumY, w = 150, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "+30s",
        onClick = function()
            TASK.removeTask_code(Task_MusicEnd)
            BGM.set('all', 'seek', math.min(BGM.tell() + 30, BGM.getDuration()))
        end,
    },
    WIDGET.new { -- no loop
        type = 'button',
        x = baseX + 450, y = albumY + 80, w = 200, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "NO LOOPS",
        onClick = function()
            BgmLooping, BgmNeedSkip = false, false
        end,
    },
}
local function albumBtn(param)
    table.insert(pages[3], WIDGET.new(TABLE.update({
        type = 'button',
        w = 65,
        fontSize = 30,
        textColor = 'D',
    }, param)))
end
for i = 0, 10 do
    albumBtn {
        x = baseX + 75 + 75 * i, y = baseY + 450,
        color = bgmColors['f' .. i],
        text = "" .. i,
        onClick = function()
            GAME.height = bgmHeight[i]
            PlayBGM('f' .. i)
        end,
        visibleFunc = function()
            return page == 3 and STAT.maxFloor >= i
        end,
    }
    albumBtn {
        x = baseX + 75 + 75 * i, y = baseY + 530,
        color = bgmColors['f' .. i .. 'r'],
        text = "R" .. i,
        onClick = function()
            GAME.height = (bgmHeight[i] + bgmHeight[i + 1]) / 2
            PlayBGM('f' .. i .. 'r')
        end,
        visibleFunc = function() return page == 3 and STAT.maxFloor >= 10 and TABLE.countAll(GAME.completion, 2) > 0 end,
    }
end
albumBtn {
    x = baseX + 450 - 200, y = baseY + 690, w = 120,
    color = bgmColors.tera,
    text = "TERA",
    onClick = function()
        PlayBGM('tera')
    end,
    visibleFunc = function() return page == 3 and ACHV.blazing_speed end,
}
albumBtn {
    x = baseX + 450, y = baseY + 690, w = 120,
    color = bgmColors.fomg,
    fontSize = 50,
    text = "FΩ",
    onClick = function()
        GAME.height = 6200
        PlayBGM('fomg')
    end,
    visibleFunc = function() return page == 3 and STAT.maxHeight >= 6200 end,
}
albumBtn {
    x = baseX + 450 + 200, y = baseY + 690, w = 120,
    color = bgmColors.terar,
    text = "TERAR",
    onClick = function()
        PlayBGM('terar')
    end,
    visibleFunc = function() return page == 3 and ACHV.blazing_speed and BEST.highScore.rEX >= Floors[9].top end,
}

local function newTabBtn(text, y, key)
    return WIDGET.new {
        type = 'button',
        pos = { 1, 0 }, x = -60, y = y, w = 160, h = 60,
        color = { COLOR.HEX '383838' },
        fontSize = 30, text = text, textColor = 'DL',
        onClick = function() love.keypressed(key) end,
    }
end

-- Tabs
local tab = {
    newTabBtn("CONF   ", 140 + 90 * 0, '1'),
    newTabBtn("USER   ", 140 + 90 * 1, '2'),
    newTabBtn("ALB   ", 140 + 90 * 2, '3'),
    WIDGET.new {
        type = 'button',
        pos = { 0, 0 }, x = 60, y = 140, w = 160, h = 60,
        color = { .15, .15, .15 },
        fontSize = 30, text = "    BACK", textColor = 'DL',
        onClick = function() love.keypressed('escape') end,
    },
}

-- Apply dafault visibility functions
local pageVisFunc = {}
for p = 1, maxPage do pageVisFunc[p] = function() return page == p end end
for i = 1, #pages do
    for _, W in next, pages[i] do
        W.visibleFunc = W.visibleFunc or pageVisFunc[i]
        if W.type == 'button' or W.type == 'checkBox' then
            W.sound_hover = 'menutap'
            if i ~= 3 then W.sound_release = 'menuclick' end
        end
    end
end

scene.widgetList = {}
for i = 1, #pages do TABLE.append(scene.widgetList, pages[i]) end
TABLE.append(scene.widgetList, tab)

return scene
