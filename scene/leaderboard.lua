---@type Zenitha.Scene
local scene = {}

local clr = {
    D = { COLOR.HEX '19311EFF' },
    D2 = { COLOR.HEX '295131FF' },
    D3 = { COLOR.HEX '1A251CFF' },
    L = { COLOR.HEX '4DA667FF' },
    T = { COLOR.HEX '6FAC82FF' },
}
local colorRev = false
local scroll, scroll1, maxScroll

local M = GAME.mod
local MD = ModData
local CD = Cards

local scrollGroup = {}
local page = 0
local subPage = 'alt'

local function refreshBtn()
    local L = scene.widgetList
    L.alt.fillColor = subPage == 'alt' and clr.D3 or clr.D2
    L.time.fillColor = subPage == 'time' and clr.D3 or clr.D2
    for i = 0, 4 do
        L['day' .. i].fillColor = page == i and clr.D3 or clr.D2
    end
end

local function sendReq(combo)
    LB[combo] = LB[combo] or {}
    if STAT.mod == 'vanilla' and SupportCurl then
        ASYNC.runCmd('fetchLeaderboard', CurlCMD {
            act = 'fetch',
            combo = combo,
        })
    end
end

local function switchPage(p)
    local combo = DailyHistory[p]
    if LB[combo] and LB[combo].lastUpd then
        if os.time() - LB[combo].lastUpd >= 26 then
            sendReq(combo)
        end
    elseif TASK.lock('lb_daily_' .. p, 26) then
        sendReq(combo)
    end
    page = p
    refreshBtn()
end

function scene.load()
    if GAME.anyRev ~= colorRev then
        colorRev = GAME.anyRev
        for _, C in next, clr do
            C[1], C[2] = C[2], C[1]
        end
    end
    scroll, scroll1 = 0, 0
    maxScroll = 0

    page, subPage = 0, 'alt'
    refreshBtn()

    switchPage(0)
end

function scene.mouseMove(_, _, _, dy)
    if love.mouse.isDown(1, 2) then
        scroll = MATH.clamp(scroll - dy * (1 + M.VL), 0, maxScroll)
    end
end

function scene.touchMove(_, _, _, dy)
    scroll = MATH.clamp(scroll - dy * (1 + M.VL), 0, maxScroll)
end

function scene.keyDown(key, isRep)
    if isRep then return true end
    if key == 'escape' or key == 'f2' then
        SFX.play('menuclick')
        SCN.back('none')
    end
    ZENITHA._cursor.active = true
    return true
end

function scene.wheelMove(_, dy)
    scroll = MATH.clamp(scroll - dy * 100 * (1 + M.VL), 0, maxScroll)
end

function scene.resize()
    scroll, scroll1 = 0, 0
end

function scene.update(dt)
    local y0 = scroll1
    if math.abs(y0 - scroll) > .1 then
        scroll1 = MATH.expApproach(scroll1, scroll, dt * 26)
        for _, w in next, scrollGroup do
            w._y = w._y + (y0 - scroll1)
        end
        GAME.bgH = math.max(GAME.bgH + (y0 - scroll1) / 355, 0)
    end
    GAME.height = GAME.bgH
end

local gc = love.graphics
local gc_push, gc_pop = gc.push, gc.pop
local gc_origin, gc_replaceTransform = gc.origin, gc.replaceTransform
local gc_translate, gc_scale = gc.translate, gc.scale
local gc_setColor, gc_setLineWidth = gc.setColor, gc.setLineWidth
local gc_draw, gc_line = gc.draw, gc.line
local gc_rectangle, gc_circle = gc.rectangle, gc.circle
local gc_arc = gc.arc
local gc_print, gc_printf = gc.print, gc.printf
local setFont = FONT.set
local gc_setAlpha = GC.setAlpha

local function drawBtn(x, y, w, h, revQuad)
    gc_rectangle('fill', x, y, w, h)
    if revQuad then
        gc_setColor(1, 1, 1)
        if colorRev then
            gc_draw(TEXTURE.recRevBG, revQuad, 0, 10)
        else
            GC.setShader(SHADER.swapRG)
            gc_draw(TEXTURE.recRevBG, revQuad, 0, 10)
            GC.setShader()
        end
    end
    gc_setColor(1, 1, 1, .2)
    gc_rectangle('fill', x, y, w, 3)
    gc_rectangle('fill', x, y + 3, 3, h - 3)
    gc_setColor(0, 0, 0, .2)
    gc_rectangle('fill', x + w, y + 3, -3, h - 6)
    gc_setColor(0, 0, 0, .4)
    gc_rectangle('fill', x + 3, y + h, w - 3, -3)
end

local baseX, baseY = 200, 110
local pw, ph = 1200, 300
local noW = 160
local entryH = 100
local entryGap = 10
function scene.draw()
    DrawBG(26)

    -- Panel
    gc_replaceTransform(SCR.xOy)
    gc_translate(baseX, baseY - scroll1)
    gc_setColor(clr.D)
    drawBtn(0, 0, pw, ph)

    setFont(50)
    gc_setColor(clr.T)
    gc_print("LEADERBOARDS", 15, 3)

    gc_setColor(0, 0, 0, .3)
    gc_rectangle('fill', 30, 90, pw - 30 * 2, 80, 4)
    gc_rectangle('fill', 30, 190, pw - 30 * 2, 80, 4)

    -- List
    local L = LB[DailyHistory[page]]
    if L.lastUpd then
        local l = L[subPage]
        gc_push('transform')
        gc_translate(0, 320)
        for i = 1, #l do
            local p = l[i]
            gc_setColor(clr.D)
            drawBtn(0, 0, pw, entryH)
            gc_setColor(0, 0, 0, .15)
            gc_rectangle('fill', 0, 0, noW, entryH)
            setFont(70)
            gc_setColor(COLOR.LG)
            gc_printf(i, 0, 0, noW - 10, 'right')
            gc_setColor(clr.T)
            gc_print(p.uid, noW + 15, 0, 0, .85)
            setFont(50)
            gc_printf(p.alt .. "M", 0, 0, pw - 15, 'right')
            setFont(30)
            if p.time then
                gc_printf("F10 in " .. p.time .. "s", 0, 55, pw - 15, 'right')
            end
            gc_setColor(1, 1, 1, .1)
            gc_print(p.hid, noW + 18, 65, 0, .8)
            gc_translate(0, entryH + entryGap)
        end
        maxScroll = math.max((entryH + entryGap) * (#l - 4), 0)
        gc_pop()
    else
        gc_setColor(clr.D)
        gc_setLineWidth(62)
        gc_circle('line', pw / 2, ph + 260, 200)
        gc_setColor(clr.L)
        gc_setLineWidth(26)
        local t = -love.timer.getTime() * 26
        gc_arc('line', 'open', pw / 2, ph + 260, 200, t, t + 2.6)
    end
end

function scene.overDraw()
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
        gc_print("CLICKER CHANNEL / LEADERBOARDS", 15, 68, 0, 1, -1)
    else
        gc_print("CLICKER CHANNEL / LEADERBOARDS", 15, 0)
    end

    -- Bottom bar
    gc_replaceTransform(SCR.xOy_d)
    gc_setColor(clr.D)
    gc_rectangle('fill', -1300, 0, 2600, -50)
    gc_setColor(clr.L)
    gc_setAlpha(.626)
    gc_rectangle('fill', -1300, -50, 2600, -3)
    gc_replaceTransform(SCR.xOy_dl)
    gc_setColor(clr.L)
    setFont(30)
    gc_print("TOP THE DAILY CHALLENGE LEADERBOARD!", 15, -45, 0, .85, 1)
end

local dayText = { [0] = "TODAY", "1D AGO", "2D AGO", "3D AGO", "4D AGO" }
for i = 0, 4 do
    local x = baseX + pw / 2 + (i - 2) * 225
    local y = baseY + 130
    table.insert(scrollGroup, WIDGET.new {
        name = 'day' .. i, type = 'button',
        x = x, y = y, w = 200, h = 50,
        color = clr.D2,
        sound_hover = 'menutap',
        textColor = clr.T, text = dayText[i],
        onPress = function() switchPage(i) end,
    })
end
table.insert(scrollGroup, WIDGET.new {
    name = 'alt', type = 'button',
    x = baseX + pw / 2 - 280, y = baseY + 230, w = 540, h = 50,
    color = clr.D2,
    sound_hover = 'menutap',
    textColor = clr.T, text = "ALTITUDE",
    onPress = function()
        subPage = 'alt'
        refreshBtn()
    end,
})
table.insert(scrollGroup, WIDGET.new {
    name = 'time', type = 'button',
    x = baseX + pw / 2 + 280, y = baseY + 230, w = 540, h = 50,
    color = clr.D2,
    sound_hover = 'menutap',
    textColor = clr.T, text = "SPEEDRUN",
    onPress = function()
        subPage = 'time'
        refreshBtn()
    end,
})

scene.widgetList = {
    WIDGET.new {
        name = 'back', type = 'button',
        pos = { 0, 0 }, x = 60, y = 140, w = 160, h = 60,
        color = { .15, .15, .15 },
        sound_hover = 'menutap',
        fontSize = 30, text = "    BACK", textColor = 'DL',
        onClick = function() love.keypressed('escape') end,
    },
}

TABLE.append(scene.widgetList, scrollGroup)

return scene
