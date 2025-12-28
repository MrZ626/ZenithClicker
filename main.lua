love.window.setIcon(love.image.newImageData('assets/icon.png'))

require 'Zenitha'

ZENITHA.setMainLoopSpeed(240)
ZENITHA.setRenderRate(50)
ZENITHA.setAppInfo("Zenith Clicker", SYSTEM .. " " .. (require 'version'.appVer))
ZENITHA.setClickDist(62)
ZENITHA._cursor.speed = 1600

STRING.install()

SCR.setSize(1600, 1000)

for _, v in next, {
    'customAssets',
    'customAssets/achievements',
    'customAssets/badges',
    'customAssets/card',
    'customAssets/music',
    'customAssets/panel',
    'customAssets/particle',
    'customAssets/rank',
    'customAssets/revive',
    'customAssets/stat',
    'customAssets/tower',
} do love.filesystem.createDirectory(v) end


---@return love.Texture
local function assets(path) return FILE.exist('customAssets/' .. path) and 'customAssets/' .. path or 'assets/' .. path end
local function q(oy, n, size)
    return GC.newQuad(
        n * size, oy,
        size, size,
        2178, 1663
    )
end
local function q2(ox, oy, w, h)
    return GC.newQuad(
        ox, oy,
        w, h,
        2178, 1663
    )
end
local function aq(x, y) return GC.newQuad((x - 1) % 16 * 256, (y - 1) % 16 * 256, 256, 256, 4096, 2048) end
TEXTURE = {
    star0 = assets 'crystal-dark.png',
    star1 = assets 'crystal.png',
    panel = {
        glass_a = assets 'panel/glass-a.png',
        glass_b = assets 'panel/glass-b.png',
        throb_a = assets 'panel/throb-a.png',
        throb_b = assets 'panel/throb-b.png',
    },
    modIcon = assets 'mod_icon.png',
    modQuad_ig = {
        VL = q(0, 0, 225),
        NH = q(0, 1, 225),
        MS = q(0, 2, 225),
        IN = q(0, 3, 225),
        GV = q(0, 4, 225),
        EX = q(0, 5, 225),
        DP = q(0, 6, 225),
        DH = q(0, 7, 225),
        AS = q(0, 8, 225),
        rVL = q(225, 0, 242),
        rNH = q(225, 1, 242),
        rMS = q(225, 2, 242),
        rIN = q(225, 3, 242),
        rGV = q(225, 4, 242),
        rEX = q(225, 5, 242),
        rDP = q(225, 6, 242),
        rDH = q(225, 7, 242),
        rAS = q(225, 8, 242),
    },
    modQuad_res = {
        VL = q(467, 0, 183),
        NH = q(467, 1, 183),
        MS = q(467, 2, 183),
        IN = q(467, 3, 183),
        GV = q(467, 4, 183),
        EX = q(467, 5, 183),
        DP = q(467, 6, 183),
        DH = q(467, 7, 183),
        AS = q(467, 8, 183),
        rVL = q(650, 0, 183),
        rNH = q(650, 1, 183),
        rMS = q(650, 2, 183),
        rIN = q(650, 3, 183),
        rGV = q(650, 4, 183),
        rEX = q(650, 5, 183),
        rDP = q(650, 6, 183),
        rDH = q(650, 7, 183),
        rAS = q(650, 8, 183),
    },
    modQuad_ultra_res = {
        rVL = q(833, 0, 183),
        rNH = q(833, 1, 183),
        rMS = q(833, 2, 183),
        rIN = q(833, 3, 183),
        rGV = q(833, 4, 183),
        rEX = q(833, 5, 183),
        rDP = q(833, 6, 183),
        rDH = q(833, 7, 183),
        rAS = q(833, 8, 183),
    },
    modQuad_ultra = {
        rNH = q2(0000, 1016, 315, 315),
        rMS = q2(0315, 1016, 315, 315),
        rGV = q2(0630, 1016, 315, 315),
        rVL = q2(0945, 1016, 315, 315),
        rDH = q2(0000, 1331, 315, 315),
        rIN = q2(0315, 1331, 315, 315),
        rAS = q2(0630, 1331, 315, 315),
        rEX = q2(0945, 1331, 315, 332),
        rDP = q2(1260, 1016, 419, 378),
    },
    EX = { lock = '_lockover_9', front = assets 'card/expert.png', back = assets 'card/expert-back.png' },
    NH = { lock = '_lockfull_2', front = assets 'card/nohold.png', back = assets 'card/nohold-back.png' },
    MS = { lock = '_lockfull_3', front = assets 'card/messy.png', back = assets 'card/messy-back.png' },
    GV = { lock = '_lockfull_4', front = assets 'card/gravity.png', back = assets 'card/gravity-back.png' },
    VL = { lock = '_lockfull_5', front = assets 'card/volatile.png', back = assets 'card/volatile-back.png' },
    DH = { lock = '_lockfull_6', front = assets 'card/doublehole.png', back = assets 'card/doublehole-back.png' },
    IN = { lock = '_lockfull_7', front = assets 'card/invisible.png', back = assets 'card/invisible-back.png' },
    AS = { lock = '_lockfull_8', front = assets 'card/allspin.png', back = assets 'card/allspin-back.png' },
    DP = { lock = '_lockover_?', front = assets 'card/duo.png', back = assets 'card/duo-back.png' },
    lockfull = assets 'card/lockfull.png',
    lockover = assets 'card/lockover.png',
    towerBG = { assets 'tower/f1.jpg', assets 'tower/f2.jpg', assets 'tower/f3.jpg', assets 'tower/f4.jpg', assets 'tower/f5.jpg', assets 'tower/f6.jpg', assets 'tower/f7.jpg', assets 'tower/f8.jpg', assets 'tower/f9.jpg', assets 'tower/f10.png' },
    moon = assets 'tower/moon.png',
    stars = assets 'tower/stars.png',

    revive = {
        norm = assets 'revive/norm.png',
        rev_left = assets 'revive/rev_left.png',
        rev_right = assets 'revive/rev_right.png',
    },
    spark = {
        assets 'particle/spark1.png',
        assets 'particle/spark2.png',
        assets 'particle/spark3.png',
    },

    stat = {
        avatar = assets 'stat/avatar.png',
        clicker = assets 'stat/clicker.png',
        clicker_star = assets 'stat/clicker_star.png',
        rank = {
            [0] = assets 'rank/z.png',
            assets 'rank/d.png',
            assets 'rank/d+.png',
            assets 'rank/c-.png',
            assets 'rank/c.png',
            assets 'rank/c+.png',
            assets 'rank/b-.png',
            assets 'rank/b.png',
            assets 'rank/b+.png',
            assets 'rank/a-.png',
            assets 'rank/a.png',
            assets 'rank/a+.png',
            assets 'rank/s-.png',
            assets 'rank/s.png',
            assets 'rank/s+.png',
            assets 'rank/ss.png',
            assets 'rank/u.png',
            assets 'rank/x.png',
            assets 'rank/x+.png',
        },
        badges = (function()
            local list = love.filesystem.getDirectoryItems('assets/badges')
            local l = {}
            for _, v in next, list do
                l[v:match('^(.*)%.png$')] = assets('badges/' .. v)
            end
            return l
        end)()
    },
    achievement = {
        icons = assets 'achievements/achv_icons.png',
        iconQuad = {
            _undef = aq(8, 8),

            contender = aq(2, 2),
            clicker = aq(1, 1),
            elegance = aq(4, 1),
            garbage_offensive = aq(3, 1),
            tower_climber = aq(8, 2),
            tower_regular = aq(8, 2),
            speed_player = aq(5, 2),
            plonk = aq(6, 2),
            zenith_explorer = aq(2, 3),
            zenith_explorer_plus = aq(2, 3),
            clicker_speedrun = aq(5, 1),
            naga_eyes = aq(8, 8),
            supercharged = aq(5, 6),
            supercharged_plus = aq(5, 6),
            multitasker = aq(7, 2),
            effective = aq(7, 2),
            zenith_speedrun = aq(2, 6),
            zenith_speedrun_plus = aq(2, 6),
            zenith_challenger = aq(11, 2),
            divine_challenger = aq(12, 2),
            zenith_speedrunner = aq(14, 2),
            divine_speedrunner = aq(13, 2),
            the_spike_of_all_time = aq(4, 2),
            the_spike_of_all_time_minus = aq(4, 2),
            clock_out = aq(13, 5),
            vip_list = aq(6, 6),

            EX = aq(3, 3),
            NH = aq(7, 3),
            MS = aq(8, 3),
            GV = aq(6, 3),
            VL = aq(5, 3),
            DH = aq(4, 3),
            IN = aq(1, 4),
            AS = aq(2, 4),
            DP = aq(3, 4),
            GVIN = aq(6, 4),
            ASNH = aq(4, 6),
            DPEX = aq(8, 5),
            GVNH = aq(4, 4),
            DHMSNH = aq(5, 4),
            DHEXNH = aq(7, 4),
            DHEXMSVL = aq(8, 4),
            ASEXVL = aq(1, 7),
            swamp_water_lite = aq(5, 7),
            swamp_water = aq(2, 5),

            rEX = aq(15, 1),
            rNH = aq(11, 1),
            rMS = aq(12, 1),
            rGV = aq(10, 1),
            rVL = aq(9, 1),
            rDH = aq(16, 1),
            rIN = aq(13, 1),
            rAS = aq(14, 1),
            rDP = aq(7, 7),
            rGVrIN = aq(9, 3),       -- The Grandmaster+
            EXNHrAS = aq(10, 7),     -- Magic School
            INrASrDHrNH = aq(14, 6), -- The Spellcaster
            DHEXrGV = aq(10, 3),     -- Demonic Speed
            EXGVNHrMS = aq(12, 6),   -- Bnuuy
            ASDPGVrMSrNH = aq(9, 2), -- Grand-Master! Rounds
            DHrEXrVL = aq(9, 6),     -- Sweat and Ruin
            ASGVrDPrMS = aq(13, 3),  -- Cupid's Gamble
            NHVLrDPrGV = aq(11, 6),  -- Despairful Longing
            VLrEXrIN = aq(16, 6),    -- Authoritarian Delusion
            rDPrEX = aq(12, 3),      -- Tyrannical Dyarchy
            INMSrDHrEX = aq(15, 6),  -- Sisyphean Monarchy
            ASMSrDHrIN = aq(13, 6),  -- Kitsune Trickery
            swamp_water_lite_plus = aq(15, 3),
            swamp_water_plus = aq(16, 3),

            -- Special, no texture needed
            blight = aq(0, 0),
            desolation = aq(0, 0),
            havoc = aq(0, 0),
            pandemonium = aq(0, 0),
            inferno = aq(0, 0),
            purgatory = aq(0, 0),
            perdition = aq(0, 0),
            cataclysm = aq(0, 0),
            annihilation = aq(0, 0),
            armageddon = aq(0, 0),
            abyss = aq(0, 0),

            talentless = aq(3, 7),
            quest_rationing = aq(2, 7),
            the_responsible_one = aq(1, 6),
            the_unreliable_one = aq(15, 2),
            the_responsible_one_plus = aq(1, 6),
            guardian_angel = aq(3, 6),
            carried = aq(3, 8),
            level_19_cap = aq(16, 2),
            the_escape_artist = aq(1, 5),
            fel_magic = aq(9, 7),
            empurple = aq(13, 7),
            faltered = aq(7, 5),
            patience_is_a_virtue = aq(10, 6),
            spotless = aq(16, 4),
            a_mutual_agreement = aq(13, 4),
            the_cheaters = aq(12, 4),
            overprotection = aq(12, 7),
            clutch_main = aq(14, 3),
            sunk_cost = aq(11, 5),
            wax_wings = aq(12, 5),
            the_masterful_juggler = aq(11, 7),
            the_oblivious_artist = aq(14, 7),
            zero_to_sixty = aq(10, 5),
            speed_bonus = aq(9, 4),
            arrogance = aq(3, 5),
            scarcity_mindset = aq(4, 1),
            detail_oriented = aq(8, 6),
            psychokinesis = aq(8, 6),
            divine_rejection = aq(7, 6),
            moon_struck = aq(7, 6),
            lovers_promise = aq(8, 7),

            hardcore_beginning = aq(16, 5),
            love_hotel = aq(16, 5),
            financially_responsible = aq(16, 5),
            unfair_battle = aq(16, 5),
            museum_heist = aq(16, 5),
            workaholic = aq(16, 5),
            human_experiment = aq(16, 5),
            thermal_anomaly = aq(16, 5),
            ultra_dash = aq(16, 5),
            perfect_speedrun = aq(15, 5),
            the_perfectionist = aq(15, 5),
            cruise_control = aq(15, 5),
            dazed = aq(5, 6),
            drag_racing = aq(5, 6),
            space_race = aq(5, 6),
            fickle_fuel = aq(9, 5),
            the_spike_of_all_time_plus = aq(5, 6),

            cut_off = aq(6, 2),
            worn_out = aq(6, 2),
            the_harbinger = aq(5, 8),
            final_defiance = aq(3, 2),
            speedrun_speedrunning = aq(5, 2),
            abyss_weaver = aq(5, 2),
            royal_resistance = aq(10, 2),
            lovers_stand = aq(10, 2),
            romantic_homicide = aq(4, 8),
            benevolent_ambition = aq(15, 4),
            blazing_speed = aq(10, 4),
            dusty_memories = aq(11, 4),
            its_kinda_rare = aq(14, 4),
            fruitless_effort = aq(6, 7),
            false_god = aq(2, 8),

            identity = aq(6, 6),
            respectful = aq(2, 1),
            zenith_relocation = aq(4, 7),
            intended_glitch = aq(11, 4),
            lucky_coincidence = aq(14, 5),
            zenith_traveler = aq(1, 8),
            dark_force = aq(3, 1),
            return_to_the_light = aq(5, 5),
            smooth_dismount = aq(4, 1),
        },
        frame = {
            [0] = assets 'achievements/frames/none.png',
            assets 'achievements/frames/bronze.png',
            assets 'achievements/frames/silver.png',
            assets 'achievements/frames/gold.png',
            assets 'achievements/frames/platinum.png',
            assets 'achievements/frames/diamond.png',
            assets 'achievements/frames/issued.png',
        },
        ring = assets 'achievements/frames/ring-piece.png',
        wreath = {
            assets 'achievements/wreaths/t100.png',
            assets 'achievements/wreaths/t50.png',
            assets 'achievements/wreaths/t25.png',
            assets 'achievements/wreaths/t10.png',
            assets 'achievements/wreaths/t5.png',
            assets 'achievements/wreaths/t3.png',
        },
        glint_1 = assets 'achievements/glint-a.png',
        glint_2 = assets 'achievements/glint-b.png',
        glint_3 = assets 'achievements/glint-c.png',
        competitive = assets 'achievements/competitive.png',
        hidden = assets 'achievements/hidden.png',
        event = assets 'achievements/event.png',
        unranked = assets 'achievements/unranked.png',
        extra = assets 'achievements/extra.png',
        overDev = assets 'achievements/verified-halfmod.png',
    },

    logo = assets 'icon.png',
    logo_old = assets 'icon_old.png',
}
TEXTURE = TABLE.linkSource({}, TEXTURE, function(path)
    if type(path) ~= 'string' then return path end
    if path:match('^_lock') then
        local lockType = path:match('_(lock....)')
        local char = path:sub(-1)
        local C = GC.newCanvas(TEXTURE[lockType]:getDimensions())
        GC.setCanvas(C)
        GC.origin()
        GC.setColor(1, 1, 1)
        GC.draw(TEXTURE[lockType], 0, 0)
        local t = GC.newText(FONT.get(70, 'sans'), char)
        if lockType == 'lockfull' then
            GC.setColor(COLOR.HEX "646483FF")
            for i = 0, 25 do
                local angle = i / 26 * MATH.tau
                local dx, dy = math.cos(angle) * 2, math.sin(angle) * 2
                GC.mDraw(t, C:getWidth() * .51 + dx, C:getHeight() * .526 + dy, 0, 2)
            end
        else
            GC.setColor(COLOR.HEX "544F65FF")
            for i = 0, 25 do
                local angle = i / 26 * MATH.tau
                local dx, dy = math.cos(angle) * 1.6, math.sin(angle) * 1.6
                GC.mDraw(t, C:getWidth() * .495 + dx, C:getHeight() * .52 + dy, 0, 1.5)
            end
        end
        t:release()
        GC.setCanvas()
        return C
    else
        local suc, res = pcall(love.graphics.newImage, path)
        if not suc then
            MSG.log('error', ("Cannot load image '%s': %s"):format(path, res))
            return PAPER
        end
        return res
    end
end)

TEXTURE.pixel = GC.load { w = 1, h = 1, { 'clear', 1, 1, 1 } }

TEXTURE.ruler = GC.newCanvas(32, 600)
GC.setCanvas(TEXTURE.ruler)
for y = 0, 199 do
    local w =
        y % 200 == 0 and 32 or
        y % 40 == 0 and 20 or
        y % 8 == 0 and 10 or
        6
    local l = .4 + .6 * w / 32
    GC.setColor(l, l, l)
    GC.rectangle('fill', 16 - w / 2, y * 3, w, 1)
end
GC.setColor(1, 1, 1)
GC.rectangle('fill', 0, 1, 32, 1)
GC.rectangle('fill', 0, 600, 32, -1)

TEXTURE.transition = GC.newCanvas(128, 1)
GC.setCanvas(TEXTURE.transition)
for x = 0, 127 do
    GC.setColor(1, 1, 1, 1 - x / 128)
    GC.rectangle('fill', x, 0, 1, 1)
end
TEXTURE.ruler:setFilter('nearest', 'nearest')
TEXTURE.ruler:setWrap('repeat', 'repeat')

TEXTURE.darkCorner = GC.newCanvas(128, 128)
GC.setCanvas(TEXTURE.darkCorner)
GC.setColor(0, 0, 0)
GC.blurCircle(.626, 64, 64, 64)

TEXTURE.lightDot = GC.newCanvas(32, 32)
GC.setCanvas(TEXTURE.lightDot)
GC.clear(1, 1, 1, 0)
GC.setColor(1, 1, 1)
GC.blurCircle(.26, 16, 16, 16)

TEXTURE.recRevBG = GC.newCanvas(1586, 606)
GC.setCanvas(TEXTURE.recRevBG)
GC.setColor(1, 1, 1)
GC.draw(TEXTURE.panel.glass_a)
GC.draw(TEXTURE.panel.glass_b)

TEXTURE.recRevLight = GC.newCanvas(165, 120)
GC.setCanvas(TEXTURE.recRevLight)
GC.clear(1, .1, .1, 0)
GC.setColor(1, .1, .1)
GC.blurCircle(-.2, 60, 60, 60)
GC.blurCircle(-.6, 105, 60, 60)
GC.setCanvas()



FONT.load {
    serif = "assets/AbhayaLibre-Regular.ttf",
    sans = "assets/DINPro-Medium.otf",
    led = "assets/UniDreamLED.ttf",
}
FontLoaded = SYSTEM == 'Web' or MATH.roll(.62)
FONT.setDefaultFont(FontLoaded and 'sans' or 'serif')
FONT.setOnInit(function(font, size)
    font:setFallbacks(FONT.get(size, '_norm'))
end)

BG.add('black', { draw = function() GC.clear(0, 0, 0) end })
BG.set('black')

TEXTS = { -- Font size can only be 30 and 50 here !!!
    version    = GC.newText(FONT.get(30)),
    mod        = GC.newText(FONT.get(30)),
    mpPreview  = GC.newText(FONT.get(30)),
    zpPreview  = GC.newText(FONT.get(30)),
    zpChange   = GC.newText(FONT.get(30)),
    dcBest     = GC.newText(FONT.get(30)),
    dcTimer    = GC.newText(FONT.get(30)),
    title      = GC.newText(FONT.get(50), "EXPERT QUICK PICK"),
    load       = GC.newText(FONT.get(50), "JOINING ROOM..."),
    pb         = GC.newText(FONT.get(50)),
    endResult  = GC.newText(FONT.get(30)),
    endHeight  = GC.newText(FONT.get(50)),
    endFloor   = GC.newText(FONT.get(30)),
    linePB     = GC.newText(FONT.get(50), "PB"),
    lineKM     = GC.newText(FONT.get(50), "1000"),
    height     = GC.newText(FONT.get(30)),
    time       = GC.newText(FONT.get(30)),
    rank       = GC.newText(FONT.get(30)),
    chain      = GC.newText(FONT.get(50)),
    chain2     = GC.newText(FONT.get(50, 'led')),
    b2b        = GC.newText(FONT.get(30), "B2B x"),
    spike      = GC.newText(FONT.get(50)),
    gigaspeed  = GC.newText(FONT.get(50), {
        COLOR.dR, "G", COLOR.dO, "I", COLOR.dY, "G",
        COLOR.dK, "A", COLOR.dG, "S", COLOR.dJ, "P",
        COLOR.dC, "E", COLOR.dS, "E", COLOR.dB, "D"
    }),
    teraspeed  = GC.newText(FONT.get(50), {
        COLOR.R, "T", COLOR.O, "E", COLOR.Y, "R",
        COLOR.K, "A", COLOR.G, "S", COLOR.J, "P",
        COLOR.C, "E", COLOR.S, "E", COLOR.B, "D",
    }),
    gigatime   = GC.newText(FONT.get(50)),
    floorTime  = GC.newText(FONT.get(30)),
    rankTime   = GC.newText(FONT.get(30)),
    slogan     = GC.newText(FONT.get(30), "CROWD THE TOWER!"),
    slogan_EX  = GC.newText(FONT.get(30), "THRONG THE TOWER!"),
    slogan_rEX = GC.newText(FONT.get(30), "OVERFLOW THE TOWER!"),
    forfeit    = GC.newText(FONT.get(50), "KEEP HOLDING TO FORFEIT"),
    credit     = GC.newText(FONT.get(30), "Almost all assets from TETR.IO"),
    test       = GC.newText(FONT.get(50), "TEST"),
}
if not FontLoaded then
    TASK.new(function()
        local loadTime = love.timer.getTime() + (MATH.roll(.9626) and MATH.rand(2.6, 6.26) or 26)
        while love.timer.getTime() < loadTime do
            TASK.yieldT(0.1)
            if GAME.anyRev then
                TASK.yieldT(0.26)
                SFX.play('staffsilence')
                MSG('dark', "A DARK FORCE INTERRUPTED THE FONT LOADING")
                IssueAchv('dark_force')
                return
            end
            if SCN.cur == 'about' then
                TASK.yieldT(0.26)
                SFX.play('staffspam')
                break
            end
        end
        FONT.setDefaultFont('sans')
        FontLoaded = true
        ReloadTexts()
        FILE.save('', 'serifQuit')
    end)
end

local button_invis = WIDGET.newClass('button_invis', 'button')
button_invis.draw = NULL

Metatable = {
    best_highscore = { __index = function() return 0 end },
    best_speedrun = { __index = function() return 1e99 end },
}
BEST = {
    highScore = setmetatable({}, Metatable.best_highscore),
    speedrun = setmetatable({}, Metatable.best_speedrun),
}

STAT = {
    mod = 'vanilla',
    version = nil, -- will be set after loading
    system = SYSTEM,
    joinDate = os.date("%b %Y"),
    hid = os.date("%d%S%m%M%y%H") .. math.random(26000, 42000) .. math.random(42000, 62000),
    uid = "ANON-" .. os.date("%d_") .. math.random(2600, 6200),
    keybind = {
        "q", "w", "e", "r", "t", "y", "u", "i", "o",
        "a", "s", "d", "f", "g", "h", "j", "k", "l",
        "space", "z", "x", "c"
    },
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
    badge = {},

    fullscreen = true,
    syscursor = false,
    cardBrightness = 90,
    bgBrightness = 40,
    bg = true,
    sfx = 60,
    bgm = 100,

    startCD = true,
    autoMute = false,
    oldHitbox = false,
}

ACHV = {}

AchvNotice = {}

TestMode = false

function SaveBest() if not TestMode then love.filesystem.write('best.luaon', 'return' .. TABLE.dumpDeflate(BEST)) end end

function SaveStat() if not TestMode then love.filesystem.write('stat.luaon', 'return' .. TABLE.dumpDeflate(STAT)) end end

function SaveAchv() if not TestMode then love.filesystem.write('achv.luaon', 'return' .. TABLE.dumpDeflate(ACHV)) end end

MSG.setSafeY(75)
MSG.addCategory('dark', COLOR.D, COLOR.L)
MSG.addCategory('bright', COLOR.L, COLOR.D)

AchvData = {
    [0] = { id = 'achv_none', bg = COLOR.D, fg = COLOR.LD, fg2 = COLOR.LD },
    { id = 'achv_bronze',   bg = COLOR.DO,          fg = COLOR.lO, fg2 = COLOR.O },
    { id = 'achv_silver',   bg = { .26, .26, .26 }, fg = COLOR.L,  fg2 = COLOR.dL },
    { id = 'achv_gold',     bg = COLOR.DY,          fg = COLOR.lY, fg2 = COLOR.Y },
    { id = 'achv_platinum', bg = COLOR.DJ,          fg = COLOR.lJ, fg2 = COLOR.J },
    { id = 'achv_diamond',  bg = COLOR.DP,          fg = COLOR.lP, fg2 = COLOR.lB },
    { id = 'achv_issued',   bg = COLOR.DM,          fg = COLOR.lM, fg2 = COLOR.lM },
}
for i = 0, 6 do MSG.addCategory(AchvData[i].id, AchvData[i].bg, COLOR.L, TEXTURE.achievement.frame[i]) end
for i = 1, 6 do MSG.addCategory("wreath_" .. i, AchvData[5].bg, COLOR.L, GC.load { w = 256, { 'draw', TEXTURE.achievement.frame[5] }, { 'draw', TEXTURE.achievement.wreath[i] } }) end

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

MX, MY = -260, 0

---@type Map<Card>
Cards = {}

---@type nil|number
FloatOnCard = nil

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
StarPS = GC.newParticleSystem(TEXTURE.stars, 32)
StarPS:setParticleLifetime(2.6)
StarPS:setRotation(0, 6.26)
StarPS:setEmissionRate(12)
---@diagnostic disable-next-line
StarPS:setColors(COLOR.LX, COLOR.L, COLOR.L, COLOR.L, COLOR.L, COLOR.L, COLOR.L, COLOR.LX)

WoundPS = GC.newParticleSystem(GC.load { w = 16, h = 16,
    { 'clear', 1, 1, 1 },
    { 'setCL', 0, 0, 0 },
    { 'fRect', 1, 1, 14, 14 },
}, 32)
WoundPS:setEmissionArea('uniform', 42, 42, 0)
WoundPS:setParticleLifetime(2.6, 6.2)
WoundPS:setSpread(6.28)
WoundPS:setSpeed(26, 42)
---@diagnostic disable-next-line
WoundPS:setColors(COLOR.LX, COLOR.L, COLOR.L, COLOR.L, COLOR.L, COLOR.L, COLOR.L, COLOR.LX)


SparkPS = {}
for i = 1, 3 do
    local ps = GC.newParticleSystem(TEXTURE.spark[i])
    ps:setParticleLifetime(.26, .62)
    ps:setEmissionArea('ellipse', 62, 62, 0)
    ---@diagnostic disable-next-line
    ps:setColors(COLOR.L, COLOR.LX)
    SparkPS[i] = ps
end

BgScale = 1

require 'module/game_data'
require 'module/achv_data'
require 'module/shader'
require 'module/game'

for i = 1, #ModData.deck do table.insert(Cards, require 'module/card'.new(ModData.deck[i])) end
GAME.refreshLayout()
for i, C in ipairs(Cards) do
    Cards[C.id], C.x, C.y = C, C.tx, C.ty + 260 + 26 * 1.6 ^ i
end

SCN.addSwapStyle('warp', require 'module/warp_swap')

SCN.add('joining', require 'module/scene/joining')
SCN.add('tower', require 'module/scene/tower')
SCN.add('stat', require 'module/scene/stat')
SCN.add('records', require 'module/scene/records')
SCN.add('achv', require 'module/scene/achv')
SCN.add('conf', require 'module/scene/conf')
SCN.add('about', require 'module/scene/about')
SCN.add('ending', require 'module/scene/ending')
ZENITHA.setFirstScene('joining')

local gc = love.graphics

local pressValue = 0

CursorProgress = 0
CursorHide = true
local function starCursor(x, y)
    if CursorHide or GAME.zenithTraveler then return end
    GC.translate(x, y)
    GC.scale(1.42)
    GC.rotate(MATH.lerp(-.626, -1.2, pressValue))
    GC.scale(.8 + .2 * pressValue, 1)
    local l = .626 + .374 * pressValue
    GC.setColor(l, l, l)
    GC.draw(TEXTURE.star0, 0, -6, 0, .14, .3, TEXTURE.star1:getWidth() * .5, 0)
    GC.scale(.12, .26)
    GC.setShader(SHADER.coloring)
    GC.setColor(1, .626, .5)
    GC.draw(TEXTURE.star0, -150, 0)
    if CursorProgress <= .384626 then
        local t = MATH.interpolate(0, 1, .384626, 0, CursorProgress)
        GC.setColor(.9, .9, .9, t)
        GC.draw(TEXTURE.star0, -150, 0)
        GC.setShader()
    else
        GC.setShader()
        GC.setColor(1, 1, 1, MATH.iLerp(.384626, 1, CursorProgress))
        GC.draw(TEXTURE.star1, -150, 0)
    end
end

local M = GAME.mod

--[[
# F0 (Watchful Eye)           4|4      ♩ = 184         C Minor
# F1 (Divine Registration)    4|4      ♩ = 184         C Minor
# F2 (Zenith Hotel)           4|4      ♩ = 110         D Major / B Minor
# F3 (Empty Prayers)         12|8      ♩.= 120         C Major / A Minor
# F4 (Crowd Control)          5|8      ♪ = 180         F♯ Minor
# F5 (Phantom Memories)       4|4 6|8  ♩ = 130 ♩.= 130 E Minor
# F6 (Echo)                   4|4      ♩ = 65          A Minor
# F7 (Cryptic Chemistry)      4|4      ♩ = 120         A+50 Minor
# F8 (Chrono Flux)            4|4      ♩ = 150         E Minor
# F9 (Broken Record)          4|4      ♩ = 160         E Minor
# F10 (Deified Validation)    4|4      ♩ = 98          C Major / C Minor
# Hyper (Schnellfeuer Bullet) 4|4      ♩ = 240         C♯ Minor
]]

BgmSet = {
    f0 = {
        'piano',
        'arp', 'bass', 'guitar', 'pad', 'staccato', 'violin',
        'expert', 'rev',
        'piano2', 'violin2',
    },
    f1 = { 'f1', 'f1ex', 'f1rev' },
}

---@enum (key) ZC.bgmName
BgmData = {
    f0 = { meta = '4|4  184 BPM  C Minor', bar = 4, bpm = 184, toneFix = 0, loop = { 0, 114.7826 } },
    f1 = { meta = '4|4  184 BPM  C Minor', bar = 4, bpm = 184, toneFix = 0, loop = { 7.826, 91.304 }, introLen = 1.304, teleport = { -1, 7.826 } },
    f2 = { meta = '4|4  110 BPM  D Major & B Minor', bar = 4, bpm = 110, toneFix = -1, loop = { 26.181, 113.454 } },
    f2r = { meta = '4|4  110 BPM  D Major & B Minor', bar = 4, bpm = 110, toneFix = -1, loop = { 26.181, 113.454 } },
    f3 = { meta = '12|8  120 BPM  C Major & A Minor', bar = 4, bpm = 120, toneFix = -1, loop = { 48, 128 } },
    f3r = { meta = '12|8  120 BPM  C Major & A Minor', bar = 4, bpm = 120, toneFix = -1, loop = { 48, 128 } },
    f4 = { meta = '5|8  180 BPM  F# Minor', bar = 5, bpm = 180, toneFix = 1, loop = { 13.333, 93.333 } },
    f4r = { meta = '5|8  180 BPM  F# Minor', bar = 5, bpm = 180, toneFix = 1, loop = { 13.333, 93.333 } },
    f5 = { meta = '4|4 6|8  130 BPM  E Minor', bar = 4, bpm = 130, toneFix = -1, loop = { 96, 169.846 } },
    f5r = { meta = '4|4 6|8  130 BPM  E Minor', bar = 4, bpm = 130, toneFix = -1, loop = { 96, 169.846 } },
    f6 = { meta = '4|4  65 BPM  A Minor', bar = 4, bpm = 65, toneFix = 2, loop = { 29.538, 103.384 } },
    f6r = { meta = '4|4  65 BPM  G Minor', bar = 4, bpm = 65, toneFix = 0, loop = { 29.538, 103.384 } },
    f7 = { meta = '4|4  120 BPM  A+50c Minor', bar = 4, bpm = 120, toneFix = 2.5, loop = { 128, 192 } },
    f7r = { meta = '4|4  120 BPM  A+50c Minor', bar = 4, bpm = 120, toneFix = 2.5, loop = { 128, 192 }, teleport = { 8, 32 } },
    f8 = { meta = '4|4  150 BPM  E Minor', bar = 4, bpm = 150, toneFix = -1, loop = { 38.4, 134.4 } },
    f8r = { meta = '4|4  150 BPM  E Minor', bar = 4, bpm = 150, toneFix = -1, loop = { 38.4, 134.4 } },
    f9 = { meta = '4|4  160 BPM  E Minor', bar = 4, bpm = 160, toneFix = -1, loop = { 36, 144 } },
    f9r = { meta = '4|4  160 BPM  E Minor', bar = 4, bpm = 160, toneFix = -1, loop = { 36, 144 } },
    f10 = { meta = '4|4  98 BPM  C Major & C Minor', bar = 4, bpm = 98, toneFix = 0, loop = { 203.877, 311.632 } },
    f10r = { meta = '4|4  98 BPM  C Major & C Minor', bar = 4, bpm = 98, toneFix = 0, loop = { 203.877, 311.632 } },
    fomg = { meta = '4|4  90 & 100 BPM  Db Major & Bb Minor', bar = 4, bpm = 100, toneFix = 3, loop = { 38.4 - 11.862, 144 - 11.862 }, end1 = 144 - 11.862, end2 = 153.6 - 11.862 },
    tera = { meta = '4|4  240 BPM  C# Minor', bar = 4, bpm = 240, toneFix = 1, loop = { 76, 140 }, introLen = 2, teleport = { -1, 20 }, end1 = 140, end2 = 142, end3 = 144, end4 = 146 },
    terar = { meta = '4|4  240 BPM  C# Minor', bar = 4, bpm = 240, toneFix = 1, loop = { 84 - 15.565, 172 - 15.565 }, teleport = { 0, 18 - 15.565 } },
}

BgmPlaying = false ---@type ZC.bgmName | false
BgmLooping = false
BgmNeedSkip = false
BgmNeedStop = false

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

    local last = BgmPlaying

    if GAME.playing and RevMusicMode() then name = name .. 'r' end
    if name == 'fomgr' then name = 'fomg' end
    if name:sub(1, 2) == 'f0' then
        BgmPlaying = 'f0'
    elseif name:sub(1, 2) == 'f1' and name:sub(1, 3) ~= 'f10' then
        BgmPlaying = 'f1'
    else
        BgmPlaying = name
    end

    if not BgmData[BgmPlaying] then return end
    BgmLooping = BgmData[BgmPlaying].loop
    BgmNeedSkip = BgmData[BgmPlaying].teleport
    BgmNeedStop = false

    if BgmPlaying == 'f0' then
        BgmLooping = false
        BGM.play(BgmSet.f0)
        RefreshBGM(name)
    elseif BgmPlaying == 'f1' then
        BGM.play(BgmSet.f1, force and '' or '-sdin')
        local start = math.random(3, 5) * BgmData.f1.introLen
        BgmNeedSkip[1] = start + BgmData.f1.introLen
        BGM.set('all', 'seek', start)
        RefreshBGM(name)
    elseif name == 'tera' then
        BGM.play('tera', '-sdin')
        local startFrom
        startFrom = last and tonumber(last:match("%d+"))
        if startFrom then startFrom = startFrom - 1 end
        local start = (GAME.playing and GAME.floor or startFrom or math.random(0, 9)) * BgmData.tera.introLen
        BgmNeedSkip[1] = start + BgmData.tera.introLen
        BGM.set('all', 'seek', start)
        RefreshBGM()
    else
        if BGM.play(name, force and '' or '-sdin') then
            RefreshBGM()
        end
    end
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
    COLOR.LL, "There's no more achievements, and ", COLOR.lR, "you are not expected to go very high up.\n",
    COLOR.R, "Give Up: ", COLOR.LL, "ESC    ", COLOR.R, "Forfeit: ", COLOR.LL, "ESC    ", COLOR.R, "Quit: ", COLOR.LL, "ESC"
}
function RefreshHelpText()
    local s = SCN.scenes.tower.widgetList
    ---@cast s Map<Zenitha.Widget.base|Zenitha.WidgetArg>
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
        normalHelp[#normalHelp] = ("Commit: $1    Reset: $2    Forfeit/Quit: ESC"):repD(STAT.keybind[19]:upper(), STAT.keybind[20]:upper())
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
    if BgmPlaying == 'f1' then
        outroStart = D.loop[2] + 4 * 60 / D.bpm
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f2' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f3' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f4' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 10 * 60 / D.bpm
    elseif BgmPlaying == 'f5' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f6' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 4 * 60 / D.bpm
    elseif BgmPlaying == 'f7' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f8' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f9' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f10' then
        if BGM.tell() < 28 * 4 * 60 / D.bpm then
            BGM.stop(4.2)
            TASK.yieldT(4.2)
        elseif BGM.tell() < 59 * 4 * 60 / D.bpm then
            BGM.set('all', 'seek', 59 * 4 * 60 / D.bpm)
            BgmNeedStop = BGM.tell() + 5 * 60 / D.bpm
        elseif BGM.tell() < 77.25 * 4 * 60 / D.bpm then
            BGM.stop(4.2)
            TASK.yieldT(4.2)
        else
            outroStart = D.loop[2]
            BgmNeedStop = outroStart + 8 * 60 / D.bpm
        end
    elseif BgmPlaying == 'fomg' then
        if BGM.tell() > D.loop[1] then
            outroStart = D.loop[2]
            BgmNeedStop = outroStart + 13 * 60 / D.bpm
        else
            outroStart = D.loop[2] + 16 * 60 / D.bpm
            BgmNeedStop = outroStart + 8 * 60 / D.bpm
        end
    elseif BgmPlaying == 'f1r' then
        outroStart = D.loop[2] + 4 * 60 / D.bpm
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f2r' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f3r' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f4r' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 10 * 60 / D.bpm
    elseif BgmPlaying == 'f5r' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f6r' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 4 * 60 / D.bpm
    elseif BgmPlaying == 'f7r' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f8r' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f9r' then
        outroStart = D.loop[2]
        BgmNeedStop = outroStart + 8 * 60 / D.bpm
    elseif BgmPlaying == 'f10r' then
        if BGM.tell() < 28 * 4 * 60 / D.bpm then
            BGM.stop(6.2)
            TASK.yieldT(6.2)
        elseif BGM.tell() < 59 * 4 * 60 / D.bpm then
            BGM.set('all', 'seek', 59 * 4 * 60 / D.bpm)
            BgmNeedStop = BGM.tell() + 5 * 60 / D.bpm
        elseif BGM.tell() < 77.25 * 4 * 60 / D.bpm then
            BGM.stop(6.2)
            TASK.yieldT(6.2)
        else
            outroStart = D.loop[2]
            BgmNeedStop = outroStart + 8 * 60 / D.bpm
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

function Tone(pitch)
    return pitch + (URM and M.GV == 2 and 3 or M.GV) + BgmData[BgmPlaying].toneFix
end

function ApplySettings()
    love.mouse.setVisible(STAT.syscursor)
    ZENITHA.globalEvent.drawCursor = STAT.syscursor and NULL or starCursor
    SFX.setVol(STAT.sfx / 100)
    BGM.setVol(STAT.bgm / 100)
end

function ReloadTexts()
    local sep = (TEXTS.mod:getFont():getHeight() + TEXTS.title:getFont():getHeight()) / 2
    for _, text in next, TEXTS do text:setFont(FONT.get(text:getFont():getHeight() < sep and 30 or 50)) end
    for _, text in next, ShortCut do text:setFont(FONT.get(text:getFont():getHeight() < sep and 30 or 50)) end
    for _, quest in next, GAME.quests do quest.name:setFont(FONT.get(70)) end
    TEXTS.height:setFont(FONT.get(30))
    TEXTS.time:setFont(FONT.get(30))
    TEXTS.gigatime:setFont(FONT.get(50))
    TEXTS.chain2:setFont(FONT.get(50, 'led'))
    for _, W in next, SCN.scenes.tower.widgetList do W:reset() end
    for _, W in next, SCN.scenes.stat.widgetList do W:reset() end
    for _, W in next, SCN.scenes.achv.widgetList do W:reset() end
    for _, W in next, SCN.scenes.conf.widgetList do W:reset() end
    for _, W in next, SCN.scenes.about.widgetList do W:reset() end
    for _, W in next, SCN.scenes.records.widgetList do W:reset() end
    AboutText:setFont(FONT.get(70))
    DevNoteText:setFont(FONT.get(30))
    EndText:setFont(FONT.get(70))
    EndText2:setFont(FONT.get(70))
    if SCN.cur == 'stat' then RefreshProfile() end
    if SCN.cur == 'records' then SCN.scenes.records.load() end
end

VALENTINE = false
VALENTINE_TEXT = "FLOOD THE TOWER SIDE BY SIDE WITH WHAT COULD BE"
XMAS=false
ZDAY = false
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
            STAT.dailyMastered = false
            LOG('info', "ZP: " .. math.floor(oldZP / 1000 + .5) .. "k -> " .. math.floor(STAT.zp / 1000 + .5) .. "k")
            LOG('info', "DZP: " .. math.floor(oldDZP) .. " -> " .. math.floor(STAT.dzp))
        end
        STAT.lastDay = os.time()
    end

    for x = 0, 0 do
        -- for x = 0, 1e99 do
        math.randomseed(os.date("!%Y%m%d") + x)
        for _ = 1, 26 do math.random() end

        local modCount = math.ceil(9 - math.log(math.random(11, 42), 1.62)) -- 5 444 3333 2222
        DAILY = {}

        DailyActived = false
        DailyAvailable = false

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
        -- assert(table.concat(DAILY, ' ')~="rEX rDP","Appears after "..x.." days later")
        LOG('info', "Today's Daily Challenge: " .. table.concat(DAILY, ' '))
    end

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

loadstring(love.data.decompress('string', 'deflate', love.data.decode('string', 'base64', [[bdJRa4MwEADgvyKBQgUpHexxDtLkWgMxDhPL+ihTWYfVQfWp+N+X5MqWsT3enbn7crGbh7fpPA5RdW1pP6n60q5jQ3cSNvNnU0/tOh8bXk91cuvmvnf19AavKXmKcqoNlNEzSVTmYlGWcCwY3QkpzMnlc+3yLAPQ4OLD0cUcmBSKGlEolzxKf1hpE5zkvmMuNMuEbVppBVq7glCukAku1MHF1I8oCynvCf6CiZwq5oYuSd18IBnB+0qieG8REpGeeEIg8mw3pFUeJgFNgQgtVsJBoeOuQIMXGMEsYBjnIRQE4+11AwGEAr8gNATL+cNwi/mm+On/UxiQZYl/XjlVlZRROzTRuYvG68a/NVldVg2J05RsH7cPZHpvf/8Y9vMv]])))()

love.mouse.setVisible(false)
ZENITHA.globalEvent.drawCursor = NULL
ZENITHA.globalEvent.clickFX = NULL
function ZENITHA.globalEvent.fileDrop(file)
    local data = file:read('data')
    local suc, res = pcall(GC.newImage, data)
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

local KBisDown = love.keyboard.isDown
function ZENITHA.globalEvent.keyDown(key, isRep)
    if isRep then return end
    if KBisDown('lctrl', 'rctrl') then return end
    if key == 'f12' then
        if TASK.lock('dev') then
            MSG('check', "Zenith Clicker is powered by Love2d & Zenitha, not Web!", 6.26)
        else
            ZENITHA.setDevMode(not ZENITHA.getDevMode() and 1 or false)
        end
    elseif key == 'f11' then
        STAT.fullscreen = not STAT.fullscreen
        love.window.setFullscreen(STAT.fullscreen)
        MSG('dark', "Fullscreen: " .. (STAT.fullscreen and "ON" or "OFF"), 1)
    elseif key == 'f10' then
        STAT.syscursor = not STAT.syscursor
        SetMouseVisible(true)
        ApplySettings()
        MSG('dark', "Star Force: " .. (STAT.syscursor and "OFF" or "ON"), 1)
    elseif key == 'f9' then
        if not GAME.zenithTraveler then STAT.bg = not STAT.bg end
        MSG('dark', "BG: " .. (STAT.bg and "ON" or "OFF"), 1)
    elseif key == 'f8' then
        if STAT.bgBrightness < 80 then
            STAT.bgBrightness = MATH.clamp(STAT.bgBrightness + 10, 30, 80)
            MSG('dark', "BG " .. STAT.bgBrightness .. "%", 1)
        end
    elseif key == 'f7' then
        if STAT.bgBrightness > 30 then
            STAT.bgBrightness = MATH.clamp(STAT.bgBrightness - 10, 30, 80)
            MSG('dark', "BG " .. STAT.bgBrightness .. "%", 1)
        end
    elseif key == 'f5' then
        if STAT.cardBrightness > 80 then
            STAT.cardBrightness = MATH.clamp(STAT.cardBrightness - 5, 80, 100)
            MSG('dark', "Card " .. STAT.cardBrightness .. "%", 1)
        end
    elseif key == 'f6' then
        if STAT.cardBrightness < 100 then
            STAT.cardBrightness = MATH.clamp(STAT.cardBrightness + 5, 80, 100)
            MSG('dark', "Card " .. STAT.cardBrightness .. "%", 1)
        end
    elseif key == 'f3' then
        if STAT.sfx > 0 then
            TempSFX = STAT.sfx
            STAT.sfx = 0
        else
            STAT.sfx = TempSFX or 60
            TempSFX = false
        end
        MSG('dark', STAT.sfx > 0 and "SFX ON" or "SFX OFF", 1)
        ApplySettings()
        SFX.play('menuclick')
    elseif key == 'f4' then
        if STAT.bgm > 0 then
            TempBGM = STAT.bgm
            STAT.bgm = 0
        else
            STAT.bgm = TempBGM or 100
            TempBGM = false
        end
        MSG('dark', STAT.bgm > 0 and "BGM ON" or "BGM OFF", 1)
        ApplySettings()
    end
end

do -- Auto mute when unfocused
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
        if not STAT.autoMute then return end
        if f then
            TASK.removeTask_code(task_autoSoundOff)
            TASK.new(task_autoSoundOn)
        else
            TASK.removeTask_code(task_autoSoundOn)
            TASK.new(task_autoSoundOff)
        end
    end
end

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
    gc.push('transform')
    gc.translate(self._x, not (self.pos and self.pos[1] == .5) and self._y or self._y + DeckPress)

    if self._pressTime > 0 then
        gc.scale(1 - self._pressTime / self._pressTimeMax * .0626)
    end
    local w, h = self.w, self.h

    local fillC = self.fillColor
    local frameC = self.frameColor

    -- Background
    gc.setColor(fillC)
    GC.mRect('fill', 0, 0, w, h)

    -- Frame
    gc.setLineWidth(3)
    gc.setColor(frameC[1] * .42, frameC[2] * .42, frameC[3] * .42)
    gc.line(-w / 2, h / 2, w / 2, h / 2, w / 2, -h / 2 - 1.5)
    gc.setColor(.2 + frameC[1] * .8, .2 + frameC[2] * .8, .2 + frameC[3] * .8)
    gc.line(-w / 2, h / 2 + 1.5, -w / 2, -h / 2, w / 2 - 1.5, -h / 2)

    -- Drawable
    gc.setColor(self.textColor)
    WIDGET._alignDraw(self, self._text, 0, 0, 0, 1.2, 1.2 - 2.4 * GAME.revTimer)

    -- Highlight
    if self._hoverTime > 0 then
        gc.setColor(1, 1, 1, self._hoverTime / self._hoverTimeMax * .0626)
        GC.mRect('fill', 0, 0, w - 3, h - 3)
    end

    gc.pop()
end

function WIDGET._prototype.checkBox:draw()
    gc.push('transform')
    gc.translate(self._x, self._y)
    local w = self.w

    gc.setLineWidth(self.lineWidth)
    if self.disp() then
        -- Active
        gc.setColor(self.frameColor)
        GC.mRect('fill', 0, 0, w, w, 2)
        gc.setColor(0, 0, 0, .42)
        gc.line(-w / 2, w / 2, w / 2, w / 2, w / 2, -w / 2)
        gc.setColor(1, 1, 1, .62)
        gc.line(-w / 2, w / 2, -w / 2, -w / 2, w / 2, -w / 2)
        gc.setLineWidth(self.lineWidth * 2)
        gc.setLineJoin('bevel')
        gc.setColor(1, 1, 1)
        gc.line(-w * .355, 0, 0, w * .355, w * .355, -w * .355)
    else
        -- Background
        gc.setColor(self.fillColor)
        GC.mRect('fill', 0, 0, w, w, 2)
        gc.setColor(0, 0, 0, .626)
        gc.line(-w / 2, w / 2, -w / 2, -w / 2, w / 2, -w / 2)
        gc.setColor(1, 1, 1, .0626)
        gc.line(-w / 2, w / 2, w / 2, w / 2, w / 2, -w / 2)
    end

    -- Drawable
    local x2, y2 = w * .5 + self.labelDist, 0
    gc.setColor(self.textColor)
    WIDGET._alignDraw(self, self._text, x2, y2, nil, self.textScale)

    -- Highlight
    gc.setColor(1, 1, 1, self._hoverTime / self._hoverTimeMax * .0626)
    GC.mRect('fill', 0, 0, w, w, 2)

    gc.pop()
end

function WIDGET._prototype.slider:draw()
    local x, y = self._x, self._y
    local x2 = x + self.w
    local rangeL, rangeR = self._rangeL, self._rangeR

    local frameC = self.frameColor

    -- Axis
    gc.setColor(frameC)
    gc.setLineWidth(self.lineWidth * 2)
    gc.line(x, y, x2, y)

    local fillC = self.fillColor

    -- Block
    local pos = MATH.clamp(self._pos, rangeL, rangeR)
    local cx = x + self.w * (pos - rangeL) / self._rangeWidth
    local bw, bh = 26, 30
    GC.ucs_move('m', cx, y)
    gc.setColor(fillC)
    GC.mRect('fill', 0, 0, bw, bh, self.cornerR)
    gc.setLineWidth(self.lineWidth)
    gc.setColor(0, 0, 0, .26)
    gc.line(-bw / 2, bh / 2, bw / 2, bh / 2, bw / 2, -bh / 2)
    gc.setColor(1, 1, 1, .1)
    gc.line(-bw / 2, bh / 2, -bw / 2, -bh / 2, bw / 2, -bh / 2)
    GC.ucs_back()
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

DiscordState = {}
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
        local msg = ASYNC.get('submitDaily')
        if msg then
            local suc, res = pcall(JSON.decode, msg)
            local duration = GAME.playing and 0 or 10
            if suc and res then
                if res.error then
                    MSG('warn', "Daily Challenge submission failed:\n" .. res.error, duration * .626)
                else
                    MSG('check',
                        "Daily Challenge score submitted!\n" ..
                        "Alt #" .. tostring(res.altRank) .. " of " .. tostring(res.altCount) .. ", top: " .. tostring(res.altBest) .. "m\n" ..
                        "SR #" .. tostring(res.timeRank) .. " of " .. tostring(res.timeCount) .. ", top: " .. tostring(res.timeBest) .. "s",
                        duration)
                    SFX.play('pause_continue', 1, 0, Tone(-5))
                end
                DAILYCMD = nil
            else
                MSG('warn', "Daily Challenge submission failed\nRetry with secret code 'resubmit'\ndata received from server: " .. msg, 10 * 1.6)
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

    local t1 = -.1
    local t = 0
    while true do
        if BgmPlaying then
            local bar = 2 * 60 / BgmData[BgmPlaying].bpm * 4
            local T = BGM.tell()
            -- Throb tranpaency
            ThrobAlpha.card = max(.626 - 2 * T / bar % 1, .626 - 2 * (T / bar - .375) % 1)
            ThrobAlpha.bg1 = .626 - 2 * T / bar % 1
            ThrobAlpha.bg2 = .626 - 2 * (T / bar - 1 / 32) % 1

            -- Giga anim
            if GigaSpeed.alpha > 0 then
                GigaSpeed.r, GigaSpeed.g, GigaSpeed.b = hsv(T / bar % 1, .626, 1)
                GigaSpeed.bgAlpha = 1 - 4 * T / bar % 1
            end

            -- Messy position shaking
            if T < t1 then t1 = -.1 end
            if T > t1 + 2 * 60 / BgmData[BgmPlaying].bpm then
                t1 = T
                if M.MS == 0 then
                    for i = 1, deckSize do Cards[i].visY = 0 end
                elseif URM and M.MS == 2 then
                    for i = 1, deckSize do Cards[i].visY = math.random(-42, 42) end
                else
                    for i = 1, deckSize do Cards[i].visY = M.MS * math.random(-4, 4) end
                end
                GAME.refreshLayout()
            end

            -- Time Control
            if BgmLooping then
                if BGM.tell() > BgmLooping[2] then
                    BGM.set('all', 'seek', BgmLooping[1] + (BGM.tell() - BgmLooping[2]))
                end
            end
            if BgmNeedSkip then
                if BGM.tell() > BgmNeedSkip[1] then
                    BGM.set('all', 'seek', BgmNeedSkip[2] + (BGM.tell() - BgmNeedSkip[1]))
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

        -- Mouse holding animation
        if not STAT.syscursor then
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
    end
end

require 'module/initialize'

Initialize()
RefreshDaily()
TABLE.update(TextColor, BaseTextColor)
TABLE.update(ShadeColor, BaseShadeColor)
GAME.refreshCurrentCombo()
TEXTS.version:set(SYSTEM .. (STAT.oldHitbox and " T" or " V") .. (require 'version'.verStr))

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

-- Debug
for i = 1, 4 do SCN.scenes._console.widgetList[i].textColor = COLOR.D end
TASK.new(function()
    for _, s in next, ([[ ]]):trim():split('%s+', true) do
        TASK.yieldT(1)
        SFX.play(s)
    end
end)
