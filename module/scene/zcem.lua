---@type Zenitha.Scene
local scene = {}

local clr = {
    D = COLOR.DG,
    L = { .15, .75, .15 },
    T = { COLOR.HEX '6FAC82FF' },
    LT = { COLOR.HEX 'B0EBCCFF' },
    cbFill = { COLOR.HEX '0B0E17FF' },
    cbFrame = { COLOR.HEX '6A82A7FF' },
}
local colorRev = false
local bpmMode = false
local lastNonTera = 'f0'
local mode = ''
local leftx, rightx, leftbx, rightbx = 40, 500, 220, 685
local startHour = os.date('%H')
local startMin = os.date('%M')
local startSec = os.date('%S')
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

-- Panel size
local w, h = 900, 830
local baseX, baseY = (1600 - w) / 2, (1000 - h) / 2

local gc = love.graphics
local gc_replaceTransform = gc.replaceTransform
local gc_setColor, gc_rectangle, gc_print, gc_printf = gc.setColor, gc.rectangle, gc.print, gc.printf
local gc_ucs_move, gc_ucs_back = GC.ucs_move, GC.ucs_back
local gc_setAlpha, gc_mRect, gc_mStr = GC.setAlpha, GC.mRect, GC.mStr
local gc_draw = gc.draw
local gc_line, gc_circle, gc_rotate, gc_setLineWidth = gc.line, gc.circle, gc.rotate, gc.setLineWidth
local sin, cos = math.sin, math.cos

local function refreshWidgets()
    scene.widgetList.gameplay:setVisible(not MusicPlayer)
    scene.widgetList.promotion:setVisible(not MusicPlayer)
    scene.widgetList.imperial:setVisible(not MusicPlayer)
    scene.widgetList.oldTransparentCard:setVisible(not MusicPlayer)
    scene.widgetList.oldHitbox:setVisible(not MusicPlayer)
    scene.widgetList.easyName:setVisible(not MusicPlayer)
    scene.widgetList.stacker:setVisible(not MusicPlayer)
    scene.widgetList.musicplay:setVisible(MusicPlayer)
    scene.widgetList.prevtrack:setVisible(MusicPlayer)
    scene.widgetList.nexttrack:setVisible(MusicPlayer)
    scene.widgetList.tera:setVisible(MusicPlayer)
    scene.widgetList.reverse:setVisible(MusicPlayer)
    scene.widgetList.uneasy:setVisible(MusicPlayer)
    scene.widgetList.smithyMode:setVisible(MusicPlayer)
    for _,  W in next, scene.widgetList do
        if W.name ~= 'back' then
            if GAME.ecloseCard then
                if W.x < 700 then
                    if W.type == "checkBox" then
                        W.x = baseX + leftx + 20
                    elseif W.type == "button" then
                        W.x = baseX + leftbx + 20
                    else
                        W.x = baseX + 20 + 20
                    end
                else
                    if W.type == "checkBox" then
                        W.x = baseX + rightx - 20
                    elseif W.type == "button" then
                        W.x = baseX + rightbx - 20
                    end
                end
                W:resetPos()
            else
                if W.x < 700 then
                    if W.type == "checkBox" then
                        W.x = baseX + leftx
                    elseif W.type == "button" then
                        W.x = baseX + leftbx
                    else
                        W.x = baseX + 20
                    end
                else
                    if W.type == "checkBox" then
                        W.x = baseX + rightx
                    elseif W.type == "button" then
                        W.x = baseX + rightbx
                    end
                end
                W:resetPos()
            end
            if GAME.eglassCard then
                if #W.name > 2 and W.type ~= "button" and W.name ~= "urm" then
                    W.textColor = COLOR.L
                end
            else
                if #W.name > 2 and W.type ~= "button" and W.name ~= "urm" then
                    W.textColor = clr.T
                end
            end
        end
    end
end

local function anyPieceActive()
    return GAME.nightcore or GAME.enightcore or GAME.slowmo or GAME.eslowmo or GAME.glassCard or GAME.eglassCard or GAME.fastLeak or GAME.efastLeak or GAME.invisUI or GAME.einvisUI or GAME.invisCard or GAME.einvisCard or GAME.closeCard or GAME.ecloseCard
end

local function countPiecesActive()
    return (GAME.nightcore and 1 or 0) + (GAME.enightcore and 1 or 0) + (GAME.slowmo and 1 or 0) + (GAME.eslowmo and 1 or 0) + (GAME.glassCard and 1 or 0) + (GAME.eglassCard and 1 or 0) + (GAME.fastLeak and 1 or 0) + (GAME.efastLeak and 1 or 0) + (GAME.invisUI and 1 or 0) + (GAME.einvisUI and 1 or 0) + (GAME.invisCard and 1 or 0) + (GAME.einvisCard and 1 or 0) + (GAME.closeCard and 1 or 0) + (GAME.ecloseCard and 1 or 0)
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
        GAME.refreshCurrentCombo()
    end
    ZENITHA._cursor.active=true
    return true
end

scene.resize = refreshWidgets

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

    -- ClockEffect
    local gravityMod = 1
    if GAME.mod.GV == 2 and URM then
        gravityMod = 2 ^ (3/12)
    elseif GAME.mod.GV == 2 then
        gravityMod = 2 ^ (2/12)
    elseif GAME.mod.GV == 1 then
        gravityMod = 2 ^ (1/12)
    elseif GAME.mod.GV == -1 then
        gravityMod = 2 ^ (-6/12)
    end
    local clockMod = 9.57
    if GAME.enightcore or GAME.eslowmo then
        gc_replaceTransform(SCR.xOy_m)
        gc_rotate(-1.5708)
        gc_setLineWidth(42)
        local a = love.timer.getTime()
        -- goal is for all hands to complete a revolution at *gravityMod* rate
        local h = a*gravityMod/(3600*clockMod) + startHour/6 * 3.1416
        local m = a*gravityMod/(60*clockMod) + startMin/30 * 3.1416
        local s = a*gravityMod/clockMod + startSec/30 * 3.1416
        local o = a*gravityMod*(184/4)/clockMod -- 184 rotations per minute
        local x = a*gravityMod*(240/4)/clockMod -- 240 rotations per minute
        if GAME.enightcore then
            gc_setColor(1, 1, 1, GAME.playing and .1 or .26)
            gc_circle('line', 0, 0, 620)
            gc_setColor(1, 1, 1, GAME.playing and .26 or .42)
            --a = os.date('%H') / 6 * 3.1416
            gc_setLineWidth(26)
            gc_line(0, 0, 120 * cos(h), 120 * sin(h))
            --a = os.date('%M') / 30 * 3.1416
            gc_setLineWidth(16)
            gc_line(0, 0, 260 * cos(m), 260 * sin(m))
            --a = os.date('%S') / 30 * 3.1416
            gc_setLineWidth(10)
            gc_line(0, 0, 420 * cos(s), 420 * sin(s))
            --a = love.timer.getTime() / 30 * 3.1416 * 26
            gc_line(0, 0, 520 * cos(o), 520 * sin(o))
            --a = love.timer.getTime() / 30 * 3.1416 * 60
            gc_line(0, 0, 600 * cos(x), 600 * sin(x))
        else
            gc_setColor(1, 1, 1, GAME.playing and .1 or .26)
            gc_circle('line', 0, 0, 620)
            gc_setColor(1, 1, 1, GAME.playing and .26 or .42)
            --a = os.date('%H') / 6 * 3.1416
            gc_setLineWidth(26)
            gc_line(0, 0, 120 * cos(h), 120 * sin(h))
            --a = os.date('%M') / 30 * 3.1416
            gc_setLineWidth(16)
            gc_line(0, 0, 260 * cos(m), 260 * sin(m))
            --a = os.date('%S') / 30 * 3.1416
            gc_setLineWidth(10)
            gc_line(0, 0, 420 * cos(s), 420 * sin(s))
        end
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
    if GAME.eglassCard then
        local speedMod = ((GAME.enightcore or GAME.nightcore) and 2 or 1) * (GAME.eslowmo and 0.75 or 1) * (GAME.slowmo and 0.5 or 1)
        gc_setColor(COLOR.rainbow_dark(2.6 * t * speedMod))
    end
    gc_setAlpha(GAME.einvisCard and 0.626 or 1)
    gc_rectangle('fill', 0, 0, w, h)
    gc_setColor(0, 0, 0, GAME.einvisCard and 0.13 or .26)
    gc_rectangle('fill', 3, 3, w - 6, h - 6)
    gc_setColor(1, 1, 1, GAME.einvisCard and 0.05 or .1)
    gc_rectangle('fill', 0, 0, w, 3)
    gc_setColor(1, 1, 1, GAME.einvisCard and 0.02 or .04)
    gc_rectangle('fill', 0, 3, 3, h + 3)

    if GAME.efastLeak then
        gc_setAlpha(1)
        gc_replaceTransform(SCR.origin)
        gc_setColor(0, .42, 1, (GAME.mod.EX > 0 and .62 or .42))
        gc_draw(TEXTURE.transition, 0, 0, 0, .42 / 128 * SCR.w, SCR.h)
        gc_draw(TEXTURE.transition, SCR.w, 0, 0, -.42 / 128 * SCR.w, SCR.h)
    end

    -- Top bar & title
    gc_replaceTransform(SCR.xOy_u)
    gc_setColor(clr.D)
    gc_setAlpha(GAME.einvisUI and 0.626 or 1)
    gc_rectangle('fill', -1300, 0, 2600, 70)
    gc_setColor(clr.L)
    gc_setAlpha(GAME.einvisUI and 0.262 or .626)
    gc_rectangle('fill', -1300, 70, 2600, 3)
    gc_replaceTransform(SCR.xOy_ul)
    gc_setColor(clr.L)
    gc_setAlpha(GAME.einvisUI and 0.626 or 1)
    FONT.set(50)
    if GAME.anyRev then
        gc_print("ZCEM SETTINGS", 15, 68, 0, 1, -1)
    else
        gc_print("ZCEM SETTINGS", 15, 0)
    end

    -- Bottom bar & text
    gc_replaceTransform(SCR.xOy_d)
    gc_setColor(clr.D)
    gc_setAlpha(GAME.einvisUI and 0.626 or 1)
    gc_rectangle('fill', -1300, 0, 2600, -50)
    gc_setColor(clr.L)
    gc_setAlpha(GAME.einvisUI and 0.262 or .626)
    gc_rectangle('fill', -1300, -50, 2600, -3)
    gc_replaceTransform(SCR.xOy_dl)
    gc_setColor(clr.L)
    gc_setAlpha(GAME.einvisUI and 0.626 or 1)
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
        speedMod = speedMod * 2.6
    end
    if GAME.enightcore then 
        bpm = bpm * 2
    end
    if GAME.slowmo then 
        bpm = bpm / 2
    end
    if GAME.eslowmo then
        bpm = bpm * 0.70711
        speedMod = speedMod * 0.75
    end
    if GAME.ecloseCard then
        speedMod = speedMod * 2
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
    local t = love.timer.getTime()
    if MusicPlayer then
        playTime = BGM.tell()
        beatLen = 60 / BgmData[BgmPlaying].bpm
        dy = MATH.clamp(6 * math.sin(playTime / beatLen * 3.1416), -2.6, 2.6)
    end
    if bpmMode then
        local bpmString = "BPM: "..tostring(MATH.floor(bpm*100)/100)
        gc_setColor(bgmColors[BgmPlaying] or clr.LT)
        if BgmPlaying == 'tera' or BgmPlaying == 'terar' or BgmPlaying == 'terae' or BgmPlaying == 'teral' or BgmPlaying == 'terael' then
            gc_setColor(COLOR.rainbow_light(2.6 * t * bpm/240))
        end
        gc_setAlpha(1)
        FONT.set(65)
        gc_print(bpmString, 835 - (GAME.ecloseCard and 20 or 0), 100 + dy)
    else
        local speedString = "SPEED: "..tostring(MATH.floor(speedMod*100)/100) .. "x"
        gc_setColor(bgmColors[BgmPlaying] or clr.LT)
        if BgmPlaying == 'tera' or BgmPlaying == 'terar' or BgmPlaying == 'terae' or BgmPlaying == 'teral' or BgmPlaying == 'terael' then
            gc_setColor(COLOR.rainbow_light(2.6 * t * bpm/240))
        end
        gc_setAlpha(1)
        FONT.set(65)
        gc_print(speedString, 835 - (GAME.ecloseCard and 20 or 0), 100 + dy)
    end
    if countPiecesActive() > 1 then
        gc_setColor(COLOR.R)
        gc_setAlpha(1)
        FONT.set(50)
        gc_print("MULTIPLE PIECES!!!", 770 - (GAME.ecloseCard and 20 or 0), baseY + 338 + dy)
    else
        GAME.multiplePiecesActive = false
    end
    if URM then
        gc_replaceTransform(SCR.origin)
        gc_setColor(.42, 0, 0, .35)
        gc_draw(TEXTURE.pixel, 0, 0, 0, SCR.w, SCR.h)
        gc_setColor(0, 0, 0, GAME.mod.EX == 2 and .62 or .42)
        gc_draw(TEXTURE.darkCorner, 0, 0, 0, SCR.w / 128, SCR.h / 128)
    end
end

scene.widgetList = {

    -- GAMEPLAY OPTIONS
    WIDGET.new { -- Game Play
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
    -- BPM button is shared with MP options
    WIDGET.new { -- Promotion
        name = 'promotion', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "PROMOTION GAUGE",
        x = baseX + 40, y = baseY + 60 + 80,
        disp = function() return STAT.promotion end,
        code = function()
            local multiple = GAME.multiplePiecesActive
            MSG.clear()
            STAT.promotion = not STAT.promotion
            SFX.play('social_dm')
            MSG('dark', "Rank Promotion Gauge: " .. (STAT.promotion and "ON" or "OFF"))
            GAME.multiplePiecesActive = false
            SaveStat()
            if multiple then GAME.multiplePiecesActive = true end
        end,
    },
    WIDGET.new { -- Imperial
        name = 'imperial', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "IMPERIAL UNITS",
        x = baseX + 500, y = baseY + 60 + 80,
        disp = function() return STAT.imperial end,
        code = function()
            local multiple = GAME.multiplePiecesActive
            MSG.clear()
            STAT.imperial = not STAT.imperial
            SFX.play('social_dm')
            MSG('dark', "Imperial Units: " .. (STAT.imperial and "ON" or "OFF"))
            GAME.multiplePiecesActive = false
            SaveStat()
            if multiple then GAME.multiplePiecesActive = true end
        end,
    },
    WIDGET.new { -- Old Transparent Card
        name = 'oldTransparentCard', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "OLD TRANSPARENT CARD",
        x = baseX + 40, y = baseY + 60 + 160,
        disp = function() return STAT.oldTransparentCard end,
        code = function()
            local multiple = GAME.multiplePiecesActive
            MSG.clear()
            STAT.oldTransparentCard = not STAT.oldTransparentCard
            SFX.play('social_dm')
            MSG('dark', "Transparent Card: " .. (STAT.oldTransparentCard and "V1.0/1.1" or "V1.2+"))
            GAME.multiplePiecesActive = false
            SaveStat()
            if multiple then GAME.multiplePiecesActive = true end
        end,
    },
    WIDGET.new { -- Old Hitbox
        name = 'oldHitbox', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "OLD HITBOX",
        x = baseX + 500, y = baseY + 60 + 160,
        disp = function() return STAT.oldHitbox end,
        code = function()
            local multiple = GAME.multiplePiecesActive
            MSG.clear()
            STAT.oldHitbox = not STAT.oldHitbox
            MSG('dark', "Force old hitbox: " .. (STAT.oldHitbox and "ON" or "OFF"))
            SFX.play(STAT.oldHitbox and 'social_online' or 'social_offline')
            GAME.multiplePiecesActive = false
            SaveStat()
            if multiple then GAME.multiplePiecesActive = true end
        end,
    },
    WIDGET.new { -- Use Easy Names
        name = 'easyName', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "USE EASY NAMES",
        x = baseX + 40, y = baseY + 60 + 240,
        disp = function() return STAT.easyName end,
        code = function()
            local multiple = GAME.multiplePiecesActive
            MSG.clear()
            STAT.easyName = not STAT.easyName
            SFX.play('social_dm')
            MSG('dark', "Easy Names In-Game: " .. (STAT.easyName and "ON" or "OFF"))
            GAME.multiplePiecesActive = false
            SaveStat()
            if multiple then GAME.multiplePiecesActive = true end
        end,
    },
    WIDGET.new { -- Stacker
        name = 'stacker', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "STACKER MODE",
        x = baseX + 500, y = baseY + 60 + 240,
        disp = function() return false end,
        code = function()
            local multiple = GAME.multiplePiecesActive
            MSG.clear()
            --[[STAT.imperial = not STAT.imperial
            SFX.play('social_dm')
            MSG('dark', "Imperial Units: " .. (STAT.imperial and "ON" or "OFF"))
            GAME.multiplePiecesActive = false
            SaveStat()
            if multiple then GAME.multiplePiecesActive = true end]]
            SFX.play('no')
            MSG('dark', "STACKER NOT IMPLEMENTED IN THIS VERSION OF THE GAME!")
        end,
    },
    -- MUSIC PLAYER OPTIONS
    WIDGET.new { -- Music Play
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
    WIDGET.new { -- BPM/Speed Button
        name = 'bpm', type = 'button', 
        x = baseX + 685, y = baseY + 60, w = 410, h = 70,
        color = clr.T,
        sound_hover = 'menutap',
        fontSize = 50, text = "", textColor = clr.LT,
        onClick = function()
            bpmMode = not bpmMode
        end,
    },
    WIDGET.new { -- Prev Track
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
                        if floor == 0 and scene.widgetList.reverse.disp() then mode = 'f0r' end
                        if floor == 1 and scene.widgetList.reverse.disp() then mode = 'f1r' end
                        PlayBGM('f' .. floor .. (scene.widgetList.reverse.disp() and 'r' or ''),true)
                    end
                else
                    PlayBGM('f10' .. (scene.widgetList.reverse.disp() and 'r' or ''),true)
                end
                MSG("bright", "Now Playing: " .. BgmPlaying .. ((mode == 'f1r' and floor == 1 or mode == 'f0r' and floor == 0) and 'r' or ''))
            else
                MSG("dark", "DISABLE TERASPEED FIRST!")
            end
            RefreshBGM(mode)
        end,
    },
    WIDGET.new { -- Next Track
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
                        if floor == 1 and scene.widgetList.reverse.disp() then mode = 'f1r' end
                        PlayBGM('f' .. floor .. (scene.widgetList.reverse.disp() and 'r' or ''),true)
                    end
                else
                    if scene.widgetList.reverse.disp() then mode = 'f0r' end
                    PlayBGM('f0',true)
                end
                MSG("bright", "Now Playing: " .. BgmPlaying .. ((mode == 'f1r' and floor == 1 or mode == 'f0r' and floor == 0) and 'r' or ''))
            else
                MSG("dark", "DISABLE TERASPEED FIRST!")
            end
            RefreshBGM(mode)
        end,
    },
    WIDGET.new { -- Teraspeed
        name = 'tera', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "TERASPEED",
        x = baseX + 40, y = baseY + 60 + 160,
        disp = function() return BgmPlaying:count('t') == 1 end,
        code = function()
            MSG.clear()
            TASK.removeTask_code(Task_MusicEnd)
            if BgmPlaying:count('t') == 1 then
                if scene.widgetList.reverse.disp() then
                    if lastNonTera == 'f0' then mode = 'f0r'
                    elseif lastNonTera == 'f1' then mode = 'f1r'
                    elseif lastNonTera ~= 'fomg' then lastNonTera = lastNonTera .. (lastNonTera:count('r') == 0 and 'r' or '')
                    end
                end
                PlayBGM(lastNonTera, true)
                MSG("bright", "Now Playing: " .. BgmPlaying .. ((mode == 'f1r' and BgmPlaying == 'f1' or mode == 'f0r' and BgmPlaying == 'f0') and 'r' or ''))
            else
                lastNonTera = BgmPlaying
                if BgmPlaying:count('r') == 1 then
                    PlayBGM('terar', true)
                else
                    PlayBGM('tera', true)
                end
                MSG("bright", "Now Playing: " .. BgmPlaying)
            end
            RefreshBGM(mode)
        end,
    },
    WIDGET.new { -- Reverse
        name = 'reverse', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "REVERSE",
        x = baseX + 500, y = baseY + 60 + 160,
        disp = function() return (BgmPlaying:count('t') == 0 and BgmPlaying:count('r') == 1) or BgmPlaying:count('r') == 2 or (mode == 'f0r' and BgmPlaying == 'f0' or mode == 'f1r' and BgmPlaying == 'f1') end,
        code = function()
            MSG.clear()
            TASK.removeTask_code(Task_MusicEnd)
            if (BgmPlaying:count('t') == 0 and BgmPlaying:count('r') == 1) or BgmPlaying:count('r') == 2 or (mode == 'f0r' and BgmPlaying == 'f0' or mode == 'f1r' and BgmPlaying == 'f1') then
                if BgmPlaying == 'terar' then
                    PlayBGM('tera', true)
                else
                    mode = ''
                    PlayBGM(BgmPlaying:gsub('r',''), true)
                end
                MSG("bright", "Now Playing: " .. BgmPlaying)
            else
                if BgmPlaying:count('t') == 1 then
                    PlayBGM('terar', true)
                elseif BgmPlaying ~= 'fomg' then
                    if BgmPlaying == 'f0' or BgmPlaying == 'f1' then mode = BgmPlaying .. 'r' end
                    PlayBGM(BgmPlaying .. (BgmPlaying:count('r') == 0 and 'r' or ''), true)
                else
                    MSG("dark", "CANNOT REVERSE fomg")
                end
                if BgmPlaying ~= 'fomg' then MSG("bright", "Now Playing: " .. BgmPlaying .. ((mode == 'f1r' and BgmPlaying == 'f1' or mode == 'f0r' and BgmPlaying == 'f0') and 'r' or '')) end
            end
            RefreshBGM(mode)
        end,
    },
    WIDGET.new { -- Uneasy
        name = 'uneasy', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "UNEASY (TERA & not REV)",
        x = baseX + 40, y = baseY + 60 + 240,
        disp = function() return BgmPlaying == 'teral' or BgmPlaying == 'terael' end,
        code = function()
            MSG.clear()
            TASK.removeTask_code(Task_MusicEnd)
            if BgmPlaying:count('t') == 0 then
                MSG("dark", "ENABLE TERASPEED FIRST!")
            elseif scene.widgetList.reverse.disp() then
                MSG("dark", "DISABLE REVERSE FIRST!")
            else
                if BgmPlaying == 'tera' then
                    PlayBGM('teral', force)
                elseif BgmPlaying == 'terae' then
                    PlayBGM('terael', force)
                elseif BgmPlaying == 'teral' then
                    PlayBGM('tera', force)
                elseif BgmPlaying == 'terael' then
                    PlayBGM('terae', force)
                end
                MSG("bright", "Now Playing: " .. BgmPlaying)
            end
            RefreshBGM(mode)
        end,
    },
    WIDGET.new { -- Smithy Mode
        name = 'smithyMode', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = clr.T, text = "SMITHY (TERA & not REV)",
        x = baseX + 500, y = baseY + 60 + 240,
        disp = function() return BgmPlaying == 'terae' or BgmPlaying == 'terael' end,
        code = function()
            MSG.clear()
            TASK.removeTask_code(Task_MusicEnd)
            if BgmPlaying:count('t') == 0 then
                MSG("dark", "ENABLE TERASPEED FIRST!")
            elseif scene.widgetList.reverse.disp() then
                MSG("dark", "DISABLE REVERSE FIRST!")
            else
                if BgmPlaying == 'tera' then
                    PlayBGM('terae', force)
                elseif BgmPlaying == 'terae' then
                    PlayBGM('tera', force)
                elseif BgmPlaying == 'teral' then
                    PlayBGM('terael', force)
                elseif BgmPlaying == 'terael' then
                    PlayBGM('teral', force)
                end
                MSG("bright", "Now Playing: " .. BgmPlaying)
            end
            RefreshBGM(mode)
        end,
    },
    -- PIECE EFFECTS
    WIDGET.new { -- pieces
        name = 'pieces',
        type = 'text', alignX = 'left',
        text = "PIECE EFFECTS",
        color = clr.T,
        fontSize = 50,
        x = baseX + 20, y = baseY + 370,
    },
    WIDGET.new { -- ez
        name = 'ez', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = COLOR.lR, text = "eZ - Nightcore+",
        x = baseX + 40, y = baseY + 50 + 400,
        disp = function() return GAME.enightcore end,
        code = function()
            MSG.clear()
            TASK.removeTask_code(Task_MusicEnd)
            if not GAME.enightcore and anyPieceActive() then 
                SFX.play('damage_alert')
                MSG('dark', "WARNING: MULTIPLE PIECES ENABLED DISABLES SCORING AND MAY CAUSE ISSUES. DO NOT REPORT!")
                GAME.multiplePiecesActive = true
            else
                SFX.play('social_dm')
            end
            GAME.enightcore = not GAME.enightcore
            MSG('dark', "eZ: " .. (GAME.enightcore and "ON" or "OFF"))
            RefreshBGM(mode)
        end,
    },
    WIDGET.new { -- es
        name = 'es', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = COLOR.lG, text = "eS - Slow-mo+",
        x = baseX + 500, y = baseY + 50 + 400,
        disp = function() return GAME.eslowmo end,
        code = function()
            MSG.clear()
            TASK.removeTask_code(Task_MusicEnd)
            if not GAME.eslowmo and anyPieceActive() then 
                SFX.play('damage_alert')
                MSG('dark', "WARNING: MULTIPLE PIECES ENABLED DISABLES SCORING AND MAY CAUSE ISSUES. DO NOT REPORT!")
                GAME.multiplePiecesActive = true
            else
                SFX.play('social_dm')
            end
            GAME.eslowmo = not GAME.eslowmo
            MSG('dark', "eS: " .. (GAME.eslowmo and "ON" or "OFF"))
            RefreshBGM(mode)
        end,
    },
    WIDGET.new { -- ej
        name = 'ej', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = COLOR.lB, text = "eJ - Glass Card+",
        x = baseX + 40, y = baseY + 50 + 480,
        disp = function() return GAME.eglassCard end,
        code = function()
            MSG.clear()
            TASK.removeTask_code(Task_MusicEnd)
            if not GAME.eglassCard and anyPieceActive() then 
                SFX.play('damage_alert')
                MSG('dark', "WARNING: MULTIPLE PIECES ENABLED DISABLES SCORING AND MAY CAUSE ISSUES. DO NOT REPORT!")
                GAME.multiplePiecesActive = true
            else
                SFX.play('social_dm')
            end
            GAME.eglassCard = not GAME.eglassCard
            MSG('dark', "eJ: " .. (GAME.eglassCard and "ON" or "OFF"))
            refreshWidgets()
        end,
    },
    WIDGET.new { -- el
        name = 'el', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = COLOR.lO, text = "eL - Slow Leak",
        x = baseX + 500, y = baseY + 50 + 480,
        disp = function() return GAME.efastLeak end,
        code = function()
            MSG.clear()
            TASK.removeTask_code(Task_MusicEnd)
            if not GAME.efastLeak and anyPieceActive() then 
                SFX.play('damage_alert')
                MSG('dark', "WARNING: MULTIPLE PIECES ENABLED DISABLES SCORING AND MAY CAUSE ISSUES. DO NOT REPORT!")
                GAME.multiplePiecesActive = true
            else
                SFX.play('social_dm')
            end
            GAME.efastLeak = not GAME.efastLeak
            MSG('dark', "eL: " .. (GAME.efastLeak and "ON" or "OFF"))
        end,
    },
    WIDGET.new { -- eT
        name = 'et', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = COLOR.lM, text = "eT - Transparent UI",
        x = baseX + 40, y = baseY + 50 + 560,
        disp = function() return GAME.einvisUI end,
        code = function()
            MSG.clear()
            TASK.removeTask_code(Task_MusicEnd)
            if not GAME.einvisUI and anyPieceActive() then 
                SFX.play('damage_alert')
                MSG('dark', "WARNING: MULTIPLE PIECES ENABLED DISABLES SCORING AND MAY CAUSE ISSUES. DO NOT REPORT!")
                GAME.multiplePiecesActive = true
            else
                SFX.play('social_dm')
            end
            GAME.einvisUI = not GAME.einvisUI
            MSG('dark', "eT: " .. (GAME.einvisUI and "ON" or "OFF"))
        end,
    },
    WIDGET.new { -- eo
        name = 'eo', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = COLOR.lY, text = "eO - Transparent Card",
        x = baseX + 500, y = baseY + 50 + 560,
        disp = function() return GAME.einvisCard end,
        code = function()
            MSG.clear()
            TASK.removeTask_code(Task_MusicEnd)
            if not GAME.einvisCard and anyPieceActive() then 
                SFX.play('damage_alert')
                MSG('dark', "WARNING: MULTIPLE PIECES ENABLED DISABLES SCORING AND MAY CAUSE ISSUES. DO NOT REPORT!")
                GAME.multiplePiecesActive = true
            else
                SFX.play('social_dm')
            end
            GAME.einvisCard = not GAME.einvisCard
            MSG('dark', "eO: " .. (GAME.einvisCard and "ON" or "OFF"))
        end,
    },
    WIDGET.new { -- ei
        name = 'ei', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = COLOR.lC, text = "eI - Closer Card",
        x = baseX + 40, y = baseY + 50 + 640,
        disp = function() return GAME.ecloseCard end,
        code = function()
            MSG.clear()
            TASK.removeTask_code(Task_MusicEnd)
            if not GAME.ecloseCard and anyPieceActive() then 
                SFX.play('damage_alert')
                MSG('dark', "WARNING: MULTIPLE PIECES ENABLED DISABLES SCORING AND MAY CAUSE ISSUES. DO NOT REPORT!")
                GAME.multiplePiecesActive = true
            else
                SFX.play('social_dm')
            end
            GAME.ecloseCard = not GAME.ecloseCard
            MSG('dark', "eI: " .. (GAME.ecloseCard and "ON" or "OFF"))
            refreshWidgets()  
        end,
    },
    WIDGET.new { -- urm
        name = 'urm', type = 'checkBox',
        fillColor = clr.cbFill,
        frameColor = clr.cbFrame,
        textColor = COLOR.R, text = "Ultra Reverse",
        x = baseX + 500, y = baseY + 50 + 640,
        disp = function() return URM end,
        code = function()
            URM = not URM
            SFX.play(URM and 'exchange' or 'undo')
            GAME.hardMode = GAME.mod.EX > 0 or GAME.anyRev and not URM
            GAME.refreshLayout()
            GAME.refreshUltra()
            GAME.refreshCurrentCombo()
            GAME.refreshPBText()
            RefreshBGM()
            GAME.refreshRPC()
            RefreshHelpText()
        end,
    },
    WIDGET.new { -- Clear Button
        name = 'clear', type = 'button', 
        x = baseX + 220, y = baseY + 60 + 720, w = 410, h = 70,
        color = clr.T,
        sound_hover = 'menutap',
        fontSize = 50, text = "CLEAR PIECES", textColor = clr.LT,
        onClick = function()
            if anyPieceActive() or URM then
                SFX.play('allclear')
                MSG('dark', 'All Clear')
            else
                SFX.play('no')
            end
            URM = false
            GAME.nightcore = false
            GAME.slowmo = false
            GAME.glassCard = false
            GAME.fastLeak = false
            GAME.invisUI = false
            GAME.invisCard = false
            GAME.closeCard = false
            GAME.enightcore = false
            GAME.eslowmo = false
            GAME.eglassCard = false
            GAME.efastLeak = false
            GAME.einvisUI = false
            GAME.einvisCard = false
            GAME.ecloseCard = false
            GAME.multiplePiecesActive = false
            PieceSFXID = 15
            RefreshBGM()
            refreshWidgets()
        end,
    },
    WIDGET.new { -- normal piece button
        name = 'help2', type = 'button', 
        x = baseX + 685, y = baseY + 60 + 720, w = 410, h = 70,
        color = clr.T,
        sound_hover = 'menutap',
        fontSize = 50, text = "CYCLE PIECES", textColor = clr.LT,
        onClick = function()
            PieceSFXID = (PieceSFXID or 0) % 15 + 1
            if PieceSFXID <= 14 then
                local piece = ('zsjltoi'):sub(PieceSFXID, PieceSFXID)
                SFX.play(piece, 1, 0, Tone(6))
                if PieceSFXID > 7 then
                    SFX.play('combo_'..(PieceSFXID - 7)..'_power', 1, 0, Tone(0))
                end
            else
                SFX.play('allclear')
            end

            --for i = 1, 7 do
            -- Trevor Smithy
            for i = 1, 14 do
                GAME[PieceData[i].id] = PieceSFXID == i
            end

            GAME.refreshLayout()
            RefreshBGM()
            GAME.refreshRPC()
            -- Trevor Smithy
            GAME.refreshCurrentCombo()
            GAME.multiplePiecesActive = false
            MSG({
                cat = 'dark',
                str = PieceData[PieceSFXID].popup,
                time = 1.2
            })
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
