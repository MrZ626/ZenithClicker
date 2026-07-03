---@type (fun():number)[]
local upgradeFunc = {
    [false] = function()
        for k in next, BEST.highScore do
            if k:find('rNH') or k:find('rMS') or k:find('rVL') or k:find('rAS') then
                BEST.highScore[k] = nil
            end
        end
        return 162
    end,
    [162] = function()
        TABLE.clear(BEST.speedrun)
        return 163
    end,
    [163] = function()
        STAT.maxFloor = BEST.maxFloor or 1
        BEST.maxFloor = nil
        return 166
    end,
    [166] = function()
        if type(STAT.sfx) == 'boolean' then STAT.sfx = STAT.sfx and 60 or 0 end
        if type(STAT.bgm) == 'boolean' then STAT.bgm = STAT.bgm and 100 or 0 end
        return 167
    end,
    [167] = function()
        STAT.dzp = STAT.dailyHS or 0
        STAT.dailyHS = nil
        return 168
    end,
    [168] = function()
        ACHV.mastery = nil
        ACHV.terminal_velocity = nil
        ACHV.false_god = nil
        ACHV.supremacy = nil
        ACHV.the_completionist = nil
        ACHV.sunk_cost, ACHV.sink_cost = ACHV.sink_cost, nil
        return 170
    end,
    [170] = function()
        ACHV.quest_rationing = nil
        return 171
    end,
    [171] = function()
        ACHV.worn_out = nil
        return 172
    end,
    [172] = function()
        ACHV.speedrun_speedrunning = ACHV.speedrun_speedruning
        return 173
    end,
    [173] = function()
        ACHV.cruise_control, ACHV.stable_rise = ACHV.stable_rise, nil
        ACHV.subjugation, ACHV.supremacy = ACHV.supremacy, nil
        ACHV.smooth_dismount, ACHV.somersault = ACHV.somersault, nil
        ACHV.omnipotence, ACHV.the_completionist = ACHV.omnipotence, nil
        return 174
    end,
    [174] = function()
        ACHV.overprotection, ACHV.overprotectiveness = ACHV.overprotection, nil
        return 175
    end,
    [175] = function()
        ACHV.petaspeed, ACHV.teraspeed = ACHV.teraspeed, nil
        return 176
    end,
    [176] = function()
        local banned
        if ACHV.love_hotel and ACHV.love_hotel < 2.6 then ACHV.love_hotel, banned = 6.2, true end
        if ACHV.unfair_battle and ACHV.unfair_battle < 4.2 then ACHV.unfair_battle, banned = 9.42, true end
        if banned then STAT.badge.rDP_meta = true end
        return 177
    end,
    [177] = function()
        if ACHV.skys_the_limit then IssueSecret('fomg', true) end
        if ACHV.superluminal then IssueSecret('superluminal', true) end
        if ACHV.clicking_champion then IssueSecret('champion', true) end
        if ACHV.mastery then IssueSecret('mastery_1', true) end
        if ACHV.terminal_velocity then IssueSecret('speedrun_1', true) end
        if ACHV.subjugation then IssueSecret('mastery_2', true) end
        if ACHV.omnipotence then IssueSecret('speedrun_2', true) end
        return 178
    end,
    [178] = function()
        for i = #STAT.badge, 1, -1 do
            STAT.badge[STAT.badge[i]] = true
            STAT.badge[i] = nil
        end
        local banned
        if ACHV.supercharged and ACHV.supercharged > 355 then ACHV.supercharged, banned = 355, true end
        if ACHV.supercharged_plus and ACHV.supercharged_plus > 420 then
            if MATH.between(ACHV.the_spike_of_all_time_plus, ACHV.supercharged_plus, ACHV.supercharged_plus + 260) then
                ACHV.the_spike_of_all_time_plus, banned = 420, true
            end
            ACHV.supercharged_plus, banned = 420, true
        end
        if banned then STAT.badge.rDP_meta = true end
        return 179
    end,
    [179] = function()
        if ACHV.perfect_speedrun then ACHV.perfect_speedrun = ACHV.perfect_speedrun * 75 / 70 end
        return 180
    end,
    [180] = function()
        ACHV.quest_rationing = ACHV.block_rationing
        ACHV.block_rationing = nil
        return 181
    end,
    [181] = function()
        ACHV.drag_racing, ACHV.petaspeed = ACHV.petaspeed, nil
        return 182
    end,
    [182] = function()
        STAT.peakDZP = math.max(STAT.peakDZP, STAT.dzp)
        STAT.peakZP = math.max(STAT.peakZP, STAT.zp)
        return 183
    end,
    [183] = function()
        ACHV.plonk = nil
        return 184
    end,
    [184] = function()
        if ACHV.moon_struck then ACHV.moon_struck = MATH.roundUnit(math.abs(ACHV.moon_struck - 2202.8), .1) end
        return 185
    end,
    [185] = function()
        STAT.badge.subluminal, STAT.badge.superluminal = STAT.badge.superluminal, nil
        if TABLE.minAll(BEST.speedrun) <= 42 then STAT.badge.superluminal = true end
        if TABLE.maxAll(BEST.highScore) >= 12600 then STAT.badge.fepsilon = true end
        if ACHV.divine_rejection then
            ACHV.divine_rejection = math.floor(ACHV.divine_rejection * 10) / 10
        end
        return 186
    end,
    [186] = function()
        for k, v in next, BEST.highScore do
            BEST.highScore[k] = math.floor(v * 10) / 10
        end
        return 187
    end,
    [187] = function()
        ACHV.dazed = nil
        return 188
    end,
    [188] = function()
        STAT.hid = STAT.hid:sub(1, 12) .. math.random(26000, 42000) .. math.random(42000, 62000)
        return 189
    end,
    [189] = function()
        if STAT.badge.zenith_and_nadir then
            STAT.badge.zenith_and_nadir = nil
            STAT.badge.universal_gravitation = true
        end
        return 190
    end,
    [190] = function()
        if ACHV.denying_the_dark then
            ACHV.return_to_the_light = true
        end
        return 191
    end,
    [191] = function()
        if not CONF then
            for k in next, CONF do
                if STAT[k] ~= nil then
                    CONF[k] = STAT[k]
                end
            end
        end
        return 192
    end,
    [192] = function()
        if STAT.srTimer_game > STAT.srTimer_life then
            STAT.srTimer_game, STAT.srTimer_life = STAT.srTimer_life, STAT.srTimer_game
        end
        return 193
    end,
    [193] = function()
        if STAT.totalHeight > 0 and STAT.totalKO == 0 then
            STAT.totalKO = math.floor(STAT.totalHeight * (6 / 2000))
            STAT.totalRevive = ((ACHV.the_responsible_one or 0) + (ACHV.the_unreliable_one or 0)) * 6
        end
        return 194
    end,
    [194] = function()
        ACHV.slayer_of_the_tower = math.min(ACHV.slayer_of_the_tower or 0, 42)
        return 195
    end,
    [195] = function()
        STAT.badge.exceed_dev_half, STAT.badge.exceed_dev = nil, nil
        return 196
    end,
    [196] = function()
        for k in next, CONF do STAT[k] = nil end
        return 197
    end,
    [197] = function()
        if (SR.star_9 or 1e99) < 60 then SR.star_9 = nil end
        if (SR.star_18 or 1e99) < 200 then SR.star_18 = nil end
        if (SR.clicker or 1e99) < 260 then SR.clicker = nil end
        if (SR.mod_up or 1e99) < 200 then SR.mod_up = nil end
        if (SR.mod_rev or 1e99) < 260 then SR.mod_rev = nil end
        if (SR.rank_ss or 1e99) < 260 then SR.rank_ss = nil end
        return 198
    end,
}

function Initialize(save)
    STAT.version, BEST.version = STAT.version or BEST.version, nil
    if STAT.version == nil then STAT.version = false end
    local oldVer = STAT.version
    while upgradeFunc[STAT.version] do
        STAT.version = upgradeFunc[STAT.version]()
    end

    -- Some initialization
    for i = 1, #Cards do
        local f10 = Floors[9].top
        local id = Cards[i].id
        local rid = 'r' .. id
        if BEST.highScore[rid] >= f10 then
            GAME.completion[id] = 2
        else
            for setStr, h in next, BEST.highScore do
                if h >= f10 and setStr:find(rid) then
                    GAME.completion[id] = 2
                    break
                end
            end
        end
        if GAME.completion[id] ~= 2 then
            if BEST.highScore[id] >= f10 then
                GAME.completion[id] = 1
            else
                for setStr, h in next, BEST.highScore do
                    if h >= f10 and (setStr:gsub('^u', ''):gsub('r', ''):find(id) or 0) % 2 == 1 then
                        GAME.completion[id] = 1
                        break
                    end
                end
            end
        end
    end

    -- Auto fixing
    local realBestHeight = math.max(STAT.maxHeight, TABLE.maxAll(BEST.highScore), 0)
    if STAT.maxHeight > realBestHeight + .1 then
        STAT.maxHeight = realBestHeight
        STAT.heightDate = "NO DATE"
    end
    local realBestTime = math.min(STAT.minTime, TABLE.minAll(BEST.speedrun), 2600)
    if STAT.minTime < realBestTime - .1 then
        STAT.minTime = realBestTime
        STAT.timeDate = "NO DATE"
    end
    for setStr in next, BEST.highScore do
        setStr = setStr:gsub('[ur]', '')
        local illegal
        for i = 1, #setStr, 2 do
            if not GAME.completion[setStr:sub(i, i + 1)] then
                illegal = true
                break
            end
        end
        if illegal then
            BEST.highScore[setStr] = nil
            BEST.speedrun[setStr] = nil
        end
    end
    local achvLost = ""
    for k in next, ACHV do
        if not Achievements[k] then
            ACHV[k] = nil
            achvLost = achvLost .. "[" .. (k) .. "]\n"
        end
    end
    if #achvLost > 0 then
        MSG('dark', "Achievements lost due to update:\n" .. achvLost:sub(1, #achvLost - 1), 6.26)
    end

    GAME.refreshRev()
    GAME.refreshLockState()
    GAME.refreshPBText()
    RefreshHelpText()
    love.window.setFullscreen(CONF.fullscreen)
    ApplySettings()
    GAME.refreshCursor()

    if save or STAT.version ~= oldVer then
        SaveConf()
        SaveStat()
        SaveBest()
        SaveAchv()
    end
end
