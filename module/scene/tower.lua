local next = next
local max, min = math.max, math.min
local sin, cos = math.sin, math.cos
local floor, abs = math.floor, math.abs

local distance, clamp = MATH.distance, MATH.clamp
local interpolate, clampInterpolate = MATH.interpolate, MATH.clampInterpolate
local lerp, iLerp, cLerp, icLerp, lLerp = MATH.lerp, MATH.iLerp, MATH.cLerp, MATH.icLerp, MATH.lLerp

local GAME = GAME
local M = GAME.mod
local MD = ModData
ShortCut = {}
local ShortCut = ShortCut
for i = 1, #MD.deck do ShortCut[i] = GC.newText(FONT.get(50)) end

HoldingButtons = {}
local HoldingButtons = HoldingButtons

URM = false
RevUnlocked = false
UsingTouch = MOBILE
local usingTouch = UsingTouch
local revHold = {}

---@type Zenitha.Scene
local scene = {}

local function switchVisitor(bool)
    if not GAME.playing and GAME.zenithTraveler ~= bool and STAT.bg then
        SFX.play(bool and 'pause_exit' or 'pause_start', 1, 0, Tone(-2))
        GAME.zenithTraveler = bool
        love.mouse.setRelativeMode(bool)
        ZENITHA._cursor.active = not bool
        for _, W in next, scene.widgetList do W:setVisible(not bool) end
        if usingTouch then scene.widgetList.help:setVisible(true) end
        if bool then IssueAchv('zenith_traveler') end
        TABLE.clear(HoldingButtons)
    end
end

local function MouseOnCard(x, y)
    if FloatOnCard and Cards[FloatOnCard]:mouseOn(x, y) then
        return FloatOnCard
    end
    if FloatOnCard and not usingTouch or STAT.oldHitbox then
        local cid, dist = 0, 1e99
        for i = 1, #Cards do
            if Cards[i]:mouseOn(x, y) then
                local dist2 = distance(x, y, Cards[i].x, Cards[i].y)
                if dist2 < dist then
                    dist = dist2
                    cid = i
                end
            end
        end
        if cid > 0 then return cid end
    else
        for i = 1, #Cards do
            if Cards[i]:mouseOn(x, y) then
                return i
            end
        end
    end
end

function SetMouseVisible(bool)
    if STAT.syscursor then
        love.mouse.setVisible(bool)
    else
        CursorHide = not bool
    end
end

local function mouseMove(x, y)
    SetMouseVisible(true)
    MX, MY = x, y
    local new = MouseOnCard(x, y)
    if FloatOnCard ~= new then
        FloatOnCard = new
        if new then
            SFX.play('card_slide_' .. math.random(4), .626)
        end
        GAME.refreshLayout()
    end
end

local function mouseTrigger(x, y, k)
    SetMouseVisible(true)
    mouseMove(x, y)
    local C = Cards[FloatOnCard]
    if C then
        if GAME.playing or not C.lock then
            C:setActive(false, k)
        else
            C:flick()
            SFX.play('no')
        end
    end
end

local function keyTrigger(key)
    local bindID = TABLE.find(STAT.keybind, key)
    if bindID and bindID <= 18 and (M.AS > 0 or (not GAME.playing and (bindID == 8 or bindID == 17))) then
        if bindID > 9 then bindID = bindID - 9 end
        local C = Cards[bindID]
        if C then
            if GAME.playing or not C.lock then
                GAME.nixPrompt('keep_no_keyboard')
                FloatOnCard = bindID
                SetMouseVisible(false)
                MX, MY = C.x + math.random(-126, 126), C.y + math.random(-260, 260)
                C:setActive()
                GAME.refreshLayout()
            else
                C:flick()
                SFX.play('no')
            end
            if not GAME.achv_noKeyboardH then GAME.achv_noKeyboardH = GAME.roundHeight end
        end
    else
        if key == 'escape' then
            if not GAME.playing then
                local W = scene.widgetList.back
                W._pressTime = W._pressTimeMax * 2
                W._hoverTime = W._hoverTimeMax
                if TASK.lock('sure_quit', 2.6) then
                    SFX.play('menuclick')
                    MSG('dark', "PRESS AGAIN TO QUIT", 2.6)
                else
                    SFX.play('menuback')
                    BGM.set('all', 'volume', 0, 1.6)
                    SCN.back()
                end
            end
        elseif bindID == 20 then
            GAME.nixPrompt('keep_no_keyboard')
            local W = scene.widgetList.reset
            W._pressTime = W._pressTimeMax * 2
            W._hoverTime = W._hoverTimeMax
            SFX.play('menuclick')
            if M.AS == 0 then GAME.nixPrompt('keep_no_reset') end
            GAME.cancelAll()
            if not GAME.achv_noKeyboardH then GAME.achv_noKeyboardH = GAME.roundHeight end
        elseif bindID == 21 or bindID == 22 then
            GAME.nixPrompt('keep_no_keyboard')
            scene.mouseDown(MX, MY, bindID == 21 and 1 or 2)
            scene.mouseUp(MX, MY, bindID == 21 and 1 or 2)
            if not GAME.achv_noKeyboardH then GAME.achv_noKeyboardH = GAME.roundHeight end
        elseif bindID == 19 then
            GAME.nixPrompt('keep_no_keyboard')
            local W = scene.widgetList.start
            W._pressTime = W._pressTimeMax * 2
            W._hoverTime = W._hoverTimeMax
            if GAME.playing then
                GAME.commit()
                if not GAME.achv_noManualCommitH then GAME.achv_noManualCommitH = GAME.roundHeight end
                if not GAME.achv_noKeyboardH then GAME.achv_noKeyboardH = GAME.roundHeight end
            else
                GAME.start()
            end
        elseif key == '`' then
            if GAME.playing then
                SFX.play('no')
            else
                if URM and M.VL == 2 and not UltraVlCheck('stat') then return end
                SFX.play('menuhit1')
                SCN.go('stat', 'none')
            end
            local W = scene.widgetList.stat
            W._pressTime = W._pressTimeMax * 2
            W._hoverTime = W._hoverTimeMax
        elseif key == 'tab' then
            if GAME.playing then
                SFX.play('no')
            else
                if URM and M.VL == 2 and not UltraVlCheck('achv') then return end
                SFX.play('menuhit1')
                SCN.go('achv', 'none')
            end
            local W = scene.widgetList.achv
            W._pressTime = W._pressTimeMax * 2
            W._hoverTime = W._hoverTimeMax
        elseif key == 'f1' then
            if GAME.playing then
                SFX.play('no')
            else
                if URM and M.VL == 2 and not UltraVlCheck('conf') then return end
                SFX.play('menuhit1')
                SCN.go('conf', 'none')
            end
            local W = scene.widgetList.conf
            W._pressTime = W._pressTimeMax * 2
            W._hoverTime = W._hoverTimeMax
        elseif key == 'f2' then
            if GAME.playing then
                SFX.play('no')
            else
                if URM and M.VL == 2 and not UltraVlCheck('reset') then return end
                SFX.play('menuhit1')
                SCN.go('about', 'none')
            end
            local W = scene.widgetList.about
            W._pressTime = W._pressTimeMax * 2
            W._hoverTime = W._hoverTimeMax
        end
    end
end

local function ultraStateChange()
    GAME.hardMode = M.EX > 0 or GAME.anyRev and not URM
    GAME.refreshLayout()
    GAME.refreshUltra()
    GAME.refreshCurrentCombo()
    GAME.refreshPBText()
    RefreshBGM()
    GAME.refreshRPC()
    RefreshHelpText()
end

local function applyCombo(set)
    local changed
    for _, C in ipairs(Cards) do
        local cur = C.active and (C.upright and 1 or 2) or 0
        local tar = TABLE.find(set, C.id) and 1 or TABLE.find(set, 'r' .. C.id) and 2 or 0
        if cur ~= tar then
            if cur > 0 then C:setActive(true) end
            if tar > 0 then C:setActive(true, tar == 2 and 2 or 1) end
            changed = true
        end
    end
    if set.ultra ~= nil and set.ultra ~= URM then
        URM = set.ultra
        ultraStateChange()
    end
    if changed then SFX.play('mmstart') end
end

function scene.load()
    if SYSTEM == 'Web' and TASK.lock('web_warn') then
        MSG('warn',
            "[WARNING]\nThe web version is for trial purposes only.\nPlease note that your progress may be lost without warning, and this cannot be fixed.\nDownload the desktop version to keep playing in the future, with far better performance.\nThank you for your support!",
            12.6)
    end
    RevUnlocked = TABLE.countAll(GAME.completion, 0) < 9

    for i = 1, #MD.deck do ShortCut[i]:set(STAT.keybind[i]:upper()) end

    GAME.refreshDailyChallengeText()
    TASK.unlock('sure_quit')
    ZENITHA.setAppInfo("Zenith Clicker")

    if PendingComboFromRecord then
        applyCombo(PendingComboFromRecord)
        PendingComboFromRecord = nil
    end
end

function scene.unload()
    MSG.clear()
    TEXT:clear()
    ZENITHA.setAppInfo("Zenith Clicker", SYSTEM .. " " .. (require 'version'.appVer))
end

function scene.mouseMove(x, y, _, dy)
    if GAME.zenithTraveler then
        GAME.height = clamp(GAME.height +
            dy / 260 *
            (M.VL + 1) *
            (M.EX > 0 and 2.6 or 6.2) *
            (M.AS > 0 and -1 or 1), 0,
            STAT.maxHeight
        )
    else
        GAME.nixPrompt('keep_no_mouse')
        mouseMove(x, y)
    end
end

local msIsDown = love.mouse.isDown
local kbIsDown = love.keyboard.isDown
local function getBtnPressed()
    local btnPressed = 0
    if msIsDown(1) then btnPressed = btnPressed + 1 end
    if msIsDown(2) then btnPressed = btnPressed + 1 end
    if msIsDown(4) then btnPressed = btnPressed + 1 end
    if msIsDown(5) then btnPressed = btnPressed + 1 end
    if msIsDown(6) then btnPressed = btnPressed + 1 end
    if kbIsDown(STAT.keybind[21]) then btnPressed = btnPressed + 1 end
    if kbIsDown(STAT.keybind[22]) then btnPressed = btnPressed + 1 end
    return btnPressed
end

function scene.mouseDown(x, y, k)
    if k > 3 then return end
    if usingTouch and k == 1 then
        usingTouch = false
        UsingTouch = false
    end
    if GAME.zenithTraveler then
        switchVisitor(false)
        return true
    end
    if k == 3 then return true end
    HoldingButtons['mouse' .. k] = true
    GAME.nixPrompt('keep_no_mouse')

    if getBtnPressed() > 1 + (URM and M.VL == 2 and 0 or floor(M.VL / 2)) then return true end
    if M.EX == 0 then
        SFX.play('move')
        mouseTrigger(x, y, k)
    else
        SFX.play('rotate')
    end
end

function scene.mouseUp(x, y, k)
    if k > 3 then return end
    if not HoldingButtons['mouse' .. k] then return end
    HoldingButtons['mouse' .. k] = nil
    if GAME.zenithTraveler then return end
    GAME.nixPrompt('keep_no_mouse')
    if k == 3 then return end

    if getBtnPressed() > (URM and M.VL == 2 and 0 or floor(M.VL / 2)) then return end
    if M.EX > 0 then
        mouseTrigger(x, y, k)
    end
end

function scene.wheelMove(_, dy)
    if GAME.zenithTraveler and M.NH < 2 then
        GAME.height = clamp(GAME.height -
            dy *
            (M.VL + 1) *
            (M.EX > 0 and 2.6 or 6.2) *
            (M.AS > 0 and -1 or 1), 0,
            STAT.maxHeight
        )
    end
end

function scene.touchMove(x, y, dx, dy) scene.mouseMove(x, y, dx, dy) end

function scene.touchDown(x, y, id)
    if not usingTouch then
        usingTouch = true
        UsingTouch = true
    end
    if GAME.zenithTraveler then return end
    local x1, y1 = SCR.xOy_dl:inverseTransformPoint(SCR.xOy:transformPoint(x, y))
    if not GAME.playing and x1 <= 200 and MATH.between(y1, -600, -40) then
        revHold[id] = true
        return
    end

    HoldingButtons['touch' .. tostring(id)] = true
    if M.EX == 0 then
        SFX.play('move')
        mouseTrigger(x, y, next(revHold) and 2 or 1)
    else
        SFX.play('rotate')
        -- scene.mouseMove(x, y, 0, 0)
    end
end

function scene.touchUp(x, y, id)
    if revHold[id] then
        revHold[id] = nil
        return
    end
    if not HoldingButtons['touch' .. tostring(id)] then return end
    HoldingButtons['touch' .. tostring(id)] = nil
    if M.EX > 0 then
        mouseTrigger(x, y, next(revHold) and 2 or 1)
    end
end

-- Test
-- scene.mouseDown=scene.touchDown
-- scene.mouseUp=scene.touchUp

local KBisDown = love.keyboard.isDown
function scene.keyDown(key)
    HoldingButtons[key] = true
    if GAME.zenithTraveler then
        if key == 'escape' or key == '\\' or key == 'space' then
            switchVisitor(false)
        elseif KBisDown('lctrl', 'rctrl') and key:match('^f%d%d?$') and tonumber(key:match('%d+')) <= 10 then
            local floor = tonumber(key:sub(2))
            GAME.height = Floors[floor - 1].top
            if floor == 10 then GAME.height = GAME.height + 6.26 end
        end
    else
        if M.EX == 0 then
            SFX.play('move')
            keyTrigger(key)
        else
            SFX.play('rotate')
        end
        ZENITHA._cursor.active = true
    end
    return true
end

function scene.keyUp(key)
    if not HoldingButtons[key] then return end
    HoldingButtons[key] = nil
    if GAME.zenithTraveler then return end
    if M.EX > 0 then
        keyTrigger(key)
    end
end

local KBIsDown, MSIsDown = love.keyboard.isDown, love.mouse.isDown
local expApproach = MATH.expApproach
function scene.update(dt)
    if kbIsDown('left', 'right', 'up', 'down') then
        local spd = ZENITHA._cursor.speed * dt * (kbIsDown('lctrl', 'rctrl') and .6 or 1)
        if kbIsDown('left') then MX = MX - spd end
        if kbIsDown('right') then MX = MX + spd end
        if kbIsDown('up') then MY = MY - spd end
        if kbIsDown('down') then MY = MY + spd end
        ZENITHA.setCursorPos(MX, MY)
    end
    if GAME.nightcore then dt = dt * 2.6 end
    if GAME.zenithTraveler and M.EX == 2 then
        local f = GAME.calculateFloor(GAME.bgH)
        GAME.height = max(GAME.height - dt * (f * (f + 1) + 10) * (M.VL + 1), 0)
    end
    if dt > .26 then dt = .26 end
    GAME.update(dt)
    GAME.lifeShow = expApproach(GAME.lifeShow, GAME.life, dt * 10)
    GAME.lifeShow2 = expApproach(GAME.lifeShow2, GAME.life2, dt * 10)
    GAME.bgH = expApproach(GAME.bgH, GAME.height, dt * 2.6)
    if DeckPress > 0 then
        DeckPress = DeckPress - dt
    end
    for i = #ImpactGlow, 1, -1 do
        local L = ImpactGlow[i]
        L.t = L.t - dt
        if L.t <= 0 then
            table.remove(ImpactGlow, i)
        end
    end

    StarPS:moveTo(0, -GAME.bgH * 2 * BgScale)
    StarPS:update(dt)
    if GAME.chain >= 4 then
        WoundPS:update(dt)
        for i = 1, 3 do SparkPS[i]:update(dt) end
    end

    for i = 1, #Cards do
        Cards[i]:update(GAME.slowmo and dt / 6.26 or dt)
    end
    if GAME.playing and (KBIsDown('escape') or MSIsDown(3)) then
        GAME.forfeitTimer = GAME.forfeitTimer +
            (GAME.slowmo and dt / 6.26 or dt) * clampInterpolate(12, 2.6, 26, 1, min(GAME.totalQuest, GAME.time))
        if TASK.lock('forfeit_sfx', .0872) then
            SFX.play('detonate1', clampInterpolate(0, .4, 1, .6, GAME.forfeitTimer))
        end
        if GAME.forfeitTimer > 1 then
            SFX.play('detonate2')
            GAME.finish('forfeit')
        end
    else
        if GAME.forfeitTimer > 0 then
            GAME.forfeitTimer = GAME.forfeitTimer - (GAME.playing and 1 or 2.6) * (GAME.slowmo and dt / 6.26 or dt)
        end
    end

    if not GAME.playing and TASK.lock('dcTimer', 1) then
        local timeRemain = 86400 - (3600 * os.date("!%H") + 60 * os.date("!%M") + os.date("!%S"))
        if timeRemain < 0 then
            RefreshDaily()
            GAME.refreshDailyChallengeText()
            timeRemain = timeRemain + 86400
        end
        TEXTS.dcTimer:set(os.date("!%H:%M:%S", timeRemain))
    end
end

ValentineTextColor = { 1, .6, .8 }
ValentineShadeColor = { .45, .3, .45 }
BaseTextColor = { .7, .5, .3 }
BaseShadeColor = { .3, .15, 0 }
TextColor, ShadeColor, ComboColor = {}, {}, {}
local rankColor = {
    [0] = { 1, 1, 1, .26 },
    { 1,  .1, 0 },
    { 1,  .7, 0 },
    { .5, 1,  0 },
    { 0,  .7, 1 },
    { 1,  .1, 1 },
    { 1,  .8, .5 },
    { .6, 1,  .8 },
    { .4, .9, 1 },
    { 1,  .7, 1 },
}
local floorColors = TABLE.transpose {
    { COLOR.HEX '792B12' }, -- F1
    { COLOR.HEX '98773E' }, -- F2
    { COLOR.HEX '56320C' }, -- F3
    { COLOR.HEX '993019' }, -- F4
    { COLOR.HEX '818A8A' }, -- F5
    { COLOR.HEX 'C86A3C' }, -- F6
    { COLOR.HEX '196FA3' }, -- F7
    { COLOR.HEX '9B212D' }, -- F8
    { COLOR.HEX '0B5D38' }, -- F9
    { COLOR.HEX '130031' }, -- F10
}
local f10colors = TABLE.transpose {
    { .9, .3, .9 }, -- 1650 m
    { .6, .3, .8 }, -- 1756.25 m
    { .4, .2, .7 }, -- 1862.5 m
    { .2, .5, .7 }, -- 1968.75 m
    { .4, .6, .4 }, -- 2075 m
    { 1,  0,  .5 }, -- 2181.25 m
    { 1,  0,  .6 }, -- 2287.5 m
    { .8, 0,  1 },  -- 2393.75 m
    { .0, .0, 1 },  -- 2500 m
}
local gc = love.graphics
local gc_push, gc_pop = gc.push, gc.pop
local gc_replaceTransform = gc.replaceTransform
local gc_translate, gc_scale, gc_rotate, gc_shear = gc.translate, gc.scale, gc.rotate, gc.shear
local gc_setColor, gc_setLineWidth, gc_setBlendMode = gc.setColor, gc.setLineWidth, gc.setBlendMode
local gc_draw = gc.draw
local gc_line, gc_rectangle, gc_circle, gc_arc = gc.line, gc.rectangle, gc.circle, gc.arc
local gc_mRect, gc_mDraw, gc_mDrawQ, gc_strokeDraw = GC.mRect, GC.mDraw, GC.mDrawQ, GC.strokeDraw
local gc_setAlpha, gc_move, gc_back = GC.setAlpha, GC.ucs_move, GC.ucs_back
local gc_blurCircle, gc_strokePrint = GC.blurCircle, GC.strokePrint
local gc_setColorMask = GC.setColorMask
local setFont = FONT.set

local chargeIcon = GC.load {
    w = 512, h = 512,
    { 'move',   256,  256 },
    { 'fCirc',  0,    0,  180, 4 },
    { 'rotate', .5236 },
    { 'fCirc',  0,    0,  180, 4 },
    { 'rotate', .5236 },
    { 'fCirc',  0,    0,  180, 4 },
}

local TEXTURE = TEXTURE
local Cards = Cards
local TextColor = TextColor
local ShadeColor = ShadeColor
local bgQuad = GC.newQuad(0, 0, 0, 0, 0, 0)
local rulerQuad = GC.newQuad(0, 0, 32, 300, TEXTURE.ruler)
local reviveQuad = {
    GC.newQuad(0, 0, 1042, 296, TEXTURE.revive.norm),
    GC.newQuad(0, 355, 1042, 342, TEXTURE.revive.norm),
    GC.newQuad(0, 740, 1042, 354, TEXTURE.revive.norm),
}
local reviveMove = { -155, -147, -154 }
local reviveRot = { -.095, .15, -.17 }

function DrawBG(brightness, showRuler)
    gc_replaceTransform(SCR.origin)
    if GAME.bgH > -50 then
        local bgFloor = GAME.calculateFloor(GAME.bgH)
        if STAT.bg and not GAME.invisUI then
            if bgFloor < 10 then
                gc_setColor(1, 1, 1)
                local bottom = Floors[bgFloor - 1].top
                local top = Floors[bgFloor].top
                local bg = TEXTURE.towerBG[bgFloor]
                local w, h = bg:getDimensions()
                local quadStartH = interpolate(bottom, h, top, 0, GAME.bgH) - 640
                bgQuad:setViewport(GAME.bgX, quadStartH, 1024, 640, w, h)
                gc_mDrawQ(bg, bgQuad, SCR.w / 2, SCR.h / 2, 0, BgScale)
                if bgFloor == 9 then
                    if GAME.bgH > 1562 then
                        gc_setColor(.5, .5, .5, interpolate(1562, 0, 1650, 1, GAME.bgH))
                        gc_rectangle('fill', 0, 0, SCR.w, SCR.h)
                    end
                elseif quadStartH < 0 then
                    bg = TEXTURE.towerBG[bgFloor + 1]
                    w, h = bg:getDimensions()
                    bgQuad:setViewport(GAME.bgX, h - 640, 1024, 640, w, h)
                    gc_mDrawQ(bg, bgQuad, SCR.w / 2, SCR.h * interpolate(0, -.5, -640, .5, quadStartH), 0, BgScale)
                end
            else
                -- Space color
                if GAME.bgH < 2500 then
                    -- Top
                    if GAME.bgH < 1900 then
                        gc_setColor(0, 0, interpolate(1650, .2, 1900, 0, GAME.bgH))
                        gc_rectangle('fill', 0, 0, SCR.w, SCR.h)
                    end

                    -- Bottom
                    local t = iLerp(1650, 2500, GAME.bgH)
                    gc_setColor(
                        lLerp(f10colors[1], t),
                        lLerp(f10colors[2], t),
                        lLerp(f10colors[3], t),
                        .626 * (1 - t)
                    )
                    gc_draw(TEXTURE.transition, 0, SCR.h, -1.5708, SCR.h / 128, SCR.w)
                elseif ComboColor[1] then
                    -- Vacuum
                    local t = GAME.time % 1
                    gc_setColor(
                        lLerp(ComboColor[1], t),
                        lLerp(ComboColor[2], t),
                        lLerp(ComboColor[3], t),
                        icLerp(2500, 6200, GAME.bgH) * .355
                    )
                    gc_rectangle('fill', 0, 0, SCR.w, SCR.h)
                end

                -- Bodies
                gc_setBlendMode('add')
                gc_setColor(1, 1, 1, .8)
                gc_draw(StarPS, SCR.w / 2, SCR.h / 2 + GAME.bgH * 2 * BgScale)
                gc_mDraw(TEXTURE.moon, SCR.w / 2, SCR.h / 2 + (GAME.bgH - 2202.84) * 2 * BgScale, 0, .2 * BgScale)
                gc_setBlendMode('alpha')

                -- Tower
                if GAME.bgH < 1700 then
                    gc_setColor(1, 1, 1)
                    local bg = TEXTURE.towerBG[10]
                    local w, h = bg:getDimensions()
                    local quadStartH = interpolate(1650, h, 1700, 0, GAME.bgH) - 640
                    bgQuad:setViewport(0, quadStartH, 1024, 640, w, h)
                    gc_mDrawQ(bg, bgQuad, SCR.w / 2, SCR.h / 2, 0, BgScale)
                end

                -- Cover
                local f10CoverAlpha = GAME.zenithTraveler and icLerp(1660, 1650, GAME.bgH) or 1 - GAME.floorTime / 2.6
                if f10CoverAlpha > 0 then
                    gc_setColor(.5, .5, .5, f10CoverAlpha)
                    gc_rectangle('fill', 0, 0, SCR.w, SCR.h)
                end
            end
        else
            local top = Floors[bgFloor].top
            local t = icLerp(1, 10, bgFloor + clampInterpolate(top - 50, 0, top, 1, GAME.bgH))
            gc_setColor(
                lLerp(floorColors[1], t),
                lLerp(floorColors[2], t),
                lLerp(floorColors[3], t)
            )
            gc_rectangle('fill', 0, 0, SCR.w, SCR.h)
        end
    end

    -- Brightness cover
    gc_setColor(0, 0, 0, 1 - (GAME.gigaspeed and (.7 + GigaSpeed.bgAlpha * .6) or 1) * brightness / 100)
    gc_rectangle('fill', 0, 0, SCR.w, SCR.h)

    -- Ruler
    if showRuler and GAME.bgH < 1700 and not GAME.invisUI then
        gc_replaceTransform(SCR.xOy_m)
        gc_setBlendMode('add')
        gc_setColor(1, 1, 1, GAME.bgH <= 1650 and .626 or .626 * (1700 - GAME.bgH) / 50 * brightness / 100)
        rulerQuad:setViewport(0, 150 - 300 / 25 * GAME.bgH, 32, 300, 32, 300)
        gc_mDrawQ(TEXTURE.ruler, rulerQuad, 0, 0, 0, 4, 4)
        gc_setBlendMode('alpha')
    end

    -- Display altitude (Debug)
    -- gc_setColor(1, 1, 1)
    -- gc.print(floor(GAME.bgH), 10, 10, 0, 2.6)
end

local function drawPBline(h, pb, spd, textObj)
    gc_replaceTransform(SCR.xOy_r)

    local obj = textObj or TEXTS.linePB
    local y = (spd or 32.6) * (GAME.bgH - h)

    -- Text
    local ox, oy = obj:getWidth() + 6, obj:getHeight() / 2
    gc_setColor(0, 0, 0, .62)
    gc_strokeDraw('full', 2, obj, 0, y, 0, 1.26, 1.26, ox, oy)
    if pb then
        local over = clampInterpolate(-6, 0, 10, 1, GAME.bgH - h)
        gc_setColor(1, .8 + over * .2, over * 1, 1 - over * .626)
    else
        gc_setColor(COLOR.lD)
    end
    gc_draw(obj, 0, y, 0, 1.26, 1.26, ox, oy)

    -- Line
    gc_rectangle('fill', -1.26 * (obj:getWidth() + 12), y - 2, -2600, 4)
end

function scene.draw()
    local t = love.timer.getTime()
    if GAME.zenithTraveler then
        DrawBG(100, true)
        drawPBline(STAT.maxHeight, true)
        return
    else
        DrawBG(STAT.bgBrightness, true)
    end

    if not GAME.invisUI then
        -- Wind Particles
        if GAME.height <= 1650 then
            gc_replaceTransform(SCR.origin)
            local dh = GAME.bgH - GAME.bgLastH
            GAME.bgLastH = GAME.bgH
            for i = 1, 62 do
                local w = Wind[i]
                w[2] = w[2] + dh / w[3] / 42
                if w[2] < 0 or w[2] > 1 then
                    w[1], w[2] = math.random(), w[2] % 1
                end
                WindBatch:set(i, w[1] * SCR.w, (w[2] * 1.2 - .1) * SCR.h, 0, 5, (-6 - dh * 260) / w[3] * SCR.k, .5, 0)
            end
            gc_setColor(1, 1, 1, GAME.uiHide *
                clamp((GAME.rank - 2) / 6, .26, 1) * .26 *
                cLerp(.62, 1, abs(dh * 26))
            )
            gc_draw(WindBatch)
        end

        -- PB Line
        drawPBline(GAME.prevPB, true)

        -- KM Line
        if GAME.floor >= 10 then
            gc_setColor(1, 1, 1, GAME.uiHide)
            drawPBline(MATH.roundUnit(GAME.bgH, 1000), false, 6, TEXTS.lineKM)
        end

        local panelH = 697 + GAME.uiHide * (420 + GAME.height / 6.2)

        -- GigaSpeed BG
        if GigaSpeed.alpha > 0 then
            local gigaPower = (1 - clamp((GAME.time - (GAME.gigaspeedEntered or GAME.time) - 120) / 180, 0, 1)) ^ 1.5
            if gigaPower > 0 then
                gc_replaceTransform(SCR.origin)
                gc_setColor(GigaSpeed.r, GigaSpeed.g, GigaSpeed.b, .42 * GigaSpeed.alpha * gigaPower)
                local h1 = SCR.y + 470 * SCR.k
                gc_draw(TEXTURE.transition, 0, 0, 0, .42 / 128 * SCR.w, h1)
                gc_draw(TEXTURE.transition, SCR.w, 0, 0, -.42 / 128 * SCR.w, h1)

                gc_replaceTransform(SCR.xOy)
                gc_setAlpha(GigaSpeed.alpha * gigaPower)
                gc_draw(TEXTURE.transition, 800 - 1586 / 2, panelH - 303, 1.5708, 26, 1586, 0, 1)
            end
        end

        gc_replaceTransform(SCR.xOy)

        -- Mod icons
        if GAME.uiHide > 0 then
            gc_setColor(1, 1, 1, GAME.uiHide * (M.IN == 0 and 1 or 1 - M.IN * (.26 + .1 * sin(t * 2.6))))
            local y = 330 + (GAME.height - GAME.bgH) * (M.VL + 1)
            if GAME.anyRev then
                local r = (M.AS + 1) * .026
                gc_setColorMask(false, false, true, true)
                gc_draw(GAME.modIB, 1490 + 2.0 * sin(t * 1.5), y + .5 * 2.0 * sin(t * 2.5), r * sin(t * 0.5), 1)
                gc_setColorMask(false, true, false, true)
                gc_draw(GAME.modIB, 1490 + 2.6 * sin(t * 1.6), y + .5 * 2.6 * sin(t * 2.6), r * sin(t * 0.6), 1)
                gc_setColorMask(true, false, false, true)
                gc_draw(GAME.modIB, 1490 + 2.6 * sin(t * 1.7), y + .5 * 2.6 * sin(t * 2.7), r * sin(t * 0.7), 1)
                gc_setColorMask()
            else
                gc_draw(GAME.modIB, 1490, y, M.AS * .026 * sin(t), 1)
            end
        end

        -- Card Panel
        gc_replaceTransform(SCR.xOy)
        gc_translate(0, DeckPress)
        gc_setColor(ShadeColor)
        gc_draw(TEXTURE.transition, 800 - 1586 / 2, panelH - 303, 1.5708, 6.26, 1586, 0, 1)
        if GAME.revDeckSkin then
            gc_setColor(1, 1, 1, GAME.revTimer)
            gc_mDraw(TEXTURE.panel.glass_a, 800, panelH)
            gc_mDraw(TEXTURE.panel.glass_b, 800, panelH)
            gc_setColor(1, 1, 1, ThrobAlpha.bg1)
            gc_mDraw(TEXTURE.panel.throb_a, 800, panelH)
            gc_setColor(1, 1, 1, ThrobAlpha.bg2)
            gc_mDraw(TEXTURE.panel.throb_b, 800, panelH)
        end
        gc_setColor(ShadeColor)
        gc_draw(TEXTURE.transition, 800 - 1586 / 2, panelH - 303, 1.5708, 12.6, -3, 0, 1)
        gc_draw(TEXTURE.transition, 800 + 1586 / 2, panelH - 303, 1.5708, 12.6, 3, 0, 1)
        gc_setColor(TextColor)
        gc_setAlpha(.626)
        gc_mRect('fill', 800, panelH - 303, 1586 + 6, -3)

        -- MP & ZP Preview
        if not GAME.playing and STAT.maxFloor >= 10 then
            gc_setColor(TextColor)
            gc_setAlpha(.12 + abs(math.log(GAME.comboZP)) * 2)
            gc_draw(TEXTS.zpPreview, 1370, 275, 0, 1, 1, TEXTS.zpPreview:getWidth())
            if GAME.comboMP >= 6 then
                gc_setAlpha(clampInterpolate(5, 0, 8, 1, GAME.comboMP))
                gc_draw(TEXTS.mpPreview, 1370, 235, 0, 1, 1, TEXTS.mpPreview:getWidth())
            end
        end
    end

    -- Result
    if GAME.uiHide < 1 then
        gc_replaceTransform(SCR.xOy_u)
        gc_translate(0, -224 * GAME.uiHide)
        gc_setColor(1, 1, 1)
        gc_draw(GAME.resIB, 400, 150, 0, .9)
        gc_setColor(COLOR.D)
        gc_mDraw(TEXTS.endHeight, 0, 135, 0, 1.8)
        gc_mDraw(TEXTS.endFloor, 0, 204)
        gc_mDraw(TEXTS.zpChange, 220, 95, 0, .626)
        gc_draw(TEXTS.endResult, -617, 80, 0, .626)
        gc_draw(TEXTS.floorTime, -617, 226 - GAME.uiHide * 150, 0, .38)
        gc_draw(TEXTS.rankTime, -527, 226 - GAME.uiHide * 150, 0, .38)
        gc_setColor(COLOR.L)
        gc_mDraw(TEXTS.endHeight, 0, 130, 0, 1.8)
        gc_mDraw(TEXTS.endFloor, 0, 201)
        gc_draw(TEXTS.endResult, -616, 78, 0, .626)
        gc_setColor(COLOR.DL)
        gc_draw(TEXTS.floorTime, -616, 224 - GAME.uiHide * 150, 0, .38)
        gc_draw(TEXTS.rankTime, -526, 224 - GAME.uiHide * 150, 0, .38)
        gc_setColor(COLOR.dL)
        gc_mDraw(TEXTS.zpChange, 220, 93, 0, .626)
    end

    -- Daily Challenge Button
    if not GAME.playing then
        gc_replaceTransform(SCR.xOy_ur)
        gc_setColor(TextColor)
        gc_mDraw(TEXTS.dcBest, -200, 100, nil, .626)
        gc_mDraw(TEXTS.dcTimer, -200, 152, nil, .626)
        if DailyActived then
            gc_setAlpha(.42 + .1 * sin(t * 6.2))
            gc_mRect('fill', -200, 126, 200, 80, 40)
        end
    end
end

local gvTimerColor1 = { 1, .942, .872, 0 }
local gvTimerColor2 = { 0, 0, 0, 0 }
local altitudeText = { 0, COLOR.dL, "m" }
function scene.overDraw()
    local t = love.timer.getTime()
    if GAME.zenithTraveler then return end

    gc_translate(0, DeckPress)

    if not GAME.invisUI then
        -- Current combo
        if not GAME.playing or M.IN < 2 then
            gc_setColor(TextColor)
            if M.IN == 2 then gc_setAlpha(.42 + .26 * sin(t * 2.6)) end
            gc_mDraw(TEXTS.mod, 800, 396, 0, min(1, 760 / TEXTS.mod:getWidth()))
        end

        -- Glow
        if ImpactGlow[1] then
            gc_setBlendMode('add')
            for i = 1, #ImpactGlow do
                local L = ImpactGlow[i]
                gc_setColor(L.r, L.g, L.b, L.t)
                gc_blurCircle(0, L.x, L.y, 120 * (L.t + 1.6) ^ 2)
            end
            gc_setBlendMode('alpha')
        end

        -- GigaSpeed Timer
        if GigaSpeed.alpha > 0 then
            local w, h = TEXTS.gigatime:getDimensions()
            local gigaFade = clamp((GAME.time - (GAME.gigaspeedEntered or GAME.time) - 120) / 180, 0, 1)
            gc_setColor(GigaSpeed.r, GigaSpeed.g, GigaSpeed.b, .2 * (GigaSpeed.alpha - gigaFade))
            gc_strokeDraw('full', 3, TEXTS.gigatime, 800, 264, 0, 1.5, 1.2, w * .5, h * .5)
            if M.DP < 2 then
                gc_setAlpha(GigaSpeed.alpha)
                gc_draw(TEXTS.gigatime, 800, 264, 0, 1.5, 1.2, w * .5, h * .5)
                if gigaFade > 0 then
                    local l = gigaFade == 1 and .5 or .8
                    gc_setColor(l, l, l, GigaSpeed.alpha * gigaFade)
                    gc_draw(TEXTS.gigatime, 800, 264, 0, 1.5, 1.2, w * .5, h * .5)
                end
            end
        end

        -- GigaSpeed Anim
        if GigaSpeed.textTimer then
            gc_setBlendMode('add')
            gc_setColor(.26, .26, .26)
            if GigaSpeed.isTera then
                for p = -10, 10, 3 do
                    gc_mDraw(TEXTS.teraspeed, 800 + (GigaSpeed.textTimer + p * .01) ^ 5 * 2600, 355, 0, 2.6)
                end
            else
                for p = -10, 10, 3 do
                    gc_mDraw(TEXTS.gigaspeed, 800 + (GigaSpeed.textTimer + p * .012) ^ 5 * 2600, 395, 0, 1.6)
                end
            end
            gc_setBlendMode('alpha')
        end

        -- Spike counter
        if GAME.spikeCounter >= 8 and GAME.spikeTimer > 0 then
            gc_push('transform')
            gc_translate(1226, 300)
            local _t = GAME.questTime
            local bk = _t < .12 and 1 + 62 * _t * (.12 - _t) or 1
            gc_scale(min(GAME.spikeCounter / 60, 1) + bk)
            local ox, oy = TEXTS.spike:getWidth() / 2, TEXTS.spike:getHeight() / 2
            gc_setColor(1, 1, 1, GAME.spikeTimer * .62)
            gc_strokeDraw('full', 2, TEXTS.spike, 0, 0, 0, 1, 1, ox, oy)
            gc_setColor(0, 0, 0, GAME.spikeTimer * 2.6)
            gc_draw(TEXTS.spike, 0, 0, 0, 1, 1, ox, oy)
            gc_pop()
        end

        -- Health Bar
        local safeHP = GAME.playing and max(GAME.dmgWrong + GAME.dmgWrongExtra, GAME.dmgTime) or 0
        if M.DP == 0 then
            gc_setColor(GAME.playing and GAME.life > safeHP and COLOR.L or COLOR.R)
            gc_mRect('fill', 800, 440, 1540 * GAME.lifeShow / GAME.fullHealth, 10)
            if GAME.playing then
                gc_setColor(COLOR.LD)
                gc_mRect('fill', 800, 440 - 2, 1540 * GAME.dmgTime / GAME.fullHealth, 3)
                gc_setColor(.872, 0, 0)
                gc_mRect('fill', 800, 440 + 2, 1540 * GAME.dmgWrong / GAME.fullHealth, 3)
                gc_setColor(1, 0, 0, .626)
                gc_mRect('fill', 800, 440 + 2, 1540 * (GAME.dmgWrong + GAME.dmgWrongExtra) / GAME.fullHealth, 2)
            end
        else
            local onAlly = GAME.onAlly
            gc_setColor(GAME.playing and GAME.life > safeHP and COLOR.L or COLOR.R)
            if onAlly then gc_setAlpha(.42) end
            gc_rectangle('fill', 800, 440 - 5, -1540 / 2 * GAME.lifeShow / GAME.fullHealth, onAlly and 8 * M.DP or 12)
            gc_setColor(GAME.playing and GAME.life2 > safeHP and COLOR.L or COLOR.R)
            if not onAlly then gc_setAlpha(.42) end
            gc_rectangle('fill', 800, 440 - 5, 1540 / 2 * GAME.lifeShow2 / GAME.fullHealth, onAlly and 12 or 8 * M.DP)
        end
    end

    if GAME.playing then
        if not GAME.invisUI then
            -- Achievement state mark
            if M.DP > 0 then
                if GAME.comboStr == 'rDP' and not GAME.achv_protectH then
                    gc_setColor(COLOR.lG)
                    gc_mRect('fill', 800 + 1540 / 2 * 10 / GAME.fullHealth, 442, 4, 20)
                    gc_mRect('fill', 800 - 1540 / 2 * 10 / GAME.fullHealth, 442, 4, 20)
                end
                if not GAME.achv_shareModH then
                    gc_setColor(COLOR.M)
                    gc_mRect('fill', 800, 435, 10, 10)
                end
                if not GAME.achv_noShareModH then
                    gc_setColor(COLOR.dR)
                    gc_mRect('fill', 800, 445, 10, 10)
                end
            end
            setFont(30)
            -- Quest counter
            if GAME.totalQuest <= 40 then
                gc_setColor(TextColor)
                gc.print(GAME.totalQuest, 1210, 230)
            end
            -- Revive counter
            if GAME.reviveCount > 0 then
                gc_strokePrint('full', 1, COLOR.D, COLOR.lR, GAME.reviveCount, 800, 440, 260, 'center')
            end
            if GAME.chain >= 4 then
                -- Chain Counter
                local c = GAME.chain
                local _t = GAME.questTime
                local bk = _t < .12 and 1 + 62 * _t * (.12 - _t) or 1
                local k = clampInterpolate(6, .7, 26, 2, c)

                local r, g, b, a
                if GAME.fault then
                    local l = M.AS < 2 and .62 or .42
                    r, g, b, a = l, l, l, c < 8 and .26 or 1
                elseif M.AS < 2 then
                    r, g, b, a = COLOR.HSL(
                        26 / (c + 22) + 1.3, 1,
                        icLerp(-260, 420, c),
                        c < 8 and .26 or 1
                    )
                else
                    r, g, b, a = COLOR.HSV(
                        clampInterpolate(4, .76, 26, 0.926, c), 1, 1,
                        .16
                    )
                    gc_setColor(0, 0, 0)
                    gc_mDraw(chargeIcon, 326, 270, GAME.time * 2.6, .25 * k * bk)
                end

                if URM and M.NH == 2 then
                    r, g, b = .626 + r * .26, .626 + g * .26, .626 + b * .26
                end

                -- Spike ball
                gc_setColor(r, g, b, a)
                gc_blurCircle(-.26, 326, 270, 100 * k)
                gc_mDraw(chargeIcon, 326, 270, GAME.time * 2.6, .25 * k * bk)

                -- Spark
                if not (URM and M.NH == 2) then
                    gc_setColor(.7 + r * .3, .7 + g * .3, .7 + b * .3)
                    for i = 1, 3 do gc_draw(SparkPS[i], 326, 270, 0, k * .8) end
                end

                -- "B2B x"
                local x = 255 - 50 * k * bk
                gc_setColor(COLOR.D)
                gc_draw(TEXTS.b2b, x, 216)
                gc_setColor(r, g, b)
                gc_draw(TEXTS.b2b, x, 214)

                -- Number
                local chain = TEXTS[M.AS < 2 and 'chain' or 'chain2']
                if M.AS < 2 then
                    if c >= 8 then
                        gc_setColor(COLOR.L)
                        gc_strokeDraw('full', k * 2, chain, 326, 268, 0, k * bk, nil,
                            chain:getWidth() / 2, chain:getHeight() / 2)
                        gc_setColor(COLOR.D)
                    end
                    gc_mDraw(chain, 326, 268, 0, k * bk)
                else
                    gc_draw(WoundPS, 326, 266)

                    if not GAME.fault then
                        gc_setColor(r, g, b, .26 + .1 * math.sin(GAME.time * 4.2))
                        gc_setBlendMode('add')
                        gc_strokeDraw('full', 3.55 * k, chain, 326, 268, 0, k * bk)
                        gc_setBlendMode('alpha')
                    end
                    gc_setColor(COLOR.L)
                    gc_draw(chain, 326, 268, 0, k * bk)
                end
            elseif GAME.comboStr == 'VLrGV' then
                GC.mStr(floor(GAME.achv_altFromSurge) .. "m", 326, 240)
            end

            -- Damage Timer
            local delay = GAME.dmgDelay
            local w = -360 * min(GAME.dmgTimerMul ^ .5, 1)
            gc_setColor(GAME.dmgTimer > GAME.dmgCycle and COLOR.DL or COLOR.lR)
            gc_rectangle('fill', 390, 430, w * (GAME.dmgTimer / delay), -20 - 2 * delay)
            gc_setLineWidth(3)
            gc_setColor(COLOR.LD)
            gc_rectangle('line', 390, 430, w * (GAME.dmgCycle / delay), -20 - 2 * delay)
            gc_rectangle('line', 390, 430, w, -20 - 2 * delay)

            -- Gravity Timer
            if M.GV > 0 then
                gc_push('transform')
                gc_translate(1300, 270)
                gc_scale(GAME.uiHide)
                gc_setColor(COLOR.DL)
                if GAME.gravTimer then
                    gc_arc('fill', 'pie', 0, 0, 40, -1.5708,
                        -1.5708 + 6.2832 * GAME.gravTimer / GAME.gravDelay)
                else
                    gc_circle('fill', 0, 0, 40)
                end
                gc_setColor(COLOR.LD)
                gc_circle('line', 0, 0, 40)
                if GAME.gravTimer and GAME.gravTimer < 4.2 then
                    setFont(30)
                    gvTimerColor1[4] = clampInterpolate(clamp(GAME.gravDelay, 2.6, 4.2), 0, min(GAME.gravDelay - .626, 2.6), 1, GAME.gravTimer)
                    gvTimerColor2[4] = gvTimerColor1[4]
                    gc_strokePrint('full', 1, gvTimerColor1, gvTimerColor2, ("%.1f"):format(GAME.gravTimer + .05), 0, -21, nil, 'center')
                end
                gc_pop()
            end

            -- Revive Task
            local task = GAME.currentTask
            if task then
                local allyDie = GAME.life2 <= 0
                gc_push('transform')

                -- Lock
                gc_translate(allyDie and 1150 or 450, 450)
                gc_setColor(1, 1, 1)
                local texture = TEXTURE.revive[M.DP < 2 and 'norm' or allyDie and 'rev_right' or 'rev_left']
                local taskID
                for i = #GAME.reviveTasks, 1, -1 do
                    gc_mDrawQ(texture, reviveQuad[i], 0, 0, 0, .4)
                    if GAME.reviveTasks[i] == GAME.currentTask then
                        taskID = i
                        break
                    end
                end

                -- Text
                gc_rotate(reviveRot[taskID])
                gc_translate(reviveMove[taskID], 0)
                local txt = task.textObj
                local w, h = txt:getDimensions()
                local ky = h < 40 and 1 or .7
                if task.target == 1 then
                    local kx = min(ky, 310 / w)
                    gc_draw(txt, (310 - w * kx) / 2, h < 40 and -12 or -22, 0, kx, ky)
                else
                    local kx = min(ky, 240 / w)
                    gc_draw(txt, 0, h < 40 and -12 or -22, 0, kx, ky)
                    -- Progres
                    local w2 = task.progObj:getWidth()
                    gc_draw(task.progObj, 310, -22, 0, min((300 - w * kx) / w2, 1.5), 1.5, w2)
                end

                -- gc_setColor(0, 1, 0)
                -- gc_rectangle('line', 0, -25, 310, 63.5)
                gc_pop()

                -- Short Text & Panel
                gc_setColor(.3, .1, 0, .62)
                gc_mRect('fill', 800, 330, GAME.currentTask.shortObj:getWidth() * 1.6 + 50, 75, 20)
                gc_setColor(1, 1, 1)
                gc_mDraw(GAME.currentTask.shortObj, 800, 330, 0, 1.6)
            end
        end


        -- Quests
        for i = 1, #GAME.quests do
            local Q = GAME.quests[i]
            local text = Q.name
            local kx = min(Q.k, 1550 / text:getWidth())
            local ky = max(kx, Q.k)
            local a = 1
            if M.IN == 2 then
                local k = M.DP > 0 and i <= 2 and 1 / i or i ^ -2
                a = clamp(
                    a * (1 - (GAME.questTime - .26) * (GAME.floor + .62) * .26 * k),
                    GAME.faultWrong and not URM and i * .26 or 0, 1
                )
            end
            if a > 0 then
                a = a * Q.a
                gc_setColor(.2 * a, .2 * a, .2 * a, a)
                gc_mDraw(text, 800, Q.y + 5, 0, kx, ky)
                gc_setColor(1, 1, 1, a)
                gc_mDraw(text, 800, Q.y, 0, kx, ky)
            end
        end
    end


    -- Debug
    -- setFont(30) gc_setColor(1, 1, 1)
    -- for i = 1, #Cards do
    --     gc.print(Cards[i].ty, Cards[i].x, Cards[i].y-260)
    -- end

    -- Bottom In-game UI
    if GAME.uiHide > 0 and not GAME.invisUI then
        local h = 100 - GAME.uiHide * 100
        gc_move('m', 0, h)

        -- Thruster (XP bar)
        local rank = GAME.rank
        gc_setColor(rankColor[rank - 1] or COLOR.dL)
        if GAME.DPlock then gc_setAlpha(.26) end
        gc_setLineWidth(26 / (GAME.leakSpeed + 2))
        gc_mRect('line', 800, 965, 420 + 6, 26)
        gc_rectangle('fill', 800 - 35, 985, 70, 6)
        for i = 1, min(rank - 1, 6) do
            gc_rectangle('fill', 800 + 15 + 28 * i, 985, 22, 6)
            gc_rectangle('fill', 800 - 15 - 28 * i, 985, -22, 6)
        end
        if rank >= 8 then
            for i = 0, min(rank - 8, 3) do
                gc_rectangle('fill', 800 - 220 + 45 * i, 945, 35, -10)
                gc_rectangle('fill', 800 + 220 - 45 * i, 945, -35, -10)
            end
            if rank >= 12 then
                for i = 0, rank - 12 do
                    gc_rectangle('fill', 800 + 222 + 15 * i, 955, 10, 32)
                    gc_rectangle('fill', 800 - 222 - 15 * i, 955, -10, 32)
                end
            end
        end
        if GAME.rankupLast then
            if GAME.xpLockLevel < GAME.xpLockLevelMax and not (URM and M.NH == 2) then
                gc_mRect('fill', 800 - 105, 965, 2, 26 - 4)
                gc_mRect('fill', 800 + 105, 965, 2, 26 - 4)
            end
        else
            gc_mRect('fill', 800, 965, 420, 1)
        end
        gc_setColor(rankColor[rank] or COLOR.L)
        if GAME.xpLockTimer > 0 then
            gc_setAlpha((sin(6200 / (GAME.xpLockTimer + 4.2) ^ 3) * .26 + .74) * (GAME.DPlock and .26 or 1))
        elseif GAME.DPlock then
            gc_setAlpha(.26)
        end
        gc_mRect('fill', 800, 965, 420 * GAME.xp / (4 * rank), 3 * min(GAME.xpLockLevel, 5))

        -- Height & Time
        altitudeText[1] = ("%.1f"):format(GAME.roundHeight)
        TEXTS.height:set(altitudeText)
        TEXTS.time:set(STRING.time_simp(GAME.time))
        gc_setColor(COLOR.D)
        local wid, hgt = TEXTS.height:getDimensions()
        gc_strokeDraw('full', 1, TEXTS.height, 800, 978, 0, 1, 1, wid / 2, hgt / 2)
        wid, hgt = TEXTS.time:getDimensions()
        gc_strokeDraw('full', 2, TEXTS.time, 375, 978, 0, 1, 1, wid / 2, hgt / 2)
        wid, hgt = TEXTS.rank:getDimensions()
        gc_strokeDraw('full', 1, TEXTS.rank, 1027, 990, 0, .626, .626, wid / 2, hgt / 2)

        gc_setColor(GAME.timerMul, .99, .99)
        gc_mDraw(TEXTS.time, 375, 978)
        gc_setColor(COLOR.L)
        gc_mDraw(TEXTS.rank, 1027, 990, 0, .626)
        if GAME.DPlock then
            gc_setColor(GAME.time % .9 > .45 and COLOR.R or COLOR.D)
        end
        gc_mDraw(TEXTS.height, 800, 978)

        if GAME.attackMul < 1 then
            setFont(30)
            gc_setColor(1, 0, 0, t % .52 < .26 and .872 or .42)
            gc.print("x" .. GAME.attackMul, 1024, 926, 0, .7)
        end

        gc_back()
    end

    -- Rev trigger for touchscreen
    if usingTouch and not GAME.playing and RevUnlocked then
        gc_replaceTransform(SCR.xOy_dl)
        if URM then
            gc_setColor(COLOR.C)
            gc_setAlpha(next(revHold) and .872 or .62)
        else
            gc_setColor(COLOR.S)
            gc_setAlpha(next(revHold) and .42 or .26)
        end
        gc_draw(TEXTURE.transition, -200 * GAME.uiHide, -40, 0, 200 / 128, -560)
    end

    -- Cards
    gc_replaceTransform(SCR.xOy)
    gc_setColor(1, 1, 1)
    if FloatOnCard then
        for i = #Cards, 1, -1 do
            if i ~= FloatOnCard then Cards[i]:draw() end
        end
        Cards[FloatOnCard]:draw()
    else
        for i = #Cards, 1, -1 do Cards[i]:draw() end
    end

    if not GAME.invisUI then
        -- Allspin keyboard hint
        if M.AS > 0 and M.EX == 0 then
            for i = 1, #Cards do
                local obj = ShortCut[i]
                local x, y = Cards[i].x + 90, Cards[i].y + 155
                local k = min(60 / obj:getWidth(), 1)
                gc_setColor(ShadeColor)
                gc_strokeDraw(
                    'full', 3 * k, obj, x, y, 0, k, k,
                    obj:getWidth() / 2, obj:getHeight() / 2
                )
                gc_setColor(COLOR.lR)
                gc_mDraw(obj, x, y, 0, k)
            end
        end

        -- Section time
        if GAME.uiHide > 0 then
            gc_replaceTransform(SCR.xOy_dr)
            local ox, oy = TEXTS.floorTime:getDimensions()
            gc_setColor(0, 0, 0, .626)
            gc_draw(TEXTS.floorTime, -10, -5 + 260 * (1 - GAME.uiHide), 0, .7, .7, ox, oy)
            gc_setColor(.626, .626, .626, .626)
            gc_draw(TEXTS.floorTime, -10, -5 + 260 * (1 - GAME.uiHide), 0, .7, .7, ox, oy)
        end

        -- UI
        if GAME.uiHide < 1 then
            local exT = GAME.exTimer
            local revT = GAME.revTimer
            local d = GAME.uiHide * 70

            gc_replaceTransform(SCR.xOy_u)

            -- Top bar & texts
            gc_setColor(ShadeColor)
            gc_rectangle('fill', -1300, -d, 2600, 70)
            gc_setColor(TextColor)
            gc_setAlpha(.626)
            gc_rectangle('fill', -1300, 70 - d, 2600, 3)
            gc_replaceTransform(SCR.xOy_ul)
            local h = TEXTS.title:getHeight()
            gc_setColor(TextColor)
            gc_draw(TEXTS.title, lerp(-181, 10, exT), (h / 2 + 2) - d, 0, 1, 1 - 2 * revT, 0, (h / 2 + 2))
            gc_replaceTransform(SCR.xOy_ur)
            gc_draw(TEXTS.pb, -10, -d, 0, 1, 1, TEXTS.pb:getWidth(), 0)
            gc_replaceTransform(SCR.xOy_dl)
            gc_translate(0, DeckPress + d)
            if revT > 0 then
                gc_draw(TEXTS.slogan, 6, 2 + (exT + revT) * 42, 0, 1, 1, 0, TEXTS.slogan:getHeight())
                gc_draw(TEXTS.slogan_EX, 6, 2 + (1 - exT + revT) * 42, 0, 1, 1, 0, TEXTS.slogan_EX:getHeight())
                gc_draw(TEXTS.slogan_rEX, 6, 2 + (1 - revT) * 42, 0, 1, 1, 0, TEXTS.slogan_rEX:getHeight())
            else
                gc_draw(TEXTS.slogan, 6, 2 + exT * 42, 0, 1, 1, 0, TEXTS.slogan:getHeight())
                gc_draw(TEXTS.slogan_EX, 6, 2 + (1 - exT) * 42, 0, 1, 1, 0, TEXTS.slogan_EX:getHeight())
            end
            gc_replaceTransform(SCR.xOy_dr)
            gc_translate(0, DeckPress)
            gc_draw(TEXTS.credit, -5, d, 0, .872, .872, TEXTS.credit:getDimensions())
        end

        -- Card Info
        if not GAME.playing and FloatOnCard then
            local C = Cards[FloatOnCard]
            local infoID = C.lock and (C.id == 'DP' and 'lockDP' or 'lock') or C.id
            gc_replaceTransform(SCR.xOy_d)
            gc_move('m', 0, 126 * (1 - C.float))
            gc_setColor(ShadeColor)
            gc_setAlpha(.7)
            gc_rectangle('fill', -888 / 2, -145, 888, 120, 10)
            if GAME.anyRev and M[infoID] == 2 then
                local text = URM and MD.ultraName[infoID] or MD.revName[infoID]
                setFont(70)
                gc_push('transform')
                gc_translate(0, -118)
                gc_scale(1 + sin(t / 2.6) * .026)
                gc_shear(sin(t) * .26, cos(t * 1.2) * .026)
                gc_strokePrint('full', 6, COLOR.DW, nil, text, 130, -35 + 4, 2600, 'center', 0, .9, 1)
                gc_strokePrint('full', 4, COLOR.dW, nil, text, 130, -35 + 2, 2600, 'center', 0, .9, 1)
                gc_strokePrint(
                    'full', 2, COLOR.W, URM and COLOR.D or COLOR.L,
                    text, 130, -35, 2600, 'center', 0, .9, 1
                )
                gc_pop()
                setFont(30)
                gc_strokePrint(
                    'full', 2, COLOR.dW, URM and COLOR.D or COLOR.W,
                    (URM and MD.ultraDesc or MD.revDesc)[infoID], 260, -68, 2600, 'center', 0, .8, 1
                )
            else
                setFont(70)
                gc_strokePrint('full', 3, ShadeColor, TextColor, MD.fullName[infoID], 130, -150, 2600, 'center', 0, .9, 1)
                setFont(30)
                gc_strokePrint('full', 2, ShadeColor, TextColor, MD.desc[infoID], 260, -73, 2600, 'center', 0, .8, 1)
            end
            gc_back()
        end

        -- Forfeit Panel
        if GAME.forfeitTimer > 0 then
            gc_replaceTransform(SCR.origin)
            local alpha = min(GAME.forfeitTimer * 2.6, 1)
            local h = SCR.h * GAME.forfeitTimer * .5

            -- Body
            gc_setColor(.8, .2, .0626, alpha)
            gc_rectangle('fill', 0, SCR.h, SCR.w, -h)

            -- Blur
            gc_setColor(1, 1, 1, alpha * .355)
            gc_draw(TEXTURE.transition, 0, SCR.h - h, 1.5708, h / 128, SCR.w, 0, 1)
            gc_setColor(1, 0, 0, alpha * .42)
            gc_draw(TEXTURE.transition, 0, SCR.h - h, -1.5708, SCR.k * 42 / 128, SCR.w)

            -- Line
            gc_setColor(1, 0, 0, alpha)
            gc_rectangle('fill', 0, SCR.h - h, SCR.w, -5 * SCR.k)

            -- Text
            gc_setColor(1, .872, .872, alpha)
            gc_mDraw(TEXTS.forfeit, SCR.w / 2, SCR.h - h * .5, 0, SCR.k, SCR.k)
        end
    end

    -- TimeMul
    if GAME.nightcore or GAME.slowmo then
        gc_replaceTransform(SCR.xOy_m)
        gc_rotate(-1.5708)
        gc_setLineWidth(42)
        local a
        if GAME.nightcore then
            gc_setColor(1, 1, 1, GAME.playing and .1 or .26)
            gc_circle('line', 0, 0, 620)
            gc_setColor(1, 1, 1, GAME.playing and .26 or .42)
            a = os.date('%H') / 6 * 3.1416
            gc_setLineWidth(26)
            gc_line(0, 0, 120 * cos(a), 120 * sin(a))
            a = os.date('%M') / 30 * 3.1416
            gc_setLineWidth(16)
            gc_line(0, 0, 260 * cos(a), 260 * sin(a))
            a = os.date('%S') / 30 * 3.1416
            gc_setLineWidth(10)
            gc_line(0, 0, 420 * cos(a), 420 * sin(a))
            a = love.timer.getTime() / 30 * 3.1416 * 26
            gc_line(0, 0, 520 * cos(a), 520 * sin(a))
            a = love.timer.getTime() / 30 * 3.1416 * 60
            gc_line(0, 0, 600 * cos(a), 600 * sin(a))
        else
            gc_setColor(1, 1, 1, GAME.playing and .0626 or .1)
            gc_circle('line', 0, 0, 620)
            gc_setColor(1, 1, 1, GAME.playing and .1 or .26)
            a = os.date('%H') / 6 * 3.1416
            gc_setLineWidth(26)
            gc_line(0, 0, 120 * cos(a), 120 * sin(a))
            a = os.date('%M') / 30 * 3.1416
            gc_setLineWidth(16)
            gc_line(0, 0, 260 * cos(a), 260 * sin(a))
            a = os.date('%S') / 30 * 3.1416
            gc_setLineWidth(10)
            gc_line(0, 0, 420 * cos(a), 420 * sin(a))
        end
    end

    -- Test
    if TestMode then
        -- Watermark
        gc_replaceTransform(SCR.xOy_u)
        gc_setColor(1, 1, 1, .26)
        gc_mDraw(TEXTS.test, -260, 260, -.16 + sin(t * 2.6) * .0626, 8.72)

        -- Show Touch
        gc_replaceTransform(SCR.xOy)
        gc_setColor(1, 1, 1, .5)
        gc_setLineWidth(4)
        for _, id in next, love.touch.getTouches() do
            local x, y = love.touch.getPosition(id)
            x, y = SCR.xOy:inverseTransformPoint(x, y)
            gc_circle('line', x, y, 80)
        end
    end

    -- Ultra cover
    if URM and (not GAME.playing or GAME.anyRev) then
        gc_replaceTransform(SCR.origin)
        gc_setColor(.42, 0, 0, GAME.playing and .16 or .35)
        gc_draw(TEXTURE.pixel, 0, 0, 0, SCR.w, SCR.h)
        gc_setColor(0, 0, 0, M.EX == 2 and .62 or .42)
        gc_draw(TEXTURE.darkCorner, 0, 0, 0, SCR.w / 128, SCR.h / 128)
    end

    -- Version number
    if not GAME.invisUI then
        gc_replaceTransform(SCR.xOy_d)
        gc_setColor(.626, .626, .626, .626)
        gc_mDraw(TEXTS.version, GAME.invisUI and 0 or -260 * GAME.uiHide, -10, 0, .62)
    end
end

local function button_start()
    if GAME.playing then
        GAME.commit()
        if UsingTouch then
            FloatOnCard = nil
            GAME.refreshLayout()
        end
        if not GAME.achv_noManualCommitH then GAME.achv_noManualCommitH = GAME.roundHeight end
    else
        GAME.start()
    end
end
local function button_reset()
    if M.AS == 0 then GAME.nixPrompt('keep_no_reset') end
    GAME.cancelAll()
    if UsingTouch then
        FloatOnCard = nil
        GAME.refreshLayout()
    end
    SFX.play('menuclick')
end

scene.widgetList = {
    WIDGET.new {
        name = 'back', type = 'button',
        pos = { 0, 0 }, x = 60, y = 140, w = 160, h = 60,
        color = { .15, .15, .15 },
        sound_hover = 'menutap',
        fontSize = 30, text = "    BACK", textColor = 'DL',
        onClick = function()
            if GAME.playing then
                if TASK.lock('sure_forfeit', 2.6) then
                    SFX.play('menuclick')
                    MSG('dark', "PRESS AGAIN TO FORFEIT", 2.6)
                else
                    SFX.play('menuback')
                    GAME.finish('forfeit')
                end
            else
                love.keypressed('escape')
                love.keyreleased('escape')
            end
        end,
    },
    WIDGET.new {
        name = 'stat', type = 'button',
        pos = { 0, 0 }, x = 60, y = 230, w = 160, h = 60,
        color = { COLOR.HEX '1F4E2C' },
        sound_hover = 'menutap',
        fontSize = 30, text = "    STAT", textColor = { COLOR.HEX '73E284' },
        onPress = function() love.keypressed('`') end,
        onClick = function() love.keyreleased('`') end,
    },
    WIDGET.new {
        name = 'achv', type = 'button',
        pos = { 0, 0 }, x = 60, y = 320, w = 160, h = 60,
        color = { COLOR.HEX '1F4E2C' },
        sound_hover = 'menutap',
        fontSize = 30, text = "    ACHV", textColor = { COLOR.HEX '73E284' },
        onPress = function() love.keypressed('tab') end,
        onClick = function() love.keyreleased('tab') end,
    },
    WIDGET.new {
        name = 'conf', type = 'button',
        pos = { 1, 0 }, x = -60, y = 230, w = 160, h = 60,
        color = { COLOR.HEX '253355' },
        sound_hover = 'menutap',
        fontSize = 30, text = "CONF   ", textColor = { COLOR.HEX '869EFF' },
        onPress = function() love.keypressed('f1') end,
        onClick = function() love.keyreleased('f1') end,
    },
    WIDGET.new {
        name = 'about', type = 'button',
        pos = { 1, 0 }, x = -60, y = 320, w = 160, h = 60,
        color = { COLOR.HEX '383838' },
        sound_hover = 'menutap',
        fontSize = 30, text = "ABOUT ", textColor = { COLOR.HEX '909090' },
        onPress = function() love.keypressed('f2') end,
        onClick = function() love.keyreleased('f2') end,
    },
    WIDGET.new {
        name = 'start', type = 'button',
        pos = { .5, .5 }, y = -170, w = 800, h = 200,
        color = { .35, .12, .05 },
        textColor = TextColor,
        sound_hover = 'menuhover',
        fontSize = 70, text = "START",
        onPress = function(k)
            if k == 3 then return end
            HoldingButtons.startBtn = true
            if M.EX == 0 then
                SFX.play('move')
                button_start()
            else
                SFX.play('rotate')
            end
        end,
        onClick = function(k)
            if k == 3 then return end
            if not HoldingButtons.startBtn then return end
            HoldingButtons.startBtn = nil
            if M.EX > 0 then button_start() end
        end,
    },
    WIDGET.new {
        name = 'reset', type = 'button',
        pos = { .5, .5 }, x = 500, y = -120, w = 160, h = 100,
        color = 'DR',
        sound_hover = 'menutap',
        fontSize = 30, text = "RESET", textColor = 'dR',
        onPress = function(k)
            if k == 3 then return end
            HoldingButtons.resetBtn = true
            if M.EX == 0 then
                SFX.play('move')
                button_reset()
            else
                SFX.play('rotate')
            end
        end,
        onClick = function(k)
            if k == 3 then return end
            if not HoldingButtons.resetBtn then return end
            if M.EX > 0 then button_reset() end
        end,
    },
    WIDGET.new {
        name = 'daily', type = 'hint',
        pos = { 1, 0 }, x = -200, y = 126, w = 200, h = 80, cornerR = 40,
        color = TextColor,
        fontSize = 30, text = "Daily Chall.",
        sound_hover = 'menutap',
        labelPos = 'leftBottom',
        floatFontSize = 30,
        floatCornerR = 26,
        floatText = "NO DATA",
        onPress = function()
            if not DailyAvailable then return end
            applyCombo(DAILY)
        end,
    },
    WIDGET.new {
        name = 'help', type = 'hint',
        pos = { 1, 0 }, x = -50, y = 126, w = 80, cornerR = 40,
        color = TextColor,
        fontSize = 50, text = "", -- Dynamic text
        sound_hover = 'menutap',
        labelPos = 'leftBottom',
        floatFontSize = 30,
        floatText = "", -- Dynamic text
        onPress = function()
            if usingTouch then
                switchVisitor(not GAME.zenithTraveler)
            else
                switchVisitor(true)
            end
        end,
        visibleFunc = function() return not GAME.playing end,
    },
    WIDGET.new {
        name = 'help2', type = 'hint',
        pos = { .5, 0 }, x = 610, y = 275, w = 60, cornerR = 30,
        color = TextColor,
        fontSize = 50, text = "", -- Dynamic text
        sound_hover = 'menutap',
        labelPos = 'leftBottom',
        floatFontSize = 30,
        floatText = "", -- Dynamic text
        onPress = function(k)
            if STAT.maxFloor < 10 then return SFX.play('no') end
            if k == 2 or kbIsDown('lctrl', 'rctrl') or next(revHold) then
                if RevUnlocked then
                    URM = not URM
                    SFX.play(URM and 'exchange' or 'undo')
                    ultraStateChange()
                else
                    SFX.play('no')
                end
            else
                PieceSFXID = (PieceSFXID or 0) % 8 + 1
                if PieceSFXID <= 7 then
                    local piece = ('zsjltoi'):sub(PieceSFXID, PieceSFXID)
                    SFX.play(piece, 1, 0, Tone(6))
                else
                    SFX.play('allclear')
                end

                for i = 1, 7 do
                    GAME[PieceData[i].id] = PieceSFXID == i
                end

                GAME.refreshLayout()
                RefreshBGM()
                GAME.refreshRPC()

                MSG({
                    cat = 'dark',
                    str = PieceData[PieceSFXID].popup,
                    time = 1.2
                })
            end
        end,
        visibleFunc = function() return not GAME.playing and TABLE.countAll(GAME.completion, 0) < 9 end,
    },
}

return scene
