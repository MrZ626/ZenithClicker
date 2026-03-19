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

        x = 0,
        y = 0,
        kx = 1,
        ky = 1,
        size = .62,
        r = 0,
        tx = 0,
        ty = 0,
        visY = 0,
        visY1 = 0,

        float = 0,

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
        abs(x - self.tx) <= self.size * 240 and
        abs(y - self.ty) <= self.size * 330
end

local completion = GAME.completion
local KBIsDown = love.keyboard.isDown
local function tween_deckPress(t) DeckPress = 26 * (1 - t) end
local function tween_expertOn(t) GAME.exTimer = M.EX > 0 and t or (1 - t) end
local function task_refreshBGM()
    TASK.yieldT(.1)
    RefreshBGM()
end
function Card:setActive(auto, key)
    if TASK.getLock('cannotFlip') or GAME.playing and M.NH == 1 and not auto and self.active then
        self:flick()
        SFX.play('no')
        return
    end
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
    if GAME.playing then
        if not auto then
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
        end
        if M.DP > 0 and not auto and self.id == 'DP' and self.active and not (URM and M.DP == 2) then
            if GAME.swapControl() then
                SFX.play('party_ready', .8)
            end
        end
        if not auto then
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
    else
        TASK.unlock('cannotStart')
        revOn = self.active and (key == 2 or KBIsDown('lctrl', 'lalt', 'rctrl', 'ralt'))
        if revOn and completion[self.id] == 0 then
            revOn = false
            noSpin = true
            self.active = false
            self:shake()
            SFX.play('no')
            MSG('dark', "Reach F10 with this mod first!")
            return
        end
        local wasRev = M[self.id] == 2
        M[self.id] = self.active and (revOn and 2 or 1) or 0
        -- if revOn then -- Limit only one Rev mod can be selected
        --     for _, C in ipairs(Cards) do
        --         if C.active and C ~= self then
        --             C:setActive(true)
        --         end
        --     end
        -- end
        self.upright = not (self.active and revOn)
        if revOn or wasRev then GAME.refreshRev() end
        TASK.removeTask_code(task_refreshBGM)
        TASK.new(task_refreshBGM)
        if wasRev and not revOn then self:spin() end
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
            key and clampInterpolate(-200, -4.2, 200, 4.2, self.y - MY) or MATH.rand(-2.6, 2.6)
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
    TWEEN.tag_kill('shake_' .. self.id)
    self.front = not self.front
    local s, e = self.kx, self.front and 1 or -1
    local rs = self.r % 6.2832
    TWEEN.new(function(t)
        self.kx = lerp(s, e, t)
        self.r = lerp(rs, 0, t)
    end):setUnique('spin_' .. self.id):setEase('OutQuad'):setDuration(.26):run()
end

function Card:spin()
    TWEEN.tag_kill('shake_' .. self.id)
    local animFunc, ease
    local re = (GAME.playing or self.upright) and 0 or 3.1416
    if M.IN ~= 1 then
        -- Normal
        ease = 'OutQuart'
        function animFunc(t)
            self.ky = .9 + .1 * cos(t * 6.2832)
            self.r = t * 6.2832
            self.kx = cos((M.AS + 1) * t * 6.2832)
            if not self.front then
                self.kx = -self.kx
            end
        end
    else
        -- Flip only
        ease = 'OutInQuart'
        local s = self.r % 6.2832
        function animFunc(t)
            self.kx = cos(t * 6.2832)
            self.r = lerp(s, re, t)
            if not self.front then
                self.kx = -self.kx
            end
        end
    end
    TWEEN.new(animFunc):setUnique('spin_' .. self.id):setEase(ease):setDuration(M.IN == 2 and .62 or .42):run()
        :setOnKill(function()
            self.ky = 1
            self.r = re
            -- self.kx = self.front and 1 or -1
        end)
end

local bounceEase = { 'linear', 'inQuad' }
function Card:bounce(height, duration)
    TWEEN.tag_kill('shake_' .. self.id)
    TWEEN.new(function(t)
        self.y = self.ty + t * (t - 1) * height
    end):setUnique('bounce_' .. self.id):setEase(bounceEase):setDuration(duration):run()
end

function Card:revJump()
    local h = 355
    if URM and self.id == 'EX' then h = h * 1.626 end
    TWEEN.tag_kill('shake_' .. self.id)
    TWEEN.new(function(t)
        t = t * (t - 1) * 4
        self.y = self.ty + t * h
        self.size = .62 - .355 * t
    end):setUnique('revJump_' .. self.id):setEase(bounceEase):setDuration(.62 * (h / 355) ^ .5):run()
        :setOnFinish(function()
            local currentState = M[self.id]
            if currentState == 2 then
                TWEEN.new(tween_deckPress):setUnique('DeckPress'):setEase('OutQuad'):setDuration(.42):run()
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
                    x = self.x,
                    y = self.y,
                    t = 1,
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
    local s, e = self.kx, self.front and 1 or -1
    TWEEN.new(function(t)
        self.kx = lerp(s, e, t)
        self.r = (t - 1) * 3.1416
    end):setUnique('spin_' .. self.id):setEase('OutQuart'):setDuration(.52):run()
end

function Card:shake()
    local tag = 'shake_' .. self.id
    TWEEN.tag_kill(tag)
    self.r = MATH.coin(-.26, .26)
    local s, e = self.r, 0
    TWEEN.new(function(t)
        self.r = lerp(s, e, t)
    end):setTag(tag):setEase('OutBack'):setDuration(.26):run()
end

function Card:flick()
    TWEEN.new(function(t)
        self.size = lerp(.56, .62, t)
    end):setUnique('flick_' .. self.id):setEase('OutBack'):setDuration(.26):run()
end

local activeFrame = GC.newImage('assets/card/outline1.png')
local frame1W, frame1H = activeFrame:getWidth() / 2, activeFrame:getHeight() / 2
local activeFrame2 = GC.newImage('assets/card/outline2.png')
local frame2W, frame2H = activeFrame2:getWidth() / 2, activeFrame2:getHeight() / 2

function Card:update(dt)
    self.x = expApproach(self.x, self.tx, dt * 16)
    self.y = expApproach(self.y, self.ty, dt * 16)
    self.visY1 = expApproach(self.visY1, self.visY, dt * 26)
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
local gc_push, gc_pop = gc.push, gc.pop
local gc_translate, gc_scale = gc.translate, gc.scale
local gc_rotate, gc_shear = gc.rotate, gc.shear
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

function Card:draw()
    local texture = TEXTURE[self.id]
    local playing = GAME.playing
    local img, img2
    local faceUp
    if self.lock and self.lockfull then
        img = texture.lock
    else
        if M.IN == 2 then
            img = texture.back
        else
            faceUp = self.kx * self.ky > 0
            img = faceUp and texture.front or texture.back
        end
        if self.lock then
            img2 = texture.lock
        end
    end

    gc_push('transform')
    gc_translate(self.x, self.y + self.visY1)
    gc_rotate(self.r)
    if not playing and not self.upright then gc_rotate(3.1416) end
    gc_scale(abs(self.size * self.kx), self.size * self.ky)

    if self == CD[FloatOnCard] then
        -- EX scale
        if M.EX > 0 and love.mouse.isDown(1, 2) then gc_scale(.9) end
        -- Fake 3D
        local dx, dy = (MX - self.x) / (240 * self.size), (MY - self.y) / (330 * self.size)
        local d = (abs(dx) - abs(dy)) * .026
        gc_scale(min(1, 1 - d), min(1, 1 + d))
        local D = -sign(dx * dy) * abs(dx * dy) ^ .626 * .026
        gc_shear(D, D)
        gc_scale(1 - abs(D))
    end

    -- Outline (prepare)
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
                    r1, g1, b1 = .4 + .1 * sin(GAME.time * 42 - self.x * .0026), 0, 0
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
                                clampInterpolate(1.2, 0, 2.6, .2, qt) * sin(qt * 26 - self.x * .0026)
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

    if GAME.glassCard then
        local w, h = 240, 330
        gc_setColor((faceUp and ModData.textColor or ModData.color)[self.id])
        gc_setAlpha((STAT.cardBrightness / 100) ^ 2 * .872)
        gc_mRect('fill', 0, 0, w * 2, h * 2, 26)

        if self.burn then
            if URM and M.AS == 2 then
                gc_setColor(1, .42, .26)
            else
                gc_setColor(GAME.time % .16 < .08 and COLOR.lF or COLOR.Y)
            end
        else
            gc_setColor(1, 1, 1)
        end

        FONT.set(50)
        if faceUp then
            GC.scale(2.6)
            GC.mStr(self.id, 0, -42)
            GC.scale(1 / 2.6)
        else
            GC.scale(2)
            GC.mStr("TETR.IO", 0, -42)
            GC.scale(1 / 2)
        end

        gc_setColor(1, 1, 1, .62)
        gc_setLineWidth(4)
        gc_mRect('line', 0, 0, w * 2 - 3, h * 2 - 3, 26)

        -- Outline (draw)
        if a1 then
            gc_setLineWidth(52)
            gc_setColor(r1, g1, b1, a1)
            gc_mRect('line', 0, 0, w * 2 + 52, h * 2 + 52, 52)
        end
        if a2 then
            gc_setLineWidth(26)
            gc_setColor(r2, g2, b2, a2)
            gc_mRect('line', 0, 0, w * 2 + 26, h * 2 + 26, 39)
        end
    else
        -- Card
        if not GAME.invisCard then
            if self.burn then
                if URM and M.AS == 2 then
                    gc_setColor(1, .42, .26)
                else
                    gc_setColor(
                        GAME.time % .16 < .08 and
                        (faceUp and COLOR.LF or COLOR.lF) or
                        (faceUp and COLOR.lY or COLOR.Y)
                    )
                end
            else
                local b = STAT.cardBrightness / 100
                gc_setColor(b, b, b)
            end
            gc_draw(img, -img:getWidth() / 2, -img:getHeight() / 2)
            if img2 then
                gc_draw(img2, -img2:getWidth() / 2, -img2:getHeight() / 2)
            end
        end

        -- Outline (draw)
        if a1 then
            gc_setColor(r1, g1, b1, a1)
            gc_draw(activeFrame, 0, 0, 0, sign(self.kx), 1, frame1W, frame1H)
        end
        if a2 then
            gc_setColor(r2, g2, b2, a2)
            gc_draw(activeFrame2, 0, 0, 0, sign(self.kx), 1, frame2W, frame2H)
        end

        -- Menu UI
        if not playing then
            gc_push('transform')

            -- Rev Throb
            if not self.upright and GAME.revDeckSkin and faceUp then
                gc_setColor(1, 1, 1, ThrobAlpha.card)
                gc_setShader(SHADER.throb)
                gc_draw(img, -img:getWidth() / 2, -img:getHeight() / 2)
                gc_setShader()
            end

            -- Star
            if completion[self.id] > 0 then
                img = TEXTURE[self.active and (self.id == 'DP' and STAT.clicker and 'star2' or 'star1') or 'star0']
                local t = self.upright and self.float or 1
                local blur = (FloatOnCard == self.initOrder or not self.upright) and 0 or -.2
                local x = lerp(155, 0, t)
                local y = lerp(-370, -330, t)
                local cr = lerp(60, 180, t)
                local revMastery = completion[self.id] == 2
                local ang = -t * 6.2832
                gc_scale(abs(1 / self.kx * self.ky), 1)
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
            gc_pop()
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
end

return Card
