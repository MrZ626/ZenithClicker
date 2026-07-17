---------------------------------------------------------------------
--                      SPOILER WARNING                            --
-- This file contains secrets that may spoil your game experience. --
-- Be sure you've finished the game, including Ultra Reversed Mods --
--                   Read at your own risk.                        --
---------------------------------------------------------------------

AchvMsgStyle = {
    [0] = { id = 'achv_none', bg = CLR.D, fg = CLR.LD, fg2 = CLR.LD },
    { id = 'achv_bronze',   bg = COLOR.DO, fg = COLOR.lO, fg2 = COLOR.O },
    { id = 'achv_silver',   bg = CLR.d4,   fg = CLR.L,    fg2 = CLR.dL },
    { id = 'achv_gold',     bg = COLOR.DY, fg = COLOR.lY, fg2 = COLOR.Y },
    { id = 'achv_platinum', bg = COLOR.DJ, fg = COLOR.lJ, fg2 = COLOR.J },
    { id = 'achv_diamond',  bg = COLOR.DP, fg = COLOR.lP, fg2 = COLOR.lB },
    { id = 'achv_issued',   bg = COLOR.DM, fg = COLOR.lM, fg2 = COLOR.lM },
}

GigaSpeedReq = { [0] = 7, 8, 8, 9, 9, 10, 1e99, 1e99, 1e99, 1e99, 1e99 }
TeraMusicReq = { [0] = 9, 11, 11, 12, 12, 13, 13, 1e99, 1e99, 1e99 }

GravityTimer = {
    { 9.0, 8.0, 7.5, 7.0, 6.5, 6.0, 5.5, 5.0, 4.5, 4.0 },
    { 3.2, 3.0, 2.8, 2.6, 2.5, 2.4, 2.3, 2.2, 2.1, 2.0 },
}

PieceData = {
    [0] = { id = 'allclear', text = { CLR.W, "-" }, piece = { CLR.W, CHAR.brik.O1 }, popup = { CLR.W, "All Clear" } },
    { id = 'nightcore', text = { COLOR.lR, "Z" }, piece = { COLOR.lR, CHAR.brik.Z }, popup = { COLOR.lR, "Z - Nightcore" } },
    { id = 'slowmo',    text = { COLOR.lG, "S" }, piece = { COLOR.lG, CHAR.brik.S }, popup = { COLOR.lG, "S - Sloooooow-mo" } },
    { id = 'glassCard', text = { COLOR.lB, "J" }, piece = { COLOR.lB, CHAR.brik.J }, popup = { COLOR.lB, "J - Glass Card" } },
    { id = 'fastLeak',  text = { COLOR.lO, "L" }, piece = { COLOR.lO, CHAR.brik.L }, popup = { COLOR.lO, "L - Fast Leak" } },
    { id = 'invisUI',   text = { COLOR.lM, "T" }, piece = { COLOR.lM, CHAR.brik.T }, popup = { COLOR.lM, "T - Invisible UI" } },
    { id = 'invisCard', text = { COLOR.lY, "O" }, piece = { COLOR.lY, CHAR.brik.O }, popup = { COLOR.lY, "O - Invisible Card" } },
    { id = 'closeCard', text = { COLOR.lC, "I" }, piece = { COLOR.lC, CHAR.brik.I }, popup = { COLOR.lC, "I - Close Card" } },
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
