local max, min = math.max, math.min
local abs, rnd = math.abs, math.random
local sin, cos = math.sin, math.cos
local sign, lerp = MATH.sign, MATH.lerp
local expApproach, clampInterpolate = MATH.expApproach, MATH.clampInterpolate
local getTime = love.timer.getTime

local GAME = GAME
local M = GAME.mod
local CD = Cards

---@class Card
---@field burn false | number
local Card = {}
Card.__index = Card
function Card.new(d)
    ---@class Card
    local obj = setmetatable({
        initOrder = d.initOrder,
        tempOrder = d.initOrder,
        id = d.id,
        lockfull = d.lockfull,

        lock = true,
        active = false,
        front = true,
        upright = true,

        -- Posiition & Size
        x = 0,
        y = 0,
        size = .62,

        -- Display-only
        x1 = 0,         -- X anim
        y1 = 0,         -- Y anim
        dy_ms = 0,      -- delta Y for MS anim
        r_3d = 0,       -- 3D rotation
        r_3d_in = 0,    -- 3D rotation (for IN mod)
        r_2d_rev = 0,   -- 2D rotation (for reverse anim)
        r_2d_shake = 0, -- 2D rotation (for shake anim)
        float = 0,      -- mouse floating anim, 0-1

        touchCount = 0,
        burn = false,
        required = false,
        required2 = false,
        inLastCommit = false,
        charge = 0,
    }, Card)
    return obj
end

function Card:mouseOn(x, y)
    return
        abs(x - self.x) <= self.size * (480 / 2) and
        abs(y - self.y) <= self.size * (660 / 2)
end

local completion = GAME.completion
local KBisDown = love.keyboard.isDown
local function tween_deckPress(t) DeckPress = 26 * (1 - t) end
local function tween_expertOn(t) GAME.exTimer = M.EX > 0 and t or (1 - t) end
local function task_refreshBGM()
    TASK.yieldT(.1)
    RefreshBGM()
end
function Card:setActive(auto, key)
    -- NH interrupt
    if TASK.getLock('cannotFlip') or GAME.playing and M.NH == 1 and not auto and self.active then
        self:flick()
        SFX.play('no')
        return
    end

    -- VL interrupt
    if M.VL == 1 then
        if not self.active and not auto then
            self.charge = self.charge + 1
            SFX.play('clearline', .42)
            if self.charge < 1.2 then
                self:shake()
                SFX.play('combo_' .. rnd(2, 3), .626, 0, Tone(-2))
                return
            end
            SFX.play('combo_4', .626, 0, Tone(0))
            self.charge = 0
        end
    elseif M.VL == 2 then
        self.charge = self.charge + (auto and 3.55 or 1)
        if self.charge < 3.1 then
            SFX.play('clearline', .3)
            self:shake()
            if self.charge < 1.3 then
                SFX.play('combo_1', .626, 0, Tone(0))
            elseif self.charge < 2.2 then
                SFX.play('combo_3', .626, 0, Tone(-2))
            else
                SFX.play('combo_2', .626, 0, Tone(1))
            end
            return
        end
        if not auto then
            SFX.play('clearquad', .3)
            SFX.play('combo_4', .626, 0, Tone(0))
        end
        self.charge = 0
    end

    if GAME.currentTask then
        if self.active then
            GAME.incrementPrompt('cancel')
            if not auto then GAME.nixPrompt('keep_no_cancel') end
        else
            GAME.incrementPrompt('activate')
        end
        if not auto then
            if self.id ~= GAME.lastFlip then
                GAME.nixPrompt('flip_single')
            end
            GAME.incrementPrompt('flip_single')
        end
        GAME.incrementPrompt('flip')
    end
    if not auto then
        GAME.lastFlip = self.id
    end

    self.active = not self.active
    local noSpin, revOn
    if not GAME.playing then
        -- not in-game, update various global states
        TASK.unlock('cannotStart')
        revOn = self.active and (key == 2 or KBisDown('lctrl', 'lalt', 'rctrl', 'ralt'))
        if revOn and completion[self.id] == 0 then
            revOn = false
            noSpin = true
            self.active = false
            if STAT.maxFloor >= 10 then
                self:shake()
                SFX.play('no')
                MSG('dark', "Reach F10 with this mod first!")
            end
            return
        end
        local wasRev = M[self.id] == 2
        M[self.id] = self.active and (revOn and 2 or 1) or 0
        -- if revOn then for _, C in ipairs(CD) do if C.active and C ~= self then C:setActive(true) end end end -- Unique rev mod limit
        self.upright = not (self.active and revOn)
        if revOn or wasRev then GAME.refreshRev() end
        TASK.removeTask_code(task_refreshBGM)
        TASK.new(task_refreshBGM)
        if wasRev and not revOn then
            self:revCancel()
        end
        if self.id == 'EX' then
            TWEEN.new(tween_expertOn):setDuration(M.EX > 0 and .26 or .1):run()
            TABLE.clear(HoldingButtons)
        elseif self.id == 'IN' then
            for _, C in ipairs(CD) do C:flip() end
            noSpin = M.IN == 1
        end
        SCN.scenes.tower.widgetList.reset:setVisible(not GAME.zenithTraveler)
        GAME.hardMode = M.EX > 0 or GAME.anyRev and not URM
        GAME.refreshPBText()
        GAME.refreshRPC()
    elseif not auto then
        -- in-game manual flip, triggering effects
        self.touchCount = self.touchCount + 1
        GAME.totalFlip = GAME.totalFlip + 1
        if not GAME.achv_noManualFlipH then
            GAME.achv_noManualFlipH = GAME.roundHeight
            if GAME.totalQuest >= 3 then SFX.play('btb_break') end
        end
        if self.touchCount == 1 then
            if (self.required or self.required2) and not GAME.hardMode then
                GAME.addXP(M.VL == 1 and 2 or 1)
            end
        elseif not GAME.fault and not self.burn then
            GAME.fault = true
        end
        if M.DP > 0 and self.id == 'DP' and self.active and not (URM and M.DP == 2) then
            if GAME.swapControl() then
                SFX.play('party_ready', .8)
            end
        end
        if M.GV > 0 and not GAME.gravTimer then
            GAME.gravTimer = GAME.gravDelay
        end
        if M.AS > 0 then
            if self.burn then
                self.burn = false
                TASK.removeTask_code(GAME.task_cancelAll)
                local p = TABLE.find(CD, self) or 0
                local l = { -3, -2, -1, 1, 2, 3 }
                CD[(p + table.remove(l, rnd(4, 6)) - 1) % #CD + 1]:setActive(true)
                CD[(p + table.remove(l, rnd(1, 3)) - 1) % #CD + 1]:setActive(true)
                GAME.achv_escapeBurnt = true
                if M.AS == 2 then
                    CD[(p + table.remove(l, rnd(3, 4)) - 1) % #CD + 1]:setActive(true)
                    CD[(p + table.remove(l, rnd(1, 2)) - 1) % #CD + 1]:setActive(true)
                    if GAME.floor < 10 and GAME.gigaspeed then GAME.achv_felMagicBurnt = true end
                    if URM then return GAME.takeDamage(1e99, 'wrong') end
                end
                SFX.play('wound')
            else
                self.burn = M.AS == 1 and 3 + GAME.floor / 2 or 1e99
            end
        end
    end
    GAME.refreshCurrentCombo()
    GAME.refreshLayout()
    if auto then
        if self.active and revOn then self:revJump() end
        return
    end

    -- Sound and animation
    if self.active then
        local postfix = revOn and '_reverse' or ''
        SFX.play(
            GAME.glassCard and 'harddrop' or 'card_select' .. postfix, 1, 0,
            key and clampInterpolate(-200, -4.2, 200, 4.2, self.y1 - MY) or MATH.rand(-2.6, 2.6)
        )
        local toneName = 'card_tone_' .. ModData.name[self.id]
        local toneVol = GAME.playing and .8 + GAME.floor * .02 - (GAME.gigaspeed and .26 or 0) or 1
        if revOn then
            SFX.play(toneName .. postfix, toneVol, 0, Tone(0))
            if URM then
                TASK.new(function()
                    TASK.yieldT(.2)
                    SFX.play(toneName, toneVol * .8, 0, Tone(7))
                    TASK.yieldT(.2)
                    SFX.play(toneName, toneVol * .6, 0, Tone(7))
                end)
            end
        else
            SFX.play(toneName, toneVol, 0, Tone(0))
        end
        if revOn then
            self:revJump()
        elseif M.NH < 2 and not noSpin then
            self:spin()
        end
    else
        SFX.play('card_slide_' .. rnd(4))
        SFX.play('floor')
        SFX.play('hold')
    end
end

function Card:flip()
    self.front = not self.front
    local s, e = self.r_3d_in, self.front and 0 or 3.1416
    TWEEN.new(function(t)
        self.r_3d_in = lerp(s, e, t)
    end):setUnique('flip_' .. self.id):setEase('OutQuad'):setDuration((GAME.slowmo and 2.6 or 1) * .26):run()
end

function Card:spin()
    local re = (GAME.playing or self.upright) and 0 or 3.1416
    local ease = M.IN == 1 and 'OutInQuart' or 'OutQuart'
    local rot = (M.AS + 1) * 6.2832
    local duration = (GAME.slowmo and 2.6 or 1) * (M.IN == 2 and .62 or .42) * (1 + M.AS * .42)
    TWEEN.new(function(t)
        self.r_3d = t * rot
    end):setUnique('spin_' .. self.id):setEase(ease):setDuration(duration):run()
        :setOnKill(function()
            self.r_3d = re
        end)
end

local bounceEase = { 'linear', 'inQuad' }
function Card:bounce(height, duration)
    TWEEN.new(function(t)
        self.y1 = self.y + t * (t - 1) * height
    end):setUnique('bounce_' .. self.id):setEase(bounceEase):setDuration((GAME.slowmo and 2.6 or 1) * duration):run()
end

function Card:revJump()
    local h = 355
    if self.id == 'EX' then
        h = h * (URM and 1.626 or 1.26)
    elseif self.id == 'GV' then
        h = h * (URM and .42 or .62)
    end
    TWEEN.new(function(t)
        t = t * (t - 1) * 4
        self.y1 = self.y + t * h
        self.size = .62 - .355 * t
    end):setUnique('revJump_' .. self.id):setEase(bounceEase):setDuration((GAME.slowmo and 2.6 or 1) * .62 * (h / 355) ^ .5):run()
        :setOnFinish(function()
            local currentState = M[self.id]
            if currentState == 2 then
                TWEEN.new(tween_deckPress):setUnique('DeckPress'):setEase('OutQuad'):setDuration((GAME.slowmo and 2.6 or 1) * .42):run()
                if self.id ~= 'NH' then
                    for _, C in ipairs(CD) do
                        if C ~= self then
                            local r = rnd()
                            if self.id == 'EX' then
                                r = r * (URM and 12.6 or 2.6)
                            elseif self.id == 'MS' then
                                r = max(sign((r - .5)) * abs(r - .5) ^ .3333 / 1.5874 + .5, 0)
                            elseif self.id == 'GV' then
                                r = r * (URM and .0626 or .26)
                            end
                            C:bounce(lerp(62, 420, r), lerp(.42, .62, r))
                        end
                    end
                end
                local color = ModData.color[self.id]
                table.insert(ImpactGlow, {
                    r = (color[1] - .26) * .8,
                    g = (color[2] - .26) * .8,
                    b = (color[3] - .26) * .8,
                    x = self.x1,
                    y = self.y1,
                    t = 1,
                    tk = 1 / (GAME.slowmo and 2.6 or 1),
                })
                GAME.revDeckSkin = true
                GAME.bgXdir = MATH.coin(-1, 1)
                if not URM then
                    SFX.play('card_reverse_impact', 1, 0, Tone(0))
                else
                    local tone = ModData.ultraImpactTone[self.id]
                    if tone[1] then SFX.play('card_reverse_impact', .626, 0, Tone(tone[1])) end
                    if tone[2] then SFX.play('card_reverse_impact', .8, 0, Tone(tone[2])) end
                    if tone[3] then SFX.play('card_reverse_impact', 1, 0, Tone(tone[3])) end
                    SFX.play('card_tone_' .. ModData.name[self.id] .. '_reverse', .42, 0, Tone(-5))
                end
            else
                SFX.play('spin')
                if currentState == 0 then
                    self:bounce(100, .26)
                else
                    for _, C in ipairs(CD) do
                        if C ~= self then
                            local r = 1 - abs(C.initOrder - self.initOrder) / 8
                            if self.id == 'EX' then r = r * (URM and 12.6 or 2.6) end
                            if self.id == 'MS' then r = r * MATH.rand(.26, 1.26) end
                            if self.id == 'GV' then r = r * (URM and .0626 or .26) end
                            C:bounce(lerp(120, 420, r), lerp(.42, .62, r))
                        end
                    end
                    IssueAchv('smooth_dismount')
                end
            end
        end)
    local rot = self.id == 'AS' and 3 * 3.1416 or 3.1416
    local ease = self.id == 'GV' and 'OutQuart' or 'OutBack'
    TWEEN.new(function(t)
        self.r_2d_rev = t * rot
    end):setUnique('spin2D_' .. self.id):setEase(ease):setDuration((GAME.slowmo and 2.6 or 1) * .52):run()
end

function Card:revCancel()
    TWEEN.new(function(t)
        self.r_2d_rev = (1 - t) * 3.1416
    end):setUnique('spin2D_' .. self.id):setEase('OutQuart'):setDuration((GAME.slowmo and 2.6 or 1) * .26):run()
end

function Card:shake()
    self.r_2d_shake = MATH.coin(-.26, .26)
    local s, e = self.r_2d_shake, 0
    TWEEN.new(function(t)
        self.r_2d_shake = lerp(s, e, t)
    end):setUnique('shake_' .. self.id):setEase('OutBack'):setDuration((GAME.slowmo and 2.6 or 1) * .2):run()
end

function Card:flick()
    TWEEN.new(function(t)
        self.size = lerp(.56, .62, t)
    end):setUnique('flick_' .. self.id):setEase('OutBack'):setDuration((GAME.slowmo and 2.6 or 1) * .26):run()
end

local activeFrame = GC.newImage('assets/card/outline1.png')
local frame1W, frame1H = activeFrame:getWidth() / 2, activeFrame:getHeight() / 2
local activeFrame2 = GC.newImage('assets/card/outline2.png')
local frame2W, frame2H = activeFrame2:getWidth() / 2, activeFrame2:getHeight() / 2

function Card:update(dt)
    self.x1 = expApproach(self.x1, self.x, dt * 16)
    self.y1 = expApproach(self.y1, self.y + self.dy_ms, dt * 16)
    self.float = expApproach(self.float, CD[FloatOnCard] == self and 1 or 0, dt * 12)
    if self.burn then
        self.burn = self.burn - dt
        if self.burn <= 0 then
            self.burn = false
            SFX.play('wound_repel')
        end
    end
    if self.charge > 0 then
        self.charge = max(self.charge - dt, 0)
    end
end

local gc = love.graphics
local gc_setCanvas, gc_clear = gc.setCanvas, gc.clear
local gc_push, gc_pop = gc.push, gc.pop
local gc_origin, gc_translate, gc_scale = gc.origin, gc.translate, gc.scale
local gc_setColor, gc_setAlpha = gc.setColor, GC.setAlpha
local gc_setShader, gc_setLineWidth = GC.setShader, gc.setLineWidth
local gc_draw, gc_mDraw, gc_mRect = gc.draw, GC.mDraw, GC.mRect
local gc_blurCircle, gc_setBlendMode = GC.blurCircle, GC.setBlendMode

local iconFrame
xpcall(function()
    local suc, res = FILE.safeLoad('customAssets/mod_polygon.luaon', '-luaon')
    if not suc then error("!" .. res) end
    iconFrame = res
    assert(iconFrame, "")
    assert(type(iconFrame) == 'table', "!Invalid mod_polygon data")
    assert(#iconFrame % 2 == 0, "!mod_polygon must have an even number of points")
    assert(#iconFrame <= 52, "!mod_polygon must have at most 26 points")
    for i = 1, #iconFrame do assert(type(iconFrame[i]) == 'number', "!mod_polygon must be a list of numbers") end
    assert(next(iconFrame, #iconFrame) == nil, "!mod_polygon must be a pure array")
end, function(msg)
    if msg:find("!") then LOG('warn', msg:match("!(.*)")) end
    local x, y = 156.5, -245.5
    local r = 65
    iconFrame = {
        x - r, y - r,
        x + 7, y - r,
        x + r, y - 7,
        x + r, y + r,
        x - 12, y + r,
        x - r, y + 12,
    }
end)

local burnColor = {
    uAS = { 1, .42, .26 },
    AS1 = COLOR.R,
    AS2 = COLOR.lY,
}
local canvasW, canvasH = 600, 800

local meshVertices = {}
for y = 0, 1, .125 do
    for x = 0, 1, .125 do
        table.insert(meshVertices, { x, y })
    end
end
local meshVerticePosTemplate = {}
for i = 1, #meshVertices do
    table.insert(meshVertices[i], 1, 0)
    table.insert(meshVertices[i], 2, 0)
    table.insert(meshVerticePosTemplate, {
        lerp(-canvasW / 2, canvasW / 2, meshVertices[i][3]),
        lerp(-canvasH / 2, canvasH / 2, meshVertices[i][4]),
    })
end

local tempCanvas = GC.newCanvas(canvasW, canvasH)
local tempMesh = GC.newMesh(meshVertices, 'strip', 'dynamic')
do
    local mat = TABLE.newMat(0, 9, 9)
    for y = 1, 9 do for x = 1, 9 do mat[y][x] = (y - 1) * 9 + x end end
    local vMap = {}
    for y = 1, 7, 2 do
        for x = 1, 9 do
            table.insert(vMap, mat[y][x])
            table.insert(vMap, mat[y + 1][x])
        end
        for x = 9, 2, -1 do
            table.insert(vMap, mat[y + 2][x])
            table.insert(vMap, mat[y + 1][x - 1])
        end
    end
    table.insert(vMap, mat[9][1])
    tempMesh:setVertexMap(unpack(vMap))
end
tempMesh:setTexture(tempCanvas)
local glassCardText = setmetatable({}, {
    __index = function(t, k)
        t[k] = GC.newText(FONT.get(50), k)
        return t[k]
    end
})
local function rotate_point_around_axis(x, y, z, ax, ay, az, theta)
    local len = (ax * ax + ay * ay + az * az) ^ .5
    local kx, ky, kz = ax / len, ay / len, az / len
    local cos_t, sin_t = cos(theta), sin(theta)
    local dot = kx * x + ky * y + kz * z

    -- Rodrigues' rotation formula
    return
        x * cos_t + (ky * z - kz * y) * sin_t + kx * dot * (1 - cos_t),
        y * cos_t + (kz * x - kx * z) * sin_t + ky * dot * (1 - cos_t),
        z * cos_t + (kx * y - ky * x) * sin_t + kz * dot * (1 - cos_t)
end

function Card:draw()
    local texture = TEXTURE[self.id]
    local playing = GAME.playing
    local img, img2
    local rot3D = self.r_3d + self.r_3d_in
    local faceUp
    local glassW, glassH = 480, 660
    local finalRot = playing and self.r_2d_shake or self.r_2d_rev + self.r_2d_shake
    local finalSize = self == CD[FloatOnCard] and M.EX > 0 and love.mouse.isDown(1, 2) and .9 * self.size or self.size

    -- Select texture
    if self.lock and self.lockfull then
        img = texture.lock
    else
        if M.IN == 2 then
            img = texture.back
        else
            faceUp = math.floor(rot3D / 3.1416 + .5) % 2 == 0
            img = faceUp and texture.front or texture.back
        end
        if self.lock then
            img2 = texture.lock
        end
    end

    -- Calculating outline color
    local r1, g1, b1, a1
    local r2, g2, b2, a2
    if playing then
        if M.IN < 2 then
            if self.active then
                if self.required or self.required2 then
                    if self.required then
                        r1, g1, b1 = 1, .26, 0
                        a1 = .6 + .4 * self.float
                    end
                    if self.required2 then
                        r2, g2, b2 = .942, .626, .872
                        a2 = .6 + .4 * self.float
                    end
                else
                    r1, g1, b1 = .4 + .1 * sin(GAME.time * 42 - self.x1 * .0026), 0, 0
                    a1 = 1
                end
            else
                if self.required or self.required2 then
                    if self.required then
                        r1, g1, b1 = 1, 1, 1
                        local qt = GAME.questTime
                        if M.IN == 0 then
                            if GAME.hardMode then qt = qt - 1.5 end
                            a1 = clampInterpolate(1, 0, 2, .4, qt) +
                                clampInterpolate(1.2, 0, 2.6, .2, qt) * sin(qt * 26 - self.x1 * .0026)
                        elseif M.IN == 1 then
                            if GAME.hardMode then qt = qt * .626 end
                            a1 = -.1 + .4 * sin(3.1416 + qt * 3)
                        end
                    end
                    if self.required2 then
                        r2, g2, b2 = 1, 1, 1
                        local qt = GAME.questTime
                        if M.IN == 0 then
                            if GAME.hardMode then qt = qt - 1.5 end
                            a2 = clampInterpolate(1, 0, 2, .2, qt)
                        elseif M.IN == 1 then
                            if GAME.hardMode then qt = qt * .626 end
                            a2 = -.1 + .2 * sin(3.1416 + qt * 3)
                        end
                    end
                end
            end
        else
            if self.active then
                r1, g1, b1 = 1, .26, 0
                a1 = .6 + .4 * self.float
            end
        end
    else
        if self.active then
            if not self.upright then
                r1, g1, b1 = 0, .5, .7        -- Reversed
            elseif self.id ~= 'DP' then
                r1, g1, b1 = 1, .26, 0        -- Orange
            else
                r1, g1, b1 = .942, .626, .872 -- Pink
            end
            a1 = .6 + .4 * self.float
        end
        if self.required then
            r2, g2, b2 = 1, 0, .26
            a2 = getTime() % .1 < .0626 and 1 - (getTime() - GAME.finishTime) / 4.2
            if a2 and a2 <= 0 then self.required = false end
        end
    end

    -- Calculate 3D mesh
    local f = 2600 - 20 * CONF.rot3D_focal
    local t = CONF.rot3D_tilt * .0042
    local t2 = CONF.rot3D_tilt * 20
    local float = FloatOnCard == self.initOrder
    for i = 1, #meshVerticePosTemplate do
        local x, y, z = meshVerticePosTemplate[i][1], meshVerticePosTemplate[i][2], 0

        -- Real 3D rotation
        -- rotate around X
        local tilt = sin(self.r_3d) * t
        local c, s = cos(tilt), sin(tilt)
        y, z = y * c - z * s, y * s + z * c
        -- rotate around Y
        c, s = cos(rot3D), sin(rot3D)
        x, z = x * c - z * s, x * s + z * c

        if float and t2 > 0 then
            -- float tilting
            local dx, dy, dz = MX - self.x, MY - self.y, 0 -- Cursor vector
            local dist = (dx * dx + dy * dy) ^ .5
            if dist > 1 then
                local nx, ny, nz = 0, 0, 1 -- Normal vector
                x, y, z = rotate_point_around_axis(
                    x, y, z,
                    -dy, dx, 0, -- simplified cross product
                    -- ny * dz - nz * dy,
                    -- nz * dx - nx * dz,
                    -- nx * dy - ny * dx,
                    -dist / t2
                )
            end
        end

        meshVertices[i][1], meshVertices[i][2] = x / (z / f + 1), y / (z / f + 1)
    end
    tempMesh:setVertices(meshVertices)

    -- Hint layer
    if a1 or a2 then
        gc_push('all')
        gc_setCanvas(tempCanvas)
        gc_clear()
        gc_origin()
        gc_translate(canvasW / 2, canvasH / 2)

        gc_setBlendMode('alpha', 'premultiplied')
        if GAME.glassCard then
            if a1 then
                gc_setLineWidth(52)
                gc_setColor(r1, g1, b1, a1)
                gc_mRect('line', 0, 0, glassW + 52, glassH + 52, 52)
            end
            if a2 then
                gc_setLineWidth(26)
                gc_setColor(r2, g2, b2, a2)
                gc_mRect('line', 0, 0, glassW + 26, glassH + 26, 39)
            end
        else
            if a1 then
                gc_setColor(r1, g1, b1, a1)
                gc_draw(activeFrame, -frame1W, -frame1H)
            end
            if a2 then
                gc_setColor(r2, g2, b2, a2)
                gc_draw(activeFrame2, -frame2W, -frame2H)
            end
        end
        gc_pop()
        gc_draw(tempMesh, self.x1, self.y1, finalRot, finalSize)
    end

    -- Card layer
    gc_push('all')
    gc_setCanvas(tempCanvas)
    gc_clear()
    gc_origin()
    gc_translate(canvasW / 2, canvasH / 2)

    if GAME.glassCard then
        -- Fill
        gc_setColor((faceUp and ModData.textColor or ModData.color)[self.id])
        gc_setAlpha((CONF.cardBrightness / 100) ^ 2 * .872)
        gc_mRect('fill', 0, 0, glassW, glassH, 26)

        -- Text
        gc_setColor(
            self.burn and (
                URM and M.AS == 2 and burnColor.uAS or
                GAME.time % .16 < .08 and burnColor.AS1 or burnColor.AS2
            ) or CLR.W
        )
        FONT.set(50)
        if faceUp then
            gc_scale(2.6)
            gc_mDraw(glassCardText[self.id])
            gc_scale(1 / 2.6)
        else
            gc_scale(2)
            gc_mDraw(glassCardText["TETR.IO"])
            gc_scale(1 / 2)
        end

        -- Outline
        gc_setColor(1, 1, 1, .62)
        gc_setLineWidth(4)
        gc_mRect('line', 0, 0, glassW - 3, glassH - 3, 26)
    else
        -- Card
        if not GAME.invisCard then
            if self.burn then
                if URM and M.AS == 2 then
                    gc_setColor(burnColor.uAS)
                else
                    gc_setColor(
                        GAME.time % .16 < .08 and
                        (faceUp and COLOR.lR or COLOR.R) or
                        (faceUp and COLOR.lY or COLOR.Y)
                    )
                end
            else
                local b = CONF.cardBrightness / 100
                gc_setColor(b, b, b)
            end
            gc_draw(img, -img:getWidth() / 2, -img:getHeight() / 2)
            if img2 then
                gc_draw(img2, -img2:getWidth() / 2, -img2:getHeight() / 2)
            end
        end

        -- Rev Throb
        if not playing and not self.upright and GAME.revDeckSkin and faceUp then
            gc_setColor(1, 1, 1, ThrobAlpha.card)
            gc_setShader(SHADER.throb)
            gc_draw(img, -img:getWidth() / 2, -img:getHeight() / 2)
            gc_setShader()
        end
    end

    -- Star
    if not playing and completion[self.id] > 0 then
        img = TEXTURE[self.active and (self.id == 'DP' and STAT.clicker and 'star2' or 'star1') or 'star0']
        local t = self.upright and self.float or 1
        local blur = (FloatOnCard == self.initOrder or not self.upright) and 0 or -.2
        local x = lerp(155, 0, t)
        local y = lerp(-370, -330, t)
        local cr = lerp(60, 180, t)
        local revMastery = completion[self.id] == 2
        local ang = -t * 6.2832
        -- Base star
        if self.upright then
            gc_setColor(.26, .26, .26)
            gc_setBlendMode('add')
            gc_blurCircle(blur, x, y, cr)
            if revMastery then gc_blurCircle(blur, -x, -y, cr) end
            gc_setBlendMode('alpha')
            gc_setColor(1, 1, 1)
            gc_mDraw(img, x, y, ang, lerp(.16, .42, t))
            if revMastery then gc_mDraw(img, -x, -y, ang, lerp(.16, .42, t)) end
        else
            gc_setColor(.6, .1, .1)
            gc_setBlendMode('add')
            gc_blurCircle(blur, x, y, cr)
            if revMastery then gc_blurCircle(blur, -x, -y, cr) end
            gc_setBlendMode('alpha')
            gc_setColor(1, .62 + .1 * sin(getTime() * 42), .26)
            gc_mDraw(img, x, y, ang, lerp(.16, .42, t))
            if revMastery then gc_mDraw(img, -x, -y, ang, lerp(.16, .42, t)) end
        end
        -- Float star
        if not self.active then
            if revMastery then
                gc_setColor(.5, .5, .5, t)
                gc_setBlendMode('add')
                gc_blurCircle(blur, -x, -y, cr)
                gc_setBlendMode('alpha')
            end
            gc_setColor(1, 1, 1, t)
            local star1 = TEXTURE[self.id == 'DP' and STAT.clicker and 'star2' or 'star1']
            gc_mDraw(star1, x, y, ang, lerp(.16, .42, t))
            if revMastery then gc_mDraw(star1, -x, -y, ang, lerp(.16, .42, t)) end
        end
    end

    -- Icon cover
    if faceUp then
        gc_setColor((GAME.glassCard and ModData.color or ModData.textColor)[self.id])
        local active = playing and self.inLastCommit or not playing and self.active
        if M.EX == 0 then
            if active then
                gc_setLineWidth(6)
                gc.polygon('line', iconFrame)
                gc_setAlpha(.62)
                gc.polygon('fill', iconFrame)
            else
                gc_setLineWidth(4)
                gc.polygon('line', iconFrame)
            end
        elseif active then
            gc_setAlpha(.62)
            gc.polygon('fill', iconFrame)
        end
    end

    gc_pop()
    gc_draw(tempMesh, self.x1, self.y1, finalRot, finalSize)
end

return Card
