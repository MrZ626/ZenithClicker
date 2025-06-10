# Zenith Clicker

    Welcome to Zenith Clicker, where the goal is to select required Tarot cards and send players to scale the tower.  
    As you keep climbing, more tricky players will come!  
    Leaderboards aren't available, but how high can you reach?

> Almost all art and sounds are from [TETR.IO](https://tetr.io), a modern yet familiar online stacker game by osk with amazing graphics and music.

**WARNING**: This game requires the knowledge of the mechanics and mods of TETR.IO's Quick Play 2, or you won't get much fun.  
If you like the Quick Play 2 mode but don't know much about it, check another repo of mine: [QP2 Documentation](https://github.com/MrZ626/io_qp2_rule) (in Chinese, with some translated forks). It's nearly a full explanation of QP2, including many technical details behind the scenes, which can allow you to play QP2 with better strats!

**Zenith Clicker** is a game inspired by the Quick Play 2 mod selection menu of TETR.IO. Its interactive feel is really not good for quickly picking the mods needed, and there's still no convenient way to know which mods are included in a specific combo.

Powered by LÖVE & Zenitha & Lua ~~instead of slow web engine~~

Credits:  
*MrZ*: Programming, game design, general development  
*CreepercraftYT*: Detailed mod icons  
*DJ Asriel*: Background reconstruction  
*Flowerling*: Text Revision  
*flomikel & Spritzy Sheep*: Additional text writing  
*Dr Ocelot*: Audio & music
*osk*: Founder & lead producer of TETR.IO  
*Garbo*: Game & world designer of TETR.IO  
*Frutigеr*: Font designer (D-Din-Pro)  
*Mooniak*: Font designer (AbhayaLibre)  
*Lorc & Delapouite & Quoting*: Some achievement icons (on https://game-icons.net, CC BY 3.0)

## How to Play

After you start the game, you will see three mod combinations, which are called "quests", shown at the top of the screen. Select the mods which are contained by the first (largest) one, then press the `Start` button to commit.

Pass quests with one click at most on each card to get "perfect pass", which gives extra attack and increases B2B. At B2Bx4, it starts charging up a huge Surge Attack that releases all at once at the end of your chain.

Each mod creates a unique experience by twisting the rules, but also increases the difficulty.

## Mod Effects (may not be exactly correct & complete)

### Expert (`EX`)

- Cards are **10px (9%)** closer together.
- Climb speed **decays 67% faster.**
- Cards are deactivated after failure.
- All actions happen on button **release** instead of button press.
- AS keyboard hints are not shown (if enabled).

### No Hold (`NH`)

- You cannot manually deselect cards.

#### Messiness (`MS`)

- Cards are **lightly shuffled** at the start of **floors 1, 2, 5, and 8**. The cards will always be in or adjacent to their correct position.

### Gravity (`GV`)

- **Automatically commit** some time after the first card flip. The timer starts at **9s** at floor 1, and decreases every floor until **4s** at floor 10. The timer will also automatically start if you flip no cards for 2.6s.

### Volatility (`VL`)

- Cards are **20px (18%)** further apart.
- Cards must be pressed **twice** to activate, but deactivating still takes a single press.

### Double Hole (`DH`)

- Quests are harder.
- Quests can sometimes be slightly shuffled.
- TODO: add specifics to difficulty change

### Invisible (`IN`)

- All cards are **face down**.
- Quest colours are desaturated.
- Quest hints are only shown for a moment **every two seconds**..

### All-Spin (`AS`)

- You can flip cards with your keyboard: on ANSI QWERTY layout, the inputs are 1-9, Q-O, or A-L. If cards are shuffled by `(r)MS`, they are flipped based on their *position*, not by which card they are.
- The RESET button is replaced with **SPIN**. Using SPIN quickly flips all cards one-by-one.
- Flipping a card will apply a **burn** to it, indicated by it flashing yellow. Burns last **3s** and this duration increases by **0.5s per floor**. They can be removed by committing (even if the selected card is a wrong one) or pressing SPIN. Flipping a burned card will cause you to get **wounded**, force-flipping two cards. These cards do *not* get a Burn.

### Duo (`DP`)

- There are two "players" instead of one. You can swap players by activating the Duo card, or by completing the second quest in the queue (the cards will be highlighted pink while you do this).
- If one player is incapacitated, your ascension is halved and quests becomes harder, but they can be revived by completing some revive prompts.
- Quests are a bit harder.
- TODO: specifics on tasks

## SPOILERS

<details>
<summary>
Make sure you've discovered most contents before reading this section!
</summary>

### The Tyrant (`rEX`)

- **Has ALL the effects of Expert.**
- Fatigue is much harsher.
- Passing a quest with Duo no longer gives +2 attack.
- **You fall downward** instead of passively climbing. The speed increases quadratically from **0.6m/s** on Floor 1 to **6m/s** on Floor 10.
- Staying on the same floor for over 30 seconds will slowly increase damage on mistake.

### Asceticism (`rNH`)

- The keyboard is disabled if (r)AS is not enabled. 
- The RESET/SPIN button is removed.
- The **next queue** is removed. If (r)DP is enabled, it will show only one next quest.
- Quest **colours** are faded.
- Cards are **not deselected** after committing.

### Loaded Dice (`rMS`)

- Cards are shuffled at the start of **every floor**. This effect gets stronger for every odd-numbered floor reached, with cards straying further from their correct positions.
- On commit, **swap two cards**, three on Floor 9/10. The cards must be within a five-card range.

### Freefall (`rGV`)

- The auto-commit timer starts at **3.2s** and decreases every floor down to a minimum of **2s**.

### Last Stand (`rVL`)

- Cards are **40px (36%)** further apart.
- Cards must be pressed **four times** to activate *and* to **deactivate**!

### Damnation (`rDH`)

- Quests are harder.
- Most combos are given a **community name**!
- TODO: specifics again

### The Exile (`rIN`)

- **Has ALL the effects of Invisible with some differences below:**
- Quest hints are **not shown** at all!
- Quests **fade away** after a short time, but reappear if you make a wrong commit. They disappear faster as you reach higher floors.

| Floor | rNH Protection | Fade Time |
| :---: | :------------: | :-------: |
|   1   |     0.026s     |   2.37s   |
|   2   |     0.052s     |   1.47s   |
|   3   |     0.078s     |   1.06s   |
|   4   |     0.104s     |   0.83s   |
|   5   |     0.130s     |   0.68s   |
|   6   |     0.156s     |   0.58s   |
|   7   |     0.182s     |   0.50s   |
|   8   |     0.208s     |   0.45s   |
|   9   |     0.234s     |   0.40s   |
|  10   |     0.260s     |   0.36s   |

### The Warlock (`rAS`)

- **Has ALL the effects of All-Spin with some differences below:**
- SPINs are faster than normal.
- Wounds flip **four cards** instead of two.
- SPINs and wrong commits will **not remove Burns**, and they aren't removed over time!
- B2B >= 4 sends **+1 attack**, but passing imperfectly **sends nothing**!

### Bleeding Hearts (`rDP`)

- **Has ALL the effects of Duo with some differences below:**
- A special fatigue system is used.
- **Half the amount of attack you send** goes to the inactive player.
- If one player is incapacitated, **you won't be able to climb** and half the amount of attack sent goes to the **active player**!

### Hard Mode

- **Expert and ALL reversed modifiers activate Hard Mode with the following effects.**
- Activating a correct card for the first time no longer gives +1 Climb Speed XP.
- Quest hints take longer to appear (**1.5s longer**, or on IN, **38% longer** between flashes)

## Behind the Scenes

### Clicker Rating (CR)

Just like TR, the maximum value is 25000,  
but CR is calculated from:

1. Best Height (5k)
1. Best Time (5k)
1. Mod Completion (3k)
1. Mod Speedrun (2k)
1. Zenith Point (3k)
1. Daily Challenge (2k)
2. Achievement (5k)

For the exact formula, see function `calculateRating()` in this [file](/module/scene/stat.lua)

### Zenith Point (ZP)

You gain ZP after a run, with `ZP = altitude * multiplier`, which `multiplier` is taken from:

|   Mod    |  EX   |  NH   |  MS   |    GV     |    VL     |     DH     |  IN   |  AS   |     DP     |
| :------: | :---: | :---: | :---: | :-------: | :-------: | :--------: | :---: | :---: | :--------: |
| Upright  |  1.4  |  1.1  |  1.2  |    1.1    |    1.1    |    1.2     |  1.1  | 0.85  |    0.95    |
| Reversed |  2.6  |  1.6  |  2.0  | 1.2+.02*M | 1.2+.02*M | 1.6+.4*rIN |   X   |  1.1  | 2.2-.6*rEX |

> M = (Other) Mod Count  
> X = rNH ? (DP or rDP ? 2 : 2.2) : 1.6  
> \*The `.02*M` is actually `.020026*M`, but who cares?

And `Hard Mode Decay` = 0.99, this applies `number_of_EX_or_Rev - 1` times.

Total ZP is soft-capped by your skill:

```lua
STAT.zp = max(
    STAT.zp, -- Won't drop
    STAT.zp < zpEarn * 16 and min(STAT.zp + zpEarn, zpEarn * 16) or -- Gain full before 16*zpGain
    zpEarn * 16 + (STAT.zp - zpEarn * 16) * (9 / 10) + (zpEarn * 10) * (1 / 10) -- Slower from 16*zpGain, slower and slower when getting close to the hard-cap (26*zpGain)
)
```

Total ZP decays ~2.6%/d. `ZP*= e^(-0.026)`

Also, DC Highscore decays ~6%/d. `DC*= e^(-0.0626)`
</details>

## TODO

### Daily Challenge Leaderboard

Resets every day

HTTP, only 2 APIs:

**Upload score**

```
request: POST {
    string special_unique_id, -- Generated by client side, not changable, always unique
    string username, -- display name
    string combo, -- to check is it really today's combo
    number altitude, -- altitude (meter)
    number time, -- F10 speedrun time (seconds)
}
response: 200 OK
```

**Fetch leaderboard**

```
struct score {
    string username,
    number rank,
    number altitude, -- altitude (meter)
    number? time, -- F10 speedrun time (seconds) (no value if speedrun not completed)
}

request: GET {string? special_unique_id}
response: 200 OK {
    score[?] altitudeList,
    score[?] timeList,
}

PLAN A - both list includes first 5 scores and-2 ~ self+2, 10 scores in total
PLAN B - both list includes first 5 scores, 10/25/50/75%-th score, and player, 10 scores in total
All lists are sorted by `rank`.
```

## Design draft of Clicker League (Probably won't be implemented)

**Main idea**: Sending mod effect to an opponent

Two players start the run, using most of the same gameplay as in single player.

**Sending Buffer**: Your attack power is converted into a corresponding duration of "time" (1 attack = 1 second) and stored in this buffer.  
When the buffer remains inactive (no increase) for 3 seconds or you take time-based damage, the stored time will be sent to the opponent. The last card you activated is the effect you will send.

**Cancelling**: Before sending `effect-time` to the opponent, it will try to cancel the same effect currently active on you, with a 2x multiplier.  
For example, it's not possible to force EX on the opponent if you already have EX.

**Sending**: After cancelling, any excess time in the sending buffer is sent to the opponent.

The game ends when one player's HP reaches zero.
