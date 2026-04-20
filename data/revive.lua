local function rndMod(t)
    local d = MATH.randFreqAll(ModData.weight)
    t.prompt = t.prompt:repD(d)
    if STAT.easyName then d = 'e' .. d end
    t.text = STAT.easyName and t.text:repD(ModData.noun[d]) or t.text:repD(ModData.adj[d])
    t.short = t.short:repD(d)
end
local function rndMod2(t)
    local d = ModData.deck[math.random(9)].id
    t.prompt = t.prompt:repD(d)
    if STAT.easyName then d = 'e' .. d end
    t.text = STAT.easyName and t.text:repD(ModData.noun[d]) or t.text:repD(ModData.adj[d])
    t.short = t.short:repD(d)
end
local function f5() return math.max(GAME.floor, GAME.negFloor) <= 5 end
local function F6() return math.max(GAME.floor, GAME.negFloor) >= 6 end
local function F9() return math.max(GAME.floor, GAME.negFloor) >= 9 end
local function F9wind() return math.max(GAME.floor, GAME.negFloor) >= 9 and GAME.maxQuestSize >= 4 and GAME.mod.DH ~= -1 end
local function F9wind3() return math.max(GAME.floor, GAME.negFloor) >= 9 and GAME.maxQuestSize >= 5 and GAME.mod.DH ~= -1 end
--ZCEM conditions
local function notENH() return GAME.mod.NH ~= -1 end
local function notENHorF9wind() return math.max(GAME.floor, GAME.negFloor) >= 9 and GAME.maxQuestSize >= 4 and GAME.mod.DH ~= -1 and GAME.mod.NH ~= -1 end
local function notENHorF9wind3() return math.max(GAME.floor, GAME.negFloor) >= 9 and GAME.maxQuestSize >= 5 and GAME.mod.DH ~= -1 and GAME.mod.NH ~= -1 end
local function notEMS() return GAME.mod.MS ~= -1 end
local function notEMSorF6() return math.max(GAME.floor, GAME.negFloor) >= 6 and GAME.mod.MS ~= -1 end
local function notEasyName() return not STAT.easyName end -- whether or not to use SWAMP WATER or BATH WATER
local function easyName() return STAT.easyName end
local function EDP() return GAME.mod.DP == -1 and GAME.mod.NH ~= 2 and GAME.animDuration < 26 end --3rd quest, don't do if rNH or excessive animDuration
local function notUASandEDP() return not (GAME.mod.AS == 2 and URM and GAME.mod.DP == -1) end -- friend won't let you kill yourself
local function notEDHandEDP() return GAME.mod.DH ~= -1 and GAME.mod.DP ~= -1 end -- friend removes annoying revive task
local function notRGVandEDP() return not (GAME.mod.GV == 2 and GAME.mod.DP == -1) and math.max(GAME.floor, GAME.negFloor) <= 5 end --- no commit for 6 seconds

---@class Prompt
---@field rank number[]
---@field prompt string
---@field target number
---@field short string
---@field text string
---@field cond fun():boolean?
---@field init fun(t:Prompt)?
---@field _prompt string? for repeating check

---@type Prompt[]
local d = {
    { rank = { 1, 2 }, prompt = 'activate',             target = 30,  short = "Activate 30",             text = "Activate 30 cards" },
    { rank = { 3, 4 }, prompt = 'activate',             target = 80,  short = "Activate 80",             text = "Activate 80 cards" },
    { rank = { 2, 2 }, prompt = 'cancel',               target = 40,  short = "Cancel 40",               text = "Cancel 40 cards" },
    { rank = { 3, 4 }, prompt = 'cancel',               target = 100, short = "Cancel 100",              text = "Cancel 100 cards" },
    { rank = { 1, 2 }, prompt = 'flip',                 target = 50,  short = "Flip 50",                 text = "Flip 50 cards" },
    { rank = { 3, 4 }, prompt = 'flip',                 target = 120, short = "Flip 120",                text = "Flip 120 cards" },
    { rank = { 5, 6 }, prompt = 'flip',                 target = 300, short = "Flip 300",                text = "Flip 300 cards" },
    { rank = { 1, 2 }, prompt = 'flip_single',          target = 10,  short = "Flip single 10",          text = "Flip a single card\n10 times in a row",       cond = notUASandEDP },
    { rank = { 2, 4 }, prompt = 'flip_single',          target = 20,  short = "Flip single 20",          text = "Flip a single card\n20 times in a row",       cond = notUASandEDP },
    { rank = { 1, 2 }, prompt = 'commit',               target = 6,   short = "Commit 6x",               text = "Commit 6 times" },
    { rank = { 2, 3 }, prompt = 'commit',               target = 15,  short = "Commit 15x",              text = "Commit 15 times" },
    { rank = { 3, 5 }, prompt = 'commit',               target = 30,  short = "Commit 30x",              text = "Commit 30 times" },
    { rank = { 1, 2 }, prompt = 'commit_$1',            target = 2,   short = "Commit $1 2x",            text = "Commit 2 times\nwith $1",                     init = rndMod },
    { rank = { 3, 4 }, prompt = 'commit_$1',            target = 4,   short = "Commit $1 4x",            text = "Commit 4 times\nwith $1",                     init = rndMod },
    { rank = { 2, 4 }, prompt = 'commit_$1_row',        target = 2,   short = "2 Chain with $1",         text = "Commit 2 times\nwith $1 in a row",            init = rndMod },
    { rank = { 3, 6 }, prompt = 'commit_$1_row',        target = 3,   short = "3 Chain with $1",         text = "Commit 3 times\nwith $1 in a row",            init = rndMod },
    { rank = { 1, 3 }, prompt = 'commit_no_$1_row',     target = 2,   short = "2 chain without $1",      text = "Commit 2 times\nwithout $1 in a row",         init = rndMod2 },
    { rank = { 3, 5 }, prompt = 'commit_no_$1_row',     target = 3,   short = "3 chain without $1",      text = "Commit 3 times\nwithout $1 in a row",         init = rndMod2 },
    { rank = { 1, 2 }, prompt = 'commit_0',             target = 2,   short = "Commit NOTHING 2x",       text = "Commit NOTHING\n2 times" },
    { rank = { 2, 4 }, prompt = 'commit_0',             target = 5,   short = "Commit NOTHING 5x",       text = "Commit NOTHING\n5 times" },
    { rank = { 4, 6 }, prompt = 'commit_0',             target = 8,   short = "Commit NOTHING 8x",       text = "Commit NOTHING\n8 times" },
    { rank = { 1, 3 }, prompt = 'commit_0_row',         target = 3,   short = "3x Spam commit",          text = "Commit NOTHING\n3 times in a row" },
    { rank = { 3, 5 }, prompt = 'commit_no_conn',       target = 1,   short = "Commit no consec",        text = "Commit without consecutive cards",            cond = F6 },
    { rank = { 1, 4 }, prompt = 'commit_conn_2',        target = 1,   short = "Commit 2 consec",         text = "Commit with 2 consecutive cards",             cond = f5 },
    { rank = { 2, 4 }, prompt = 'commit_conn_3',        target = 1,   short = "Commit 3 consec",         text = "Commit with 3 consecutive cards",             cond = f5 },
    { rank = { 3, 5 }, prompt = 'commit_conn_4',        target = 1,   short = "Commit 4 consec",         text = "Commit with 4 consecutive cards" },
    { rank = { 3, 5 }, prompt = 'commit_swamp_l',       target = 1,   short = "SWAMP WATER LITE",        text = "Commit SWAMP WATER LITE",                     cond = notEasyName},
    { rank = { 4, 6 }, prompt = 'commit_swamp',         target = 1,   short = "SWAMP WATER",             text = "Commit SWAMP WATER",                          cond = notEasyName},
    { rank = { 3, 5 }, prompt = 'commit_swamp_l',       target = 1,   short = "BATH WATER LITE",         text = "Commit BATH WATER variant",                   cond = easyName},
    { rank = { 4, 6 }, prompt = 'commit_swamp',         target = 1,   short = "BATH WATER",              text = "Commit BATH WATER",                           cond = easyName},
    { rank = { 3, 6 }, prompt = 'commit_reversed',      target = 1,   short = "Commit inversed",         text = "Commit all cards\nthat aren't requested" },
    { rank = { 1, 4 }, prompt = 'commit_1card',         target = 3,   short = "Commit 1 cards 3x",       text = "Commit 3 times with\n1 card on first commit" },
    { rank = { 2, 5 }, prompt = 'commit_2card',         target = 4,   short = "Commit 2 cards 4x",       text = "Commit 4 times with\n2 cards on first commit" },
    { rank = { 3, 6 }, prompt = 'commit_3card',         target = 5,   short = "Commit 3 cards 5x",       text = "Commit 5 times with\n3 cards on first commit" },
    { rank = { 4, 6 }, prompt = 'commit_4card',         target = 4,   short = "Commit 4 cards 4x",       text = "Commit 4 times with\n4 cards on first commit" },
    { rank = { 5, 6 }, prompt = 'commit_5card',         target = 3,   short = "Commit 5 cards 3x",       text = "Commit 3 times with\n5 cards on first commit" },
    { rank = { 1, 4 }, prompt = 'pass',                 target = 10,  short = "Pass 10",                 text = "Pass 10 times" },
    { rank = { 5, 6 }, prompt = 'pass',                 target = 20,  short = "Pass 20",                 text = "Pass 20 times" },
    { rank = { 2, 5 }, prompt = 'pass_$1',              target = 2,   short = "Pass 2 with $1",          text = "Pass 2 times\nwith $1",                       init = rndMod, cond = notEDHandEDP },
    { rank = { 3, 5 }, prompt = 'pass_$1',              target = 3,   short = "Pass 3 with $1",          text = "Pass 3 times\nwith $1",                       init = rndMod, cond = notEDHandEDP },
    { rank = { 4, 6 }, prompt = 'pass_$1',              target = 4,   short = "Pass 4 with $1",          text = "Pass 4 times\nwith $1",                       init = rndMod, cond = notEDHandEDP },
    { rank = { 2, 4 }, prompt = 'pass_perfect',         target = 6,   short = "6x perf",                 text = "Get 6 perfect passes" },
    { rank = { 5, 6 }, prompt = 'pass_perfect',         target = 12,  short = "12x perf",                text = "Get 12 perfect passes" },
    { rank = { 2, 4 }, prompt = 'pass_imperfect',       target = 6,   short = "6x im-perf",              text = "Get 6 imperfect passes",                       cond = notENH },
    { rank = { 5, 6 }, prompt = 'pass_imperfect',       target = 12,  short = "12x im-perf",             text = "Get 12 imperfect passes",                      cond = notENH },
    { rank = { 4, 5 }, prompt = 'pass_imperfect_row',   target = 3,   short = "3x chain im-perf",        text = "Get 3 imperfect\npasses in a row",             cond = notENH },
    { rank = { 5, 6 }, prompt = 'pass_imperfect_row',   target = 8,   short = "8x chain im-perf",        text = "Get 8 imperfect\npasses in a row",             cond = notENH },
    { rank = { 2, 4 }, prompt = 'pass_perfect_row',     target = 4,   short = "4x chain perf",           text = "Get 4 perfect\npasses in a row" },
    { rank = { 3, 5 }, prompt = 'pass_perfect_row',     target = 6,   short = "6x chain perf",           text = "Get 6 perfect\npasses in a row" },
    { rank = { 4, 5 }, prompt = 'pass_perfect_row',     target = 8,   short = "8x chain perf",           text = "Get 8 perfect\npasses in a row" },
    { rank = { 4, 6 }, prompt = 'pass_perfect_row',     target = 10,  short = "10x chain perf",          text = "Get 10 perfect\npasses in a row" },
    { rank = { 2, 3 }, prompt = 'pass_second',          target = 4,   short = "2nd quest 4x",            text = "Pass the second\nquest 4 times" },
    { rank = { 3, 4 }, prompt = 'pass_second',          target = 8,   short = "2nd quest 8x",            text = "Pass the second\nquest 8 times" },
    { rank = { 4, 5 }, prompt = 'pass_second',          target = 12,  short = "2nd quest 12x",           text = "Pass the second\nquest 12 times" },
    { rank = { 2, 3 }, prompt = 'pass_third',           target = 1,   short = "3rd quest",               text = "Pass the third\nquest once",                   cond = EDP },
    { rank = { 3, 4 }, prompt = 'pass_third',           target = 2,   short = "3rd quest 2x",            text = "Pass the third\nquest 2 times",                cond = EDP },
    { rank = { 4, 5 }, prompt = 'pass_third',           target = 3,   short = "3rd quest 3x",            text = "Pass the third\nquest 3 times",                cond = EDP },
    { rank = { 2, 4 }, prompt = 'b2b_break_4',          target = 1,   short = "Break B2B 4x",            text = "Break B2B chain\nat B2B x4",                   cond = notENH },
    { rank = { 3, 4 }, prompt = 'b2b_break_6',          target = 1,   short = "Break B2B 6x",            text = "Break B2B chain\nat B2B x6",                   cond = notENH },
    { rank = { 4, 5 }, prompt = 'b2b_break_8',          target = 1,   short = "Break B2B 8x",            text = "Break B2B chain\nat B2B x8",                   cond = notENH },
    { rank = { 4, 6 }, prompt = 'b2b_break_10',         target = 1,   short = "Break B2B 10x",           text = "Break B2B chain\nat B2B x10",                  cond = notENH },
    { rank = { 4, 6 }, prompt = 'b2b_break_windup',     target = 1,   short = "Break B2B at a windup",   text = "Break B2B at a windup",                        cond = notENHorF9wind },
    { rank = { 5, 6 }, prompt = 'b2b_break_windup3',    target = 1,   short = "Break B2B at a windup3+", text = "Break B2B at\na Lv.3+ windup",                 cond = notENHorF9wind3 },
    { rank = { 1, 3 }, prompt = 'heal',                 target = 8,   short = "Heal 8 HP",               text = "Heal 8 HP",                                    cond = notEMS },
    { rank = { 2, 4 }, prompt = 'heal',                 target = 20,  short = "Heal 20 HP",              text = "Heal 20 HP",                                   cond = notEMS },
    { rank = { 1, 2 }, prompt = 'send',                 target = 6,   short = "Send 6",                  text = "Send 6 Attack" },
    { rank = { 3, 4 }, prompt = 'send',                 target = 20,  short = "Send 20",                 text = "Send 20 Attack" },
    { rank = { 5, 6 }, prompt = 'send',                 target = 40,  short = "Send 40",                 text = "Send 40 Attack" },
    { rank = { 3, 4 }, prompt = 'pass_windup',          target = 1,   short = "Windup",                  text = "Pass a windup",                               cond = F9wind },
    { rank = { 3, 5 }, prompt = 'pass_windup3',         target = 1,   short = "Windup3+",                text = "Pass a Lv.3+ windup",                         cond = F9wind3 },
    { rank = { 5, 5 }, prompt = 'pass_windup_inb2b',    target = 1,   short = "Windup with B2B",         text = "Pass a windup\nduring B2B charge",            cond = F9wind },
    { rank = { 4, 5 }, prompt = 'pass_windup',          target = 4,   short = "Windup x 4",              text = "Pass 4 windups",                              cond = F9wind },
    { rank = { 4, 4 }, prompt = 'pass_windup_perfect',  target = 1,   short = "Windup perf",             text = "Pass a windup\nperfectly",                    cond = F9wind },
    { rank = { 6, 6 }, prompt = 'pass_windup_inb2b',    target = 3,   short = "Windup x 3 with B2B",     text = "Pass 4 windups\nduring a B2B charge",         cond = F9wind },
    { rank = { 5, 5 }, prompt = 'pass_windup_perfect',  target = 4,   short = "Windup perf x 4",         text = "Pass 4 windups\nperfectly",                   cond = F9wind },
    { rank = { 5, 5 }, prompt = 'pass_windup3_perfect', target = 1,   short = "Windup3+ perf",           text = "Pass a Lv.3+\nwindup perfectly",              cond = F9wind3 },
    { rank = { 6, 6 }, prompt = 'pass_windup3_perfect', target = 4,   short = "Windup3+ perf x 4",       text = "Pass 4 Lv.3+\nwindups perfectly",             cond = F9wind3 },
    { rank = { 2, 2 }, prompt = 'dmg_time',             target = 4,   short = "Take Dmg 4x",             text = "Take damage 4 times",                         cond = notEMS },
    { rank = { 3, 3 }, prompt = 'dmg_time',             target = 8,   short = "Take Dmg 8x",             text = "Take damage 8 times",                         cond = notEMS },
    { rank = { 2, 4 }, prompt = 'dmg_amount',           target = 10,  short = "Lose 10 HP",              text = "Take 10 damage total",                        cond = notEMS },
    { rank = { 4, 6 }, prompt = 'dmg_amount',           target = 20,  short = "Lose 20 HP",              text = "Take 20 damage total",                        cond = notEMS },
    { rank = { 3, 4 }, prompt = 'timedmg_time',         target = 2,   short = "Take Time Dmg 2x",        text = "Take time damage 2 times",                    cond = F6 },
    { rank = { 5, 6 }, prompt = 'timedmg_time',         target = 4,   short = "Take Time Dmg 4x",        text = "Take time damage 4 times",                    cond = F6 },
    { rank = { 4, 6 }, prompt = 'keep_health_safe',     target = 8,   short = "Safe HP 8s",              text = "Keep HP safe\nfor 8 seconds",                 cond = F6 },
    { rank = { 4, 5 }, prompt = 'keep_health_danger',   target = 3,   short = "Critical HP 3s",          text = "Keep HP critical\nfor 3 seconds",             cond = notEMSorF6 },
    { rank = { 2, 5 }, prompt = 'keep_no_mouse',        target = 4,   short = "No mouse 4s",             text = "Don't use the mouse\nfor 4 seconds",          cond = f5 },
    { rank = { 2, 4 }, prompt = 'keep_no_commit',       target = 6,   short = "No commit 6s",            text = "Don't commit\nfor 6 seconds",                 cond = notRGVandEDP },
    { rank = { 3, 6 }, prompt = 'keep_no_cancel',       target = 8,   short = "No cancel 8s",            text = "Don't cancel\nfor 8 seconds" },
    { rank = { 2, 5 }, prompt = 'keep_no_keyboard',     target = 10,  short = "No keyboard 10s",         text = "Don't use the keyboard\nfor 10 seconds",      cond = F6 },
    { rank = { 3, 5 }, prompt = 'keep_no_perfect',      target = 12,  short = "No perfect 12s",          text = "Have no perfect\npasses for 12 seconds",      cond = notENH },
    { rank = { 4, 6 }, prompt = 'keep_no_imperfect',    target = 14,  short = "No imperfect 14s",        text = "Have no imperfect\npasses for 14 seconds",    cond = F6 },
    { rank = { 3, 5 }, prompt = 'keep_no_reset',        target = 16,  short = "No reset 16s",            text = "Don't reset\nfor 16 seconds" },
}
for i = 1, #d do d[i]._prompt = d[i].prompt end

return d
