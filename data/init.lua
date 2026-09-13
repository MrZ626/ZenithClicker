---------------------------------------------------------------------
--                      SPOILER WARNING                            --
-- This file contains secrets that may spoil your game experience. --
-- Be sure you've finished the game, including Ultra Reversed Mods --
--                   Read at your own risk.                        --
---------------------------------------------------------------------

AchvMsgStyle = {
    [0] = { id = 'achv_none', bg = CLR.D, fg = CLR.LD },
    { id = 'achv_bronze',   bg = COLOR.DO, fg = COLOR.lO },
    { id = 'achv_silver',   bg = CLR.d4,   fg = CLR.dL },
    { id = 'achv_gold',     bg = COLOR.DY, fg = COLOR.lY },
    { id = 'achv_platinum', bg = COLOR.DJ, fg = COLOR.lJ },
    { id = 'achv_diamond',  bg = COLOR.DP, fg = COLOR.lP },
    { id = 'achv_issued',   bg = COLOR.DM, fg = COLOR.lM },
}

GigaSpeedReq = { [0] = 7, 8, 8, 9, 9, 10, 1e99, 1e99, 1e99, 1e99, 1e99 }
TeraMusicReq = { [0] = 9, 11, 11, 12, 12, 13, 13, 1e99, 1e99, 1e99 }

MessinessShuffleSets = {
    [0] = { { 2, 3 }, { 4, 5 }, { 5, 6 }, { 7, 8 }, pop = 3 },
    { { 1, 2 },    { 3, 4 },    { 6, 7 },    { 8, 9 },    pop = 2 },
    { { 1, 2 },    { 3, 4 },    { 6, 7 },    { 8, 9 },    pop = 1 },
    { { 1, 3 },    { 2, 4 },    { 6, 8 },    { 7, 9 },    pop = 1 },
    { { 1, 2, 3 }, { 7, 8, 9 }, { 5, 6, 7 }, { 3, 4, 5 }, pop = 0 },
}
GravityTimer = {
    { 9.0, 8.0, 7.5, 7.0, 6.5, 6.0, 5.5, 5.0, 4.5, 4.0 },
    { 3.2, 3.0, 2.8, 2.6, 2.5, 2.4, 2.3, 2.2, 2.1, 2.0 },
}
UltraMessinessMaxUnmoved = { 5, 5, 5, 5, 4, 4, 4, 3, 3, 2 }

PieceData = {
    { id = 'nightcore', sfx = 'z', text = { COLOR.lR, "Z" }, piece = { COLOR.lR, CHAR.brik.Z }, popup = { COLOR.lR, "Z - Nightcore" } },
    { id = 'slowmo',    sfx = 's', text = { COLOR.lG, "S" }, piece = { COLOR.lG, CHAR.brik.S }, popup = { COLOR.lG, "S - Sloooooow-mo" } },
    { id = 'steadfast', sfx = 'j', text = { COLOR.lB, "J" }, piece = { COLOR.lB, CHAR.brik.J }, popup = { COLOR.lB, "J - Steadfast " } },
    { id = 'fastLeak',  sfx = 'l', text = { COLOR.lO, "L" }, piece = { COLOR.lO, CHAR.brik.L }, popup = { COLOR.lO, "L - Fast Leak" } },
    { id = 'invisUI',   sfx = 't', text = { COLOR.lM, "T" }, piece = { COLOR.lM, CHAR.brik.T }, popup = { COLOR.lM, "T - Invisible UI" } },
    { id = 'invisCard', sfx = 'o', text = { COLOR.lY, "O" }, piece = { COLOR.lY, CHAR.brik.O }, popup = { COLOR.lY, "O - Invisible Card" } },
    { id = 'closeCard', sfx = 'i', text = { COLOR.lC, "I" }, piece = { COLOR.lC, CHAR.brik.I }, popup = { COLOR.lC, "I - Close Card" } },
}

RevSwampName = {
    "Z", "S", "J", "L", "T", "O", "I",
    [["BLIGHT"]],
    [["DESOLATION"]],
    [["HAVOC"]],
    [["PANDEMONIUM"]],
    [["INFERNO"]],
    [["PURGATORY"]],
    [["PERDITION"]],
    [["CATACLYSM"]],
    [["ANNIHILATION"]],
    [["ARMAGEDDON"]],
    [["ABYSS"]],
    [["APOCALYPSE"]], -- not used
}

Floors = {
    [0] = { top = 0, name = "The Basement" },
    { top = 50,   event = {},                                                  name = "Hall of Beginnings" },
    { top = 150,  event = { 'dmgDelay', -2, 'dmgWrong', 1 },                   name = "The Hotel",           MSshuffle = 1 },
    { top = 300,  event = { 'dmgDelay', -2, 'dmgCycle', -.5 },                 name = "The Casino" },
    { top = 450,  event = { 'dmgDelay', -1, 'dmgCycle', -.5 },                 name = "The Arena" },
    { top = 650,  event = { 'dmgDelay', -1, 'dmgCycle', -.5, 'dmgWrong', 1 },  name = "The Museum",          MSshuffle = 2 },
    { top = 850,  event = { 'dmgDelay', -1, 'dmgTime', 1, 'maxQuestSize', 1 }, name = "Abandoned Offices" },
    { top = 1100, event = { 'dmgDelay', -1, 'dmgCycle', -.5 },                 name = "The Laboratory",      MSshuffle = 3 },
    { top = 1350, event = { 'dmgDelay', -1, 'dmgCycle', -.5 },                 name = "The Core" },
    { top = 1650, event = { 'dmgDelay', -.5, 'dmgWrong', 1 },                  name = "Corruption",          MSshuffle = 4 },
    { top = 1e99, event = { 'dmgDelay', -.5, 'dmgCycle', -.5, 'dmgTime', 1 },  name = "Platform of the Gods" },
    { top = 1e99, name = "Stellar Nebula Frontier" }, -- Only name is used
    -- Initial: Delay=15. Cycle=5, Wrong=1
    -- Total: Delay-10, Cycle-3, Wrong+4
}

---@enum (key) ZC.bgmName
BgmMeta = {
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
    f5    = { meta = '4|4 6|8  130 BPM  E Minor       ', bar = 4, bpm = 130, toneFix = -1., loop = { 51.692, 155.077 } },
    f5r   = { meta = '4|4 6|8  130 BPM  E Minor       ', bar = 4, bpm = 130, toneFix = -1., loop = { 51.692, 155.077 } },
    f6    = { meta = '4|4  130 BPM  A Minor           ', bar = 4, bpm = 130, toneFix = 2.0, loop = { 29.538, 103.384 } },
    f6r   = { meta = '4|4  130 BPM  G Minor           ', bar = 4, bpm = 130, toneFix = 0.0, loop = { 29.538, 103.384 } },
    f7    = { meta = '4|4  120 BPM  A+50c Minor       ', bar = 4, bpm = 120, toneFix = 2.5, bpmData = { 60, 32, 120 }, loop = { 128, 192 } },
    f7r   = { meta = '4|4  120 BPM  A+50c Minor       ', bar = 4, bpm = 120, toneFix = 2.5, bpmData = { 60, 32, 120 }, loop = { 128, 192 }, teleport = { 8, 32 } },
    f8    = { meta = '4|4  150 BPM  E Minor           ', bar = 4, bpm = 150, toneFix = -1., loop = { 38.4, 134.4 } },
    f8r   = { meta = '4|4  150 BPM  E Minor           ', bar = 4, bpm = 150, toneFix = -1., loop = { 38.4, 134.4 } },
    f9    = { meta = '4|4  160 BPM  E Minor           ', bar = 4, bpm = 160, toneFix = -1., loop = { 36, 144 } },
    f9r   = { meta = '4|4  160 BPM  E Minor           ', bar = 4, bpm = 160, toneFix = -1., loop = { 36, 144 } },
    f10   = { meta = '4|4  196 BPM  C Major & C Minor ', bar = 4, bpm = 196, toneFix = 0.0, bpmData = { 49, 19.592, 98 }, loop = { 213.673, 311.632 } },
    f10r  = { meta = '4|4  196 BPM  C Major & C Minor ', bar = 4, bpm = 196, toneFix = 0.0, bpmData = { 49, 19.592, 98 }, loop = { 213.673, 311.632 } },
    tera  = { meta = '4|4  240 BPM  C# Minor          ', bar = 4, bpm = 240, toneFix = 1.0, loop = { 76, 140 }, introLen = 2, teleport = { -1, 20 } }, -- 4 endings at 140/142/144/146
    terar = { meta = '4|4  240 BPM  C# Minor          ', bar = 4, bpm = 240, toneFix = 1.0, loop = { 84 - 15.565, 172 - 15.565 }, teleport = { 0, 18 - 15.565 } },
    fomg  = { meta = '4|4  180 & 200 BPM  Bb Minor    ', bar = 4, bpm = 200, toneFix = -2., bpmData = { 90, 10.667, 180, 25.333, 200 }, loop = { 38.4 - 11.862, 144 - 11.862 } },
    fomgr = { meta = '4|4  184 BPM  B Minor & C Minor ', bar = 4, bpm = 184, toneFix = -.5, loop = { 60 / 184 * 76, 60 / 184 * 632 } },
    b6    = { meta = '4|4  120 BPM  G Minor           ', bar = 4, bpm = 120, toneFix = 2.0, loop = { 16, 224 } },
}
for _, v in next, BgmMeta do
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

require "data/basement"

ModData = require 'data/mod'
ComboData = require 'data/combo'
BoardColorData = require "data/boardcolor"
UsernameData = require 'data/username'
Fatigue = require 'data/fatigue'
RevivePrompts = require 'data/revive'
Achievements = require 'data/achievement'
BadgeData = require 'data/badge'
SpeedrunData = require 'data/speedrun'
DevScore = require 'data/devscore'
DevCommentary = require 'data/devcommentary'
