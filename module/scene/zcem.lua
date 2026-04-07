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
local bpmMode = false
local reverse = (GAME.mod.EX == 2 or GAME.mod.NH == 2 or GAME.mod.MS == 2 or GAME.mod.GV == 2 or GAME.mod.VL == 2 or GAME.mod.DH == 2 or GAME.mod.IN == 2 or GAME.mod.AS == 2 or GAME.mod.DP == 2)
local uneasy = (GAME.mod.EX == -1 and URM and GAME.mod.NH < 2 and GAME.mod.MS < 2 and GAME.mod.GV < 2 and GAME.mod.VL < 2 and GAME.mod.DH < 2 and GAME.mod.IN < 2 and GAME.mod.AS < 2 and GAME.mod.DP < 2)
local smithyMode = GAME.mod.EX == -1 and GAME.mod.VL == -1 and GAME.mod.AS == -1 and GAME.mod.NH == 0 and GAME.mod.MS == 0 and GAME.mod.GV == 0 and GAME.mod.DH == 0 and GAME.mod.IN == 0 and GAME.mod.DP == 0
local lastNonTera = 'f0'
local mode = ''
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
    scene.widgetList.gameplay:setVisible(not MusicPlayer)
    scene.widgetList.musicplay:setVisible(MusicPlayer)
    scene.widgetList.prevtrack:setVisible(MusicPlayer)
    scene.widgetList.nexttrack:setVisible(MusicPlayer)
    scene.widgetList.tera:setVisible(MusicPlayer)
    scene.widgetList.reverse:setVisible(MusicPlayer)
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
    refreshWidgets()
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
function scene.keyDown(key, isRep)
    if isRep then return true end
    if key == 'escape' then
        SFX.play('menuclick')
        SCN.back('none')
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
        gc_print("ZCEM SETTINGS", 15, 68, 0, 1, -1)
    else
        gc_print("ZCEM SETTINGS", 15, 0)
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
    gc_print("TWEAK YOUR SETTINGS FOR A BETTER MODDED EXPERIENCE", 15, -45, 0, .85, 1)
end

function scene.overDraw()
    -- BPM/Speed Indicator
    local data = BgmData[BgmPlaying]
    local bpm = data.bpm
    local speedMod = 1
    if GAME.nightcore then 
        bpm = bpm * 2
        speedMod = speedMod * 2
    end
    if GAME.enightcore then 
        bpm = bpm * 2
        speedMod = speedMod * 2
    end
    if GAME.slowmo then 
        bpm = bpm / 2
        speedMod = speedMod / 2
    end
    if GAME.eslowmo then
        bpm = bpm * 0.70711
        speedMod = speedMod * 0.70711
    end
    if GAME.mod.GV == -1 then
        bpm = bpm * 0.70711
    elseif GAME.mod.GV == 1 then
        bpm = bpm * 1.05946
    elseif GAME.mod.GV == 2 then
        if not URM then
            bpm = bpm * 1.12246
        else
            bpm = bpm * 1.18921
        end
    end
    local playTime = 0
    local beatLen = 0
    local dy = 0
    if MusicPlayer then
        playTime = BGM.tell()
        beatLen = 60 / BgmData[BgmPlaying].bpm
        dy = MATH.clamp(6 * math.sin(playTime / beatLen * 3.1416), -2.6, 2.6)
    end
    if bpmMode then
        local bpmString = "BPM: "..tostring(MATH.floor(bpm*100)/100)
        gc_setColor(bgmColors[BgmPlaying] or clr.LT)
        gc_setAlpha(1)
        FONT.set(65)
        gc_print(bpmString, 835, 100 + dy)
    else
        local speedString = "SPEED: "..tostring(MATH.floor(speedMod*100)/100) .. "x"
        gc_setColor(bgmColors[BgmPlaying] or clr.LT)
        gc_setAlpha(1)
        FONT.set(65)
        gc_print(speedString, 835, 100 + dy)
    end
end

scene.widgetList = {

    -- GAMEPLAY OPTIONS/MUSIC PLAYER OPTIONS
    WIDGET.new {
        name = 'gameplay', type = 'button', 
        x = baseX + 220, y = baseY + 60, w = 410, h = 70,
        color = clr.T,
        sound_hover = 'menutap',
        fontSize = 50, text = "GAME PLAY", textColor = clr.LT,
        onClick = function()
            MusicPlayer = not MusicPlayer
            bpmMode = true
            refreshWidgets()
        end,
    },
    WIDGET.new {
        name = 'musicplay', type = 'button', 
        x = baseX + 220, y = baseY + 60, w = 410, h = 70,
        color = clr.T,
        sound_hover = 'menutap',
        fontSize = 50, text = "MUSIC PLAY", textColor = clr.LT,
        onClick = function()
            MusicPlayer = not MusicPlayer
            refreshWidgets()
        end,
    },
    WIDGET.new {
        name = 'bpm', type = 'button', 
        x = baseX + 685, y = baseY + 60, w = 410, h = 70,
        color = clr.T,
        sound_hover = 'menutap',
        fontSize = 50, text = "", textColor = clr.LT,
        onClick = function()
            bpmMode = not bpmMode
            refreshWidgets()
        end,
    },
    WIDGET.new {
        name = 'prevtrack', type = 'button', 
        x = baseX + 220, y = baseY + 60 + 80, w = 410, h = 70,
        color = clr.T,
        sound_hover = 'menutap',
        fontSize = 50, text = "PREV TRACK", textColor = clr.LT,
        onClick = function()
            MSG.clear()
            TASK.removeTask_code(Task_MusicEnd)
            if BgmPlaying:count('f') == 1 then
                local floor = -1
                if BgmPlaying ~= 'fomg' then
                    floor = tonumber(BgmPlaying:gsub('[fr]', ''),10) - 1
                    if floor == -1 then
                        PlayBGM('fomg',true)
                        mode = ''
                    else
                        if floor == 0 and reverse then mode = 'f0r' end
                        if floor == 1 and reverse then mode = 'f1r' end
                        PlayBGM('f' .. floor .. (reverse and 'r' or ''),true)
                    end
                else
                    PlayBGM('f10' .. (reverse and 'r' or ''),true)
                end
                MSG("bright", "Now Playing: " .. BgmPlaying .. ((mode == 'f1r' and floor == 1 or mode == 'f0r' and floor == 0) and 'r' or ''))
            else
                MSG("dark", "DISABLE TERASPEED FIRST!")
            end
            RefreshBGM(mode)
            refreshWidgets()
        end,
    },
    WIDGET.new {
        name = 'nexttrack', type = 'button', 
        x = baseX + 685, y = baseY + 60 + 80, w = 410, h = 70,
        color = clr.T,
        sound_hover = 'menutap',
        fontSize = 50, text = "NEXT TRACK", textColor = clr.LT,
        onClick = function()
            MSG.clear()
            TASK.removeTask_code(Task_MusicEnd)
            if BgmPlaying:count('f') == 1 then
                local floor = -1
                if BgmPlaying ~= 'fomg' then
                    floor = tonumber(BgmPlaying:gsub('[fr]', ''),10) + 1
                    if floor == 11 then
                        PlayBGM('fomg',true)
                        mode = ''
                    else
                        if floor == 1 and reverse then mode = 'f1r' end
                        PlayBGM('f' .. floor .. (reverse and 'r' or ''),true)
                    end
                else
                    if reverse then mode = 'f0r' end
                    PlayBGM('f0',true)
                end
                MSG("bright", "Now Playing: " .. BgmPlaying .. ((mode == 'f1r' and floor == 1 or mode == 'f0r' and floor == 0) and 'r' or ''))
            else
                MSG("dark", "DISABLE TERASPEED FIRST!")
            end
            RefreshBGM(mode)
            refreshWidgets()
        end,
    },
    WIDGET.new {
        name = 'tera', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "TERASPEED",
        x = baseX + 220, y = baseY + 60 + 160,
        disp = function() return BgmPlaying:count('t') == 1 end,
        code = function()
            MSG.clear()
            TASK.removeTask_code(Task_MusicEnd)
            if BgmPlaying:count('t') == 1 then
                if reverse and lastNonTera:count('r') == 0 then
                    if lastNonTera == 'f0' then mode = 'f0r'
                    elseif lastNonTera == 'f1' then mode = 'f1r'
                    elseif lastNonTera ~= 'fomg' then lastNonTera = lastNonTera .. 'r'
                    end
                end
                PlayBGM(lastNonTera, true)
                MSG("bright", "Now Playing: " .. BgmPlaying .. ((mode == 'f1r' and BgmPlaying == 'f1' or mode == 'f0r' and BgmPlaying == 'f0') and 'r' or ''))
            else
                lastNonTera = BgmPlaying
                if reverse or (GAME.mod.EX == 2 or GAME.mod.NH == 2 or GAME.mod.MS == 2 or GAME.mod.GV == 2 or GAME.mod.VL == 2 or GAME.mod.DH == 2 or GAME.mod.IN == 2 or GAME.mod.AS == 2 or GAME.mod.DP == 2) then
                    PlayBGM('terar', true)
                elseif uneasy or (GAME.mod.EX == -1 and URM and GAME.mod.NH < 2 and GAME.mod.MS < 2 and GAME.mod.GV < 2 and GAME.mod.VL < 2 and GAME.mod.DH < 2 and GAME.mod.IN < 2 and GAME.mod.AS < 2 and GAME.mod.DP < 2) then
                    if smithyMode or (GAME.mod.EX == -1 and GAME.mod.VL == -1 and GAME.mod.AS == -1 and GAME.mod.NH == 0 and GAME.mod.MS == 0 and GAME.mod.GV == 0 and GAME.mod.DH == 0 and GAME.mod.IN == 0 and GAME.mod.DP == 0) then
                        PlayBGM('terael', true)
                    else
                        PlayBGM('teral', true)
                    end
                elseif smithyMode or (GAME.mod.EX == -1 and GAME.mod.VL == -1 and GAME.mod.AS == -1 and GAME.mod.NH == 0 and GAME.mod.MS == 0 and GAME.mod.GV == 0 and GAME.mod.DH == 0 and GAME.mod.IN == 0 and GAME.mod.DP == 0) then
                    PlayBGM('terae', true)
                else
                    PlayBGM('tera', true)
                end
                MSG("bright", "Now Playing: " .. BgmPlaying)
            end
            RefreshBGM(mode)
            refreshWidgets()
        end,
    },
    WIDGET.new {
        name = 'reverse', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "REVERSE",
        x = baseX + 685, y = baseY + 60 + 160,
        disp = function() return (BgmPlaying:count('t') == 0 and BgmPlaying:count('r') == 1) or BgmPlaying:count('r') == 2 or (mode == 'f0r' or mode == 'f1r') end,
        code = function()
            MSG.clear()
            TASK.removeTask_code(Task_MusicEnd)
            if (BgmPlaying:count('t') == 0 and BgmPlaying:count('r') == 1) or BgmPlaying:count('r') == 2 or (mode == 'f0r' or mode == 'f1r') then
                reverse = false
                if BgmPlaying:count('r') == 2 then
                    if uneasy or (GAME.mod.EX == -1 and URM and GAME.mod.NH < 2 and GAME.mod.MS < 2 and GAME.mod.GV < 2 and GAME.mod.VL < 2 and GAME.mod.DH < 2 and GAME.mod.IN < 2 and GAME.mod.AS < 2 and GAME.mod.DP < 2) then
                        if smithyMode or (GAME.mod.EX == -1 and GAME.mod.VL == -1 and GAME.mod.AS == -1 and GAME.mod.NH == 0 and GAME.mod.MS == 0 and GAME.mod.GV == 0 and GAME.mod.DH == 0 and GAME.mod.IN == 0 and GAME.mod.DP == 0) then
                            PlayBGM('terael', true)
                        else
                            PlayBGM('teral', true)
                        end
                    elseif smithyMode or (GAME.mod.EX == -1 and GAME.mod.VL == -1 and GAME.mod.AS == -1 and GAME.mod.NH == 0 and GAME.mod.MS == 0 and GAME.mod.GV == 0 and GAME.mod.DH == 0 and GAME.mod.IN == 0 and GAME.mod.DP == 0) then
                        PlayBGM('terae', true)
                    else
                        PlayBGM('tera', true)
                    end
                else
                    mode = ''
                    PlayBGM(BgmPlaying:gsub('r',''), true)
                end
                MSG("bright", "Now Playing: " .. BgmPlaying)
            else
                if BgmPlaying:count('t') == 1 then
                    PlayBGM('terar', true)
                    reverse = true
                elseif BgmPlaying ~= 'fomg' then
                    if BgmPlaying == 'f0' or BgmPlaying == 'f1' then mode = BgmPlaying .. 'r' end
                    PlayBGM(BgmPlaying .. (BgmPlaying:count('r') == 0 and 'r' or ''), true)
                    reverse = true
                else
                    MSG("dark", "CANNOT REVERSE fomg")
                end
                if BgmPlaying ~= 'fomg' then MSG("bright", "Now Playing: " .. BgmPlaying .. ((mode == 'f1r' and BgmPlaying == 'f1' or mode == 'f0r' and BgmPlaying == 'f0') and 'r' or '')) end
            end
            RefreshBGM(mode)
            refreshWidgets()
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
