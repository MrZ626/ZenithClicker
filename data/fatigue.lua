local d = {}

d.normal = {
    { time = 90,  event = { 'extraQuestBase', .2, 'animDuration', .5 } },
    { time = 180, event = { 'extraQuestBase', .2, 'animDuration', .5 } },
    { time = 240, event = { 'extraQuestBase', .2, 'animDuration', 1 } },
    { time = 300, event = { 'dmgTimerMul', -.1, 'animDuration', 1 },                   text = "FATIGUE SETS IN_",          desc = "TimerSpeed++" },
    { time = 330, event = { 'dmgCycle', -.5, 'dmgWrong', 1 },                          text = "YOUR BODY GROWS WEAK_",     desc = "DmgCycle--   Damage++" },
    { time = 360, event = { 'dmgTimerMul', -.1, 'dmgHeal', -1, 'animDuration', 1 },    text = "ALL SENSES BLUR TOGETHER_", desc = "TimerSpeed++   Heal--" },
    { time = 390, event = { 'dmgTimerMul', -.1, 'dmgWrong', 1 },                       text = "YOUR CONSCIOUSNESS FADES_", desc = "TimerSpeed++   Damage++" },
    { time = 420, event = { 'dmgTimerMul', -.05, 'dmgCycle', -.5, 'animDuration', 1 }, text = "THIS IS THE END.",          desc = "TimerSpeed++   DmgCycle--", final = true },
    { time = 422, event = { 'dmgTimerMul', -.05 } },
    { time = 425, event = { 'dmgTimerMul', -.05 } },
    { time = 430, event = { 'dmgTimerMul', -.05 } },
    { time = 480, event = { 'atkBufferCap', 6, 'animDuration', 2, 'maxQuestSize', 1 }, text = "FAREWELL.",                 desc = "QuestDifficulty++++++",     duration = 26, color = 'lB', },
    { time = 485, event = { 'atkBufferCap', 6, 'animDuration', 4, 'extraQuestVar', 1 } },
    { time = 490, event = { 'atkBufferCap', 6, 'animDuration', 4 } },
    { time = 500, event = { 'animDuration', 5 }, --[[21]] },
    { time = 510, event = { 'animDuration', 5 }, --[[26]]                              text = "" },
    { time = 520, event = { 'animDuration', 10, 'lifeLeak', .2 }, --[[36]]             text = "ANGINA.",                   desc = "HP leak",                   color = 'DR' },
    { time = 540, event = { 'animDuration', 12 }, --[[48]] },
    { time = 560, event = { 'animDuration', 14 }, --[[62]]                             text = "" },
    { time = 1e99 }, -- Total: dmgTimerMul-50%, Cycle-1, Wrong+2, killscreen at 520+100(150)s
}

d.rEX = {
    { time = 90,  event = { 'extraQuestBase', .2, 'animDuration', .5 } },
    { time = 180, event = { 'extraQuestBase', .2, 'animDuration', .5 } },
    { time = 240, event = { 'extraQuestBase', .2, 'animDuration', 1 } },
    { time = 240, event = { 'dmgTimerMul', -.2 },                                   text = "YOUR POWER SLIPS_",               desc = "TimerSpeed++" },
    { time = 270, event = { 'dmgWrong', 2 },                                        text = "WHISPERS OF DISCONTENT SPREAD_",  desc = "Damage++" },
    { time = 300, event = { 'dmgCycle', -1, 'animDuration', 1 },                    text = "PROTESTERS LINE THE STREETS_",    desc = "DmgCycle--" },
    { time = 330, event = { 'dmgTimerMul', -.2, 'dmgWrong', 2 },                    text = "YOUR CLOSEST ALLIES DEFECT_",     desc = "TimerSpeed++   Damage++" },
    { time = 360, event = { 'dmgTimerMul', -.1, 'dmgHeal', -1, 'animDuration', 1 }, text = "PARANOIA CLOUDS YOUR JUDGEMENT_", desc = "TimerSpeed++   Heal--" },
    { time = 362, event = { 'dmgTimerMul', -.05 } },
    { time = 365, event = { 'dmgTimerMul', -.05 } },
    { time = 390, event = { 'dmgCycle', -.5, 'dmgWrong', 1 },                       text = "THE REVOLUTION HAS BEGUN_",       desc = "DmgCycle--   Damage++" },
    { time = 420, event = { 'dmgTimerMul', -.1, 'animDuration', 1 },                text = "THE END OF AN ERA.",              desc = "TimerSpeed++++",         duration = 10, final = true },
    { time = 423, event = { 'dmgTimerMul', -.05 } },
    { time = 426, event = { 'dmgTimerMul', -.05 } },
    { time = 430, event = { 'dmgTimerMul', -.05 } },
    { time = 435, event = { 'dmgTimerMul', -.03 } },
    { time = 440, event = { 'dmgTimerMul', -.02, 'lifeLeak', .5 },                  text = "BLACK OUT.",                      desc = "HP leak",                color = 'DR' },
    { time = 1e99 }, -- Total: dmgTimerMul-90%, Cycle-1.5, Wrong+5, killscreen at 440+40(60)s
}

d.rDP = {
    { time = 20,  event = { 'dmgHeal', -1 }, --[[ 2 ]]                       text = "YOUR PASSION FADES_",                        desc = "Heal-",          duration = 10 },
    { time = 40,  event = { 'dmgHeal', -.5 }, --[[ 1.5 ]]                    text = "THEIR REPLIES BECOME LESS ENGAGED_",         desc = "Heal--",         duration = 10 },
    { time = 60,  event = { 'dmgHeal', -.5, 'animDuration', .5 }, --[[ 1 ]]  text = "YOU FEEL NEGLECTED_",                        desc = "Heal---",        duration = 10 },
    { time = 80,  event = { 'dmgHeal', 1 }, --[[ 2 ]]                        text = "THEY SUCCESSFULLY APOLOGIZE_?",              desc = "Heal+",          duration = 10, color = 'lO' },
    { time = 90,  event = { 'extraQuestBase', .2 } },
    { time = 100, event = { 'dmgHeal', 1 }, --[[ 3 ]]                        text = "THINGS ARE BACK TO HOW THEY USED TO BE_!",   desc = "Heal+++",        duration = 10, color = 'lO' },
    { time = 120, event = { 'dmgHeal', -1, 'animDuration', .5 }, --[[ 2 ]]   text = "MINOR ISSUES BECOME LARGE CONFLICTS_",       desc = "Heal--",         duration = 10 },
    { time = 140, event = { 'dmgHeal', -1 }, --[[ 1 ]]                       text = "YOU BLAME THEM FOR YOUR OWN PROBLEMS_",      desc = "Heal---",        duration = 10 },
    { time = 160, event = { 'reviveDifficulty', 3 },                         text = "THEY WOULD RATHER SPEND TIME ALONE_",        desc = "Revive++",       duration = 10 },
    { time = 180, event = { 'extraQuestBase', .2 } },
    { time = 180, event = { 'dmgHeal', 1.5, 'animDuration', 1 }, --[[ 2.5 ]] text = "YOU PROMISE TO CHANGE_",                     desc = "Heal++",         duration = 10, color = 'lO' },
    { time = 200, event = { 'dmgTimerMul', -.2 },                            text = "PROMISES ARE BROKEN_",                       desc = "TimerSpeed++",   duration = 10 },
    { time = 220, event = { 'dmgHeal', -.5 }, --[[ 2 ]]                      text = "CONVERSATIONS DEVOLVE TO SHOUTING MATCHES_", desc = "Heal---",        duration = 10 },
    { time = 240, event = { 'extraQuestBase', .2, 'animDuration', 1 } },
    { time = 240, event = { 'dmgHeal', -.5 }, --[[ 1.5 ]]                    text = "ALL TRUST HAS WITHERED AWAY_",               desc = "Heal--",         duration = 10 },
    { time = 260, event = { 'dmgHeal', -.5 }, --[[ 1 ]]                      text = "THEY SET AN ULTIMATUM_",                     desc = "Heal--",         duration = 10 },
    { time = 280, event = { 'dmgHeal', -.5 }, --[[ .5 ]]                     text = "YOU CAN'T BE BOTHERED ANYMORE_",             desc = "Heal--",         duration = 10 },
    { time = 300, event = { 'dmgWrong', 2, 'animDuration', 1 },              text = "ONE LAST PAINFUL ARGUMENT_",                 desc = "Dmg+",           duration = 10 },
    { time = 320, event = { 'reviveDifficulty', 9999 },                      text = "GOODBYE.",                                   desc = "NO REVIVE",      duration = 10, color = 'R' },
    { time = 360, event = { 'dmgHeal', 1, 'animDuration', 1 }, --[[ 1.5 ]]   text = "\"I MISS YOU\"",                             desc = "Heal+++",        duration = 10, color = 'lO' },
    { time = 380, event = { 'dmgHeal', 1 }, --[[ 2.5 ]]                      text = "MAYBE IT CAN STILL WORK_?",                  desc = "Heal+",          duration = 10, color = 'lO' },
    { time = 400, event = { 'dmgTimerMul', -.1, 'animDuration', 4 },         text = "GOODBYE.",                                   desc = "TimerSpeed++++", duration = 10, final = true },
    { time = 405, event = { 'dmgTimerMul', -.05 } },
    { time = 410, event = { 'dmgTimerMul', -.05 } },
    { time = 415, event = { 'dmgTimerMul', -.05 } },
    { time = 420, event = { 'dmgTimerMul', -.03 } },
    { time = 425, event = { 'dmgTimerMul', -.02 } },
    { time = 476, event = { 'lifeLeak', .2 },                                text = "CARDIAC RUPTURE.",                           desc = "HP leak",        color = 'DR' },
    { time = 1e99 }, -- Total: dmgTimerMul-50%, killscreen at 476+150s
}

-- My formatter doesn't work if there's "…" inside
for _, f in next, d do for _, v in next, f do if v.text then v.text = v.text:gsub("_", "…") end end end

return d
