local d = {
    {
        id = 'star_9',
        name = "9-star",
        desc = "Master all upright mods",
    },
    {
        id = 'star_18',
        name = "18-star",
        desc = "Master all reversed mods",
    },
    {
        id = 'mod_up',
        name = "MOD%",
        desc = "Speedrun all single upright mods",
    },
    {
        id = 'mod_rev',
        name = "REV%",
        desc = "Speedrun all single reversed mods",
    },
    {
        id = 'rank_ss',
        name = "SS%",
        desc = "Achieve SS rank or higher",
    },
    {
        id = 'clicker',
        name = "ANY%",
        desc = "Reveal the true ending",
    },
}

for i = 1, #d do d[d[i].id] = d[i] end

return d
