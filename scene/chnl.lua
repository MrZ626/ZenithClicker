---@type Zenitha.Scene
local scene = {}

local clr = {
    D = { COLOR.HEX '19311EFF' },
    L = { COLOR.HEX '4DA667FF' },
    T = { COLOR.HEX '6FAC82FF' },
    LT = { COLOR.HEX '98CBA8FF' },
    button = { COLOR.HEX '1F4E2C' },
}
local colorRev = false

function scene.load()
    SetMouseVisible(true)
    if GAME.anyRev ~= colorRev then
        colorRev = GAME.anyRev
        for _, C in next, clr do
            C[1], C[2] = C[2], C[1]
        end
    end
end

function scene.keyDown(key, isRep)
    if isRep then return true end
    if key == 'escape' or key == 'tab' then
        SFX.play('menuclick')
        SCN.back('none')
    elseif key == '1' then
        SFX.play('menuhit2')
        SCN.go('achv', 'none')
    elseif key == '2' then
        SFX.play('menuhit2')
        SCN.go('records', 'none')
    elseif key == '3' then
        SFX.play('menuhit2')
        SCN.go('splits', 'none')
    elseif key == '4' then
        SFX.play('menuhit2')
        SCN.go('leaderboard', 'none')
    elseif key == '5' then
        SFX.play('menuconfirm')
        love.system.openURL("https://discord.gg/thqhzSn72j")
    elseif key == '6' then
        SFX.play('menuconfirm')
        love.system.openURL("https://github.com/MrZ626/ZenithClicker")
    end
    ZENITHA._cursor.active = true
    return true
end

local gc = love.graphics
local gc_push, gc_pop = gc.push, gc.pop
local gc_replaceTransform = gc.replaceTransform
local gc_translate, gc_scale = gc.translate, gc.scale
local gc_setShader, gc_setColor, gc_setLineWidth = gc.setShader, gc.setColor, gc.setLineWidth
local gc_rectangle, gc_print = gc.rectangle, gc.print
local gc_stc_reset, gc_stc_rect, gc_stc_stop = GC.stc_reset, GC.stc_rect, GC.stc_stop
local gc_setAlpha = GC.setAlpha
local setFont = FONT.set
function scene.draw()
    DrawBG(26)

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
        gc_print("CLICKER CHANNEL", 15, 68, 0, 1, -1)
    else
        gc_print("CLICKER CHANNEL", 15, 0)
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
    gc_print("WELCOME TO CLICKER CHANNEL!", 15, -45, 0, .85, 1)
end

local texture_chn = TEXTURE.channel
local sd = SHADER.swapRG
local buttonContent = {
    function(w, h)
        gc_setColor(1, 1, 1)
        if colorRev then gc_setShader(sd) end
        GC.mDraw(texture_chn.achievements, w / 2, h / 2, 0, w / texture_chn.achievements:getWidth())
        if colorRev then gc_setShader() end
        gc_setColor(0, 0, 0, .42)
        gc_print("ACHIEVEMENTS", 22, 6 + 6, 0, .9)
        gc_print("VIEW YOUR ACHIEVEMENTS AND THEIR PROGRESS", 26, 62 + 3, 0, .36)
        gc_setColor(clr.LT)
        gc_print("ACHIEVEMENTS", 22, 6, 0, .9)
        gc_print("VIEW YOUR ACHIEVEMENTS AND THEIR PROGRESS", 26, 62, 0, .36)
    end,
    function(w, h)
        gc_setColor(1, 1, 1)
        if colorRev then gc_setShader(sd) end
        GC.mDraw(texture_chn.records, w / 2, h / 2, 0, w / texture_chn.records:getWidth())
        if colorRev then gc_setShader() end
        gc_setColor(1, 1, 1, .062)
        gc_print(STAT.uid, 62, -100, 0, 2.6, 5, 0, 0, -.26)
        gc_setColor(0, 0, 0, .42)
        gc_print("PERSONAL RECORDS", 22, 6 + 6, 0, .9)
        gc_print("VIEW YOUR OWN RECORDS", 26, 62 + 3, 0, .36)
        gc_setColor(clr.LT)
        gc_print("PERSONAL RECORDS", 22, 6, 0, .9)
        gc_print("VIEW YOUR OWN RECORDS", 26, 62, 0, .36)
    end,
    function(w, h)
        gc_setColor(1, 1, 1)
        if colorRev then gc_setShader(sd) end
        GC.mDraw(texture_chn.splits, w / 2, h * .26, 0, w / texture_chn.splits:getWidth() * 2)
        if colorRev then gc_setShader() end
        gc_setColor(0, 0, 0, .42)
        gc_print("SPEEDRUN SPLITS", 22, 6 + 6, 0, .9)
        gc_print("VIEW YOUR SPEEDRUN SPLITS", 26, 62 + 3, 0, .36)
        gc_setColor(clr.LT)
        gc_print("SPEEDRUN SPLITS", 22, 6, 0, .9)
        gc_print("VIEW YOUR SPEEDRUN SPLITS", 26, 62, 0, .36)
    end,
    function(w, h)
        gc_setColor(1, 1, 1)
        if colorRev then gc_setShader(sd) end
        GC.mDraw(texture_chn.leaderboard, w / 2, h / 2, 0, w / texture_chn.leaderboard:getWidth())
        if colorRev then gc_setShader() end
        gc_setColor(0, 0, 0, .42)
        gc_print("LEADERBOARDS", 22, 6 + 6, 0, .9)
        gc_print("VIEW THE DAILY CHALLENGE LEADERBOARDS", 26, 62 + 3, 0, .36)
        gc_setColor(clr.LT)
        gc_print("LEADERBOARDS", 22, 6, 0, .9)
        gc_print("VIEW THE DAILY CHALLENGE LEADERBOARDS", 26, 62, 0, .36)
    end,
    function(w, h)
        -- gc_setColor(1, 1, 1)
        -- if colorRev then gc_setShader(sd) end
        -- GC.mDraw(texture_chn.leaderboard, w / 2, h / 2, 0, w / texture_chn.leaderboard:getWidth())
        -- if colorRev then gc_setShader() end
        gc_setColor(0, 0, 0, .42)
        gc_print("DISCORD", 22, 6 + 6, 0, .9)
        gc_print("JOIN OUR DISCORD COMMUNITY", 26, 62 + 3, 0, .36)
        gc_setColor(clr.LT)
        gc_print("DISCORD", 22, 6, 0, .9)
        gc_print("JOIN OUR DISCORD COMMUNITY", 26, 62, 0, .36)
    end,
    function(w, h)
        -- gc_setColor(1, 1, 1)
        -- if colorRev then gc_setShader(sd) end
        -- GC.mDraw(texture_chn.leaderboard, w / 2, h / 2, 0, w / texture_chn.leaderboard:getWidth())
        -- if colorRev then gc_setShader() end
        gc_setColor(0, 0, 0, .42)
        gc_print("GITHUB", 22, 6 + 6, 0, .9)
        gc_print("OPEN THE GITHUB REPOSITORY", 26, 62 + 3, 0, .36)
        gc_setColor(clr.LT)
        gc_print("GITHUB", 22, 6, 0, .9)
        gc_print("OPEN THE GITHUB REPOSITORY", 26, 62, 0, .36)
    end,
}
function scene.overDraw()
    gc_replaceTransform(SCR.xOy)
    gc_setLineWidth(10)
    gc_setColor(1, 0, 0)
    for i = 1, #buttonContent do
        local W = scene.widgetList[i]
        gc_push()
        gc_translate(W._x, W._y)
        if W._pressTime > 0 then gc_scale(1 - W._pressTime / W._pressTimeMax * .0626) end
        gc_translate(-W.w / 2, -W.h / 2)
        gc_stc_reset()
        gc_stc_rect(0, 0, W.w, W.h)
        setFont(50)
        buttonContent[i](W.w, W.h)
        if W._hoverTime > 0 then
            gc_setColor(1, 1, 1, W._hoverTime / W._hoverTimeMax * .0626)
            gc_rectangle('fill', 0, 0, W.w, W.h)
        end
        gc_stc_stop()
        gc_pop()
    end
end

local btnY = -260
local btnW = 1100
local btnH = 160
local gap = 20

scene.widgetList = {
    WIDGET.new {
        type = 'button',
        pos = { .5, .5 }, x = 0, y = btnY, w = btnW, h = btnH - gap,
        color = clr.button,
        sound_hover = 'menutap',
        onClick = function() love.keypressed('1') end,
    },
    WIDGET.new {
        type = 'button',
        pos = { .5, .5 }, x = 0, y = btnY + btnH, w = btnW, h = btnH - gap,
        color = clr.button,
        sound_hover = 'menutap',
        onClick = function() love.keypressed('2') end,
    },
    WIDGET.new {
        type = 'button',
        pos = { .5, .5 }, x = (-btnW - gap) / 4, y = btnY + 2 * btnH, w = (btnW - gap) / 2, h = btnH - gap,
        color = clr.button,
        sound_hover = 'menutap',
        onClick = function() love.keypressed('3') end,
    },
    WIDGET.new {
        type = 'button',
        pos = { .5, .5 }, x = (btnW + gap) / 4, y = btnY + 2 * btnH, w = (btnW - gap) / 2, h = btnH - gap,
        color = clr.button,
        sound_hover = 'menutap',
        onClick = function() love.keypressed('4') end,
    },
    WIDGET.new {
        type = 'button',
        pos = { .5, .5 }, x = (-btnW - gap) / 4, y = btnY + 3 * btnH, w = (btnW - gap) / 2, h = btnH - gap,
        color = clr.button,
        sound_hover = 'menutap',
        onClick = function() love.keypressed('5') end,
    },
    WIDGET.new {
        type = 'button',
        pos = { .5, .5 }, x = (btnW + gap) / 4, y = btnY + 3 * btnH, w = (btnW - gap) / 2, h = btnH - gap,
        color = clr.button,
        sound_hover = 'menutap',
        onClick = function() love.keypressed('6') end,
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
