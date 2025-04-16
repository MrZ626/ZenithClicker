local max, min = math.max, math.min
local floor, ceil = math.floor, math.ceil
local abs, rnd = math.abs, math.random

local ins, rem = table.insert, table.remove

---@class Question
---@field combo string[]
---@field name love.Text

---@class ReviveTask:Prompt
---@field progress number
---@field textObj love.Text
---@field shortObj love.Text
---@field progObj love.Text

---@class Game
---@field playing boolean
---
---@field prevPB number
---@field comboStr string
---@field totalFlip number
---@field totalQuest number
---@field totalPerfect number
---@field totalAttack number
---@field heightBonus number
---@field peakRank number
---@field rankTimer integer[]
---
---@field time number
---@field gigaTime false | number
---@field questTime number
---@field floorTime number
---
---@field rank number
---@field xp number
---@field rankupLast boolean
---@field xpLockLevel number
---@field xpLockTimer number
---
---@field floor number
---@field height number
---@field heightBuffer number
---@field fatigueSet {time:number, event:table, text:string, desc:string, color?:string}[]
---@field fatigue number
---
---@field queueLen number
---@field maxComboSize number
---@field extraComboBase number
---@field extraComboVar number
---@field dmgHeal number
---@field dmgWrong number
---@field dmgWrongExtra number
---@field dmgTime number
---@field dmgDelay number
---@field dmgCycle number
---
---@field life number
---@field fullHealth number
---@field dmgTimer number
---@field chain number
---@field gigaspeed boolean
---@field gigaspeedEntered false | number
---@field atkBuffer number
---@field atkBufferCap number
---@field shuffleReady number | false
---
---@field gravDelay false | number
---@field gravTimer false | number
---
---@field onAlly boolean
---@field life2 number
---@field maxRank number
---@field reviveCount number
---@field currentTask ReviveTask |false
---@field DPlock boolean
---@field lastFlip number | false
local GAME = {
    forfeitTimer = 0,
    exTimer = 0,
    anyRev = false,
    revTimer = 0,
    revDeckSkin = false,
    uiHide = 0,
    bgX = 0,
    bgXdir = 0,
    bgH = 0,
    bgLastH = 0,
    lifeShow = 0,
    lifeShow2 = 0,
    prevPB = -260,
    modIB = GC.newSpriteBatch(TEXTURE.modIcon),
    resIB = GC.newSpriteBatch(TEXTURE.modIcon),
    comboMP = 0,
    comboZP = 1,

    completion = { -- 0=not mastered, 1=mastered, 2=rev mastered
        EX = 0,
        NH = 0,
        MS = 0,
        GV = 0,
        VL = 0,
        DH = 0,
        IN = 0,
        AS = 0,
        DP = 0,
    },

    mod = {
        EX = 0,
        NH = 0,
        MS = 0,
        GV = 0,
        VL = 0,
        DH = 0,
        IN = 0,
        AS = 0,
        DP = 0,
    },
    hardMode = false,
    numberRev = false,

    quests = {}, ---@type Question[]
    reviveTasks = {}, ---@type ReviveTask[]
    currentTask = false, ---@type false | ReviveTask
    lastFlip = false,

    zenithTraveler = false,
}

GAME.playing = false
GAME.fullHealth = 20
GAME.life = 0
GAME.life2 = 0
GAME.time = 0
GAME.floorTime = 2.6
GAME.floor = 1
GAME.rank = 1
GAME.xp = 0
GAME.height = 0
GAME.chain = 0

local M = GAME.mod
local MD = ModData
local CD = Cards

--- Unsorted, like {'rEX','NH',...}
function GAME.getHand(real)
    local list = {}
    if real then
        -- FOR ULTIMATE SPEED
        if M.EX > 0 then ins(list, M.EX == 1 and 'EX' or 'rEX') end
        if M.NH > 0 then ins(list, M.NH == 1 and 'NH' or 'rNH') end
        if M.MS > 0 then ins(list, M.MS == 1 and 'MS' or 'rMS') end
        if M.GV > 0 then ins(list, M.GV == 1 and 'GV' or 'rGV') end
        if M.VL > 0 then ins(list, M.VL == 1 and 'VL' or 'rVL') end
        if M.DH > 0 then ins(list, M.DH == 1 and 'DH' or 'rDH') end
        if M.IN > 0 then ins(list, M.IN == 1 and 'IN' or 'rIN') end
        if M.AS > 0 then ins(list, M.AS == 1 and 'AS' or 'rAS') end
        if M.DP > 0 then ins(list, M.DP == 1 and 'DP' or 'rDP') end
        -- for i = 1, 9 do
        --     local D = ModData.deck[i]
        --     local level = M[D.id]
        --     if level == 1 then
        --         ins(list, D.id)
        --     elseif level == 2 then
        --         ins(list, 'r' .. D.id)
        --     end
        -- end
    else
        -- FASTER
        for i = 1, 9 do
            if CD[i].active then
                ins(list, CD[i].id)
            end
        end
        -- for _, C in ipairs(Cards) do
        --     if C.active then
        --         ins(list, C.id)
        --     end
        -- end
    end
    return list
end

---@param list string[]
function GAME.getComboMP(list)
    return #table.concat(list) - #list
end

---@param list string[]
function GAME.getComboZP(list)
    local m = TABLE.getValueSet(list)
    local zp = 1

    if m.EX then zp = zp * 1.4 elseif m.rEX then zp = zp * 2.6 end
    if m.NH then zp = zp * 1.1 elseif m.rNH then zp = zp * 1.6 end
    if m.MS then zp = zp * 1.2 elseif m.rMS then zp = zp * 2.0 end
    if m.GV then zp = zp * 1.1 elseif m.rGV then zp = zp * (1.2 + .03 * (#list - 1)) end
    if m.VL then zp = zp * 1.1 elseif m.rVL then zp = zp * (1.2 + .02 * (#list - 1)) end
    if m.DH then zp = zp * 1.2 elseif m.rDH then zp = zp * (m.rIN and 2 or 1.6) end
    if m.IN then zp = zp * 1.1 elseif m.rIN then zp = zp * (m.rNH and ((m.DP or m.rDP) and 2 or 2.2) or 1.6) end
    if m.AS then zp = zp * .85 elseif m.rAS then zp = zp * 1.1 end
    if m.DP then zp = zp * .95 elseif m.rDP then zp = zp * (m.rEX and 1.6 or 2.2) end

    local hardCnt = STRING.count(table.concat(list), "r")
    if m.EX then hardCnt = hardCnt + 1 end
    if hardCnt >= 2 then zp = zp * 0.99 ^ (hardCnt - 1) end

    return zp
end

---@param list string[] WILL BE SORTED!!!
---@param extend? boolean use extended combo lib from community
---@param ingame? boolean return a color-string table instead
function GAME.getComboName(list, extend, ingame)
    local len = #list
    if ingame then
        if len == 0 then return {} end

        local fstr = {}

        local comboText
        if not GAME.anyRev and not TABLE.find(list, 'DP') then
            comboText = len == 8 and [["SWAMP WATER"]] or len == 7 and [["SWAMP WATER LITE"]]
            if comboText then
                fstr = comboText:atomize()
                for i = #fstr, 1, -1 do
                    ins(fstr, i, i % #fstr <= 1 and COLOR.dL or COLOR.random(5))
                end
                return fstr
            end
        end

        local str = table.concat(TABLE.sort(list), ' ')
        if ComboData[str] and (ComboData[str].basic or extend) then
            return { COLOR.dL, ComboData[str].name }
        end

        table.sort(list, function(a, b) return MD.prio[a] < MD.prio[b] end)

        for i = 1, len - 1 do
            ins(fstr, MD.textColor[list[i]])
            ins(fstr, MD.adj[list[i]] .. " ")
        end
        ins(fstr, MD.textColor[list[len]])
        ins(fstr, MD.noun[list[len]])
        if M.NH == 2 then
            for i = 1, #fstr, 2 do
                fstr[i] = TABLE.copy(fstr[i])
                for j = 1, 3 do
                    fstr[i][j] = fstr[i][j] * .7 + .26
                end
            end
        elseif M.IN > 0 then
            local r = rnd(0, 3)
            for i = 1, #fstr, 2 do
                r =
                    r == 0 and rnd(2, 3) or
                    r == 1 and 3 or
                    r == 2 and 0 or rnd(0, 1)
                fstr[i] = { 1, 1, 1, .6 + .13 * r }
            end
        end

        return fstr
    else
        -- Simple
        if len == 0 then return "" end
        if len == 1 then return MD.noun[list[1]] end

        -- Super Set
        if GAME.anyRev and STRING.count(table.concat(list), "r") >= 2 then
            local mp = GAME.getComboMP(list)
            if mp >= 8 then return RevComboData[min(mp, #RevComboData)] end
        elseif len >= 7 then
            return
                GAME.anyRev and (
                    len == 7 and [["SWAMP WATER LITE+"]] or
                    len == 8 and [["SWAMP WATER+"]] or
                    len == 9 and [["SWAMP WATER PRO+"]] or
                    [["SWAMP WATER X+"]]
                ) or (
                    len == 7 and [["SWAMP WATER LITE"]] or
                    len == 8 and [["SWAMP WATER"]] or
                    len == 9 and [["SWAMP WATER PRO"]] or
                    [["SWAMP WATER X"]]
                )
        end

        -- Normal Combo
        local str = table.concat(TABLE.sort(list), ' ')
        if ComboData[str] and (ComboData[str].basic or extend) then return ComboData[str].name end

        table.sort(list, function(a, b) return MD.prio[a] < MD.prio[b] end)

        str = ""
        for i = 1, len - 1 do str = str .. MD.adj[list[i]] .. " " end
        return str .. MD.noun[list[len]]
    end
end

---@param event 'start' | 'finish' | 'revSwitched' | 'ingame' | 'init'
function GAME.updateBgm(event)
    if event == 'start' then
        BGM.set(BgmSets.assist, 'volume', 1)
        BGM.set('bass', 'volume', .26)
        if GAME.anyRev then
            BGM.set('rev', 'volume', M.DP > 0 and .5 or .7)
        end
    elseif event == 'finish' then
        BGM.set(BgmSets.assist, 'volume', 0)
        local l = TABLE.copy(BgmSets.assist)
        for _ = 1, MATH.clamp(GAME.floor - 6, 2, 4) do
            BGM.set(TABLE.popRandom(l), 'volume', 1)
        end
        if GAME.anyRev then
            BGM.set('rev', 'volume', M.DP > 0 and .5 or .7)
            if M.DP == 2 then BGM.set('violin', 'volume', 1) end
        end
    elseif event == 'revSwitched' then
        if GAME.anyRev then
            BGM.set('rev', 'volume', M.DP > 0 and .5 or .7, 4.2)
            BGM.set(BgmSets.assist, 'volume', 0, 4.2)
            if M.DP == 2 then BGM.set('violin', 'volume', 1) end
        else
            BGM.set('rev', 'volume', 0, 2.6)
            local l = TABLE.copy(BgmSets.assist)
            for _ = 1, 2 do
                BGM.set(TABLE.popRandom(l), 'volume', 1, 4.2)
            end
        end
    elseif event == 'ingame' then
        if GAME.floor < 10 then
            BGM.set('staccato', 'volume', MATH.clampInterpolate(1, 1, 6, .26, GAME.floor))
            BGM.set('bass', 'volume', MATH.clampInterpolate(1, .26, 9, 1, GAME.floor))
        else
            local f = GAME.fatigue
            BGM.set('staccato', 'volume', f == 1 and 0 or 1)
            BGM.set('bass', 'volume', min((f - 1) * .4, 1))
        end
    elseif event == 'init' then
        BGM.play(BgmSets.all)
        BGM.set('all', 'volume', 0, 0)
        BGM.set('piano', 'volume', 1)
        BGM.set('piano2', 'pitch', 2, 0)
        BGM.set(TABLE.getRandom(BgmSets.assist), 'volume', 1, 10)
    end
end

function GAME.anim_setMenuHide(t)
    GAME.uiHide = t
    local w = SCN.scenes.tower.widgetList
    ---@cast w -nil
    w.stat.x = MATH.cLerp(60, -90, t * 1.5 - .5)
    w.stat:resetPos()
    w.achv.x = MATH.cLerp(60, -90, t * 1.5)
    w.achv:resetPos()
    w.conf.x = MATH.cLerp(-60, 90, t * 1.5 - .5)
    w.conf:resetPos()
    w.about.x = MATH.cLerp(-60, 90, t * 1.5)
    w.about:resetPos()
    MSG.setSafeY(75 * (1 - GAME.uiHide))
end

function GAME.anim_setMenuHide_rev(t)
    GAME.anim_setMenuHide(1 - t)
end

local floorHeights = {}
for i = 0, 9 do ins(floorHeights, Floors[i].top) end
function GAME.getBgFloor()
    return floor(1 + 9 * MATH.ilLerp(floorHeights, GAME.bgH))
end

function GAME.task_gigaspeed()
    TWEEN.new(function(t) GigaSpeed.textTimer = 1 - 2 * t end):setEase('Linear'):setDuration(2.6):run()
        :setOnFinish(function() GigaSpeed.textTimer = false end)
end

function GAME.task_fatigueWarn()
    for _ = 1, 3 do
        for _ = 1, M.DP == 2 and 1 or 3 do SFX.play('warning', 1, 0, M.GV) end
        TASK.yieldT(1)
    end
end

function GAME.cancelBurn()
    for i = 1, #CD do CD[i].burn = false end
end

function GAME.sortCards()
    table.sort(CD, function(a, b) return a.initOrder < b.initOrder end)
end

function GAME.shuffleCards(maxDist)
    local order = {}
    for i = 1, #CD do order[i] = i end

    local r = {}
    for i = 1, #CD - 1 do r[i] = i end
    TABLE.shuffle(r)

    for _, p in next, r do
        order[p], order[p + 1] = order[p + 1], order[p]
        local illegal
        for j = 1, #order do
            if abs(order[j] - j) > maxDist then
                illegal = true
                break
            end
        end
        if illegal then
            order[p], order[p + 1] = order[p + 1], order[p]
        end
    end

    for i = 1, #order do CD[i].tempOrder = order[i] end
    table.sort(CD, function(a, b) return a.tempOrder < b.tempOrder end)

    GAME.refreshLayout()
end

function GAME.genQuest()
    local combo = {}
    local base = .872 + GAME.floor ^ .5 / 6 + GAME.extraComboBase + MATH.icLerp(6200, 10000, GAME.height)
    local var = GAME.floor * .26 * GAME.extraComboVar
    local r = MATH.clamp(base + var * abs(MATH.randNorm()), 1, GAME.maxComboSize)
    if M.DP == 0 then
        GAME.atkBuffer = GAME.atkBuffer + r
        if GAME.atkBuffer > GAME.atkBufferCap then
            r = r - (GAME.atkBuffer - GAME.atkBufferCap)
            GAME.atkBuffer = GAME.atkBufferCap
        end
        GAME.atkBuffer = max(GAME.atkBuffer - (max(GAME.floor / 3, GAME.atkBufferCap / 4)), 0)
    end

    local pool = TABLE.copyAll(MD.weight)
    if M.DH == 2 then pool.DP = pool.DP * .5 end
    local lastQ = GAME.quests[#GAME.quests]
    if lastQ then pool[lastQ.combo[1]] = nil end
    for _ = 1, MATH.clamp(MATH.roundRnd(r), 1, GAME.maxComboSize) do
        local mod = MATH.randFreqAll(pool)
        pool[mod] = nil
        ins(combo, mod)
    end

    ins(GAME.quests, {
        combo = combo,
        name = GC.newText(FONT.get(70), GAME.getComboName(TABLE.copy(combo), M.DH == 2, true)),
    })
end

function GAME.questReady()
    GAME.questTime = 0
    GAME.fault = false
    GAME.faultWrong = false
    GAME.dmgWrongExtra = 0
    GAME.gravTimer = false
    for _, C in ipairs(CD) do C.touchCount, C.isCorrect = 0, false end
    if M.DP > 0 then for _, v in next, GAME.quests[2].combo do CD[v].isCorrect = 2 end end
    for _, v in next, GAME.quests[1].combo do CD[v].isCorrect = 1 end
end

function GAME.startRevive()
    if GAME.reviveCount < 260 then
        local power = min(GAME.floor + GAME.reviveCount, 17)
        local maxOut = power == 17
        local powerList = TABLE.new(floor(power / 3), 3)
        if power % 3 == 1 then
            if power == maxOut then
                powerList[2] = powerList[2] + 1
            else
                local r = rnd(3)
                powerList[r] = powerList[r] + 1
            end
        elseif power % 3 == 2 then
            powerList[1] = powerList[1] + 1
            powerList[2] = powerList[2] + 1
            powerList[3] = powerList[3] + 1
            local r = rnd(3)
            powerList[r] = powerList[r] - 1
        end
        TABLE.delete(powerList, 0)

        TABLE.clear(GAME.reviveTasks)
        for _, pow in next, powerList do
            local options = {} ---@type Prompt[]
            for _, opt in next, RevivePrompts do
                if opt.rank[1] <= pow and pow <= opt.rank[2] and (not opt.cond or opt.cond()) then
                    local repeated
                    for _, t in next, GAME.reviveTasks do
                        if t.prompt == opt.prompt then
                            repeated = true
                            break
                        end
                    end
                    if not repeated then
                        ins(options, opt)
                    end
                end
            end
            if #options > 0 then
                local task = TABLE.copyAll(TABLE.getRandom(options))
                if task.init then task.init(task) end
                ---@cast task ReviveTask
                task.progress = 0
                task.textObj = GC.newText(FONT.get(30), task.text)
                task.shortObj = GC.newText(FONT.get(30), task.short)
                task.progObj = GC.newText(FONT.get(30), "0/" .. task.target)
                ins(GAME.reviveTasks, task)
            end
        end
        SFX.play('boardlock')
    else
        SFX.play('losestock')
    end
    GAME.currentTask = GAME.reviveTasks[1] or false
    GAME.DPlock = M.DP == 2
end

function GAME.incrementPrompt(prompt, value)
    local t = GAME.currentTask
    if t and prompt == t.prompt then
        local oldProg = t.progress
        t.progress = min(t.progress + (value or 1), t.target)
        if floor(oldProg) ~= floor(t.progress) and not TASK.getLock('noIncrementSFX') then
            SFX.play('boardlock_clink')
            TASK.lock('noIncrementSFX', 0.026)
        end
        if t.progress >= t.target then
            GAME.currentTask = TABLE.next(GAME.reviveTasks, GAME.currentTask) or false
            if GAME.currentTask then
                SFX.play('boardlock_clear')
            else
                GAME.currentTask = false
                GAME.reviveCount = GAME.reviveCount + 1
                GAME[GAME.getLifeKey(true)] = GAME.fullHealth
                SFX.play('boardlock_revive')
                GAME.DPlock = false
            end
        end
        t.progObj:set(floor(t.progress) .. "/" .. t.target)
    end
end

function GAME.nixPrompt(prompt)
    local t = GAME.currentTask
    if t and prompt == t.prompt then
        if t.progress >= 1 then
            SFX.play('boardlock_fail')
            TASK.lock('noIncrementSFX', 0.026)
        end
        t.progress = 0
        t.progObj:set(floor(t.progress) .. "/" .. t.target)
    end
end

function GAME.getLifeKey(another)
    if M.DP == 0 then return 'life' end
    return (GAME.onAlly ~= not another) and 'life' or 'life2'
end

function GAME.heal(hp)
    local k = GAME.getLifeKey()
    hp = max(min(hp, GAME.fullHealth - GAME[k]), 0)
    GAME[k] = GAME[k] + hp
    GAME.incrementPrompt('heal', hp)

    GAME.freshLifeState()
end

---@param dmg number
---@param reason 'wrong' | 'time'
---@param toAlly? boolean
function GAME.takeDamage(dmg, reason, toAlly)
    if GAME.currentTask then
        GAME.incrementPrompt('dmg_time')
        GAME.incrementPrompt('dmg_amount', dmg)
        if reason == 'time' then GAME.incrementPrompt('timedmg_time') end
    end

    local k = GAME.getLifeKey(toAlly)
    GAME[k] = max(GAME[k] - dmg, 0)
    SFX.play(
        toAlly and 'inject' or
        dmg <= 1.626 and 'damage_small' or
        dmg <= 4.2 and 'damage_medium' or
        'damage_large', .872
    )
    if GAME[k] <= 0 then
        if GAME[GAME.getLifeKey(not toAlly)] > 0 then
            if toAlly then
                SFX.play('elim')
            else
                GAME.swapControl()
            end
            GAME.startRevive()
            GAME.dmgWrongExtra = 0 -- Being tolerant!
        else
            GAME.finish(reason)
            return true
        end
    else
        GAME.freshLifeState()
    end
end

function GAME.addHeight(h)
    h = h * GAME.rank / 4
    GAME.heightBonus = GAME.heightBonus + h
    GAME.heightBuffer = GAME.heightBuffer + h
end

function GAME.addXP(xp)
    GAME.xp = GAME.xp + xp
    if GAME.xpLockLevel < 5 and GAME.rankupLast and GAME.xp >= 2 * GAME.rank then
        GAME.xpLockLevel = 5
    end
    local oldRank = GAME.rank
    local oldLockTimer = GAME.xpLockTimer
    while GAME.xp >= 4 * GAME.rank do
        GAME.xp = GAME.xp - 4 * GAME.rank
        GAME.rank = GAME.rank + 1
        GAME.rankupLast = true
        GAME.xpLockTimer = GAME.xpLockLevel
        GAME.xpLockLevel = max(GAME.xpLockLevel - 1, 1)

        -- Rank skip
        if GAME.xp >= 4 * GAME.rank then
            GAME.rank = GAME.rank + floor(GAME.xp / (4 * GAME.rank))
            -- One more
            if GAME.xp >= 4 * GAME.rank then
                GAME.rank = GAME.rank + 1
                GAME.xp = GAME.xp - 4 * GAME.rank
            end
            GAME.xpLockLevel = 5
        end
    end
    if GAME.rank > GAME.maxRank then
        GAME.rank = GAME.maxRank
        GAME.xp = 4 * GAME.rank
    end
    if GAME.rank ~= oldRank then
        GAME.peakRank = max(GAME.peakRank, GAME.rank)
        TEXTS.rank:set("R-" .. GAME.rank)
        SFX.play('speed_up_' .. MATH.clamp(floor((GAME.rank + .5) / 1.5), 1, 4),
            .4 + .1 * GAME.xpLockLevel * min(GAME.rank / 4, 1))
        if not GAME.gigaspeedEntered and GAME.rank >= GigaSpeedReq[GAME.floor] then
            GAME.setGigaspeedAnim(true)
            SFX.play('zenith_speedrun_start')
            GAME.refreshRPC()
        end
    else
        GAME.xpLockTimer = oldLockTimer
    end
end

function GAME.setGigaspeedAnim(on, finish)
    GAME.gigaspeed = on
    local s = GigaSpeed.alpha
    if on then
        GAME.gigaspeedEntered = GAME.floor
        TWEEN.new(function(t) GigaSpeed.alpha = MATH.lerp(s, 1, t) end)
            :setUnique('giga'):run()
        TASK.removeTask_code(GAME.task_gigaspeed)
        TASK.new(GAME.task_gigaspeed)
    else
        TWEEN.new(function(t) GigaSpeed.alpha = MATH.lerp(s, 0, t) end):setDuration(finish and 6.26 or 3.55)
            :setUnique('giga'):run()
    end
end

function GAME.upFloor()
    GAME.floor = GAME.floor + 1
    GAME.floorTime = 0
    if GAME.floor > 1 then
        if M.MS == 1 and Floors[GAME.floor].MSshuffle then
            GAME.shuffleReady = 1
        elseif M.MS == 2 then
            GAME.shuffleReady = ceil(GAME.floor / 2)
        end
        if GAME.shuffleReady then
            SFX.play('rsg_go', 1, 0, 2 + M.GV)
            for _, C in ipairs(CD) do
                C:shake()
            end
        end
    end
    if M.GV > 0 then GAME.gravDelay = GravityTimer[M.GV][GAME.floor] end
    local F = Floors[GAME.floor]
    local e = F.event
    for i = 1, #e, 2 do
        GAME[e[i]] = GAME[e[i]] + e[i + 1]
    end
    if GAME.dmgTimer > GAME.dmgDelay then GAME.dmgTimer = GAME.dmgDelay end

    local duration = GAME.floor >= 10 and 8.72 or 4.2
    TEXT:add {
        text = "Floor",
        x = 160, y = 290, k = 1.6, fontSize = 30,
        color = 'LY', duration = duration,
    }
    TEXT:add {
        text = tostring(GAME.floor),
        x = 240, y = 280, k = 2.6, fontSize = 30,
        color = 'LY', duration = duration, align = 'left',
    }
    TEXT:add {
        text = Floors[GAME.floor].name,
        x = 200, y = 350, k = 1.2, fontSize = 30,
        color = 'LY', duration = duration,
    }
    if GAME.floor > 1 then SFX.play('zenith_levelup_g', 1, 0, M.GV) end
    if GAME.gigaspeed then SFX.play('zenith_split_cleared', 1, 0, -1 + M.GV) end
    if GAME.floor >= 10 then
        local roundTime = MATH.roundUnit(GAME.time, .001)
        if GAME.gigaspeed then
            if GAME.time < STAT.minTime then
                STAT.minTime = roundTime
                STAT.timeDate = os.date("%y.%m.%d %H:%M%p")
                SaveStat()
            end
            GAME.gigaTime = GAME.time
            GAME.setGigaspeedAnim(false, true)
            local t = BEST.speedrun[GAME.comboStr]
            SFX.play('applause', GAME.time < t and t < 1e99 and 1 or .42)
            if GAME.time < t then
                BEST.speedrun[GAME.comboStr] = roundTime
                SaveBest()
            end
        end
    end
    GAME.updateBgm('ingame')
    GAME.refreshRPC()
end

local revLetter = setmetatable({
    P = "Ь", R = "ᖉ", T = "ꓕ", Q = "О́", U = "Ո", A = "Ɐ", L = "Γ",
}, { __index = function(_, k) return k end })
function GAME.refreshRPC()
    local detailStr = M.EX > 0 and "EXPERT QUICK PICK" or "QUICK PICK"
    if M.DP > 0 then detailStr = detailStr:gsub("QUICK", "DUAL") end
    if GAME.anyRev then detailStr = detailStr:gsub(".", revLetter) end

    local stateStr
    if GAME.playing then
        stateStr = GAME.gigaspeed and "Speedrun: " or "In game: "
        stateStr = stateStr .. "F" .. GAME.floor
        local hand = GAME.getHand(true)
        if #hand > 0 then stateStr = stateStr .. " - " .. GAME.getComboName(hand, M.DH == 2) end
    else
        stateStr = "Listening to music"
        if M.NH > 0 then stateStr = stateStr .. " (Inst.)" end
        if M.GV > 0 then stateStr = stateStr .. " (+" .. M.GV .. ")" end
        if M.IN > 0 then
            stateStr = stateStr:gsub("j", "r"):gsub("s", "z"):gsub("tch", "dge")
                :gsub("p", "b"):gsub("c", "g"):gsub("t", "d")
        end
    end

    DiscordState = {
        needUpdate = true,
        details = detailStr,
        state = stateStr,
    }
    TASK.lock('RPC_update', 1.6)
end

local modIconPos = {
    { -2, -1.5 }, { -2, 0.5 }, { -1, -0.5 }, { -1, 1.5 },
    { 0,  -1.5 }, { 0, 0.5 }, { 1, -0.5 }, { 1, 1.5 },
    { 2, -1.5 }, { 2, 0.5 }, { 3, -0.5 }, { 3, 1.5 },
}

function GAME.refreshModIcon()
    GAME.modIB:clear()
    local hand = GAME.getHand(true)
    table.sort(hand, function(a, b) return MD.prio_icon[a] < MD.prio_icon[b] end)
    if #hand == 1 then
        GAME.modIB:add(
            TEXTURE.modQuad_ig_ex[hand[1]], 0, 0,
            0, #hand[1] == 3 and .7023 or .62, nil, 219 * .5, 219 * .5
        )
    elseif #hand == 2 then
        GAME.modIB:add(
            TEXTURE.modQuad_ig_ex[hand[2]], 35, 0,
            0, #hand[2] == 3 and .626 or .5, nil, 219 * .5, 219 * .5
        )
        GAME.modIB:add(
            TEXTURE.modQuad_ig_ex[hand[1]], -35, 0,
            0, #hand[1] == 3 and .626 or .5, nil, 219 * .5, 219 * .5
        )
    else
        local r = 35
        for x = 3, 2, -1 do
            for i = #hand, 1, -1 do
                if #hand[i] == x then
                    GAME.modIB:add(
                        TEXTURE.modQuad_ig[hand[i]],
                        modIconPos[i][1] * r, modIconPos[i][2] * r,
                        0, x == 3 and .4 or .28, nil, 219 * .5, 219 * .5
                    )
                end
            end
        end
    end
end

function GAME.refreshResultModIcon()
    GAME.resIB:clear()
    local hand = GAME.getHand(true)
    table.sort(hand, function(a, b) return MD.prio_icon[a] < MD.prio_icon[b] end)
    if #hand == 1 then
        GAME.resIB:add(
            TEXTURE.modQuad_res_ex[hand[1]], 0, 0,
            0, #hand[1] == 3 and .626 or .5, nil, 183 * .5, 183 * .5
        )
    elseif #hand == 2 then
        GAME.resIB:add(
            TEXTURE.modQuad_res_ex[hand[2]], 35, 0,
            0, #hand[2] == 3 and .567 or .432, nil, 183 * .5, 183 * .5
        )
        GAME.resIB:add(
            TEXTURE.modQuad_res_ex[hand[1]], -35, 0,
            0, #hand[1] == 3 and .567 or .432, nil, 183 * .5, 183 * .5
        )
    else
        local r = 35
        for x = 3, 2, -1 do
            for i = #hand, 1, -1 do
                if #hand[i] == x then
                    GAME.resIB:add(
                        TEXTURE.modQuad_res[hand[i]],
                        modIconPos[i][1] * r, modIconPos[i][2] * r,
                        0, x == 3 and .36 or .3, nil, 183 * .5, 183 * .5
                    )
                end
            end
        end
    end
end

--------------------------------------------------------------

function GAME.refreshCurrentCombo()
    local hand = GAME.getHand(not GAME.playing)
    TEXTS.mod:set(GAME.getComboName(hand, M.DH == 2))
    if not GAME.playing then
        GAME.comboMP = GAME.getComboMP(hand)
        GAME.comboZP = GAME.getComboZP(hand)
        TEXTS.mpPreview:set(GAME.comboMP .. " MP")
        TEXTS.zpPreview:set(("%.2fx ZP"):format(GAME.comboZP))
        DailyActived =
            #GAME.getHand(true) == #DAILY and
            TABLE.equal(TABLE.sort(GAME.getHand(true)), TABLE.sort(TABLE.copy(DAILY)))

        local lastLine = (
            #hand == 0 and "Without any mods, " or
            #hand == 1 and "With this mod, " or
            "With this combo, "
        ) .. "ZP gain starts from 0%% at %.0fm, to 100%% at %.0fm"
        local W = SCN.scenes.tower.widgetList.help2
        W.floatText = "Each mod will multiply ZP gain with a certain rate.\n" ..
            lastLine:format(STAT.zp / 26 / GAME.comboZP, STAT.zp / 16 / GAME.comboZP)
        W:reset()
    end
end

function GAME.refreshLayout()
    local baseDist = (M.EX > 0 and 100 or 110) + M.VL * 20
    local baseL, baseR = 800 - 4 * baseDist - 70, 800 + 4 * baseDist + 70
    local dodge = M.VL == 0 and 260 or 220
    local baseY = 726 + 15 * M.GV
    local float = M.NH < 2
    if FloatOnCard then
        local selX = 800 + (FloatOnCard - 5) * baseDist
        for i = 1, #CD do
            local C = CD[i]
            if i < FloatOnCard then
                C.tx = MATH.interpolate(1, baseL, FloatOnCard - 1, selX - dodge, i)
                if C.tx ~= C.tx then C.tx = baseL end
            elseif i > FloatOnCard then
                C.tx = MATH.interpolate(#CD, baseR, FloatOnCard + 1, selX + dodge, i)
                if C.tx ~= C.tx then C.tx = baseR end
            else
                C.tx = selX
            end
            C.ty = baseY - (float and (C.active and 45 or 0) + (i == FloatOnCard and 55 or 0) or 0)
        end
    else
        for i, C in ipairs(CD) do
            C.tx = 800 + (i - 5) * baseDist
            C.ty = baseY - (float and (C.active and 45 or 0) + (i == FloatOnCard and 55 or 0) or 0)
        end
    end
end

function GAME.refreshCursor()
    local sum = 0
    for _, v in next, GAME.completion do
        sum = sum + v ^ 1.37851162325373
    end
    CursorProgress = sum / 23.4
end

function GAME.refreshLockState()
    CD.EX.lock = STAT.maxFloor < 9
    CD.NH.lock = STAT.maxFloor < 2
    CD.MS.lock = STAT.maxFloor < 3
    CD.GV.lock = STAT.maxFloor < 4
    CD.VL.lock = STAT.maxFloor < 5
    CD.DH.lock = STAT.maxFloor < 6
    CD.IN.lock = STAT.maxFloor < 7
    CD.AS.lock = STAT.maxFloor < 8
    CD.DP.lock = GAME.completion.DP == 0 -- Possible, try to find the way to play it
end

function GAME.refreshPBText()
    local setStr = table.concat(TABLE.sort(GAME.getHand(true)))
    local height = BEST.highScore[setStr]
    if height == 0 then
        TEXTS.pb:set("No score yet")
    else
        local time = BEST.speedrun[setStr]
        if time < 1e99 then
            TEXTS.pb:set(("%.1fm    %.3fs"):format(height, time))
        else
            local f = 0
            for i = 1, #Floors do
                if height < Floors[i].top then
                    f = i
                    break
                end
            end
            TEXTS.pb:set(("%.1fm  <F%d>"):format(height, f))
        end
    end
end

function GAME.refreshRev()
    local hasRev = false
    for _, C in ipairs(CD) do
        if M[C.id] == 2 then
            hasRev = true
            break
        end
    end
    if hasRev ~= GAME.anyRev then
        GAME.anyRev = hasRev

        local W
        W = SCN.scenes.tower.widgetList.stat
        W.fillColor[1], W.fillColor[2] = W.fillColor[2], W.fillColor[1]
        W.textColor[1], W.textColor[2] = W.textColor[2], W.textColor[1]
        W = SCN.scenes.tower.widgetList.achv
        W.fillColor[1], W.fillColor[2] = W.fillColor[2], W.fillColor[1]
        W.textColor[1], W.textColor[2] = W.textColor[2], W.textColor[1]
        W = SCN.scenes.tower.widgetList.conf
        W.fillColor[1], W.fillColor[3] = W.fillColor[3], W.fillColor[1]
        W.textColor[1], W.textColor[3] = W.textColor[3], W.textColor[1]

        if not hasRev then
            GAME.revDeckSkin = false
        end

        local s, e = GAME.revTimer, hasRev and 1 or 0
        local x = (GAME.bgX + 1024) % 2048 - 1024
        TWEEN.new(function(t)
            GAME.bgX = MATH.lerp(x, 0, t)
            t = MATH.lerp(s, e, t)
            GAME.revTimer = t
            TextColor[1] = MATH.lerp(.7, .62, t)
            TextColor[2] = MATH.lerp(.5, .1, t)
            TextColor[3] = MATH.lerp(.3, .1, t)
            ShadeColor[1] = MATH.lerp(.3, .1, t)
            ShadeColor[2] = MATH.lerp(.15, 0, t)
            ShadeColor[3] = MATH.lerp(.0, 0, t)
        end):setUnique('revSwitched'):setDuration(.26):run()

        GAME.updateBgm('revSwitched')
    end
end

function GAME.freshLifeState()
    local oldState = GAME.lifeState
    local hp = GAME[GAME.getLifeKey()]
    local newState
    if hp == GAME.fullHealth then
        newState = 'full'
    else
        local dangerDmg = max(GAME.dmgWrong + GAME.dmgWrongExtra, GAME.dmgTime)
        newState = hp <= dangerDmg and 'danger' or 'safe'
    end
    if oldState ~= newState then
        GAME.lifeState = newState
        if newState == 'danger' then
            SFX.play('hyperalert')
        end
    end
end

function GAME.refreshDailyChallengeText()
    TEXTS.dcBest:set(("%.0fm  %.0fZP"):format(STAT.dailyBest / GAME.getComboZP(DAILY), STAT.dailyBest))
    local sortedDaily = TABLE.copy(DAILY)
    DailyAvailable = true
    for _, v in next, sortedDaily do
        if v:find('r') then
            if GAME.completion[v:sub(2)] == 0 then
                DailyAvailable = false
                break
            end
        else
            if Cards[v].lock then
                DailyAvailable = false
                break
            end
        end
    end
    local str
    if DailyAvailable then
        str = "Today's Combo: " .. table.concat(sortedDaily, " ")
        table.sort(sortedDaily, function(a, b) return ModData.prio_card[a] < ModData.prio_card[b] end)
        local rev = str:match("r%S+")
        if rev and GAME.completion then str = str .. "   (" .. rev .. " = reversed " .. rev:sub(2) .. ")" end
        str = str .. "\nTry to get more ZP in one run using this mod combo.\n(Click to select)"
    else
        str = "Oops! Today's mod combo is not available for you...\nComplete more mods to unlock some content."
    end
    SCN.scenes.tower.widgetList.daily.floatText = str
    SCN.scenes.tower.widgetList.daily:reset()
end

function GAME.swapControl()
    if GAME[GAME.getLifeKey(true)] > 0 then
        GAME.onAlly = not GAME.onAlly
        GAME.freshLifeState()
        return true
    end
end

function GAME.cancelAll(instant)
    if M.NH == 2 then
        if M.AS == 1 then
            GAME.cancelBurn()
            GAME.fault = true
        end
        return
    end
    TASK.removeTask_code(GAME.task_cancelAll)
    TASK.new(GAME.task_cancelAll, instant)
    if GAME.gravTimer then GAME.gravTimer = GAME.gravDelay end
end

function GAME.task_cancelAll(instant)
    local spinMode = not instant and M.AS > 0
    local list = TABLE.copy(CD, 0)
    local needFlip = {}
    for i = 1, #CD do
        needFlip[i] = spinMode or CD[i].active
    end
    for i = 1, #list do
        if needFlip[i] then
            list[i]:setActive(true)
            if M.AS == 1 then
                list[i].burn = false
            end
            if not instant then
                TASK.yieldT(.026)
            end
        end
    end
end

function GAME.commit()
    if #GAME.quests == 0 then return end

    local hand = TABLE.sort(GAME.getHand(false))
    local q1 = TABLE.sort(GAME.quests[1].combo)
    local q2 = M.DP > 0 and TABLE.sort(GAME.quests[2].combo)

    if GAME.currentTask then
        GAME.incrementPrompt('commit')
        GAME.nixPrompt('keep_no_commit')
        for i = 1, 9 do
            local id = ModData.deck[i].id
            if TABLE.find(hand, id) then
                GAME.incrementPrompt('commit_' .. id)
                GAME.incrementPrompt('commit_' .. id .. '_row')
                GAME.nixPrompt('commit_no_' .. id .. '_row')
            else
                GAME.incrementPrompt('commit_no_' .. id .. '_row')
                GAME.nixPrompt('commit_' .. id .. '_row')
            end
        end
        if #hand == 0 then
            GAME.incrementPrompt('commit_0')
            GAME.incrementPrompt('commit_0_row')
        else
            GAME.nixPrompt('commit_0_row')
            if not GAME.faultWrong then
                GAME.incrementPrompt('commit_' .. #hand .. 'card')
            end
        end
        local maxConn = 0
        local conn = 0
        for _, C in ipairs(CD) do
            if C.active then
                conn = conn + 1
                maxConn = max(maxConn, conn)
            else
                conn = 0
            end
        end
        if maxConn >= 2 then
            GAME.incrementPrompt('commit_conn_2')
            if maxConn >= 3 then
                GAME.incrementPrompt('commit_conn_3')
                if maxConn >= 4 then
                    GAME.incrementPrompt('commit_conn_4')
                end
            end
        else
            GAME.incrementPrompt('commit_no_conn')
        end
    end

    local correct, dblCorrect
    if TABLE.equal(hand, q1) then
        correct = 1
        dblCorrect = q2 and TABLE.equal(hand, q2)
    elseif q2 and TABLE.equal(hand, q2) then
        correct = 2
        GAME.incrementPrompt('pass_second')
    end

    if correct then
        if GAME.currentTask then
            GAME.incrementPrompt('pass')
            for i = 1, #hand do GAME.incrementPrompt('pass_' .. hand[i]) end

            if #hand >= 4 then
                GAME.incrementPrompt('pass_windup')
                if #hand >= 5 then
                    GAME.incrementPrompt('pass_windup3')
                end
            end
        end

        GAME.heal((dblCorrect and 3 or 1) * GAME.dmgHeal)

        local dp = TABLE.find(hand, 'DP')
        local attack = 3
        local xp = 0
        if dp and M.EX < 2 then attack = attack + 2 end
        if GAME.fault then
            -- Non-perfect
            if GAME.currentTask then
                GAME.incrementPrompt('pass_imperfect')
                GAME.incrementPrompt('pass_imperfect_row')
                GAME.nixPrompt('pass_perfect_row')
                GAME.nixPrompt('keep_no_imperfect')
                GAME.nixPrompt('pass_windup_inb2b')
            end
            if M.AS == 2 then attack = 0 end
            xp = xp + 2
            if GAME.chain < 4 then
                SFX.play('clearline', .62)
            else
                if GAME.currentTask then
                    if GAME.chain >= 4 and GAME.chain <= 10 and GAME.chain % 2 == 0 then
                        GAME.incrementPrompt('b2b_break_' .. GAME.chain)
                    end
                    if #hand >= 4 then
                        GAME.incrementPrompt('b2b_break_windup')
                        if #hand >= 5 then
                            GAME.incrementPrompt('b2b_break_windup3')
                        end
                    end
                end
                SFX.play('clearline')
                SFX.play(
                    GAME.chain < 8 and 'b2bcharge_blast_1' or
                    GAME.chain < 12 and 'b2bcharge_blast_2' or
                    GAME.chain < 24 and 'b2bcharge_blast_3' or
                    'b2bcharge_blast_4'
                )
                if GAME.chain >= 8 then
                    SFX.play('thunder' .. rnd(6), MATH.clampInterpolate(8, .7, 16, 1, GAME.chain))
                end
                local k = GAME.onAlly and 'life2' or 'life'
                local oldLife = GAME[k]
                while GAME.chain > 0 and GAME[k] < GAME.fullHealth do
                    GAME.chain = max(GAME.chain - 2, 0)
                    GAME[k] = min(GAME[k] + 1, GAME.fullHealth)
                end
                if GAME[k] > oldLife then GAME.incrementPrompt('heal', GAME[k] - oldLife) end
                if GAME.chain > 0 then
                    attack = attack + GAME.chain
                end
            end
            GAME.chain = 0
        else
            -- Perfect
            if GAME.currentTask then
                GAME.incrementPrompt('pass_perfect')
                GAME.incrementPrompt('pass_perfect_row')
                GAME.nixPrompt('pass_imperfect_row')
                GAME.nixPrompt('keep_no_perfect')
                if #hand >= 4 then
                    GAME.incrementPrompt('pass_windup_perfect')
                    if #hand >= 5 then
                        GAME.incrementPrompt('pass_windup3_perfect')
                    end
                    if GAME.chain >= 4 then
                        GAME.incrementPrompt('pass_windup_inb2b')
                    else
                        GAME.nixPrompt('pass_windup_inb2b')
                    end
                end
            end

            SFX.play(MATH.roll(.626) and 'clearspin' or 'clearquad', .5)
            if correct == 1 then
                attack = attack + 1
                if M.AS == 2 and GAME.chain >= 4 then attack = attack + 1 end
                xp = xp + 3
                GAME.chain = GAME.chain + 1
                if GAME.chain < 4 then
                elseif GAME.chain < 8 then
                    if GAME.chain == 4 then SFX.play('b2bcharge_start', .8) end
                    SFX.play('b2bcharge_1', .8)
                elseif GAME.chain < 12 then
                    SFX.play('b2bcharge_2', .8)
                elseif GAME.chain < 24 then
                    SFX.play('b2bcharge_3', .8)
                else
                    SFX.play('b2bcharge_4', .8)
                end
            end

            GAME.totalPerfect = GAME.totalPerfect + (dblCorrect and 2 or 1)
        end
        if dblCorrect then
            attack = attack * 3
            xp = xp * 3
        end
        if GAME.chain >= 4 then
            if GAME.chain == 4 then
                for i = 1, 3 do
                    SparkPS[i]:reset()
                    SparkPS[i]:setEmissionRate(0)
                end
            elseif GAME.chain % 8 == 0 then
                for i = 1, 3 do
                    SparkPS[i]:setEmissionRate(GAME.chain ^ .5 * .42 + rnd() * .5)
                end
            end
            if M.AS < 2 then
                TEXTS.chain:set(tostring(GAME.chain))
            else
                if GAME.chain <= 26 then
                    if GAME.chain == 4 then
                        WoundPS:reset()
                    end
                    local r = MATH.clampInterpolate(4, 26, 26, 62, GAME.chain)
                    WoundPS:setEmissionArea('uniform', r, r, 0, false)
                end
                if GAME.chain % 4 == 0 then
                    if GAME.chain <= 100 then
                        local s = 1 + GAME.chain / 200
                        ---@diagnostic disable-next-line
                        WoundPS:setSizes(0, 1 * s, .9 * s, .8 * s, .7 * s, .6 * s, .42 * s)
                    end
                end
                WoundPS:setEmissionRate(MATH.clampInterpolate(16, 1, 2600, 6.26, GAME.chain ^ 2))
                WoundPS:setLinearDamping(MATH.clampInterpolate(4, 1.2, 42, 0.626, GAME.chain))

                TEXTS.chain2:clear()
                local s = tostring(GAME.chain)
                local i = 0
                if s:sub(1, 1) == '1' then i = i - .35 end
                for c in string.gmatch(s, ".") do
                    i = i + 1
                    TEXTS.chain2:addf(
                        c, 260, 'center',
                        32 * (i - #s / 2 - .5), 0,
                        MATH.rand(-.12, .12), 1.26, 1.26, 129, 26
                    )
                end
            end
        end

        SFX.play(dp and 'zenith_start_duo' or 'zenith_start', .626, 0, 12 + M.GV)

        if M.DP == 2 then
            if GAME.takeDamage(attack / 4, 'wrong', GAME[GAME.getLifeKey(true)] > 0) then return end
        end

        if M.DP > 0 and GAME[GAME.getLifeKey(true)] == 0 then
            xp = xp / 2
            attack = attack / 2
            attack = floor(attack) + (MATH.roll(attack % 1) and 1 or 0)
        end

        GAME.incrementPrompt('send', attack)
        GAME.totalAttack = GAME.totalAttack + attack
        if not GAME.DPlock then
            GAME.addHeight(attack)
            GAME.addXP(attack + xp)
        end

        -- rMS little shuffle
        if M.MS == 2 then
            local r1 = rnd(2, #CD - 1)
            local r2, r3
            repeat r2 = rnd(r1 - 2, r1 + 2) until r2 ~= r1 and MATH.between(r2, 1, #CD)
            if GAME.floor <= 8 then
                CD[r1], CD[r2] = CD[r2], CD[r1]
            else
                repeat r3 = rnd(r1 - 2, r1 + 2) until r3 ~= r1 and r3 ~= r2 and MATH.between(r3, 1, #CD)
                CD[r1], CD[r2], CD[r3] = CD[r2], CD[r3], CD[r1]
            end
            GAME.refreshLayout()
        end

        GAME.cancelAll(true)
        GAME.cancelBurn()
        GAME.dmgTimer = min(GAME.dmgTimer + max(2.6, GAME.dmgDelay / 2), GAME.dmgDelay)

        for i = dblCorrect and 2 or 1, 1, -1 do
            local p = dblCorrect and i or correct
            GAME.genQuest()
            rem(GAME.quests, p)
            local combo = GAME.quests[correct] and GAME.quests[correct].combo or NONE
            if #combo >= 4 then
                local pwr = #combo * 2 - 7
                if TABLE.find(combo, 'DH') then pwr = pwr + 1 end
                SFX.play('garbagewindup_' .. MATH.clamp(pwr, 1, 4), 1, 0, M.GV)
            end
            GAME.questReady()
            GAME.totalQuest = GAME.totalQuest + 1
        end

        if M.DP > 0 and (correct == 2 or dblCorrect) then
            if GAME.swapControl() then
                SFX.play('party_ready', 1, 0, M.GV)
            end
        end

        if GAME.shuffleReady then
            GAME.shuffleCards(GAME.shuffleReady)
            GAME.shuffleReady = false
        end

        return true
    else
        if GAME.currentTask then
            if #hand >= 7 and not TABLE.find(hand, 'DP') then
                GAME.incrementPrompt(#hand == 8 and 'commit_swamp' or 'commit_swamp_l')
            end
            if
                #hand + #q1 == 9 and
                #hand == #TABLE.subtract(TABLE.copy(hand), q1) or
                q2 and #hand + #q2 == 9 and
                #hand == #TABLE.subtract(TABLE.copy(hand), q2)
            then
                GAME.incrementPrompt('commit_reversed')
            end
        end

        GAME.fault = true
        GAME.faultWrong = true

        if GAME.takeDamage(max(GAME.dmgWrong + GAME.dmgWrongExtra, 1), 'wrong') then return end
        GAME.dmgWrongExtra = GAME.dmgWrongExtra + .5

        if M.GV > 0 then GAME.gravTimer = GAME.gravDelay end
        if M.EX > 0 then
            GAME.cancelAll(true)
        elseif M.AS == 1 then
            GAME.cancelBurn()
        end
    end
end

local function task_startSpin()
    for _, C in ipairs(CD) do if C.active then C:setActive(true) end end
    for _, C in ipairs(CD) do
        C.lock = false
        if M.MS == 0 then
            if C.lock then
                C:flick()
            else
                C:spin()
            end
            TASK.yieldT(.01)
        end
    end
    if M.MS > 0 then
        GAME.shuffleCards(M.MS)
    end
end
function GAME.start()
    if TASK.getLock('cannotStart') then
        SFX.play('clutch')
        return
    end
    SCN.scenes.tower.widgetList.help:setVisible(false)
    SCN.scenes.tower.widgetList.help2:setVisible(false)
    SCN.scenes.tower.widgetList.daily:setVisible(false)

    SFX.play('menuconfirm', .8)
    SFX.play(CD.DP.active and 'zenith_start_duo' or 'zenith_start', 1, 0, M.GV)

    GAME.playing = true

    -- Statistics
    GAME.comboStr = table.concat(TABLE.sort(GAME.getHand(true)))
    GAME.prevPB = BEST.highScore[GAME.comboStr]
    if GAME.prevPB == 0 then GAME.prevPB = -260 end
    GAME.totalFlip = 0
    GAME.totalQuest = 0
    GAME.totalPerfect = 0
    GAME.totalAttack = 0
    GAME.heightBonus = 0
    GAME.peakRank = 1
    GAME.rankTimer = TABLE.new(0, 16)

    -- Time
    GAME.time = 0
    GAME.gigaTime = false
    GAME.questTime = 0
    GAME.floorTime = 0

    -- Rank
    GAME.rank = 1
    TEXTS.rank:set("R-1")
    GAME.xp = 0
    GAME.rankupLast = false
    GAME.xpLockLevel = 5
    GAME.xpLockTimer = 0

    -- Floor
    GAME.floor = 0
    GAME.height = 0
    GAME.heightBuffer = 0
    GAME.fatigueSet = Fatigue[M.EX == 2 and 'rEX' or M.DP == 2 and 'rDP' or 'normal']
    GAME.fatigue = 1

    -- Params
    GAME.queueLen = M.NH == 2 and (M.DP == 0 and 1 or 2) or 3
    GAME.maxComboSize = M.DH == 2 and 3 or 4
    GAME.extraComboBase = (M.DH > 0 and .626 or 0) + (M.NH == 2 and M.DH < 2 and -.42 or 0)
    GAME.extraComboVar = (M.DH > 0 and .626 or 1)
    GAME.dmgHeal = 2
    GAME.dmgWrong = 1
    GAME.dmgTime = 2
    GAME.dmgTimeMul = 1
    GAME.dmgDelay = 15
    GAME.dmgCycle = 5

    -- Player
    GAME.life = 20
    GAME.fullHealth = 20
    GAME.dmgTimer = GAME.dmgDelay
    GAME.chain = 0
    GAME.gigaspeed = false
    GAME.gigaspeedEntered = false
    GAME.atkBuffer = 0
    GAME.atkBufferCap = 8 + (M.DH == 1 and M.NH < 2 and 2 or 0)
    GAME.shuffleReady = false

    -- rDP
    GAME.onAlly = false
    GAME.life2 = 20
    GAME.maxRank = 26000
    GAME.reviveCount = 0
    GAME.currentTask = false
    GAME.DPlock = false
    GAME.lastFlip = false
    if M.DP == 2 then
        GAME.maxRank = 8 + 4 * M.EX
        GAME.dmgHeal = 3
    end

    if M.DP > 0 then
        GAME.life = 10
        GAME.life2 = 10
        GAME.fullHealth = 10
    end

    GAME.refreshModIcon()
    TABLE.clear(ComboColor)
    for k, v in next, M do
        if v > 0 then
            local c = TABLE.copy(ModData.color[k])
            c[4] = nil
            ins(ComboColor, c)
        end
    end
    if #ComboColor > 0 then
        TABLE.shuffle(ComboColor)
        ins(ComboColor, TABLE.copy(ComboColor[1]))
        TABLE.transpose(ComboColor)
    end

    GAME.upFloor()

    TABLE.clear(GAME.quests)
    for _ = 1, GAME.queueLen do GAME.genQuest() end
    GAME.questReady()

    TASK.removeTask_code(task_startSpin)
    TASK.new(task_startSpin)

    TWEEN.new(GAME.anim_setMenuHide):setDuration(.26):setUnique('uiHide'):run()
    GAME.updateBgm('start')
end

---@param reason 'forfeit' | 'wrong' | 'time'
function GAME.finish(reason)
    SCN.scenes.tower.widgetList.help:setVisible(not GAME.zenithTraveler)
    SCN.scenes.tower.widgetList.help2:setVisible(not GAME.zenithTraveler)
    SCN.scenes.tower.widgetList.daily:setVisible(not GAME.zenithTraveler)
    MSG.clear()

    SFX.play(
        reason == 'forfeit' and 'detonated' or
        reason == 'wrong' and 'topout' or
        reason == 'time' and 'losestock' or
        'shatter', .8
    )

    GAME.sortCards()
    for _, C in ipairs(CD) do
        if (M[C.id] > 0) ~= C.active then
            C:setActive(true)
        end
        C.touchCount = 0
        C.isCorrect = false
        C.burn = false
        C.charge = 0
    end
    FloatOnCard = false
    GAME.refreshLayout()

    GAME.playing = false
    GAME.life, GAME.life2 = 0, 0
    GAME.currentTask = false

    local unlockDuo
    if GAME.totalQuest > 2.6 then
        if GAME.floor >= 10 then
            local unlockRev
            for k, v in next, M do
                if v > GAME.completion[k] then
                    if GAME.completion[k] == 0 then
                        if k == 'DP' then
                            unlockDuo = true
                        else
                            unlockRev = true
                        end
                    end
                    GAME.completion[k] = v
                end
            end
            if unlockRev then
                MSG.clear()
                MSG('dark', "You’ve unlocked a new REVERSED MOD!\nActivate it by right-clicking on a card that has a star on it.", 6.26)
                SFX.play('notify')
            end
        end

        -- Statistics
        STAT.maxFloor = max(STAT.maxFloor, GAME.floor)
        if GAME.height > STAT.maxHeight then
            STAT.maxHeight = MATH.roundUnit(GAME.height, .01)
            STAT.heightDate = os.date("%y.%m.%d %H:%M%p")
        end
        STAT.totalGame = STAT.totalGame + 1
        STAT.totalTime = MATH.roundUnit(STAT.totalTime + GAME.time, .001)
        STAT.totalFlip = STAT.totalFlip + GAME.totalFlip
        STAT.totalQuest = STAT.totalQuest + GAME.totalQuest
        STAT.totalPerfect = STAT.totalPerfect + GAME.totalPerfect
        STAT.totalAttack = STAT.totalAttack + GAME.totalAttack
        STAT.totalHeight = MATH.roundUnit(STAT.totalHeight + GAME.height, .01)
        STAT.totalBonus = MATH.roundUnit(STAT.totalBonus + GAME.heightBonus, .01)
        STAT.totalFloor = STAT.totalFloor + (GAME.floor - 1)
        if GAME.gigaspeedEntered then STAT.totalGiga = STAT.totalGiga + 1 end
        if GAME.floor >= 10 then STAT.totalF10 = STAT.totalF10 + 1 end

        local oldZP, zpGain = STAT.zp, GAME.height * GAME.comboZP
        if DailyActived then
            STAT.dzp = max(STAT.dzp, zpGain)
            STAT.dailyBest = max(STAT.dailyBest, zpGain)
            -- TODO: send to online leaderboard
        end
        STAT.zp = max(
            STAT.zp,
            STAT.zp < zpGain * 16 and min(STAT.zp + zpGain, zpGain * 16) or
            zpGain * 16 + (STAT.zp - zpGain * 16) * (9 / 10) + (zpGain * 10) * (1 / 10)
        )
        if DailyActived then STAT.zp = MATH.clamp(STAT.zp + (STAT.zp - oldZP) * 1.6, STAT.zp, 50 * zpGain) end
        TEXTS.zpChange:set(("%.0f ZP  (+%.0f%s)"):format(zpGain, 0, DailyActived and ", 260%" or ""))
        local zpEarn = STAT.zp - oldZP
        if zpEarn > 0 then
            TASK.new(function()
                TASK.yieldT(0.626)
                TWEEN.new(function(t)
                    TEXTS.zpChange:set(("%.0f ZP  (+%.0f%s)"):format(zpGain, zpEarn * t, DailyActived and ", 260%" or ""))
                end):setEase('InOutCubic'):setDuration(2):run()
                SFX.play('ratingraise', zpEarn ^ .5 / 60)
            end)
        end
        SaveStat()

        -- Best
        local oldPB = BEST.highScore[GAME.comboStr]
        if GAME.height > oldPB then
            BEST.highScore[GAME.comboStr] = MATH.roundUnit(GAME.height, .01)
            local modCount = #GAME.getHand(true)
            if modCount > 0 and oldPB < Floors[9].top and GAME.floor >= 10 then
                local t = modCount == 1 and "MOD MASTERED" or "COMBO MASTERED"
                if GAME.anyRev then t = t:gsub(" ", "+ ", 1) end
                TEXT:add {
                    text = t,
                    x = 800, y = 226, k = 2.26, fontSize = 70,
                    style = 'beat', inPoint = .26, outPoint = .62,
                    color = 'lC', duration = 6.2,
                }
                SFX.play('worldrecord', 1, 0, (modCount == 1 and -1 or 0) + M.GV)
            elseif GAME.floor >= 2 then
                TEXT:add {
                    text = "PERSONAL BEST",
                    x = 800, y = 226, k = 2.6, fontSize = 70,
                    style = 'beat', inPoint = .26, outPoint = .62,
                    color = 'lY', duration = 6.2,
                }
                SFX.play('personalbest', 1, 0, -.1 + M.GV)
            end
            SFX.play('applause', GAME.floor / 10)
            SaveBest()
        end

        TEXTS.endHeight:set(("%.1fm"):format(GAME.height))
        if GAME.gigaspeedEntered then
            local s = ("F$1: $2"):repD(GAME.floor, Floors[GAME.floor].name)
            if GAME.gigaTime then s = s .. "   in " .. STRING.time_simp(GAME.gigaTime) end
            local l = s:atomize()
            local len = #l
            for i = len, 1, -1 do ins(l, i, { COLOR.HSV(MATH.lerp(.026, .626, i / len), GAME.gigaTime and .6 or .2, 1) }) end
            TEXTS.endFloor:set(l)
        else
            TEXTS.endFloor:set("F" .. GAME.floor .. ": " .. Floors[GAME.floor].name)
        end

        local maxCSP = {}
        for i = 1, #GAME.rankTimer do ins(maxCSP, { i < 16 and i or "16+", GAME.rankTimer[i] }) end
        table.sort(maxCSP, function(a, b) return a[2] > b[2] end)
        TEXTS.endResult:set({
            COLOR.L, "Time  " .. STRING.time_simp(GAME.time),
            COLOR.LD, GAME.gigaTime and "  (F10 " .. STRING.time_simp(GAME.gigaTime) .. ")\n" or "\n",
            COLOR.L, "Flip  " .. GAME.totalFlip,
            COLOR.LD, "  (" .. MATH.roundUnit(GAME.totalFlip / GAME.time, .01) .. "/s)\n",
            COLOR.L, "Quest  " .. GAME.totalQuest,
            COLOR.LD, "  (" .. MATH.roundUnit(GAME.totalQuest / GAME.time, .01) .. "/s  ",
            MATH.roundUnit(GAME.totalPerfect / GAME.totalQuest * 100, .1) .. "% Perf)\n",
            COLOR.L, "Speed  " .. MATH.roundUnit(GAME.height / GAME.time, .1) .. "m/s",
            COLOR.LD, "  (",
            MATH.roundUnit(maxCSP[1][2], .1) .. "s@" .. maxCSP[1][1], ", ",
            MATH.roundUnit(maxCSP[2][2], .1) .. "s@" .. maxCSP[2][1], ")\n",
            COLOR.L, "Attack  " .. GAME.totalAttack,
            COLOR.LD, "  (" .. MATH.roundUnit(GAME.totalAttack / GAME.totalQuest, .01) .. " eff)\n",
            COLOR.L, "Bonus  " .. MATH.roundUnit(GAME.heightBonus, .1) .. "m",
            COLOR.LD, "  (" .. MATH.roundUnit(GAME.heightBonus / GAME.height * 100, .1) .. "%)\n",
        })
        GAME.refreshResultModIcon()
    else
        TEXTS.endHeight:set("")
        TEXTS.endFloor:set("")
        TEXTS.endResult:set("")
        TEXTS.zpChange:set("")
        GAME.resIB:clear()
    end

    GAME.setGigaspeedAnim(false)
    TASK.removeTask_code(task_startSpin)
    GAME.refreshLockState()
    GAME.refreshCurrentCombo()
    GAME.refreshPBText()
    TASK.unlock('dcTimer')
    GAME.refreshDailyChallengeText()

    if unlockDuo then
        CD.DP.lock = true
        TASK.new(function()
            TASK.yieldT(0.42)
            CD.DP.lock = false
            CD.DP:spin()
            CD.DP:bounce(1200, .62)
            SFX.play('supporter')
        end)
    end

    TWEEN.new(GAME.anim_setMenuHide_rev):setDuration(.26):setUnique('uiHide'):run()
    GAME.refreshRPC()
    GAME.updateBgm('finish')
    if reason ~= 'forfeit' then
        TASK.lock('cannotStart', 1)
        TASK.lock('cannotFlip', .626)
    end
end

function GAME.update(dt)
    if GAME.playing then
        -- if love.keyboard.isDown('[') then
        --     GAME.addHeight(dt * 260)
        -- elseif love.keyboard.isDown(']') then
        --     GAME.addXP(dt * 42)
        -- end

        GAME.time = GAME.time + dt

        local r = min(GAME.rank, 16)
        GAME.rankTimer[r] = GAME.rankTimer[r] + dt

        if GAME.gigaspeed then
            TEXTS.gigatime:set(("%02d:%02d.%03d"):format(
                floor(GAME.time / 60),
                floor(GAME.time % 60),
                GAME.time % 1 * 1000)
            )
        end

        local t = GAME.currentTask
        if t and t.prompt:sub(1, 5) == 'keep_' then
            if t.prompt:sub(6, 12) == 'health_' then
                if t.prompt:sub(13) == GAME.lifeState then
                    GAME.incrementPrompt(t.prompt, dt)
                else
                    GAME.nixPrompt(t.prompt)
                end
            else
                GAME.incrementPrompt(t.prompt, dt)
            end
        end

        GAME.questTime = GAME.questTime + dt
        GAME.floorTime = GAME.floorTime + dt
        if M.GV > 0 and not GAME.gravTimer and GAME.questTime >= 2.6 and GAME.questTime - dt < 2.6 then
            GAME.gravTimer = GAME.gravDelay
        end
        if M.EX == 2 and GAME.floorTime > 30 then
            GAME.dmgWrong = GAME.dmgWrong + 0.05 * dt
        end
        local stage = GAME.fatigueSet[GAME.fatigue]
        if GAME.time >= stage.time then
            local e = stage.event
            for i = 1, #e, 2 do
                GAME[e[i]] = GAME[e[i]] + e[i + 1]
            end
            if GAME.floor >= 10 then GAME.updateBgm('ingame') end
            GAME.fatigue = GAME.fatigue + 1
            local duration = 5
            if M.DP == 2 or GAME.fatigue == #GAME.fatigueSet then
                duration = duration * 2
            end
            TEXT:add {
                text = stage.text,
                x = 800, y = 265, fontSize = 30, k = 1.5,
                style = 'score', duration = duration,
                inPoint = .1, outPoint = .26,
                color = stage.color or 'lM',
            }
            TEXT:add {
                text = stage.desc,
                x = 800, y = 300, fontSize = 30,
                style = 'score', duration = duration,
                inPoint = .26, outPoint = .1,
                color = stage.color or 'lM',
            }
            TASK.new(GAME.task_fatigueWarn)
        end

        if not GAME.DPlock then
            local releaseHeight = GAME.heightBuffer
            GAME.heightBuffer = max(MATH.expApproach(GAME.heightBuffer, 0, dt * 6.3216), GAME.heightBuffer - 600 * dt)
            releaseHeight = releaseHeight - GAME.heightBuffer

            GAME.height = GAME.height + releaseHeight
            if M.EX < 2 then
                GAME.height = GAME.height + GAME.rank / 4 * dt * MATH.icLerp(1, 6, Floors[GAME.floor].top - GAME.height)
            else
                GAME.height = max(
                    GAME.height - dt * (GAME.floor * (GAME.floor + 1) + 10) / 20,
                    Floors[GAME.floor - 1].top
                )
            end

            if GAME.height >= Floors[GAME.floor].top then
                GAME.upFloor()
            end

            if GAME.xpLockTimer > 0 then
                GAME.xpLockTimer = GAME.xpLockTimer - dt
            else
                GAME.xp = GAME.xp - dt * (M.EX > 0 and 5 or 3) * GAME.rank * (GAME.rank + 1) / 60
                if GAME.xp <= 0 then
                    GAME.xp = 0
                    if GAME.rank > 1 then
                        GAME.rank = GAME.rank - 1
                        GAME.xp = 4 * GAME.rank
                        GAME.rankupLast = false
                        if GAME.gigaspeed and GAME.rank < GigaSpeedReq[0] then
                            GAME.setGigaspeedAnim(false)
                            SFX.play('zenith_speedrun_end')
                            SFX.play('zenith_speedrun_end')
                        end
                        TEXTS.rank:set("R-" .. GAME.rank)
                        SFX.play('speed_down', .4 + GAME.xpLockLevel / 10)
                    end
                end
            end
        end

        GAME.dmgTimer = GAME.dmgTimer - dt / GAME.dmgTimeMul
        if GAME.dmgTimer <= 0 then
            GAME.dmgTimer = GAME.dmgCycle
            GAME.takeDamage(GAME.dmgTime, 'time')
        end

        if GAME.gravTimer then
            GAME.gravTimer = GAME.gravTimer - dt
            if GAME.gravTimer <= 0 then
                GAME.faultWrong = false
                GAME.commit()
            end
        end
    end
end

return GAME
