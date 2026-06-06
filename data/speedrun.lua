local d = {
    {
        id = 'star_9',
        name = "9-star",
        desc = "Master all upright mods",
        par1 = 162,
        par2 = 260,
    },
    {
        id = 'star_18',
        name = "18-star",
        desc = "Master all reversed mods",
        par1 = 620,
        par2 = 960,
    },
    {
        id = 'clicker',
        name = "ANY%",
        desc = "Reveal the true ending",
        par1 = 900,
        par2 = 1260,
    },
    {
        id = 'mod_up',
        name = "MOD%",
        desc = "Speedrun all single upright mods",
        par1 = 620,
        par2 = 1000,
    },
    {
        id = 'mod_rev',
        name = "REV%",
        desc = "Speedrun all single reversed mods",
        par1 = 1260,
        par2 = 1620,
    },
    {
        id = 'rank_ss',
        name = "SS%",
        desc = "Achieve SS rank or higher",
        par1 = 1620,
        par2 = 2600,
    },
}

for i = 1, #d do d[d[i].id] = d[i] end

return d
