---------------------------------------------------------------------
--                      SPOILER WARNING                            --
-- This file contains secrets that may spoil your game experience. --
-- Be sure you've finished the game, including Ultra Reversed Mods --
--                   Read at your own risk.                        --
---------------------------------------------------------------------
AchvData = {
    [0] = { id = 'achv_none', bg = COLOR.D, fg = COLOR.LD, fg2 = COLOR.LD },
    { id = 'achv_bronze',   bg = COLOR.DO,          fg = COLOR.lO, fg2 = COLOR.O },
    { id = 'achv_silver',   bg = { .26, .26, .26 }, fg = COLOR.L,  fg2 = COLOR.dL },
    { id = 'achv_gold',     bg = COLOR.DY,          fg = COLOR.lY, fg2 = COLOR.Y },
    { id = 'achv_platinum', bg = COLOR.DJ,          fg = COLOR.lJ, fg2 = COLOR.J },
    { id = 'achv_diamond',  bg = COLOR.DP,          fg = COLOR.lP, fg2 = COLOR.lB },
    { id = 'achv_issued',   bg = COLOR.DM,          fg = COLOR.lM, fg2 = COLOR.lM },
}

GigaSpeedReq = { [0] = 7, 8, 8, 9, 9, 10, 1e99, 1e99, 1e99, 1e99, 1e99 }
TeraMusicReq = { [0] = 9, 11, 11, 12, 12, 13, 13, 1e99, 1e99, 1e99 }

GravityTimer = {
    { 9.0, 8.0, 7.5, 7.0, 6.5, 6.0, 5.5, 5.0, 4.5, 4.0 },
    { 3.2, 3.0, 2.8, 2.6, 2.5, 2.4, 2.3, 2.2, 2.1, 2.0 },
}

PieceData = {
    { id = 'nightcore', text = { COLOR.lR, "Z", }, popup = { COLOR.lR, "Z - Nightcore" } },
    { id = 'slowmo',    text = { COLOR.lG, "S", }, popup = { COLOR.lG, "S - Sloooooow-mo" } },
    { id = 'glassCard', text = { COLOR.lB, "J", }, popup = { COLOR.lB, "J - Glass Card" } },
    { id = 'fastLeak',  text = { COLOR.lO, "L", }, popup = { COLOR.lO, "L - Fast Leak" } },
    { id = 'invisUI',   text = { COLOR.lM, "T", }, popup = { COLOR.lM, "T - Invisible UI" } },
    { id = 'invisCard', text = { COLOR.lY, "O", }, popup = { COLOR.lY, "O - Invisible Card" } },
    { id = 'closeCard', text = { COLOR.lC, "I", }, popup = { COLOR.lC, "I - Close Card" } },
    { id = 'allclear',  text = { COLOR.LL, "-", }, popup = { COLOR.LL, "All Clear" } },
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

NegFloors = {
    [0] = { bottom = -1e99 },
    { bottom = -50,   name = "The Basement" },
    { bottom = -150,  name = "Zenith Restaurant" },
    { bottom = -300,  name = "Underground Parking" },
    { bottom = -450,  name = "The Bunker" },
    { bottom = -650,  name = "The Infirmary" },
    { bottom = -850,  name = "Decayed Catacombs" },
    { bottom = -1100, name = "Sacreligious Ruins" },
    { bottom = -1350, name = "Singularity Reactor" },
    { bottom = -1650, name = "Distorted Gateways" },
    { bottom = -1e99, name = "Endless Void" },
}
NegTexts = {
    b1 = { -- The Basement
        desc = "A basic storage room for the floors above... and below.",
        begin = [[You find yourself in an unfamiliar place.]],
        noAS = [[You passed the security check without any prohibited items.]],
        ASoff = [[To prevent mech heart users from entering, the AS mod has been confiscated.]],
        -- egg = [[Garbo checks the imprisoned mech heart users here from time to time, except rtxtile, who kept escaping somehow?]],
    },
    b2 = { -- Zenith Restaurant
        desc = "A lively restaurant with a lovely atmosphere.\nThough the prices here are slightly outrageous...",
        begin = [[The smell of food calms your senses...]],
        effStart = [[Illusions dance before your eyes...]],
        noVL = [[You feel yourself getting weaker...]],
        VLoff = [[You feel your strength fading...]],
        noIN = [[The illusion before your eyes hasn't entirely faded...]],
        INoff = [[Your mind is becoming clearer...]],
    },
    b3 = { -- Underground Parking
        desc = "A boundless parking lot for all of these visitors.",
        begin = [[The vast lot's tranquility reassures you.]],
        effStart = [[But a realization dawned - you were lost.]],
        mid1 = [["Where am I?"]],
        noGV = [[You feel like you're not going fast enough...]],
        GVoff = [[You subconsciously quickened your pace...]],
        mid2 = [["Where am I going?"]],
    },
    b4 = { -- The Bunker
        desc = "A regular bunker...\nafter witnessing the Corruption, you definitely know why it was built.",
        begin = [[You feel safe away from the above.]],
        effStart = [[The barren bunker begins to feel ghostly.]],
        noMS = [[It seems that luck was against you...]],
        MSoff = [[You organized your thoughts...]],
    },
    b5 = { -- The Infirmary
        desc = "The medical sector of the tower, filled with incomprehensible technology.\nThey look similar to the ones in the Laboratory...",
        begin = [[Endless beeping echoes through the halls you roam.]],
        effStart = [[One horrifying scene after another floods your vision.]],
        noDH = [[A sinister thought crosses your mind...]],
        DHoff = [[You shuddered while walking in this terrifying place.]],
    },
    b6 = { -- Decayed Catacombs
        desc = "A complex of the dead,\nnow decaying into an even more unsettling shell of itself.",
        begin = [[The feeling of safety slipped away.]],
        effStart = [[Your attention strays...]],
        mid = [[You begin to hear something calling your name...]],
        noNH = [[You cannot ignore the voice...]],
        NHoff = [[You overcome your fear.]],
    },
    b7 = { -- Sacreligious Ruins
        desc = "The remains of a previously sacred chapel, the spirits of those,\nwho worshipped the gods above linger on...",
        desc2 = [[Whispers of a missing artifact echo throughout the area...]],
        begin = [[You pray that nothing dire becomes of you.]],
        effStart = [[Spacetime ahead is heavily warped...]],
        mid = [[You know you have to go as fast as possible.]],
    },
    b8 = { -- Singularity Reactor
        desc = "Fueled by the power of the cosmos and the stolen artifact, powering something...",
        begin = [[You are overwhelmed by the reactor's magnitude.]],
        mid1 = [[Dizzy spells.]],
        mid2 = [[Blurred vision.]],
        mid3 = [[Head throbbing.]],
        -- mid = [[The mysterious voice is growing ever nearer...]],
    },
    b9 = { -- Distorted Gateways
        desc = "A hall of millions of gateways to different realities, towers and wastelands...\nThe mere thought of something like this is sickening...",
        desc2 = [[The entrance to a false promise of paradise.]],
        desc3 = [[You reach the bottom... or it seemed to be at first glance... one last gateway was left...]],
        begin = [[The endless void beckons you...]],
        mid = [[RUN.]],
        -- begin = [[You feel nostalgia at the sight of a familiar tower.]],
    },
    b10 = { -- Endless Void
        desc = "A realm of absolutely nothing, none have ever returned.",
        desc2 = [[You look back above... yet you've already gone too far in this insane abyss for you to see anything.]],
        -- begin = [[...and you pass the point of no return.]],
        -- mid1 = [[Everything begins to go quiet.]],
        end1 = [[...this is it?]],
        end2 = [[This is what's down below all of this?]],
        end3 = [[It's so empty... and vast...]],
        end4 = [[Yet it feels nostalgic somehow...]],
        end5 = [[And peaceful.]],
    },
}
NegEvents = {
    -- B1: The Basement
    { h = -10 }, { text = 'b1.begin' },
    { h = -26 },
    { text = 'b1.noAS', color = 'lB', cond = function() return GAME.mod.AS == 0 end },
    {
        text = 'b1.ASoff',
        color = 'lO',
        cond = function() return GAME.mod.AS > 0 end,
        event = function()
            GAME.attackMul = GAME.attackMul - .1
            GAME.dmgTimerMul = GAME.dmgTimerMul + .01
            GAME.mod.AS = 0
            GAME.refreshModIcon()
            GAME.refreshRPC()
        end,
    },

    -- B2: Zenith Restaurant
    { h = -50 }, { event = { 'dmgDelay', -2 } },
    { event = { 'attackMul', -.1, 'timerMul', -.25 } },
    { h = -55 }, { text = 'b2.begin' },
    { h = -60 },
    {
        text = 'b2.effStart',
        event = function()
            GAME.nightcore = true
            RefreshBGM()
        end
    },
    { h = -90 },
    { text = 'b2.noVL', color = 'lB', cond = function() return GAME.mod.VL == 0 end },
    {
        text = 'b2.VLoff',
        color = 'lO',
        cond = function() return GAME.mod.VL > 0 end,
        event = function()
            GAME.attackMul = GAME.attackMul - .1
            GAME.dmgTimerMul = GAME.dmgTimerMul + .01
            GAME.mod.VL = 0
            GAME.refreshModIcon()
            GAME.refreshRPC()
        end,
    },
    { h = -120 },
    { text = 'b2.noIN', color = 'lB', cond = function() return GAME.mod.IN == 0 end },
    {
        text = 'b2.INoff',
        color = 'lO',
        cond = function() return GAME.mod.IN > 0 end,
        event = function()
            GAME.dmgCycle = GAME.dmgCycle + GAME.mod.IN * 1
            GAME.attackMul = GAME.attackMul - .1
            GAME.dmgTimerMul = GAME.dmgTimerMul + .01
            GAME.mod.IN = 0
            RefreshBGM()
            for _, C in ipairs(Cards) do C:flip() end
            GAME.refreshModIcon()
            GAME.refreshRPC()
        end,
    },
    { h = -150 },
    {
        event = function()
            GAME.nightcore = false
            RefreshBGM()
        end
    },


    -- B3: Underground Parking
    { h = -150 }, { event = { 'dmgDelay', -2, 'dmgCycle', -.5 } },
    { event = { 'attackMul', -.1, 'timerMul', -.15 } },
    { h = -155 }, { text = 'b3.begin' },
    { h = -160 }, { text = 'b3.effStart' },
    { h = -165 }, { event = { 'invisUI', true } },
    { h = -170 }, { event = { 'invisUI', false } },
    { h = -175 }, { event = { 'invisUI', true } },
    { h = -180 }, { text = 'b3.mid1' },
    { h = -185 }, { event = { 'invisUI', false } },
    { h = -195 }, { event = { 'invisUI', true } },
    { h = -200 },
    { text = 'b3.noGV', color = 'lB', cond = function() return GAME.mod.GV == 0 end },
    {
        text = 'b3.GVoff',
        color = 'lO',
        cond = function() return GAME.mod.GV > 0 end,
        event = function()
            GAME.dmgDelay = GAME.dmgDelay + GAME.mod.GV * 4
            GAME.attackMul = GAME.attackMul - .1
            GAME.dmgTimerMul = GAME.dmgTimerMul + .01
            GAME.mod.GV = 0
            GAME.refreshModIcon()
            GAME.refreshRPC()
            RefreshBGM()
        end,
    },
    { h = -200 }, { event = { 'invisUI', false } },
    { h = -210 }, { event = { 'invisUI', true } },
    { h = -220 }, { text = 'b3.mid2' },
    { h = -250 }, { event = { 'invisUI', false } },
    { h = -260 }, { event = { 'invisUI', true } },
    { h = -280 }, { event = { 'invisUI', false } },

    -- B4: The Bunker
    { h = -300 }, { event = { 'dmgDelay', -1, 'dmgCycle', -.5 } },
    { event = { 'attackMul', -.1, 'timerMul', -.1 } },
    { h = -310 },
    { text = 'b4.begin' },
    { event = function() GAME.dmgWrong = math.min(GAME.dmgWrong, 2) end },
    { h = -320 }, { text = 'b4.effStart', event = { 'glassCard', true } },
    { h = -380 },
    { text = 'b4.noMS', color = 'lB', cond = function() return GAME.mod.MS == 0 end },
    {
        text = 'b4.MSoff',
        color = 'lO',
        cond = function() return GAME.mod.MS > 0 end,
        event = function()
            GAME.extraQuestBase = GAME.extraQuestBase - GAME.mod.MS * .2
            GAME.attackMul = GAME.attackMul - .1
            GAME.dmgTimerMul = GAME.dmgTimerMul + .01
            GAME.mod.MS = 0
            GAME.sortCards()
            GAME.refreshModIcon()
            GAME.refreshRPC()
        end,
    },
    { h = -450 }, { event = { 'glassCard', false } },

    -- B5: The Infirmary
    { h = -450 }, { event = { 'dmgDelay', -1, 'dmgCycle', -.5 } },
    { event = { 'attackMul', -.1 } },
    { event = function() GAME.dmgWrong = math.min(GAME.dmgWrong, 2) end },
    { h = -460 }, { text = 'b5.begin' },
    { h = -470 }, { text = 'b5.effStart' },
    {
        event = function()
            GAME.slowmo = true
            RefreshBGM()
        end
    },
    { h = -550 },
    { text = 'b5.noDH', color = 'lB', cond = function() return GAME.mod.DH == 0 end },
    {
        text = 'b5.DHoff',
        color = 'lO',
        cond = function() return GAME.mod.DH > 0 end,
        event = function()
            GAME.extraQuestVar = GAME.extraQuestVar - GAME.mod.DH * .2
            GAME.attackMul = GAME.attackMul - .1
            GAME.dmgTimerMul = GAME.dmgTimerMul + .01
            GAME.mod.DH = 0
            GAME.refreshModIcon()
            GAME.refreshRPC()
        end,
    },
    { h = -650 },
    {
        event = function()
            GAME.slowmo = false
            RefreshBGM()
        end
    },

    -- B6: Decayed Catacombs
    { h = -650 }, { event = { 'dmgDelay', -1, 'dmgTime', 1, 'maxQuestSize', 1 } },
    { event = { 'attackMul', -.1 } },
    { event = function() GAME.dmgWrong = math.min(GAME.dmgWrong, 2) end },
    { h = -660 }, { text = 'b6.begin' },
    { h = -670 }, { text = 'b6.effStart', event = { 'invisCard', true } },
    { h = -720 },
    { text = 'b6.noNH', color = 'lB', cond = function() return GAME.mod.NH == 0 end },
    {
        text = 'b6.NHoff',
        color = 'lO',
        cond = function() return GAME.mod.NH > 0 end,
        event = function()
            GAME.dmgHeal = GAME.dmgHeal + GAME.mod.NH * 3
            GAME.attackMul = GAME.attackMul - .1
            GAME.dmgTimerMul = GAME.dmgTimerMul + .01
            GAME.mod.NH = 0
            GAME.maxQuestCount = 3
            GAME.xpLockLevelMax = 5
            GAME.refreshModIcon()
            GAME.refreshRPC()
        end,
    },
    { h = -850 }, { event = { 'invisCard', false } },

    -- B7: Sacreligious Ruins
    { h = -850 }, { event = { 'dmgDelay', -1, 'dmgCycle', -.5 } },
    { event = { 'attackMul', -.1 } },
    { event = function() GAME.dmgWrong = math.min(GAME.dmgWrong, 2) end },
    { h = -860 }, { text = 'b7.begin' },
    { h = -900 }, { text = 'b7.effStart' },
    { h = -950 }, { text = 'b7.mid' },

    -- B8: Singularity Reactor
    { h = -1100 }, { event = { 'dmgDelay', -1, 'dmgCycle', -.5 } },
    { event = function() GAME.dmgWrong = math.min(GAME.dmgWrong, 2) end },
    { h = -1115 }, { text = 'b8.begin' },
    { h = -1145 }, { text = 'b8.mid1', color = 'R', size = 1.26, sfx = 'b2bcharge_distance_3', duration = 1.26 },
    { h = -1160 }, { text = 'b8.mid2', color = 'R', size = 1.26, sfx = 'b2bcharge_distance_3', duration = 1.26 },
    { h = -1175 }, { text = 'b8.mid3', color = 'R', size = 1.26, sfx = 'b2bcharge_distance_3', duration = 1.26 },
    { h = -1182 }, { sfx = 'b2bcharge_distance_2' },
    { h = -1185 }, { sfx = 'b2bcharge_distance_2' },
    { h = -1188 }, { sfx = 'b2bcharge_distance_2' },
    { h = -1191 }, { sfx = 'b2bcharge_distance_1' },
    { h = -1194 }, { sfx = 'b2bcharge_distance_1' },
    { h = -1197 }, { sfx = 'b2bcharge_distance_1' },
    { h = -1200 },
    {
        event = function()
            GAME.nightcore = true
            RefreshBGM()
        end
    },

    { h = -1350 },
    {
        event = function()
            GAME.nightcore = false
            RefreshBGM()
        end
    },


    -- B9: Distorted Gateways
    { h = -1350 }, { event = { 'dmgDelay', -.5 } },
    { h = -1360 }, { text = 'b9.begin' },
    { event = function() GAME.rankLimit = math.min(GAME.rankLimit, 10) end },
    {
        text = 'b9.mid',
        color = 'lR',
        size = 2.6,
        duration = 16,
        event = function()
            GAME.time = math.max(GAME.time, 419)
        end
    },

    -- B10: Endless Void
    { h = -1650 },
    {
        event = function()
            GAME.invincible = true
            GAME.timerMul = 0
            GAME.dmgWrong = 1
            GAME.invisCard = true
            GAME.dmgTimerMul = 1e99
            GAME.height = -1650
            GAME.heightBonus = 0
            GAME.attackMul = -1
            GAME.chain = 0
            GAME.maxQuestCount = 1
            if GAME.rank > 8 then
                GAME.rank = 8
                GAME.xp = 32
            end
            GAME.xpLockLevelMax = 2600
            GAME.xpLockTimer = 2600
            GAME.xpLockLevel = 2600
            GAME.rankLimit = 8
            TEXTS.rank:set("R-" .. GAME.rank)

            GAME.mod.EX = 0
            GAME.refreshModIcon()
            GAME.refreshRPC()
            GAME.mod.EX = 2
        end,
    },
    { h = -1660 }, { text = 'b10.end1', color = 'L', duration = 6.26, sfx = 'piece_change', event = function() BGM.setVol(STAT.bgm / 100 * .85) end },
    { h = -1690 }, { text = 'b10.end2', color = 'L', duration = 6.26, sfx = 'piece_change', event = function() BGM.setVol(STAT.bgm / 100 * .7) end },
    { h = -1720 }, { text = 'b10.end3', color = 'L', duration = 6.26, sfx = 'piece_change', event = function() BGM.setVol(STAT.bgm / 100 * .5) end },
    { h = -1750 }, { text = 'b10.end4', color = 'L', duration = 6.26, sfx = 'piece_change', event = function() BGM.setVol(STAT.bgm / 100 * .3) end },
    { h = -1780 }, { text = 'b10.end5', color = 'L', duration = 6.26, sfx = 'piece_change', event = function() BGM.setVol(STAT.bgm / 100 * 0) end },
    { h = -1800 },
    {
        event = function()
            GAME.heightBonus = 0
            GAME.height = -1800
            FloatOnCard = nil
            GAME.refreshLayout()
            STAT.clicker = true
            SFX.play('warp')
            SCN.go('ending', "warp")
        end
    },
    { h = -1e99 },
}
local lastH = -0
for _, e in next, NegEvents do
    e.cond = e.cond or TRUE
    e.text = e.text and TABLE.pathIndex(NegTexts, e.text) or e.text
    e.text2 = e.text2 and TABLE.pathIndex(NegTexts, e.text2) or e.text2
    if e.h then
        assert(e.h <= lastH)
        lastH = e.h
    else
        e.h = lastH
    end
end

local require = simpRequire((...) .. "/")
ModData = require 'mod'
ComboData = require 'combo'
Fatigue = require 'fatigue'
RevivePrompts = require 'revive'
Achievements = require 'achievement'
BadgeData = require 'badge'
DevScore = require 'devscore'
DevCommentary = require 'devcommentary'
