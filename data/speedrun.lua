local d = {
    {
        id = 'star_9',
        name = "9-star",
        desc = "Master all upright mods",
        parTime = 260,
    },
    {
        id = 'star_18',
        name = "18-star",
        desc = "Master all reversed mods",
        parTime = 720,
    },
    {
        id = 'clicker',
        name = "ANY%",
        desc = "Reveal the true ending",
        parTime = 900,
    },
    {
        id = 'mod_up',
        name = "MOD%",
        desc = "Speedrun all single upright mods",
        parTime = 1000,
    },
    {
        id = 'mod_rev',
        name = "REV%",
        desc = "Speedrun all single reversed mods",
        parTime = 1260,
    },
    {
        id = 'rank_ss',
        name = "SS%",
        desc = "Achieve SS rank or higher",
        parTime = 1620,
    },
}

for i = 1, #d do d[d[i].id] = d[i] end

return d
