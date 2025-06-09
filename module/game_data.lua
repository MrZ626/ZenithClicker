---------------------------------------------------------------------
--                      SPOILER WARNING                            --
-- This file contains secrets that may spoil your game experience. --
-- Be sure you've finished the game, including Ultra Reversed Mods --
--                   Read at your own risk.                        --
---------------------------------------------------------------------

GigaSpeedReq = { [0] = 7, 8, 8, 9, 9, 10, 1e99, 1e99, 1e99, 1e99, 1e99 }
TeraMusicReq = { [0] = 9, 11, 11, 12, 12, 13, 13, 1e99, 1e99, 1e99 }

GravityTimer = {
    { 9.0, 8.0, 7.5, 7.0, 6.5, 6.0, 5.5, 5.0, 4.5, 4.0 },
    { 3.2, 3.0, 2.8, 2.6, 2.5, 2.4, 2.3, 2.2, 2.1, 2.0 },
}

ModData = {
    deck = {
        { id = 'EX', initOrder = 1, lockfull = false },
        { id = 'NH', initOrder = 2, lockfull = true },
        { id = 'MS', initOrder = 3, lockfull = true },
        { id = 'GV', initOrder = 4, lockfull = true },
        { id = 'VL', initOrder = 5, lockfull = true },
        { id = 'DH', initOrder = 6, lockfull = true },
        { id = 'IN', initOrder = 7, lockfull = true },
        { id = 'AS', initOrder = 8, lockfull = true },
        { id = 'DP', initOrder = 9, lockfull = false },
    },
    name = {
        EX = 'expert',
        NH = 'nohold',
        MS = 'messy',
        GV = 'gravity',
        VL = 'volatile',
        DH = 'doublehole',
        IN = 'invisible',
        AS = 'allspin',
        DP = 'duo',
    },
    fullName = {
        EX = "< EXPERT MODE >",
        NH = "< NO HOLD >",
        MS = "< MESSINESS  >",
        GV = "< GRAVITY >",
        VL = "< VOLATILITY >",
        DH = "< DOUBLE HOLE >",
        IN = "< INVISIBLE >",
        AS = "< ALL-SPIN >",
        DP = "< DUO >",
        lock = "< LOCKED >",
        lockDP = "< LOCKED? >",
    },
    desc = {
        EX = "A LESS LENIENT CHALLENGE, FOR THOSE WHO DARE",
        NH = "CANCELING IS DISABLED",
        MS = "SHUFFLE CARDS BY FLOOR",
        GV = "AUTO COMMITS OCCUR PERIODICALLY, INTERVALS DECREASE PER FLOOR",
        VL = "LARGER GAPS BETWEEN CARDS, MUST CLICK TWICE",
        DH = "COMBO DIFFICULTY IS INCREASED",
        IN = "CARDS ARE FACED DOWN AND FLASH ONCE EVERY TWO SECONDS",
        AS = "ENABLE KEYBOARD CONTROLS, BUT DOUBLE CLICKING IS PENALIZED",
        DP = "FLOOD THE TOWER WITH SOMEONE WHO DOESN'T EXIST",
        lock = "REACH A HIGHER FLOOR TO UNLOCK",
        lockDP = "PLAY THIS MOD ONCE TO UNLOCK",
    },
    revName = {
        EX = "> THE TYRANT <",
        NH = "> ASCETICISM <",
        MS = "> LOADED DICE <",
        GV = "> FREEFALL <",
        VL = "> LAST STAND <",
        DH = "> DAMNATION <",
        IN = "> THE EXILE <",
        AS = "> THE WARLOCK <",
        DP = "> BLEEDING HEARTS <",
    },
    revDesc = {
        EX = "FEAR, OPPRESSION, AND LIMITLESS AMBITION",
        NH = "A DETACHMENT FROM EVEN THAT WHICH IS MODERATE",
        MS = "IN A RIGGED GAME, YOUR MIND IS THE ONLY FAIR ADVANTAGE",
        GV = "THE GROUND YOU STOOD ON NEVER EXISTED IN THE FIRST PLACE",
        VL = "STRENGTH ISN'T NECESSARY FOR THOSE WITH NOTHING TO LOSE",
        DH = "NEITHER THE FREEDOM OF LIFE OR PEACE OF DEATH",
        IN = "NEVER UNDERESTIMATE BLIND FAITH",
        AS = "INTO REALMS BEYOND HEAVEN AND EARTH",
        DP = "EVEN AS WE BLEED, WE KEEP HOLDING ON...",
    },
    ultraName = {
        EX = "- PSYCHOTIC SOVEREIGN -",
        NH = "- ASCENDED VIRTUE -",
        MS = "- ENTROPY -",
        GV = "- COLLAPSING GALAXY -",
        VL = "- DIMINISHING VOLITION -",
        DH = "- BLASPHEMY -",
        IN = "- PARADOXICAL NIHILITY -",
        AS = "- DEPRAVED GRIMOIRE -",
        DP = "- SEVERED EDEN -",
    },
    ultraDesc = {
        EX = "ROTTEN AUTHORITY AND UNJUST LAW, USURPED THY MORAL AND PEASANTRY",
        NH = "FOR THY SACRIFICES, TRANSCENDENCE AWAITS, MORTAL...",
        MS = "A DISTORTED FATE RESULTED FROM UNGOVERNED ENIGMATA",
        GV = "THE UNIVERSE CRUMBLES, WITH ESCAPE MERELY TEMPORARY",
        VL = "CRUSHED BENEATH DESPAIR, RESISTANCE FADES TO NOTHING",
        DH = "HARK! THE HOPELESS, DAMNED WEEPING OF THY WILL...",
        IN = "ETERNALLY DROWNING IN ENIGMATIC DOUBTS, UNCERTAINTY AND HYSTERIA",
        AS = "ILL-NATURED, TENEBRIOUS, LIFE-DRAINING MAGIC CLASPS THY SOUL...",
        DP = "WHAT ONCE WAS INTERTWINED NOW NEVER TO COEXIST",
    },
    ultraImpactTone = {
        EX = { 0, nil, 0 }, -- 6 6
        NH = { 0, 5 },      -- 5 2
        MS = { 3, 5, 7 },   -- 1 2 3
        GV = { -4, 8 },     -- 4 4
        VL = { -5, 0 },     -- 3 6
        DH = { 1, 6, 9 },   -- #6 #2 #4
        IN = {},
        AS = { 0, 3 },      -- 6 1
        DP = { -2, 5 },     -- 5 2
    },
    weight = {
        EX = 13, --  8 + 5
        NH = 12, --  8 + 4
        MS = 14, -- 10 + 4
        GV = 12, -- 10 + 2
        VL = 17, -- 15 + 2
        DH = 12, --  8 + 4
        IN = 7,  --  6 + 1
        AS = 13, -- 10 + 3
        DP = 4,  --  3 + 1
    },
    color = {
        EX = { COLOR.HEX "89590B" },
        NH = { COLOR.HEX "FF00D4" },
        MS = { COLOR.HEX "FFB400" },
        GV = { COLOR.HEX "FFFF00" },
        VL = { COLOR.HEX "FF1500" },
        DH = { COLOR.HEX "47ACFF" },
        IN = { COLOR.HEX "BD24FF" },
        AS = { COLOR.HEX "00FED4" },
        DP = { COLOR.HEX "FF8C9D" },
    },
    textColor = {
        EX = { COLOR.HEX "C29F68" },
        NH = { COLOR.HEX "FF8BEC" },
        MS = { COLOR.HEX "FFD572" },
        GV = { COLOR.HEX "F7FF8A" },
        VL = { COLOR.HEX "FF978D" },
        DH = { COLOR.HEX "A6D5FF" },
        IN = { COLOR.HEX "E8B3FF" },
        AS = { COLOR.HEX "93FFE0" },
        DP = { COLOR.HEX "FFC0C9" },
    },
    prio_name = { IN = 0, MS = 1, VL = 2, NH = 3, DH = 4, AS = 5, GV = 6, EX = 7, DP = 8, rIN = 0, rMS = 1, rVL = 2, rNH = 3, rDH = 4, rAS = 5, rGV = 6, rEX = 7, rDP = 8 },
    prio_icon = { EX = 0, DP = 1, DH = 2, VL = 3, GV = 4, NH = 5, MS = 6, IN = 7, AS = 8, rEX = 0, rDP = 1, rDH = 2, rVL = 3, rGV = 4, rNH = 5, rMS = 6, rIN = 7, rAS = 8 },
    prio_card = { EX = 0, NH = 1, MS = 2, GV = 3, VL = 4, DH = 5, IN = 6, AS = 7, DP = 8, rEX = 0, rNH = 1, rMS = 2, rGV = 3, rVL = 4, rDH = 5, rIN = 6, rAS = 7, rDP = 8 },
    adj = {
        EX = "EXPERT",
        NH = "HOLDLESS",
        MS = "MESSY",
        GV = "GRAVITY",
        VL = "VOLATILE",
        DH = "DOUBLE HOLE",
        IN = "INVISIBLE",
        AS = "ALL-SPIN",
        DP = "DUO",
        rEX = "TYRANNICAL",
        rNH = "ASCENDANT",
        rMS = "DECEPTIVE",
        rGV = "COLLAPSED",
        rVL = "DESPERATE",
        rDH = "DAMNED",
        rIN = "BELIEVED",
        rAS = "OMNI-SPIN",
        rDP = "PIERCING",
    },
    noun = {
        EX = "EXPERT",
        NH = "NO HOLD",
        MS = "MESSINESS",
        GV = "GRAVITY",
        VL = "VOLATILITY",
        DH = "DOUBLE HOLE",
        IN = "INVISIBLITY",
        AS = "ALL-SPIN",
        DP = "DUO",
        rEX = "TYRANNY",
        rNH = "ASCENSION",
        rMS = "DECEPTION",
        rGV = "COLLAPSE",
        rVL = "DESPERATION",
        rDH = "DAMNATION",
        rIN = "BELIEF",
        rAS = "OMNI-SPIN",
        rDP = "HEARTACHE",
    },
}

ComboData = {
    menu = {
        { set = 'NH GV',            name = "A Modern Classic" },
        { set = 'NH MS DH',         name = "Deadlock" },
        { set = 'MS DH AS',         name = "The Escape Artist" },
        { set = 'GV IN',            name = "The Grandmaster" },
        { set = 'EX NH DH',         name = "Emperor's Decadence" },
        { set = 'EX MS VL DH',      name = "Divine Mastery" },
        { set = 'NH AS',            name = "The Starving Artist" },
        { set = 'EX VL AS',         name = "The Con Artist" },
        { set = 'EX DP',            name = "Trained Professionals" },
        { set = 'EX MS',            name = "Block Rationing" },

        { set = "EX rGV DH",        name = "Demonic Speed" },
        { set = "rGV rAS",          name = "Whizzing Wizard" },
        { set = "rGV rIN",          name = "The Grandmaster+" },
        { set = "NH rAS",           name = "Pristine" },
        { set = "GV rDH rAS",       name = "Storage Overload" },
        { set = "rNH rMS DH",       name = "Deadbeat" },
        { set = "rNH rGV rVL",      name = "Sweatshop" },
        { set = "rNH rIN",          name = "Fleeting Memory" },
        { set = "EX NH rMS GV",     name = "Bnuuy" },
        { set = "rNH rMS GV AS DP", name = "Grand-Master! Rounds" },
        { set = "rEX rVL DH",       name = "Sweat and Ruin" },
        { set = "rMS GV AS rDP",    name = "Cupid's Gamble" },
        { set = "NH rGV VL rDP",    name = "Despairful Longing" },
        { set = "rEX VL rIN",       name = "Authoritarian Delusion" },
        { set = "rEX rDP",          name = "Tyrannical Dyarchy" },
        { set = "rEX MS rDH IN",    name = "Sisyphean Monarchy" },
        { set = "MS rDH rIN AS",    name = "Kitsune Trickery" },

        { set = "NH rGV",           name = "Clutch Main" },
        { set = "EX VL",            name = "Wax Wings" },
        { set = "DH rIN AS",        name = "The Oblivious Artist" },
        { set = "VL DH rIN",        name = "Empurple" },

        { set = "EX VL rIN rDP",    name = "Love Hotel" },
        { set = "EX MS AS",         name = "Financially Responsible" },
        { set = "EX rVL rDP",       name = "Unfair Battle" },
        { set = "DH DP",            name = "Museum Heist" },
        { set = "EX rGV VL",        name = "Workaholic" },
        { set = "MS VL AS",         name = "Human Experiment" },
        { set = "EX GV DH",         name = "Thermal Anomaly" },
        { set = "rMS rGV rIN",      name = "The Masterful Juggler" },
    },

    game = {
        { set = 'NH GV',       name = "A Modern Classic" },
        { set = 'NH MS DH',    name = "Deadlock" },
        { set = 'MS DH AS',    name = "The Escape Artist" },
        { set = 'GV IN',       name = "The Grandmaster" },
        { set = 'EX NH DH',    name = "Emperor's Decadence" },
        { set = 'EX MS VL DH', name = "Divine Mastery" },
        { set = 'NH AS',       name = "The Starving Artist" },
        { set = 'EX VL AS',    name = "The Con Artist" },
        { set = 'EX DP',       name = "Trained Professionals" },
        { set = 'EX MS',       name = "Block Rationing" },
    },

    -- rDH database, from tetr.io's community:
    -- https://docs.google.com/spreadsheets/d/1syh3q2oiduCZb1cJ5QI95Y2XhhedAfhv4YnEH9z2tbc
    gameEX = {
        { set = "EX",             name = "The Emperor" },
        { set = "NH",             name = "Temperance" },
        { set = "MS",             name = "Wheel of Fortune" },
        { set = "GV",             name = "The Tower" },
        { set = "VL",             name = "Strength" },
        { set = "DH",             name = "The Devil" },
        { set = "IN",             name = "The Hermit" },
        { set = "AS",             name = "The Magician" },
        { set = "DP",             name = "The Lovers" },
        { set = "EX NH",          name = "A Fair Leader" },
        { set = "EX MS",          name = "Block Rationing" },
        { set = "EX GV",          name = "Invictus" },
        { set = "EX VL",          name = "Icarus" },
        { set = "EX DH",          name = "The Devil's Temptation" },
        { set = "EX IN",          name = "Emperor's Dilemma" },
        { set = "EX AS",          name = "Dancing Queen" },
        { set = "EX DP",          name = "Trained Professionals" },
        { set = "NH MS",          name = "All in" },
        { set = "NH GV",          name = "A Modern Classic" },
        { set = "NH VL",          name = "Resistance" },
        { set = "NH DH",          name = "Purgatory Lite" },
        { set = "NH IN",          name = "Helen Keller" },
        { set = "NH AS",          name = "The Starving Artist" },
        { set = "NH DP",          name = "Hand in Hand" },
        { set = "MS GV",          name = "Cheese Race" },
        { set = "MS VL",          name = "Swiss Cheese" },
        { set = "MS DH",          name = "Dig In" },
        { set = "MS IN",          name = "Blind Bet" },
        { set = "MS AS",          name = "Roulette Wheel" },
        { set = "MS DP",          name = "It's Complicated..." },
        { set = "GV VL",          name = "Comfort Food" },
        { set = "GV DH",          name = "The Speed Demon" },
        { set = "GV IN",          name = "The Grandmaster" },
        { set = "GV AS",          name = "The Juggler" },
        { set = "GV DP",          name = "Heavy Hearts" },
        { set = "VL DH",          name = "Lucifer" },
        { set = "VL IN",          name = "Memorization" },
        { set = "VL AS",          name = "Water From Stone" },
        { set = "DH IN",          name = "The Ghost" },
        { set = "DH AS",          name = "The Deal with the Devil" },
        { set = "DH DP",          name = "Forbidden Lovers" },
        { set = "IN AS",          name = "The Abstract Artist" },
        { set = "IN DP",          name = "Love is Blind" },
        { set = "AS DP",          name = "Collaboration" },
        { set = "EX NH MS",       name = "Online Gambling" },
        { set = "EX NH GV",       name = "Beyond Death" },
        { set = "EX NH VL",       name = "Archangel" },
        { set = "EX NH DH",       name = "Emperor's Decadence" },
        { set = "EX NH IN",       name = "The Friar" },
        { set = "EX NH AS",       name = "Indecision" },
        { set = "EX MS GV",       name = "Mining Operation" },
        { set = "EX MS VL",       name = "The Wolf of Wall Street" },
        { set = "EX MS DH",       name = "No Warning" },
        { set = "EX MS IN",       name = "Irrational" },
        { set = "EX MS AS",       name = "The Rich Gambler" },
        { set = "EX GV VL",       name = "Relaxation" },
        { set = "EX GV DH",       name = "The Daredevil" },
        { set = "EX GV IN",       name = "The Super GM" },
        { set = "EX GV AS",       name = "Master of the T" },
        { set = "EX GV DP",       name = "Sinking" },
        { set = "EX VL DH",       name = "The Mad Lord" },
        { set = "EX VL IN",       name = "Bounty Hunter" },
        { set = "EX VL AS",       name = "The Con Artist" },
        { set = "EX DH IN",       name = "The Architect" },
        { set = "EX DH AS",       name = "Loki" },
        { set = "EX IN AS",       name = "Expertise" },
        { set = "NH MS GV",       name = "Atlas' Burden" },
        { set = "NH MS VL",       name = "The Glass Cannon" },
        { set = "NH MS DH",       name = "Deadlock" },
        { set = "NH MS IN",       name = "The False Prophet" },
        { set = "NH MS AS",       name = "Unpredictable Outcome" },
        { set = "NH GV VL",       name = "Traditional" },
        { set = "NH GV DH",       name = "Unstable Footing" },
        { set = "NH GV IN",       name = "Evanescence" },
        { set = "NH GV AS",       name = "A Modern Twist" },
        { set = "NH GV DP",       name = "Nostalgia" },
        { set = "NH VL DH",       name = "Judgment" },
        { set = "NH VL IN",       name = "Justice" },
        { set = "NH VL AS",       name = "Bob Ross" },
        { set = "NH DH IN",       name = "Blindside" },
        { set = "NH DH AS",       name = "Shapeshifter" },
        { set = "NH IN AS",       name = "The Blind Artist" },
        { set = "NH IN DP",       name = "Left On Read" },
        { set = "MS GV VL",       name = "Survival" },
        { set = "MS GV DH",       name = "Double Down" },
        { set = "MS GV IN",       name = "Burrata" },
        { set = "MS GV AS",       name = "Rough Sketch" },
        { set = "MS VL DH",       name = "Utter Trash" },
        { set = "MS VL IN",       name = "Starstruck" },
        { set = "MS VL AS",       name = "Cream Cheese" },
        { set = "MS VL DP",       name = "Couples Therapy" },
        { set = "MS DH IN",       name = "The Stealth Ninja" },
        { set = "MS DH AS",       name = "The Escape Artist" },
        { set = "MS IN AS",       name = "Abstraction" },
        { set = "GV VL DH",       name = "Temptation" },
        { set = "GV VL IN",       name = "Paranoia" },
        { set = "GV VL AS",       name = "The Gladiator" },
        { set = "GV DH IN",       name = "The Drunk Driver" },
        { set = "GV DH AS",       name = "The Texting Driver" },
        { set = "GV IN AS",       name = "The Spinmaster" },
        { set = "VL DH IN",       name = "The Flickering Spirit" },
        { set = "VL DH AS",       name = "Forbidden Sorcery" },
        { set = "VL IN AS",       name = "Eccentric Recluse" },
        { set = "VL AS DP",       name = "The Cheaters" },
        { set = "DH IN AS",       name = "The Libertine" },
        { set = "DH IN DP",       name = "Separation Anxiety" },
        { set = "EX NH MS GV",    name = "Atlas' Lament" },
        { set = "EX NH MS VL",    name = "The Fugitive" },
        { set = "EX NH MS DH",    name = "Impasse" },
        { set = "EX NH MS AS",    name = "Fair Chance" },
        { set = "EX NH GV VL",    name = "Cutting Edge" },
        { set = "EX NH GV IN",    name = "Still Water" },
        { set = "EX NH GV AS",    name = "Beyond the Afterdeath" },
        { set = "EX NH VL DH",    name = "Azathoth" },
        { set = "EX NH VL IN",    name = "Unreasonable" },
        { set = "EX NH VL AS",    name = "The Scam Leader" },
        { set = "EX NH DH IN",    name = "Invisible Decadence" },
        { set = "EX NH DH AS",    name = "Amorphous" },
        { set = "EX NH IN AS",    name = "Black Magic" },
        { set = "EX NH AS DP",    name = "Royal Waltz" },
        { set = "EX MS GV VL",    name = "Juggernaut" },
        { set = "EX MS GV DH",    name = "Mining for Netherite" },
        { set = "EX MS GV AS",    name = "Irregular Sketch" },
        { set = "EX MS VL DH",    name = "Divine Mastery" },
        { set = "EX MS VL IN",    name = "Interstellar" },
        { set = "EX MS VL AS",    name = "The Hacker" },
        { set = "EX MS DH AS",    name = "Imprisonment" },
        { set = "EX MS IN AS",    name = "The Mathematician" },
        { set = "EX GV VL DH",    name = "The Autocrat" },
        { set = "EX GV VL IN",    name = "Lateness" },
        { set = "EX GV VL AS",    name = "Inertia" },
        { set = "EX GV DH AS",    name = "Spin Overlord" },
        { set = "EX GV IN AS",    name = "Mastermind" },
        { set = "EX VL DH IN",    name = "Corruption" },
        { set = "EX VL DH AS",    name = "Devilish Falsifier" },
        { set = "EX VL IN AS",    name = "Insanity" },
        { set = "EX DH IN AS",    name = "Reverse Quadruple Threat" },
        { set = "NH MS GV VL",    name = "Quadruple threat" },
        { set = "NH MS GV DH",    name = "Futility" },
        { set = "NH MS GV IN",    name = "Spelunking" },
        { set = "NH MS VL DH",    name = "Deadbolt" },
        { set = "NH MS VL IN",    name = "Blind Swinging" },
        { set = "NH MS VL AS",    name = "Bluff" },
        { set = "NH MS DH IN",    name = "Unfinished Business" },
        { set = "NH MS DH AS",    name = "Locksmith" },
        { set = "NH MS IN AS",    name = "Writer's Block" },
        { set = "NH GV VL DH",    name = "Nephalem" },
        { set = "NH GV VL IN",    name = "The Black Hole" },
        { set = "NH GV VL AS",    name = "Recreation" },
        { set = "NH GV DH IN",    name = "Live Fast Die Young" },
        { set = "NH GV DH AS",    name = "Dance Dance Revolution" },
        { set = "NH GV IN AS",    name = "Divine Failure" },
        { set = "NH GV IN DP",    name = "Silver Anniversary" },
        { set = "NH VL DH IN",    name = "Spilled Milk" },
        { set = "NH VL DH AS",    name = "The Restrained Artist" },
        { set = "NH VL IN AS",    name = "Vigilante" },
        { set = "NH DH IN AS",    name = "Impressionism" },
        { set = "MS GV VL DH",    name = "Quadruple Down" },
        { set = "MS GV VL IN",    name = "Eleventh Hour" },
        { set = "MS GV VL AS",    name = "Gambled Faith" },
        { set = "MS GV DH IN",    name = "Intoxication" },
        { set = "MS GV DH AS",    name = "The Spacial Artist" },
        { set = "MS GV IN AS",    name = "Parmigiano Reggiano" },
        { set = "MS VL DH IN",    name = "The Night Watchman" },
        { set = "MS VL DH AS",    name = "Blue Cheese" },
        { set = "MS VL DH DP",    name = "Quadruples Therapy" },
        { set = "MS VL IN AS",    name = "Creative Explosion" },
        { set = "MS DH IN AS",    name = "Nascent" },
        { set = "GV VL DH IN",    name = "Nightmare" },
        { set = "GV VL DH AS",    name = "Sword Box" },
        { set = "GV VL IN AS",    name = "Immense Pressure" },
        { set = "GV DH IN AS",    name = "Horror Thriller" },
        { set = "GV DH IN DP",    name = "Timid Adoration" },
        { set = "VL DH IN AS",    name = "The Prodigy" },
        { set = "EX NH MS GV VL", name = "Oppression" },
        { set = "EX NH MS VL DH", name = "No Holds Barred" },
        { set = "EX NH GV VL DH", name = "The Veteran" },
        { set = "EX NH GV VL IN", name = "Foresight" },
        { set = "EX NH GV DH AS", name = "The Kill Screen" },
        { set = "EX NH GV IN AS", name = "Paragon" },
        { set = "EX NH GV IN DP", name = "Golden Anniversary" },
        { set = "EX NH VL DH IN", name = "Spoiled Milk" },
        { set = "EX NH VL DH AS", name = "Loss of Control" },
        { set = "EX NH VL IN AS", name = "Loading Screen" },
        { set = "EX NH DH IN AS", name = "Futile Spectacle" },
        { set = "EX MS GV VL DH", name = "Hell's Gate" },
        { set = "EX MS GV VL IN", name = "Hunted" },
        { set = "EX MS GV VL AS", name = "Deadline" },
        { set = "EX MS GV DH AS", name = "The Temporal Artist" },
        { set = "EX MS VL DH AS", name = "False Security" },
        { set = "EX MS VL IN AS", name = "Reload" },
        { set = "EX GV VL DH IN", name = "Unexpectancy" },
        { set = "EX GV VL IN AS", name = "Speed the Collapse" },
        { set = "EX VL DH IN AS", name = "Reverse Quintuple Threat" },
        { set = "NH MS GV VL DH", name = "Quintuple threat" },
        { set = "NH MS GV DH IN", name = "Misdrop Haven" },
        { set = "NH MS GV DH AS", name = "A Classic Escape" },
        { set = "NH MS GV IN AS", name = "Lost and Dizzy" },
        { set = "NH MS VL DH IN", name = "Blind Faith" },
        { set = "NH MS VL DH AS", name = "Boltsmith" },
        { set = "NH MS VL IN AS", name = "Ballet Dancing" },
        { set = "NH MS DH IN AS", name = "Disappearance" },
        { set = "NH GV VL DH IN", name = "Entropy" },
        { set = "NH GV VL DH AS", name = "Demonic Possession" },
        { set = "NH GV VL IN AS", name = "Ergosphere" },
        { set = "NH GV DH IN AS", name = "Cheat Code" },
        { set = "NH VL DH IN AS", name = "Magic" },
        { set = "MS GV VL DH IN", name = "Slaughterhouse" },
        { set = "MS GV VL DH AS", name = "Killer Clown" },
        { set = "MS GV VL IN AS", name = "Mortal Chaos" },
        { set = "MS GV DH IN AS", name = "Doubled Symbolism" },
        { set = "MS VL DH IN AS", name = "Beethoven" },
        { set = "GV VL DH IN AS", name = "Lost Genius" },
    },
}

for _, sets in next, ComboData do
    for i = 1, #sets do
        local cmb = sets[i]
        cmb.name = '"' .. cmb.name:upper() .. '"'
        local cmbStr = table.concat(TABLE.sort(cmb.set:trim():split('%s+', true)), ' ')
        sets[cmbStr] = sets[cmbStr] or cmb
    end
end

RevSwampName = {
    "Z", "S", "J", "L", "T", "O", "I",
    [["BLIGHT"]],
    [["DESOLATION"]],
    [["HAVOC"]],
    [["PANDEMONIUM"]],
    [["INFERNO"]],
    [["PURGATORY"]],
    [["PERDITION"]],
    [["CATACLYSM"]],
    [["ANNIHILATION"]],
    [["ARMAGEDDON"]],
    [["ABYSS"]],
    [["APOCALYPSE"]], -- not used
}

Floors = {
    [0] = { top = 0, name = "The Basement" },
    { top = 50,   event = {},                                                  name = "Hall of Beginnings" },
    { top = 150,  event = { 'dmgDelay', -2, 'dmgWrong', 1 },                   name = "The Hotel",           MSshuffle = 1 },
    { top = 300,  event = { 'dmgDelay', -2, 'dmgCycle', -.5 },                 name = "The Casino" },
    { top = 450,  event = { 'dmgDelay', -1, 'dmgCycle', -.5 },                 name = "The Arena" },
    { top = 650,  event = { 'dmgDelay', -1, 'dmgCycle', -.5, 'dmgWrong', 1 },  name = "The Museum",          MSshuffle = 2 },
    { top = 850,  event = { 'dmgDelay', -1, 'dmgTime', 1, 'maxQuestSize', 1 }, name = "Abandoned Offices" },
    { top = 1100, event = { 'dmgDelay', -1, 'dmgCycle', -.5 },                 name = "The Laboratory",      MSshuffle = 3 },
    { top = 1350, event = { 'dmgDelay', -1, 'dmgCycle', -.5 },                 name = "The Core" },
    { top = 1650, event = { 'dmgDelay', -.5, 'dmgWrong', 1 },                  name = "Corruption",          MSshuffle = 4 },
    { top = 1e99, event = { 'dmgDelay', -.5, 'dmgCycle', -.5, 'dmgTime', 1 },  name = "Platform of the Gods" },
    { top = 1e99, name = "Stellar Nebula Frontier" }, -- Only name is used
    -- Initial: Delay=15. Cycle=5, Wrong=1
    -- Total: Delay-10, Cycle-3, Wrong+4
}

NegFloors = {
    [0] = { bottom = -1e99, name = "Endless Void" },
    { bottom = -50,   name = "The Basement" },
    { bottom = -150,  name = "Zenith Restaurant" },
    { bottom = -300,  name = "Underground Parking" },
    { bottom = -450,  name = "The Bunker" },
    { bottom = -650,  name = "The Infirmary" },
    { bottom = -850,  name = "Decayed Catacombs" },
    { bottom = -1100, name = "Sacreligious Ruins" },
    { bottom = -1350, name = "Singularity Reactor" },
    { bottom = -1650, name = "Distorted Gateways" },
    { bottom = -1e99, name = "Endless Void" },
}
local NegTexts = {
    b1 = { -- The Basement
        desc = [[A basic storage room for the floors above... and below.]],
        begin = [[You find yourself in an unfamiliar place.]],
        noAS = [[You passed the security check without any prohibited items.]],
        ASoff = [[To prevent mech heart users from entering, the AS mod has been confiscated.]],
        -- egg = [[Garbo checks the imprisoned mech heart users here from time to time, except rtxtile, who kept escaping somehow?]],
    },
    b2 = { -- Zenith Restaurant
        desc = [[A lively restaurant with a lovely atmosphere. Though the prices here are slightly outrageous...]],
        begin = [[The smell of food calms your senses...]],
        effStart = [[Illusions dance before your eyes...]],
        noVL = [[You feel yourself getting weaker and weaker...]],
        VLoff = [[You feel your strength fading...]],
        noIN = [[The illusion before your eyes hasn't entirely faded...]],
        INoff = [[Your mind is becoming clearer...]],
    },
    b3 = { -- Underground Parking
        desc = [[A boundless parking lot for all of these visitors.]],
        begin = [[The vast lot's tranquility reassures you.]],
        effStart = [[But a realization dawned - you were lost.]],
        mid1 = [["Where am I?"]],
        noGV = [[You feel like you're not going fast enough...]],
        GVoff = [[You subconsciously quickened your pace...]],
        mid2 = [["Where am I going?"]],
    },
    b4 = { -- The Bunker
        desc = [[A regular bunker... after witnessing the Corruption, you definitely know why it was built.]],
        begin = [[You feel safe away from the above.]],
        effStart = [[The barren bunker begins to feel ghostly.]],
        noMS = [[It seems that luck was against you...]],
        MSoff = [[You organized your thoughts...]],
    },
    b5 = { -- The Infirmary
        desc = [[The medical sector of the tower, filled with incomprehensible technology. they look similar to the ones in the Laboratory...]],
        begin = [[Endless beeping echoes through the halls you roam.]],
        effStart = [[One horrifying scene after another floods your vision.]],
        noDH = [[And now, a sinister thought crosses your mind...]],
        DHoff = [[You shuddered while walking in this terrifying place.]],
    },
    b6 = { -- Decayed Catacombs
        desc = [[A complex of the dead, now decaying into an even more unsettling shell of itself.]],
        begin = [[The feeling of safety slipped away.]],
        effStart = [[Your attention strays...]],
        mid = [[You begin to hear something calling your name...]],
        noNH = [[You cannot ignore the voice...]],
        NHoff = [[You overcome your fear.]],
    },
    b7 = { -- Sacreligious Ruins
        desc = [[The remains of a previously sacred chapel, the spirits of those, who worshipped the gods above linger on...]],
        desc2 = [[Whispers of a missing artifact echo throughout the area...]],
        begin = [[You pray that nothing dire becomes of you.]],
        effStart = [[Spacetime ahead is heavily warped...]],
        mid = [[You feel as if you have to go as fast as possible.]],
    },
    b8 = { -- Singularity Reactor
        desc = [[Fueled by the power of the cosmos and the stolen artifact, powering something...]],
        begin = [[You are overwhelmed by the reactor's magnitude.]],
        mid1 = [[Dizzy spells.]],
        mid2 = [[Blurred vision.]],
        mid3 = [[Head throbbing.]],
        -- mid = [[The mysterious voice is growing ever nearer...]],
    },
    b9 = { -- Distorted Gateways
        desc = [[A hall of millions of gateways to different realities, towers and wastelands... the mere thought of something like this is sickening...]],
        desc2 = [[The entrance to a false promise of paradise.]],
        desc3 = [[You reach the bottom... or it seemed to be at first glance... one last gateway was left...]],
        begin = [[The endless void beckons you...]],
        mid = [[Run.]],
        -- begin = [[You feel nostalgia at the sight of a familiar tower.]],
    },
    b10 = { -- Endless Void
        desc = [[A realm of absolutely nothing, none have ever returned.]],
        desc2 = [[You look back above... yet you've already gone too far in this insane abyss for you to see anything.]],
        -- begin = [[...and you pass the point of no return.]],
        -- mid1 = [[Everything begins to go quiet.]],
        end1 = [["...this is it?"]],
        end2 = [["This is what's down below all of this?"]],
        end3 = [[The void around you is rather empty and vast.]],
        end4 = [[Yet, it feels nostalgic somehow...]],
        end5 = [[...and peaceful.]],
    },
}
NegEvents = {
    -- B1: The Basement
    { h = -10 }, { text = 'b1.begin' },
    { h = -26 },
    { text = 'b1.noAS', color = 'lB', cond = function() return GAME.mod.AS == 0 end },
    {
        text = 'b1.ASoff',
        color = 'lO',
        cond = function() return GAME.mod.AS > 0 end,
        event = function()
            GAME.attackMul = GAME.attackMul - .1
            GAME.dmgTimerMul = GAME.dmgTimerMul + .01
            GAME.mod.AS = 0
            RefreshButtonText()
            GAME.refreshModIcon()
            GAME.refreshRPC()
        end,
    },

    -- B2: Zenith Restaurant
    { h = -50 }, { event = { 'dmgDelay', -2 } },
    { event = { 'attackMul', -.1, 'timerMul', -.25 } },
    { h = -55 }, { text = 'b2.begin' },
    { h = -60 },
    {
        text = 'b2.effStart',
        event = function()
            GAME.nightcore = true
            RefreshBGM()
        end
    },
    { h = -90 },
    { text = 'b2.noVL', color = 'lB', cond = function() return GAME.mod.VL == 0 end },
    {
        text = 'b2.VLoff',
        color = 'lO',
        cond = function() return GAME.mod.VL > 0 end,
        event = function()
            GAME.attackMul = GAME.attackMul - .1
            GAME.dmgTimerMul = GAME.dmgTimerMul + .01
            GAME.mod.VL = 0
            GAME.refreshModIcon()
            GAME.refreshRPC()
        end,
    },
    { h = -120 },
    { text = 'b2.noIN', color = 'lB', cond = function() return GAME.mod.IN == 0 end },
    {
        text = 'b2.INoff',
        color = 'lO',
        cond = function() return GAME.mod.IN > 0 end,
        event = function()
            GAME.dmgCycle = GAME.dmgCycle + GAME.mod.IN * 1
            GAME.attackMul = GAME.attackMul - .1
            GAME.dmgTimerMul = GAME.dmgTimerMul + .01
            GAME.mod.IN = 0
            RefreshBGM()
            for _, C in ipairs(Cards) do C:flip() end
            GAME.refreshModIcon()
            GAME.refreshRPC()
        end,
    },
    { h = -150 },
    {
        event = function()
            GAME.nightcore = false
            RefreshBGM()
        end
    },


    -- B3: Underground Parking
    { h = -150 }, { event = { 'dmgDelay', -2, 'dmgCycle', -.5 } },
    { event = { 'attackMul', -.1, 'timerMul', -.15 } },
    { h = -155 }, { text = 'b3.begin' },
    { h = -160 }, { text = 'b3.effStart' },
    { h = -165 }, { event = { 'invisUI', true } },
    { h = -170 }, { event = { 'invisUI', false } },
    { h = -175 }, { event = { 'invisUI', true } },
    { h = -180 }, { text = 'b3.mid1' },
    { h = -185 }, { event = { 'invisUI', false } },
    { h = -195 }, { event = { 'invisUI', true } },
    { h = -200 },
    { text = 'b3.noGV', color = 'lB', cond = function() return GAME.mod.GV == 0 end },
    {
        text = 'b3.GVoff',
        color = 'lO',
        cond = function() return GAME.mod.GV > 0 end,
        event = function()
            GAME.dmgDelay = GAME.dmgDelay + GAME.mod.GV * 4
            GAME.attackMul = GAME.attackMul - .1
            GAME.dmgTimerMul = GAME.dmgTimerMul + .01
            GAME.mod.GV = 0
            GAME.refreshModIcon()
            GAME.refreshRPC()
            RefreshBGM()
        end,
    },
    { h = -200 }, { event = { 'invisUI', false } },
    { h = -210 }, { event = { 'invisUI', true } },
    { h = -220 }, { text = 'b3.mid2' },
    { h = -250 }, { event = { 'invisUI', false } },
    { h = -260 }, { event = { 'invisUI', true } },
    { h = -280 }, { event = { 'invisUI', false } },

    -- B4: The Bunker
    { h = -300 }, { event = { 'dmgDelay', -1, 'dmgCycle', -.5 } },
    { event = { 'attackMul', -.1, 'timerMul', -.1 } },
    { h = -310 },
    { text = 'b4.begin' },
    { event = function() GAME.dmgWrong = math.min(GAME.dmgWrong, 2) end },
    { h = -320 }, { text = 'b4.effStart', event = { 'glassCard', true } },
    { h = -380 },
    { text = 'b4.noMS', color = 'lB', cond = function() return GAME.mod.MS == 0 end },
    {
        text = 'b4.MSoff',
        color = 'lO',
        cond = function() return GAME.mod.MS > 0 end,
        event = function()
            GAME.extraQuestBase = GAME.extraQuestBase - GAME.mod.MS * .2
            GAME.attackMul = GAME.attackMul - .1
            GAME.dmgTimerMul = GAME.dmgTimerMul + .01
            GAME.mod.MS = 0
            GAME.sortCards()
            GAME.refreshModIcon()
            GAME.refreshRPC()
        end,
    },
    { h = -450 }, { event = { 'glassCard', false } },

    -- B5: The Infirmary
    { h = -450 }, { event = { 'dmgDelay', -1, 'dmgCycle', -.5 } },
    { event = { 'attackMul', -.1 } },
    { event = function() GAME.dmgWrong = math.min(GAME.dmgWrong, 2) end },
    { h = -460 }, { text = 'b5.begin' },
    { h = -470 }, { text = 'b5.effStart', event = { 'slowmo', true } },
    { h = -550 },
    { text = 'b5.noDH', color = 'lB', cond = function() return GAME.mod.DH == 0 end },
    {
        text = 'b5.DHoff',
        color = 'lO',
        cond = function() return GAME.mod.DH > 0 end,
        event = function()
            GAME.extraQuestVar = GAME.extraQuestVar - GAME.mod.DH * .2
            GAME.attackMul = GAME.attackMul - .1
            GAME.dmgTimerMul = GAME.dmgTimerMul + .01
            GAME.mod.DH = 0
            RefreshButtonText()
            GAME.refreshModIcon()
            GAME.refreshRPC()
        end,
    },
    { h = -650 }, { event = { 'slowmo', false } },

    -- B6: Decayed Catacombs
    { h = -650 }, { event = { 'dmgDelay', -1, 'dmgTime', 1, 'maxQuestSize', 1 } },
    { event = { 'attackMul', -.1 } },
    { event = function() GAME.dmgWrong = math.min(GAME.dmgWrong, 2) end },
    { h = -660 }, { text = 'b6.begin' },
    { h = -670 }, { text = 'b6.effStart', event = { 'invisCard', true } },
    { h = -720 },
    { text = 'b6.noNH', color = 'lB', cond = function() return GAME.mod.NH == 0 end },
    {
        text = 'b6.NHoff',
        color = 'lO',
        cond = function() return GAME.mod.NH > 0 end,
        event = function()
            GAME.dmgHeal = GAME.dmgHeal + GAME.mod.NH * 3
            GAME.attackMul = GAME.attackMul - .1
            GAME.dmgTimerMul = GAME.dmgTimerMul + .01
            GAME.mod.NH = 0
            GAME.maxQuestCount = 3
            while #GAME.quests < 3 do GAME.genQuest() end
            GAME.refreshModIcon()
            GAME.refreshRPC()
        end,
    },
    { h = -850 }, { event = { 'invisCard', false } },

    -- B7: Sacreligious Ruins
    { h = -850 }, { event = { 'dmgDelay', -1, 'dmgCycle', -.5 } },
    { event = { 'attackMul', -.1 } },
    { event = function() GAME.dmgWrong = math.min(GAME.dmgWrong, 2) end },
    { h = -860 }, { text = 'b7.begin' },
    { h = -900 }, { text = 'b7.effStart' },
    { h = -950 }, { text = 'b7.mid' },

    -- B8: Singularity Reactor
    { h = -1100 }, { event = { 'dmgDelay', -1, 'dmgCycle', -.5 } },
    { event = function() GAME.dmgWrong = math.min(GAME.dmgWrong, 2) end },
    { h = -1115 }, { text = 'b8.begin' },
    { h = -1145 }, { text = 'b8.mid1', color = 'R', size = 1.26, sfx = 'b2bcharge_distance_3', duration = 1.26 },
    { h = -1160 }, { text = 'b8.mid2', color = 'R', size = 1.26, sfx = 'b2bcharge_distance_3', duration = 1.26 },
    { h = -1175 }, { text = 'b8.mid3', color = 'R', size = 1.26, sfx = 'b2bcharge_distance_3', duration = 1.26 },
    { h = -1182 }, { sfx = 'b2bcharge_distance_2' },
    { h = -1185 }, { sfx = 'b2bcharge_distance_2' },
    { h = -1188 }, { sfx = 'b2bcharge_distance_2' },
    { h = -1191 }, { sfx = 'b2bcharge_distance_1' },
    { h = -1194 }, { sfx = 'b2bcharge_distance_1' },
    { h = -1197 }, { sfx = 'b2bcharge_distance_1' },
    { h = -1200 },
    {
        event = function()
            GAME.nightcore = true
            RefreshBGM()
        end
    },

    { h = -1350 },
    {
        event = function()
            GAME.nightcore = false
            RefreshBGM()
        end
    },


    -- B9: Distorted Gateways
    { h = -1350 }, { event = { 'dmgDelay', -.5 } },
    { h = -1360 }, { text = 'b9.begin' },
    { event = function() GAME.rankLimit = math.min(GAME.rankLimit, 10) end },
    {
        text = 'b9.mid',
        color = 'lR',
        size = 2.6,
        duration = 16,
        event = function()
            GAME.time = math.max(GAME.time, 419)
        end
    },

    -- B10: Endless Void
    { h = -1650 },
    {
        event = function()
            GAME.negFloor = 0
            GAME.timerMul = 0
            GAME.dmgWrong = 1
            GAME.invisCard = true
            GAME.dmgTimerMul = 1e99
            GAME.height = -1650
            GAME.heightBonus = 0
            GAME.attackMul = -1
            GAME.chain = 0
            GAME.maxQuestCount = 1
            if GAME.rank > 8 then
                GAME.rank = 8
                GAME.xp = 32
            end
            GAME.xpLockLevelMax = 2600
            GAME.xpLockTimer = 2600
            GAME.xpLockLevel = 2600
            GAME.rankLimit = 8
            TEXTS.rank:set("R-" .. GAME.rank)

            GAME.mod.EX = 0
            GAME.refreshModIcon()
            GAME.refreshRPC()
            GAME.mod.EX = 2
        end,
    },
    { h = -1660 }, { text = 'b10.end1', color = 'L', duration = 6.26, sfx = 'piece_change', event = function() BGM.setVol(STAT.bgm / 100 * .85) end },
    { h = -1690 }, { text = 'b10.end2', color = 'L', duration = 6.26, sfx = 'piece_change', event = function() BGM.setVol(STAT.bgm / 100 * .7) end },
    { h = -1720 }, { text = 'b10.end3', color = 'L', duration = 6.26, sfx = 'piece_change', event = function() BGM.setVol(STAT.bgm / 100 * .5) end },
    { h = -1750 }, { text = 'b10.end4', color = 'L', duration = 6.26, sfx = 'piece_change', event = function() BGM.setVol(STAT.bgm / 100 * .3) end },
    { h = -1780 }, { text = 'b10.end5', color = 'L', duration = 6.26, sfx = 'piece_change', event = function() BGM.setVol(STAT.bgm / 100 * 0) end },
    { h = -1800 },
    {
        event = function()
            GAME.heightBonus = 0
            GAME.height = -1800
            FloatOnCard = nil
            GAME.refreshLayout()
            STAT.clicker = true
            SFX.play('warp')
            SCN.go('ending', "warp")
        end
    },
    { h = -1e99 },
}
local lastH = -0
for _, e in next, NegEvents do
    e.cond = e.cond or TRUE
    e.text = e.text and TABLE.pathIndex(NegTexts, e.text) or e.text
    e.text2 = e.text2 and TABLE.pathIndex(NegTexts, e.text2) or e.text2
    if e.h then
        assert(e.h <= lastH)
        lastH = e.h
    else
        e.h = lastH
    end
end

Fatigue = {
    normal = {
        { time = 90,  event = { 'extraQuestBase', .2, 'animDuration', .5 } },
        { time = 180, event = { 'extraQuestBase', .2, 'animDuration', .5 } },
        { time = 240, event = { 'extraQuestBase', .2, 'animDuration', 1 } },
        { time = 300, event = { 'dmgTimerMul', -.1, 'animDuration', 1 },                   text = "FATIGUE SETS IN_",          desc = "TimerSpeed++" },
        { time = 330, event = { 'dmgCycle', -.5, 'dmgWrong', 1 },                          text = "YOUR BODY GROWS WEAK_",     desc = "DmgCycle--   Damage++" },
        { time = 360, event = { 'dmgTimerMul', -.1, 'dmgHeal', -1, 'animDuration', 1 },    text = "ALL SENSES BLUR TOGETHER_", desc = "TimerSpeed++   Heal--" },
        { time = 390, event = { 'dmgTimerMul', -.1, 'dmgWrong', 1 },                       text = "YOUR CONSCIOUSNESS FADES_", desc = "TimerSpeed++   Damage++" },
        { time = 420, event = { 'dmgTimerMul', -.05, 'dmgCycle', -.5, 'animDuration', 1 }, text = "THIS IS THE END.",          desc = "TimerSpeed++   DmgCycle--" },
        { time = 422, event = { 'dmgTimerMul', -.05 } },
        { time = 425, event = { 'dmgTimerMul', -.05 } },
        { time = 430, event = { 'dmgTimerMul', -.05 } },
        { time = 480, event = { 'atkBufferCap', 6, 'animDuration', 1, 'maxQuestSize', 1 }, text = "FAREWELL.",                 desc = "QuestDifficulty++++++",    duration = 26, color = 'lB', },
        { time = 485, event = { 'atkBufferCap', 6, 'animDuration', 1, 'extraQuestVar', 1 } },
        { time = 490, event = { 'atkBufferCap', 6, 'animDuration', 1 } },
        { time = 1e99 }, -- Total: dmgTimerMul-50%, Cycle-1, Wrong+2
    },
    rEX = {
        { time = 90,  event = { 'extraQuestBase', .2, 'animDuration', .5 } },
        { time = 180, event = { 'extraQuestBase', .2, 'animDuration', .5 } },
        { time = 240, event = { 'extraQuestBase', .2, 'animDuration', 1 } },
        { time = 240, event = { 'dmgTimerMul', -.2 },                                   text = "YOUR POWER SLIPS_",               desc = "TimerSpeed++" },
        { time = 270, event = { 'dmgWrong', 2 },                                        text = "WHISPERS OF DISCONTENT SPREAD_",  desc = "Damage++" },
        { time = 300, event = { 'dmgCycle', -1, 'animDuration', 1 },                    text = "PROTESTERS LINE THE STREETS_",    desc = "DmgCycle--" },
        { time = 330, event = { 'dmgTimerMul', -.2, 'dmgWrong', 2 },                    text = "YOUR CLOSEST ALLIES DEFECT_",     desc = "TimerSpeed++   Damage++" },
        { time = 360, event = { 'dmgTimerMul', -.1, 'dmgHeal', -1, 'animDuration', 1 }, text = "PARANOIA CLOUDS YOUR JUDGEMENT_", desc = "TimerSpeed++   Heal--" },
        { time = 362, event = { 'dmgTimerMul', -.05 } },
        { time = 365, event = { 'dmgTimerMul', -.05 } },
        { time = 390, event = { 'dmgCycle', -.5, 'dmgWrong', 1 },                       text = "THE REVOLUTION HAS BEGUN_",       desc = "DmgCycle--   Damage++" },
        { time = 420, event = { 'dmgTimerMul', -.1, 'animDuration', 1 },                text = "THE END OF AN ERA.",              desc = "TimerSpeed++++",         duration = 10 },
        { time = 423, event = { 'dmgTimerMul', -.05 } },
        { time = 426, event = { 'dmgTimerMul', -.05 } },
        { time = 430, event = { 'dmgTimerMul', -.05 } },
        { time = 435, event = { 'dmgTimerMul', -.03 } },
        { time = 440, event = { 'dmgTimerMul', -.02 } },
        { time = 1e99 }, -- Total: dmgTimerMul-90%, Cycle-1.5, Wrong+5
    },
    rDP = {
        { time = 20,  event = { 'dmgHeal', -1 }, --[[ 2 ]]                       text = "PASSION IS FADING AWAY_",                        desc = "Heal-",          duration = 10 },
        { time = 40,  event = { 'dmgHeal', -.5 }, --[[ 1.5 ]]                    text = "INSECURITIES GROW STRONGER_",         desc = "Heal--",         duration = 10 },
        { time = 60,  event = { 'dmgHeal', -.5, 'animDuration', .5 }, --[[ 1 ]]  text = "YOU FEEL NEGLECTED_",                        desc = "Heal---",        duration = 10 },
        { time = 80,  event = { 'dmgHeal', 1 }, --[[ 2 ]]                        text = "THEY SUCCESSFULLY APOLOGIZE_?",              desc = "Heal+",          duration = 10, color = 'lO' },
        { time = 90,  event = { 'extraQuestBase', .2 } },
        { time = 100, event = { 'dmgHeal', 1 }, --[[ 3 ]]                        text = "THINGS ARE BACK TO HOW THEY SHOULD BE_!",   desc = "Heal+++",        duration = 10, color = 'lO' },
        { time = 120, event = { 'dmgHeal', -1, 'animDuration', .5 }, --[[ 2 ]]   text = "THE WEIGHT OF WORDS UNSPOKEN_",       desc = "Heal--",         duration = 10 },
        { time = 140, event = { 'dmgHeal', -1 }, --[[ 1 ]]                       text = "YOU BLAME THEM FOR YOUR OWN PROBLEMS_",      desc = "Heal---",        duration = 10 },
        { time = 160, event = { 'reviveDifficulty', 3 },                         text = "THEY WOULD RATHER SPEND TIME ALONE_",        desc = "Revive++",       duration = 10 },
        { time = 180, event = { 'extraQuestBase', .2 } },
        { time = 180, event = { 'dmgHeal', 1.5, 'animDuration', 1 }, --[[ 2.5 ]] text = "YOU MAKE A PROMISE TO CHANGE AGAIN_",                     desc = "Heal++",         duration = 10, color = 'lO' },
        { time = 200, event = { 'dmgTimerMul', -.2 },                            text = "PROMISES ARE BROKEN_",                       desc = "TimerSpeed++",   duration = 10 },
        { time = 220, event = { 'dmgHeal', -.5 }, --[[ 2 ]]                      text = "CONVERSATIONS DEVOLVE TO SHOUTING MATCHES_", desc = "Heal---",        duration = 10 },
        { time = 240, event = { 'extraQuestBase', .2, 'animDuration', 1 } },
        { time = 240, event = { 'dmgHeal', -.5 }, --[[ 1.5 ]]                    text = "ALL TRUST HAS WITHERED AWAY_",               desc = "Heal--",         duration = 10 },
        { time = 260, event = { 'dmgHeal', -.5 }, --[[ 1 ]]                      text = "THEY SET AN ULTIMATUM_",                     desc = "Heal--",         duration = 10 },
        { time = 280, event = { 'dmgHeal', -.5 }, --[[ .5 ]]                     text = "YOU CAN'T BE BOTHERED ANYMORE_",             desc = "Heal--",         duration = 10 },
        { time = 300, event = { 'dmgWrong', 2, 'animDuration', 1 },              text = "ONE LAST PAINFUL ARGUMENT_",                 desc = "Dmg+",           duration = 10 },
        { time = 320, event = { 'reviveDifficulty', 9999 },                      text = "GOODBYE.",                                   desc = "You can no longer revive",      duration = 10, color = 'R' },
        { time = 360, event = { 'dmgHeal', 1, 'animDuration', 1 }, --[[ 1.5 ]]   text = "\"I MISS YOU\"",                             desc = "Heal+++",        duration = 10, color = 'lO' },
        { time = 380, event = { 'dmgHeal', 1 }, --[[ 2.5 ]]                      text = "WHAT IF_?",                  desc = "Heal+",          duration = 10, color = 'lO' },
        { time = 400, event = { 'dmgTimerMul', -.1, 'animDuration', 4 },         text = "_",                                   desc = "TimerSpeed++++", duration = 10 },
        { time = 402, event = { 'dmgTimerMul', -.1 } },
        { time = 405, event = { 'dmgTimerMul', -.1 } },
        { time = 408, event = { 'dmgTimerMul', -.05 } },
        { time = 412, event = { 'dmgTimerMul', -.05 } },
        { time = 416, event = { 'dmgTimerMul', -.05 } },
        { time = 420, event = { 'dmgTimerMul', -.03 } },
        { time = 425, event = { 'dmgTimerMul', -.02 } },
        { time = 1e99 }, -- Total: dmgTimerMul-70%
    },
}
-- My formatter doesn't work if there's "…" inside
for _, f in next, Fatigue do for _, v in next, f do if v.text then v.text = v.text:gsub("_", "…") end end end

local function rndMod(t)
    local d = ModData.deck[math.random(9)].id
    t.prompt = t.prompt:repD(d)
    t.text = t.text:repD(ModData.adj[d])
    t.short = t.short:repD(d)
end
local function f5() return GAME.floor <= 5 end
local function F6() return GAME.floor >= 6 end
local function F9() return GAME.floor >= 9 end

---@class Prompt
---@field rank number[]
---@field prompt string
---@field target number
---@field short string
---@field text string
---@field cond? fun():boolean
---@field init? fun(t:Prompt)

---@type Prompt[]
RevivePrompts = {
    { rank = { 1, 2 }, prompt = 'activate',             target = 30,  short = "Activate 30",             text = "Activate 30 cards" },
    { rank = { 3, 4 }, prompt = 'activate',             target = 80,  short = "Activate 80",             text = "Activate 80 cards" },
    { rank = { 2, 2 }, prompt = 'cancel',               target = 40,  short = "Cancel 40",               text = "Cancel 40 cards" },
    { rank = { 3, 4 }, prompt = 'cancel',               target = 100, short = "Cancel 100",              text = "Cancel 100 cards" },
    { rank = { 1, 2 }, prompt = 'flip',                 target = 50,  short = "Flip 50",                 text = "Flip 50 cards" },
    { rank = { 3, 4 }, prompt = 'flip',                 target = 120, short = "Flip 120",                text = "Flip 120 cards" },
    { rank = { 5, 6 }, prompt = 'flip',                 target = 300, short = "Flip 300",                text = "Flip 300 cards" },
    { rank = { 1, 2 }, prompt = 'flip_single',          target = 10,  short = "Flip single 10",          text = "Flip a single card\n10 times in a row" },
    { rank = { 2, 4 }, prompt = 'flip_single',          target = 20,  short = "Flip single 20",          text = "Flip a single card\n20 times in a row" },
    { rank = { 1, 2 }, prompt = 'commit',               target = 6,   short = "Commit 6x",               text = "Commit 6 times" },
    { rank = { 2, 3 }, prompt = 'commit',               target = 15,  short = "Commit 15x",              text = "Commit 15 times" },
    { rank = { 3, 5 }, prompt = 'commit',               target = 30,  short = "Commit 30x",              text = "Commit 30 times" },
    { rank = { 1, 2 }, prompt = 'commit_$1',            target = 2,   short = "Commit $1 2x",            text = "Commit twice\nwith $1",                     init = rndMod },
    { rank = { 3, 4 }, prompt = 'commit_$1',            target = 4,   short = "Commit $1 4x",            text = "Commit 4 times\nwith $1",                     init = rndMod },
    { rank = { 2, 4 }, prompt = 'commit_$1_row',        target = 2,   short = "2 Chain with $1",         text = "Commit twice\nwith $1 in a row",            init = rndMod },
    { rank = { 3, 6 }, prompt = 'commit_$1_row',        target = 3,   short = "3 Chain with $1",         text = "Commit 3 times\nwith $1 in a row",            init = rndMod },
    { rank = { 1, 3 }, prompt = 'commit_no_$1_row',     target = 2,   short = "2 chain without $1",      text = "Commit twice\nwithout $1 in a row",         init = rndMod },
    { rank = { 3, 5 }, prompt = 'commit_no_$1_row',     target = 3,   short = "3 chain without $1",      text = "Commit 3 times\nwithout $1 in a row",         init = rndMod },
    { rank = { 1, 2 }, prompt = 'commit_0',             target = 2,   short = "Commit NOTHING 2x",       text = "Commit NOTHING\ntwice" },
    { rank = { 2, 4 }, prompt = 'commit_0',             target = 5,   short = "Commit NOTHING 5x",       text = "Commit NOTHING\n5 times" },
    { rank = { 4, 6 }, prompt = 'commit_0',             target = 8,   short = "Commit NOTHING 8x",       text = "Commit NOTHING\n8 times" },
    { rank = { 1, 3 }, prompt = 'commit_0_row',         target = 3,   short = "3x Spam commit",          text = "Commit NOTHING\n3 times in a row" },
    { rank = { 3, 5 }, prompt = 'commit_no_conn',       target = 1,   short = "Commit no consec",        text = "Commit without consecutive cards",            cond = F6 },
    { rank = { 1, 4 }, prompt = 'commit_conn_2',        target = 1,   short = "Commit 2 consec",         text = "Commit with 2 consecutive cards",             cond = f5 },
    { rank = { 2, 4 }, prompt = 'commit_conn_3',        target = 1,   short = "Commit 3 consec",         text = "Commit with 3 consecutive cards",             cond = f5 },
    { rank = { 3, 5 }, prompt = 'commit_conn_4',        target = 1,   short = "Commit 4 consec",         text = "Commit with 4 consecutive cards" },
    { rank = { 3, 5 }, prompt = 'commit_swamp_l',       target = 1,   short = "SWAMP WATER LITE",        text = "Commit SWAMP WATER LITE" },
    { rank = { 4, 6 }, prompt = 'commit_swamp',         target = 1,   short = "SWAMP WATER",             text = "Commit SWAMP WATER" },
    { rank = { 3, 6 }, prompt = 'commit_reversed',      target = 1,   short = "Commit inversed",         text = "Commit all cards\nthat aren't requested" },
    { rank = { 1, 4 }, prompt = 'commit_1card',         target = 3,   short = "Commit 1 cards 3x",       text = "Commit 3 times with\n1 card on first commit" },
    { rank = { 2, 5 }, prompt = 'commit_2card',         target = 4,   short = "Commit 2 cards 4x",       text = "Commit 4 times with\n2 cards on first commit" },
    { rank = { 3, 6 }, prompt = 'commit_3card',         target = 5,   short = "Commit 3 cards 5x",       text = "Commit 5 times with\n3 cards on first commit" },
    { rank = { 4, 6 }, prompt = 'commit_4card',         target = 4,   short = "Commit 4 cards 4x",       text = "Commit 4 times with\n4 cards on first commit" },
    { rank = { 5, 6 }, prompt = 'commit_5card',         target = 3,   short = "Commit 5 cards 3x",       text = "Commit 3 times with\n5 cards on first commit" },
    { rank = { 1, 4 }, prompt = 'pass',                 target = 10,  short = "Pass 10",                 text = "Pass 10 times" },
    { rank = { 5, 6 }, prompt = 'pass',                 target = 20,  short = "Pass 20",                 text = "Pass 20 times" },
    { rank = { 2, 5 }, prompt = 'pass_$1',              target = 2,   short = "Pass 2 with $1",          text = "Pass twice\nwith $1",                       init = rndMod },
    { rank = { 3, 5 }, prompt = 'pass_$1',              target = 3,   short = "Pass 3 with $1",          text = "Pass 3 times\nwith $1",                       init = rndMod },
    { rank = { 4, 6 }, prompt = 'pass_$1',              target = 4,   short = "Pass 4 with $1",          text = "Pass 4 times\nwith $1",                       init = rndMod },
    { rank = { 2, 4 }, prompt = 'pass_perfect',         target = 6,   short = "6x perf",                 text = "Get 6 perfect passes" },
    { rank = { 5, 6 }, prompt = 'pass_perfect',         target = 12,  short = "12x perf",                text = "Get 12 perfect passes" },
    { rank = { 2, 4 }, prompt = 'pass_imperfect',       target = 6,   short = "6x im-perf",              text = "Get 6 imperfect passes" },
    { rank = { 5, 6 }, prompt = 'pass_imperfect',       target = 12,  short = "12x im-perf",             text = "Get 12 imperfect passes" },
    { rank = { 4, 5 }, prompt = 'pass_imperfect_row',   target = 3,   short = "3x chain im-perf",        text = "Get 3 imperfect\npasses in a row" },
    { rank = { 5, 6 }, prompt = 'pass_imperfect_row',   target = 8,   short = "8x chain im-perf",        text = "Get 8 imperfect\npasses in a row" },
    { rank = { 2, 4 }, prompt = 'pass_perfect_row',     target = 4,   short = "4x chain perf",           text = "Get 4 perfect\npasses in a row" },
    { rank = { 3, 5 }, prompt = 'pass_perfect_row',     target = 6,   short = "6x chain perf",           text = "Get 6 perfect\npasses in a row" },
    { rank = { 4, 5 }, prompt = 'pass_perfect_row',     target = 8,   short = "8x chain perf",           text = "Get 8 perfect\npasses in a row" },
    { rank = { 4, 6 }, prompt = 'pass_perfect_row',     target = 10,  short = "10x chain perf",          text = "Get 10 perfect\npasses in a row" },
    { rank = { 2, 3 }, prompt = 'pass_second',          target = 4,   short = "2nd quest 4x",            text = "Pass the second\nquest 4 times" },
    { rank = { 3, 4 }, prompt = 'pass_second',          target = 8,   short = "2nd quest 8x",            text = "Pass the second\nquest 8 times" },
    { rank = { 4, 5 }, prompt = 'pass_second',          target = 12,  short = "2nd quest 12x",           text = "Pass the second\nquest 12 times" },
    { rank = { 2, 4 }, prompt = 'b2b_break_4',          target = 1,   short = "Break B2B 4x",            text = "Break the B2B chain\nat B2B x4" },
    { rank = { 3, 4 }, prompt = 'b2b_break_6',          target = 1,   short = "Break B2B 6x",            text = "Break the B2B chain\nat B2B x6" },
    { rank = { 4, 5 }, prompt = 'b2b_break_8',          target = 1,   short = "Break B2B 8x",            text = "Break the B2B chain\nat B2B x8" },
    { rank = { 4, 6 }, prompt = 'b2b_break_10',         target = 1,   short = "Break B2B 10x",           text = "Break the B2B chain\nat B2B x10" },
    { rank = { 4, 6 }, prompt = 'b2b_break_windup',     target = 1,   short = "Break B2B at a windup",   text = "Break the B2B chain\nat a windup",                       cond = F9 },
    { rank = { 5, 6 }, prompt = 'b2b_break_windup3',    target = 1,   short = "Break B2B at a windup3+", text = "Break the B2B chain at\na Lv. 3+ windup",                cond = F9 },
    { rank = { 1, 3 }, prompt = 'heal',                 target = 8,   short = "Heal 8 HP",               text = "Heal 8 HP" },
    { rank = { 2, 4 }, prompt = 'heal',                 target = 20,  short = "Heal 20 HP",              text = "Heal 20 HP" },
    { rank = { 1, 2 }, prompt = 'send',                 target = 6,   short = "Send 6",                  text = "Send 6 Attack" },
    { rank = { 3, 4 }, prompt = 'send',                 target = 20,  short = "Send 20",                 text = "Send 20 Attack" },
    { rank = { 5, 6 }, prompt = 'send',                 target = 40,  short = "Send 40",                 text = "Send 40 Attack" },
    { rank = { 3, 4 }, prompt = 'pass_windup',          target = 1,   short = "Windup",                  text = "Pass a windup",                               cond = F9 },
    { rank = { 3, 5 }, prompt = 'pass_windup3',         target = 1,   short = "Windup3+",                text = "Pass a Lv. 3 windup\nor higher",                         cond = F9 },
    { rank = { 5, 5 }, prompt = 'pass_windup_inb2b',    target = 1,   short = "Windup with B2B",         text = "Pass a windup\n with one B2B charge",        cond = F9 },
    { rank = { 4, 5 }, prompt = 'pass_windup',          target = 4,   short = "Windup x 4",              text = "Pass four windups",                              cond = F9 },
    { rank = { 4, 4 }, prompt = 'pass_windup_perfect',  target = 1,   short = "Windup perf",             text = "Pass a windup\nperfectly",                    cond = F9 },
    { rank = { 6, 6 }, prompt = 'pass_windup_inb2b',    target = 3,   short = "Windup x 3 with B2B",     text = "Pass 4 windups while\nholding a B2B charge",         cond = F9 },
    { rank = { 5, 5 }, prompt = 'pass_windup_perfect',  target = 4,   short = "Windup perf x 4",         text = "Pass four windups\nperfectly",                   cond = F9 },
    { rank = { 5, 5 }, prompt = 'pass_windup3_perfect', target = 1,   short = "Windup3+ perf",           text = "Pass a Lv. 3+\nwindup perfectly",              cond = F9 },
    { rank = { 6, 6 }, prompt = 'pass_windup3_perfect', target = 4,   short = "Windup3+ perf x 4",       text = "Pass four Lv. 3+\nwindups perfectly",             cond = F9 },
    { rank = { 2, 2 }, prompt = 'dmg_time',             target = 4,   short = "Take Dmg 4x",             text = "Take damage 4 times" },
    { rank = { 3, 3 }, prompt = 'dmg_time',             target = 8,   short = "Take Dmg 8x",             text = "Take damage 8 times" },
    { rank = { 2, 4 }, prompt = 'dmg_amount',           target = 10,  short = "Lose 10 HP",              text = "Take 10 damage total" },
    { rank = { 4, 6 }, prompt = 'dmg_amount',           target = 20,  short = "Lose 20 HP",              text = "Take 20 damage total" },
    { rank = { 3, 4 }, prompt = 'timedmg_time',         target = 2,   short = "Take Time Dmg 2x",        text = "Take time damage 2 times",                    cond = F6 },
    { rank = { 5, 6 }, prompt = 'timedmg_time',         target = 4,   short = "Take Time Dmg 4x",        text = "Take time damage 4 times",                    cond = F6 },
    { rank = { 4, 6 }, prompt = 'keep_health_safe',     target = 8,   short = "High HP 8s",              text = "Have high HP for\n8 seconds",                 cond = F6 },
    { rank = { 4, 5 }, prompt = 'keep_health_danger',   target = 3,   short = "Low HP 3s",            text = "Have low HP for\n3 seconds",            cond = F6 },
    { rank = { 2, 5 }, prompt = 'keep_no_mouse',        target = 4,   short = "No mouse 4s",             text = "Don't use the mouse\nfor 4 seconds",            cond = f5 },
    { rank = { 2, 4 }, prompt = 'keep_no_commit',       target = 6,   short = "No commit 6s",            text = "Don't commit\nfor 6 seconds",                 cond = f5 },
    { rank = { 3, 6 }, prompt = 'keep_no_cancel',       target = 8,   short = "No cancel 8s",            text = "Don't cancel\nfor 8 seconds" },
    { rank = { 2, 5 }, prompt = 'keep_no_keyboard',     target = 10,  short = "No keyboard 10s",         text = "Don't use the keyboard\nfor 10 seconds",        cond = F6 },
    { rank = { 3, 5 }, prompt = 'keep_no_perfect',      target = 12,  short = "No perfect 12s",          text = "Have no perfect\npasses for 12 seconds" },
    { rank = { 4, 6 }, prompt = 'keep_no_imperfect',    target = 14,  short = "No imperfect 14s",        text = "Have no imperfect\npasses for 14 seconds",             cond = F6 },
    { rank = { 3, 5 }, prompt = 'keep_no_reset',        target = 16,  short = "No reset 16s",            text = "Don't reset\nfor 16 seconds" },
}

DevScore = {contender=6237,elegance=251237,garbage_offensive=1269350,tower_climber=3911636.25,speed_player=3375,zenith_explorer=10666.27,zenith_explorer_plus=14334.49,clicker_speedrun=17.666060159,typer_speedrun=11.339685894,supercharged=288,supercharged_plus=288,multitasker=48370.24,effective=34874.96658,zenith_speedrun=52.277,zenith_speedrun_plus=34.994,zenith_challenger=74554.63,divine_challenger=46448.96,zenith_speedrunner=553.477,divine_speedrunner=931.003,the_spike_of_all_time=393,the_spike_of_all_time_minus=162,clock_out=128,vip_list=17,GVIN=6538.4,ASNH=9830.74,DPEX=5417.82,GVNH=8373.29,DHMSNH=4603.14,DHEXNH=4520.53,DHEXMSVL=2766.57,ASEXVL=4432.7,swamp_water_lite=4560.15,swamp_water=2447.67,swamp_water_pro=2233.36,DHEXrGV=4597.23,rASrGV=12092.56,rGVrIN=3470.17,NHrAS=9560.7,GVrASrDH=3595.35,DHrMSrNH=2206.04,rGVrNHrVL=2487.95,rINrNH=2126.54,EXGVNHrMS=2277.21,ASDPGVrMSrNH=2005.6,DHrEXrVL=1664.66,ASGVrDPrMS=1551.46,NHVLrDPrGV=2178.42,VLrEXrIN=1379.08,rDPrEX=1650,INMSrDHrEX=1201.82,ASMSrDHrIN=773.9,swamp_water_lite_plus=2447.67,swamp_water_plus=2447.67,swamp_water_pro_plus=1845.46,blight=4487.36,desolation=2638.46,havoc=2480.82,pandemonium=2068.58,lovers_promise=7605.62,love_hotel=2.597011165,perdition=969.95,cataclysm=802.22,annihilation=777.19,armageddon=423.31,human_experiment=2.733007991,thermal_anomaly=0.46684615700001,ultra_dash=0.498314056,perfect_speedrun=24.607504283,the_perfectionist=5448.2,petaspeed=22,cruise_control=21,the_spike_of_all_time_plus=466,skys_the_limit=0,superluminal=0,cut_off=0,patience_is_a_virtue=2627.37,spotless=2916.6,clutch_main=191,honeymoon=2211.87,break_up=1519.21,overprotection=1986.85,sunk_cost=3617.87,royal_resistance=0,lovers_stand=0,romantic_homicide=0,its_kinda_rare=0,benevolent_ambition=0,fruitless_effort=0,psychokinesis=1462.25,divine_rejection=1649.99,omnipotence=0,clicking_champion=0,respectful=0,zenith_relocation=0,intended_glitch=0,lucky_coincidence=0,dark_force=0,zenith_traveler=0,smooth_dismount=0,VL=6275.59,NH=7390.17,MS=5384.91,IN=7068.16,GV=10604.39,EX=6246.78,DP=7605.62,DH=9644.52,AS=14334.49,rVL=6036.9,rNH=4056.03,rMS=3213.8,rIN=4095.01,rGV=8520,rEX=2013.73,rDP=3617.87,rDH=2580.51,rAS=12315.11,identity=0,clicker=676043,inferno=1775.53,purgatory=1257,abyss=166.09,talentless=7817.15,block_rationing=631.02,the_responsible_one=17,the_unreliable_one=14,carried=3573.21,guardian_angel=6061.19,the_escape_artist=132,fel_magic=107,powerless=5845.4,false_god=0,subjugation=0,workaholic=2.3799148589999,museum_heist=2.4841288230001,unfair_battle=4.344901018,financially_responsible=5.898309714,detail_oriented=44,the_pacifist=350,arrogance=772.74,the_oblivious_artist=110,empurple=2919.81,the_masterful_juggler=122,wax_wings=1817.92,abyss_weaver=0,speedrun_speedrunning=0,final_defiance=0,the_harbinger=0,terminal_velocity=0,mastery=0,worn_out=0,}
