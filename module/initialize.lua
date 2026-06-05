UPDCMD = "curl -s -X GET https://api.github.com/repos/MrZ626/ZenithClicker/releases/latest"
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
if SupportCurl then
    ASYNC.runCmd('checkUpdate', UPDCMD)
end
if FILE.exist('avatar') then
    local suc, res = pcall(GC.newImage, 'avatar')
    if suc then AVATAR = res end
end

function LoadSave()
    local stat = FILE.safeLoad('stat.luaon', '-luaon')
    if stat then
        TABLE.update(STAT, stat)
        if not STAT.srTimer_game then
            STAT.srTimer_game, STAT.srTimer_life = STAT.totalTime, MATH.roundUnit(STAT.totalTime * 1.26, .001)
        end
    end
    TABLE.update(BEST, FILE.safeLoad('best.luaon', '-luaon') or NONE)
    TABLE.update(ACHV, FILE.safeLoad('achv.luaon', '-luaon') or NONE)
    TABLE.update(CONF, FILE.safeLoad('conf.luaon', '-luaon') or NONE)
end

LoadSave()

function Initialize(save)
    if STAT.totalF10 == 0 and STAT.totalGiga > 0 then STAT.totalF10 = math.floor(STAT.totalGiga * 0.872) end
    if STAT.totalBonus == 0 and STAT.totalGame > 2.6 then STAT.totalBonus = STAT.totalHeight * 0.5 end
    if STAT.totalPerfect == 0 and STAT.totalQuest > 0 then STAT.totalPerfect = math.floor(STAT.totalQuest * 0.872) end
    if BEST.version then STAT.version, BEST.version = BEST.version, nil end
    local oldVer = STAT.version
    if STAT.version then
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
        if STAT.version == 190 then
            if ACHV.denying_the_dark then
                ACHV.return_to_the_light = true
            end
            STAT.version = 191
        end
        if STAT.version == 191 then
            if not CONF then
                for k in next, CONF do
                    if STAT[k] ~= nil then
                        CONF[k] = STAT[k]
                    end
                end
            end
            STAT.version = 192
        end
        if STAT.version == 192 then
            if STAT.srTimer_game > STAT.srTimer_life then
                STAT.srTimer_game, STAT.srTimer_life = STAT.srTimer_life, STAT.srTimer_game
            end
            STAT.version = 193
        end
        if STAT.version == 193 then
            if STAT.totalHeight > 0 and STAT.totalKO == 0 then
                STAT.totalKO = math.floor(STAT.totalHeight * (6 / 2000))
                STAT.totalRevive = ((ACHV.the_responsible_one or 0) + (ACHV.the_unreliable_one or 0)) * 6
            end
            STAT.version = 194
        end
        if STAT.version == 194 then
            ACHV.slayer_of_the_tower = math.min(ACHV.slayer_of_the_tower or 0, 42)
            STAT.version = 195
        end
        if STAT.version == 195 then
            STAT.badge.exceed_dev_half, STAT.badge.exceed_dev = nil, nil
            STAT.version = 196
        end
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
