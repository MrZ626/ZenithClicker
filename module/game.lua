local max, min = math.max, math.min
local floor, ceil = math.floor, math.ceil
local abs, rnd = math.abs, math.random
local roundUnit = MATH.roundUnit
local expApproach = MATH.expApproach
local lerp, cLerp, icLerp = MATH.lerp, MATH.cLerp, MATH.icLerp
local clamp = MATH.clamp
local lLerp = MATH.lLerp
local clampInterpolate = MATH.clampInterpolate

local ins, rem = table.insert, table.remove

---@class Question
---@field combo string[]
---@field name love.Text
---@field y number
---@field k number
---@field a number

---@class ReviveTask:Prompt
---@field progress number
---@field textObj love.Text
---@field shortObj love.Text
---@field progObj love.Text

---@class Game
---@field playing boolean
---@field finishTime number
---
---@field prevPB number
---@field comboStr string
---@field totalFlip number
---@field totalQuest number
---@field totalPerfect number
---@field totalAttack number
---@field totalSurge number
---@field heightBonus number
---@field peakRank number
---@field rankTimer number[]
---
---@field time number
---@field gigaTime false | number
---@field questTime number
---@field floorTime number
---@field reviveTime false | number
---@field secTime number[]
---
---@field rank number
---@field xp number
---@field rankupLast boolean
---@field xpLockLevel number
---@field xpLockTimer number
---
---@field floor number
---@field height number
---@field roundHeight number for statistics and achievement
---@field heightBuffer number
---@field fatigueSet {time:number, event:table, text:string, desc:string, color?:string, duration?:number, final?:true}[]
---@field fatigue number
---@field animDuration number
---
---@field maxQuestCount number
---@field maxQuestSize number
---@field extraQuestBase number
---@field extraQuestVar number
---@field questFavor number Higher questFavor will result in mods generated consecutively more often, in design
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
---@field gigaspeedEntered false | number time when enter
---@field gigaCount number
---@field teraCount number
---@field teramusic boolean
---@field atkBuffer number
---@field atkBufferCap number
---@field shuffleMessiness number | false
---@field lastCommit string[]
---
---@field spikeTimer number
---@field spikeCounter number
---@field spikeCounterWeak number
---@field maxSpike number
---@field maxSpikeWeak number
---
---@field gravDelay false | number
---@field gravTimer false | number
---
---@field omega boolean
---@field negFloor number
---@field negEvent number
---@field timerMul number
---@field attackMul number
---@field xpLockLevelMax number
---@field leakSpeed number
---@field invincible boolean
---
---@field onAlly boolean
---@field life2 number
---@field rankLimit number
---@field reviveCount number
---@field reviveDifficulty number
---@field killCount number
---@field quests Question[]
---@field reviveTasks ReviveTask[]
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
    isUltraRun = false,

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

    quests = {},
    reviveTasks = {},
    currentTask = false,
    lastFlip = false,
    switch_sickness = 0,
    hasseenDPnerf = false,
    gigaspeedFloor = {},
    teraspeedFloor = {},

    zenithTraveler = false,
    nightcore = false,
    slowmo = false,
    glassCard = false,
    closeCard = false,
    fastLeak = false,
    invisCard = false,
    invisUI = false,

    achv_perfectH = nil,
    achv_demoteH = nil,
    achv_carriedH = nil,
    achv_noPerfectH = nil,
    achv_noChargeH = nil,
    achv_noManualCommitH = nil,
    achv_noDamageH = nil,
    achv_noKeyboardH = nil,
    achv_shareModH = nil,
    achv_noShareModH = nil,
    achv_protectH = nil,
    achv_maxChain = nil,
    achv_maxReviveH = nil,
    achv_totalDmg = nil,
    achv_clutchQuest = nil,
    achv_escapeBurnt = nil,
    achv_escapeQuest = nil,
    achv_felMagicBurnt = nil,
    achv_felMagicQuest = nil,
    achv_resetCount = nil,
    achv_noResetH = nil,
    achv_obliviousQuest = nil,
    achv_doublePass = nil,
    achv_level19capH = nil,
    achv_totalResetCount = nil,
    achv_altFromSurge = nil,
}

GAME.playing = false
GAME.finishTime = -2600
GAME.fullHealth = 20
GAME.life = 0
GAME.life2 = 0
GAME.time = 0
GAME.spikeCounter = 0
GAME.spikeTimer = 0
GAME.floorTime = 0
GAME.reviveTime = false
GAME.floor = 1
GAME.rank = 1
GAME.xp = 0
GAME.height = 0
GAME.chain = 0

local M = GAME.mod
local MD = ModData
local CD = Cards

---Unsorted, like {'rEX','NH',...}
---@param real boolean current mod setting or literally selected cards
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
        -- for i = 1, #MD.deck do
        --     local D = MD.deck[i]
        --     local level = M[D.id]
        --     if level == 1 then
        --         ins(list, D.id)
        --     elseif level == 2 then
        --         ins(list, 'r' .. D.id)
        --     end
        -- end
    else
        -- FASTER
        for i = 1, #MD.deck do
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
    if m.NH then zp = zp * 1.1 elseif m.rNH then zp = zp * 1.8 end
    if m.MS then zp = zp * 1.2 elseif m.rMS then zp = zp * (m.rGV and 2.0 or 1.7) end
    if m.GV then zp = zp * 1.1 elseif m.rGV then zp = zp * (1.2 + .02 * (#list - 1)) end
    if m.VL then zp = zp * 1.1 elseif m.rVL then zp = zp * (1.2 + .02 * (#list - 1)) end
    if m.DH then zp = zp * 1.2 elseif m.rDH then zp = zp * (m.rIN and 2.0 or 1.6) end
    if m.IN then zp = zp * 1.2 elseif m.rIN then zp = zp * 1.6 end
    if m.AS then zp = zp * .85 elseif m.rAS then zp = zp * 1.1 end
    if m.DP then zp = zp * .95 elseif m.rDP then zp = zp * (m.rEX and 1.8 or 2.1) end

    local hardCnt = table.concat(list):count('r')
    if m.EX then hardCnt = hardCnt + 1 end
    if hardCnt >= 2 then zp = zp * 0.99 ^ (hardCnt - 1) end
    if zp > 100 then zp = 100 end -- 101.22x if not capped

    return zp
end

local function modNameSorter(a, b) return MD.prio_name[a] < MD.prio_name[b] end
local function modCardSorter(a, b) return MD.prio_card[a] < MD.prio_card[b] end
local function trimR(s) return s:sub(2) end

---@param list string[] WILL BE SORTED!!!
---@param mode? 'ingame' | 'button' | 'rpc' | 'record'
function GAME.getComboName(list, mode)
    local len = #list
    if mode == 'ingame' then
        -- Empty
        if len == 0 then return {} end

        local fstr = {}

        -- Super Set
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

        -- Named Combo
        local combo = (M.DH == 2 and ComboData.gameEX or ComboData.game)[table.concat(TABLE.sort(list), ' ')]
        if combo then
            fstr = combo.name:atomize()
            if URM and M.DH == 2 then
                -- Shuffle letters except first and last
                rem(fstr, #fstr)
                local e = rem(fstr)
                rem(fstr, 1)
                local s = rem(fstr, 1)
                TABLE.shuffle(fstr)
                ins(fstr, 1, s)
                ins(fstr, 1, "\"")
                ins(fstr, e)
                ins(fstr, "\"")
            end
            -- Random gray
            for i = #fstr, 1, -1 do
                ins(fstr, i, { MATH.rand(.872, 1), MATH.rand(.872, 1), MATH.rand(.872, 1) })
            end
            if M.IN == 0 then
                local colors = {}
                for i = 1, #list do ins(colors, MD.color[list[i]]) end
                if #colors == 1 then
                    -- Single color
                    for i = 1, #fstr, 2 do
                        local org = fstr[i]
                        org[1] = expApproach(org[1], colors[1][1], .5)
                        org[2] = expApproach(org[2], colors[1][2], .5)
                        org[3] = expApproach(org[3], colors[1][3], .5)
                    end
                else
                    -- Multiple colors
                    colors = TABLE.transposeNew(TABLE.shuffle(colors))
                    local colorCnt = #colors[1]
                    local keep = clamp(#fstr / colorCnt * .05, .2, .6)
                    for i = 1, #fstr, 2 do
                        local org = fstr[i]
                        -- Attracted to closest color
                        local t = (i - 2) / (#fstr - 4) * (colorCnt - 1)
                        t = (t * keep + floor(t + .5) * (1 - keep)) / (colorCnt - 1)
                        org[1] = expApproach(org[1], lLerp(colors[1], t), .5)
                        org[2] = expApproach(org[2], lLerp(colors[2], t), .5)
                        org[3] = expApproach(org[3], lLerp(colors[3], t), .5)
                    end
                end
            end
            return fstr
        end

        -- Sort & Shuffle
        if M.DH == 2 then
            TABLE.shuffle(list)
        else
            table.sort(list, modNameSorter)
            if M.DH == 1 and MATH.roll((#list - 1) / 6.26) then
                local r1, r2 = rnd(#list), rnd(#list - 1)
                if r2 >= r1 then r2 = r2 + 1 end
                list[r1], list[r2] = list[r2], list[r1]
            end
        end

        -- General
        for i = 1, len - 1 do
            ins(fstr, MD.textColor[list[i]])
            ins(fstr, MD.adj[list[i]] .. " ")
        end
        ins(fstr, MD.textColor[list[len]])
        ins(fstr, MD.noun[list[len]])
        if M.IN > 0 then
            local r = rnd(0, 3)
            for i = 1, #fstr, 2 do
                r =
                    r == 0 and rnd(2, 3) or
                    r == 1 and 3 or
                    r == 2 and 0 or rnd(0, 1)
                fstr[i] = { 1, 1, 1, .6 + .13 * r }
            end
        elseif URM and M.NH == 2 then
            for i = 1, #fstr, 2 do
                fstr[i] = TABLE.copy(fstr[i])
                for j = 1, 3 do
                    fstr[i][j] = fstr[i][j] * .62 + .26
                end
            end
        end

        if URM and M.DH == 2 then
            for i = 1, #fstr do
                if type(fstr[i]) == 'string' then
                    fstr[i] = table.concat(TABLE.shuffle(fstr[i]:atomize()))
                end
            end
        end

        return fstr
    else
        -- Empty
        if len == 0 then return "" end

        -- Super Set
        if mode == 'button' and GAME.playing then
            local len_noDP = len - (TABLE.find(list, 'DP') and 1 or 0)
            if len_noDP >= 7 then
                return len_noDP == 7 and [["SWAMP WATER LITE"]] or [["SWAMP WATER"]]
            end
        else
            local cmbID = table.concat(list)
            if cmbID:count('r') >= 2 then
                local mp = GAME.getComboMP(list)
                if mp >= 8 then return RevSwampName[min(mp, #RevSwampName)] end
            else
                local len_noDP = len - (TABLE.find(list, 'DP') and 1 or 0)
                if len_noDP >= 7 then
                    return
                        cmbID:find('r') and (
                            len_noDP == 7 and [["AMBROSIA SODA"]] or
                            len_noDP == 8 and [["AMBROSIA WINE"]] or
                            [["AMBROSIA MOONSHINE"]]
                        ) or (
                            len_noDP == 7 and [["SWAMP WATER LITE"]] or
                            len_noDP == 8 and [["SWAMP WATER"]] or
                            [["SWAMP WATER PRO"]]
                        )
                end
            end
        end

        -- Named Combo
        local combo
        local cmbStr = table.concat(TABLE.sort(list), ' ')
        if mode == 'record' then
            combo =
                ComboData.menu[cmbStr] or
                M.DH == 2 and ComboData.gameEX[cmbStr]
            if combo then return combo.name end
            if M.DH == 2 and cmbStr:count('r') == #list then
                if #list == 1 then
                    combo = ComboData.gameEX[cmbStr]
                else
                    local cmbStrNoRev = table.concat(TABLE.sort(TABLE.applyeach(TABLE.copy(list), trimR)), ' ')
                    combo = ComboData.gameEX[cmbStrNoRev]
                end
            end
            if combo then return combo.name:sub(1, -2) .. "+" .. '"' end
        else
            combo = (
                (mode == 'rpc' or not GAME.playing) and ComboData.menu or
                M.DH == 2 and ComboData.gameEX or
                ComboData.game
            )[cmbStr]
            if combo then return combo.name end
        end

        -- General
        table.sort(list, modNameSorter)
        local str = ""
        for i = 1, len - 1 do str = str .. MD.adj[list[i]] .. " " end
        return str .. MD.noun[list[len]]
    end
end

function GAME.anim_setMenuHide(t)
    GAME.uiHide = t
    local w = SCN.scenes.tower.widgetList
    ---@cast w -nil
    w.stat.x = cLerp(60, -90, t * 1.5 - .5)
    w.stat:resetPos()
    w.achv.x = cLerp(60, -90, t * 1.5)
    w.achv:resetPos()
    w.conf.x = cLerp(-60, 90, t * 1.5 - .5)
    w.conf:resetPos()
    w.about.x = cLerp(-60, 90, t * 1.5)
    w.about:resetPos()
    MSG.setSafeY(75 * (1 - GAME.uiHide))
end

function GAME.anim_setMenuHide_finish()
    TEXTS.floorTime:set("")
end

function GAME.anim_setMenuHide_rev(t)
    GAME.anim_setMenuHide(1 - t)
end

local floorHeights = {}
for i = 0, 9 do ins(floorHeights, Floors[i].top) end
function GAME.calculateFloor(h)
    return floor(1 + 9 * MATH.ilLerp(floorHeights, h))
end

function GAME.task_gigaspeed()
    TWEEN.new(function(t) GigaSpeed.textTimer = 1 - 2 * t end):setEase('Linear'):setDuration(2.6):run()
        :setOnFinish(function() GigaSpeed.textTimer = false end)
end

function GAME.task_fatigueWarn()
    for _ = 1, 3 do
        for _ = 1, M.DP == 2 and 2 or 3 do SFX.play('warning', 1) end
        TASK.yieldT(1)
    end
end

function GAME.cancelBurn()
    for i = 1, #CD do CD[i].burn = false end
end

function GAME.sortCards()
    table.sort(CD, function(a, b) return a.initOrder < b.initOrder end)
    for _, C in ipairs(CD) do C.tempOrder = C.initOrder end
end

local shuffleSets = {
    [0] = { { 2, 3 }, { 4, 5 }, { 5, 6 }, { 7, 8 }, pop = 3 },
    { { 1, 2 },    { 3, 4 },    { 6, 7 },    { 8, 9 },    pop = 2 },
    { { 1, 2 },    { 3, 4 },    { 6, 7 },    { 8, 9 },    pop = 1 },
    { { 1, 3 },    { 2, 4 },    { 6, 8 },    { 7, 9 },    pop = 1 },
    { { 1, 2, 3 }, { 7, 8, 9 }, { 5, 6, 7 }, { 3, 4, 5 }, pop = 0 },
}
function GAME.weakShuffleCards(phase)
    local sets = TABLE.copyAll(shuffleSets[phase] or shuffleSets[4])
    for _ = 1, sets.pop do
        TABLE.popRandom(sets)
    end

    for i = 1, #sets do
        local a, b = TABLE.popRandom(sets[i]), TABLE.popRandom(sets[i])
        CD[a].tempOrder, CD[b].tempOrder = CD[b].tempOrder, CD[a].tempOrder
    end
    table.sort(CD, function(a, b) return a.tempOrder < b.tempOrder end)
    GAME.refreshLayout()
end

function GAME.shuffleCards(messiness)
    local order = {}
    for i = 1, #CD do order[i] = i end

    repeat
        for _ = 1, 3 do
            local p = rnd(#CD - 1)
            order[p], order[p + 1] = order[p + 1], order[p]
        end

        local totalDist = 0
        for i = 1, #order do
            CD[i].tempOrder = order[i]
            totalDist = totalDist + abs(order[i] - CD[i].initOrder) ^ 1.6
        end
    until totalDist >= messiness
    table.sort(CD, function(a, b) return a.tempOrder < b.tempOrder end)

    GAME.refreshLayout()
end

function GAME.genQuest()
    local combo = {}
    local base = .72 + GAME.floor ^ .5 / 6 + GAME.extraQuestBase + icLerp(6200, 10000, GAME.height)
    local var = GAME.floor * .26 * GAME.extraQuestVar
    local r = MATH.clamp(base + var * abs(MATH.randNorm()), 1, GAME.maxQuestSize)

    GAME.atkBuffer = GAME.atkBuffer + r
    if GAME.atkBuffer > GAME.atkBufferCap then
        r = r - (GAME.atkBuffer - GAME.atkBufferCap)
        GAME.atkBuffer = GAME.atkBufferCap
    end
    GAME.atkBuffer = clamp(GAME.atkBuffer - (max(GAME.floor / 3, GAME.atkBufferCap / 4) + MATH.rand(-.62, .62)), 0, GAME.atkBufferCap)
    if M.DP > 0 then r = r * (GAME[GAME.getLifeKey(true)] == 0 and 1.26 or 1.1) end

    local pool = TABLE.copyAll(MD.weight)

    local lastQ = GAME.quests[#GAME.quests]
    if lastQ then
        -- Prevent 100% repeating
        pool[lastQ.combo[1]] = 0
        if M.NH == 2 then
            -- More probability to repeat last quest's mods on rNH
            for i = 2, #lastQ.combo do
                pool[lastQ.combo[i]] = pool[lastQ.combo[i]] * 3.5
            end
        end
    end
    local questCount = MATH.clamp(MATH.roundRnd(r), 1, GAME.maxQuestSize)
    if questCount == 1 then
        -- Prevent 1-mod quest being DP
        pool.DP = 0
    elseif M.DH == 2 then
        -- Reduce DP on rDH
        pool.DP = pool.DP * .5
    end
    for _ = 1, questCount do
        local mod = MATH.randFreqAll(pool)
        pool[mod] = 0
        local p = TABLE.find(CD, CD[mod])
        if p then
            if p > 1 then
                local left = CD[p - 1].id
                pool[left] = max(pool[left] * (1 - GAME.questFavor * .01), 0)
            end
            if p < 9 then
                local right = CD[p + 1].id
                pool[right] = max(pool[right] * (1 - GAME.questFavor * .01), 0)
            end
        end

        ins(combo, mod)
    end

    ins(GAME.quests, {
        combo = combo,
        name = GC.newText(FONT.get(70), GAME.getComboName(TABLE.copy(combo), 'ingame')),
        y = -100,
        k = .5,
        a = 0,
    })
end

function GAME.questReady()
    GAME.questTime = 0
    GAME.fault = false
    GAME.faultWrong = false
    GAME.dmgWrongExtra = 0
    GAME.gravTimer = false
    GAME.achv_resetCount = 0
    for _, C in ipairs(CD) do C.touchCount, C.required, C.required2 = 0, false, false end
    for _, v in next, GAME.quests[1].combo do CD[v].required = true end
    if M.DP > 0 and GAME.quests[2] then for _, v in next, GAME.quests[2].combo do CD[v].required2 = true end end
end

function GAME.startRevive()
    TABLE.foreach(GAME.reviveTasks, function(t)
        t.textObj:release()
        t.shortObj:release()
        t.progObj:release()
    end)
    TABLE.clear(GAME.reviveTasks)
    if GAME.reviveDifficulty < 9999 then
        local power = min(GAME.floor + GAME.reviveDifficulty, 17)
        local maxOut = power == 17
        local powerList = TABLE.new(floor(power / 3), 3)
        if power % 3 == 1 then
            local r = rnd(3)
            powerList[r] = powerList[r] + 1
        elseif power % 3 == 2 then
            powerList[1] = powerList[1] + 1
            powerList[2] = powerList[2] + 1
            powerList[3] = powerList[3] + 1
            local r = power == maxOut and 2 or rnd(3)
            powerList[r] = powerList[r] - 1
        end
        TABLE.delete(powerList, 0)

        for _, pow in next, powerList do
            local options = {} ---@type Prompt[]
            for _, opt in next, RevivePrompts do
                if opt.rank[1] <= pow and pow <= opt.rank[2] and (not opt.cond or opt.cond()) then
                    local repeated
                    for _, t in next, GAME.reviveTasks do
                        if t._prompt == opt._prompt then
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
    GAME.reviveTime = 0
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
                GAME.reviveDifficulty = GAME.reviveDifficulty + 1
                GAME[GAME.getLifeKey(true)] = GAME.fullHealth
                SFX.play('boardlock_revive')
                GAME.DPlock = false
                GAME.reviveTime = false
                GAME.switch_sickness = 0
                GAME.achv_maxReviveH = max(GAME.achv_maxReviveH or 0, GAME.roundHeight)
                if GAME.fatigueSet == Fatigue.rDP and GAME.fatigue > 19 then IssueAchv('benevolent_ambition') end
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
    hp = MATH.clamp(hp, 0, GAME.fullHealth - GAME[k])
    GAME[k] = GAME[k] + hp
    GAME.incrementPrompt('heal', hp)

    GAME.refreshLifeState()
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
        dmg <= 2600 and 'damage_large' or
        'bombdetonate', .872
    )

    GAME.achv_totalDmg = GAME.achv_totalDmg + dmg
    if not GAME.achv_perfectH then
        GAME.achv_perfectH = GAME.roundHeight
        if GAME.totalQuest >= 26 then SFX.play('btb_break') end
    end
    if not GAME.achv_noDamageH then
        GAME.achv_noDamageH = GAME.roundHeight
        if GAME.totalQuest >= 26 then SFX.play('btb_break') end
    end
    if not GAME.achv_protectH and GAME.comboStr == 'rDP' and min(GAME.life, GAME.life2) < 10 then
        GAME.achv_protectH = GAME.roundHeight
        if GAME.totalQuest >= 26 then SFX.play('btb_break') end
    end

    if GAME[k] <= .01 then -- Prevent float number precision error
        GAME[k] = 0
        if GAME.invincible then
            GAME[k] = 0.26
        elseif GAME[GAME.getLifeKey(not toAlly)] > 0 then
            if toAlly then
                SFX.play('elim')
                GAME.killCount = GAME.killCount + 1
            else
                GAME.swapControl()
            end
            GAME.startRevive()
            GAME.dmgWrongExtra = 0 -- Being tolerant!
        else
            GAME.finish(reason)
        end
    else
        GAME.refreshLifeState()
    end
end

function GAME.addHeight(h, realHeight)
    h = h * (realHeight and 1 or GAME.rank / 4)
    GAME.heightBonus = GAME.heightBonus + h
    GAME.heightBuffer = GAME.heightBuffer + h
    if h >= 6 and TASK.lock('speed_tick_whirl', 2.6) then SFX.play('speed_tick_whirl') end
end

local speedupSFX = { 0, 1, 1, 1, 2, 2, 2, 3, 3 }
function GAME.addXP(xp)
    GAME.xp = GAME.xp + xp
    if GAME.rankupLast and GAME.xp >= 2 * GAME.rank then GAME.xpLockLevel = GAME.xpLockLevelMax end

    local oldRank = GAME.rank
    local oldLockTimer = GAME.xpLockTimer
    while GAME.xp >= 4 * GAME.rank do
        GAME.xp = GAME.xp - 4 * GAME.rank
        GAME.rank = GAME.rank + 1
        GAME.xpLockLevel = max(GAME.xpLockLevel - 1, 1)

        -- Rank skip
        if GAME.xp >= 2 * GAME.rank then
            GAME.xpLockLevel = GAME.xpLockLevelMax
            if GAME.xp >= 4 * GAME.rank then
                GAME.rank = GAME.rank + floor(GAME.xp / (4 * GAME.rank))
            end
        end
    end
    if GAME.rank > GAME.rankLimit then
        GAME.rank = GAME.rankLimit
        GAME.xp = 4 * GAME.rank
    end
    if GAME.rank ~= oldRank then
        GAME.xpLockTimer = GAME.xpLockLevel
        GAME.rankupLast = true
        GAME.peakRank = max(GAME.peakRank, GAME.rank)
        TEXTS.rank:set("R-" .. GAME.rank)
        SFX.play('speed_up_' .. (speedupSFX[GAME.rank] or 4), .4 + .5 * GAME.xpLockLevel / (GAME.xpLockLevelMax + 1) * min(GAME.rank / 4, 1))
        -- if GAME.height > 0 and not GAME.gigaspeedEntered and GAME.rank >= GigaSpeedReq[max(GAME.floor, (GAME.negFloor - 1) % 10 + 1)] then
        if not GAME.gigaspeed and GAME.height > 0 and GAME.rank >= GigaSpeedReq[GAME.floor] then
            GAME.setGigaspeedAnim(true)
            GAME.refreshRPC()
        end
        if GAME.gigaspeed and not GAME.teramusic and GAME.rank >= TeraMusicReq[GAME.floor] then
            GAME.startTeraAnim()
            GAME.refreshRPC()
        end
    else
        GAME.xpLockTimer = oldLockTimer
    end
end

function GAME.setGigaspeedAnim(on)
    GAME.gigaspeed = on
    local s = GigaSpeed.alpha
    if on then
        GAME.gigaspeedEntered = GAME.time
        GAME.gigaspeedFloor[GAME.floor] = true
        GAME.gigaCount = GAME.gigaCount + 1
        GigaSpeed.isTera = false
        TWEEN.new(function(t) GigaSpeed.alpha = lerp(s, 1, t) end):setUnique('giga'):run()
        TASK.removeTask_code(GAME.task_gigaspeed)
        TASK.new(GAME.task_gigaspeed)
        SFX.play('zenith_speedrun_start')

        if GAME.comboStr == "ASNHrVL" then SubmitAchv('zero_to_sixty', roundUnit(GAME.time, .01)) end
        if GAME.floor == 1 then IssueAchv('speedrun_speedrunning') end
        if GAME.comboMP >= 15 then IssueAchv('abyss_weaver') end
    else
        TWEEN.new(function(t) GigaSpeed.alpha = lerp(s, 0, t) end):setDuration(GAME.floor == 10 and 6.26 or 3.55):setUnique('giga'):run()
    end
end

function GAME.startTeraAnim()
    GAME.teramusic = true
    GAME.teraspeedFloor[GAME.floor] = true
    GAME.teraCount = GAME.teraCount + 1
    GigaSpeed.isTera = true
    TASK.removeTask_code(GAME.task_gigaspeed)
    TASK.new(GAME.task_gigaspeed)
    SFX.play('zenith_speedrun_start')
    PlayBGM('tera', true)
end

function GAME.stopTeraspeed(mode)
    GAME.teramusic = false
    if mode == 'drop' then
        PlayBGM('f' .. max(GAME.floor, GAME.negFloor), true)
    end
end

function GAME.readyShuffle(messiness, noSnd)
    if not messiness then return end
    GAME.shuffleMessiness = messiness
    if GAME.totalQuest > 0 then
        if not noSnd then SFX.play('rsg_go', 1, 0, Tone(2)) end
        for _, C in ipairs(CD) do C:shake() end
    end
end

function GAME.showFloorText(f, name, duration)
    if GAME.invisUI then return end
    TEXT:add {
        text = "Floor",
        x = 160, y = 290, k = 1.6, fontSize = 30,
        color = 'LY', duration = duration,
    }
    TEXT:add {
        text = tostring(f),
        x = 240, y = 280, k = 2.6, fontSize = 30,
        color = 'LY', duration = duration, align = 'left',
    }
    TEXT:add {
        text = name,
        x = 200, y = 350, k = 1.2, fontSize = 30,
        color = 'LY', duration = duration,
    }
end

function GAME.upFloor()
    local roundFloorTime = roundUnit(GAME.floorTime, .001)
    if GAME.floor == 1 then
        if GAME.comboStr == 'rEXrNHrVL' then SubmitAchv('hardcore_beginning', roundFloorTime) end
    elseif GAME.floor == 2 then
        if GAME.comboStr == 'EXVLrDPrIN' then SubmitAchv('love_hotel', roundFloorTime) end
    elseif GAME.floor == 3 then
        if GAME.comboStr == 'ASEXMS' then SubmitAchv('financially_responsible', roundFloorTime) end
    elseif GAME.floor == 4 then
        if GAME.comboStr == 'EXrDPrVL' then SubmitAchv('unfair_battle', roundFloorTime) end
    elseif GAME.floor == 5 then
        if GAME.comboStr == 'DHDP' then SubmitAchv('museum_heist', roundFloorTime) end
    elseif GAME.floor == 6 then
        if GAME.comboStr == 'EXVLrGV' then SubmitAchv('workaholic', roundFloorTime) end
    elseif GAME.floor == 7 then
        if GAME.comboStr == 'ASMSVL' then SubmitAchv('human_experiment', roundFloorTime) end
    elseif GAME.floor == 8 then
        if GAME.comboStr == 'DHEXGV' then SubmitAchv('thermal_anomaly', roundFloorTime) end
    elseif GAME.floor == 9 then
        SubmitAchv('ultra_dash', GAME.floorTime)
        if GAME.comboStr == 'ASGVMS' then SubmitAchv('dazed', GAME.rank) end
    end

    -- Update section time
    if GAME.floor > 0 then
        ins(GAME.secTime, GAME.floorTime)
        GAME.refreshSectionTime()
    end

    GAME.floor = GAME.floor + 1
    GAME.floorTime = 0
    if GAME.floor > 1 then
        if M.MS == 1 then
            GAME.readyShuffle(Floors[GAME.floor].MSshuffle)
        elseif M.MS == 2 and not URM then
            GAME.readyShuffle(GAME.floor * 2.6)
        end
    end

    GAME.questFavor =
        M.VL == 2 and 50 or (
            (M.EX > 0 and 0 or 33)
            - (M.MS > 0 and 25 or 0)
            - GAME.floor * 3
        )
    if M.GV > 0 then GAME.gravDelay = GravityTimer[M.GV][GAME.floor] end
    local F = Floors[GAME.floor]
    local e = F.event
    for i = 1, #e, 2 do
        if type(e[i + 1]) == 'number' then
            GAME[e[i]] = GAME[e[i]] + e[i + 1]
        else
            GAME[e[i]] = e[i + 1]
        end
    end
    if GAME.dmgTimer > GAME.dmgDelay then GAME.dmgTimer = GAME.dmgDelay end

    -- Text & SFX
    GAME.showFloorText(GAME.floor, Floors[GAME.floor].name, GAME.floor >= 10 and 8.72 or 4.2)
    if GAME.gigaspeed then
        SFX.play('zenith_split_cleared', 1, 0, Tone(-1))
    elseif GAME.floor > 1 then
        SFX.play('zenith_levelup_' .. ({ 'c', 'b', 'a', 'fsharp', 'e', GAME.anyRev and 'g' or 'a', 'ahalfsharp', 'e', 'e', 'a' })[GAME.floor])
    end

    -- End game
    if GAME.floor >= 10 then
        local roundTime = roundUnit(GAME.time, .001)
        if GAME.gigaspeed then
            if GAME.time < STAT.minTime then
                STAT.minTime = roundTime
                STAT.timeDate = os.date("%y.%m.%d %H:%M%p")
                SaveStat()
            end
            GAME.gigaTime = GAME.time
            GAME.setGigaspeedAnim(false)
            if GAME.teramusic then IssueAchv('blazing_speed') end
            GAME.stopTeraspeed('f10')

            local setStr = (GAME.anyUltra and 'u' or '') .. GAME.comboStr
            local t = BEST.speedrun[setStr]
            SFX.play('applause', GAME.time < t and t < 1e99 and 1 or .42)
            if GAME.time < t then
                BEST.speedrun[setStr] = roundTime
                SaveBest()
            end

            local _t
            if not STAT.badge.speedrun_1 then
                _t = 0
                for id in next, MD.name do if rawget(BEST.speedrun, id) then _t = _t + 1 end end
                if _t >= #MD.deck then IssueSecret('speedrun_1') end
            end
            if not STAT.badge.speedrun_2 then
                _t = 0
                for id in next, MD.name do if rawget(BEST.speedrun, 'r' .. id) then _t = _t + 1 end end
                if _t >= #MD.deck then IssueSecret('speedrun_2') end
            end
            if GAME.time <= 76.2 then IssueSecret('subluminal') end
            if GAME.time <= 42 then IssueSecret('superluminal') end
            if GAME.time - GAME.gigaspeedEntered >= 300 then IssueAchv('worn_out') end
            if GAME.closeCard and GAME.comboStr == 'rEX' then IssueSecret('true_expert') end
            if GAME.nightcore and GAME.comboStr == 'rGV' then IssueSecret('true_master') end
            if GAME.fastLeak and GAME.comboStr == 'rVL' then IssueSecret('true_strength') end
            if GAME.invisCard and GAME.comboStr == 'rIN' then IssueSecret('true_invis') end
            if GAME.invisUI and GAME.comboStr == 'rDP' then IssueSecret('true_couple') end
        end

        if GAME.comboStr == '' then SubmitAchv('zenith_speedrun', roundTime) end
        SubmitAchv('zenith_speedrun_plus', roundTime)
        SubmitAchv('detail_oriented', GAME.totalFlip)
    end
    PlayBGM('f' .. GAME.floor)
    GAME.refreshRPC()
end

function GAME.nextFatigue()
    local stage = GAME.fatigueSet[GAME.fatigue]
    local e = stage.event
    for i = 1, #e, 2 do
        GAME[e[i]] = GAME[e[i]] + e[i + 1]
    end
    if stage.text then
        TEXT:add {
            text = stage.text,
            x = 800, y = 265, fontSize = 30, k = 1.5,
            style = 'score', duration = stage.duration or 5,
            inPoint = .1, outPoint = .26,
            color = stage.color or 'lM',
        }
        if stage.desc then
            TEXT:add {
                text = stage.desc,
                x = 800, y = 300, fontSize = 30,
                style = 'score', duration = stage.duration or 5,
                inPoint = .26, outPoint = .1,
                color = stage.color or 'lM',
            }
        end
        TASK.new(GAME.task_fatigueWarn)
        if not GAME.achv_level19capH then
            GAME.achv_level19capH = GAME.roundHeight
        end
    end
    if stage.final then
        if GAME.fatigueSet == Fatigue.normal then
            IssueAchv('final_defiance')
        elseif GAME.fatigueSet == Fatigue.rEX then
            IssueAchv('royal_resistance')
        elseif GAME.fatigueSet == Fatigue.rDP then
            IssueAchv('lovers_stand')
        end
    end

    GAME.fatigue = GAME.fatigue + 1
end

function GAME.downFloor()
    GAME.negFloor = GAME.negFloor + 1
    GAME.floorTime = 0
    if GAME.negFloor > 1 then
        if M.MS == 1 then
            GAME.readyShuffle(Floors[GAME.negFloor].MSshuffle)
        elseif M.MS == 2 and not URM then
            GAME.readyShuffle(GAME.negFloor * 2.6)
        end
    end

    GAME.questFavor =
        M.VL == 2 and 50 or (
            (M.EX > 0 and 0 or 33)
            - (M.MS > 0 and 25 or 0)
            - GAME.negFloor * 3
        )
    if M.GV > 0 then GAME.gravDelay = GravityTimer[M.GV][GAME.negFloor] end

    -- Text & SFX
    GAME.showFloorText(-GAME.negFloor, NegFloors[GAME.negFloor].name, 6.2)
    SFX.play('zenith_levelup_' .. ({ 'c', 'b', 'a', 'fsharp', 'e', GAME.anyRev and 'g' or 'a', 'ahalfsharp', 'e', 'e', 'a' })[GAME.floor])

    GAME.refreshRPC()
    PlayBGM('f' .. GAME.negFloor)
end

function GAME.nextNegEvent()
    local e = NegEvents[GAME.negEvent]
    if e.cond() then
        if type(e.event) == 'function' then
            e.event()
        elseif type(e.event) == 'table' then
            for i = 1, #e.event, 2 do
                if type(e.event[i + 1]) == 'number' then
                    GAME[e.event[i]] = GAME[e.event[i]] + e.event[i + 1]
                else
                    GAME[e.event[i]] = e.event[i + 1]
                end
            end
        end
        local sfx
        if e.text then
            TEXT:add {
                text = e.text,
                x = 800, y = 350, fontSize = 30, k = 1.5 * (e.size or 1),
                style = 'score', duration = e.duration or 5,
                inPoint = .1, outPoint = .26,
                color = e.color or 'lR',
            }
            sfx = 'counter'
        end
        SFX.play(e.sfx or sfx)
    end
    GAME.negEvent = GAME.negEvent + 1
end

local revLetter = setmetatable({
    P = "Ь", R = "ᖉ", T = "ꓕ", Q = "Ơ", U = "Ո", A = "Ɐ", L = "Γ", S = "Ƨ"
}, { __index = function(_, k) return k end })
function GAME.refreshRPC()
    local detailStr = "QUICK PICK"
    if M.EX > 0 then detailStr = "EXPERT " .. detailStr end
    if M.DP > 0 then detailStr = detailStr:gsub("QUICK", "DUAL") end
    if TestMode then detailStr = detailStr:gsub("PICK", "TEST") end
    if GAME.anyRev then detailStr = detailStr:gsub(".", revLetter) end

    local stateStr
    if GAME.playing then
        if DailyActived then
            stateStr = GAME.teramusic and "Daily SPEEDRUN: " or GAME.gigaspeed and "Daily speedrun: " or "Daily game: "
        else
            stateStr = GAME.teramusic and "SPEEDRUN: " or GAME.gigaspeed and "Speedrun: " or "In game: "
        end
        if GAME.negFloor > 1 then
            stateStr = stateStr .. "B" .. GAME.negFloor
        else
            stateStr = stateStr .. "F" .. (GAME.floor == 10 and GAME.omega and "Ω" or GAME.floor)
        end
        local hand = GAME.getHand(true)
        if #hand > 0 then
            local comboName = GAME.getComboName(hand, 'rpc')
            stateStr = stateStr .. " - "
            if GAME.anyUltra then
                ---@cast comboName string
                comboName = comboName:gsub("([^\"])", "ULTRA %1", 1)
            end
            stateStr = stateStr .. comboName
        end
    else
        stateStr = "Enjoying music"
        if BgmPlaying and BgmPlaying ~= 'f0' then
            stateStr = stateStr .. " (" .. BgmPlaying:upper():gsub("R$", "-R") .. ")"
        end
        local pitch = URM and M.GV == 2 and 3 or M.GV
        if GAME.nightcore then pitch = pitch + 12 end
        if GAME.slowmo then pitch = pitch - 12 end
        if pitch ~= 0 then stateStr = stateStr .. (pitch > 0 and " (+" or " (") .. pitch .. ")" end
        if M.IN > 0 then stateStr = stateStr:gsub(".", { j = "r", s = "z", p = "b", c = "g", t = "d" }) end
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
local function modIconSorter(a, b) return MD.prio_icon[a] < MD.prio_icon[b] end
function GAME.refreshModIcon()
    GAME.modIB:clear()
    local hand = GAME.getHand(true)
    table.sort(hand, modIconSorter)
    local quad, w, _
    if #hand == 1 then
        quad = URM and TEXTURE.modQuad_ultra[hand[1]] or TEXTURE.modQuad_ig[hand[1]]
        _, _, w = quad:getViewport()
        GAME.modIB:add(
            quad, 0, 0,
            0, .62, nil, w * .5, w * .5
        )
    elseif #hand == 2 then
        quad = URM and TEXTURE.modQuad_ultra[hand[2]] or TEXTURE.modQuad_ig[hand[2]]
        _, _, w = quad:getViewport()
        GAME.modIB:add(
            quad, 35, 0,
            0, .5, nil, w * .5, w * .5
        )
        quad = URM and TEXTURE.modQuad_ultra[hand[1]] or TEXTURE.modQuad_ig[hand[1]]
        _, _, w = quad:getViewport()
        GAME.modIB:add(
            quad, -35, 0,
            0, .5, nil, w * .5, w * .5
        )
    else
        local r = 35
        for x = 3, 2, -1 do
            for i = #hand, 1, -1 do
                if #hand[i] == x then
                    quad = x == 3 and URM and TEXTURE.modQuad_ultra[hand[i]] or TEXTURE.modQuad_ig[hand[i]]
                    _, _, w = quad:getViewport()
                    GAME.modIB:add(
                        quad,
                        modIconPos[i][1] * r, modIconPos[i][2] * r,
                        0, URM and x == 3 and .35 or .28, nil, w * .5, w * .5
                    )
                end
            end
        end
    end
end

function GAME.refreshResultModIcon()
    GAME.resIB:clear()
    local hand = GAME.getHand(true)
    table.sort(hand, modIconSorter)
    local quad, w, _
    if #hand == 1 then
        quad = URM and TEXTURE.modQuad_ultra_res[hand[1]] or TEXTURE.modQuad_res[hand[1]]
        _, _, w = quad:getViewport()
        GAME.resIB:add(
            quad, 0, 0,
            0, #hand[1] == 3 and .626 or .5, nil, w * .5, w * .5
        )
    elseif #hand == 2 then
        quad = URM and TEXTURE.modQuad_ultra_res[hand[2]] or TEXTURE.modQuad_res[hand[2]]
        _, _, w = quad:getViewport()
        GAME.resIB:add(
            quad, 35, 0,
            0, #hand[2] == 3 and .567 or .432, nil, w * .5, w * .5
        )
        quad = URM and TEXTURE.modQuad_ultra_res[hand[1]] or TEXTURE.modQuad_res[hand[1]]
        _, _, w = quad:getViewport()
        GAME.resIB:add(
            quad, -35, 0,
            0, #hand[1] == 3 and .567 or .432, nil, w * .5, w * .5
        )
    else
        local r = 35
        for x = 3, 2, -1 do
            for i = #hand, 1, -1 do
                if #hand[i] == x then
                    quad = URM and TEXTURE.modQuad_ultra_res[hand[i]] or TEXTURE.modQuad_res[hand[i]]
                    _, _, w = quad:getViewport()
                    GAME.resIB:add(
                        quad, modIconPos[i][1] * r, modIconPos[i][2] * r,
                        0, x == 3 and .36 or .3, nil, w * .5, w * .5
                    )
                end
            end
        end
    end
end

--------------------------------------------------------------

function GAME.refreshCurrentCombo()
    local hand = GAME.getHand(not GAME.playing)
    local comboName = GAME.getComboName(hand, 'button')
    if not GAME.playing and GAME.anyUltra and #hand > 0 then
        ---@cast comboName string
        comboName = comboName:gsub("([^\"])", "ULTRA %1", 1)
    end
    TEXTS.mod:set(comboName)
    if not GAME.playing then
        GAME.comboMP = GAME.getComboMP(hand)
        GAME.comboZP = GAME.getComboZP(hand)
        TEXTS.mpPreview:set(GAME.comboMP .. " MP")
        TEXTS.zpPreview:set(("%.2fx ZP"):format(GAME.comboZP))
        DailyActived =
            #GAME.getHand(true) == #DAILY and
            TABLE.equal(TABLE.sort(GAME.getHand(true)), TABLE.sort(TABLE.copy(DAILY)))

        RefreshHelpText()
    end
end

function GAME.refreshLayout()
    local baseDist = 110 + (M.EX > 0 and (URM and M.EX == 2 and -30 or -10) or 0) + M.VL * 20 + (GAME.closeCard and -30 or 0)
    local baseL, baseR = 800 - 4 * baseDist - 70, 800 + 4 * baseDist + 70
    local baseY = 726 + (URM and M.GV == 2 and 50 or 15 * M.GV)
    if FloatOnCard then
        local selX = 800 + (FloatOnCard - 5) * baseDist
        local dodge = M.VL == 0 and 250 or 230
        if URM and M.EX == 2 then dodge = dodge - 40 end
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
            C.ty = baseY - ((C.active and 45 or 0) + (i == FloatOnCard and 55 or 0))
        end
    else
        for i, C in ipairs(CD) do
            C.tx = 800 + (i - 5) * baseDist
            C.ty = baseY - ((C.active and 45 or 0) + (i == FloatOnCard and 55 or 0))
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
    CD.DP.lock = not ACHV.intended_glitch
end

function GAME.refreshPBText()
    local setStr = (GAME.anyUltra and 'u' or '') .. table.concat(TABLE.sort(GAME.getHand(true)))
    local height = BEST.highScore[setStr]
    if height == 0 then
        TEXTS.pb:set("No score yet")
    else
        local time = BEST.speedrun[setStr]
        if time < 1e99 then
            TEXTS.pb:set(("BEST: %.1fm    GIGA: %.3f″"):format(height, time))
        else
            local f = 0
            for i = 1, #Floors do
                if height < Floors[i].top then
                    f = i
                    break
                end
            end
            TEXTS.pb:set(("BEST: %.1fm  <F%d>"):format(height, f))
        end
    end
end

function GAME.refreshSectionTime()
    local secTimeStr = ""
    for i = 1, #GAME.secTime do
        secTimeStr = secTimeStr .. ("%sF%s%s%s %s %.3f″"):format(
            (i > 1 and "\n" or ""),
            i == 11 and "Ω" or tostring(i),
            GAME.gigaspeedFloor[i] and "g" or "",
            GAME.teraspeedFloor[i] and "t" or "",
            not GAME.playing and i == #GAME.secTime and "x" or "-",
            GAME.secTime[i]
        )
    end
    TEXTS.floorTime:set(secTimeStr)
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
        GAME.refreshUltra()

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
            GAME.bgX = lerp(x, 0, t)
            t = lerp(s, e, t)
            GAME.revTimer = t
            TextColor[1] = lerp(BaseTextColor[1], .62, t)
            TextColor[2] = lerp(BaseTextColor[2], .1, t)
            TextColor[3] = lerp(BaseTextColor[3], .1, t)
            ShadeColor[1] = lerp(BaseShadeColor[1], .1, t)
            ShadeColor[2] = lerp(BaseShadeColor[2], 0, t)
            ShadeColor[3] = lerp(BaseShadeColor[3], 0, t)
        end):setUnique('revSwitched'):setDuration(.26):run()
    end
end

function GAME.refreshUltra()
    GAME.anyUltra = URM and GAME.anyRev
end

function GAME.refreshLifeState()
    local oldState = GAME.lifeState
    local hp = GAME[GAME.getLifeKey()]
    local newState
    if hp == GAME.fullHealth then
        newState = 'safe'
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
    TEXTS.dcBest:set(
        STAT.dailyBest > 0 and
        ("%.0fm  %.0fZP"):format(STAT.dailyBest / GAME.getComboZP(DAILY), STAT.dailyBest)
        or ""
    )
    DailyAvailable = true
    for _, v in next, DAILY do
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
        local sortedDaily = TABLE.copy(DAILY)
        table.sort(sortedDaily, modCardSorter)
        str = "Today's Combo: " .. table.concat(sortedDaily, " ")
        local rev = str:match("r(%S+)")
        if not rev then
            local key = table.concat(TABLE.sort(sortedDaily), ' ')
            local combo = ComboData.menu[key] or ComboData.gameEX[key]
            if combo then
                str = str .. "   " .. combo.name
            end
        else
            str = str .. ("   (r$1 = reversed $1)"):repD(rev)
        end
        str = str .. "\nTry to get more ZP in one run using this mod combo.\n(Click to select them)"
    else
        str = "Oops! Today's mod combo is not available for you...\nComplete more mods to unlock some content."
    end
    SCN.scenes.tower.widgetList.daily.floatText = str
    SCN.scenes.tower.widgetList.daily:reset()
end

function GAME.swapControl()
    if GAME[GAME.getLifeKey(true)] > 0 then
        GAME.onAlly = not GAME.onAlly
        GAME.refreshLifeState()
        return true
    end
end

function GAME.cancelAll(instant)
    if URM and M.VL == 2 and not UltraVlCheck('reset', instant) then return end

    TASK.removeTask_code(GAME.task_cancelAll)
    TASK.new(GAME.task_cancelAll, instant)
    if GAME.gravTimer and (not (URM and M.GV == 2) and GAME.achv_resetCount < 15) then GAME.gravTimer = GAME.gravDelay end
end

function GAME.task_cancelAll(instant)
    if GAME.playing and not instant then
        if GAME.achv_resetCount == 0 then
            GAME.achv_noResetH = GAME.roundHeight
        end
        GAME.achv_resetCount = GAME.achv_resetCount + 1
        -- if GAME.achv_totalResetCount == 0 then
        --     if GAME.comboStr == 'ASDHNHVL' then
        --         SubmitAchv('minimalism', GAME.achv_maxChain)
        --         if GAME.totalQuest >= 26 then SFX.play('btb_break') end
        --     end
        -- end
        GAME.achv_totalResetCount = GAME.achv_totalResetCount + 1
    end
    local list = TABLE.copy(CD, 0)
    local needFlip = {}
    local spinMode = not instant and M.AS > 0
    for i = 1, #CD do
        needFlip[i] = spinMode or CD[i].active
    end
    local interval = not instant and .042 * (M.AS == 2 and .62 or 1) * (1 + 2 * M.NH) * (GAME.slowmo and 2.6 or 1) * (GAME.nightcore and 1 / 2.6 or 1)
    for i = 1, #list do
        if needFlip[i] then
            list[i]:setActive(true)
            if M.AS == 1 then
                list[i].burn = false
            end
            if interval then
                SFX.play('card_slide_' .. rnd(4), .62)
                TASK.yieldT(interval)
            end
        end
    end
end

function GAME.commit(auto)
    if #GAME.quests == 0 then return end

    if URM and M.VL == 2 and not UltraVlCheck('start', auto) then return end

    if not auto and not GAME.achv_noManualCommitH then GAME.achv_noManualCommitH = GAME.roundHeight end

    local hand = TABLE.sort(GAME.getHand(false))
    local allyWasDead = GAME[GAME.getLifeKey(true)] == 0

    if #hand == 0 and GAME.questTime < .1 then return SFX.play('no') end

    if M.DP > 0 and not (GAME.achv_shareModH and GAME.achv_noShareModH) and GAME.totalQuest >= 1 then
        local noRep = #TABLE.subtract(TABLE.copy(hand), GAME.lastCommit) == #hand
        if noRep then
            if not GAME.achv_shareModH then
                GAME.achv_shareModH = GAME.roundHeight
                if GAME.totalQuest >= 10 then SFX.play('btb_break') end
            end
        else
            if not GAME.achv_noShareModH then
                GAME.achv_noShareModH = GAME.roundHeight
                if GAME.totalQuest >= 10 then SFX.play('btb_break') end
            end
        end
    end

    for _, id in next, GAME.lastCommit do CD[id].inLastCommit = false end
    GAME.lastCommit = TABLE.copy(hand)
    for _, id in next, GAME.lastCommit do CD[id].inLastCommit = true end

    local q1 = TABLE.sort(GAME.quests[1].combo)
    local q2 = M.DP > 0 and GAME.quests[2] and TABLE.sort(GAME.quests[2].combo)

    if GAME.currentTask then
        GAME.incrementPrompt('commit')
        GAME.nixPrompt('keep_no_commit')
        for i = 1, #MD.deck do
            local id = MD.deck[i].id
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

        if GAME.lifeState == 'danger' then
            GAME.achv_clutchQuest = GAME.achv_clutchQuest + 1
            SFX.play('clutch')
        end

        GAME.heal((dblCorrect and 3 or 1) * GAME.dmgHeal)
        if MATH.between(Floors[GAME.floor].top - (GAME.height + GAME.heightBuffer), 0, 2) then GAME.addHeight(3, true) end

        local dp = TABLE.find(hand, 'DP')
        local attack = 3
        local surge = 0
        local xp = 0
        if dp and M.EX < 2 then attack = attack + 2 end
        local check_achv_romantic_homicide
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
                check_achv_romantic_homicide = M.DP == 2 and GAME.chain >= 62 and GAME[GAME.getLifeKey(true)] == 0
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
                    SFX.play('thunder' .. rnd(6), clampInterpolate(8, .7, 16, 1, GAME.chain))
                end
                local k = GAME.onAlly and 'life2' or 'life'
                local oldLife = GAME[k]
                while GAME.chain > 0 and GAME[k] < GAME.fullHealth do
                    GAME.chain = max(GAME.chain - 2, 0)
                    GAME[k] = min(GAME[k] + 1, GAME.fullHealth)
                end
                if GAME[k] > oldLife then GAME.incrementPrompt('heal', GAME[k] - oldLife) end
                if GAME.chain > 0 then
                    surge = GAME.chain
                end
            end
            GAME.chain = 0

            if not GAME.achv_perfectH then
                GAME.achv_perfectH = GAME.roundHeight
                if GAME.totalQuest >= 26 then SFX.play('btb_break') end
            end
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
            if M.NH < 2 then attack = attack + 1 end
            if M.AS == 2 and GAME.chain >= 4 then attack = attack + 1 end
            xp = xp + 3

            if correct == 1 then
                GAME.chain = GAME.chain + 1
                if GAME.chain < 4 then
                elseif GAME.chain < 8 then
                    if GAME.chain == 4 then SFX.play('b2bcharge_start', .8) end
                    SFX.play('b2bcharge_1', .8)
                elseif GAME.chain < 12 then
                    SFX.play('b2bcharge_2', .8)
                elseif GAME.chain < 24 then
                    SFX.play('b2bcharge_3', .7)
                else
                    SFX.play('b2bcharge_4', .626)
                end
            end

            GAME.totalPerfect = GAME.totalPerfect + (dblCorrect and 2 or 1)
            if not GAME.achv_noPerfectH then
                GAME.achv_noPerfectH = GAME.roundHeight
                if GAME.totalQuest >= 26 then SFX.play('btb_break') end
            end
            if not GAME.achv_noChargeH and GAME.chain >= 4 then
                GAME.achv_noChargeH = GAME.roundHeight
                if GAME.totalQuest >= 26 then SFX.play('btb_break') end
            end
        end
        if dblCorrect then
            attack = attack * 3
            xp = xp * 3
            GAME.chain = GAME.chain + 1
            GAME.achv_doublePass = GAME.achv_doublePass + 1
            if not ACHV.lucky_coincidence then IssueAchv('lucky_coincidence') end
        end
        if GAME.switch_sickness >= 20 then
            if GAME.switch_sickness >= 20 then xp = xp * .5 end
            if GAME.switch_sickness >= 30 then attack = attack * .5 end
            if GAME.switch_sickness >= 40 then xp = xp * .4 end
            if GAME.switch_sickness >= 50 then attack = attack * .5 end
            if GAME.switch_sickness >= 60 then xp = xp * .3 end
            if not GAME.hasseenDPnerf and GAME.switch_sickness >= 40 then
                GAME.hasseenDPnerf = true
                GAME.extraQuestBase = GAME.extraQuestBase + .626
            end
        end
        if GAME.chain >= 4 then
            local chainCap = 6 * (max(GAME.floor, GAME.negFloor) + 2) ^ 2
            if GAME.chain > chainCap then
                GAME.chain = chainCap
                IssueSecret('sc_cap')
            end
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
                    local r = clampInterpolate(4, 26, 26, 62, GAME.chain)
                    WoundPS:setEmissionArea('uniform', r, r, 0, false)
                end
                if GAME.chain % 4 == 0 then
                    if GAME.chain <= 100 then
                        local s = 1 + GAME.chain / 200
                        ---@diagnostic disable-next-line
                        WoundPS:setSizes(0, 1 * s, .9 * s, .8 * s, .7 * s, .6 * s, .42 * s)
                    end
                end
                WoundPS:setEmissionRate(clampInterpolate(16, 1, 2600, 6.26, GAME.chain ^ 2))
                WoundPS:setLinearDamping(clampInterpolate(4, 1.2, 42, 0.626, GAME.chain))

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

            GAME.achv_maxChain = max(GAME.achv_maxChain, GAME.chain)
            if GAME.chain >= 75 and GAME.chain - (dblCorrect and 2 or 1) < 75 then
                SubmitAchv('perfect_speedrun', GAME.time)
            end
        end

        SFX.play(dp and 'zenith_start_duo' or 'zenith_start', .626, 0, Tone(12))

        if GAME.achv_escapeBurnt then
            GAME.achv_escapeBurnt = false
            GAME.achv_escapeQuest = GAME.achv_escapeQuest + 1
        end
        if GAME.achv_felMagicBurnt then
            GAME.achv_felMagicBurnt = false
            GAME.achv_felMagicQuest = GAME.achv_felMagicQuest + 1
        end
        if GAME.achv_resetCount % 2 == 1 then
            GAME.achv_obliviousQuest = GAME.achv_obliviousQuest + 1
        end

        -- Spike
        if GAME.spikeTimer <= 0 then
            GAME.spikeTimer = 0
            GAME.spikeCounter = 0
            GAME.spikeCounterWeak = 0
        end
        GAME.spikeTimer = MATH.clamp(
            GAME.spikeTimer + (attack + surge) / (12.6 + GAME.spikeCounter / 26),
            GAME.spikeCounter < 8 and 1.26 or .8,
            6.2
        )
        GAME.spikeCounter = GAME.spikeCounter + attack + surge
        GAME.maxSpike = max(GAME.maxSpike, GAME.spikeCounter)
        GAME.spikeCounterWeak = GAME.spikeCounterWeak + attack
        GAME.maxSpikeWeak = max(GAME.maxSpikeWeak, GAME.spikeCounterWeak)
        if GAME.spikeCounter >= 8 then TEXTS.spike:set(tostring(GAME.spikeCounter)) end

        if URM and M.NH == 2 then
            xp = xp + surge
            surge = 0
        end

        attack = attack + surge
        GAME.achv_altFromSurge = GAME.achv_altFromSurge + surge * GAME.rank / 4 * GAME.attackMul

        local oldAllyLife = GAME[GAME.getLifeKey(true)]
        ---@cast oldAllyLife number
        if M.DP > 0 then
            if GAME[GAME.getLifeKey(true)] == 0 then
                xp = xp / 2
                attack = attack / 2
            elseif not allyWasDead and not GAME.achv_carriedH then
                GAME.achv_carriedH = GAME.roundHeight
                if GAME.totalQuest >= 26 then SFX.play('btb_break') end
            end
            if M.DP == 2 then
                GAME.takeDamage(URM and attack / 2.6 or attack / 4, 'wrong', oldAllyLife > 0)
                if not GAME.playing then return end
                if check_achv_romantic_homicide then IssueAchv('romantic_homicide') end
            end
        end

        attack = MATH.roundRnd(attack)

        GAME.incrementPrompt('send', attack)
        GAME.totalAttack = GAME.totalAttack + attack
        GAME.totalSurge = GAME.totalSurge + surge

        if GAME.DPlock then attack = min(attack, URM and oldAllyLife * 2.6 or oldAllyLife * 4) end
        if attack > 0 then GAME.addHeight(attack * GAME.attackMul) end
        GAME.addXP(attack + xp)

        -- rMS little shuffle
        if M.MS == 2 then
            if URM then
                GAME.readyShuffle(max(GAME.floor, GAME.negFloor) * 2.6, true)
            else
                local lastPos = -26
                for i = 1, #CD do
                    if CD[i].id == GAME.lastFlip then
                        lastPos = i
                        break
                    end
                end
                local w = max(GAME.floor, GAME.negFloor) <= 8 and 2 or 3
                local r
                repeat r = rnd(#CD - w + 1) until r > lastPos + 1 or r + w < lastPos
                if w == 2 then
                    CD[r], CD[r + 1] = CD[r + 1], CD[r]
                elseif w == 3 then
                    if MATH.roll() then
                        CD[r], CD[r + 1], CD[r + 2] = CD[r + 2], CD[r], CD[r + 1]
                    else
                        CD[r], CD[r + 1], CD[r + 2] = CD[r + 1], CD[r + 2], CD[r]
                    end
                end
                GAME.refreshLayout()
            end
        end

        if M.NH < 2 then GAME.cancelAll(true) end
        GAME.cancelBurn()
        GAME.dmgTimer = min(GAME.dmgTimer + max(2.6, GAME.dmgDelay / 2), GAME.dmgDelay)

        for i = dblCorrect and 2 or 1, 1, -1 do
            local p = dblCorrect and i or correct
            if #GAME.quests < GAME.maxQuestCount + 1 then
                GAME.genQuest()
            end
            rem(GAME.quests, p).name:release()
            local combo = GAME.quests[correct] and GAME.quests[correct].combo or NONE
            if #combo >= 4 then
                local pwr = #combo * 2 - 7
                if TABLE.find(combo, 'DH') then pwr = pwr + 1 end
                SFX.play('garbagewindup_' .. MATH.clamp(pwr, 1, 5), 1, 0)
            end
            GAME.questReady()
            GAME.totalQuest = GAME.totalQuest + 1
            if GAME.totalQuest == 40 then
                if GAME.comboStr == '' then SubmitAchv('clicker_speedrun', GAME.time) end
                if GAME.comboStr == 'ASrMS' then SubmitAchv('naga_eyes', GAME.time) end
                if GAME.comboStr == 'DPMSrNH' then SubmitAchv('scarcity_mindset', GAME.totalFlip) end
            elseif GAME.totalQuest == 41 then
                if GAME.comboStr == 'EXMS' then SubmitAchv('quest_rationing', GAME.roundHeight) end
            end
            if GAME.totalQuest > 7 and not GAME.achv_plonkH then
                GAME.achv_plonkH = GAME.roundHeight
            end
        end

        if M.DP > 0 and (correct == 2 or dblCorrect) then
            if GAME.swapControl() then
                SFX.play('party_ready', MATH.clampInterpolate(15, 1, 40, .6, GAME.switch_sickness))
                GAME.switch_sickness = GAME.switch_sickness + 1
            end
        else
            GAME.switch_sickness = max(GAME.switch_sickness - .5, 0)
        end

        if GAME.shuffleMessiness then
            GAME.sortCards()
            if M.MS == 1 then
                GAME.weakShuffleCards(GAME.shuffleMessiness)
            elseif M.MS == 2 then
                GAME.shuffleCards(GAME.shuffleMessiness)
            end
            GAME.shuffleMessiness = false
        end

        if M.MS == 1 and GAME.floor >= 10 and GAME.totalQuest % 40 == 0 then GAME.readyShuffle(4) end
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

        GAME.takeDamage(max(GAME.dmgWrong + GAME.dmgWrongExtra, 1), 'wrong')
        if not GAME.playing then return end
        GAME.dmgWrongExtra = GAME.dmgWrongExtra + .5

        if M.GV > 0 then GAME.gravTimer = GAME.gravDelay end
        if M.EX > 0 then
            if M.NH < 2 then GAME.cancelAll(true) end
        elseif M.AS == 1 then
            GAME.cancelBurn()
        end
    end
end

local function task_startSpin()
    for _, C in ipairs(CD) do
        C.tempOrder = C.initOrder
        if C.active then C:setActive(true) end
    end
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
    if M.MS == 1 then
        GAME.weakShuffleCards(0)
    elseif M.MS == 2 then
        GAME.shuffleCards(2.6)
    end
end
function GAME.start()
    if TASK.getLock('cannotStart') then
        SFX.play('garbagerise')
        return
    end
    if URM and M.VL == 2 and not UltraVlCheck('start') then return end
    TASK.removeTask_code(Task_MusicEnd)
    MusicPlayer = false

    GAME.omega = false
    GAME.negFloor = 1
    GAME.negEvent = 1
    GAME.timerMul = 1
    GAME.isUltraRun = GAME.anyUltra
    GAME.attackMul = GAME.isUltraRun and .62 or 1
    GAME.xpLockLevelMax = URM and M.NH == 2 and 1 or 5
    GAME.leakSpeed = (M.EX > 0 and 5 or 3) + (GAME.fastLeak and 8 or 0)
    GAME.invincible = false

    TASK.unlock('sure_quit')
    SCN.scenes.tower.widgetList.help:setVisible(false)
    SCN.scenes.tower.widgetList.help2:setVisible(false)
    SCN.scenes.tower.widgetList.daily:setVisible(false)
    MSG.clear()

    SFX.play('menuconfirm', .8)
    SFX.play((M.DP > 0 or VALENTINE and not GAME.anyRev) and 'zenith_start_duo' or 'zenith_start', 1, 0, Tone(0))

    GAME.playing = true

    -- Statistics
    GAME.comboStr = table.concat(TABLE.sort(GAME.getHand(true)))
    GAME.prevPB = BEST.highScore[(GAME.isUltraRun and 'u' or '') .. GAME.comboStr]
    if GAME.prevPB == 0 then GAME.prevPB = -2600 end
    GAME.totalFlip = 0
    GAME.totalQuest = 0
    GAME.totalPerfect = 0
    GAME.totalAttack = 0
    GAME.totalSurge = 0
    GAME.heightBonus = 0
    GAME.peakRank = 1
    GAME.rankTimer = TABLE.new(0, 26)

    -- Time
    GAME.time = 0
    GAME.gigaTime = false
    GAME.questTime = 0
    GAME.floorTime = 0
    GAME.reviveTime = false
    GAME.secTime = {}

    -- Rank
    GAME.rank = 1
    TEXTS.rank:set("R-1")
    GAME.xp = 0
    GAME.rankupLast = false
    GAME.xpLockLevel = GAME.xpLockLevelMax
    GAME.xpLockTimer = 0

    -- Floor
    GAME.floor = 0
    GAME.height = 0
    GAME.heightBuffer = 0
    GAME.fatigueSet = Fatigue[M.EX == 2 and 'rEX' or M.DP == 2 and 'rDP' or 'normal']
    GAME.fatigue = 1
    GAME.animDuration = GAME.slowmo and 26 or 1
    GAME.lastCommit = {}

    -- Params
    GAME.maxQuestCount = M.NH == 2 and 2 or 3
    GAME.maxQuestSize = (M.NH < 2 and M.DH == 2) and 3 or 4
    GAME.extraQuestBase = M.NH == 2 and (M.DH > 0 and 2.42 - M.DH or 1.26) or M.DH == 1 and 0.26 or 0
    GAME.extraQuestVar = M.DH == 1 and .626 or 1
    GAME.questFavor = 0 -- Initialized in GAME.upFloor()
    GAME.dmgHeal = 2
    GAME.dmgWrong = 1
    GAME.dmgTime = 2
    GAME.dmgTimerMul = 1
    GAME.dmgDelay = 15
    GAME.dmgCycle = 5

    -- Player
    GAME.life = 20
    GAME.fullHealth = 20
    GAME.dmgTimer = GAME.dmgDelay
    GAME.chain = 0
    GAME.gigaspeed = false
    GAME.gigaspeedEntered = false
    TABLE.clear(GAME.gigaspeedFloor)
    TABLE.clear(GAME.teraspeedFloor)
    GAME.gigaCount = 0
    GAME.teraCount = 0
    GAME.teramusic = false
    GAME.atkBuffer = 0
    GAME.atkBufferCap = 8 + (M.DH == 1 and M.NH < 2 and 2 or 0)
    GAME.shuffleMessiness = false

    -- Spike
    GAME.spikeTimer = 0
    GAME.spikeCounter = 0
    GAME.spikeCounterWeak = 0
    GAME.maxSpike = 0
    GAME.maxSpikeWeak = 0

    -- rDP
    GAME.onAlly = false
    GAME.life2 = 20
    GAME.rankLimit = 26000
    GAME.reviveCount = 0
    GAME.reviveDifficulty = 0
    GAME.killCount = 0
    GAME.currentTask = false
    GAME.DPlock = false
    GAME.lastFlip = false
    GAME.switch_sickness = 0
    GAME.hasseenDPnerf = false
    if M.DP == 2 then
        GAME.rankLimit = 8 + 4 * M.EX
        GAME.dmgHeal = 3
    end

    if M.DP > 0 then
        GAME.life = 15
        GAME.life2 = 15
        GAME.fullHealth = 15
    end

    GAME.refreshLifeState()

    GAME.refreshModIcon()
    TABLE.clear(ComboColor)
    for k, v in next, M do
        if v > 0 then
            local c = TABLE.copy(MD.color[k])
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
    for _ = 1, GAME.maxQuestCount do GAME.genQuest() end
    GAME.questReady()

    TASK.removeTask_code(task_startSpin)
    TASK.new(task_startSpin)

    TWEEN.new(GAME.anim_setMenuHide):setOnFinish(GAME.anim_setMenuHide_finish):setDuration(GAME.slowmo and 2.6 or .26):setUnique('uiHide'):run()

    GAME.achv_plonkH = nil
    GAME.achv_perfectH = nil
    GAME.achv_demoteH = nil
    GAME.achv_carriedH = nil
    GAME.achv_noPerfectH = nil
    GAME.achv_noChargeH = nil
    GAME.achv_noManualCommitH = nil
    GAME.achv_noDamageH = nil
    GAME.achv_noKeyboardH = nil
    GAME.achv_shareModH = nil
    GAME.achv_noShareModH = nil
    GAME.achv_protectH = nil
    GAME.achv_noManualFlipH = nil
    GAME.achv_maxChain = 0
    GAME.achv_maxReviveH = nil
    GAME.achv_totalDmg = 0
    GAME.achv_clutchQuest = 0
    GAME.achv_escapeBurnt = false
    GAME.achv_escapeQuest = 0
    GAME.achv_felMagicBurnt = false
    GAME.achv_felMagicQuest = 0
    GAME.achv_resetCount = 0
    GAME.achv_obliviousQuest = 0
    GAME.achv_doublePass = 0
    GAME.achv_level19capH = false
    GAME.achv_totalResetCount = 0
    GAME.achv_altFromSurge = 0
    if M.DP > 0 then IssueAchv('intended_glitch') end
end

---@param reason 'forfeit' | 'wrong' | 'time'
function GAME.finish(reason)
    SCN.scenes.tower.widgetList.help:setVisible(not GAME.zenithTraveler)
    SCN.scenes.tower.widgetList.help2:setVisible(not GAME.zenithTraveler)
    SCN.scenes.tower.widgetList.daily:setVisible(not GAME.zenithTraveler)
    TABLE.clear(HoldingButtons)
    MSG.clear()

    SFX.play(
        reason == 'forfeit' and 'detonated' or
        reason == 'wrong' and 'topout' or
        reason == 'time' and 'losestock' or
        'shatter', .8
    )

    TASK.removeTask_code(GAME.task_cancelAll)

    GAME.sortCards()
    for _, C in ipairs(CD) do
        if (M[C.id] > 0) ~= C.active then
            C:setActive(true)
        end
        if not C.active and not C.upright then C.upright = true end
        C.touchCount = 0
        -- C.required = false
        C.required2 = false
        C.inLastCommit = false
        C.burn = false
        C.charge = 0
    end
    FloatOnCard = nil
    GAME.refreshLayout()

    GAME.playing = false
    if M.DH == 2 then GAME.finishTime = love.timer.getTime() end
    ins(GAME.secTime, GAME.floorTime)
    GAME.refreshSectionTime()
    GAME.life, GAME.life2 = 0, 0
    GAME.teramusic = false
    GAME.currentTask = false

    local unlockDuo
    if GAME.totalQuest > 2.6 then
        LOG('info', ("[%s] (%s) F%d %.1fm in %.3fs"):format(reason, table.concat(GAME.getHand(true), ', '), GAME.floor, GAME.roundHeight, GAME.time))

        if GAME.floor >= 10 then
            local unlockRev = 0
            for k, v in next, M do
                if v > GAME.completion[k] then
                    if GAME.completion[k] == 0 then
                        if k == 'DP' then
                            unlockDuo = true
                        else
                            unlockRev = unlockRev + 1
                        end
                        RevUnlocked = true
                    end
                    GAME.completion[k] = v
                end
            end
            if unlockRev > 0 or not GAME.anyRev and MATH.roll(.1) and TABLE.countAll(GAME.completion, 2) == 0 then
                local hintText
                if unlockRev == 0 then
                    hintText = "You've already unlocked REVERSED MOD!\n"
                else
                    hintText = "You've already unlocked " .. (unlockRev == 1 and "a new REVERSED MOD!\n" or unlockRev .. " new REVERSED MODS!\n")
                end
                hintText = hintText .. (
                    MOBILE and
                    STRING.trimIndent [[
                        To activate it, press and hold the blue area at the left side,
                        then click on a card that has a star on it.
                    ]] or
                    STRING.trimIndent [[
                        Activate it by right-clicking on a card that has a star on it.
                    ]]
                )
                MSG('dark', hintText, 6.26)
                SFX.play('notify')
            end
            if GAME.height >= 12600 then
                IssueSecret('fepsilon')
            end
        end

        -- Statistics
        STAT.maxFloor = max(STAT.maxFloor, GAME.floor)
        if GAME.roundHeight > STAT.maxHeight then
            STAT.maxHeight = GAME.roundHeight
            STAT.heightDate = os.date("%y.%m.%d %H:%M%p")
        end
        STAT.totalGame = STAT.totalGame + 1
        STAT.totalTime = roundUnit(STAT.totalTime + GAME.time, .001)
        STAT.totalFlip = STAT.totalFlip + GAME.totalFlip
        STAT.totalQuest = STAT.totalQuest + GAME.totalQuest
        STAT.totalPerfect = STAT.totalPerfect + GAME.totalPerfect
        STAT.totalAttack = STAT.totalAttack + GAME.totalAttack
        STAT.totalHeight = roundUnit(STAT.totalHeight + abs(GAME.roundHeight), .1)
        STAT.totalBonus = roundUnit(STAT.totalBonus + abs(GAME.heightBonus), .1)
        STAT.totalFloor = STAT.totalFloor + (GAME.floor - 1) + (GAME.negFloor - 1)
        STAT.totalGiga = STAT.totalGiga + GAME.gigaCount + GAME.teraCount
        if GAME.floor >= 10 then
            STAT.totalF10 = STAT.totalF10 + 1
            if GAME.floorTime <= 6.26 then
                STAT.clockOutCount = STAT.clockOutCount + 1
                SubmitAchv('clock_out', STAT.clockOutCount, true)
            end
        end

        -- ZP of current run
        local zpGain = GAME.roundHeight * GAME.comboZP
        TEXTS.zpChange:set(("%.0f ZP  (+%.0f%s)"):format(zpGain, 0, DailyActived and ", 260%" or ""))

        -- Daily
        if DailyActived then
            STAT.dzp = max(STAT.dzp, zpGain)
            STAT.peakDZP = max(STAT.peakDZP, STAT.dzp)
            STAT.dailyBest = max(STAT.dailyBest, zpGain)
            if GAME.floor >= 10 and GAME.comboStr:find('r') then
                if not STAT.dailyMastered then
                    STAT.dailyMastered = true
                    STAT.vipListCount = STAT.vipListCount + 1
                    SubmitAchv('vip_list', STAT.vipListCount)
                end
                if GAME.comboStr:count('r') >= 2 then
                    IssueAchv('its_kinda_rare')
                end
            end
            if not TestMode and SupportCurl then
                local curl =
                    SYSTEM == 'Windows' and [[curl -s -X POST https://vercel-leaderboard-one.vercel.app/api -H "Content-Type: application/json" -d "$1"]] or
                    [[curl -s -X POST https://vercel-leaderboard-one.vercel.app/api -H 'Content-Type: application/json' -d '$1']]
                if curl then
                    local json = JSON.encode {
                        hid = STAT.hid,
                        uid = STAT.uid,
                        combo = GAME.comboStr,
                        alt = GAME.roundHeight,
                        time = GAME.gigaTime and roundUnit(GAME.gigaTime, .001),
                    }
                    if SYSTEM == 'Windows' then json = json:gsub('"', [[\"]]) end
                    DAILYCMD = curl:repD(json)
                    ASYNC.runCmd('submitDaily', DAILYCMD)
                    MSG('dark', "Submitting Daily Challenge score...")
                end
            end
        end

        -- Update ZP
        local oldZP = STAT.zp
        local thres1 = zpGain * 16
        local thres2 = zpGain * 26
        local newZP = max(
            oldZP, -- won't drop
            oldZP < thres1 and oldZP + zpGain or
            thres1 + (oldZP - thres1) * (9 / 10) + (thres2 - thres1) * (1 / 10)
        )
        if DailyActived then newZP = MATH.clamp(newZP + (newZP - oldZP) * 1.6, newZP, 50 * zpGain) end
        local zpEarn = newZP - oldZP
        if zpEarn > 0 then
            TASK.new(function()
                TASK.yieldT(0.626)
                TWEEN.new(function(t)
                    TEXTS.zpChange:set(("%.0f ZP  (+%.0f%s)"):format(zpGain, zpEarn * t, DailyActived and ", 260%" or ""))
                end):setEase('InOutCubic'):setDuration(2):run()
                SFX.play('ratingraise', zpEarn ^ .5 / 60)
            end)
        end

        STAT.zp = newZP
        STAT.peakZP = max(STAT.peakZP, STAT.zp)
        SaveStat()

        -- Best
        local hand = GAME.getHand(true)
        local setStr = (GAME.anyUltra and 'u' or '') .. GAME.comboStr
        local oldPB = BEST.highScore[setStr]
        if GAME.roundHeight > oldPB then
            BEST.highScore[setStr] = GAME.roundHeight
            if #hand > 0 and oldPB < Floors[9].top and GAME.floor >= 10 then
                local t
                local size, color, duration
                if GAME.comboMP >= 8 and GAME.comboStr:count('r') >= 2 then
                    if not YOU_LOST_THE_GAME then YOU_LOST_THE_GAME = love.data.decompress('string', 'deflate', love.data.decode('string', 'base64', "NY5bboMwEEW3MgvIJib2BE9lbOoHKv1DgRaUBCi0XX/HlfJ5jubeO+8w9ftwXYdxOEVYf8d96pfP+3gccJuvN7Ev8JiPYV+3TcAWmMb7cEpwbPOyiPPwvffL8bHuDyGGr5++tJ0tVyYBqBxInzRFbzGxdwCBlEWuxRpsvQIwaJNQg05T7R3nGuA1ky0n7C4UnAegt8SuyhxNOc2hwuRDB5ACuqhIoqIpaH6OaKJSoDChsl2UzphDy604dI4NP//BlkLZx1BjRVoXd/GBYkJriz93MUqa8J8ar9B2TSTgCI4kDMkQyAd/")):split(',') end
                    t = YOU_LOST_THE_GAME[GAME.comboMP]
                    local p = (GAME.comboMP - 8) / 10
                    color = { COLOR.HSL(MATH.lerp(-.2, 0, p), 1, MATH.lerp(.626, .5, p)) }
                    size = GAME.comboMP == 18 and 2.6 or 1.626
                    duration = 12.6
                else
                    t = (GAME.anyUltra and "U-" or GAME.anyRev and "R-" or "") .. (#hand == 1 and "MOD" or "COMBO") .. " MASTERED"
                    size = 2.26
                    color = 'lC'
                    duration = 6.2
                end
                TEXT:add {
                    text = t,
                    x = 800, y = 226, k = size, fontSize = 70,
                    style = 'beat', inPoint = .26, outPoint = .62,
                    color = color, duration = duration,
                }
                SFX.play('worldrecord', 1, 0, Tone(#hand == 1 and -1 or 0))
            elseif GAME.floor >= 2 then
                TEXT:add {
                    text = "PERSONAL BEST",
                    x = 800, y = 226, k = 2.6, fontSize = 70,
                    style = 'beat', inPoint = .26, outPoint = .62,
                    color = 'lY', duration = 6.2,
                }
                SFX.play('personalbest', 1, 0, Tone(-.1))
            end
            SFX.play('applause', GAME.floor / 10)
            SaveBest()
        end

        local resStr = {}
        for i = 1, 7 do
            if GAME[PieceData[i].id] then TABLE.append(resStr, PieceData[i].text) end
        end
        if #resStr > 0 then ins(resStr, " ") end
        TEXTS.endHeight:set(TABLE.append(resStr, { COLOR.LL, ("%.1fm"):format(GAME.roundHeight) }))
        local endFloorStr
        if GAME.roundHeight >= 0 then
            if GAME.floor >= 10 and GAME.omega then
                endFloorStr = "FΩ: " .. Floors[11].name
            else
                endFloorStr = ("F$1: $2"):repD(GAME.floor, Floors[GAME.floor].name)
            end
        else
            endFloorStr = ("B$1: $2"):repD((GAME.negFloor - 1) % 10 + 1, NegFloors[GAME.negFloor].name)
        end
        if GAME.gigaspeedEntered then
            if GAME.gigaTime then
                local t = GAME.gigaTime < 60 and roundUnit(GAME.gigaTime, .001) .. "s" or STRING.time_simp(GAME.gigaTime)
                if endFloorStr:find("F10") then
                    endFloorStr = endFloorStr .. "   in " .. t
                else
                    endFloorStr = endFloorStr .. "    F10 in " .. t
                end
            end
            local l = {}
            for _, codepoint in STRING.u8codes(endFloorStr) do
                ins(l, STRING.u8char(codepoint))
            end
            local len = #l
            for i = len, 1, -1 do ins(l, i, { COLOR.HSV(lerp(.026, .626, i / len), GAME.gigaTime and .6 or .2, 1) }) end
            TEXTS.endFloor:set(l)
        else
            TEXTS.endFloor:set(endFloorStr)
        end

        local g = GAME
        TEXTS.endResult:set({
            COLOR.L, ("Time  %s"):format(STRING.time_simp(g.time)),
            COLOR.LD, g.gigaTime and ("  (F10 at %s)\n"):format(STRING.time_simp(g.gigaTime)) or "\n",
            COLOR.L, ("Flip  %d"):format(g.totalFlip),
            COLOR.LD, ("  (%.2f/s)\n"):format(g.totalFlip / g.time),
            COLOR.L, ("Quest  %d"):format(g.totalQuest),
            COLOR.LD, ("  (%.2f/s  %.1f%% Perf)\n"):format(g.totalQuest / g.time, g.totalPerfect / g.totalQuest * 100),
            COLOR.L, ("Speed  %.1fm/s"):format(roundUnit(g.height / g.time, .1)),
            COLOR.LD, ("  (max rank %d)\n"):format(g.peakRank),
            COLOR.L, ("Attack  %d"):format(g.totalAttack),
            COLOR.LD, ("  (%.1fapm  %dsurge)\n"):format(g.totalAttack / g.time * 60, g.totalSurge),
            COLOR.L, ("Bonus  " .. (g.heightBonus >= 2600 and "%.0fm" or "%.1fm")):format(g.heightBonus),
            COLOR.LD, abs(g.height) <= 2.6 and "" or ("  (%.1f%%  %.1fm/quest)"):format(g.heightBonus / g.height * 100, g.heightBonus / g.totalQuest),
        })

        local maxCSP = {}
        for i = 1, #GAME.rankTimer do ins(maxCSP, { i, GAME.rankTimer[i] }) end
        do
            local rankTimeCount = 11
            table.sort(maxCSP, function(a, b) return a[2] > b[2] end)
            local mainRank = maxCSP[1]

            table.sort(maxCSP, function(a, b) return a[1] < b[1] end)
            local bestPos, bestSum = 0, 0
            for i = min(mainRank[1], 26 - (rankTimeCount - 1)), max(mainRank[1] - (rankTimeCount - 1), 1), -1 do
                local sum = 0
                for j = i, i + (rankTimeCount - 1) do
                    sum = sum + maxCSP[j][2]
                end
                if sum > bestSum then
                    bestSum = sum
                    bestPos = i
                end
            end

            local rankTimeText = {}
            for i = bestPos + (rankTimeCount - 1), bestPos, -1 do
                ins(rankTimeText, { 1, 1, 1, max(maxCSP[i][2] / mainRank[2], .42) })
                ins(rankTimeText, ("Rank%d - %.1f″\n"):format(maxCSP[i][1], maxCSP[i][2]))
            end
            TEXTS.rankTime:set(rankTimeText)
        end

        GAME.refreshResultModIcon()

        -- Achievements
        local _t
        if not STAT.badge.mastery_1 then
            _t = 0
            for id in next, MD.name do if BEST.highScore[id] >= Floors[9].top then _t = _t + 1 end end
            if _t >= #MD.deck then IssueSecret('mastery_1') end
        end
        if not STAT.badge.mastery_2 then
            _t = 0
            for id in next, MD.name do if BEST.highScore['r' .. id] >= Floors[9].top then _t = _t + 1 end end
            if _t >= #MD.deck then IssueSecret('mastery_2') end
        end
        if not ACHV.false_god and MATH.sumAll(GAME.completion) >= 2 * #MD.deck then IssueAchv('false_god', STAT.badge.mastery_2) end

        if not ACHV.the_harbinger then
            local allRevF5 = true
            for id in next, MD.name do
                if BEST.highScore['r' .. id] < Floors[4].top then
                    allRevF5 = false
                    break
                end
            end
            if allRevF5 then
                IssueAchv('the_harbinger')
            end
        end

        SubmitAchv('contender', STAT.totalGame, true, true)
        SubmitAchv('clicker', STAT.totalFlip, true, true)
        SubmitAchv('elegance', STAT.totalPerfect, true, true)
        SubmitAchv('garbage_offensive', STAT.totalAttack, true, true)
        SubmitAchv('tower_climber', STAT.totalHeight, true, true)
        SubmitAchv('tower_regular', STAT.totalFloor, true, true)
        SubmitAchv('speed_player', STAT.totalGiga, true, true)
        _t = 0
        for id in next, MD.name do _t = _t + min(BEST.speedrun[id], 2600) end
        SubmitAchv('zenith_speedrunner', _t, true)
        _t = 0
        for id in next, MD.name do _t = _t + min(BEST.speedrun['r' .. id], 2600) end
        SubmitAchv('divine_speedrunner', _t, true)
        _t = 0
        for id in next, MD.name do _t = _t + BEST.highScore[id] end
        SubmitAchv('zenith_challenger', _t, true)
        _t = 0
        for id in next, MD.name do _t = _t + BEST.highScore['r' .. id] end
        SubmitAchv('divine_challenger', _t, true)

        SubmitAchv('multitasker', roundUnit(GAME.height * GAME.comboMP, .1))
        SubmitAchv('effective', zpGain)
        SubmitAchv('drag_racing', GAME.peakRank)
        SubmitAchv('space_race', GAME.peakRank * GAME.comboMP)
        table.sort(maxCSP, function(a, b) return a[1] > b[1] end)
        for i = 1, #maxCSP do
            if maxCSP[i][2] >= 60 then
                SubmitAchv('cruise_control', maxCSP[i][1])
                break
            end
        end
        SubmitAchv('empty_box', GAME.achv_noResetH or GAME.roundHeight)
        SubmitAchv('the_perfectionist', GAME.achv_perfectH or GAME.roundHeight)
        SubmitAchv('sunk_cost', GAME.achv_demoteH or GAME.roundHeight)
        SubmitAchv('patience_is_a_virtue', GAME.achv_noManualCommitH or GAME.roundHeight)
        SubmitAchv(GAME.comboStr, GAME.roundHeight)
        local soat = SubmitAchv('the_spike_of_all_time', GAME.maxSpikeWeak)
        SubmitAchv('the_spike_of_all_time_plus', GAME.maxSpike, soat)
        SubmitAchv('moon_struck', MATH.roundUnit(abs(GAME.roundHeight - 2202.8), .1))
        if GAME.roundHeight >= 6200 then IssueSecret('fomg') end
        SubmitAchv('plonk', GAME.achv_plonkH or GAME.roundHeight)
        SubmitAchv('psychokinesis', GAME.achv_noManualFlipH or GAME.roundHeight)
        if GAME.floor < 10 then SubmitAchv('divine_rejection', GAME.roundHeight) end
        if GAME.heightBonus / GAME.height * 100 >= 260 then IssueAchv('fruitless_effort') end
        if GAME.comboStr == 'DP' then
            if VALENTINE then SubmitAchv('lovers_promise', GAME.roundHeight) end
        elseif GAME.comboStr == 'NH' then
            SubmitAchv('level_19_cap', GAME.achv_level19capH or GAME.roundHeight)
        elseif GAME.comboStr == 'AS' then
            SubmitAchv('talentless', GAME.achv_noKeyboardH or GAME.roundHeight)
        elseif GAME.comboStr == 'EXMS' then
            if GAME.totalQuest <= 40 then SubmitAchv('quest_rationing', GAME.roundHeight) end
        elseif GAME.comboStr == 'EXVL' then
            SubmitAchv('wax_wings', GAME.achv_demoteH or GAME.roundHeight)
        elseif GAME.comboStr == 'NHrGV' then
            SubmitAchv('clutch_main', GAME.achv_clutchQuest)
        elseif GAME.comboStr == 'ASDHMS' then
            SubmitAchv('the_escape_artist', GAME.achv_escapeQuest)
        elseif GAME.comboStr == 'ASDHrIN' then
            SubmitAchv('the_oblivious_artist', GAME.achv_obliviousQuest)
        elseif GAME.comboStr == 'rGV' then
            SubmitAchv('spotless', GAME.achv_noDamageH or GAME.roundHeight)
        elseif GAME.comboStr == 'rAS' then
            SubmitAchv('arrogance', GAME.achv_noPerfectH or GAME.roundHeight)
            SubmitAchv('fel_magic', GAME.achv_felMagicQuest)
        elseif GAME.comboStr == 'rDP' then
            SubmitAchv('overprotection', GAME.achv_protectH or GAME.roundHeight)
        elseif GAME.comboStr == 'rGVrINrMS' then
            SubmitAchv('the_masterful_juggler', GAME.achv_maxChain)
        elseif GAME.comboStr == 'DHVLrIN' then
            SubmitAchv('empurple', GAME.achv_noChargeH or GAME.roundHeight)
        elseif GAME.comboStr == 'EXMSNHVLrAS' then
            SubmitAchv('faltered', GAME.achv_noChargeH or GAME.roundHeight)
        elseif GAME.comboStr == 'ASDHDP' then
            SubmitAchv('a_mutual_agreement', GAME.achv_shareModH or GAME.roundHeight)
        elseif GAME.comboStr == 'ASDPVL' then
            SubmitAchv('the_cheaters', GAME.achv_noShareModH or GAME.roundHeight)
        elseif GAME.comboStr == 'VLrGV' then
            SubmitAchv('fickle_fuel', roundUnit(GAME.achv_altFromSurge, .1))
        elseif GAME.comboStr == 'ASDHEXGVINMSNHVLrDP' then
            if GAME.floor >= 10 then IssueAchv('dusty_memories') end

            -- elseif GAME.comboStr == 'ASDHNHVL' then
            --     if GAME.achv_totalResetCount == 0 then
            --         SubmitAchv('minimalism', GAME.achv_maxChain)
            --     end
        end
        if M.EX < 2 and M.DP < 2 then
            SubmitAchv('speed_bonus', GAME.gigaCount + GAME.teraCount)
        end
        if M.DP > 0 then
            SubmitAchv('the_responsible_one', GAME.reviveCount)
            SubmitAchv('the_responsible_one_plus', GAME.reviveCount * GAME.comboMP)
            SubmitAchv('guardian_angel', GAME.achv_maxReviveH or 0)
            SubmitAchv('carried', GAME.achv_carriedH or GAME.roundHeight)
            if M.DP == 2 then
                SubmitAchv('the_unreliable_one', GAME.killCount)
                if GAME.floor < 10 and GAME.time >= 600 and GAME.fatigueSet == Fatigue.rDP then
                    IssueSecret('rDP_meta')
                end
            end
        end
        if GAME.comboStr == '' then
            SubmitAchv('zenith_explorer', GAME.roundHeight)
            SubmitAchv('supercharged', GAME.achv_maxChain)
            SubmitAchv('the_spike_of_all_time_minus', GAME.maxSpikeWeak)
        else
            local revCount = GAME.comboStr:count('r')
            local len_noDP = #hand - (M.DP == 1 and 1 or 0)
            if len_noDP >= 7 then
                local sw = {
                    'swamp_water_lite',
                    'swamp_water',
                    'swamp_water_pro',
                }
                local swFin
                for i = len_noDP, 7, -1 do
                    if revCount > 0 then swFin = SubmitAchv(sw[i - 6] .. '_plus', GAME.roundHeight, swFin) or swFin end
                    swFin = SubmitAchv(sw[i - 6], GAME.roundHeight, swFin) or swFin
                end
            end
            if revCount >= 2 and GAME.comboMP >= 8 then
                for m = GAME.comboMP, 8, -1 do
                    SubmitAchv(RevSwampName[min(m, #RevSwampName)]:sub(2, -2):lower(), GAME.roundHeight, m < GAME.comboMP)
                end
            end
        end
        SubmitAchv('zenith_explorer_plus', GAME.roundHeight)
        SubmitAchv('supercharged_plus', GAME.achv_maxChain)
    else
        TEXTS.endHeight:set("")
        TEXTS.endFloor:set("")
        TEXTS.endResult:set("")
        TEXTS.zpChange:set("")
        TEXTS.floorTime:set("")
        TEXTS.rankTime:set("")
        GAME.resIB:clear()
    end
    ReleaseAchvBuffer()

    GAME.setGigaspeedAnim(false)
    GAME.stopTeraspeed('fin')
    TASK.removeTask_code(task_startSpin)
    GAME.refreshLockState()
    GAME.refreshCurrentCombo()
    GAME.refreshPBText()
    TASK.unlock('dcTimer')
    GAME.refreshDailyChallengeText()
    GAME.prevPB = max(GAME.prevPB, GAME.height)

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

    if URM and GAME.height < 0 then
        PieceSFXID = 0
        GAME.nightcore = false
        GAME.slowmo = false
        GAME.glassCard = false
        GAME.fastLeak = false
        GAME.invisUI = false
        GAME.invisCard = false
        GAME.closeCard = false
    end
    if #GAME.secTime >= 10 and GAME.height < 0 then IssueSecret('universal_gravitation') end

    TWEEN.new(GAME.anim_setMenuHide_rev):setDuration(GAME.slowmo and 2.6 or .26):setUnique('uiHide'):run()
    GAME.refreshRPC()
    if reason ~= 'forfeit' then
        if STAT.startCD then TASK.lock('cannotStart', 1) end
        TASK.lock('cannotFlip', .626)
    end
    TASK.removeTask_code(Task_MusicEnd)
    TASK.new(Task_MusicEnd)
    collectgarbage()
end

local questStyle = {
    { k = 1.4, y = 175, a = 1 },
    { k = 1.1, y = 95,  a = .8 },
    { k = 0.9, y = 30,  a = .5 },
}
local questStyleDP = {
    { k = 1.4,  y = 175, a = 1 },
    { k = 1.3,  y = 95,  a = 1 },
    { k = 0.85, y = 30,  a = .7 },
}

local KBisDown = love.keyboard.isDown
function GAME.update(dt)
    GAME.spikeTimer = GAME.spikeTimer - dt
    if not GAME.playing then return end
    if TestMode then
        if KBisDown(']') then
            GAME.addXP(dt * GAME.rank * 8)
        elseif KBisDown('[') then
            GAME.xp = GAME.xp - dt * GAME.rank * 8
            if GAME.xp < 0 then GAME.xpLockTimer = 0 end
        end
        if KBisDown('=') then
            GAME.addHeight(dt * 260)
        elseif KBisDown('-') then
            GAME.addHeight(-dt * 260)
        end
        if KBisDown('backspace') and TASK.lock("test_freezeTimer", 1 / 26) then GAME.dmgTimer = GAME.dmgDelay end
        if KBisDown('rshift') and GAME.gravTimer then GAME.gravTimer = GAME.gravDelay end
        if KBisDown('\\') and TASK.lock("test_charge", 1 / 26) then
            GAME.chain = GAME.chain + 1
            if M.AS < 2 then
                TEXTS.chain:set(tostring(GAME.chain))
            else
                TEXTS.chain2:clear()
                TEXTS.chain2:addf(tostring(GAME.chain), 260, 'center', -130, -26)
            end
        end
        if KBisDown('return') and TASK.lock("test_eliminate", .26) then
            GAME.addHeight(15)
            SFX.play('elim')
        end
        if KBisDown('rshift') then
            GAME.time = GAME.time + dt * 62
        end
    end

    -- Quest animattion
    local style = M.DP == 0 and questStyle or questStyleDP
    for i = 1, #GAME.quests do
        local Q = GAME.quests[i]
        local k = dt / GAME.animDuration
        Q.y = expApproach(Q.y, style[i].y, k * 35)
        Q.k = expApproach(Q.k, style[i].k, k * 26)
        Q.a = expApproach(Q.a, style[i].a, k * 26)
    end

    -- Timers
    GAME.time = GAME.time + dt * GAME.timerMul
    local r = min(GAME.rank, 26)
    GAME.rankTimer[r] = GAME.rankTimer[r] + dt
    GAME.questTime = GAME.questTime + dt
    GAME.floorTime = GAME.floorTime + dt
    if M.GV > 0 and not GAME.gravTimer and (URM and M.GV == 2 or GAME.questTime >= 2.6) and GAME.questTime - dt < 2.6 then
        GAME.gravTimer = GAME.gravDelay
    end
    if M.EX == 2 and GAME.floorTime > 30 then
        GAME.dmgWrong = GAME.dmgWrong + 0.05 * dt
    end
    if GAME.reviveTime then
        GAME.reviveTime = GAME.reviveTime + dt
        if M.DP == 2 and GAME.reviveTime > 60 then
            GAME.dmgHeal = GAME.dmgHeal - 0.05 * dt
        end
    end
    if GAME.time >= GAME.fatigueSet[GAME.fatigue].time then
        GAME.nextFatigue()
    end

    -- Gigaspeed timer text
    if GAME.gigaspeed then
        TEXTS.gigatime:set(("%02d:%06.3f"):format(floor(GAME.time / 60), GAME.time % 60))
    end

    -- Time-based revive prompt
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

    -- Height change
    local releaseHeight = GAME.heightBuffer
    GAME.heightBuffer = max(MATH.expApproach(GAME.heightBuffer, 0, dt * 6.3216), GAME.heightBuffer - 600 * dt)
    releaseHeight = releaseHeight - GAME.heightBuffer

    local oldHeight = GAME.height

    GAME.height = GAME.height + releaseHeight

    if not GAME.DPlock then
        if M.EX == 2 then
            if not URM then
                GAME.height = GAME.height - dt * (GAME.floor * (GAME.floor + 1) + 10) / 20
                GAME.height = max(GAME.height, Floors[GAME.floor - 1].top)
            else
                if GAME.negFloor > 0 then
                    if GAME.negFloor >= 2 then
                        GAME.height = min(GAME.height, NegFloors[GAME.negFloor - 1].bottom)
                    end
                    if GAME.negFloor < 10 then
                        local f = max(GAME.floor, GAME.negFloor)
                        local fallSpeed = (f * (f + 1) + 10) / 20
                        GAME.height = GAME.height - dt * fallSpeed
                    end
                end
                if GAME.height < NegFloors[GAME.negFloor].bottom then GAME.downFloor() end
                if GAME.height < NegEvents[GAME.negEvent].h then GAME.nextNegEvent() end
            end
        else
            GAME.height = GAME.height + GAME.rank / 4 * dt * icLerp(1, 6, Floors[GAME.floor].top - GAME.height)
        end
    end

    GAME.roundHeight = floor(GAME.height * 10) / 10

    if GAME.height >= Floors[GAME.floor].top then GAME.upFloor() end

    if floor(GAME.height * 2) > floor(oldHeight * 2) and TASK.lock('speed_tick', .026) then
        SFX.play('speed_tick_' .. rnd(4), clampInterpolate(4, 1, 12, .8, GAME.rank))
    end

    -- XP Leak & Demote
    if GAME.xpLockTimer > 0 then
        GAME.xpLockTimer = GAME.xpLockTimer - dt
    else
        GAME.xp = GAME.xp - dt * GAME.leakSpeed * GAME.rank * (GAME.rank + 1) / 60
        if GAME.xp <= 0 then
            GAME.xp = 0
            if GAME.rank > 1 then
                GAME.rank = GAME.rank - 1
                GAME.xp = 4 * GAME.rank
                GAME.rankupLast = false
                if GAME.gigaspeed then
                    if GAME.rank < GigaSpeedReq[0] then
                        GAME.setGigaspeedAnim(false)
                        SFX.play('zenith_speedrun_end')
                        SFX.play('zenith_speedrun_end')
                        if MATH.between(GAME.height, Floors[9].top - 50, Floors[9].top) then IssueAchv('cut_off') end
                    elseif GAME.teramusic and GAME.rank < TeraMusicReq[0] then
                        GAME.stopTeraspeed('drop')
                    end
                end
                TEXTS.rank:set("R-" .. GAME.rank)
                SFX.play('speed_down', .4 + .5 * GAME.xpLockLevel / (GAME.xpLockLevelMax + 1))
                if not GAME.achv_demoteH then
                    GAME.achv_demoteH = GAME.roundHeight
                    if GAME.comboStr == 'EXVL' or GAME.floor >= 8 then SFX.play('btb_break') end
                end
            end
        end
    end

    -- Gravity
    if M.GV > 0 and GAME.gravTimer then
        GAME.gravTimer = GAME.gravTimer - dt
        if GAME.gravTimer <= 0 then
            GAME.faultWrong = false
            GAME.commit(true)
        end
    end

    if GAME.floor >= 10 then
        -- Omega floor
        if not GAME.omega and GAME.height >= 6200 then
            GAME.omega = true
            GAME.showFloorText("Ω", Floors[11].name, 6.2)
            SFX.play('zenith_levelup_a', 1, 0, Tone(1))
            PlayBGM('fomg')
            ins(GAME.secTime, GAME.floorTime)
            GAME.refreshSectionTime()
            GAME.floorTime = 0
        end

        -- KM line text
        if TASK.lock('kmTimer', 1) then
            TEXTS.lineKM:set(tostring(MATH.roundUnit(GAME.bgH, 1000)))
        end
    end

    -- Damage
    GAME.dmgTimer = GAME.dmgTimer - dt / GAME.dmgTimerMul
    if GAME.dmgTimer <= 0 then
        GAME.dmgTimer = GAME.dmgCycle
        GAME.takeDamage(GAME.dmgTime, 'time')
    end
end

_G.GAME = GAME
