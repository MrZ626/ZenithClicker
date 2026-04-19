---@type Zenitha.Scene
local scene = {}

local maskAlpha, cardShow
local card = GC.newCanvas(1200, 720)
local totalBadges = 22

local floor = math.floor

local baseColor = { .12, .26, .14 }
local areaColor = { .12, .23, .12 }
local titleColor = { COLOR.HEX("16582D") }
local textColor = { COLOR.HEX("54B06D") }
local scoreColor = { COLOR.HEX("B0FFC0") }
local setup = { stencil = true, card }

local crProgress = {
    f10 = 0,
    sr = 0,
    achvGet = 0,
    achvAll = 0,
}

local function getF10Completion()
    local s = 0
    for i = 1, #ModData.deck do
        local id = ModData.deck[i].id
        if BEST.highScore[id] >= Floors[9].top then s = s + 1 end
        if BEST.highScore['r' .. id] >= Floors[9].top then s = s + 1 end
    end
    return s
end
local function getSpeedrunCompletion()
    local s = 0
    for i = 1, #ModData.deck do
        local id = ModData.deck[i].id
        if BEST.speedrun[id] < 1e26 then s = s + 1 end
        if BEST.speedrun['r' .. id] < 1e26 then s = s + 1 end
    end
    return s
end
local function getAchvCompletion()
    local p, P = 0, 0
    for i = 1, #Achievements do
        local A = Achievements[i]
        if A.type == 'competitive' then
            P = P + 5
            if ACHV[A.id] then
                local rank = floor(A.rank(ACHV[A.id]))
                p = p + rank
            end
        end
    end
    return p, P
end
local function norm(x, k) return 1 + (x - 1) / (k * x + 1) end
local function calculateRating()
    local cap = 25000
    local cr = 0

    -- Best height (5K)
    cr = cr + 5000 * norm(MATH.icLerp(50, 6200, STAT.maxHeight), 6.2)

    -- Best time (5K)
    cr = cr + 5000 * norm(MATH.icLerp(420, 76.2, STAT.minTime), -.5)

    -- Mod completion (3K)
    cr = cr + 3000 * norm(MATH.icLerp(0, #ModData.deck * 2, crProgress.f10), .62)

    -- Mod speedrun (2K)
    cr = cr + 2000 * norm(MATH.icLerp(0, #ModData.deck * 2, crProgress.sr), .62)

    -- Zenith point (3K)
    cr = cr + 3000 * norm(MATH.icLerp(0, 26e4, STAT.zp), 4.2)

    -- Daily challenge (2K)
    cr = cr + 2000 * norm(MATH.icLerp(0, 6200, STAT.dzp), 2.6)

    -- Achievement (5K)
    cr = cr + 5000 * norm(MATH.icLerp(0, crProgress.achvAll, crProgress.achvGet), 2.6)

    -- ACHV Wreath (competitive achievement count)
    for i = 1, #Achievements do
        local A = Achievements[i]
        if A.type == 'competitive' then
            cap = cap + 1
            local r = A.rank(ACHV[A.id] or A.noScore or 0)
            if r == 5.9999 then
                cr = cr + 1
            end
        end
    end

    if cr >= 25000 then IssueSecret('champion', true) end

    return MATH.round(cr), cap
end

local sawMap = {
    { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0 },
    { 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0 },
}
local saw = { w = 30, h = 3 }
for y = 1, 3 do
    for x = 1, 30 do
        if sawMap[y][x] == 1 then
            table.insert(saw, { 'fRect', x - 1, y - 1, 1, 1 })
        end
    end
end
saw = GC.load(saw)
saw:setFilter('nearest', 'nearest')
saw:setWrap('repeat', 'repeat')
local sawQuad = GC.newQuad(0, 0, 180, 3, saw)
local bannerQuad = GC.newQuad(0, 220, 512, 256, TEXTURE.logo)
local function dblMidDraw(obj, x, y)
    GC.mDraw(obj, x, y)
    GC.setAlpha(.626)
    GC.mDraw(obj, x, y + 2.6)
end
local t30, t50
function RefreshProfile()
    if t30 then
        t30:release()
        t50:release()
    end
    t30 = GC.newText(FONT.get(30))
    t50 = GC.newText(FONT.get(50))

    ---@diagnostic disable
    local pnlColor = TABLE.copy(baseColor)
    local boxColor = TABLE.copy(areaColor)
    local lblColor = TABLE.copy(titleColor)
    local textColor = TABLE.copy(textColor)
    local scoreColor = TABLE.copy(scoreColor)
    ---@diagnostic enable

    if GAME.anyRev then
        pnlColor[1], pnlColor[2] = pnlColor[2], pnlColor[1]
        boxColor[1], boxColor[2] = boxColor[2], boxColor[1]
        lblColor[1], lblColor[2] = lblColor[2], lblColor[1]
        textColor[1], textColor[2] = textColor[2], textColor[1]
        scoreColor[1], scoreColor[2] = scoreColor[2], scoreColor[1]
    end

    GC.setCanvas(setup)
    GC.origin()
    GC.clear(pnlColor[1], pnlColor[2], pnlColor[3], 0)

    -- Banner
    GC.setColor(.42, .42, .42)
    GC.draw(TEXTURE.logo, bannerQuad, 0, 10, 0, 1200 / 512, 150 / 256)

    -- Main panel & frame
    GC.setColor(pnlColor)
    -- base
    GC.rectangle('fill', 0, 720, 1200, -560)
    -- deco
    GC.draw(saw, sawQuad, 0, 720 - 560, 0, 7.2, 7.2, 0, 3)
    -- top ribbon (badges)
    GC.setColor(boxColor)
    GC.rectangle('fill', 0, 210, 1200, 60)
    -- bottom ribbon
    GC.rectangle('fill', 0, 720, 1200, -90)
    -- github link
    FONT.set(50)
    GC.setColor(scoreColor)
    GC.printf("↗  VIEW FULL RECORDS", 0, 640, 1200, 'center')
    -- bottom dark
    GC.setColor(0, 0, 0, .3)
    GC.rectangle('fill', 0, 720, 1200, -3)
    -- right dark
    GC.setColor(0, 0, 0, .15)
    GC.rectangle('fill', 1200, 720, -3, -560)
    GC.draw(TEXTURE.transition, 1200, 720 - 560, -1.5708, .626, -3)
    -- left light
    GC.setColor(1, 1, 1, .15)
    GC.rectangle('fill', 0, 720, 3, -560)
    GC.draw(TEXTURE.transition, 0, 720 - 560, -1.5708, .626, 3)

    -- X
    FONT.set(30)
    GC.setColor(COLOR.DL)
    GC.print("CLOSE", 1068 - 10, 45 - 3, 0, 1.2)

    -- PFP
    local avatar = AVATAR or TEXTURE.stat.avatar
    GC.setColor(1, 1, 1)
    GC.stc_setComp()
    GC.stc_rect(30, 0, 120, 120, 6)
    GC.draw(avatar, 30, 0, 0, 120 / math.min(avatar:getDimensions()))
    GC.stc_stop()

    -- ID
    FONT.set(30)
    GC.print(("Joined " .. STAT.joinDate):upper(), 165, 96, 0, .7)
    FONT.set(50)
    GC.setColor(COLOR.L)
    GC.print(STAT.uid, 165, 18, 0, 1.2)

    -- Time
    GC.ucs_move(1065, 165)
    GC.setColor(boxColor)
    GC.rectangle('fill', 0, 0, 110, 40, 5)
    GC.setColor(1, 1, 1)
    FONT.set(30)
    GC.mStr(STAT.totalTime <= 60000 and
        { scoreColor, floor(STAT.totalTime / 60), textColor, "min" }
        or { scoreColor, floor(STAT.totalTime / 3600), textColor, "H" },
        55, 0)
    GC.ucs_back()

    -- Small badges
    local badgeCount = 0
    local badges = TABLE.sort(TABLE.getKeys(STAT.badge), function(a, b)
        return (BadgeData[a] or BadgeData[0]).prio < (BadgeData[b] or BadgeData[0]).prio
    end)
    for i = 1, #badges do
        local id = badges[i]
        if TEXTURE.stat.badges[id] then
            badgeCount = badgeCount + 1
            GC.mDraw(TEXTURE.stat.badges[id], 6 + 52 * badgeCount, 242, 0, 50 / math.max(TEXTURE.stat.badges[id]:getDimensions()))
            local bd = BadgeData[id] or BadgeData[0]
            scene.widgetList[badgeCount].floatText = bd.name .. "\n" .. bd.desc
            scene.widgetList[badgeCount]:reset()
            scene.widgetList[i]:setVisible(true)
        end
    end
    for i = badgeCount + 1, totalBadges do
        scene.widgetList[i]:setVisible(false)
    end

    -- Clicker Badge
    if STAT.clicker then
        GC.setColor(1, 1, 1)
        GC.mDraw(TEXTURE.stat.clicker, 970, 182, 0, .626)
        local rating, cap = calculateRating()
        local clickerLV = 0
        if STAT.totalTime >= 3600 * 26 then clickerLV = clickerLV + 1 end
        if STAT.maxHeight >= 10000 and STAT.minTime <= 42 then clickerLV = clickerLV + 1 end
        if MATH.sumAll(GAME.completion) == 18 then clickerLV = clickerLV + 1 end
        if rating >= 25000 then clickerLV = clickerLV + 1 end
        if rating == cap then clickerLV = clickerLV + 1 end
        for i = 0, clickerLV - 1 do
            GC.mDraw(TEXTURE.stat.clicker_star, 879 - i * 34, 182, 0, .626)
        end
    end

    -- Introduction
    GC.ucs_move(25, 280)
    GC.setColor(boxColor)
    GC.rectangle('fill', 0, 0, 1150, 80)
    FONT.set(30)
    GC.setColor(lblColor)
    GC.print("ABOUT  ME", 7, 2, 0, .8)
    GC.setColor(textColor)
    GC.print(STAT.aboutme, 15, 35, 0, .8)
    GC.ucs_back()

    GC.setLineWidth(2)

    local bw, bh = 370, 120

    -- Rating
    local rating, cap = calculateRating()
    GC.ucs_move(25, 370)
    GC.setColor(boxColor)
    GC.rectangle('fill', 0, 0, bw, bh)
    FONT.set(30)
    GC.setColor(rating <= 25000 and lblColor or textColor)
    GC.line(7, bh - 30, bw - 7, bh - 30)
    GC.setColor(lblColor)
    GC.print("CLICKER  LEAGUE", 7, 2, 0, .8)
    -- Number
    t30:set(
        rating >= cap and "THE CHOSEN ONE." or
        rating >= 25000 and "THE VERY BEST!" or
        rating >= 24500 and "ALMOST THERE!" or
        rating >= 23800 and "YOU ARE GETTING THERE!" or
        rating >= 22050 and "YOU'RE NOT FAR OFF." or
        "CALCULATED FROM CAREER"
    )
    GC.mDraw(t30, bw / 2, 105, 0, .7)
    t50:set(tostring(rating))
    GC.setColor(scoreColor)
    dblMidDraw(t50, bw / 2, bh / 2 - 4)
    -- CR
    t30:set("CR")
    GC.setColor(scoreColor)
    dblMidDraw(t30, bw / 2 + t50:getWidth() / 2 + t30:getWidth() / 2, bh / 2 + 4)
    -- Rank
    local rank =
        STAT.totalTime / 60 + STAT.totalFloor / 9 + STAT.totalGiga / 2 <= 62 and 0 or
        MATH.clamp(math.ceil(rating / 1400), 1, 18)
    local rankIcon = TEXTURE.stat.rank[rank]
    GC.setColor(1, 1, 1)
    GC.mDraw(rankIcon, bw / 2 - t50:getWidth() / 2 - 26, bh / 2, 0, 62 / rankIcon:getWidth())
    if rank > 0 then
        -- Progress Bar
        GC.setColor(rating <= 25000 and textColor or scoreColor)
        GC.line(7, bh - 30,
            MATH.lerp(7, bw - 7,
                rank <= 17 and rating % 1400 / 1400 or
                rating <= 25000 and MATH.iLerp(23800, 25000, rating) or
                MATH.iLerp(25000, cap, rating)),
            bh - 30
        )
    end
    GC.ucs_back()

    -- Height
    GC.ucs_move(412.5, 370)
    GC.setColor(boxColor)
    GC.rectangle('fill', 0, 0, bw, bh)
    FONT.set(30)
    GC.setColor(lblColor)
    GC.print("MAX  ALTITUDE", 7, 2, 0, .8)
    GC.line(7, bh - 30, bw - 7, bh - 30)
    GC.setColor(textColor)
    t30:set(STAT.heightDate)
    GC.mDraw(t30, bw / 2, 105, 0, .75)
    GC.setColor(scoreColor)
    t50:set(STAT.maxHeight <= 0 and "---" or tostring(STAT.maxHeight))
    dblMidDraw(t50, bw / 2, bh / 2 - 4)
    GC.setColor(textColor)
    t30:set(STAT.maxHeight <= 0 and "" or "M")
    dblMidDraw(t30, bw / 2 + t50:getWidth() / 2 + t30:getWidth() / 2, bh / 2 + 4)
    GC.ucs_back()

    -- Speedrun
    GC.ucs_move(800, 370)
    GC.setColor(boxColor)
    GC.rectangle('fill', 0, 0, bw, bh)
    FONT.set(30)
    GC.setColor(lblColor)
    GC.print("FASTEST  SPEEDRUN", 7, 2, 0, .8)
    GC.line(7, bh - 30, bw - 7, bh - 30)
    GC.setColor(textColor)
    t30:set(STAT.timeDate)
    GC.mDraw(t30, bw / 2, 105, 0, .75)
    GC.setColor(scoreColor)
    t50:set(STAT.minTime >= 1560 and "---" or tostring(STAT.minTime))
    dblMidDraw(t50, bw / 2, bh / 2 - 4)
    GC.setColor(textColor)
    t30:set(STAT.minTime >= 1560 and "" or "S")
    dblMidDraw(t30, bw / 2 + t50:getWidth() / 2 + t30:getWidth() / 2, bh / 2 + 4)
    GC.ucs_back()

    -- Career
    GC.ucs_move(25, 500)
    GC.setColor(boxColor)
    GC.rectangle('fill', 0, 0, 570, bh)
    FONT.set(30)
    GC.setColor(lblColor)
    GC.print("CAREER", 7, 2, 0, .8)
    GC.setColor(1, 1, 1)
    local maxComp = TABLE.countAll(GAME.completion, 0) == 9 and 9 or 18
    for _, l in next, {
        { t = { textColor, "1-Mod Ascent" },                                                      x = 26,  y = 33 },
        { t = { textColor, "1-Mod Speedrun" },                                                    x = 26,  y = 58 },
        { t = { textColor, "Achievements" },                                                      x = 26,  y = 83 },
        { t = { scoreColor, crProgress.f10 .. " / " .. maxComp },                                 x = 200, y = 33 },
        { t = { scoreColor, crProgress.sr .. " / " .. maxComp },                                  x = 200, y = 58 },
        { t = { scoreColor, crProgress.achvGet .. " / " .. crProgress.achvAll },                  x = 200, y = 83 },
        { t = { textColor, "Best Altitude" },                                                     x = 300, y = 8 },
        { t = { textColor, "Best Speedrun" },                                                     x = 300, y = 33 },
        { t = { textColor, "Zenith Points" },                                                     x = 300, y = 58 },
        { t = { textColor, "Daily Challenge" },                                                   x = 300, y = 83 },
        { t = { scoreColor, STAT.maxHeight <= 0 and "---" or MATH.round(STAT.maxHeight) .. "m" }, x = 470, y = 8 },
        { t = { scoreColor, STAT.minTime >= 1560 and "---" or MATH.round(STAT.minTime) .. "s" },  x = 470, y = 33 },
        { t = { scoreColor, MATH.round(STAT.zp / 1000), textColor, " kZP" },                      x = 470, y = 58 },
        { t = { scoreColor, MATH.round(STAT.dzp), textColor, " ZP" },                             x = 470, y = 83 },
    } do GC.print(l.t, l.x, l.y, 0, .75) end
    GC.ucs_back()
    scene.widgetList.peakZP.floatText = "Peak ZP: " .. MATH.round(STAT.peakZP) .. "\nPeak Daily ZP: " .. MATH.round(STAT.peakDZP)
    scene.widgetList.peakZP:reset()

    -- Full stats
    GC.ucs_move(605, 500)
    GC.setColor(boxColor)
    GC.rectangle('fill', 0, 0, 570, bh)
    FONT.set(30)
    GC.setColor(lblColor)
    GC.print("FULL  STATS", 7, 2, 0, .8)
    for _, l in next, {
        { k = "Game",    v = { scoreColor, STAT.totalGame },                                                       x = 26,  y = 33, d = 80 },
        { k = "Ascent",  v = { scoreColor, STAT.totalF10 },                                                        x = 26,  y = 58, d = 80 },
        { k = "Giga",    v = { scoreColor, STAT.totalGiga },                                                       x = 26,  y = 83, d = 80 },
        { k = "Flip",    v = { scoreColor, STAT.totalFlip },                                                       x = 194, y = 08, d = 82 },
        { k = "Quest",   v = { scoreColor, STAT.totalQuest },                                                      x = 194, y = 33, d = 82 },
        { k = "Perfect", v = { scoreColor, STAT.totalPerfect },                                                    x = 194, y = 58, d = 82 },
        { k = "Attack",  v = { scoreColor, STAT.totalAttack },                                                     x = 194, y = 83, d = 82 },
        { k = "Time",    v = { scoreColor, ("%dh%dm"):format(STAT.totalTime / 3600, STAT.totalTime % 3600 / 60) }, x = 380, y = 08, d = 80 },
        { k = "Floor",   v = { scoreColor, STAT.totalFloor },                                                      x = 380, y = 33, d = 80 },
        { k = "Height",  v = { scoreColor, floor(STAT.totalHeight * .001), textColor, " km" },                     x = 380, y = 58, d = 80 },
        { k = "Bonus",   v = { scoreColor, floor(STAT.totalBonus * .001), textColor, " km" },                      x = 380, y = 83, d = 80 },
    } do
        GC.setColor(textColor)
        GC.print(l.k, l.x, l.y, 0, .75)
        GC.setColor(1, 1, 1)
        GC.print(l.v, l.x + l.d, l.y, 0, .75)
    end
    GC.ucs_back()

    -- Watermark
    if TestMode then
        GC.ucs_move(600, 360)
        GC.setColor(1, 1, 1, .26)
        GC.mDraw(TEXTS.test, 0, 0, -.26, 10)
    end

    GC.setCanvas()
end

function scene.load()
    SetMouseVisible(true)
    maskAlpha, cardShow = 0, 0
    TWEEN.new(function(t)
        maskAlpha = t
    end):setDuration(.26):run():setOnFinish(function()
        TWEEN.new(function(t) cardShow = t end):setDuration(.1):run()
    end)

    crProgress.f10 = getF10Completion()
    crProgress.sr = getSpeedrunCompletion()
    crProgress.achvGet, crProgress.achvAll = getAchvCompletion()

    RefreshProfile()
end

function scene.keyDown(key, isRep)
    if isRep then return true end
    if (key == 'escape' or key == '`') and cardShow == 1 then
        SFX.play('menuclick')
        TWEEN.new(function(t)
            cardShow = 1 - t
        end):setDuration(.26):run():setOnFinish(function()
            TWEEN.new(function(t)
                maskAlpha = 1 - t
            end):setDuration(.26):run():setOnFinish(function()
                SCN.back('none')
            end)
        end)
    end
    ZENITHA._cursor.active = true
    return true
end

function scene.update(dt)
    SCN.scenes.tower.update(dt)
    for _, W in next, SCN.scenes.tower.widgetList do
        W:update(dt)
    end
end

function scene.draw()
    SCN.scenes.tower.draw()
    GC.replaceTransform(SCR.xOy)
    WIDGET.draw(SCN.scenes.tower.widgetList)
    SCN.scenes.tower.overDraw()
    GC.origin()
    GC.setColor(0, 0, 0, maskAlpha * .8)
    GC.rectangle('fill', 0, 0, SCR.w, SCR.h)

    if cardShow > 0 then
        GC.replaceTransform(SCR.xOy_m)
        GC.setColor(1, 1, 1, cardShow)
        local k = .9 + cardShow * .1
        GC.mDraw(card, 0, 0, 0, k * .67, k ^ 26 * .67)
    end
end

scene.widgetList = {
    WIDGET.new {
        name = 'peakZP', type = 'hint',
        pos = { .5, .5 }, x = -100, y = 150, w = 180, h = 35,
        color = COLOR.X,
        labelPos = 'topRight',
        labelDist = 2,
        floatFontSize = 30,
        floatText = "", -- Dynamic text
    },
    WIDGET.new {
        name = 'full', type = 'button_invis',
        pos = { .5, .5 }, x = 0, y = 210, w = 800, h = 60,
        onPress = function()
            if cardShow == 1 then
                SFX.play('menuconfirm')
                SCN.swapTo('records', 'none')
            end
        end,
    },
    -- CLOSE button
    WIDGET.new {
        name = 'close', type = 'button_invis',
        pos = { .5, .5 }, x = 344, y = -196, w = 100, h = 50,
        onClick = function() love.keypressed('escape') end,
    },
    -- Inside the profile card
    WIDGET.new {
        name = 'protect', type = 'button_invis',
        pos = { .5, .5 }, w = 820, h = 500,
    },
    -- Outside the profile card
    WIDGET.new {
        type = 'button_invis',
        pos = { .5, .5 }, w = 3500, h = 2600,
        onClick = function() love.keypressed('escape') end,
    },
}
for i = 1, totalBadges do
    table.insert(scene.widgetList, i, WIDGET.new {
        name = 'link', type = 'hint',
        text = "",
        pos = { .5, .5 }, x = -363 + 35 * (i - 1), y = -80, w = 35,
        color = COLOR.X,
        labelPos = 'topRight',
        floatFontSize = 30,
        floatText = "", -- Dynamic text
    })
end

return scene
