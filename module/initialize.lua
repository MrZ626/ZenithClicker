if SYSTEM == "Windows" or SYSTEM == "Linux" then
    SupportCurl = true
elseif SYSTEM == "Android" then
    SupportCurl = false
    local f = io.popen("curl --version", "r")
    if f then
        local res = f:read("*a")
        if res then
            if res:find("^curl") then
                SupportCurl = true
            end
        end
        f:close()
    end
end
if FILE.exist('data.luaon') then
    if not FILE.exist('best.luaon') then
        love.filesystem.write('best.luaon', love.filesystem.read('data.luaon'))
    end
    love.filesystem.remove('data.luaon')
end
if FILE.exist('conf.luaon') then love.filesystem.remove('conf.luaon') end
TABLE.update(BEST, FILE.safeLoad('best.luaon', '-luaon') or NONE)
TABLE.update(STAT, FILE.safeLoad('stat.luaon', '-luaon') or NONE)
TABLE.update(ACHV, FILE.safeLoad('achv.luaon', '-luaon') or NONE)
if FILE.exist('avatar') then
    local suc, res = pcall(GC.newImage, 'avatar')
    if suc then AVATAR = res end
end
function Initialize(save)
    if STAT.totalF10 == 0 and STAT.totalGiga > 0 then STAT.totalF10 = math.floor(STAT.totalGiga * 0.872) end
    if STAT.totalBonus == 0 and STAT.totalGame > 2.6 then STAT.totalBonus = STAT.totalHeight * 0.5 end
    if STAT.totalPerfect == 0 and STAT.totalQuest > 0 then STAT.totalPerfect = math.floor(STAT.totalQuest * 0.872) end
    if BEST.version then STAT.version, BEST.version = BEST.version, nil end
    local oldVer = STAT.version
    if STAT.version == nil then
        for k in next, BEST.highScore do
            if k:find('rNH') or k:find('rMS') or k:find('rVL') or k:find('rAS') then
                BEST.highScore[k] = nil
            end
        end
        STAT.version = 162
    end
    if STAT.version == 162 then
        TABLE.clear(BEST.speedrun)
        STAT.version = 163
    end
    if STAT.version == 163 then
        STAT.maxFloor = BEST.maxFloor or 1
        BEST.maxFloor = nil
        STAT.version = 166
    end
    if STAT.version == 166 then
        STAT.sfx = STAT.sfx and 60 or 0
        STAT.bgm = STAT.bgm and 100 or 0
        STAT.version = 167
    end
    if STAT.version == 167 then
        STAT.dzp = STAT.dailyHS or 0
        STAT.dailyHS = nil
        STAT.version = 168
    end
    if STAT.version == 168 or STAT.version == 169 then
        if ACHV.patience_is_a_virtue and ACHV.patience_is_a_virtue > 0 and ACHV.talentless == ACHV.patience_is_a_virtue then ACHV.patience_is_a_virtue = nil end
        ACHV.mastery = nil
        ACHV.terminal_velocity = nil
        ACHV.false_god = nil
        ACHV.supremacy = nil
        ACHV.the_completionist = nil
        ACHV.sunk_cost, ACHV.sink_cost = ACHV.sink_cost, nil
        STAT.version = 170
    end
    if STAT.version == 170 then
        ACHV.quest_rationing = nil
        STAT.version = 171
    end
    if STAT.version == 171 then
        ACHV.worn_out = nil
        STAT.version = 172
    end
    if STAT.version == 172 then
        ACHV.speedrun_speedrunning = ACHV.speedrun_speedruning
        STAT.version = 173
    end
    if STAT.version == 173 then
        ACHV.cruise_control, ACHV.stable_rise = ACHV.stable_rise, nil
        ACHV.subjugation, ACHV.supremacy = ACHV.supremacy, nil
        ACHV.smooth_dismount, ACHV.somersault = ACHV.somersault, nil
        ACHV.omnipotence, ACHV.the_completionist = ACHV.omnipotence, nil
        STAT.version = 174
    end
    if STAT.version == 174 then
        ACHV.overprotection, ACHV.overprotectiveness = ACHV.overprotection, nil
        STAT.version = 175
    end
    if STAT.version == 175 then
        ACHV.petaspeed, ACHV.teraspeed = ACHV.teraspeed, nil
        STAT.version = 176
    end
    if STAT.version == 176 then
        local banned
        if ACHV.love_hotel and ACHV.love_hotel < 2.6 then ACHV.love_hotel, banned = 6.2, true end
        if ACHV.unfair_battle and ACHV.unfair_battle < 4.2 then ACHV.unfair_battle, banned = 9.42, true end
        if banned then STAT.badge.rDP_meta = true end
        STAT.version = 177
    end
    if STAT.version == 177 then
        if ACHV.skys_the_limit then IssueSecret('fomg', true) end
        if ACHV.superluminal then IssueSecret('superluminal', true) end
        if ACHV.clicking_champion then IssueSecret('champion', true) end
        if ACHV.mastery then IssueSecret('mastery_1', true) end
        if ACHV.terminal_velocity then IssueSecret('speedrun_1', true) end
        if ACHV.subjugation then IssueSecret('mastery_2', true) end
        if ACHV.omnipotence then IssueSecret('speedrun_2', true) end
        STAT.version = 178
    end
    if STAT.version == 178 then
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
        STAT.version = 179
    end
    if STAT.version == 179 then
        if ACHV.perfect_speedrun then ACHV.perfect_speedrun = ACHV.perfect_speedrun * 75 / 70 end
        STAT.version = 180
    end
    if STAT.version == 180 then
        ACHV.quest_rationing = ACHV.block_rationing
        ACHV.block_rationing = nil
        STAT.version = 181
    end
    if STAT.version == 181 then
        ACHV.drag_racing, ACHV.petaspeed = ACHV.petaspeed, nil
        STAT.version = 182
    end
    if STAT.version == 182 then
        STAT.peakDZP = math.max(STAT.peakDZP, STAT.dzp)
        STAT.peakZP = math.max(STAT.peakZP, STAT.zp)
        STAT.version = 183
    end
    if STAT.version == 183 then
        ACHV.plonk = nil
        STAT.version = 184
    end
    if STAT.version == 184 then
        if ACHV.moon_struck then ACHV.moon_struck = MATH.roundUnit(math.abs(ACHV.moon_struck - 2202.8), .1) end
        STAT.version = 185
    end
    if STAT.version == 185 then
        STAT.badge.subluminal, STAT.badge.superluminal = STAT.badge.superluminal, nil
        if TABLE.minAll(BEST.speedrun) <= 42 then STAT.badge.superluminal = true end
        if TABLE.maxAll(BEST.highScore) >= 12600 then STAT.badge.fepsilon = true end
        if ACHV.divine_rejection then
            ACHV.divine_rejection = math.floor(ACHV.divine_rejection * 10) / 10
        end
        STAT.version = 186
    end
    if STAT.version == 186 then
        for k, v in next, BEST.highScore do
            BEST.highScore[k] = math.floor(v * 10) / 10
        end
        STAT.version = 187
    end
    if STAT.version == 187 then
        ACHV.dazed = nil
        STAT.version = 188
    end
    if STAT.version == 188 then
        STAT.hid = STAT.hid:sub(1, 12) .. math.random(26000, 42000) .. math.random(42000, 62000)
        STAT.version = 189
    end
    if STAT.version == 189 then
        if STAT.badge.zenith_and_nadir then
            STAT.badge.zenith_and_nadir = nil
            STAT.badge.universal_gravitation = true
        end
        STAT.version = 190
    end

    -- Some Initialization
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

    GAME.refreshLockState()
    GAME.refreshPBText()
    love.window.setFullscreen(STAT.fullscreen)
    ApplySettings()
    GAME.refreshCursor()

    if save or STAT.version ~= oldVer then
        SaveStat()
        SaveBest()
        SaveAchv()
    end
end
