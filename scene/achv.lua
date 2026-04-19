---@type Zenitha.Scene
local scene = {}

local max, min = math.max, math.min
local floor, ceil, sin = math.floor, math.ceil, math.sin

local clr = {
    D = { COLOR.HEX '19311EFF' },
    L = { COLOR.HEX '4DA667FF' },
    T = { COLOR.HEX '6FAC82FF' },
}
local colorRev = false

AchvText = GC.newText(FONT.get(30))
local Achievements = Achievements
local M = GAME.mod

OverDevProgressText = "Open ACHV page to refresh the over-dev progress."

---@class EmptyAchv
---@field title string

---@class AchvItem
---@field id string
---@field name string
---@field desc string
---@field descWidth number
---@field rank number
---@field wreath? number
---@field progress number
---@field score table
---@field type string
---@field hidden boolean
---@field overDev boolean

---@type (AchvItem | EmptyAchv)[]
local achvList = {}
local scroll, scroll1 = 0, 0
local maxScroll = 0
local timer = 0
local whenItsReady = false
local hyper
local clearNotice
local overallProgress = {
    rank = { [0] = 0, 0, 0, 0, 0, 0 },
    wreath = { [0] = 0, 0, 0, 0, 0, 0, 0 },
    countStart = 0,
    ptGet = 0,
    ptAll = 0,
    ptText = "0/0 Pts",
}

local function nameSortLT(i1, i2) return i1.name < i2.name end
local function nameSortGT(i1, i2) return i1.name > i2.name end

function RefreshAchvList(canShuffle)
    overallProgress.rank = TABLE.new(0, 5)
    overallProgress.rank[0] = 0
    overallProgress.wreath = TABLE.new(0, 6)
    overallProgress.wreath[0] = 0
    overallProgress.ptGet = 0
    overallProgress.ptAll = 0
    TABLE.clear(achvList)
    local odCount, odCap = 0, 0
    for i = 1, #Achievements do
        local A = Achievements[i]
        if not A.id then
            table.insert(achvList, { title = A.hide() and "???" or A.title and A.title:upper() })
        else
            local rank, score, progress, wreath, overDev
            if TestMode or not ACHV[A.id] then
                score = "---"
            elseif not A.scoreFull then
                score = { COLOR.LL, A.scoreSimp(ACHV[A.id]) }
            else
                score = { COLOR.LL, A.scoreSimp(ACHV[A.id]), COLOR.DL, "   " .. A.scoreFull(ACHV[A.id]) }
            end
            if A.type == 'issued' then
                rank = not TestMode and ACHV[A.id] and 6 or 0
                progress = 0
                wreath = 0
            else
                local selfScore = (not TestMode and ACHV[A.id]) or A.noScore or 0
                local r = A.rank(selfScore)
                rank = floor(r)
                progress = r < 5 and r % 1 or r % 1 / .9999
                wreath = r >= 5 and floor(MATH.clampInterpolate(0, 0, .9999, 6, r % 1)) or 0
                if A.type ~= 'issued' then
                    overallProgress.rank[rank] = overallProgress.rank[rank] + 1
                    if wreath > 0 then overallProgress.wreath[wreath] = overallProgress.wreath[wreath] + 1 end
                    if A.type == 'competitive' then
                        overallProgress.ptGet = overallProgress.ptGet + floor(rank)
                        overallProgress.ptAll = overallProgress.ptAll + 5
                    end
                end
                local devScore = DevScore[A.id] or A.noScore or 0
                overDev = selfScore == devScore or A.comp(selfScore, devScore)
                odCap = odCap + 1
            end
            AchvText:set(A.desc)
            local hidden = A.hide() and not ACHV[A.id]
            local descWidth = hidden and 26 or AchvText:getWidth()
            table.insert(achvList, {
                id = A.id,
                name = hidden and "???" or A.name:upper(),
                desc = hidden and "???" or A.desc,
                descWidth = descWidth,
                rank = floor(rank),
                wreath = wreath,
                progress = progress,
                score = score,
                type = A.type,
                hidden = A.hide ~= FALSE,
                overDev = overDev,
            })
            if overDev then
                odCount = odCount + 1
            end
        end
    end
    if odCount >= odCap * .62 then IssueSecret('exceed_dev', true) end
    if odCount >= odCap * .26 then IssueSecret('exceed_dev_half', true) end
    OverDevProgressText = "ACHV scores better than Dev: " .. odCount .. "/" .. odCap
    if canShuffle then
        if M.NH == 2 then
            TABLE.foreach(achvList, function(v) return not v.id end, true)
        end

        if M.DH == 1 then
            for i = 1, #achvList do
                if achvList[i].name and #achvList[i].name > 4.2 then
                    local newStr
                    repeat
                        local cList = achvList[i].name:atomize()

                        local mode = math.random(3)
                        if mode == 1 or MATH.roll(.26) then
                            -- Swap 2
                            local r1, r2 = math.random(2, #cList - 1), math.random(2, #cList - 1)
                            cList[r1], cList[r2] = cList[r2], cList[r1]
                        end
                        if mode == 2 or MATH.roll(.26) then
                            -- Delete 20%
                            for _ = 1, floor(#cList * 0.20) do
                                table.remove(cList, math.random(2, #cList - 1))
                            end
                        end
                        if mode == 3 or MATH.roll(.26) then
                            -- Repeat 2
                            for _ = 1, #cList <= 8 and 2 or 1 do
                                local r = math.random(2, #cList - 1)
                                table.insert(cList, r, cList[r])
                            end
                        end
                        newStr = table.concat(cList)
                    until achvList[i].name ~= newStr
                    achvList[i].name = newStr
                end
            end
        elseif M.DH == 2 then
            for i = 1, #achvList do
                if achvList[i].name then
                    local a = achvList[i]
                    a.name =
                        a.name:sub(1, 1) ..
                        table.concat(TABLE.shuffle(a.name:sub(2, -2):atomize())) ..
                        a.name:sub(-1)
                end
            end
        end

        local s, e
        for i = 1, #achvList do
            if not s then
                if achvList[i].id then
                    s = i
                end
            elseif not e then
                if not achvList[i].id then
                    e = i - 1
                elseif i == #achvList then
                    e = i
                end
            end
            if e then
                local buffer = TABLE.sub(achvList, s, e)
                if M.MS > 0 then TABLE.shuffle(buffer) end
                if M.GV > 0 then table.sort(buffer, M.GV == 1 and nameSortLT or nameSortGT) end
                for j, a2 in next, buffer do achvList[s + j - 1] = a2 end
                s, e = nil, nil
            end
        end
    end

    if not TestMode then
        overallProgress.ptText = overallProgress.ptGet .. "/" .. overallProgress.ptAll .. " Pts"
        if overallProgress.ptGet < overallProgress.ptAll then
            for i = 0, 5 do
                if overallProgress.rank[i] > 0 then
                    overallProgress.countStart = i
                    break
                end
            end
        else
            for i = 0, 6 do
                if overallProgress.wreath[i] > 0 then
                    overallProgress.countStart = i
                    break
                end
            end
        end
    end
end

local function submit(id, score, silent, realSilent)
    if SubmitAchv(id, score, silent, realSilent) then TASK.yieldT(0.1) end
end
local function issue(id, silent)
    if IssueAchv(id, silent) then TASK.yieldT(0.1) end
end
local function refreshAchivement()
    if not STAT.uid:match('^ANON[-_]') or STAT.aboutme ~= "Click the Zenith!" then issue('identity') end
    if BEST.highScore.DP > 0 then issue('intended_glitch') end
    if BEST.highScore.ASDHEXGVINMSNHVLrDP > Floors[9].top then issue('dusty_memories') end
    local MD = ModData
    local sw = {
        'swamp_water_lite',
        'swamp_water',
        'swamp_water_pro',
    }
    local swFin
    local maxMMP, maxZP = 0, 0
    for setStr, h in next, BEST.highScore do
        setStr = setStr:gsub('^u', '')
        submit(setStr, h)
        local revCount = STRING.count(setStr, 'r')
        local count = (#setStr - revCount) / 2
        local len_noDP = count - (setStr:find('DP') and not setStr:find('rDP') and 1 or 0)
        if len_noDP >= 7 then
            for i = len_noDP, 7, -1 do
                if revCount > 0 then swFin = SubmitAchv(sw[i - 6] .. '_plus', h, swFin) or swFin end
                swFin = SubmitAchv(sw[i - 6], h, swFin) or swFin
            end
        end
        local mp = count + revCount
        if revCount >= 2 and mp >= 8 then
            for m = mp, 8, -1 do
                submit(RevSwampName[min(m, #RevSwampName)]:sub(2, -2):lower(), h, m < mp)
            end
        end
        maxMMP = max(maxMMP, h * mp)
        local l = {}
        for m in setStr:gmatch('r?%w%w') do l[m] = true end
        maxZP = max(maxZP, h * GAME.getComboZP(l))
    end
    submit('multitasker', maxMMP)
    submit('effective', maxZP)
    submit('zenith_explorer', BEST.highScore[''] or 0)
    submit('zenith_explorer', BEST.highScore[''] or 0)
    submit('zenith_speedrun', BEST.speedrun[''] or 2600)
    submit('zenith_explorer_plus', TABLE.maxAll(BEST.highScore) or 0)
    submit('zenith_speedrun_plus', TABLE.minAll(BEST.speedrun) or 2600)
    submit('contender', STAT.totalGame, true, true)
    submit('clicker', STAT.totalFlip, true, true)
    submit('elegance', STAT.totalPerfect, true, true)
    submit('garbage_offensive', STAT.totalAttack, true, true)
    submit('tower_climber', STAT.totalHeight, true, true)
    submit('speed_player', STAT.totalGiga, true, true)
    local _t
    _t = 0
    for id in next, MD.name do _t = _t + min(BEST.speedrun[id], 2600) end
    submit('zenith_speedrunner', _t, true)
    _t = 0
    for id in next, MD.name do _t = _t + min(BEST.speedrun['r' .. id], 2600) end
    submit('divine_speedrunner', _t, true)
    _t = 0
    for id in next, MD.name do _t = _t + BEST.highScore[id] end
    submit('zenith_challenger', _t, true)
    _t = 0
    for id in next, MD.name do _t = _t + BEST.highScore['r' .. id] end
    submit('divine_challenger', _t, true)

    if not ACHV.false_god and MATH.sumAll(GAME.completion) >= 2 * #MD.deck then issue('false_god', ACHV.subjugation) end

    if not ACHV.the_harbinger then
        local allRevF5 = true
        for id in next, MD.name do
            if BEST.highScore['r' .. id] < Floors[4].top then
                allRevF5 = false
                break
            end
        end
        if allRevF5 then
            issue('the_harbinger')
        end
    end

    RefreshAchvList()
end

function scene.load()
    SetMouseVisible(true)
    if GAME.anyRev ~= colorRev then
        colorRev = GAME.anyRev
        for _, C in next, clr do
            C[1], C[2] = C[2], C[1]
        end
    end

    if TASK.lock('achv_init') then
        TASK.new(refreshAchivement)
    else
        whenItsReady = URM and M.IN == 2 or MATH.roll(.01 + M.IN * .026)
    end

    hyper = M.EX > 0 or BgmPlaying == 'tera' or BgmPlaying == 'terar'

    RefreshAchvList(true)

    maxScroll = max(ceil((#achvList - 12) / 2) * 140, 0)
    clearNotice = false
end

function scene.unload()
    if clearNotice then
        TABLE.clear(AchvNotice)
    end
end

function scene.mouseMove(_, _, _, dy)
    if love.mouse.isDown(1, 2) then
        scroll = MATH.clamp(scroll - dy * (1 + M.VL), 0, maxScroll)
    end
end

function scene.touchMove(_, _, _, dy)
    scroll = MATH.clamp(scroll - dy * (1 + M.VL), 0, maxScroll)
end

function scene.keyDown(key, isRep)
    if isRep then return true end
    if key == 'escape' or key == 'tab' then
        SFX.play('menuclick')
        SCN.back('none')
    end
    ZENITHA._cursor.active = true
    return true
end

function scene.wheelMove(_, dy)
    scroll = MATH.clamp(scroll - dy * 100 * (1 + M.VL), 0, maxScroll)
end

function scene.update(dt)
    if timer < 2.6 then
        timer = timer + dt
        if timer > 2.6 then
            clearNotice = true
            timer = 0
        end
    end
    for mp = 8, 18 do
        if TASK.lock('revswamp_icon_' .. mp, 1.26 / (mp - 4)) then
            local name = RevSwampName[mp]:sub(2, -2):lower()
            local r = math.random(94, 126)
            TEXTURE.achievement.iconQuad[name]:setViewport(
                MATH.rand(.5, 15.5) * 256 - r, MATH.rand(.5, 5.5) * 256 - r,
                2 * r, 2 * r, 4096, 2048
            )
        end
    end
    if M.EX == 2 then scroll = min(scroll + .26, maxScroll) end
    local y0 = scroll1
    scroll1 = MATH.expApproach(scroll1, scroll, dt * 26)
    GAME.bgH = max(GAME.bgH + (y0 - scroll1) / 355, 0)
    GAME.height = GAME.bgH
end

local gc = love.graphics
local gc_replaceTransform, gc_translate = gc.replaceTransform, gc.translate
local gc_setColor, gc_rectangle, gc_polygon, gc_print, gc_printf = gc.setColor, gc.rectangle, gc.polygon, gc.print, gc.printf
local gc_ucs_move, gc_ucs_back = GC.ucs_move, GC.ucs_back
local gc_setAlpha, gc_mRect, gc_mDraw, gc_mDrawQ = GC.setAlpha, GC.mRect, GC.mDraw, GC.mDrawQ
local gc_stc_setComp, gc_stc_arc, gc_stc_stop = GC.stc_setComp, GC.stc_arc, GC.stc_stop
local gc_setBlendMode = GC.setBlendMode
function scene.draw()
    DrawBG(26)

    FONT.set(30)
    if whenItsReady then
        gc_replaceTransform(SCR.xOy)
        gc_translate(60, 0)
        gc_setColor(clr.D)
        gc_setAlpha(.626)
        gc_rectangle('fill', 400, 360, 680, 220)
        gc_setColor(COLOR.DL)
        gc_print("Zenith Clicker Achievement System When?", 420, 380)
        gc_setColor(COLOR.D)
        gc_rectangle('fill', 480, 435, 560, 50)
        gc_setColor(COLOR.lS)
        gc_polygon('fill',
            25 + 420, 435,
            420, 435 + 25,
            25 + 420, 435 + 50,
            -25 + 420 + 102, 435 + 50,
            420 + 102, 435 + 25,
            -25 + 420 + 102, 435
        )
        gc_setColor(COLOR.D)
        gc_print("MrZ", 444, 440)
        gc_setColor(COLOR.lD)
        gc_print("at 2025/3/18 (Tue)", 535, 440)
        gc_setColor(COLOR.lS)
        gc_print("When it's ready.", 482, 515)
    else
        -- Board
        gc_replaceTransform(SCR.xOy_m)
        gc_setColor(clr.D)
        gc_mRect('fill', 0, 0, 1260, 1200)

        -- Achievements
        local t = love.timer.getTime()
        local ea = (colorRev and -.5 or .5) * M.AS ^ 2 * t
        local ka = colorRev and -3.1416 or 3.1416
        local texture = TEXTURE.achievement
        local notAllRank5 = overallProgress.ptGet < overallProgress.ptAll
        gc_translate(0, -420 - scroll1)
        for i = 1 + 2 * max(floor(scroll1 / 140) - 1, 0), min(2 * (floor(scroll1 / 140) + 8), #achvList) do
            local a = achvList[i]
            if not a.id then
                if a.title then
                    gc_ucs_move(i % 2 == 1 and -605 or 5, floor((i - 1) / 2) * 140)
                    gc_setColor(0, 0, 0, .42)
                    gc_rectangle('fill', -25, 42, 1260, -10)
                    gc_setColor(clr.L)
                    gc_rectangle('fill', -25, 42, 1260, 3)
                    if colorRev then
                        gc_print(a.title, 10, 134, 0, 1.8, -1.8)
                    else
                        gc_print(a.title, 10, 62, 0, 1.8)
                    end
                    gc_ucs_back()
                end
            else
                local A = Achievements[a.id]
                if M.DP == 0 then
                    gc_ucs_move(i % 2 == 1 and -605 or 5, floor((i - 1) / 2) * 140)
                elseif M.DP == 1 then
                    gc_ucs_move(i % 2 == 1 and -600 or 0, floor((i - 1) / 2) * 140)
                else
                    gc_ucs_move(i % 2 == 1 and -626 or 26, floor((i - 1) / 2) * 140)
                end

                -- Bottom rectangle
                if hyper then
                    if overallProgress.countStart == 6 then
                        gc_setColor(COLOR.rainbow_dark(i / 2.6 - t * 2.6, .42))
                    elseif a.type == 'competitive' and (notAllRank5 and a.rank or a.wreath) == overallProgress.countStart then
                        gc_setColor(.26 + .1 * sin(t * 2.6 + ceil(i / 2) * 1.2), 0, 0, .626)
                    else
                        gc_setColor(0, 0, 0, .626)
                    end
                else
                    gc_setColor(0, 0, 0, .626)
                end
                gc_rectangle('fill', 0, 0, 600, 130)

                -- Flashing notice
                if AchvNotice[a.id] then
                    gc_setColor(1, 1, 1, .1 + .1 * sin(t * (6.2 + M.VL * 4.2)))
                    gc_rectangle('fill', 0, 0, 600, 130)
                end

                -- Badge base
                gc_setColor(1, 1, 1)
                gc_mDraw(texture.frame[a.rank], 65, 65, 0, .42)

                -- Progress ring
                if a.progress > 0 then
                    if colorRev then gc_setColor(COLOR.lR) end
                    if a.progress < 1 then
                        gc_stc_setComp()
                        gc_stc_arc('pie', 65, 65,
                            ea + -2.0944,
                            ea + -2.0944 + ka * a.progress,
                            63, 26)
                        gc_stc_arc('pie', 65, 65,
                            ea + 1.0472,
                            ea + 1.0472 + ka * a.progress,
                            63, 26)
                    end
                    gc_mDraw(texture.ring, 65, 65, 0, .42)
                    gc_mDraw(texture.ring, 65, 65, 3.1416, .42)
                    gc_stc_stop()
                end

                -- Glint
                if a.rank >= 1 then
                    gc_setBlendMode('add')
                    gc_setColor(1, 1, 1, .1 + .2 * sin(i * 2.6 + t * 2.1))
                    gc_mDraw(texture.glint_1, 65, 65, 0, .42)
                    gc_setColor(1, 1, 1, .1 + .2 * sin(i * 2.6 + t * 2.3))
                    gc_mDraw(texture.glint_2, 65, 65, 0, .42)
                    gc_setColor(1, 1, 1, .1 + .2 * sin(i * 2.6 + t * 2.6))
                    gc_mDraw(texture.glint_3, 65, 65, 0, .42)
                    gc_setBlendMode('alpha')
                end

                -- Icon
                local slice = texture.iconQuad[a.id]
                if slice and (a.rank > 0 or a.progress > 0) then
                    if a.rank > 0 then
                        gc_setColor(0, 0, 0, .872)
                    else
                        gc_setColor(1, 1, 1, .26)
                    end
                    gc_mDrawQ(texture.icons, slice or texture.iconQuad._undef, 65, 65, 0, .24)
                end

                -- Wreath
                if a.wreath > 0 then
                    gc_setColor(1, 1, 1)
                    gc_mDraw(texture.wreath[a.wreath], 65, 65, 0, .42)
                end

                -- Credit
                gc_setColor(colorRev and COLOR.dR or COLOR.LD)
                gc_printf(A.credit, 65, 113, 130 / .37, 'center', 0, .37, .37, 65 / .37)

                -- Tags
                local x = 600 - 15
                if A.ex then
                    gc_mDraw(texture.extra, x, 15, 0, .42)
                    x = x - 30
                end
                if a.hidden then
                    gc_mDraw(texture.hidden, x, 15, 0, .2)
                    x = x - 30
                end
                if A.type == 'event' then
                    gc_mDraw(texture.event, x, 15, 0, .2)
                    x = x - 30
                end
                if A.type == 'competitive' then
                    gc_mDraw(texture.competitive, x, 15, 0, .2)
                    x = x - 30
                else
                    gc_mDraw(texture.unranked, x, 15, 0, .2)
                    x = x - 30
                end

                -- Dev
                if a.overDev then
                    gc_setColor(1, 1, 1, .1)
                    gc_mDraw(texture.overDev, 565, 75, 0, .26)
                end

                -- Texts
                gc_setColor(AchvData[a.rank].fg2)
                gc_print(a.score, 130, 35, 0)
                gc_setColor(colorRev and COLOR.LR or COLOR.L)
                gc_print(a.name, 130, 7, 0, .7)
                if a.descWidth < 1050 then
                    gc_print(a.desc, 130, 77, 0, min(400 / a.descWidth, .4), .4)
                else
                    gc_printf(a.desc, 130, 73, 1050, 'left', 0, .4)
                end
                gc_setColor(colorRev and COLOR.dR or COLOR.LD)
                gc_print(A.quote, 130, a.descWidth <= 1050 and 98 or 103, 0, .42)

                -- Hidden covering
                if M.IN > 0 then
                    gc_setColor(clr.D)
                    gc_setAlpha(M.IN * (.3 + .1 * sin(ceil(i / 2) * 1.2 - t * 2.6)))
                    gc_rectangle('fill', 0, 0, 600, 130)
                end

                gc_ucs_back()
            end
        end
    end

    -- Top bar & title
    gc_replaceTransform(SCR.xOy_u)
    gc_setColor(clr.D)
    gc_rectangle('fill', -1300, 0, 2600, 70)
    gc_setColor(clr.L)
    gc_setAlpha(.626)
    gc_rectangle('fill', -1300, 70, 2600, 3)
    gc_replaceTransform(SCR.xOy_ul)
    gc_setColor(clr.L)
    FONT.set(50)
    if colorRev then
        gc_print("ACHIEVEMENTS", 15, 68, 0, 1, -1)
    else
        gc_print("ACHIEVEMENTS", 15, 0)
    end

    -- Badge (wreath) count
    if STAT.maxFloor >= 10 and not whenItsReady and not TestMode then
        gc_replaceTransform(SCR.xOy_ur)
        if overallProgress.ptGet < overallProgress.ptAll then
            for i = overallProgress.countStart, 5 do gc_print(overallProgress.rank[i], -1150 + 150 * i + 37, 5, 0, .9) end
            gc_printf(overallProgress.ptText, -360, 0, 350, 'right')
            gc_setColor(1, 1, 1)
            for i = overallProgress.countStart, 5 do
                gc_mDraw(TEXTURE.achievement.frame[i], -1150 + 150 * i, 35, 0, .26)
            end
        elseif overallProgress.countStart then
            if overallProgress.countStart == 6 then gc_print("THANKS FOR PLAYING.", -760, 0) end
            for i = overallProgress.countStart, 6 do gc_print(overallProgress.wreath[i], -1100 + 40 + 160 * i) end
            gc_setColor(1, 1, 1)
            for i = overallProgress.countStart, 6 do
                gc_mDraw(
                    i > 0 and TEXTURE.achievement.wreath[i] or TEXTURE.achievement.frame[5],
                    -1100 + 160 * i, 35, 0, .26
                )
            end
        end
    end

    -- Bottom bar & text
    gc_replaceTransform(SCR.xOy_d)
    gc_setColor(clr.D)
    gc_rectangle('fill', -1300, 0, 2600, -50)
    gc_setColor(clr.L)
    gc_setAlpha(.626)
    gc_rectangle('fill', -1300, -50, 2600, -3)
    gc_replaceTransform(SCR.xOy_dl)
    gc_setColor(clr.L)
    FONT.set(30)
    gc_print("VIEW YOUR ACHIEVEMENT PROGRESS!", 15, -45, 0, .85, 1)
end

scene.widgetList = {
    WIDGET.new {
        name = 'back', type = 'button',
        pos = { 0, 0 }, x = 60, y = 140, w = 160, h = 60,
        color = { .15, .15, .15 },
        sound_hover = 'menutap',
        fontSize = 30, text = "    BACK", textColor = 'DL',
        onClick = function() love.keypressed('escape') end,
    },
}

return scene
