---@type Zenitha.Scene
local scene = {}

local timer = 0
local k = 0
local windowSize = SYSTEM == 'Android' and 1 or .626
local banDate = ""
local clickRemain = 0

local clr = {
    panel = { CLR.HEX '951623' },
    text = { CLR.HEX 'F4A9B5' },
    dark = { CLR.HEX '0E0000' },
    reason = { CLR.HEX 'AF1326' },
    bar = { CLR.HEX 'EA122B' },
}

local function task_playWarnSFX()
    TASK.yieldT(.62)
    SFX.play('thunder2')
    SFX.play('thunder6')
    TASK.yieldT(.26)
    SFX.play('staffwarning')
end
function scene.load()
    TASK.new(task_playWarnSFX)
    timer = 0
    banDate = os.date("%m/%d/%Y, %I:%M:%S %p")
    clickRemain = 62
end

function scene.keyDown(_, isRep)
    if isRep or timer < 1.26 then return end
    clickRemain = clickRemain - 1
    if clickRemain == 0 then SCN.back() end
    return true
end

function scene.mouseDown() scene.keyDown() end

function scene.touchDown() scene.keyDown() end

function scene.update(dt)
    SCN.scenes.tower.update(dt)
    timer = timer + dt
    if timer > .626 then
        k = MATH.expApproach(k, 1, dt * 12.6)
    end
end

local function text(str, x, y, color, shadow)
    if shadow then
        GC.setColor(0, 0, 0, .22)
        GC.print(str, x + 2, y + 2)
    end
    GC.setColor(color)
    GC.print(str, x, y)
end

function scene.draw()
    SCN.scenes.tower.draw()
    SCN.scenes.tower.overDraw()
    GC.origin()
    GC.setColor(0, 0, 0, timer * 2.6)
    GC.rectangle('fill', 0, 0, SCR.w, SCR.h)

    GC.applyTransform(SCR.xOy_m)
    GC.scale(k * windowSize)

    local textX = -512
    local boxW = 1026

    -- Panel
    GC.setColor(clr.panel)
    GC.mRect('fill', 0, 0, 1126, 740, 3)

    -- Title
    FONT.set(60)
    text("YOU HAVE BEEN BANNED FROM", textX, -338, clr.text, true)
    text("ZENITH CLICKER", textX, -274, clr.text, true)

    -- Explanation
    FONT.set(30)
    text("BLOCKED SESSION MAY NOT CONTINUE PLAYING ZENITH CLICKER.", textX, -170, clr.text)

    -- Timestamp
    text("YOUR ACCOUNT WAS BLOCKED AT " .. banDate .. " FOR THE", textX, -82, clr.text)
    text("FOLLOWING REASON:", textX, -38, clr.text)

    -- Reason
    GC.setColor(clr.dark)
    GC.rectangle('fill', textX, 28, boxW, 118, 4)
    GC.setColor(clr.panel)
    GC.rectangle('line', textX, 28, boxW, 118, 4)
    text("ANTI-CHEAT TRIGGERED [" .. STAT.uid .. "] -", textX + 36, 46, clr.reason)
    text("DO NOT TRY TO GET IN TOUCH WITH STAFF", textX + 36, 84, clr.reason)
    text("THIS BAN EXPIRES AFTER " .. clickRemain .. " CLICKS.", textX, 166, clr.text)

    -- Congrats
    GC.setColor(clr.bar)
    GC.rectangle('fill', textX, 240, boxW, 76, 4)
    GC.setColor(clr.text)
    GC.print("IF YOU BELIEVE YOU WERE BANNED IN ERROR, YOU ARE RIGHT.", -490, 256)

    -- Cover
    GC.setColor(0, 0, 0, 1 - k)
    GC.mRect('fill', 0, 0, 1126, 740, 3)
end

return scene
