---@type Zenitha.Scene
local scene = {}

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
MusicPlayer = false
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
    f1ex = "Dr Ocelot - Infernal Registration",

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

    terae = "Trevor Smithy - Schnellfeuer BULLET Vocal Cover",
    teral = "Trevor Smithy - Schnellfeuer BULLET Lyric Cover",
    terael = "Trevor Smithy - Schnellfeuer BULLET Vocal & Lyric Cover",
    fomg = "Ronezkj15 - Strained Endurance",
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
    fomg = { COLOR.HEX '00437A' },
}

local function refreshWidgets()
    scene.widgetList.account:setVisible(not MusicPlayer)
    scene.widgetList.album:setVisible(MusicPlayer)
    scene.widgetList.mp_prev5s:setVisible(MusicPlayer)
    scene.widgetList.mp_next5s:setVisible(MusicPlayer)
    scene.widgetList.mp_noLoop:setVisible(MusicPlayer)
    scene.widgetList.changeAboutme:setVisible(not MusicPlayer)
    scene.widgetList.changeName:setVisible(not MusicPlayer)
    scene.widgetList.export:setVisible(not MusicPlayer)
    scene.widgetList.audio:setVisible(not MusicPlayer)
    scene.widgetList.mute:setVisible(not MusicPlayer)
end

local function refreshSongInfo()
    if not MusicPlayer then return end
    playingBgmTitle = BgmPlaying == 'f0' and RevMusicMode() and songList.f0r or songList[BgmPlaying] or "Rewrite"
    playingBgmLength = BGM.getDuration()
    playingBgmLengthStr = STRING.time_simp(playingBgmLength)
    GAME.refreshRPC()
end

function scene.load()
    MSG.clear()
    bindBuffer = nil
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
    refreshWidgets()
    refreshSongInfo()
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
    if KBisDown('lctrl', 'rctrl') and (key:match('^f%d%d?$') and tonumber(key:match('%d+')) <= 10 or key == 'o' or key == 'pause' or key == 'break' or key == 't') then
        if key == 'o' then key = 'fomg' end
        if key == 'pause' or key == 'break' or key == 't' then key = 'tera' end
        TASK.removeTask_code(Task_MusicEnd)
        if KBisDown('lshift', 'rshift') then key = key .. 'r' 
        elseif KBisDown('lalt', 'ralt') and key == 'tera' then key = key .. 'e' end
        if (key == 'terae' or key == 'tera') and (GAME.mod.EX == -1 and URM and GAME.mod.NH < 2 and GAME.mod.MS < 2 and GAME.mod.GV < 2 and GAME.mod.VL < 2 and GAME.mod.DH < 2 and GAME.mod.IN < 2 and GAME.mod.AS < 2 and GAME.mod.DP < 2) then
            key = key .. 'l'
        end
        PlayBGM(key, true)
        if not MusicPlayer then
            MusicPlayer = true
            refreshWidgets()
        end
        refreshSongInfo()
    elseif key == 'escape' or (key == 'f1' and not bindBuffer) then
        if bindBuffer then
            bindBuffer = nil
            MSG('dark', "Keybinding cancelled")
            SFX.play('staffwarning')
        else
            SFX.play('menuclick')
            SCN.back('none')
        end
    elseif bindBuffer and isLegalKey(key) then
        if TABLE.find(bindBuffer, key) then
            MSG('dark', "Keybinding should not repeat!", 1)
            SFX.play('finessefault')
        else
            table.insert(bindBuffer, key)
            if #bindBuffer >= 22 then
                STAT.keybind = bindBuffer
                bindBuffer = nil
                SaveStat()
                MSG('dark', "Keybinding updated.")
                SFX.play('social_notify_major')
            else
                SFX.play('irs')
            end
        end
    elseif MusicPlayer then
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
    ZENITHA._cursor.active=true
    return true
end

scene.resize = refreshWidgets

-- Panel size
local w, h = 900, 830
local baseX, baseY = (1600 - w) / 2, (1000 - h) / 2

local gc = love.graphics
local gc_replaceTransform = gc.replaceTransform
local gc_setColor, gc_rectangle, gc_print, gc_printf = gc.setColor, gc.rectangle, gc.print, gc.printf
local gc_ucs_move, gc_ucs_back = GC.ucs_move, GC.ucs_back
local gc_setAlpha, gc_mRect, gc_mStr = GC.setAlpha, GC.mRect, GC.mStr

local function drawSliderComponents(y, title, t1, t2, value)
    gc_ucs_move(0, y)
    gc_setColor(0, 0, 0, .26)
    gc_mRect('fill', w / 2, 0, w - 40, 65, 5)
    gc_mRect('fill', w - 90, 0, 123, 48, 3)
    FONT.set(30)
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

function scene.draw()
    DrawBG(STAT.bgBrightness)

    local t = love.timer.getTime()
    local playTime = 0
    local beatLen = 0
    local beatBar = 0
    if MusicPlayer then
        playTime = BGM.tell()
        beatLen = 60 / BgmData[BgmPlaying].bpm
        beatBar = BgmData[BgmPlaying].bar
    end

    -- Panel
    gc_replaceTransform(SCR.xOy)
    gc.translate(800 - w / 2, 510 - h / 2)
    if MusicPlayer then
        local dy = MATH.clamp(6 * math.sin(playTime / beatLen * 3.1416), -2.6, 2.6)
        gc.translate(0, dy)
        SCN.curScroll = -dy
    end
    gc_setColor(clr.D)
    gc_rectangle('fill', 0, 0, w, h)
    gc_setColor(0, 0, 0, .26)
    gc_rectangle('fill', 3, 3, w - 6, h - 6)
    gc_setColor(1, 1, 1, .1)
    gc_rectangle('fill', 0, 0, w, 3)
    gc_setColor(1, 1, 1, .04)
    gc_rectangle('fill', 0, 3, 3, h + 3)

    -- Sliders
    drawSliderComponents(310, "EFFECT VOLUME", "QUIET (F3)", "LOUD (F3)", STAT.sfx)
    drawSliderComponents(380, "MUSIC VOLUME", "QUIET (F4)", "LOUD (F4)", STAT.bgm)
    drawSliderComponents(520, "CARD  BRIGHTNESS", "DARK (F5)", "BRIGHT (F6)", STAT.cardBrightness)
    drawSliderComponents(590, "BG  BRIGHTNESS", "DARK (F7)", "BRIGHT (F8)", STAT.bgBrightness)

    -- Keybind
    if bindBuffer then
        FONT.set(30)
        gc_print("Press key for...", 610, 680, 0, .872)
        gc_print(bindHint[#bindBuffer + 1], 610, 710, 0, .872)
    end

    -- Music player info
    if MusicPlayer then
        local len = 620
        gc_ucs_move(140, 202)

        FONT.set(30)
        gc_setColor(clr.T)
        gc_print(STRING.time_simp(playTime), 0, 49, 0, .626)
        gc_print(playingBgmLengthStr, len - 45, 49, 0, .626)

        local data = BgmData[BgmPlaying]
        if BgmLooping then
            if data.loop[1] == 0 then
                gc_print('D.C.', len * data.loop[2] / playingBgmLength, 35, 0, .3)
            else
                gc_print('S', len * data.loop[1] / playingBgmLength, 35, 0, .3)
                gc_print('D.S.', len * data.loop[2] / playingBgmLength, 35, 0, .3)
            end
        end

        gc_setColor(clr.L)
        gc_rectangle('fill', 0, 46, len, 4)
        if BgmPlaying == 'tera' or BgmPlaying == 'terar' or BgmPlaying == 'terae' or BgmPlaying == 'teral' or BgmPlaying == 'terael' then
            gc_setColor(COLOR.rainbow_light(2.6 * t))
            local height = 245
            local lenMod = 0
            local lyric = ''
            local hlyric = ''
            if BgmPlaying == 'teral' or BgmPlaying == 'terael' then
                local time = playTime
                local climb = playTime - 36.1 -- climb
                local climbEnd = playTime - 36.8 -- climb end
                local climb2 = playTime - 100.1
                local climbEnd2 = playTime - 100.8
                if BgmPlaying == 'teral' then
                    time = time + 0.1
                    climb = climb + 0.1
                    climbEnd = climbEnd + 0.1
                    climb2 = climb2 + 0.1
                    climbEnd2 = climbEnd2 + 0.1
                end
                if time >= 20 and time < 22.8 then
                    lyric = 'Welcome into the Zenith Tower'
                elseif time >= 22.8 and time < 25.5 then
                    lyric = 'where anyone can try their luck'
                elseif time >= 25.5 and time < 28.1 then
                    lyric = 'at the climb to the top of the floors.'
                elseif time >= 28.1 and time < 30.8 then
                    lyric = "But, you'll come to a realization"
                elseif time >= 30.8 and time < 34.1 then
                    lyric = 'that only one can truly be with the'
                elseif time >= 34.1 and time < 36.1 then
                    lyric = "stars at the top. So now you're"
                elseif (climb >= 0 and climbEnd < 0) or (climb2 >= 0 and climbEnd2 < 0) then -- 1
                    lyric = "CLIMB'IN"
                    height = height - 0 - (time < 100 and climb or climb2) * 10
                elseif (climbEnd >= 0 and climb < 1) or (climbEnd2 >= 0 and climb2 < 1) then
                    lyric = "and"
                    height = height - 10
                elseif (climb >= 1 and climbEnd < 1) or (climb2 >= 1 and climbEnd2 < 1) then
                    lyric = "CLIMB'IN"
                    height = height - 10 - ((time < 100 and climb or climb2)-1) * 10
                elseif (climbEnd >= 1 and climb < 2) or (climbEnd2 >= 1 and climb2 < 2) then
                    lyric = "and"
                    height = height - 20
                elseif (climb >= 2 and climbEnd < 2) or (climb2 >= 2 and climbEnd2 < 2) then
                    lyric = "CLIMB'IN"
                    height = height - 20 - ((time < 100 and climb or climb2)-2) * 10
                elseif (climbEnd >= 2 and climb < 3) or (climbEnd2 >= 2 and climb2 < 3) then
                    lyric = "and"
                    height = height - 30
                elseif (climb >= 3 and climbEnd < 3) or (climb2 >= 3 and climbEnd2 < 3) then
                    lyric = "CLIMB'IN"
                    height = height - 30 - ((time < 100 and climb or climb2)-3) * 10
                elseif (climbEnd >= 3 and climb < 4) or (climbEnd2 >= 3 and climb2 < 4) then
                    lyric = "keep on"
                    height = height - 40 + ((time < 100 and climbEnd or climbEnd2)-3) * 133
                elseif (climb >= 4 and climbEnd < 4) or (climb2 >= 4 and climbEnd2 < 4) then -- 2
                    lyric = "CLIMB'IN"
                    height = height - 0 - ((time < 100 and climb or climb2)-4) * 10
                elseif (climbEnd >= 4 and climb < 5) or (climbEnd2 >= 4 and climb2 < 5) then
                    lyric = "and"
                    height = height - 10
                elseif (climb >= 5 and climbEnd < 5) or (climb2 >= 5 and climbEnd2 < 5) then
                    lyric = "CLIMB'IN"
                    height = height - 10 - ((time < 100 and climb or climb2)-5) * 10
                elseif (climbEnd >= 5 and climb < 6) or (climbEnd2 >= 5 and climb2 < 6) then
                    lyric = "and"
                    height = height - 20
                elseif (climb >= 6 and climbEnd < 6) or (climb2 >= 6 and climbEnd2 < 6) then
                    lyric = "CLIMB'IN"
                    height = height - 20 - ((time < 100 and climb or climb2)-6) * 10
                elseif (climbEnd >= 6 and climb < 7) or (climbEnd2 >= 6 and climb2 < 7) then
                    lyric = "and"
                    height = height - 30
                elseif (climb >= 7 and climb < 8) or (climb2 >= 7 and climb2 < 8) then
                    lyric = "just keep on"
                    height = height - 30 + ((time < 100 and climb or climb2)-7) * 30   
                elseif (climb >= 8 and climbEnd < 8) or (climb2 >= 8 and climbEnd2 < 8) then -- 1
                    lyric = "CLIMB'IN"
                    height = height - 0 - ((time < 100 and climb or climb2)-8) * 10
                elseif (climbEnd >= 8 and climb < 9) or (climbEnd2 >= 8 and climb2 < 9) then
                    lyric = "and"
                    height = height - 10
                elseif (climb >= 9 and climbEnd < 9) or (climb2 >= 9 and climbEnd2 < 9) then
                    lyric = "CLIMB'IN"
                    height = height - 10 - ((time < 100 and climb or climb2)-9) * 10
                elseif (climbEnd >= 9 and climb < 10) or (climbEnd2 >= 9 and climb2 < 10) then
                    lyric = "and"
                    height = height - 20
                elseif (climb >= 10 and climbEnd < 10) or (climb2 >= 10 and climbEnd2 < 10) then
                    lyric = "CLIMB'IN"
                    height = height - 20 - ((time < 100 and climb or climb2)-10) * 10
                elseif (climbEnd >= 10 and climb < 11) or (climbEnd2 >= 10 and climb2 < 11) then
                    lyric = "and"
                    height = height - 30
                elseif (climb >= 11 and climbEnd < 11) or (climb2 >= 11 and climbEnd2 < 11) then
                    lyric = "CLIMB'IN"
                    height = height - 30 - ((time < 100 and climb or climb2)-11) * 10
                elseif (climbEnd >= 11 and climb < 12) or (climbEnd2 >= 11 and climb2 < 12) then
                    lyric = "keep on"
                    height = height - 40 + ((time < 100 and climbEnd or climbEnd2)-11) * 133
                elseif (climb >= 12 and climbEnd < 12) or (climb2 >= 12 and climbEnd2 < 12) then -- 2
                    lyric = "CLIMB'IN"
                    height = height - 0 - ((time < 100 and climb or climb2)-12) * 10
                elseif (climbEnd >= 12 and climb < 13) or (climbEnd2 >= 12 and climb2 < 13) then
                    lyric = "and"
                    height = height - 10
                elseif (climb >= 13 and climbEnd < 13) or (climb2 >= 13 and climbEnd2 < 13) then
                    lyric = "CLIMB'IN"
                    height = height - 10 - ((time < 100 and climb or climb2)-13) * 10
                elseif (climbEnd >= 13 and climb < 14) or (climbEnd2 >= 13 and climb2 < 14) then
                    lyric = "and"
                    height = height - 20
                elseif (climb >= 14 and climbEnd < 14) or (climb2 >= 14 and climbEnd2 < 14) then
                    lyric = "CLIMB'IN"
                    height = height - 20 - ((time < 100 and climb or climb2)-14) * 10
                elseif (climbEnd >= 14 and climb < 15) or (climbEnd2 >= 14 and climb2 < 15) then
                    lyric = "and"
                    height = height - 30
                elseif (climb >= 15 and climb < 16) or (climb2 >= 15 and climb2 < 16) then
                    lyric = "don't slow down"
                    height = height - 30 + ((time < 100 and climb or climb2)-15) * 30
                elseif (time >= 52 and time < 84) or (time >= 116 and time < 148) then -- climb harmony
                    local climbTime = time < 100 and (playTime-52)%4 or (playTime-116)%4
                    if (climbTime < 1.7 and time < 142) or (time >= 146 and time < 147.5) then -- climb harmony stuff
                        hlyric = "(cliiiiiiiiimb)"
                    elseif ((climbTime > 2 and climbTime < 2.7) or (climbTime > 3 and climbTime < 3.7)) and time < 140 then
                        hlyric = "(climb)"
                    end
                    if (time >= 52 and time < 54.8) or (time >= 52+64 and time < 54.8+64) then
                        lyric = "Now, a piece of advice:"
                    elseif (time >= 54.9 and time < 55.8) or (time >= 54.9+64 and time < 55.8+64) then
                        lyric = "whateva you do,"
                    elseif (time >= 55.8 and time < 58.5) or (time >= 55.8+64 and time < 58.5+64) then
                        lyric = "don't stop to take a look at the sights"
                        if time > 100 then lyric = "don't lose your view of the goal" end
                    elseif (time > 59.0 and time < 59.7) or (time > 59.0+64 and time < 59.7+64) then
                        lyric = "(yea)"
                    elseif (time >= 60 and time < 62.8) or (time >= 60+64 and time < 62.8+64) then
                        lyric = "Time to time, people will fail"
                    elseif (time >= 63 and time < 63.7) or (time >= 63+64 and time < 63.7+64) then
                        lyric = "cause,"
                    elseif (time >= 64 and time < 66.7) or (time >= 64+64 and time < 66.7+64) then
                        lyric = "they did not keep their speed"
                    elseif (time > 67.0 and time < 67.7) or (time > 67.0+64 and time < 67.7+64) then
                        lyric = "(high)"
                    end
                    local believe = time < 100 and (time-68.1) or (time-68.1-64)
                    if believe >= 0 and believe < 2 then
                        lyric = "But I believe"
                    elseif believe >= 2 and believe < 2.9 then
                        lyric = "But I believe in"
                    elseif believe >= 2.9 and believe < 3.7 then
                        lyric = "But I believe in you"
                    elseif believe >= 0+4 and believe < 2+4 then
                        lyric = "You've got what it"
                    elseif believe >= 2+4 and believe < 2.9+4 then
                        lyric = "You've got what it takes"
                    elseif believe >= 2.9+4 and believe < 3.7+4 then
                        lyric = "You've got what it takes to"
                    elseif believe >= 0+8 and believe < 2+8 and time < 100 then
                        lyric = "Go all the way"
                    elseif believe >= 2+8 and believe < 2.9+8 and time < 100 then
                        lyric = "Go all the way and"
                    elseif believe >= 2.9+8 and believe < 3.7+8 and time < 100 then
                        lyric = "Go all the way and to"
                    elseif believe >= 0+12 and believe < 2+12 and time < 100 then
                        lyric = "Get to the top"
                    elseif believe >= 2+12 and believe < 2.9+12 and time < 100 then
                        lyric = "Get to the top your"
                    elseif believe >= 2.9+12 and believe < 3.7+12 and time < 100 then
                        lyric = "Get to the top your way."
                    elseif (believe >= 8 and believe < 9.7) or (believe >= 10 and believe < 11.7) or (believe >= 12 and believe < 13.7) or (believe >= 14 and believe < 15.7) then
                        lyric = "Go-"
                    end
                elseif time >= 20+64 and time < 22.8+64 then
                    lyric = 'As you pass through the different scenes here'
                    --lenMod = 100
                elseif time >= 22.8+64 and time < 25.5+64 then
                    lyric = "you'll see many foes who now try their luck"
                    --lenMod = 100
                elseif time >= 25.5+64 and time < 28.1+64 then
                    lyric = 'at the climb to the top of the floors.'
                elseif time >= 28.1+64 and time < 30.8+64 then
                    lyric = "But, you've come to the realization"
                elseif time >= 30.8+64 and time < 34.1+64 then
                    lyric = 'that only one can truly be with the'
                elseif time >= 34.1+64 and time < 36.1+64 then
                    lyric = "stars at the top. So you keep"
                end
            end
            gc_mStr(lyric, (len - 200 + 4 * MATH.max(STAT.sfx,50)) / 2, height)
            gc_mStr(hlyric, (len - 200 + 4 * MATH.max(STAT.sfx,50)) / 2, height - 40)
        else
            gc_setColor(bgmColors[BgmPlaying] or clr.LT)
        end
        gc_rectangle('fill', 0, 46, len * playTime / playingBgmLength, 4)

        gc_mStr(playingBgmTitle, len / 2, 0)
        gc_setColor(1, 1, 1, .35 - .26 * math.sin(playTime / (beatBar * beatLen) * 3.1416))
        gc_mStr(playingBgmTitle, len / 2, 0)
        gc_setColor(clr.LT)
        gc_setAlpha(.26)
        gc_printf(data.meta, len / 2, 56, 2 * len, 'center', 0, .42, .42, len)

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
    FONT.set(50)
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
    FONT.set(30)
    gc_print("TWEAK YOUR SETTINGS FOR A BETTER CLICKING EXPERIENCE", 15, -45, 0, .85, 1)
end

scene.widgetList = {
    -- ALBUM
    WIDGET.new {
        name = 'album',
        type = 'text', alignX = 'left',
        text = "ALBUM",
        color = clr.T,
        fontSize = 50,
        x = baseX + 30, y = baseY + 50,
    },
    WIDGET.new {
        name = 'mp_prev5s', type = 'button',
        x = baseX + 230, y = baseY + 115, w = 380, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "BACK  5S",
        sound_hover = 'menutap',
        onClick = function()
            TASK.removeTask_code(Task_MusicEnd)
            BGM.set('all', 'seek', math.max(BGM.tell() - 5, 0))
        end,
        visibleFunc = FALSE,
    },
    WIDGET.new {
        name = 'mp_next5s', type = 'button',
        x = baseX + 640, y = baseY + 115, w = 380, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "FORWARD  5S",
        sound_hover = 'menutap',
        onClick = function()
            TASK.removeTask_code(Task_MusicEnd)
            BGM.set('all', 'seek', math.min(BGM.tell() + 5, BGM.getDuration()))
        end,
        visibleFunc = FALSE,
    },
    WIDGET.new {
        name = 'mp_noLoop', type = 'button',
        x = baseX + 230, y = baseY + 185, w = 380, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "NO REPEAT MARKS",
        sound_hover = 'menutap',
        onClick = function()
            BgmLooping, BgmNeedSkip = false, false
        end,
        visibleFunc = FALSE,
    },

    -- ACCOUNT
    WIDGET.new {
        name = 'account',
        type = 'text', alignX = 'left',
        text = "ACCOUNT",
        color = clr.T,
        fontSize = 50,
        x = baseX + 30, y = baseY + 50,
    },
    WIDGET.new {
        name = 'changeName', type = 'button',
        x = baseX + 230, y = baseY + 115, w = 380, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "CHANGE  USERNAME",
        sound_hover = 'menutap',
        sound_release = 'menuclick',
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
            repeat
                newName = newName:upper()
                if #newName < 3 or #newName > 16 or newName:find('[^A-Z0-9_%-]') then
                    MSG('dark', "New name must be 3-16 characters long and contain the following: A-Z, 0-9, -, _")
                    break
                end
                if newName == STAT.uid then
                    MSG('dark', "New name is the same as the old one.")
                    break
                end
                if newName:match('^ANON[-_]') then
                    MSG('dark', "You can’t enter ANON as your new name.")
                    break
                end
                STAT.uid = newName
                SaveStat()
                SFX.play('supporter')
                MSG('dark', "Your name was changed to " .. STAT.uid)
                if SCN.cur == 'stat' then RefreshProfile() end
                IssueAchv('identity')
                return
            until true
            SFX.play('staffwarning')
        end,
        visibleFunc = TRUE,
    },
    WIDGET.new {
        name = 'changeAboutme', type = 'button',
        x = baseX + 640, y = baseY + 115, w = 380, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "CHANGE  ABOUT ME",
        sound_hover = 'menutap',
        sound_release = 'menuclick',
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
        visibleFunc = TRUE,
    },
    WIDGET.new {
        name = 'export', type = 'button',
        x = baseX + 230, y = baseY + 185, w = 380, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "EXPORT  PROGRESS",
        sound_hover = 'menutap',
        sound_release = 'menuclick',
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
        visibleFunc = TRUE,
    },
    WIDGET.new {
        name = 'import', type = 'button',
        x = baseX + 640, y = baseY + 185, w = 380, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "IMPORT  PROGRESS",
        sound_hover = 'menutap',
        sound_release = 'menuclick',
        onClick = function()
            -- MSG.clear()
            local data = CLIPBOARD.get():filterASCII():trim()
            local anyPieceActive = GAME.nightcore or GAME.enightcore or GAME.slowmo or GAME.eslowmo or GAME.glassCard or GAME.eglassCard or GAME.fastLeak or GAME.efastLeak or GAME.invisUI or GAME.einvisUI or GAME.invisCard or GAME.einvisCard or GAME.closeCard or GAME.ecloseCard
            if #data <= 26 then
                if data == '' then
                    MSG('dark', "No data in clipboard")
                elseif data == 'cmd' then
                    SFX.play('cutin_superlobby', 1, 0, Tone(-2))
                    SCN.go('_console')
                elseif data == 'old_hitbox' then
                    STAT.oldHitbox = not STAT.oldHitbox
                    MSG('dark', "Force old hitbox: " .. (STAT.oldHitbox and "ON" or "OFF"))
                    SFX.play(STAT.oldHitbox and 'social_online' or 'social_offline')
                    TEXTS.version:set(SYSTEM .. (STAT.oldHitbox and " T" or " V") .. (require 'version'.verStr))
                elseif data == 'true_ending' then
                    SFX.play('warp')
                    SCN.go('ending', 'warp')
                elseif data == 'test' then
                    TestMode = true
                    SFX.play('maintenance')
                elseif data == 'dev' then
                    MSG('dark', OverDevProgressText)
                elseif data == 'repo' then
                    SFX.play('menuconfirm')
                    love.system.openURL("https://github.com/MrZ626/ZenithClicker")
                elseif data == 'mp' or data == 'music' then
                    if (GAME.mod.EX == -1 and GAME.mod.VL == -1 and GAME.mod.AS == -1 and (GAME.mod.NH == 0 and GAME.mod.MS == 0 and GAME.mod.GV == 0 and GAME.mod.DH == 0 and GAME.mod.IN == 0 and GAME.mod.DP == 0)) and ACHV.programmer_gamer then
                        PlayBGM(URM and 'terael' or 'terae', false)
                    elseif (GAME.mod.EX == -1 and URM and GAME.mod.NH < 2 and GAME.mod.MS < 2 and GAME.mod.GV < 2 and GAME.mod.VL < 2 and GAME.mod.DH < 2 and GAME.mod.IN < 2 and GAME.mod.AS < 2 and GAME.mod.DP < 2) then
                        PlayBGM('teral', false)
                    else
                        if not BGM.isPlaying() or MusicPlayer then return end
                    end
                    MusicPlayer = true
                    refreshWidgets()
                    refreshSongInfo()
                elseif songList[data] then
                    TASK.removeTask_code(Task_MusicEnd)
                    PlayBGM(data, true)
                    if not MusicPlayer then
                        MusicPlayer = true
                        refreshWidgets()
                    end
                    refreshSongInfo()
                elseif data == 'UseAltName' then
                    UseAltName()
                    SFX.play('social_dm')
                elseif data == 'UseEasyName' or data == 'UseEasName' then
                    STAT.easyName = not STAT.easyName
                    SFX.play('social_dm')
                    MSG('dark', "Easy Names In-Game: " .. (STAT.easyName and "ON" or "OFF"))
                elseif data == 'imperial' or data == 'feet' then
                    STAT.imperial = not STAT.imperial
                    SFX.play('social_dm')
                    MSG('dark', "Imperial Units: " .. (STAT.imperial and "ON" or "OFF"))
                elseif data == 'promotion' then
                    STAT.promotion = not STAT.promotion
                    SFX.play('social_dm')
                    MSG('dark', "Rank Promotion Gauge: " .. (STAT.promotion and "ON" or "OFF"))
                elseif data == 'old_transparent_card' or data == 'oldTransparentCard' or data == 'oldtransparentcard' or data == 'oldeO' then
                    STAT.oldTransparentCard = not STAT.oldTransparentCard
                    SFX.play('social_dm')
                    MSG('dark', "Transparent Card: " .. (STAT.oldTransparentCard and "V1.0/1.1" or "V1.2+"))
                elseif data == 'eZ' or data == 'ez' then
                    if not GAME.enightcore and anyPieceActive then 
                        SFX.play('damage_alert')
                        MSG('dark', "WARNING: MULTIPLE PIECES ENABLED DISABLES SCORING AND MAY CAUSE ISSUES. DO NOT REPORT!")
                        GAME.multiplePiecesActive = true
                    else
                        SFX.play('social_dm')
                    end
                    GAME.enightcore = not GAME.enightcore
                    MSG('dark', "eZ: " .. (GAME.enightcore and "ON" or "OFF"))
                    GAME.refreshLayout()
                    RefreshBGM()
                    GAME.refreshCurrentCombo()
                elseif data == 'eS' or data == 'es' then
                    if not GAME.eslowmo and anyPieceActive then 
                        SFX.play('damage_alert')
                        MSG('dark', "WARNING: MULTIPLE PIECES ENABLED DISABLES SCORING AND MAY CAUSE ISSUES. DO NOT REPORT!")
                        GAME.multiplePiecesActive = true
                    else
                        SFX.play('social_dm')
                    end
                    GAME.eslowmo = not GAME.eslowmo
                    MSG('dark', "eS: " .. (GAME.eslowmo and "ON" or "OFF"))
                    GAME.refreshLayout()
                    RefreshBGM()
                    GAME.refreshCurrentCombo()
                elseif data == 'eJ' or data == 'ej' then
                    if not GAME.eglassCard and anyPieceActive then 
                        SFX.play('damage_alert')
                        MSG('dark', "WARNING: MULTIPLE PIECES ENABLED DISABLES SCORING AND MAY CAUSE ISSUES. DO NOT REPORT!")
                        GAME.multiplePiecesActive = true
                    else
                        SFX.play('social_dm')
                    end
                    GAME.eglassCard = not GAME.eglassCard
                    MSG('dark', "eJ: " .. (GAME.eglassCard and "ON" or "OFF"))
                    GAME.refreshLayout()
                    GAME.refreshCurrentCombo()
                elseif data == 'eL' or data == 'el' then
                    if not GAME.efastLeak and anyPieceActive then 
                        SFX.play('damage_alert')
                        MSG('dark', "WARNING: MULTIPLE PIECES ENABLED DISABLES SCORING AND MAY CAUSE ISSUES. DO NOT REPORT!")
                        GAME.multiplePiecesActive = true
                    else
                        SFX.play('social_dm')
                    end
                    GAME.efastLeak = not GAME.efastLeak
                    MSG('dark', "eL: " .. (GAME.efastLeak and "ON" or "OFF"))
                    GAME.refreshLayout()
                    GAME.refreshCurrentCombo()
                elseif data == 'eT' or data == 'et' then
                    if not GAME.einvisUI and anyPieceActive then 
                        SFX.play('damage_alert')
                        MSG('dark', "WARNING: MULTIPLE PIECES ENABLED DISABLES SCORING AND MAY CAUSE ISSUES. DO NOT REPORT!")
                        GAME.multiplePiecesActive = true
                    else
                        SFX.play('social_dm')
                    end
                    GAME.einvisUI = not GAME.einvisUI
                    MSG('dark', "eT: " .. (GAME.einvisUI and "ON" or "OFF"))
                    GAME.refreshLayout()
                    GAME.refreshCurrentCombo()
                elseif data == 'eO' or data == 'eo' then
                    if not GAME.einvisCard and anyPieceActive then 
                        SFX.play('damage_alert')
                        MSG('dark', "WARNING: MULTIPLE PIECES ENABLED DISABLES SCORING AND MAY CAUSE ISSUES. DO NOT REPORT!")
                        GAME.multiplePiecesActive = true
                    else
                        SFX.play('social_dm')
                    end
                    GAME.einvisCard = not GAME.einvisCard
                    MSG('dark', "eO: " .. (GAME.einvisCard and "ON" or "OFF"))
                    GAME.refreshLayout()
                    GAME.refreshCurrentCombo()
                elseif data == 'eI' or data == 'ei' then
                    if not GAME.ecloseCard and anyPieceActive then 
                        SFX.play('damage_alert')
                        MSG('dark', "WARNING: MULTIPLE PIECES ENABLED DISABLES SCORING AND MAY CAUSE ISSUES. DO NOT REPORT!")
                        GAME.multiplePiecesActive = true
                    else
                        SFX.play('social_dm')
                    end
                    GAME.ecloseCard = not GAME.ecloseCard
                    MSG('dark', "eI: " .. (GAME.ecloseCard and "ON" or "OFF"))
                    GAME.refreshLayout()
                    GAME.refreshCurrentCombo()
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
                            "Try 'UseEasyName'",
                            "Try 'imperial'",
                            "Try 'promotion'",
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
            elseif res1.mod and res1.mod ~= 'vanilla' and res1.mod ~= 'easyMode' then
                MSG('dark', "Cannot import data from modded version")
                SFX.play('staffwarning')
                return
            end
            TABLE.update(STAT, res1)
            STAT.mod = 'easyMode'
            BEST, ACHV = res2, res3
            setmetatable(BEST.highScore, Metatable.best_highscore)
            GAME.refreshLockState()
            setmetatable(BEST.speedrun, Metatable.best_speedrun)
            if STAT.system ~= SYSTEM then
                STAT.system = SYSTEM
                IssueAchv('zenith_relocation')
            end
            Initialize(true)
            if TestMode or GAME.multiplePiecesActive then
                MSG('dark', "Progress imported, but won't be saved.")
            else
                MSG('dark', "Progress imported!")
            end
            SFX.play('social_notify_major')
        end,
    },

    -- AUDIO
    WIDGET.new {
        type = 'text', alignX = 'left',
        name = 'audio',
        text = "AUDIO",
        color = clr.T,
        fontSize = 50,
        x = baseX + 30, y = baseY + 250,
    },
    WIDGET.new {
        name = 'mute',
        type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "MUTE ON UNFOCUS",
        x = baseX + 562, y = baseY + 255,
        disp = function() return STAT.autoMute end,
        code = function() STAT.autoMute = not STAT.autoMute end,
    },
    WIDGET.new {
        type = 'slider',
        x = baseX + 240 + 85, y = baseY + 310, w = 400,
        axis = { 0, 100, 10 },
        frameColor = 'dD', fillColor = clr.D,
        disp = function() return STAT.sfx end,
        code = function(value)
            STAT.sfx = value
            ApplySettings()
        end,
        sound_drag = 'rotate',
    },
    WIDGET.new {
        type = 'slider',
        x = baseX + 240 + 85, y = baseY + 380, w = 400,
        axis = { 0, 100, 10 },
        frameColor = 'dD', fillColor = clr.D,
        disp = function() return STAT.bgm end,
        code = function(value)
            STAT.bgm = value
            ApplySettings()
        end,
        sound_drag = 'rotate',
    },

    -- VIDEO
    WIDGET.new {
        name = 'video',
        type = 'text', alignX = 'left',
        text = "VIDEO",
        color = clr.T,
        fontSize = 50,
        x = baseX + 30, y = baseY + 460,
    },
    WIDGET.new {
        type = 'slider',
        x = baseX + 240 + 85, y = baseY + 520, w = 400,
        axis = { 80, 100, 5 },
        frameColor = 'dD', fillColor = clr.D,
        disp = function() return STAT.cardBrightness end,
        code = function(value) STAT.cardBrightness = value end,
        sound_drag = 'rotate',
    },
    WIDGET.new {
        type = 'slider',
        x = baseX + 240 + 85, y = baseY + 590, w = 400,
        axis = { 30, 80, 10 },
        frameColor = 'dD', fillColor = clr.D,
        disp = function() return STAT.bgBrightness end,
        code = function(value) STAT.bgBrightness = value end,
        sound_drag = 'rotate',
    },
    WIDGET.new {
        type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "FANCY BACKGROUND  (F9)",
        x = baseX + 55, y = baseY + 670,
        disp = function() return STAT.bg end,
        code = WIDGET.c_pressKey 'f9',
    },
    WIDGET.new {
        type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "STAR FORCE  (F10)",
        x = baseX + 55, y = baseY + 730,
        disp = function() return not STAT.syscursor end,
        code = WIDGET.c_pressKey 'f10',
    },
    WIDGET.new {
        type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "FULLSCREEN  (F11)",
        x = baseX + 55, y = baseY + 790,
        disp = function() return STAT.fullscreen end,
        code = WIDGET.c_pressKey 'f11',
    },

    -- KEYBIND
    WIDGET.new {
        name = 'keybind', type = 'button',
        x = baseX + 740, y = baseY + 790, w = 260, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "REBIND  KEY",
        sound_hover = 'menutap',
        sound_release = 'menuclick',
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
                            table.concat(TABLE.sub(STAT.keybind, 1, 9), ', ') .. "\n" ..
                            table.concat(TABLE.sub(STAT.keybind, 10, 18), ', ') .. "\n" ..
                            "Commit: " .. STAT.keybind[19] .. "\n" ..
                            "Reset: " .. STAT.keybind[20] .. "\n" ..
                            "Click L/R: " .. STAT.keybind[21] .. ", " .. STAT.keybind[22] .. "\n",
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

    WIDGET.new {
        name = 'back', type = 'button',
        pos = { 0, 0 }, x = 60, y = 140, w = 160, h = 60,
        color = { .15, .15, .15 },
        sound_hover = 'menutap',
        fontSize = 30, text = "    BACK", textColor = 'DL',
        onClick = function() love.keypressed('escape') end,
    },
}

return scene
