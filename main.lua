love.window.setFullscreen(true)
love.window.setIcon(love.image.newImageData('assets/icon.png'))

require 'Zenitha'

ZENITHA.setMainLoopSpeed(240)
ZENITHA.setRenderRate(50)
ZENITHA.setShowFPS(false)
ZENITHA.setVersionText(require 'version'.appVer)
ZENITHA.setClickDist(62)

STRING.install()

SCR.setSize(1600, 1000)

MSG.setSafeY(75)
MSG.addCategory('dark', COLOR.lD, COLOR.L)

---@return love.Texture
local function p(path) return 'assets/' .. path end
TEXTURE = {
    star0 = p 'crystal-dark.png',
    star1 = p 'crystal.png',
    glass_a = p 'glass-a.png',
    glass_b = p 'glass-b.png',
    throb_a = p 'throb-a.png',
    throb_b = p 'throb-b.png',
    EX = { lock = p 'lockover-9.png', front = p 'expert.png', back = p 'expert-back.png', throb = p 'expert-throb.png', },
    NH = { lock = p 'lockfull-2.png', front = p 'nohold.png', back = p 'nohold-back.png', throb = p 'nohold-throb.png', },
    MS = { lock = p 'lockfull-3.png', front = p 'messy.png', back = p 'messy-back.png', throb = p 'messy-throb.png', },
    GV = { lock = p 'lockfull-4.png', front = p 'gravity.png', back = p 'gravity-back.png', throb = p 'gravity-throb.png', },
    VL = { lock = p 'lockfull-5.png', front = p 'volatile.png', back = p 'volatile-back.png', throb = p 'volatile-throb.png', },
    DH = { lock = p 'lockfull-6.png', front = p 'doublehole.png', back = p 'doublehole-back.png', throb = p 'doublehole-throb.png', },
    IN = { lock = p 'lockfull-7.png', front = p 'invisible.png', back = p 'invisible-back.png', throb = p 'invisible-throb.png', },
    AS = { lock = p 'lockfull-8.png', front = p 'allspin.png', back = p 'allspin-back.png', throb = p 'allspin-throb.png', },
    DP = { lock = p 'lockover-supporter.png', front = p 'duo.png', back = p 'duo-back.png', throb = p 'duo-throb.png', },
    floorBG = { p '1fa.jpg', p '2fa.jpg', p '3fa.jpg', p '4fa.jpg', p '5fa.jpg', p '6fa.jpg', p '7fa.jpg', p '8fa.jpg', p '9fa.jpg', p '10fa.jpg' },
}
local transition = { w = 128, h = 1 }
for x = 0, 127 do
    table.insert(transition, { 'setCL', 1, 1, 1, 1 - x / 128 })
    table.insert(transition, { 'fRect', x, 0, 1, 1 })
end
TEXTURE.transition = GC.load(transition)
TEXTURE = IMG.init(TEXTURE, true)

local fontNotLoaded = MATH.roll(.62)
if fontNotLoaded then
    FONT.load {
        tnr = "assets/Times New Roman.ttf",
    }
    FONT.setDefaultFont('tnr')
end
TEXTS = {
    mod        = GC.newText(FONT.get(30)),
    title      = GC.newText(FONT.get(50), "EXPERT QUICK PICK"),
    load       = GC.newText(FONT.get(60), "JOINING ROOM..."),
    pb         = GC.newText(FONT.get(50)),
    sr         = GC.newText(FONT.get(50)),
    endHeight  = GC.newText(FONT.get(50)),
    endTime    = GC.newText(FONT.get(30)),
    prevPB     = GC.newText(FONT.get(50), "PB"),
    height     = GC.newText(FONT.get(30, '_mono')),
    time       = GC.newText(FONT.get(30, '_mono')),
    chain      = GC.newText(FONT.get(50)),
    b2b        = GC.newText(FONT.get(30), "B2B x"),
    gigaspeed  = GC.newText(FONT.get(50), {
        COLOR.R, "G", COLOR.O, "I", COLOR.Y, "G",
        COLOR.K, "A", COLOR.G, "S", COLOR.J, "P",
        COLOR.C, "E", COLOR.S, "E", COLOR.B, "D" }),
    gigatime   = GC.newText(FONT.get(50, '_mono')),
    slogan     = GC.newText(FONT.get(30), "CROWD THE TOWER!"),
    slogan_EX  = GC.newText(FONT.get(30), "THRONG THE TOWER!"),
    slogan_rEX = GC.newText(FONT.get(30), "OVERFLOW THE TOWER!"),
    credit     = GC.newText(FONT.get(30), "All assets from TETR.IO, see the help page"),
}
if fontNotLoaded then
    TASK.new(function()
        local t = love.timer.getTime()
        local delay = MATH.roll(.9626) and MATH.rand(2.6, 6.26) or 26
        while love.timer.getTime() - t < delay do
            coroutine.yield()
            if GAME.anyRev then
                TASK.yieldT(0.26)
                SFX.play('staffsilence')
                MSG('dark', "A DARK FORCE INTERRUPTED THE FONT LOADING")
                return
            end
        end
        FONT.setDefaultFont('_norm')
        local scale = 60 / TEXTS.load:getFont():getHeight()
        for _, text in next, TEXTS do text:setFont(FONT.get(MATH.roundUnit(text:getFont():getHeight() * scale, 10))) end
        for _, quest in next, GAME.quests do quest.name:setFont(FONT.get(60)) end
        WIDGET._reset()
        TEXTS.height:setFont(FONT.get(30, '_mono'))
        TEXTS.time:setFont(FONT.get(30, '_mono'))
        TEXTS.gigatime:setFont(FONT.get(50, '_mono'))
    end)
end

local _DATA = {
    highScore = setmetatable({}, { __index = function() return 0 end }),
    speedrun = setmetatable({}, { __index = function() return 1e99 end }),
    maxFloor = 1,
}

DATA = setmetatable({
    load = function() TABLE.update(_DATA, FILE.load('data.luaon', '-luaon -canskip') or NONE) end,
    save = function() love.filesystem.write('data.luaon', TABLE.dumpDeflate(_DATA)) end,
}, {
    __index = _DATA,
    __newindex = function(_, k, v)
        _DATA[k] = v
        DATA.save()
    end,
})

MX, MY = 0, 0

---@type Map<Card>
Cards = {}

---@type nil|number
FloatOnCard = nil

Background = {
    floor = 2,
    alpha = 0,
    quad = GC.newQuad(0, 0, 1920, 1080, 1920, 1080)
}
GigaSpeed = {
    r = 0,
    g = 0,
    b = 0,
    alpha = 0,
    bgAlpha = 0,
    textTimer = false,
}
ImpactGlow = {}
DeckPress = 0
ThrobAlpha = {
    card = 0,
    bg1 = 0,
    bg2 = 0,
}
Wind = {}
WindBatch = GC.newSpriteBatch(GC.load { w = 1, h = 1, { 'clear', 1, 1, 1, 1 } }, 260, 'static')
for i = 1, 62 do
    Wind[i] = { math.random(), math.random(), MATH.clampInterpolate(1, 0.5, 260, 2.6, i) }
    WindBatch:add(0, 0)
end

BgmSets = {
    all = {
        'piano',
        'arp', 'bass', 'guitar', 'pad', 'staccato', 'violin',
        'expert', 'rev',
        'piano2', 'violin2',
    },
    assist = { 'arp', 'bass', 'guitar', 'pad', 'staccato', 'violin' },
}
DeckData = {
    { id = 'EX', initOrder = 1, lockfull = false },
    { id = 'NH', initOrder = 2, lockfull = true },
    { id = 'MS', initOrder = 3, lockfull = true },
    { id = 'GV', initOrder = 4, lockfull = true },
    { id = 'VL', initOrder = 5, lockfull = true },
    { id = 'DH', initOrder = 6, lockfull = true },
    { id = 'IN', initOrder = 7, lockfull = true },
    { id = 'AS', initOrder = 8, lockfull = true },
    { id = 'DP', initOrder = 9, lockfull = false },
}
ModData = {
    name = {
        EX = 'expert',
        NH = 'nohold',
        MS = 'messy',
        GV = 'gravity',
        VL = 'volatile',
        DH = 'doublehole',
        IN = 'invisible',
        AS = 'allspin',
        DP = 'duo',
    },
    fullName = {
        EX = "< EXPERT MODE >",
        NH = "< NO HOLD >",
        MS = "< MESSIER GARBAGE  >",
        GV = "< GRAVITY >",
        VL = "< VOLATILE GARBAGE >",
        DH = "< DOUBLE HOLE GARBAGE >",
        IN = "< INVISIBLE >",
        AS = "< ALL-SPIN >",
        DP = "< DUO >",
        lock = "< LOCKED >",
        lockDP = "< LOCKED? >",
    },
    desc = {
        EX = "A LESS LENIENT CHALLENGE, FOR THOSE WHO DARE",
        NH = "CANCELING IS DISABLED",
        MS = "TAROTS WILL BE SHUFFLED BY FLOOR",
        GV = "AUTO COMMITTING, TIMED BY FLOOR",
        VL = "LARGER GAPS BETWEEN TAROTS, BUT MUST CLICK TWICE",
        DH = "COMBOS WILL SPAWN HARDER",
        IN = "TAROTS FACE DOWN AND HINTS FLASH ONCE EVERY TWO SECONDS",
        AS = "KEYBOARD AVAILABLE, BUT DOUBLE CLICKING IS PENALIZED",
        DP = "FLOOD THE TOWER WITH SOMEONE DOESN'T EXIST",
        lock = "REACH HIGHER FLOOR TO UNLOCK",
        lockDP = "MASTER THIS MOD TO UNLOCK",
    },
    revName = {
        EX = "> THE TYRANT <",
        NH = "> ASCETICISM <",
        MS = "> LOADED DICE <",
        GV = "> FREEFALL <",
        VL = "> LAST STAND <",
        DH = "> DAMNATION <",
        IN = "> THE EXILE <",
        AS = "> THE WARLOCK <",
        DP = "> BLEEDING HEARTS <",
    },
    revDesc = {
        EX = "FEAR, OPPRESSION, AND LIMITLESS AMBITION.",
        NH = "A DETACHMENT FROM EVEN THAT WHICH IS MODERATE.",
        MS = "IN A RIGGED GAME, YOUR MIND IS THE ONLY FAIR ADVANTAGE.",
        GV = "THE GROUND YOU STOOD ON NEVER EXISTED IN THE FIRST PLACE.",
        VL = "STRENGTH ISN'T NECESSARY FOR THOSE WITH NOTHING TO LOSE.",
        DH = "NO MORE SECOND CHANCES.",
        IN = "NEVER UNDERESTIMATE BLIND FAITH.",
        AS = "INTO REALMS BEYOND HEAVEN AND EARTH.",
        DP = "EVEN AS WE BLEED, WE KEEP HOLDING ON...",
    },
    weight = {
        EX = 13, --  8 + 5
        NH = 12, --  8 + 4
        MS = 14, -- 10 + 4
        GV = 12, -- 10 + 2
        VL = 17, -- 15 + 2
        DH = 12, --  8 + 4
        IN = 7,  --  6 + 1
        AS = 13, -- 10 + 3
        DP = 4,  --  3 + 1
    },
    color = {
        EX = { COLOR.HEX "89590B" },
        NH = { COLOR.HEX "FF00D4" },
        MS = { COLOR.HEX "FFB400" },
        GV = { COLOR.HEX "FFFF00" },
        VL = { COLOR.HEX "FF1500" },
        DH = { COLOR.HEX "47ACFF" },
        IN = { COLOR.HEX "BD24FF" },
        AS = { COLOR.HEX "00FED4" },
        DP = { COLOR.HEX "FF8C9D" },
    },
    textColor = {
        EX = { COLOR.HEX "C29F68" },
        NH = { COLOR.HEX "FF8BEC" },
        MS = { COLOR.HEX "FFD572" },
        GV = { COLOR.HEX "F7FF8A" },
        VL = { COLOR.HEX "FF978D" },
        DH = { COLOR.HEX "A6D5FF" },
        IN = { COLOR.HEX "E8B3FF" },
        AS = { COLOR.HEX "93FFE0" },
        DP = { COLOR.HEX "FFC0C9" },
    },
    prio = { IN = 0, MS = 1, VL = 2, NH = 3, DH = 4, AS = 5, GV = 6, EX = 7, DP = 8, rIN = 0, rMS = 1, rVL = 2, rNH = 3, rDH = 4, rAS = 5, rGV = 6, rEX = 7, rDP = 8 },
    adj = {
        IN = "INVISIBLE",
        MS = "MESSY",
        VL = "VOLATILE",
        NH = "HOLDLESS",
        DH = "DOUBLE HOLE",
        AS = "ALL-SPIN",
        GV = "GRAVITY",
        EX = "EXPERT",
        DP = "DUO",
        rIN = "BELIEVED",
        rMS = "DECEPTIVE",
        rVL = "DESPERATE",
        rNH = "ASCENDANT",
        rDH = "DAMNED",
        rAS = "OMNI-SPIN",
        rGV = "COLLAPSED",
        rEX = "TYRANNICAL",
        rDP = "PIERCING",
    },
    noun = {
        IN = "INVISIBLITY",
        MS = "MESSINESS",
        VL = "VOLATILITY",
        NH = "NO HOLD",
        DH = "DOUBLE HOLE",
        AS = "ALL-SPIN",
        GV = "GRAVITY",
        EX = "EXPERT",
        DP = "DUO",
        rIN = "BELIEF",
        rMS = "DECEPTION",
        rVL = "DESPERATION",
        rNH = "ASCENSION",
        rDH = "DAMNATION",
        rAS = "OMNI-SPIN",
        rGV = "COLLAPSE",
        rEX = "TYRANNY",
        rDP = "HEARTACHE",
    },
}

BasicComboCount = 9
Combos = require "module/combo_data"
for i = 1, #Combos do
    local cmb = Combos[i]
    cmb.name = '"' .. cmb.name:upper() .. '"'
    local cmbStr = table.concat(TABLE.sort(cmb.set:trim():split('%s+', true)), ' ')
    Combos[cmbStr] = Combos[cmbStr] or cmb
end

Floors = {
    { top = 50,   event = {},                                                 name = "Hall of Beginnings" },
    { top = 150,  event = { 'dmgDelay', -2, 'dmgWrong', 1 },                  name = "The Hotel" },
    { top = 300,  event = { 'dmgDelay', -2, 'dmgCycle', -.5 },                name = "The Casino" },
    { top = 450,  event = { 'dmgDelay', -1, 'dmgCycle', -.5 },                name = "The Arena" },
    { top = 650,  event = { 'dmgDelay', -1, 'dmgCycle', -.5, 'dmgWrong', 1 }, name = "The Museum" },
    { top = 850,  event = { 'dmgDelay', -1, 'dmgTime', 1 },                   name = "Abandoned Offices" },
    { top = 1100, event = { 'dmgDelay', -1, 'dmgCycle', -.5 },                name = "The Laboratory" },
    { top = 1350, event = { 'dmgDelay', -1, 'dmgCycle', -.5 },                name = "The Core" },
    { top = 1650, event = { 'dmgDelay', -.5, 'dmgWrong', 1 },                 name = "Corruption" },
    { top = 1e99, event = { 'dmgDelay', -.5, 'dmgCycle', -.5, 'dmgTime', 1 }, name = "Platform of The Gods" },
    -- Initial: Delay=15. Cycle=5, Wrong=1
    -- Total: Delay-10, Cycle-3, Wrong+4
}

Fatigue = {
    normal = {
        { time = 300, event = { 'dmgTimeMul', -.1 }, text = "FATIGUE SETS IN…", desc = "DmgDelay--" },
        { time = 330, event = { 'dmgCycle', -.5, 'dmgWrong', 1 }, text = "YOUR BODY GROWS WEAK…", desc = "DmgCycle--   Damage++" },
        { time = 360, event = { 'dmgTimeMul', -.1, 'dmgHeal', -1 }, text = "ALL SENSES BLUR TOGETHER…", desc = "DmgDelay--   Heal--" },
        { time = 390, event = { 'dmgTimeMul', -.1, 'dmgWrong', 1 }, text = "YOUR CONSCIOUSNESS FADES…", desc = "DmgDelay--   DmgCycle--" },
        { time = 420, event = { 'dmgTimeMul', -.2, 'dmgCycle', -.5 }, text = "THIS IS THE END", desc = "DmgDelay--   Damage++" },
        { time = 1e99 }, -- Total: dmgTimeMul-50%, Cycle-1, Wrong+2
    },
    rEX = {
        { time = 240, event = { 'dmgTimeMul', -.2 }, text = "YOUR POWER SLIPS…", desc = "DmgDelay--" },
        { time = 270, event = { 'dmgWrong', 2 }, text = "WHISPERS OF DISCONTENT SPREAD…", desc = "Damage++" },
        { time = 300, event = { 'dmgCycle', -1 }, text = "PROTESTERS LINE THE STREETS…", desc = "DmgCycle--" },
        { time = 330, event = { 'dmgTimeMul', -.2, 'dmgWrong', 2, }, text = "YOUR CLOSEST ALLIES DEFECT…", desc = "DmgDelay--   Damage++" },
        { time = 360, event = { 'dmgTimeMul', -.2, 'dmgHeal', -1 }, text = "PARANOIA CLOUDS YOUR JUDGEMENT…", desc = "DmgCycle--   Heal--" },
        { time = 390, event = { 'dmgCycle', -.5, 'dmgWrong', 1 }, text = "THE REVOLUTION HAS BEGUN…", desc = "DmgDelay--   Damage++" },
        { time = 420, event = { 'dmgTimeMul', -.3 }, text = "THE END OF AN ERA", desc = "DmgDelay--" },
        { time = 1e99 }, -- Total: dmgTimeMul-90%, Cycle-1, Wrong+5
    },
    rDP = {
        { time = 030, event = {}, text = [[THE RELATIONSHIP STAGNATES…]] }, -- garbage becomes a bit messier
        { time = 060, event = {}, text = [[INSECURITIES GROW STRONGER…]] }, -- garbage becomes messier
        { time = 090, event = {}, text = [[%p2 FEELS NEGLECTED…]] }, -- garbage becomes much messier
        { time = 120, event = {}, text = [[%p1 SUCCESSFULLY APOLOGIZES…?]] }, -- garbage becomes a bit cleaner
        { time = 150, event = {}, text = [[THINGS ARE BACK TO HOW THEY SHOULD BE…!]] }, -- garbage becomes much cleaner
        { time = 180, event = {}, text = [[THE WEIGHT OF WORDS UNSPOKEN…]] }, -- garbage becomes messier
        { time = 210, event = {}, text = [["WHY CAN'T YOU JUST LISTEN TO ME?"]] }, -- garbage becomes much messier
        { time = 240, event = {}, text = [["THIS IS ALL YOUR FAULT".]] }, -- revive difficulty increased
        { time = 270, event = {}, text = [[%p2 MAKES THE SAME PROMISE AGAIN…]] }, -- garbage becomes cleaner
        { time = 300, event = {}, text = [["THIS TIME WILL BE DIFFERENT."]] }, -- +4 PERMANENT GARBAGE
        { time = 330, event = {}, text = [[SOME HABITS CAN'T BE BROKEN…]] }, -- garbage becomes much messier
        { time = 360, event = {}, text = [[ALL TRUST HAS WITHERED AWAY…]] }, -- garbage becomes messier
        { time = 390, event = {}, text = [[%p1 SETS AN ULTIMATUM…]] }, -- garbage becomes messier
        { time = 420, event = {}, text = [[%p2 CONTEMPLATES THEIR WASTED EFFORT…]] }, -- garbage becomes messier
        { time = 450, event = {}, text = [[ONE LAST PAINFUL ARGUMENT…]] }, -- receive 25% more garbage
        { time = 480, event = {}, text = [[GOODBYE.]] }, -- you can no longer revive
        { time = 510, event = {}, text = [["I MISS YOU"]] }, -- garbage becomes much cleaner
        { time = 540, event = {}, text = [[WHAT IF…?]] }, -- garbage becomes a bit cleaner
        { time = 570, event = {}, text = [[…]] }, -- +12 PERMANENT GARBAGE
        { time = 1e99 },
    },
}

GravityTimer = {
    { 9.0, 8.0, 7.5, 7.0, 6.5, 6.0, 5.5, 5.0, 4.5, 4.0 },
    { 3.2, 3.0, 2.8, 2.6, 2.5, 2.4, 2.3, 2.2, 2.1, 2.0 },
}

GigaSpeedReq = { [0] = 7, 8, 8, 9, 9, 10, 1e99, 1e99, 1e99, 1e99, 1e99 }

GAME = require 'module/game'

for i = 1, #DeckData do table.insert(Cards, require 'module/card'.new(DeckData[i])) end
GAME.refreshLayout()
for i, C in ipairs(Cards) do
    Cards[C.id], C.x, C.y = C, C.tx, C.ty + 260 + 26 * 1.6 ^ i
end

SCN.add('tower', require 'module/tower')
SCN.add('joining', require 'module/joining')
ZENITHA.setFirstScene('joining')

ZENITHA.globalEvent.drawCursor = NULL
ZENITHA.globalEvent.clickFX = NULL

local _keyDown_orig = ZENITHA.globalEvent.keyDown
function ZENITHA.globalEvent.keyDown(key)
    if _keyDown_orig(key) then return true end
    if key == 'f11' then
        love.window.setFullscreen(not love.window.getFullscreen())
        return true
    elseif key == 'f12' then
        MSG('check', "Zenith Clicker is powered by Love2d & Zenitha, not Web!")
        return true
    end
end

local gc = love.graphics
function WIDGET._prototype.button:draw()
    gc.push('transform')
    gc.translate(self._x, self._y + DeckPress)

    if self._pressTime > 0 then
        gc.scale(1 - self._pressTime / self._pressTimeMax * .0626)
    end
    local w, h = self.w, self.h

    local fillC = self.fillColor
    local frameC = self.frameColor

    -- Background
    gc.setColor(fillC[1], fillC[2], fillC[3], fillC[4])
    GC.mRect('fill', 0, 0, w, h)

    -- Frame
    gc.setLineWidth(3)
    gc.setColor(frameC[1] * .2, frameC[2] * .2, frameC[3] * .2)
    gc.line(-w / 2, h / 2, w / 2, h / 2, w / 2, -h / 2 - 1.5)
    gc.setColor(.2 + frameC[1] * .8, .2 + frameC[2] * .8, .2 + frameC[3] * .8)
    gc.line(-w / 2, h / 2 + 1.5, -w / 2, -h / 2, w / 2 - 1.5, -h / 2)

    -- Highlight
    if self._hoverTime > 0 then
        gc.setColor(1, 1, 1, self._hoverTime / self._hoverTimeMax * .16)
        GC.mRect('fill', 0, 0, w - 3, h - 3)
    end

    -- Drawable
    gc.setColor(self.textColor)
    WIDGET._alignDraw(self, self._text, 0, 0, nil, 1, 1.15 * (1 - 2 * GAME.revTimer))

    gc.pop()
end

-- Muisc syncing daemon
function Daemon_Sync()
    local lib = BGM._srcLib
    local set = BgmSets.all
    coroutine.yield()
    local length = BGM.getDuration()
    while true do
        local t0 = lib[set[1]].source:tell()
        for i = #set, 2, -1 do
            local obj = lib[set[i]]
            local T = t0
            if set[i] == 'piano2' then T = T * 2 % length end
            if set[i] == 'violin2' then T = (T - 4 * 60 / 184) % length end
            if math.abs(obj.source:tell() - T) > 0.026 then
                -- print('Desync', set[i])
                obj.source:seek(T)
            end
        end
        TASK.yieldT(1)
    end
end

-- Throb tranpaency daemon
-- Messy position daemon
-- Expert guitar randomization daemon
function Daemon_Beat()
    local bar = 2 * 60 / 184 * 4
    local t1, step1 = -.1, 2 * 60 / 184
    local t2, step2 = 0, 2 * 60 / 184 / 4
    while true do
        local T = BGM.tell()
        ThrobAlpha.card = math.max(.626 - 2 * T / bar % 1, .626 - 2 * (T / bar - .375) % 1)
        ThrobAlpha.bg1 = .626 - 2 * T / bar % 1
        ThrobAlpha.bg2 = .626 - 2 * (T / bar - 1 / 32) % 1

        GigaSpeed.r, GigaSpeed.g, GigaSpeed.b = COLOR.HSV(T / bar % 1, .626, 1)
        GigaSpeed.bgAlpha = 1 - 4 * T / bar % 1

        if T < t1 then t1 = -.1 end
        if T > t1 + step1 then
            t1 = t1 + step1
            for i = 1, 9 do
                Cards[i].visY = GAME.mod.MS * math.random(-6, 2)
            end
            GAME.refreshLayout()
        end

        if T < t2 then t2 = 0 end
        if T > t2 + step2 then
            t2 = t2 + step2
            if not GAME.playing and GAME.mod.EX > 0 and not GAME.anyRev then
                local v = MATH.roll(GAME.mod.EX == 1 and .26 or .626)
                BGM.set('expert', 'volume', v and MATH.rand(.42, .626) or 0, v and 0 or .1)
            end
        end
        coroutine.yield()
    end
end

-- Background transition deamon
function Daemon_Floor()
    local bg = Background
    while true do
        repeat TASK.yieldT(.1) until bg.floor ~= GAME.floor
        repeat
            bg.alpha = bg.alpha - coroutine.yield()
        until bg.alpha <= 0
        bg.floor = GAME.floor
        bg.alpha = 0
        repeat
            bg.alpha = bg.alpha + coroutine.yield()
        until bg.alpha >= 1
        bg.alpha = 1
    end
end

-- Load data
DATA.load()
local oldVer = DATA.version
if DATA.version == nil then
    for k in next, DATA.highScore do
        if k:find('rNH') or k:find('rMS') or k:find('rVL') or k:find('rAS') then
            DATA.highScore[k] = nil
        end
    end
    DATA.version = 162
end
if DATA.version == 162 then
    DATA.speedrun = {}
    DATA.version = 163
end
if DATA.version ~= oldVer then DATA.save() end

-- Some Initialization
for i = 1, #Cards do
    local f10 = Floors[9].top
    local id = Cards[i].id
    local rid = 'r' .. id
    if DATA.highScore[rid] >= f10 then
        GAME.completion[id] = 2
    else
        for cmb, h in next, DATA.highScore do
            if h >= f10 and cmb:find(rid) then
                GAME.completion[id] = 2
                break
            end
        end
    end
    if GAME.completion[id] ~= 2 then
        if DATA.highScore[id] >= f10 then
            GAME.completion[id] = 1
        else
            for cmb, h in next, DATA.highScore do
                if h >= f10 and (cmb:gsub('r', ''):find(id) or 0) % 2 == 1 then
                    GAME.completion[id] = 1
                    break
                end
            end
        end
    end
end
GAME.refreshLockState()
GAME.refreshPBText()

-- Test
TASK.new(function()
    for _, s in next, ([[ ]]):trim():split('%s+', true) do
        TASK.yieldT(1)
        SFX.play(s)
    end
end)

if SYSTEM == 'Web' then
    _G[('DiscordRPC')] = { update = NULL, setEnable = NULL }
else
    DiscordRPC = require 'module/discordRPC'
    DiscordRPC.setEnable(true)
    DiscordRPC.update {
        details = "QUICK PICK",
        state = "Enjoying Music",
    }
end
