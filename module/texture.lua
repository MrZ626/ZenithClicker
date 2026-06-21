FILE.createDirectory({
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
})

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
    star2 = assets 'crystal-fire.png',
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
    warning = assets 'finalwarning.png',

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

    channel = {
        achievements = assets "channel/achievements.jpg",
        records = assets "channel/me.jpg",
        splits = assets "channel/standalone.jpg",
        leaderboard = assets "channel/leaderboard.jpg",
        -- players = assets "channel/players.jpg",
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
            what_ever_it_takes = aq(1, 3),
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
            INMSrDHrEX = aq(7, 8),   -- Sisyphean Monarchy
            ASMSrDHrIN = aq(13, 6),  -- Kitsune Trickery
            swamp_water_lite_plus = aq(15, 3),
            swamp_water_plus = aq(16, 3),

            talentless = aq(3, 7),
            quest_rationing = aq(2, 7),
            the_responsible_one = aq(1, 6),
            the_responsible_one_plus = aq(1, 6),
            the_unreliable_one = aq(15, 2),
            guardian_angel = aq(3, 6),
            carried = aq(3, 8),
            overprotection = aq(12, 7),
            a_mutual_agreement = aq(13, 4),
            the_cheaters = aq(12, 4),
            the_escape_artist = aq(1, 5),
            the_artist_trinity = aq(11, 3),
            level_19_cap = aq(16, 2),
            empurple = aq(13, 7),
            the_masterful_juggler = aq(11, 7),
            clutch_main = aq(14, 3),
            spotless = aq(16, 4),
            autoplay_is_awesome = aq(10, 6),
            sunk_cost = aq(11, 5),
            wax_wings = aq(12, 5),
            the_oblivious_artist = aq(14, 7),
            zero_to_sixty = aq(10, 5),
            speed_bonus = aq(9, 4),
            under_the_radar = aq(16, 8),
            arrogance = aq(3, 5),
            scarcity_mindset = aq(4, 1),
            detail_oriented = aq(8, 6),
            psychokinesis = aq(8, 6),
            fickle_fuel = aq(9, 5),
            moon_struck = aq(7, 6),
            slayer_of_the_tower = aq(1, 3),
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
            the_spike_of_all_time_plus = aq(5, 6),

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
            return_to_the_light = aq(1, 2),
            smooth_dismount = aq(4, 1),
            knifes_edge = aq(5, 5),
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
        local w, h = TEXTURE[lockType]:getDimensions()
        return GC.initCanvas(w, h, function()
            GC.draw(TEXTURE[lockType], 0, 0)
            local t = GC.newText(FONT.get(70, 'sans'), char)
            if lockType == 'lockfull' then
                GC.setColor(COLOR.HEX "646483FF")
                for i = 0, 25 do
                    local angle = i / 26 * MATH.tau
                    local dx, dy = math.cos(angle) * 2, math.sin(angle) * 2
                    GC.mDraw(t, w * .51 + dx, h * .526 + dy, 0, 2)
                end
            else
                GC.setColor(COLOR.HEX "544F65FF")
                for i = 0, 25 do
                    local angle = i / 26 * MATH.tau
                    local dx, dy = math.cos(angle) * 1.6, math.sin(angle) * 1.6
                    GC.mDraw(t, w * .495 + dx, h * .52 + dy, 0, 1.5)
                end
            end
            t:release()
        end)
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

TEXTURE.ruler = GC.initCanvas(32, 600, function()
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
end)
TEXTURE.ruler:setFilter('nearest', 'nearest')
TEXTURE.ruler:setWrap('repeat', 'repeat')

TEXTURE.transition = GC.initCanvas(128, 1, function()
    for x = 0, 127 do
        GC.setColor(1, 1, 1, 1 - x / 128)
        GC.rectangle('fill', x, 0, 1, 1)
    end
end)

TEXTURE.darkCorner = GC.initCanvas(128, 128, function()
    GC.setColor(0, 0, 0)
    GC.blurCircle(.626, 64, 64, 64)
end)

TEXTURE.lightDot = GC.initCanvas(32, 32, function()
    GC.clear(1, 1, 1, 0)
    GC.blurCircle(.26, 16, 16, 16)
end)

TEXTURE.surgeIcon = GC.initCanvas(512, 512, function()
    GC.clear(1, 1, 1, 0)
    GC.setColor(1, 1, 1)
    GC.translate(256, 256)
    for _ = 0, 2 do
        GC.circle('fill', 0, 0, 180, 4)
        GC.rotate(.5236)
    end
end)

TEXTURE.windup = GC.initCanvas(128, 128, function()
    GC.clear(1, 1, 1, 0)
    local l = {}
    for i = 0, 15 do
        local a = i / 16 * MATH.tau
        local d = i % 2 == 0 and 58 or 45
        local dx, dy = d * math.cos(a), d * math.sin(a)
        table.insert(l, 64 + dx)
        table.insert(l, 64 + dy)
    end
    GC.setLineWidth(10)
    GC.polygon('line', l)
end)
do
    local w = 13
    local d1 = 20
    local d2 = 16
    TEXTURE.windupText = {
        GC.initCanvas(128, 128, function()
            GC.clear(1, 1, 1, 0)
            GC.rectangle('fill', 64 - w / 2, 64 - 31, w, 62 - w * 1.6); GC.rectangle('fill', 64 - w / 2, 64 + 31, w, -w)
        end),
        GC.initCanvas(128, 128, function()
            GC.clear(1, 1, 1, 0)
            GC.rectangle('fill', 64 - w / 2 - d1 / 2, 64 - 31, w, 62 - w * 1.6); GC.rectangle('fill', 64 - w / 2 - d1 / 2, 64 + 31, w, -w)
            GC.rectangle('fill', 64 - w / 2 + d1 / 2, 64 - 31, w, 62 - w * 1.6); GC.rectangle('fill', 64 - w / 2 + d1 / 2, 64 + 31, w, -w)
        end),
        GC.initCanvas(128, 128, function()
            GC.clear(1, 1, 1, 0)
            GC.rectangle('fill', 64 - w / 2 - d2, 64 - 31, w, 62 - w * 1.6); GC.rectangle('fill', 64 - w / 2 - d2, 64 + 31, w, -w)
            GC.rectangle('fill', 64 - w / 2 + 00, 64 - 31, w, 62 - w * 1.6); GC.rectangle('fill', 64 - w / 2 + 00, 64 + 31, w, -w)
            GC.rectangle('fill', 64 - w / 2 + d2, 64 - 31, w, 62 - w * 1.6); GC.rectangle('fill', 64 - w / 2 + d2, 64 + 31, w, -w)
        end),
        GC.initCanvas(128, 128, function()
            local w = w - 2
            GC.clear(1, 1, 1, 0)
            FONT.set(70, '_mono')
            GC.rectangle('fill', 64 - w / 2 - 19, 64 - 31, w, 62 - w * 1.6); GC.rectangle('fill', 64 - w / 2 - 19, 64 + 31, w, -w)
            GC.print("?", 53, 5, 0, 1.1, 1.26) -- Not very fitting, but this is not used
        end),
        GC.initCanvas(128, 128, function()
            GC.clear(1, 1, 1, 0)
            FONT.set(70, '_mono')
            GC.print("?", 39, 6, 0, 1.26) -- Not very fitting, but this is not used
        end),
    }
end

TEXTURE.recRevBG = GC.initCanvas(1586, 606, function()
    GC.draw(TEXTURE.panel.glass_a)
    GC.draw(TEXTURE.panel.glass_b)
end)

TEXTURE.recRevLight = GC.initCanvas(165, 120, function()
    GC.clear(1, .1, .1, 0)
    GC.setColor(1, .1, .1)
    GC.blurCircle(-.2, 60, 60, 60)
    GC.blurCircle(-.6, 105, 60, 60)
end)

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

FONT.load {
    serif = "assets/AbhayaLibre-Regular.ttf",
    sans = "assets/DINPro-Medium.otf",
    led = "assets/UniDreamLED.ttf",
    symbol = "assets/symbols.otf",
}
FontLoaded = SYSTEM == 'Web' or MATH.roll(.62)
FONT.setDefaultFont(FontLoaded and 'sans' or 'serif')
FONT.setOnInit(function(font, size)
    font:setFallbacks(FONT.get(size, '_norm'))
end)

BG.add('black', { draw = function() GC.clear(0, 0, 0) end })
BG.set('black')

MSG.setSafeY(75)
MSG.addCategory('dark', COLOR.D, COLOR.L)
MSG.addCategory('bright', COLOR.L, COLOR.D)
MSG.addCategory('speedrun', COLOR.LG, COLOR.D)
for i = 0, 6 do MSG.addCategory(AchvData[i].id, AchvData[i].bg, COLOR.L, TEXTURE.achievement.frame[i]) end
for i = 1, 6 do MSG.addCategory("wreath_" .. i, AchvData[5].bg, COLOR.L, GC.load { w = 256, { 'draw', TEXTURE.achievement.frame[5] }, { 'draw', TEXTURE.achievement.wreath[i] } }) end

TEXTS = { -- Font size should only be 30 50 70 here, to reduce memory usage of fonts
    temp30      = GC.newText(FONT.get(30)),
    version     = GC.newText(FONT.get(30)),
    mod         = GC.newText(FONT.get(30)),
    mpPreview   = GC.newText(FONT.get(30)),
    zpPreview   = GC.newText(FONT.get(30)),
    zpChange    = GC.newText(FONT.get(30)),
    dcBest      = GC.newText(FONT.get(30)),
    dcTimer     = GC.newText(FONT.get(30)),
    srTimer     = GC.newText(FONT.get(30)),
    title       = GC.newText(FONT.get(50), "EXPERT QUICK PICK"),
    load        = GC.newText(FONT.get(50)),
    pb          = GC.newText(FONT.get(50)),
    endResult   = GC.newText(FONT.get(30)),
    endHeight   = GC.newText(FONT.get(50)),
    endFloor    = GC.newText(FONT.get(30)),
    linePB      = GC.newText(FONT.get(50), "PB"),
    lineKM      = GC.newText(FONT.get(50), "1000"),
    height      = GC.newText(FONT.get(30)),
    time        = GC.newText(FONT.get(30)),
    rank        = GC.newText(FONT.get(30)),
    chain       = GC.newText(FONT.get(50)),
    chain2      = GC.newText(FONT.get(50, 'led')),
    b2b         = GC.newText(FONT.get(30), "B2B x"),
    spike       = GC.newText(FONT.get(50)),
    gigaspeed   = GC.newText(FONT.get(50), {
        COLOR.dR, "G", COLOR.dO, "I", COLOR.dY, "G",
        COLOR.dK, "A", COLOR.dG, "S", COLOR.dJ, "P",
        COLOR.dC, "E", COLOR.dS, "E", COLOR.dB, "D"
    }),
    teraspeed   = GC.newText(FONT.get(50), {
        COLOR.R, "T", COLOR.O, "E", COLOR.Y, "R",
        COLOR.K, "A", COLOR.G, "S", COLOR.J, "P",
        COLOR.C, "E", COLOR.S, "E", COLOR.B, "D",
    }),
    gigatime    = GC.newText(FONT.get(50)),
    floorTime   = GC.newText(FONT.get(30)),
    rankTime    = GC.newText(FONT.get(30)),
    slogan      = GC.newText(FONT.get(30), "CROWD THE TOWER!"),
    slogan_EX   = GC.newText(FONT.get(30), "THRONG THE TOWER!"),
    slogan_rEX  = GC.newText(FONT.get(30), "OVERFLOW THE TOWER!"),
    forfeit     = GC.newText(FONT.get(50), "KEEP HOLDING TO FORFEIT"),
    credit      = GC.newText(FONT.get(30), "Most assets from TETR.IO"),
    EndText     = GC.newText(FONT.get(70)),
    EndText2    = GC.newText(FONT.get(70), "ZENITH CLICKER!"),
    devNoteText = GC.newText(FONT.get(30)),
    aboutText   = GC.newText(FONT.get(70)),
    test        = GC.newText(FONT.get(70), "TEST"),
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
