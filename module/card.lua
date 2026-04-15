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
---@field burn number?
local Card = {}
Card.__index = Card
function Card.new(d)
    local obj = setmetatable({
        initOrder = d.initOrder,
        tempOrder = d.initOrder,
        id = d.id,
        lockfull = d.lockfull,

        lock = true,
        active = false,
        front = true,
        upright = true,
        easy = false,

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
        required = false, --main quest
        required2 = false, --duo quest (pink)
        inLastCommit = false,
        charge = 0,
        assistPenalty = 5,
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
local function tween_expertOn(t) GAME.exTimer = M.EX ~= 0 and t or (1 - t) end
local function task_refreshBGM()
    TASK.yieldT(.1)
    RefreshBGM()
end
---@param self Card 
---@param auto boolean i.e. was not manually selected
---@param key number? 1 or nil = active/inactive 2 = reverse 3 = easy
function Card:setActive(auto, key)
    local eNHBlocksFaults = M.NH == -1 and true or false
    if not auto then
        GAME.spinCheck = false
        GAME.rollCheck = false
    end
    if TASK.getLock('cannotFlip') or GAME.playing and M.NH == 1 and not auto and self.active then
        self:flick()
        SFX.play('no')
        return
    end
    if (M.VL == 1 and not self.active) or (M.NH == -1 and (GAME.playing or (M.VL == 2 and not GAME.playing)) and self.active) then
        if not auto then
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
    -- Trevor Smithy
    elseif M.VL == -1 then
        SFX.play('combo_4', .626, 0, Tone(0))
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
    if not auto and not self.active and GAME.comboStr == 'eASeNH' and GAME.playing then
        GAME.noManualActivate = false
        --MSG("dark", "Manual activation")
    end
    -- Trevor Smithy
    self.active = not self.active -- the main flip
    --Closer Card
    if GAME.ecloseCard and GAME.playing and not auto then
        self.active = not self.active
        if not GAME.achv_noManualFlipH then
            GAME.achv_noManualFlipH = GAME.roundHeight
            if GAME.totalQuest >= 3 then SFX.play('btb_break') end
        end
        local leftCard
        local rightCard
        local mvl
        if M.VL == -1 then mvl = 1 else mvl = M.VL end
        --local baseDist = 110 + (M.EX > 0 and (URM and M.EX == 2 and -30 or -10) or 0) + mvl * 20 + (GAME.closeCard and -30 or GAME.ecloseCard and -50 or 0)
        local maxCardDistance = 1 + (M.EX == 2 and URM and 2 or M.EX == 2 and 1 or M.EX == 1 and 1 or 0) - mvl
        local otherCardActivated = false
        if self.tempOrder > 1 then leftCard = CD[self.tempOrder - 1] end
        if leftCard then
            if not leftCard.active and leftCard.required or leftCard.active and not leftCard.required then --if not active and needed, activate. if active and not needed, deactivate. if active and needed, don't do anything. if not active and not needed, don't do anything.
                leftCard.active = not leftCard.active
                otherCardActivated = true
                leftCard.assistPenalty = leftCard.active and min(leftCard.assistPenalty, 1) or 5
            end
        end
        if self.tempOrder < 9 then rightCard = CD[self.tempOrder + 1] end
        if rightCard then
            if not rightCard.active and rightCard.required or rightCard.active and not rightCard.required then --if not active and needed, activate. if active and not needed, deactivate. if active and needed, don't do anything. if not active and not needed, don't do anything.
                rightCard.active = not rightCard.active
                otherCardActivated = true
                rightCard.assistPenalty = rightCard.active and min(rightCard.assistPenalty, 1) or 5
            end
        end
        if maxCardDistance >= 2 then
            if self.tempOrder > 2 then leftCard = CD[self.tempOrder - 2] end
            if leftCard then
                if not leftCard.active and leftCard.required or leftCard.active and not leftCard.required then --if not active and needed, activate. if active and not needed, deactivate. if active and needed, don't do anything. if not active and not needed, don't do anything.
                    leftCard.active = not leftCard.active
                    otherCardActivated = true
                    leftCard.assistPenalty = leftCard.active and min(leftCard.assistPenalty, 2) or 5
                end
            end
            if self.tempOrder < 8 then rightCard = CD[self.tempOrder + 2] end
            if rightCard then
                if not rightCard.active and rightCard.required or rightCard.active and not rightCard.required then --if not active and needed, activate. if active and not needed, deactivate. if active and needed, don't do anything. if not active and not needed, don't do anything.
                    rightCard.active = not rightCard.active
                    otherCardActivated = true
                    rightCard.assistPenalty = rightCard.active and min(rightCard.assistPenalty, 2) or 5
                end
            end
            if maxCardDistance >= 3 then
                if self.tempOrder > 3 then leftCard = CD[self.tempOrder - 3] end
                if leftCard then
                    if not leftCard.active and leftCard.required or leftCard.active and not leftCard.required then --if not active and needed, activate. if active and not needed, deactivate. if active and needed, don't do anything. if not active and not needed, don't do anything.
                        leftCard.active = not leftCard.active
                        otherCardActivated = true
                        leftCard.assistPenalty = leftCard.active and min(leftCard.assistPenalty, 3) or 5
                    end
                end
                if self.tempOrder < 7 then rightCard = CD[self.tempOrder + 3] end
                if rightCard then
                    if not rightCard.active and rightCard.required or rightCard.active and not rightCard.required then --if not active and needed, activate. if active and not needed, deactivate. if active and needed, don't do anything. if not active and not needed, don't do anything.
                        rightCard.active = not rightCard.active
                        otherCardActivated = true
                        rightCard.assistPenalty = rightCard.active and min(rightCard.assistPenalty, 3) or 5
                    end
                end
                if maxCardDistance == 4 then
                    if self.tempOrder > 4 then leftCard = CD[self.tempOrder - 4] end
                    if leftCard then
                        if not leftCard.active and leftCard.required or leftCard.active and not leftCard.required then --if not active and needed, activate. if active and not needed, deactivate. if active and needed, don't do anything. if not active and not needed, don't do anything.
                            leftCard.active = not leftCard.active
                            otherCardActivated = true
                            leftCard.assistPenalty = leftCard.active and min(leftCard.assistPenalty, 4) or 5
                        end
                    end
                    if self.tempOrder < 6 then rightCard = CD[self.tempOrder + 4] end
                    if rightCard then
                        if not rightCard.active and rightCard.required or rightCard.active and not rightCard.required then --if not active and needed, activate. if active and not needed, deactivate. if active and needed, don't do anything. if not active and not needed, don't do anything.
                            rightCard.active = not rightCard.active
                            otherCardActivated = true
                            rightCard.assistPenalty = rightCard.active and min(rightCard.assistPenalty, 4) or 5
                        end
                    end
                end
            end
        end
        if not self.active and self.required then --if not active and needed, activate. if active and not needed, deactivate. if active and needed, don't do anything. if not active and not needed, don't do anything.
            self.active = not self.active
            self.assistPenalty = 0
        elseif self.active and not self.required then
            self.active = not self.active
            self.assistPenalty = 5
        elseif self.active and self.required and (self.touchCount == 0 or M.NH == -1 and self.touchCount <= 1) then
            --don't deselect a correct card
            self.assistPenalty = 0
        elseif not otherCardActivated then
            self.active = not self.active
            self.assistPenalty = 5
            if not eNHBlocksFaults then
                GAME.fault = true
            end
        end
    end

    local noSpin, revOn, easyOn
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
                if (self.required or self.required2) then
                    -- Trevor Smithy
                    GAME.addXP(M.VL == -1 and 2 or 0)
                end
            elseif not GAME.fault and not self.burn and not (eNHBlocksFaults) then
                GAME.fault = true
            end
        end
        if M.DP ~= 0 and not auto and self.id == 'DP' and self.active and not (URM and M.DP == 2) then
            if GAME.swapControl() then
                SFX.play('party_ready', .8)
            end
        end
        if not auto then
            -- Trevor Smithy
            if M.GV ~= 0 and not GAME.gravTimer then
                GAME.gravTimer = GAME.gravDelay
            end
            if M.AS > 0 then
                if self.burn then
                    if URM and M.NH == -1 then GAME.OSPActivated = true end
                    self.burn = false
                    TASK.removeTask_code(GAME.task_cancelAll)
                    local p = TABLE.find(CD, self) or 0
                    local l = { -3, -2, -1, 1, 2, 3 }
                    local coinFlip = rnd(1,2)
                    if M.NH ~= -1 then
                        CD[(p + table.remove(l, rnd(4, 6)) - 1) % #CD + 1]:setActive(true)
                        CD[(p + table.remove(l, rnd(1, 3)) - 1) % #CD + 1]:setActive(true)
                    elseif M.NH == -1 and coinFlip == 1 then
                        CD[(p + table.remove(l, rnd(4, 6)) - 1) % #CD + 1]:setActive(true)
                    elseif M.NH == -1 and coinFlip == 2 then
                        CD[(p + table.remove(l, rnd(1, 3)) - 1) % #CD + 1]:setActive(true)
                    end
                    GAME.achv_escapeBurnt = true
                    if M.AS == 2 then
                        if M.NH ~= -1 then
                            CD[(p + table.remove(l, rnd(3, 4)) - 1) % #CD + 1]:setActive(true)
                            CD[(p + table.remove(l, rnd(1, 2)) - 1) % #CD + 1]:setActive(true)
                        elseif M.NH == -1 and coinFlip == 1 then
                            CD[(p + table.remove(l, rnd(1, 2)) - 1) % #CD + 1]:setActive(true)
                        elseif M.NH == -1 and coinFlip == 2 then
                            CD[(p + table.remove(l, rnd(3, 4)) - 1) % #CD + 1]:setActive(true)
                        end
                        if GAME.floor < 10 and GAME.gigaspeed then GAME.achv_felMagicBurnt = true end
                        if not GAME.OSPActivated then
                            if URM then return GAME.takeDamage(1e99, 'wrong') end
                        else
                            GAME.takeDamage(GAME.fullHealth-(GAME.dmgWrong+0.1), 'wrong') 
                            GAME.fault = true
                            GAME.bonusRecoveryHealth = GAME.bonusRecoveryHealth + 3
                            GAME.dmgTimerMul = GAME.dmgTimerMul + 1
                            GAME.OSPActivated = false
                            for i = 1, #Cards do
                                if Cards[i].burn then
                                    Cards[i].burn = 8/9 + (GAME.floor)/9
                                end
                            end
                            if GAME[GAME.getLifeKey()] > 0.01 then
                                TEXT:add {
                                    text = 'CAREFUL THERE!',
                                    x = 800, y = 265, fontSize = 30, k = 1.5,
                                    style = 'score', duration = 5,
                                    inPoint = .1, outPoint = .26,
                                    color = 'lM',
                                }
                                IssueAchv('cheat_death')
                            end
                        end
                    end
                    SFX.play('wound')
                else
                    if M.NH == -1 then
                        self.burn = (M.AS == 1 and 1.5 + GAME.floor / 4) or (M.AS == 2 and not URM and 3 + GAME.floor / 2) or 1e99
                    else
                        self.burn = M.AS == 1 and 3 + GAME.floor / 2 or 1e99
                    end
                end
            end
        end
    else
        TASK.unlock('cannotStart')
        -- Trevor Smithy
        easyOn = self.active and (key == 3 or KBIsDown('lalt', 'ralt'))
        --
        revOn = self.active and (key == 2 or KBIsDown('lctrl', 'rctrl'))
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
        local wasEasy = M[self.id] == -1
        --M[self.id] = self.active and (revOn and 2 or 1) or 0
        -- Trevor Smithy
        M[self.id] = self.active and (revOn and 2 or easyOn and -1 or 1) or 0
        --

        -- if revOn then -- Limit only one Rev mod can be selected
        --     for _, C in ipairs(Cards) do
        --         if C.active and C ~= self then
        --             C:setActive(true)
        --         end
        --     end
        -- end
        -- Trevor Smithy
        --self.upright = not (self.active and revOn)
        self.upright = not (self.active and revOn or self.active and easyOn)
        self.easy = self.active and easyOn and not revOn
        --
        if revOn or wasRev then GAME.refreshRev() end
        TASK.removeTask_code(task_refreshBGM)
        TASK.new(task_refreshBGM)
        if wasRev and not revOn then self:spin() end
        -- Trevor Smithy
        if self.id == 'EX' then
            TWEEN.new(tween_expertOn):setDuration(M.EX ~= 0 and .26 or .1):run()
            TABLE.clear(HoldingButtons)
        elseif self.id == 'IN' then
            for _, C in ipairs(CD) do C:flip() end
            noSpin = (M.IN == 1 or M.IN == -1)
        end
        -- Trevor Smithy
        if easyOn or wasEasy then GAME.refreshEasy() end
        if wasEasy and not easyOn then self:spin() end
        
        --if self.id == 'EX' then
        --    TWEEN.new(tween_expertOn):setDuration(M.EX > 0 and .26 or .1):run()
        --    TABLE.clear(HoldingButtons)
        --elseif self.id == 'IN' then
        --    for _, C in ipairs(CD) do C:flip() end
        --    noSpin = M.IN == 1
        --end
        --
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
            GAME.glassCard or GAME.eglassCard and 'harddrop' or 'card_select' .. postfix, 1, 0,
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
    local re = (GAME.playing or self.upright or self.easy) and 0 or 3.1416

    if M.IN ~= 1 and M.IN ~= -1 then
        -- Normal
        ease = 'OutQuart'
        function animFunc(t)
            if self.easy then
                self.kx = -self.kx
            end
            self.ky = .9 + .1 * cos(t * 6.2832)
            self.r = t * (self.easy and -6.2832 or 6.2832)
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
local gc_draw, gc_mDraw, gc_mRect, gc_circle = gc.draw, GC.mDraw, GC.mRect, GC.circle
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
    if not playing and not (self.upright or self.easy) then gc_rotate(3.1416) end
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
                        if STAT.easyName then
                            if not (URM and self.id == 'EX' and M.EX == -1 and M.NH < 2 and M.MS < 2 and M.GV < 2 and M.VL < 2 and M.DH < 2 and M.IN < 2 and M.AS < 2 and M.DP < 2) then
                                r1, g1, b1 = 0, 1, 0          -- Green
                            else
                                r1, g1, b1 = 0.626, 0, 0      -- Dark Red (for Uneasy)
                            end
                        end
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
                        -- Trevor Smithy
                        elseif M.IN == -1 then
                            qt = qt + 1.5
                            a1 = clampInterpolate(1, 0, 2, .4, qt) +
                                clampInterpolate(1.2, 0, 2.6, .2, qt) * sin(qt * 26 - self.x * .0026) + 0.2
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
                        -- Trevor Smithy
                        elseif M.IN == -1 then
                            r2, g2, b2 = .942, .626, .872
                            qt = qt + 1.5
                            a2 = clampInterpolate(1, 0, 2, .2, qt) + 0.2
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
            if self.easy then
                if not (URM and self.id == 'EX' and M.EX == -1 and M.NH < 2 and M.MS < 2 and M.GV < 2 and M.VL < 2 and M.DH < 2 and M.IN < 2 and M.AS < 2 and M.DP < 2) then
                    r1, g1, b1 = 0, 1, 0          -- Green
                else
                    r1, g1, b1 = 0.626, 0, 0          -- Dark Red (for Uneasy)
                end
            elseif not self.upright then
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

    if (GAME.glassCard or GAME.eglassCard) and not (GAME.einvisCard) then
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
        if not GAME.invisCard and not (GAME.glassCard or GAME.eglassCard) then
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
            if GAME.einvisCard then
                local b = STAT.cardBrightness / 100
                gc_setColor(b,b,b,(STAT.cardBrightness / 100) ^ 2 * 0.26)
            end
            gc_draw(img, -img:getWidth() / 2, -img:getHeight() / 2)
            if img2 then
                gc_draw(img2, -img2:getWidth() / 2, -img2:getHeight() / 2)
            end
        elseif GAME.glassCard or GAME.eglassCard then
            local w, h = 240, 330
            gc_setColor((faceUp and ModData.textColor or ModData.color)[self.id])
            gc_setAlpha((STAT.cardBrightness / 100) ^ 2 * .26)
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
        end

        -- Outline (draw)
        if STAT.oldTransparentCard then
            if GAME.einvisCard then
                gc_setLineWidth(20)
                local temp = M.IN == 1 and 2 or M.IN == 2 and not URM and 3 or M.IN == 2 and URM and 4 or 1
                if self.required then 
                    gc_setColor(ModData.textColor[self.id]) 
                    if M.IN > 0 then
                        gc_setAlpha(1.26/temp + sin(love.timer.getTime() * 5.2/temp)/temp)
                    end
                    if STAT.oldHitbox and MOBILE then
                        gc_circle('fill', 0, 0, 40)
                    end
                else
                    gc_setColor(1,1,1)
                    gc_setAlpha(0.26/temp)
                end
                gc_mRect('line', 0, 0, 240 * 2 + 10, 330 * 2 + 10, 10)
            end
            if a1 then
                gc_setColor(r1, g1, b1, a1)
                gc_draw(activeFrame, 0, 0, 0, sign(self.kx), 1, frame1W, frame1H)
            end
            if a2 then
                gc_setColor(r2, g2, b2, a2)
                gc_draw(activeFrame2, 0, 0, 0, sign(self.kx), 1, frame2W, frame2H)
            end
        else
            if GAME.einvisCard then
                local temp = M.IN == 1 and 2 or M.IN == 2 and not URM and 3 or M.IN == 2 and URM and 4 or 1
                local width = 40
                local hand = TABLE.sort(GAME.getHand(false))
                local q1 = GAME.quests[1] and TABLE.sort(GAME.quests[1].combo)
                local q2 = M.DP ~= 0 and GAME.quests[2] and TABLE.sort(GAME.quests[2].combo)
                local q3 = M.DP == -1 and GAME.quests[3] and TABLE.sort(GAME.quests[3].combo)
                if self.required then 
                    gc_setColor(ModData.textColor[self.id]) 
                    if not self.active then
                        gc_setAlpha(1.26/temp + sin(love.timer.getTime() * 5.2/temp)/temp)
                        width = (9-temp)*5
                    end
                    if self.active and GAME.playing then
                        if (q1 and TABLE.equal(hand, q1))then
                            gc_setColor(0.26,1,0)
                        else
                            gc_setColor(1,1,0)
                        end
                        gc_setAlpha(min(1, 2/temp))
                        width = (9-temp)*5
                    end
                    if STAT.oldHitbox and MOBILE then
                        gc_circle('fill', 0, 0, 40)
                    end
                    gc_setLineWidth(width)
                    gc_mRect('line', 0, 0, 240 * 2 + width/2, 330 * 2 + width/2, width)
                elseif not self.required and self.active and GAME.playing and not ((q2 and TABLE.equal(hand, q2)) or (q3 and TABLE.equal(hand, q3))) then               
                    gc_setColor(1,0,0)
                    gc_setAlpha(min(1, 2/temp))
                    width = (9-temp)*5
                    gc_setLineWidth(width)
                    gc_mRect('line', 0, 0, 240 * 2 + width/2, 330 * 2 + width/2, width)
                end
                if self.required2 then
                    gc_setColor(1, 0.62, 0.9) 
                    if not self.active then
                        gc_setAlpha(1.26/temp + sin(love.timer.getTime() * 5.2/temp)/(2*temp))
                    end
                    if self.active and GAME.playing then
                        if (q2 and TABLE.equal(hand, q2)) or (M.DP == -1 and GAME[GAME.getLifeKey(true)] > 0 and q3 and q1 and TABLE.equal(hand, q3) and TABLE.equal(hand, q1)) then
                            gc_setColor(0.13,1,0)
                        else
                            gc_setColor(1,1,0)
                        end
                        gc_setAlpha(min(1, 3/temp))
                    elseif GAME.playing and (M.DP == -1 and GAME[GAME.getLifeKey(true)] > 0 and q3 and q1 and TABLE.equal(hand, q3) and TABLE.equal(hand, q1)) then
                        gc_setColor(0.13,1,0)
                    end
                    gc_setLineWidth(width/2)
                    gc_mRect('line', 0, 0, 240 * 2 - width-2, 330 * 2 - width-2, width/2-2)
                end
                if q3 and TABLE.find(q3, self.id) and self.active and GAME.playing then
                    if (q3 and TABLE.equal(hand, q3)) then
                        gc_setColor(0, 1, 0)
                    else
                        gc_setColor(1, 1, 0)
                    end
                    gc_setAlpha(min(1, 2/temp))
                    gc_setLineWidth(width/2)
                    gc_mRect('line', 0, 0, 240 * 2 - width*2-4, 330 * 2 - width*2-4, width/2-4)
                end
            end
            if a1 and not (GAME.einvisCard and GAME.playing) then
                gc_setColor(r1, g1, b1, a1)
                gc_draw(activeFrame, 0, 0, 0, sign(self.kx), 1, frame1W, frame1H)
            end
            if a2 and not (GAME.einvisCard and GAME.playing) then
                gc_setColor(r2, g2, b2, a2)
                gc_draw(activeFrame2, 0, 0, 0, sign(self.kx), 1, frame2W, frame2H)
            end
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
                local t = (self.upright or self.easy) and self.float or 1
                local blur = (FloatOnCard == self.initOrder or not self.upright) and 0 or -.2
                local x = lerp(155, 0, t)
                local y = lerp(-370, -330, t)
                local cr = lerp(60, 180, t)
                local revMastery = completion[self.id] == 2
                local ang = -t * 6.2832
                gc_scale(abs(1 / self.kx * self.ky), 1)
                -- Base star
                if self.upright or self.easy then
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
        gc_setColor(((GAME.glassCard or GAME.eglassCard) and ModData.color or ModData.textColor)[self.id])
        local active = playing and self.inLastCommit or not playing and self.active
        if M.EX <= 0 then
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
