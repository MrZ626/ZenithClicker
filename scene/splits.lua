---@type Zenitha.Scene
local scene = {}

local SRrank = {}
SRSplitText1 = {} ---@type love.Text[]
SRSplitText2 = {} ---@type love.Text[]
SRSplitText3 = {} ---@type love.Text[]

local clr = {
    D = { COLOR.HEX '19311EFF' },
    L = { COLOR.HEX '4DA667FF' },
    T = { COLOR.HEX '6FAC82FF' },
    LT = { COLOR.HEX '98CBA8FF' },
}
local colorRev = false

function scene.load()
    if GAME.anyRev ~= colorRev then
        colorRev = GAME.anyRev
        for _, C in next, clr do
            C[1], C[2] = C[2], C[1]
        end
    end
    for i = 1, #SpeedrunData do
        local id = SpeedrunData[i].id
        if not SRSplitText1[i] then
            SRSplitText1[i] = GC.newText(FONT.get(50), "")
            SRSplitText2[i] = GC.newText(FONT.get(50), "")
            SRSplitText3[i] = GC.newText(FONT.get(30), "")
            SRrank[i] = 0
        end
        SRSplitText1[i]:set(SpeedrunData[i].name)
        if tonumber(STAT.joinDate:match("%d+") or 0) <= 2025 then
            SRSplitText2[i]:set("N/A")
        else
            local t = STAT.srMilestone[id]
            if not t then
                SRSplitText2[i]:set("N/A")
            elseif t < 0 then
                SRSplitText2[i]:set("*" .. STRING.time(-t))
            else
                SRSplitText2[i]:set(STRING.time(t))
            end
        end
        if SR[id] then
            SRSplitText3[i]:set(STRING.time(SR[id]))
            if SR[id] <= DevScore.srMilestone[id] then
                SRrank[i] = 3
            elseif SR[id] <= SpeedrunData[i].par1 then
                SRrank[i] = 2
            elseif SR[id] <= SpeedrunData[i].par2 then
                SRrank[i] = 1
            end
        else
            SRSplitText3[i]:set("N/A")
        end
    end
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

local gc = love.graphics
local gc_replaceTransform, gc_translate = gc.replaceTransform, gc.translate
local gc_setColor, gc_setLineWidth = gc.setColor, gc.setLineWidth
local gc_draw, gc_line = gc.draw, gc.line
local gc_rectangle = gc.rectangle
local gc_print = gc.print
local gc_setAlpha = GC.setAlpha
local w, h = 920, 740
function scene.draw()
    DrawBG(26)

    -- Panel
    gc_replaceTransform(SCR.xOy_m)
    gc_translate(-w / 2, -h / 2)
    gc_setColor(clr.D)
    gc_rectangle('fill', 0, 0, w, h)
    gc_setColor(0, 0, 0, .26)
    gc_rectangle('fill', 3, 3, w - 6, h - 6)
    gc_setColor(1, 1, 1, .1)
    gc_rectangle('fill', 0, 0, w, 3)
    gc_setColor(1, 1, 1, .04)
    gc_rectangle('fill', 0, 3, 3, h + 3)

    gc_replaceTransform(SCR.xOy_m)
    gc_setLineWidth(2)
    FONT.set(30)
    local textH = SRSplitText1[1]:getHeight()
    local x1 = -w / 2 + 150
    local x2 = w / 2 - 150
    local achv = TEXTURE.achievement
    for i = 1, #SpeedrunData do
        local y = (i - #SpeedrunData / 2 - .5) * 110 - 20
        gc_setColor(clr.T)
        gc_draw(SRSplitText1[i], x1, y, 0, 1, 1, 0, textH / 2)
        gc_draw(SRSplitText2[i], x2, y, 0, 1, 1, SRSplitText2[i]:getWidth(), textH / 2)
        gc_setAlpha(.62)
        gc_line(x1 + SRSplitText1[i]:getWidth() + 20, y, x2 - SRSplitText2[i]:getWidth() - 20, y)
        gc_setColor(clr.L)
        gc_print(SpeedrunData[i].desc, x1, y + 26, 0, .626)
        gc_setAlpha(.62)
        local w3 = SRSplitText3[i]:getWidth()
        gc_draw(SRSplitText3[i], x2, y + 26, 0, .626, .626, w3)
        if SRrank[i] > 0 then
            if SRrank[i] >= 3 then
                gc_setColor(1, 1, 1, .16)
                GC.mDraw(achv.overDev, x2 - 42, y + 12, 0, .36)
            end
            gc_setColor(clr.LT)
            GC.mDraw(achv.frame[5], x2 - w3 * .626 - 18, y + 38, 0, .1)
            if SRrank[i] >= 2 then
                GC.mDraw(achv.wreath[6], x2 - w3 * .626 - 18, y + 38, 0, .1)
            end
        end
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
        gc_print("CLICKER CHANNEL / SPEEDRUN SPLITS", 15, 68, 0, 1, -1)
    else
        gc_print("CLICKER CHANNEL / SPEEDRUN SPLITS", 15, 0)
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
    FONT.set(30)
    gc_print("BACKUP YOUR SAVE AND TRY WITH NEW ACCOUNT!", 15, -45, 0, .85, 1)
end

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

return scene
