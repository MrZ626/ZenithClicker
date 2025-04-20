---@type Zenitha.Scene
local scene = {}

local clr = {
    D = { COLOR.HEX '191E31' },
    L = { COLOR.HEX '4D67A6' },
    T = { COLOR.HEX '6F82AC' },
    LT = { COLOR.HEX 'B0CCEB' },
    cbFill = { COLOR.HEX '0B0E17' },
    cbFrame = { COLOR.HEX '6A82A7' },
}
local colorRev = false

local fatigueSet ---@type table
local fatigueMax ---@type number

local heightSet = {
    [0]=0,   50,  150,  300,  450,  650,  850, 1000,  1350,  1650, -- Standard
     2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 15000  -- PRO!
}

local PracticeSettings = {
    height = 0, -- Not real meter, check `heightSet`
    floor = 0, -- Will be set by Height

    fatigue = 0,
    time = 0, -- Will be set by Fatigue (`Fatigue[Mod].time`)
}

function scene.load()
    SetMouseVisible(true)
    if GAME.anyRev ~= colorRev then
        colorRev = GAME.anyRev
        for _, C in next, clr do
            C[1], C[3] = C[3], C[1]
        end
    end

    local M = GAME.mod
    fatigueSet = Fatigue[M.EX == 2 and 'rEX' or M.DP == 2 and 'rDP' or 'normal']
    scene.widgetList[3].axis = {0, #fatigueSet - 1, 1}
    scene.widgetList[3]:reset()
end

-- function scene.unload()
--     SaveStat()
-- end

function scene.keyDown(key, isRep)
    if isRep then return true end
    if key == 'escape' or key == 'f1' then
        SFX.play('menuclick')
        SCN.back('none')
    end
    ZENITHA.setCursorVis(true)
    return true
end

-- Panel size
local w, h = 900, 800
local baseX, baseY = (1600 - w) / 2, (1000 - h) / 2

local function drawSliderComponents(y, title, t1, t2, value)
    GC.ucs_move('m', 0, y)
    GC.setColor(0, 0, 0, .26)
    GC.mRect('fill', w / 2, 0, w - 40, 65, 5)
    GC.mRect('fill', w - 90, 0, 123, 48, 3)
    FONT.set(30)
    GC.setColor(clr.T)
    GC.print(title, 40, -20, 0, .85, 1)
    GC.setAlpha(.42)
    GC.print(t1, 326, 5, 0, .5)
    GC.print(t2, w - 230, 5, 0, .5)
    GC.setColor(clr.T)
    GC.mStr(value, w - 90, -20)
    -- GC.setColor(clr.L)
    -- GC.print("%", w - 60, -20, 0, .85, 1)
    GC.ucs_back()
end

function scene.draw()
    DrawBG(STAT.bgBrightness)

    -- Panel
    GC.replaceTransform(SCR.xOy)
    GC.ucs_move('m', 800 - w / 2, 500 - h / 2)
    GC.setColor(clr.D)
    GC.rectangle('fill', 0, 0, w, h)
    GC.setColor(0, 0, 0, .26)
    GC.rectangle('fill', 3, 3, w - 6, h - 6)
    GC.setColor(1, 1, 1, .1)
    GC.rectangle('fill', 0, 0, w, 3)
    GC.setColor(1, 1, 1, .04)
    GC.rectangle('fill', 0, 3, 3, h + 3)

    -- Sliders
    drawSliderComponents( 50, "HEIGHT" , "0 M"  ,"15 000 M", heightSet[PracticeSettings.height] or 0)
    drawSliderComponents(120, "FATIGUE", "UNSET","MAX"     , PracticeSettings.fatigue > 0 and PracticeSettings.fatigue or '[X]')

    -- Top bar & title
    GC.replaceTransform(SCR.xOy_u)
    GC.setColor(clr.D)
    GC.rectangle('fill', -1300, 0, 2600, 70)
    GC.setColor(clr.L)
    GC.setAlpha(.626)
    GC.rectangle('fill', -1300, 70, 2600, 3)
    GC.replaceTransform(SCR.xOy_ul)
    GC.setColor(clr.L)
    FONT.set(50)
    GC.print("CONFIG", 15, 0)

    -- Bottom bar & text
    GC.replaceTransform(SCR.xOy_d)
    GC.setColor(clr.D)
    GC.rectangle('fill', -1300, 0, 2600, -50)
    GC.setColor(clr.L)
    GC.setAlpha(.626)
    GC.rectangle('fill', -1300, -50, 2600, -3)
    GC.replaceTransform(SCR.xOy_dl)
    GC.setColor(clr.L)
    FONT.set(30)
    GC.print("TWEAK YOUR SETTINGS FOR A BETTER CLICKING EXPERIENCE", 15, -45, 0, .85, 1)

    -- Fatigue text
    if fatigueSet and PracticeSettings.fatigue > 0 then
        GC.replaceTransform(SCR.xOy)
        GC.printf(fatigueSet[PracticeSettings.fatigue].text, baseX + 0, baseY + 160, w - 20, 'right')
    end
end

scene.widgetList = {
    WIDGET.new {
        name = 'start', type = 'button',
        x = baseX + 220, y = baseY + 250, w = 360, h = 50,
        color = clr.L,
        fontSize = 30, textColor = clr.LT, text = "START PRACTICING!",
        sound_hover = 'menutap',
        sound_release = 'menuclick',
        onClick = function()
            GAME.start()
            GAME.practiceMode = true
            GAME.height = heightSet[PracticeSettings.height]
            GAME.fatigue = PracticeSettings.fatigue + 1
            if PracticeSettings.fatigue > 0 then
                GAME.time = fatigueSet[GAME.fatigue - 1].time
            end
            GAME.upFloor()
            SCN.back("none")
        end,
    },

    WIDGET.new {
        type = 'slider',
        x = baseX + 240 + 85, y = baseY + 50, w = 400,
        axis = { 0, 19, 1 },
        frameColor = 'dD', fillColor = clr.D,
        disp = function() return PracticeSettings.height end,
        code = function(value)   PracticeSettings.height = value end,
        sound_drag = 'rotate',
    },
    WIDGET.new {
        type = 'slider',
        x = baseX + 240 + 85, y = baseY + 120, w = 400,
        axis = { 0, 6, 1 }, -- Dynamic
        frameColor = 'dD', fillColor = clr.D,
        disp = function() return PracticeSettings.fatigue end,
        code = function(value)   PracticeSettings.fatigue = value end,
        sound_drag = 'rotate',
    },
}

return scene
