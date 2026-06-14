---@type Zenitha.Scene
local scene = {}

local clr = {
    D = { COLOR.HEX '19311EFF' },
    L = { COLOR.HEX '4DA667FF' },
    T = { COLOR.HEX '6FAC82FF' },
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
    end
    ZENITHA._cursor.active = true
    return true
end

local gc = love.graphics
local gc_replaceTransform = gc.replaceTransform
local gc_setColor, gc_rectangle, gc_print = gc.setColor, gc.rectangle, gc.print
local gc_setAlpha = GC.setAlpha
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
    FONT.set(50)
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
    FONT.set(30)
    gc_print("WELCOME TO CLICKER CHANNEL!", 15, -45, 0, .85, 1)
end

local startY = -260
local dy = 170
local gap = 30

scene.widgetList = {
    WIDGET.new {
        type = 'button',
        pos = { .5, .5 }, x = 0, y = startY, w = 1000, h = dy - gap,
        color = clr.button,
        sound_hover = 'menutap',
        onClick = function() love.keypressed('1') end,
    },
    WIDGET.new {
        type = 'button',
        pos = { .5, .5 }, x = 0, y = startY + 1 * dy, w = 1000, h = dy - gap,
        color = clr.button,
        sound_hover = 'menutap',
        onClick = function() love.keypressed('2') end,
    },
    WIDGET.new {
        type = 'button',
        pos = { .5, .5 }, x = -250 - gap / 4, y = startY + 2 * dy, w = 500 - gap / 2, h = dy - gap,
        color = clr.button,
        sound_hover = 'menutap',
        onClick = function() love.keypressed('3') end,
    },
    WIDGET.new {
        type = 'button',
        pos = { .5, .5 }, x = 250 + gap / 4, y = startY + 2 * dy, w = 500 - gap / 2, h = dy - gap,
        color = clr.button,
        sound_hover = 'menutap',
        onClick = function() love.keypressed('4') end,
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
