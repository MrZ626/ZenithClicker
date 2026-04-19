---@type Zenitha.Scene
local scene = {}

EndText = GC.newText(FONT.get(70))
EndText2 = GC.newText(FONT.get(70), "ZENITH CLICKER!")

---@param align? 'left' | 'center' | 'right'
local function addText(text, x, y, scale, align, wraplimit)
    if type(text) == 'string' then text = { COLOR.L, text } end
    scale = scale or 1
    align = align or 'center'
    local w = (wraplimit or 900) / scale
    if align == 'center' then
        x = x - w / 2 * scale
    elseif align == 'right' then
        x = x - w * scale
    end
    EndText:addf(text, w, align, x, y, 0, scale)
end

addText("ZENITH  CLICKER", 0, 260)
addText("A TETR.IO Fangame from TETR.IO Community", 0, 360, .42)

local h = 520

addText("Design", -26, h, .42, 'right')
addText("MrZ", 26, h, .42, 'left')

h = h + 90
addText("Programming", -26, h, .42, 'right')
addText("MrZ", 26, h, .42, 'left')

h = h + 90
addText("Mod Icons", -26, h, .42, 'right')
addText("CreepercraftYT", 26, h, .42, 'left')

h = h + 90
addText("BG Reconstruction", -26, h, .42, 'right')
addText("DJ Asriel", 26, h, .42, 'left')

h = h + 90
addText("Rank Icons", -26, h, .42, 'right')
addText("Zyrixia", 26, h, .42, 'left')

h = h + 90
addText("Achievement Icons", -26, h, .42, 'right')
addText("MrZ & DJ Asriel", 26, h, .42, 'left')

h = h + 90
addText("Textworks (Ultra Mods)", -26, h, .42, 'right')
addText("FMichael & Obsidian", 26, h, .42, 'left')

h = h + 90
addText("Textworks (Design)", -26, h, .42, 'right')
addText("FMichael & Spritzy Sheep", 26, h, .42, 'left')

h = h + 90
addText("Textworks (Neg. Alt.)", -26, h, .42, 'right')
addText("FCSplayz", 26, h, .42, 'left')

h = h + 90
addText("Text Revision", -26, h, .42, 'right')
addText("MattMayuga & Flowerling", 26, h, .42, 'left')

h = h + 90
addText("Musics", -26, h, .42, 'right')
addText("Dr Ocelot", 26, h, .42, 'left')

h = h + 90
addText("Extra Music", -26, h, .42, 'right')
addText("petrtech & Ronezkj15", 26, h, .42, 'left')

h = h + 90
addText("World Design", -26, h, .42, 'right')
addText("Garbo", 26, h, .42, 'left')

h = h + 90
addText("Font (D-Din-Pro)", -26, h, .42, 'right')
addText("Adrian Frutiger", 26, h, .42, 'left')

h = h + 90
addText("Font (Abhayalibre)", -26, h, .42, 'right')
addText("Mooniak", 26, h, .42, 'left')

h = h + 90
addText("SFX", -26, h, .42, 'right')
addText("[from TETR.IO]", 26, h, .42, 'left')

h = h + 90
addText("Floor Art 1-5", -26, h, .42, 'right')
addText("Largeonions", 26, h, .42, 'left')

h = h + 90
addText("Floor Art 6-8", -26, h, .42, 'right')
addText("S. Zhang", 26, h, .42, 'left')

h = h + 90
addText("Floor Art 9-10", -26, h, .42, 'right')
addText("Lauren Sheng", 26, h, .42, 'left')

h = h + 90
addText("Original Card Art", -26, h, .42, 'right')
addText("Ricman", 26, h, .42, 'left')

h = h + 160
addText("Original Game", 0, h, .626)
h = h + 60
addText("TETR.IO", 0, h, .872)

h = h + 140
addText("The Team", 0, h, .5)

local x1, x2 = 42, 94.2
h = h + 80
addText("Founder & Lead Producer", x1, h, .42, 'right')
addText("osk", x2, h, .42, 'left')

h = h + 80
addText("Programming", x1, h, .42, 'right')
addText("Dimentio", x2, h, .42, 'left')

h = h + 80
addText("Audio, Music, Programming", x1, h, .42, 'right')
addText("Dr Ocelot", x2, h, .42, 'left')

h = h + 80
addText("Assisting Programming", x1, h, .42, 'right')
addText("Flash", x2, h, .42, 'left')

h = h + 80
addText("Game & World Design", x1, h, .42, 'right')
addText("Garbo", x2, h, .42, 'left')

h = h + 80
addText("Assisting Graphics Design", x1, h, .42, 'right')
addText("Glitchypsi", x2, h, .42, 'left')

h = h + 250
addText("YOU ARE", 0, h, .626)

local t

local e
local event = {
    [0] = { -2.6 },
    { 10,  1675 },
    { 6,   1573 },
    { 6,   1526 },
    { 6,   1390 },
    { 6,   1356 },
    { 6,   1242 },
    { 6,   1053 },
    { 6,   854 },
    { 6,   756 },
    { 6,   675 },
    { 6,   585 },
    { 6,   520 },
    { 6,   388 },
    { 6,   326 },
    { 6,   200 },
    { 6,   95 },
    { 9e9, 10 },
}
do
    local sumT = 0
    for i = 1, #event do
        sumT = sumT + event[i][1]
        event[i][1] = sumT
    end
end

function scene.load()
    t = 0
    e = 1
    STAT.bg = true
    GAME.bgH = event[1][2]
    GAME.bgX = 0
    GAME.revDeckSkin = false
    TASK.unlock('zc_sfx')
    if GAME.playing then
        SFX.setVol(0)
        GAME.negFloor = 10
        GAME.finish('forfeit')
        SFX.setVol(STAT.sfx / 100)
    end
    TASK.removeTask_code(Task_MusicEnd)
    PlayBGM('fomg', true)
    STAT.bgm = math.max(STAT.bgm, math.min(STAT.sfx, 20))
    BGM.setVol(STAT.bgm / 100)
end

function scene.unload()
    GAME.bgH = GAME.height
    TEXTS.endHeight:set("Thanks for playing!")
    TASK.new(function()
        for i = 1, 100 do
            TASK.yieldT(.01)
            BGM.setVol(STAT.bgm / 100 * i / 100)
        end
    end)
    PlayBGM('f0')
end

function scene.keyDown() return true end

function scene.update(dt)
    if love.keyboard.isDown('space', 'escape') and t < 98.72 then
        dt = dt * 12.6
    end
    if t < 120 then
        t = t + dt
        if t > event[e][1] then
            e = e + 1
            GAME.bgH = event[e][2]
        end
        GAME.bgH = math.max(GAME.bgH - dt, 0)
        if t > 100 and TASK.lock('zc_sfx') then
            TASK.new(function()
                for i = 99, 0, -1 do
                    TASK.yieldT(.1)
                    BGM.setVol(STAT.bgm / 100 * i / 100)
                end
                TASK.yieldT(2.6)
                SFX.play('victory')
            end)
        end
        if t >= 120 then
            SCN.back('slowFade')
        end
    end
    if GAME.bgH >= 1650 then
        StarPS:moveTo(0, -GAME.bgH * 2 * BgScale)
        StarPS:update(dt)
    end
end

function scene.draw()
    DrawBG(87.2)
    local a = 1 - math.min(math.abs(event[e - 1][1] - t), math.abs(event[e][1] - t)) * 0.872
    if a > 0 then
        GC.setColor(.1, .1, .1, a)
        GC.rectangle('fill', 0, 0, SCR.w, SCR.h)
    end
    GC.replaceTransform(SCR.xOy_m)
    GC.setColor(0, 0, 0)
    GC.draw(EndText, 0, -math.min(t, 110) * 62 + 4.2, 0, 2.01, 2)
    GC.setColor(1, 1, 1)
    GC.draw(EndText, 0, -math.min(t, 110) * 62, 0, 2)

    if t > 112.6 then
        FONT.set(70)
        GC.setColor(.9, .1, .2)
        for i = 0, 26 do
            GC.mDraw(EndText2, 6 * math.cos(i * MATH.tau / 26), 6 * math.sin(i * MATH.tau / 26), 0, 1.626)
        end
        GC.setColor(.1, .1, .1)
        for i = 0, 11 do
            GC.mDraw(EndText2, 2 * math.cos(i * MATH.tau / 11), 2 * math.sin(i * MATH.tau / 11), 0, 1.626)
        end
        GC.setColor(COLOR.L)
        GC.mDraw(EndText2, 0, 0, 0, 1.626)
    end
end

scene.widgetList = {
}

return scene
