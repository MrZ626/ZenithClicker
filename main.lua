love.window.setIcon(love.image.newImageData('assets/icon.png'))
love.mouse.setVisible(false)

require 'Zenitha'

ZENITHA.setMainLoopSpeed(240)
ZENITHA.setRenderRate(50)
ZENITHA.setAppInfo("Zenith Clicker", SYSTEM .. " " .. (require 'version'.appVer))
ZENITHA.setClickDist(62)
ZENITHA.setFirstScene('joining')
ZENITHA._cursor.speed = 1600

STRING.install()

SCR.setSize(1600, 1000)

local gc = love.graphics
local gc_push, gc_pop = gc.push, gc.pop
local gc_translate, gc_scale = gc.translate, gc.scale
local gc_rotate, gc_setShader = gc.rotate, gc.setShader
local gc_setColor, gc_setLineWidth, gc_setLineJoin = gc.setColor, gc.setLineWidth, gc.setLineJoin
local gc_draw, gc_line = gc.draw, gc.line
local gc_mRect = GC.mRect

ZENITHA.globalEvent.drawCursor = NULL
ZENITHA.globalEvent.clickFX = NULL
function ZENITHA.globalEvent.fileDrop(file)
    local data = file:read('data')
    local suc, res = pcall(gc.newImage, data)
    if suc then
        if AVATAR then AVATAR:release() end
        AVATAR = res
        love.filesystem.write('avatar', data)
        IssueAchv('identity')
        SFX.play('supporter')
        MSG('dark', "Your avatar was updated!")
    else
        MSG('dark', "Invalid image file.")
    end
    file:close()
    file:release()
    if SCN.cur == 'stat' then RefreshProfile() end
end

function ZENITHA.globalEvent.resize()
    BgScale = math.max(SCR.w / 1024, SCR.h / 640)
    StarPS:reset()
    StarPS:moveTo(0, -GAME.bgH * 2 * BgScale)
    StarPS:setEmissionArea('uniform', SCR.w * .626, SCR.h * .626)
    StarPS:setSizes(SCR.k * 1.626)
    local dt = 1 / StarPS:getEmissionRate()
    for _ = 1, StarPS:getBufferSize() do
        StarPS:emit(1)
        StarPS:update(dt)
    end
end

local function task_saveConf()
    TASK.yieldT(2.6)
    SaveConf()
end
local function confUpdate()
    TASK.removeTask_code(task_saveConf)
    TASK.new(task_saveConf)
end
local KBisDown = love.keyboard.isDown
function ZENITHA.globalEvent.keyDown(key, isRep)
    if isRep then return end
    if KBisDown('lctrl', 'rctrl') then return end
    if key == 'f12' then
        if TASK.lock('dev') then
            MSG('check', "Zenith Clicker is powered by Love2d & Zenitha, not Web!", 6.26)
        else
            ZENITHA.setDebugMode(not ZENITHA.getDebugMode() and 1 or false)
        end
    elseif key == 'f11' then
        CONF.fullscreen = not CONF.fullscreen
        love.window.setFullscreen(CONF.fullscreen)
        confUpdate()
        MSG('dark', "Fullscreen: " .. (CONF.fullscreen and "ON" or "OFF"), 1)
    elseif key == 'f10' then
        CONF.syscursor = not CONF.syscursor
        SetMouseVisible(true)
        ApplySettings()
        confUpdate()
        MSG('dark', "Star Force: " .. (CONF.syscursor and "OFF" or "ON"), 1)
    elseif key == 'f9' then
        if not GAME.zenithTraveler then CONF.bg = not CONF.bg end
        confUpdate()
        MSG('dark', "BG: " .. (CONF.bg and "ON" or "OFF"), 1)
    elseif key == 'f8' then
        if CONF.bgBrightness < 80 then
            CONF.bgBrightness = MATH.clamp(CONF.bgBrightness + 10, 30, 80)
            confUpdate()
            MSG('dark', "BG " .. CONF.bgBrightness .. "%", 1)
        end
    elseif key == 'f7' then
        if CONF.bgBrightness > 30 then
            CONF.bgBrightness = MATH.clamp(CONF.bgBrightness - 10, 30, 80)
            confUpdate()
            MSG('dark', "BG " .. CONF.bgBrightness .. "%", 1)
        end
    elseif key == 'f5' then
        if CONF.cardBrightness > 80 then
            CONF.cardBrightness = MATH.clamp(CONF.cardBrightness - 5, 80, 100)
            confUpdate()
            MSG('dark', "Card " .. CONF.cardBrightness .. "%", 1)
        end
    elseif key == 'f6' then
        if CONF.cardBrightness < 100 then
            CONF.cardBrightness = MATH.clamp(CONF.cardBrightness + 5, 80, 100)
            confUpdate()
            MSG('dark', "Card " .. CONF.cardBrightness .. "%", 1)
        end
    elseif key == 'f3' then
        if CONF.sfx > 0 then
            TempSFX = CONF.sfx
            CONF.sfx = 0
        else
            CONF.sfx = TempSFX or 60
            TempSFX = false
        end
        confUpdate()
        MSG('dark', CONF.sfx > 0 and "SFX ON" or "SFX OFF", 1)
        ApplySettings()
        SFX.play('menuclick')
    elseif key == 'f4' then
        if CONF.bgm > 0 then
            TempBGM = CONF.bgm
            CONF.bgm = 0
        else
            CONF.bgm = TempBGM or 100
            TempBGM = false
        end
        confUpdate()
        MSG('dark', CONF.bgm > 0 and "BGM ON" or "BGM OFF", 1)
        ApplySettings()
    end
end

function ZENITHA.globalEvent.quit() SaveStat() end

local function task_autoSoundOff()
    coroutine.yield()
    while true do
        local dt = coroutine.yield()
        local v = math.max(love.audio.getVolume() - dt * 2.6, 0)
        love.audio.setVolume(v)
        if v == 0 then return end
    end
end
local function task_autoSoundOn()
    coroutine.yield()
    while true do
        local dt = coroutine.yield()
        local v = math.min(love.audio.getVolume() + dt * 2.6, 1)
        love.audio.setVolume(v)
        if v == 1 then return end
    end
end
function ZENITHA.globalEvent.focus(f)
    if not CONF.autoMute then return end
    if f then
        TASK.removeTask_code(task_autoSoundOff)
        TASK.new(task_autoSoundOn)
    else
        TASK.removeTask_code(task_autoSoundOn)
        TASK.new(task_autoSoundOff)
    end
end

for i = 1, 4 do SCN.scenes._console.widgetList[i].textColor = COLOR.D end

WIDGET.setDefaultOption {
    checkBox = {
        w = 40,
        labelPos = 'right',
        labelDist = 8,
        lineWidth = 2,
        sound_on = 'menuclick',
        sound_off = 'menuclick',
    },
    slider = {
        lineWidth = 2,
        _approachSpeed = 1e99,
    },
}

function WIDGET._prototype.button:draw()
    gc_push('transform')
    gc_translate(self._x, self._y + (SCN.cur == 'tower' and self.pos[1] == .5 and DeckPress or 0))

    if self._pressTime > 0 then
        gc_scale(1 - self._pressTime / self._pressTimeMax * .0626)
    end
    local w, h = self.w, self.h

    local fillC = self.fillColor
    local frameC = self.frameColor

    -- Background
    gc_setColor(fillC)
    gc_mRect('fill', 0, 0, w, h)

    -- Frame
    gc_setLineWidth(3)
    gc_setColor(frameC[1] * .42, frameC[2] * .42, frameC[3] * .42)
    gc_line(-w / 2, h / 2, w / 2, h / 2, w / 2, -h / 2 - 1.5)
    gc_setColor(.2 + frameC[1] * .8, .2 + frameC[2] * .8, .2 + frameC[3] * .8)
    gc_line(-w / 2, h / 2 + 1.5, -w / 2, -h / 2, w / 2 - 1.5, -h / 2)

    -- Drawable
    gc_setColor(self.textColor)
    WIDGET._alignDraw(self, self._text, 0, 0, 0, 1.2, 1.2 - 2.4 * GAME.revTimer)

    -- Highlight
    if self._hoverTime > 0 then
        gc_setColor(1, 1, 1, self._hoverTime / self._hoverTimeMax * .0626)
        gc_mRect('fill', 0, 0, w - 3, h - 3)
    end

    gc_pop()
end

function WIDGET._prototype.checkBox:draw()
    gc_push('transform')
    gc_translate(self._x, self._y)
    local w = self.w

    gc_setLineWidth(self.lineWidth)
    if self.disp() then
        -- Active
        gc_setColor(self.frameColor)
        gc_mRect('fill', 0, 0, w, w, 2)
        gc_setColor(0, 0, 0, .42)
        gc_line(-w / 2, w / 2, w / 2, w / 2, w / 2, -w / 2)
        gc_setColor(1, 1, 1, .62)
        gc_line(-w / 2, w / 2, -w / 2, -w / 2, w / 2, -w / 2)
        gc_setLineWidth(self.lineWidth * 2)
        gc_setLineJoin('bevel')
        gc_setColor(1, 1, 1)
        gc_line(-w * .355, 0, 0, w * .355, w * .355, -w * .355)
    else
        -- Background
        gc_setColor(self.fillColor)
        gc_mRect('fill', 0, 0, w, w, 2)
        gc_setColor(0, 0, 0, .626)
        gc_line(-w / 2, w / 2, -w / 2, -w / 2, w / 2, -w / 2)
        gc_setColor(1, 1, 1, .0626)
        gc_line(-w / 2, w / 2, w / 2, w / 2, w / 2, -w / 2)
    end

    -- Drawable
    local x2, y2 = w * .5 + self.labelDist, 0
    gc_setColor(self.textColor)
    WIDGET._alignDraw(self, self._text, x2, y2, nil, self.textScale)

    -- Highlight
    gc_setColor(1, 1, 1, self._hoverTime / self._hoverTimeMax * .0626)
    gc_mRect('fill', 0, 0, w, w, 2)

    gc_pop()
end

function WIDGET._prototype.slider:draw()
    local x, y = self._x, self._y
    local x2 = x + self.w
    local rangeL, rangeR = self._rangeL, self._rangeR

    local frameC = self.frameColor ---@cast frameC -string +Zenitha.Color

    -- Axis
    gc_setColor(frameC)
    gc_setLineWidth(self.lineWidth * 2)
    gc_line(x, y, x2, y)

    local fillC = self.fillColor

    -- Block
    local pos = MATH.clamp(self._pos, rangeL, rangeR)
    local cx = x + self.w * (pos - rangeL) / self._rangeWidth
    local bw, bh = 26, 30
    GC.ucs_move(cx, y)
    gc_setColor(fillC)
    gc_mRect('fill', 0, 0, bw, bh, self.cornerR)
    gc_setLineWidth(self.lineWidth)
    gc_setColor(0, 0, 0, .26)
    gc_line(-bw / 2, bh / 2, bw / 2, bh / 2, bw / 2, -bh / 2)
    gc_setColor(1, 1, 1, .1)
    gc_line(-bw / 2, bh / 2, -bw / 2, -bh / 2, bw / 2, -bh / 2)
    GC.ucs_back()
end

WIDGET.newClass('button_invis', 'button').draw = NULL

UTIL.time("Load & Configure & Customize Zenitha", true)
--------------------------------------------------------------

CHAR = require 'module/char'
require 'data/base'
require 'module/texture'

UTIL.time("Load gamedata & Initialize Textures", true)
--------------------------------------------------------------

Metatable = {
    best_highscore = { __index = function() return 0 end },
    best_speedrun = { __index = function() return 1e99 end },
}

CONF = {
    keybind = {
        "q", "w", "e", "r", "t", "y", "u", "i", "o",
        "a", "s", "d", "f", "g", "h", "j", "k", "l",
        "space", "z", "x", "c"
    },
    fullscreen = true,
    syscursor = false,
    cardBrightness = 90,
    bgBrightness = 40,
    bg = true,
    sfx = 60,
    bgm = 100,
    autoMute = false,
    oldHitbox = false,
}
SR = {}
LB = {}

UTIL.time("Prepare storage", true)
--------------------------------------------------------------

-- Vars: System

TestMode = false
DiscordState = {}
Cards = {} ---@type Map<Card>
CRprogress = {
    f10 = 0,
    sr = 0,
    achvGet = 0,
    achvAll = 0,
}
Daily = {
    history = {},
    historyDisp = {},
    actived = false,
    available = false,
    needSubmit = false,
}
SHADER = require 'module/shader'
GAME = require 'module/game'

-- Vars: VFX

FloatOnCard = nil ---@type number?
GigaSpeed = {
    r = 0,
    g = 0,
    b = 0,
    alpha = 0,
    bgAlpha = 0,
    textTimer = false,
    isTera = false,
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
BgScale = 1

-- Vars: Music

---@enum (key) ZC.bgmName
BgmData = {
    --[[
        # F0 (Watchful Eye)           4|4 ♩ = 184         C Minor
        # F1 (Divine Registration)    4|4 ♩ = 184         C Minor
        # F2 (Zenith Hotel)           4|4 ♩ = 110         D Major / B Minor
        # F3 (Empty Prayers)         12|8 ♩.= 120         C Major / A Minor
        # F4 (Crowd Control)          5|8 ♪ = 180         F♯ Minor
        # F5 (Phantom Memories)   4|4 6|8 ♩ = 130 ♩.= 130 E Minor
        # F6 (Echo)                   4|4 ♩ = 65          A Minor
        # F7 (Cryptic Chemistry)      4|4 ♩ = 120         A+50 Minor
        # F8 (Chrono Flux)            4|4 ♩ = 150         E Minor
        # F9 (Broken Record)          4|4 ♩ = 160         E Minor
        # F10 (Deified Validation)    4|4 ♩ = 98          C Major / C Minor
        # Hyper (Schnellfeuer Bullet) 4|4 ♩ = 240         C♯ Minor
    ]]
    f0    = { meta = '4|4  184 BPM  C Minor           ', bar = 4, bpm = 184, toneFix = 0.0, loop = { 0, 114.7826 } },
    f1    = { meta = '4|4  184 BPM  C Minor           ', bar = 4, bpm = 184, toneFix = 0.0, loop = { 18.261, 91.304 }, introLen = 1.304, teleport = { -1, 7.826 } },
    f2    = { meta = '4|4  110 BPM  D Major & B Minor ', bar = 4, bpm = 110, toneFix = -1., loop = { 26.181, 113.454 } },
    f2r   = { meta = '4|4  110 BPM  D Major & B Minor ', bar = 4, bpm = 110, toneFix = -1., loop = { 26.181, 113.454 } },
    f3    = { meta = '12|8  120 BPM  C Major & A Minor', bar = 4, bpm = 120, toneFix = -1., loop = { 56, 128 } },
    f3r   = { meta = '12|8  120 BPM  C Major & A Minor', bar = 4, bpm = 120, toneFix = -1., loop = { 56, 128 } },
    f4    = { meta = '5|8  180 BPM  F# Minor          ', bar = 5, bpm = 180, toneFix = 1.0, loop = { 13.333, 93.333 } },
    f4r   = { meta = '5|8  180 BPM  F# Minor          ', bar = 5, bpm = 180, toneFix = 1.0, loop = { 13.333, 93.333 } },
    f5    = { meta = '4|4 6|8  130 BPM  E Minor       ', bar = 4, bpm = 130, toneFix = -1., loop = { 96, 169.846 } },
    f5r   = { meta = '4|4 6|8  130 BPM  E Minor       ', bar = 4, bpm = 130, toneFix = -1., loop = { 96, 169.846 } },
    f6    = { meta = '4|4  130 BPM  A Minor           ', bar = 4, bpm = 130, toneFix = 2.0, loop = { 29.538, 103.384 } },
    f6r   = { meta = '4|4  130 BPM  G Minor           ', bar = 4, bpm = 130, toneFix = 0.0, loop = { 29.538, 103.384 } },
    f7    = { meta = '4|4  120 BPM  A+50c Minor       ', bar = 4, bpm = 120, toneFix = 2.5, bpmData = { 60, 32, 120 }, loop = { 128, 192 } },
    f7r   = { meta = '4|4  120 BPM  A+50c Minor       ', bar = 4, bpm = 120, toneFix = 2.5, bpmData = { 60, 32, 120 }, loop = { 128, 192 }, teleport = { 8, 32 } },
    f8    = { meta = '4|4  150 BPM  E Minor           ', bar = 4, bpm = 150, toneFix = -1., loop = { 38.4, 134.4 } },
    f8r   = { meta = '4|4  150 BPM  E Minor           ', bar = 4, bpm = 150, toneFix = -1., loop = { 38.4, 134.4 } },
    f9    = { meta = '4|4  160 BPM  E Minor           ', bar = 4, bpm = 160, toneFix = -1., loop = { 36, 144 } },
    f9r   = { meta = '4|4  160 BPM  E Minor           ', bar = 4, bpm = 160, toneFix = -1., loop = { 36, 144 } },
    f10   = { meta = '4|4  196 BPM  C Major & C Minor ', bar = 4, bpm = 196, toneFix = 0.0, bpmData = { 49, 19.592, 98 }, loop = { 203.877, 311.632 } },
    f10r  = { meta = '4|4  196 BPM  C Major & C Minor ', bar = 4, bpm = 196, toneFix = 0.0, bpmData = { 49, 19.592, 98 }, loop = { 203.877, 311.632 } },
    fomg  = { meta = '4|4  180 & 200 BPM  Bb Minor    ', bar = 4, bpm = 200, toneFix = 3.0, bpmData = { 90, 10.667, 180, 25.333, 200 }, loop = { 38.4 - 11.862, 144 - 11.862 } },
    tera  = { meta = '4|4  240 BPM  C# Minor          ', bar = 4, bpm = 240, toneFix = 1.0, loop = { 76, 140 }, introLen = 2, teleport = { -1, 20 } }, -- 4 endings at 140/142/144/146
    terar = { meta = '4|4  240 BPM  C# Minor          ', bar = 4, bpm = 240, toneFix = 1.0, loop = { 84 - 15.565, 172 - 15.565 }, teleport = { 0, 18 - 15.565 } },
}
for _, v in next, BgmData do
    v.meta = STRING.trim(v.meta)
    if not v.bpmData then v.bpmData = { v.bpm } end
end
BgmSet = {
    f0 = {
        'piano',
        'arp', 'bass', 'guitar', 'pad', 'staccato', 'violin',
        'expert', 'rev',
        'piano2', 'violin2',
    },
    f1 = { 'f1', 'f1ex', 'f1rev' },
}
BgmPlaying = false ---@type ZC.bgmName | false
SongNamePlaying = false -- Same as BgmPlaying, but this distinguishes f0(r) and f1(r) for album page
BgmLooping = false
BgmNeedSkip = false
BgmNeedStop = false
MusicBeat = 0 ---@type number 0-1, envelope: /|/|/|

-- Vars: Daily Challenge extras

VALENTINE = false
VALENTINE_TEXT = "FLOOD THE TOWER SIDE BY SIDE WITH WHAT COULD BE"
XMAS = false
ZDAY = false

-- Vars: Cursor

MX, MY = -260, 0 -- Mouse position
CursorProgress = 0
CursorHide = true

local M = GAME.mod

-- Functions: Cursor

function SetMouseVisible(bool)
    if CONF.syscursor then
        love.mouse.setVisible(bool)
    else
        CursorHide = not bool
    end
end

-- Functions: Save Data

function SaveBest()
    if TestMode then return end
    love.filesystem.write('best.luaon', 'return' .. TABLE.dumpDeflate(BEST))
end

function SaveStat()
    if TestMode then return end
    STAT.modTime = os.time()
    love.filesystem.write('stat.luaon', 'return' .. TABLE.dumpDeflate(STAT))
end

function SaveAchv()
    if TestMode then return end
    love.filesystem.write('achv.luaon', 'return' .. TABLE.dumpDeflate(ACHV))
end

function SaveConf()
    if TestMode then return end
    love.filesystem.write('conf.luaon', 'return' .. TABLE.dumpDeflate(CONF))
end

function SaveSR()
    if TestMode then return end
    love.filesystem.write('speedrun.luaon', 'return' .. TABLE.dumpDeflate(SR))
end

-- Create BEST, STAT, ACHV tables, only called when launching and on resetall
function InitProfile()
    BEST = {
        highScore = setmetatable({}, Metatable.best_highscore),
        speedrun = setmetatable({}, Metatable.best_speedrun),
    }

    STAT = {
        mod = 'vanilla',
        version = nil, -- will be set after loading
        system = SYSTEM,
        modTime = os.time(),
        srTimer_life = 0,
        srTimer_game = 0,
        srMilestone = {},
        srActive = true,
        joinDate = os.date("%b %Y"),
        hid = os.date("%d%S%m%M%y%H") .. math.random(26000, 42000) .. math.random(42000, 62000),
        uid = "ANON-" .. os.date("%d_") .. math.random(2600, 6200),
        aboutme = "Click the Zenith!",
        maxFloor = 1,
        maxHeight = 0,
        heightDate = "NO DATE",
        minTime = 2600,
        timeDate = "NO DATE",

        zp = 0,
        dzp = 0,
        peakZP = 0,
        peakDZP = 0,
        dailyBest = 0,
        dailyFast = 1e99,
        dailyMastered = false,
        lastDay = 0,
        vipListCount = 0,
        clockOutCount = 0,
        clicker = false,

        totalGame = 0,
        totalTime = 0,
        totalQuest = 0,
        totalPerfect = 0,
        totalHeight = 0,
        totalBonus = 0,
        totalFloor = 0,
        totalFlip = 0,
        totalAttack = 0,
        totalGiga = 0,
        totalF10 = 0,
        totalKO = 0,
        totalRevive = 0,
        badge = {},
    }

    ACHV = {}

    AchvNotice = {}
end

function LoadSave()
    -- Fill BEST, STAT, ACHV tables with actual save data, only called after InitProfile()
    local stat = FILE.safeLoad('stat.luaon', '-luaon')
    if stat then
        TABLE.update(STAT, stat)
        if not STAT.srTimer_game then
            STAT.srTimer_game, STAT.srTimer_life = STAT.totalTime, MATH.roundUnit(STAT.totalTime * 1.26, .001)
        end
    end
    TABLE.update(BEST, FILE.safeLoad('best.luaon', '-luaon') or NONE)
    TABLE.update(ACHV, FILE.safeLoad('achv.luaon', '-luaon') or NONE)
end

-- Functions: Game Progress

local function norm(x, k) return 1 + (x - 1) / (k * x + 1) end
function CalculateCR()
    local deck = ModData.deck
    local hs, sr = BEST.highScore, BEST.speedrun
    local s

    s = 0
    for i = 1, #deck do
        local id = deck[i].id
        if hs[id] >= Floors[9].top then s = s + 1 end
        if hs['r' .. id] >= Floors[9].top then s = s + 1 end
    end
    CRprogress.f10 = s

    s = 0
    for i = 1, #deck do
        local id = deck[i].id
        if sr[id] < 1e26 then s = s + 1 end
        if sr['r' .. id] < 1e26 then s = s + 1 end
    end
    CRprogress.sr = s

    local p, P = 0, 0
    for i = 1, #Achievements do
        local A = Achievements[i]
        if A.type == 'competitive' then
            P = P + 5
            if ACHV[A.id] then
                local rank = math.floor(A.rank(ACHV[A.id]))
                p = p + rank
            end
        end
    end
    CRprogress.achvGet, CRprogress.achvAll = p, P

    local cap = 25000
    local cr = 0

    -- Best height (5K)
    cr = cr + 5000 * norm(MATH.icLerp(50, 6200, STAT.maxHeight), 6.2)

    -- Best time (5K)
    cr = cr + 5000 * norm(MATH.icLerp(420, 76.2, STAT.minTime), -.5)

    -- Mod completion (3K)
    cr = cr + 3000 * norm(MATH.icLerp(0, #deck * 2, CRprogress.f10), .62)

    -- Mod speedrun (2K)
    cr = cr + 2000 * norm(MATH.icLerp(0, #deck * 2, CRprogress.sr), .62)

    -- Zenith point (3K)
    cr = cr + 3000 * norm(MATH.icLerp(0, 26e4, STAT.zp), 4.2)

    -- Daily challenge (2K)
    cr = cr + 2000 * norm(MATH.icLerp(0, 6200, STAT.dzp), 2.6)

    -- Achievement (5K)
    cr = cr + 5000 * norm(MATH.icLerp(0, CRprogress.achvAll, CRprogress.achvGet), 2.6)

    -- ACHV Wreath (competitive achievement count)
    for i = 1, #Achievements do
        local A = Achievements[i]
        if A.type == 'competitive' then
            cap = cap + 1
            local r = A.rank(ACHV[A.id] or A.noScore or 0)
            if r == 5.9999 then
                cr = cr + 1
            end
        end
    end

    if not STAT.badge.champion and cr >= 25000 then IssueSecret('champion', true) end

    return MATH.round(cr), cap
end

local msgTime = 0
local bufferedMsg = {}

local saveAchvTimer = false ---@type number | false
function IssueAchv(id, silent)
    if TestMode then return end
    local A = Achievements[id]
    if not A or ACHV[id] then return end

    if not silent then
        table.insert(bufferedMsg, { 'achv_issued', {
            AchvData[6].fg, A.name .. "\n",
            COLOR.dL, A.desc .. "\n",
            COLOR.LD, A.quote,
        }, 1 })
        if not GAME.playing then
            ReleaseAchvBuffer()
        end
    end

    ACHV[id] = 0
    AchvNotice[id] = true
    saveAchvTimer = .26

    return true
end

local wreathName = {
    [false] = "",
    [0] = "",
    [1] = "T100-",
    [2] = "T50-",
    [3] = "T25-",
    [4] = "T10-",
    [5] = "T5-",
    [6] = "T3-",
}
---@return true? success
function SubmitAchv(id, score, silent, realSilent)
    if TestMode then return end
    local A = Achievements[id]
    if not A then return end
    local oldScore = ACHV[id] or A.noScore or 0
    local R0, R1 = A.rank(oldScore), A.rank(score)
    -- printf("%s: %.1f(%.2f) -> %.1f(%.2f)", id, oldScore, R0, score, R1)
    if R1 == 0 or not A.comp(score, oldScore) then return end

    if not silent and R1 >= 1 then
        local rank = math.floor(R1)
        local wreath = R1 >= 5 and math.floor(MATH.clampInterpolate(0, 0, .9999, 6, R1 % 1)) or 0
        local scoreText = A.scoreSimp(score) .. (A.scoreFull and "  " .. A.scoreFull(score) or "")
        local oldScoreText = A.scoreSimp(oldScore) .. (A.scoreFull and "  " .. A.scoreFull(oldScore) or "")
        table.insert(bufferedMsg, { wreath > 0 and 'wreath_' .. wreath or AchvData[rank].id, {
            AchvData[rank].fg, wreathName[wreath] .. A.name .. "   >>   " .. scoreText,
            COLOR.LD, (ACHV[id] and "    Previous: " .. oldScoreText or "") .. "\n",
            COLOR.dL, A.desc .. "\n", COLOR.LD, A.quote,
        }, rank <= 2 and 1 or rank <= 4 and 2 or 3 })
        if not GAME.playing then
            ReleaseAchvBuffer()
        end
    end

    ACHV[id] = score
    if not realSilent then
        AchvNotice[id] = true
    end
    saveAchvTimer = .26

    return true
end

function IssueSecret(id, silent)
    if not STAT.badge[id] then
        STAT.badge[id] = true
        if not silent then
            table.insert(bufferedMsg, { 'bright', "YOU DID A THING!\n", 0 })
            if not GAME.playing then
                ReleaseAchvBuffer()
            end
        end
    end
end

function IssueSpeedrunMilestone(id)
    if not STAT.srMilestone[id] then
        local t = MATH.roundUnit(STAT.srTimer_game, .001)
        STAT.srMilestone[id] = t * (STAT.srActive and 1 or -1)
        if STAT.srActive then
            if t < (SR[id] or 1e99) then
                SR[id] = t
                SaveSR()
            end
        end
        if t < 3600 * 2.6 then
            MSG('speedrun', SpeedrunData[id].name .. ": " .. STRING.time(STAT.srMilestone[id]), 6.26)
        end
    end
end

function ReleaseAchvBuffer()
    if TestMode then return end
    for i = 1, #bufferedMsg do
        local msg = bufferedMsg[i]
        msgTime = TASK.lock('achv_bulk', 1) and 6.2 or msgTime + 2.6
        MSG { msg[1], msg[2], time = msgTime, last = true, alpha = .75 }
        if msg[3] == 0 and TASK.lock('achv_sfx_allclear', .08) then
            SFX.play('allclear')
        elseif TASK.lock('achv_sfx_' .. msg[3], .08) then
            SFX.play('achievement_' .. msg[3], .7)
        end
    end
    TABLE.clear(bufferedMsg)
end

-- Functions: Music

function Tone(pitch)
    return pitch + (URM and M.GV == 2 and 3 or M.GV) + BgmData[BgmPlaying].toneFix
end

function RevMusicMode()
    return
        URM and M.EX == 2 or                   -- uEX
        GAME.anyRev and GAME.comboZP >= 2.6 or -- rev run with 2.6x ZP
        GAME.anyUltra and GAME.comboZP >= 1.2  -- ultra run with 1.2x ZP
end

---@param name ZC.bgmName
---@param force? boolean speedrun or music player
function PlayBGM(name, force)
    if GAME.teramusic and not force then return end

    SongNamePlaying = name
    local last = BgmPlaying

    if GAME.playing and RevMusicMode() then name = name .. 'r' end
    if name == 'fomgr' then name = 'fomg' end
    if name == 'f0r' then
        BgmPlaying = 'f0'
    elseif name == 'f1r' then -- Note: 'f1ex' is only a track name, not musicID
        BgmPlaying = 'f1'
    else
        BgmPlaying = name
    end

    if not BgmData[BgmPlaying] then return end

    BgmNeedStop = false

    if BgmPlaying == 'f0' then
        BgmLooping = false
        BgmNeedSkip = BgmData[BgmPlaying].teleport

        BGM.play(BgmSet.f0)
        RefreshBGM(name)
    elseif BgmPlaying == 'f1' then
        BgmLooping = BgmData[BgmPlaying].loop
        BgmNeedSkip = BgmData[BgmPlaying].teleport

        BGM.play(BgmSet.f1, force and '' or '-sdin')
        local start = math.random(3, 5) * BgmData.f1.introLen
        BgmNeedSkip[1] = start + BgmData.f1.introLen
        BGM.set('all', 'seek', start)
        RefreshBGM(name)
    elseif name == 'tera' then
        BgmLooping = BgmData[BgmPlaying].loop
        BgmNeedSkip = BgmData[BgmPlaying].teleport

        BGM.play('tera', '-sdin')
        local startFrom
        if last then
            ---@cast last string
            startFrom = tonumber(last:match("%d+"))
            if startFrom then startFrom = startFrom - 1 end
        end
        local start = (GAME.playing and GAME.floor or startFrom or math.random(0, 9)) * BgmData.tera.introLen
        BgmNeedSkip[1] = start + BgmData.tera.introLen
        BGM.set('all', 'seek', start)
        RefreshBGM()
    elseif BGM.play(name, force and '' or '-sdin') then
        BgmLooping = BgmData[BgmPlaying].loop
        BgmNeedSkip = BgmData[BgmPlaying].teleport
        RefreshBGM()
    end
end

function RefreshBGM(mode)
    if not BGM.isPlaying() then return end
    local pitch = M.GV > 0 and 2 ^ ((URM and M.GV == 2 and 3 or M.GV) / 12) or 1
    if GAME.slowmo then pitch = pitch / 2 end
    if GAME.nightcore then pitch = pitch * 2 end
    local justBegin = BGM.tell() < 1
    BGM.set('all', 'pitch', pitch, justBegin and 0 or .26)
    BGM.set('all', 'highgain', M.IN == 0 and 1 or M.IN == 1 and .8 or not URM and .626 or .55, justBegin and 0 or .626)
    if BgmPlaying == 'f0' then
        local revMode = mode == 'f0r' or RevMusicMode()
        BGM.set('all', 'volume', revMode and 0 or 1, 2.6)
        BGM.set('expert', 'volume', M.EX > 0 and 1 or 0, .26)
        BGM.set('piano', 'volume', M.NH == 0 and 1 or M.NH == 1 and .26 or 0)
        BGM.set('piano2', 'pitch', 2 * pitch, 0)
        BGM.set('piano2', 'volume', (M.DP > 0 or VALENTINE and not revMode) and .626 or 0, .26)
        BGM.set('violin', 'volume', M.DP == 2 and 1 or 0, .26)
        BGM.set('violin2', 'volume', M.DP == 2 and 1 or 0, .26)
        BGM.set('rev', 'volume', revMode and (M.DP > 0 and .5 or .7) or 0, revMode and 1.6 or 2.6)
    elseif BgmPlaying == 'f1' then
        local revMode = mode == 'f1r' or RevMusicMode()
        BGM.set('f1', 'volume', 1)
        BGM.set('f1ex', 'volume', M.EX > 0 and 1 or 0, 0)
        BGM.set('f1rev', 'volume', revMode and 1 or 0, 0)
    end
end

function Task_MusicEnd(manual)
    BgmLooping = false
    local D = BgmData[BgmPlaying]
    local outroStart
    if BgmPlaying == 'f1' or BgmPlaying == 'f1r' then
        outroStart = D.loop[2] + 4 * 60 / D.bpm
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f2' or BgmPlaying == 'f2r' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f3' or BgmPlaying == 'f3r' then
        if BGM.tell() < D.loop[1] then
            outroStart = D.loop[2] + 0
        else
            outroStart = D.loop[2] + 8 * 60 / D.bpm
        end
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f4' or BgmPlaying == 'f4r' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 10 * 60 / D.bpm
    elseif BgmPlaying == 'f5' or BgmPlaying == 'f5r' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f6' or BgmPlaying == 'f6r' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f7' or BgmPlaying == 'f7r' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f8' or BgmPlaying == 'f8r' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f9' or BgmPlaying == 'f9r' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f10' or BgmPlaying == 'f10r' then
        local t = BgmPlaying == 'f10' and 4.2 or 6.2
        if BGM.tell() < 56 * 4 * 60 / D.bpm then
            BGM.stop(t)
            TASK.yieldT(t)
        elseif BGM.tell() < 118 * 4 * 60 / D.bpm then
            BGM.set('all', 'seek', 118 * 4 * 60 / D.bpm)
            BgmNeedStop = BGM.tell() + 10 * 60 / D.bpm
        elseif BGM.tell() < 154.5 * 4 * 60 / D.bpm then
            BGM.stop(t)
            TASK.yieldT(t)
        else
            outroStart = D.loop[2]
            BgmNeedStop = outroStart + 8 * 60 / D.bpm
        end
    elseif BgmPlaying == 'fomg' then
        if BGM.tell() < D.loop[1] then
            outroStart = D.loop[2] + 32 * 60 / D.bpm
            BgmNeedStop = outroStart + 16 * 60 / D.bpm
        else
            outroStart = D.loop[2]
            BgmNeedStop = outroStart + 26 * 60 / D.bpm
        end
    elseif BgmPlaying == 'tera' then
        outroStart = D.loop[2] + math.random(0, 3) * 8 * 60 / D.bpm
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'terar' then
        outroStart = D.loop[2] + 96 * 60 / D.bpm
        BgmNeedStop = outroStart + 30 * 60 / D.bpm
    else
        BgmNeedStop = BGM.tell() + 4 * 60 / D.bpm
    end
    if outroStart then BGM.set('all', 'seek', outroStart) end
    BgmLooping, BgmNeedSkip = false, false
    if BgmNeedStop then
        repeat TASK.yieldT(.0626) until not BgmNeedStop
    else
        repeat TASK.yieldT(.0626) until not BGM.isPlaying()
    end
    if not manual then
        PlayBGM('f0')
        GAME.refreshRPC()
    end
end

-- Functions: System

require 'module/initialize'

local pressValue = 0
local function starCursor(x, y)
    if CursorHide or GAME.zenithTraveler then return end
    gc_translate(x, y)
    gc_scale(1.42)
    gc_rotate(MATH.lerp(-.626, -1.2, pressValue))
    gc_scale(.8 + .2 * pressValue, 1)
    local l = .626 + .374 * pressValue
    gc_setColor(l, l, l)
    gc_draw(TEXTURE.star0, 0, -6, 0, .14, .3, TEXTURE.star1:getWidth() * .5, 0)
    gc_scale(.12, .26)
    gc_setShader(SHADER.coloring)
    gc_setColor(1, .626, .5)
    gc_draw(TEXTURE.star0, -150, 0)
    if CursorProgress <= .384626 then
        local t = MATH.interpolate(0, 1, .384626, 0, CursorProgress)
        gc_setColor(.9, .9, .9, t)
        gc_draw(TEXTURE.star0, -150, 0)
        gc_setShader()
    else
        gc_setShader()
        gc_setColor(1, 1, 1, MATH.iLerp(.384626, 1, CursorProgress))
        gc_draw(TEXTURE.star1, -150, 0)
    end
end
function ApplySettings()
    love.mouse.setVisible(CONF.syscursor)
    ZENITHA.globalEvent.drawCursor = CONF.syscursor and NULL or starCursor
    SFX.setVol(CONF.sfx / 100)
    BGM.setVol(CONF.bgm / 100)
end

function ReloadTexts()
    local sep = (TEXTS.mod:getFont():getHeight() + TEXTS.title:getFont():getHeight()) / 2
    for _, text in next, TEXTS do text:setFont(FONT.get(text:getFont():getHeight() < sep and 30 or 50)) end
    for _, text in next, CardHintText do text:setFont(FONT.get(text:getFont():getHeight() < sep and 30 or 50)) end
    for _, quest in next, GAME.quests do quest.name:setFont(FONT.get(70)) end
    TEXTS.height:setFont(FONT.get(30))
    TEXTS.time:setFont(FONT.get(30))
    TEXTS.gigatime:setFont(FONT.get(50))
    TEXTS.chain2:setFont(FONT.get(50, 'led'))
    for _, W in next, SCN.scenes[SCN.cur].widgetList do W:reset() end
    AchvText:setFont(FONT.get(30))
    AboutText:setFont(FONT.get(70))
    DevNoteText:setFont(FONT.get(30))
    EndText:setFont(FONT.get(70))
    EndText2:setFont(FONT.get(70))
    for _, text in next, SRSplitText1 do text:setFont(FONT.get(50)) end
    for _, text in next, SRSplitText2 do text:setFont(FONT.get(50)) end
    for _, text in next, SRSplitText3 do text:setFont(FONT.get(30)) end
    if SCN.cur == 'stat' then RefreshProfile() end
    if SCN.cur == 'records' then SCN.scenes.records.load() end
    if SCN.cur == 'achv' then RefreshAchvList() end
end

local normalHelp = {
    COLOR.LL, "Welcome to ", COLOR.LF, "Zenith Clicker", COLOR.LL, "! Choose the required tarot cards and send players to scale the tower.\n",
    "The higher you go in the tower, the more tricky players you'll encounter!\n",
    "There's a leaderboard for daily challenge, how high can you reach?\n",
    "[DYNAMIC TEXT]",
}
local ultraHelp = {
    COLOR.LL, "Welcome to ", COLOR.LR, "Zenith Clicker: ", COLOR.R, "Ultra Reverse", COLOR.LL, ". Activate a reversed mod to start ", COLOR.lR, "suffering.\n",
    COLOR.LL, "The higher you go in the tower, the more likely you are to ", COLOR.R, "die.\n",
    COLOR.LL, "There are no more achievements, and ", COLOR.lR, "you are not expected to go very high up.\n",
    COLOR.R, "Give Up: ", COLOR.LL, "ESC    ", COLOR.R, "Forfeit: ", COLOR.LL, "ESC    ", COLOR.R, "Quit: ", COLOR.LL, "ESC"
}
function RefreshHelpText()
    local s = SCN.scenes.tower.widgetList
    ---@cast s Map<Zenitha.Widget.base | Zenitha.WidgetArg>
    if URM then
        s.help.text = "U"
        s.help.floatText = ultraHelp
        if GAME.height >= 0 then
            s.help2.text = "!"
            s.help2.floatText = "The final ULTRA REVERSE challenge.\n\"Because it is there.\""
        else
            s.help2.text = "B"
            s.help2.floatText = "B" .. GAME.negFloor .. ": " .. NegFloors[GAME.negFloor].name .. "\n" .. NegTexts['b' .. GAME.negFloor].desc
        end
    else
        s.help.text = "?"
        normalHelp[#normalHelp] = ("Commit: $1    Reset: $2    Forfeit/Quit: ESC"):repD(CONF.keybind[19]:upper(), CONF.keybind[20]:upper())
        s.help.floatText = normalHelp
        s.help2.text = "?"
        local hand = GAME.getHand(true)
        local lastLine = (
            #hand == 0 and "Without any mods, " or
            #hand == 1 and "With this mod, " or
            "With this combo, "
        ) .. "ZP earn starts from 0%% at %.0fm, to 100%% at %.0fm"
        s.help2.floatText = "Each mod will multiply ZP gain with a certain rate.\n" .. lastLine:format(STAT.zp / 26 / GAME.comboZP, STAT.zp / 16 / GAME.comboZP)
    end
    s.help:reset()
    s.help2:reset()
end

function RefreshDaily()
    local dateToday = os.date("!*t", os.time())
    local dateLastDay = os.date("!*t", math.max(STAT.lastDay, 946656000)) -- at least 2000/1/1
    local time0Today = os.time({ year = dateToday.year, month = dateToday.month, day = dateToday.day })
    local time0LastDay = os.time({ year = dateLastDay.year, month = dateLastDay.month, day = dateLastDay.day })
    local dayPast = MATH.round((time0Today - time0LastDay) / 86400)

    if dayPast < 0 then
        MSG('warn', "Back to the future?", 26)
    else
        if MATH.between(dayPast, 1, 2600) then
            LOG('info', "Daily Reset:")
            local oldZP, oldDZP = STAT.zp, STAT.dzp
            STAT.zp = MATH.expApproach(STAT.zp, 0, dayPast * .026)
            STAT.dzp = MATH.expApproach(STAT.dzp, 0, dayPast * .0626)
            STAT.dailyBest = 0
            STAT.dailyFast = 1e99
            STAT.dailyMastered = false
            LOG('info', "ZP: " .. math.floor(oldZP / 1000 + .5) .. "k -> " .. math.floor(STAT.zp / 1000 + .5) .. "k")
            LOG('info', "DZP: " .. math.floor(oldDZP) .. " -> " .. math.floor(STAT.dzp))
        end
        STAT.lastDay = os.time()
    end

    Daily.actived = false
    Daily.available = false
    Daily.needSubmit = false
    local function modCardSorter(a, b) return ModData.prio_card[a] < ModData.prio_card[b] end
    local now = os.time()
    for x = -4, 0 do
        local time = now + x * 86400
        math.randomseed(os.date("!%Y%m%d", time) + 0)
        for _ = 1, 26 do math.random() end

        local modCount = math.ceil(9 - math.log(math.random(11, 42), 1.62)) -- 5 444 3333 2222
        DAILY = {}


        local freq = { 3, 3, 2, 5, 3, 5, 4, 4, 2 }
        while #DAILY < modCount do
            local m = ModData.deck[MATH.randFreq(freq)].id
            if not TABLE.find(DAILY, m) then table.insert(DAILY, m) end
        end
        if MATH.roll(.26 + #DAILY * .1) then
            if #DAILY >= 3 and MATH.roll(.62) then TABLE.popRandom(DAILY) end
            local r = math.random(#DAILY)
            DAILY[r] = 'r' .. DAILY[r]
            if MATH.roll(.26) then
                local r2 = math.random(#DAILY - 1)
                if r2 >= r then r2 = r2 + 1 end
                DAILY[r2] = 'r' .. DAILY[r2]
            end
        end

        local sortedDaily = TABLE.copy(DAILY)
        Daily.history[-x] = table.concat(TABLE.sort(sortedDaily))
        Daily.historyDisp[-x] = table.concat(TABLE.sort(sortedDaily, modCardSorter), " ")
        if x == 0 then LOG('info', "Today's Daily Challenge: " .. table.concat(DAILY, ' ')) end
    end
    -- for k, v in next, DailyHistory do print(k, table.concat(v, " ")) end

    local isV = os.date('!%d') == '14'
    if VALENTINE ~= isV then
        VALENTINE = isV
        ModData.desc.DP, VALENTINE_TEXT = VALENTINE_TEXT, ModData.desc.DP
        ValentineTextColor, BaseTextColor = BaseTextColor, ValentineTextColor
        ValentineShadeColor, BaseShadeColor = BaseShadeColor, ValentineShadeColor
    end
    local isX = os.date('!%m%d') == '1224' or os.date('!%m%d') == '1225'
    if XMAS ~= isX then
        XMAS = isX
        XMasTextColor, BaseTextColor = BaseTextColor, XMasTextColor
        XMasShadeColor, BaseShadeColor = BaseShadeColor, XMasShadeColor
    end
    local isZ = os.date('!%d') == '26'
    if ZDAY ~= isZ then
        ZDAY = isZ
    end
end

local uVLpool = {}
function UltraVlCheck(id, auto)
    uVLpool[id] = (uVLpool[id] or 0) + (auto and 3.55 or 1)
    if uVLpool[id] < 3.1 then
        SFX.play('clearline', .3)
        if uVLpool[id] < 1.3 then
            SFX.play('combo_1', .626, 0, Tone(0))
        elseif uVLpool[id] < 2.2 then
            SFX.play('combo_3', .626, 0, Tone(-2))
        else
            SFX.play('combo_2', .626, 0, Tone(1))
        end
        return false
    end
    if not auto then
        SFX.play('clearquad', .3)
        SFX.play('combo_4', .626, 0, Tone(0))
    end
    uVLpool[id] = 0
    return true
end

function CurlCMD(data)
    local json = JSON.encode(data)
    if SYSTEM == 'Windows' then
        json = json:gsub('"', [[\"]])
        return ([[curl -s -X POST https://vercel-leaderboard-one.vercel.app/api -H "Content-Type: application/json" -d "$1"]]):repD(json)
    else
        return ([[curl -s -X POST https://vercel-leaderboard-one.vercel.app/api -H 'Content-Type: application/json' -d '$1']]):repD(json)
    end
end

local curlAvailable = SYSTEM == 'Windows' or SYSTEM == 'Linux' or (function()
    local f = io.popen('curl --version', 'r')
    if not f then return end
    local res = f:read('*a')
    f:close()
    if res and res:find('^curl') then return true end
end)()
function TryOpenLeaderboard()
    if not curlAvailable then
        SFX.play('no')
        MSG('warn', "Leaderboard is not supported on this device (no cUrl)")
    elseif STAT.maxFloor < 10 then
        SFX.play('no')
        MSG('warn', "Reach F10 once to unlock the leaderboards!")
    else
        SFX.play('menuhit2')
        SCN.go('leaderboard', 'none')
    end
end

function DailyRequest(act, data)
    if not curlAvailable or STAT.mod ~= 'vanilla' then return end
    if act == 'submit' then
        if TestMode then return end
        if STAT.uid:sub(1, 5) == 'ANON-' then
            if TASK.lock('anon_submit') then
                MSG('warn', "Anonymous users cannot submit daily challenge scores", 10 * 1.6)
            end
            return
        end
        DAILYCMD = CurlCMD {
            act = 'submit',
            hid = STAT.hid,
            uid = STAT.uid,
            combo = GAME.comboStr,
            alt = GAME.roundHeight,
            time = GAME.gigaTime and MATH.roundUnit(GAME.gigaTime, .001),
        }
        ASYNC.runCmd('submitDaily', DAILYCMD)
        MSG('dark', "Submitting Daily Challenge score...")
    elseif act == 'fetch' then
        LB[data] = LB[data] or {}
        ASYNC.runCmd('fetchLeaderboard', CurlCMD {
            act = 'fetch',
            combo = data,
        })
    end
end

function Daemon_Slow()
    TASK.yieldT(1)
    local lib = BGM._srcLib
    local f0List = BgmSet.f0
    local length
    while true do
        -- Music syncing
        if BgmPlaying == 'f0' and BGM.isPlaying() then
            length = length or lib[f0List[1]].source:getDuration()
            local t0 = lib[f0List[1]].source:tell() % length
            for i = #f0List, 2, -1 do
                local obj = lib[f0List[i]]
                local T = t0
                if f0List[i] == 'piano2' then T = T * 2 % length end
                if f0List[i] == 'violin2' then T = (T - 8 * 60 / BgmData.f0.bpm) % length end
                if math.abs(obj.source:tell() - T) > 0.026 then
                    -- print('Desync', set[i])
                    obj.source:seek(math.max(T, 0))
                end
            end
        end

        -- DiscordRPC syncing
        if DiscordState.needUpdate and not TASK.getLock('RPC_update') then
            DiscordState.needUpdate = nil
            DiscordRPC.update(DiscordState)
        end

        -- HTTP returns
        local msg = ASYNC.get('checkUpdate')
        if msg then
            local suc, res = pcall(JSON.decode, msg)
            if suc and res and res.tag_name then
                if (require 'version'.appVer):lower() == res.tag_name then
                    LOG('info', "Already on latest version (" .. res.tag_name .. ")")
                else
                    SFX.play('social_notify_major')
                    MSG('info', "New version " .. res.tag_name .. " available!", 6.26)
                end
            else
                LOG('info', "Failed to check for updates")
            end
        end
        msg = ASYNC.get('submitDaily')
        if msg then
            local suc, res = pcall(JSON.decode, msg)
            local duration = GAME.playing and 0 or 10
            if suc and res then
                if res.error then
                    MSG('warn', "Daily Challenge submission failed:\n" .. res.error, duration * .626)
                elseif next(res) then
                    MSG('check',
                        "Daily Challenge score submitted!\n" ..
                        "Alt #" .. tostring(res.altRank) .. " of " .. tostring(res.altCount) .. ", top: " .. tostring(res.altBest) .. "m\n" ..
                        "SR #" .. tostring(res.timeRank) .. " of " .. tostring(res.timeCount) .. ", top: " .. tostring(res.timeBest) .. "s",
                        duration)
                    SFX.play('pause_continue', 1, 0, Tone(-5))
                else
                    MSG('check', "Daily Challenge submission failed:\nNot a better score", duration)
                end
                DAILYCMD = nil
            else
                MSG('warn', "Daily Challenge submission failed\nRetry with secret code 'resubmit'\ndata received from server: " .. msg, 10 * 1.6)
                SFX.play('pause_retry', 1, 0, Tone(-5))
            end
        end
        msg = ASYNC.get('fetchLeaderboard')
        if msg then
            local suc, res = pcall(JSON.decode, msg)
            if suc and res then
                if res.error then
                    MSG('warn', "Daily Challenge leaderboard fetch failed:\n" .. res.error)
                elseif res.alt then
                    LB[res.combo].alt = res.alt
                    LB[res.combo].time = res.time
                    LB[res.combo].lastUpd = os.time()
                    FILE.save(LB, 'leaderboard.luaon', '-luaon')
                else
                    MSG('warn', "Daily Challenge leaderboard fetch failed:\nNo Data")
                    SFX.play('pause_retry', 1, 0, Tone(-5))
                end
            else
                MSG('warn', "Daily Challenge leaderboard fetch failed")
                SFX.play('pause_retry', 1, 0, Tone(-5))
            end
        end

        TASK.yieldT(.6)
    end
end

function Daemon_Fast()
    local max = math.max
    local hsv = COLOR.HSV
    local yield = coroutine.yield
    local msIsDown = love.mouse.isDown
    local expApproach = MATH.expApproach
    local deckSize = #ModData.deck

    local startBtnTexts = { "START", "STAR", "STA", "ST", "S", "", "C", "CO", "COM", "COMM", "COMME", "COMMEN", "COMMENC", "COMMENCE" }
    local resetBtnTexts = { "RESET", "RESE", "RES", "RE", "R", "", "S", "SP", "SPI", "SPIN" }
    local startBtnPtr = 1
    local resetBtnPtr = 1

    local beatS, beatE = 0, 0    -- Current beat's Start & End time
    local skipNextShuffle = true -- Flip-flop for MS shaking each 2 beats
    local MSactive = false       -- for skipping meaningless Ypos resets to improve performance
    local t = 0
    while true do
        if BgmPlaying then
            local bar = 2 * 60 / BgmData[BgmPlaying].bpm * 4
            local T = BGM.tell()

            -- Throb transparency
            ThrobAlpha.card = max(.626 - 2 * T / bar % 1, .626 - 2 * (T / bar - .375) % 1)
            ThrobAlpha.bg1 = .626 - 2 * T / bar % 1
            ThrobAlpha.bg2 = .626 - 2 * (T / bar - 1 / 32) % 1

            -- Giga anim
            if GigaSpeed.alpha > 0 then
                GigaSpeed.r, GigaSpeed.g, GigaSpeed.b = hsv(T / bar % 1, .626, 1)
                GigaSpeed.bgAlpha = 1 - 4 * T / bar % 1
            end

            -- Update MusicBeat
            if T < beatS then
                -- warp back
                beatS, beatE = 0, 0
            end
            local newBeat
            while T > beatE do
                -- next beat
                beatS = beatE
                local dat = BgmData[BgmPlaying].bpmData
                local bpm = dat[1]
                for i = #dat - 1, 2, -2 do
                    if beatS + .1 >= dat[i] then
                        bpm = dat[i + 1]
                        break
                    end
                end
                beatE = beatS + 60 / bpm
                newBeat = true
                -- if TASK.lock('test', .1) then SFX.play('clearline', .62) end
            end
            MusicBeat = MATH.icLerp(beatS, beatE, T)

            -- MS shaking (each 2 beats)
            if newBeat then
                if skipNextShuffle then
                    if M.MS == 0 then
                        if MSactive then
                            for i = 1, deckSize do Cards[i].visY = 0 end
                            GAME.refreshLayout()
                        end
                        MSactive = false
                    else
                        if URM and M.MS == 2 then
                            for i = 1, deckSize do Cards[i].visY = math.random(-42, 42) end
                        else
                            for i = 1, deckSize do Cards[i].visY = M.MS * math.random(-4, 4) end
                        end
                        MSactive = true
                        GAME.refreshLayout()
                    end
                end
                skipNextShuffle = not skipNextShuffle
            end

            -- BGM time control
            if BgmLooping then
                if BGM.tell() > BgmLooping[2] then
                    local pass = BGM.tell() - BgmLooping[2]
                    if pass < .26 then
                        BGM.set('all', 'seek', BgmLooping[1] + pass)
                    else
                        BGM.set('all', 'seek', BgmLooping[1])
                    end
                end
            end
            if BgmNeedSkip then
                if BGM.tell() > BgmNeedSkip[1] then
                    local pass = BGM.tell() - BgmNeedSkip[1]
                    if pass < .26 then
                        BGM.set('all', 'seek', BgmNeedSkip[2] + pass)
                    else
                        BGM.set('all', 'seek', BgmNeedSkip[2])
                    end
                    BgmNeedSkip = false
                end
            end
            if BgmNeedStop then
                if BGM.tell() > BgmNeedStop - .0626 then
                    BGM.stop(.0626)
                    BgmNeedStop = false
                end
            end
        end

        local dt = yield()

        -- Speedrun timer
        STAT.srTimer_life = STAT.srTimer_life + dt

        -- Mouse holding animation
        if not CONF.syscursor then
            pressValue = msIsDown(1, 2) and 1 or expApproach(pressValue, 0, dt * 12)
        end

        -- Achievement saving
        if saveAchvTimer then
            saveAchvTimer = saveAchvTimer - dt
            if saveAchvTimer <= 0 then
                saveAchvTimer = false
                SaveAchv()
            end
        end

        -- uVL timer reducing
        for k, v in next, uVLpool do
            uVLpool[k] = max(v - dt, 0)
        end

        -- Reverse background animation
        if GAME.revDeckSkin and SYSTEM ~= 'Web' then
            if M.NH > 0 then dt = dt * (1 - M.NH * .42) end
            if M.AS > 0 then dt = dt * (1 + M.AS) end
            t = t + dt
            local v = dt * GAME.bgXdir * (26 + 2.6 * GAME.rank)
            if M.GV > 0 then v = v * (.62 + M.GV * 2.6 * math.sin(t * 2.6 * (M.GV - .5))) end
            GAME.bgX = GAME.bgX + v
        end

        -- Button text animation
        if TASK.lock("buttonTextCD", GAME.nightcore and .014 or GAME.slowmo and .22 or .035) then
            local changed
            if M.DH == 0 then
                if startBtnPtr > 1 then
                    startBtnPtr = startBtnPtr - 1
                    changed = true
                end
            else
                if startBtnPtr < 14 then -- #startBtnTexts
                    startBtnPtr = startBtnPtr + 1
                    changed = true
                end
            end
            if changed then
                local W = SCN.scenes.tower.widgetList.start
                W.text = startBtnTexts[startBtnPtr]
                W:reset()
                changed = false
            end

            if M.AS == 0 then
                if resetBtnPtr > 1 then
                    resetBtnPtr = resetBtnPtr - 1
                    changed = true
                end
            else
                if resetBtnPtr < 10 then -- #resetBtnTexts
                    resetBtnPtr = resetBtnPtr + 1
                    changed = true
                end
            end
            if changed then
                local W = SCN.scenes.tower.widgetList.reset
                W.text = resetBtnTexts[resetBtnPtr]
                W:reset()
            end
        end

        if GAME.finishTera and GAME.endFloorFstr[1] and TASK.lock('teraScroll', .05) then
            local l = GAME.endFloorFstr
            local lastColor = l[#l - 1]
            for i = #l - 1, 1, -2 do
                l[i] = l[i - 2]
            end
            l[1] = lastColor
            TEXTS.endFloor:set(l)
        end
    end
end

-- Functions: Secret Content

---@diagnostic disable-next-line
loadstring(love.data.decompress('string', 'deflate', love.data.decode('string', 'base64', [[bdJRa4MwEADgvyKBQgUpHexxDtLkWgMxDhPL+ihTWYfVQfWp+N+X5MqWsT3enbn7crGbh7fpPA5RdW1pP6n60q5jQ3cSNvNnU0/tOh8bXk91cuvmvnf19AavKXmKcqoNlNEzSVTmYlGWcCwY3QkpzMnlc+3yLAPQ4OLD0cUcmBSKGlEolzxKf1hpE5zkvmMuNMuEbVppBVq7glCukAku1MHF1I8oCynvCf6CiZwq5oYuSd18IBnB+0qieG8REpGeeEIg8mw3pFUeJgFNgQgtVsJBoeOuQIMXGMEsYBjnIRQE4+11AwGEAr8gNATL+cNwi/mm+On/UxiQZYl/XjlVlZRROzTRuYvG68a/NVldVg2J05RsH7cPZHpvf/8Y9vMv]])))()

UTIL.time("Create util global vars & functions", true)
--------------------------------------------------------------

for i = 1, #ModData.deck do table.insert(Cards, require 'module/card'.new(ModData.deck[i])) end
for _, C in ipairs(Cards) do Cards[C.id] = C end

SCN.addSwapStyle('warp', require 'module/warp_swap')

for _, v in next, love.filesystem.getDirectoryItems('scene') do
    if FILE.isSafe('scene/' .. v) then
        local sceneName = v:sub(1, -5)
        SCN.add(sceneName, FILE.load('scene/' .. v, '-lua'))
    end
end

TABLE.update(CONF, FILE.safeLoad('conf.luaon', '-luaon') or NONE)
TABLE.update(SR, FILE.safeLoad('speedrun.luaon', '-luaon') or NONE)
TABLE.update(LB, FILE.safeLoad('leaderboard.luaon', '-luaon') or NONE)
InitProfile()
LoadSave()
Initialize()

TABLE.update(TextColor, BaseTextColor)
TABLE.update(ShadeColor, BaseShadeColor)
RefreshDaily()
TEXTS.version:set(SYSTEM .. (CONF.oldHitbox and " T" or " V") .. (require 'version'.verStr))
GAME.refreshCurrentCombo()

GAME.refreshLayout()
for i, C in ipairs(Cards) do C.x, C.y = C.tx, C.ty + 260 + 26 * 1.6 ^ i end

if SYSTEM == 'Web' then
    _G[('DiscordRPC')] = { update = NULL, setEnable = NULL }
else
    DiscordRPC = require 'module/discordRPC'
    DiscordRPC.setAppID('1341822039253712989')
    DiscordRPC.setEnable(true)
    DiscordRPC.update {
        details = "QUICK PICK",
        state = "Enjoying Music",
    }
end

if curlAvailable then
    ASYNC.runCmd('checkUpdate', [[curl -s -X GET https://api.github.com/repos/MrZ626/ZenithClicker/releases/latest]])
end
if FILE.exist('avatar') then
    local suc, res = pcall(GC.newImage, 'avatar')
    if suc then AVATAR = res end
end

if not ACHV.return_to_the_light then
    if not FontLoaded then
        FILE.save('' .. os.time(), 'serifQuit')
    else
        local lastTime = tonumber(FILE.safeLoad('serifQuit') or false)
        if os.time() - (lastTime or 0) <= 26 then
            IssueAchv('return_to_the_light')
            FILE.delete('serifQuit')
        end
    end
end

UTIL.time("Boot Sequence", true)
--------------------------------------------------------------

UTIL.showTimeLog()

-- (Debug) SFX Test
TASK.new(function()
    for _, s in next, ([[ ]]):trim():split('%s+', true) do
        TASK.yieldT(1)
        SFX.play(s)
    end
end)
