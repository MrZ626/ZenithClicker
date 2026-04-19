local d = {
    [0] = {
        prio = 1e99,
        name = "---",
        desc = "???",
    },
    {
        id = 'champion',
        name = "Clicker Champion",
        desc = "Attain 25k CR",
    },
    {
        id = 'mastery_1',
        name = "Mastery",
        desc = "Reached F10 with all single upright mods",
    },
    {
        id = 'speedrun_1',
        name = "Speedrunner",
        desc = "Finished a speedrun with all single upright mods",
    },
    {
        id = 'mastery_2',
        name = "Subjugation",
        desc = "Reached F10 with all single reversed mods",
    },
    {
        id = 'speedrun_2',
        name = "Omnipotence",
        desc = "Finished a speedrun with all single reversed mods",
    },
    {
        id = 'subluminal',
        name = "Sub-luminal",
        desc = "Reached F10 in under 76.2s (max CR from Best Speedrun)",
    },
    {
        id = 'superluminal',
        name = "Superluminal",
        desc = "Reached F10 in under 42s",
    },
    {
        id = 'fomg',
        name = "Interstellar",
        desc = "Reached 6200m (max CR from Best Altitude)",
    },
    {
        id = 'fepsilon',
        name = "Intergalactic",
        desc = "Reached 12600m",
    },
    {
        id = 'true_expert',
        name = "True Expert",
        desc = "Finished a speedrun with rEX & Close Card",
    },
    {
        id = 'true_master',
        name = "True Master",
        desc = "Finished a speedrun with rGV & Nightcore",
    },
    {
        id = 'true_strength',
        name = "True Strength",
        desc = "Finished a speedrun with rVL & Fast Leak",
    },
    {
        id = 'true_invis',
        name = "True Invisible",
        desc = "Finished a speedrun with rIN & Invisible Card",
    },
    {
        id = 'true_couple',
        name = "True Couple",
        desc = "Finished a speedrun with rDP & Invisible UI",
    },
    {
        id = 'cardiac_arrest',
        name = "Cardiac Arrest",
        desc = "Die with max HP less than 5",
    },
    {
        id = 'universal_gravitation',
        name = "Universal Gravitation",
        desc = "Reached F10 but finished at negative altitude",
    },
    {
        id = 'rDP_meta',
        name = "Mechanical Heartbreaker",
        desc = "Abused the rDP mod to stay alive over 10 minutes",
    },
    {
        id = 'sc_cap',
        name = "Surge Protector",
        desc = "Reached the B2B cap",
    },
    {
        id = 'exceed_dev_half',
        name = "Apprentice",
        desc = "Have a better score than Dev on 26% achievements",
    },
    {
        id = 'exceed_dev',
        name = "Successor",
        desc = "Have a better score than Dev on 62% achievements",
    },
}

for i = 1, #d do
    local bd = d[i]
    bd.prio = i
    d[bd.id] = bd
end

return d
