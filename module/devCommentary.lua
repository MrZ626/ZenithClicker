----------------------------------------------------------------------
--                        SPOILER WARNING                           --
-- This file contains contents that may spoil your game experience. --
-- Be sure you've finished the game, including Ultra Reversed Mods  --
--                     Read at your own risk.                       --
----------------------------------------------------------------------

return {
    [''] = STRING.trimIndent [[
        FLIP THE TAROT CARDS IN THIS MODERN YET UNFAMILIAR OFFLINE CLICKER.
        PLAY TO IMPROVE YOUR SKILLS, AND GAIN CR FROM VARIOUS MODS
        - THE CLICKER FUTURE IS YOURS!
    ]],
    notFinished = STRING.trimIndent [[
        FLIP THE TAROT CARDS IN THIS MODERN YET UNFAMILIAR OFFLINE CLICKER.
        PLAY TO IMPROVE YOUR SKILLS, AND GAIN CR FROM VARIOUS MODS
        - MASTER SELECTED MOD/COMBO TO UNLOCK THE DEVELOPER COMMENTARY!
    ]],
    noComment = STRING.trimIndent([[
        SELECTED MOD/COMBO DOESN'T HAVE DEVELOPER COMMENTARY.
        TRY ANOTHER COMBO AND COME BACK :>
                            - THE CLICKER FUTURE IS YOURS!      —— MrZ
    ]], true),
    ['EX'] = STRING.trimIndent [[
        A mod that appears simple but actually requires much skill and significantly reduces the final score.
        Like QP2, this mod is designed to punish mistakes more severely and make game less lenient.
        So I chose "smaller spacing + deselect all cards on wrong commit", along with faster XP leaking in QP2.
    ]],
    ['NH'] = STRING.trimIndent [[
        A mod with very low presence, pros can almost ignore it like no mod at all.
        Originally, I intended to remove a feature (the reset button), similar to how it works in Tetris,
        but that conflicted with the later design of AS. So I decided to change it to "No cancel".
    ]],
    ['MS'] = STRING.trimIndent [[
        A mod which is way too harder at first because shuffling cards just brutally slows you down.
        I interpreted literally as shuffling the cards since there's no "garbage lines".
        So it becomes significantly harder than QP2, plays so awful, and finally got nerfed many times.
    ]],
    ['GV'] = STRING.trimIndent [[
        Possibly the weakest mod than others, pros can completely ignore it.
        In Tetris, "increasing gravity" is similar to "forced locking", the equivalent here is forced committing.
        My aim is let everyone enjoy mods, so I made it very lenient to reduce the difficulty of combos.
    ]],
    ['VL'] = STRING.trimIndent [[
        A rather interesting mod that introduces clicking technique and endurance to the game.
        "receiving double garbages" in Tetris can correspond to "clicking the mouse twice as much". And sure, you also get doubled XP from that as in QP2.
        QP2 also cancel double, so I made canceling still one-click. Feels good but it actually leads to more mistakes —pretty interesting, isn't it?
    ]],
    ['DH'] = STRING.trimIndent [[
        Another mod with low presence, but it does increase the difficulty to some extent.
        Though we don't have garbage lines, "harder-to-clear garbage lines" can correspond to "more complex quests".
        So I designed DH to increase the expected number of mods in quests, while also slightly reducing the variance for balance.
    ]],
    ['IN'] = STRING.trimIndent [[
        A pretty cool mod that presents the "invisible" effect in a different way. Obviously, real invisible would be too difficult for an upright mod,
        So I took the approach of "hiding texts on card and colors of quests", this increases reading difficulty, creating a sensation similar to invisibility.
        Meanwhile, this also shows the design on the card back, strengthening the association between mods and their corresponding colors.
    ]],
    ['AS'] = STRING.trimIndent [[
        Just like in QP2, is a mod that "seems to have a positive effect?!", so I considered "significant buff" —play with keyboard!
        Thus, AS became an almost purely positive mod. For negative penalty. Taking inspiration from QP2's "consecutive same clear",
        "flipping a card twice" could be punished, with wounded sound effect and small punishments. Btw, Allspin surely spin all cards instead of reset!
    ]],
    ['DP'] = STRING.trimIndent [[
        The mod with the lowest development cost-effectiveness —took about three days to implement, barely worth it since it introduces the revive run.
        Since this is a single-player mini-game, online multiplayer wasn't considered. So... split the health bar into two and treat it as two players!
        To make switching easier, I chose "selecting DP card" as the condition. It also naturally switches a few times as DP appeared in quests. Nice!
    ]],

    ['rEX'] = STRING.trimIndent [[
        Exactly same with EX in QP2, even "less kill bonus", yeah, I treat "passing a quest containing DP mod" as a kill (though it's obviously much weaker)
        Until I write this, there are still only 2 players mastered rEX in QP2, way too hard for everyone to even have a try.
        I tried to shrink cards spacing furthermore, but that turns out to be too hard, so I abandoned this idea. But you could try this challenge with...
        Anyways, Zenith Clicker's aim is to let everyone enjoy all mods! Just practice a few weeks to beat rEX here! Or use AS to skip the challenge :>
    ]],
    ['rNH'] = STRING.trimIndent [[
        I want to reproduce the feeling of "classic" like what QP2 does, so I tried many combinations of "limited next queue" "no cancel" "no reset button".
        And finally I decided to make it "limited next queue" + "no auto cancel", and "remove +1 atk on perfect pass".
        Though it doesn't look like very "classic", it does need you read the only next quest and plan ahead, just like classical Tetris.
    ]],
    ['rMS'] = STRING.trimIndent [[
        What about... shuffling cards after each quest? Sounds evil but that's how reversed mods should be like, right?
        Well, I still want it to be playable for skilled players, here's the secret: the last clicked card and its neighbors won't be shuffled on pass.
        Being lenient, it's the key to make a game enjoyable, and sometimes helps creating more possibility of strategies. Go try speedrunning with it now!
    ]],
    ['rGV'] = STRING.trimIndent [[
        20G Tetris players love pure speed. So let's go faster, just faster, and nothing else changed.
        And being lenient: pause the timer for a while on passing previous quest, and reset the timer on wrong commit & reset cards.
        You said you didn't noticed that? Good, now you know how many details I added :>
        Btw do you wanna take a more exciting challenge? Go activating rGV + nightco... oops maybe I shouldn't give you hint about this XD
    ]],
    ['rVL'] = STRING.trimIndent [[
        Double clicks? Quadruple clicks! Due to health reasons, Left+Right click is allowed here, it's still very tiring to double double clicks for each card,
        and you could even use keyboard to further reduce the inputs, but that's also harder to coordinate. Which strat is the best? Up to you.
        Oh and don't forget that in QP2 there's only triple garbages but no triple cancelling, so you need to click 4 times to cancel a card too :>
        Tips: EX or any reversed mod activates "hard mode", reducing your XP gain from selecting (clearing single gives 1 atk in QP2). So what if XP lea...
    ]],
    ['rDH'] = STRING.trimIndent [[
        When I came to design this mod, QP2's rDH was still "messy garbage + no cancelling", not the current "messy garbage + dig to attack" one
        so I had no idea about how rDH should be, then I saw the "naming every combo" spreadsheet in tetrio community, it could be the answer...?
        Anyways it was chosen, rDH changes all quests into... maybe it's not much related but it introduces community interactions, so fun!
    ]],
    ['rIN'] = STRING.trimIndent [[
        Time to play real invisible! Reversed invisible should be really invisible. Let's hide quests after a few seconds...
        Wait, should we just hide all of them, which could be too hard, or only hiding current one, which could be too easy if you just pre-read one quest?
        Maybe I can take the compromise: current one first, then the latter ones. And don't forget to be lenient: show quests when player make mistake.
        Btw can you imagine a challenge that both quests and your cards are invisible?
    ]],
    ['rAS'] = STRING.trimIndent [[
        Just like in QP2, rAS makes player stronger but also more fragile. So let's take the +1 attack on B2B x 4+,
        and make the punishment stricter: flipping a card twice will mess up more cards, and you cannot cancel the burning effect.
        Well, it's still a strong buff if you are skilled enough, enjoy it!
    ]],
    ['rDP'] = STRING.trimIndent [[
        Why rDP in QP2 is only available for a few da... oh it's permanent now, nvm
        Same as DP, except your attacks will also be sent to the other player, you have to master switching players now.
        Though the "backfire" doesn't give you garbage to send more, your max rank is still limited just like in QP2.
        Can you FEEL the rhythm of switching between players even you...
    ]],

    ['uEX'] = STRING.trimIndent [[
        No more leniency. Cards spacing tightened.
        I doubt is it possible to drop from F10 to...
    ]],
    ['uNH'] = STRING.trimIndent [[
        No more leniency. No XP protection, no Surge attack.
    ]],
    ['uMS'] = STRING.trimIndent [[
        No more leniency. Let's shuffle the whole deck on each pass.
    ]],
    ['uGV'] = STRING.trimIndent [[
        No more leniency. Timer starts immediately and never resets.
    ]],
    ['uVL'] = STRING.trimIndent [[
        No more leniency. Everything must be clicked 4 times.
    ]],
    ['uDH'] = STRING.trimIndent [[
        No more leniency. All phrases are scrambled letter by letter.
    ]],
    ['uIN'] = STRING.trimIndent [[
        No more leniency. Quests will never show again.
    ]],
    ['uAS'] = STRING.trimIndent [[
        No more leniency. Flipping a card twice ends the run.
    ]],
    ['uDP'] = STRING.trimIndent [[
        No more leniency. 54% more damage to ally.
    ]],

    ['NH GV'] = STRING.trimIndent [[
        A Modern Classic, a combo ported from QP2, and it's not very worth talking about.
        It's basically no mod run, very straightforward.
        Maybe NH rGV? This feels a bit better.
    ]],
    ['NH MS DH'] = STRING.trimIndent [[
        Deadlock, a combo ported from QP2, and it's not very worth talking about.
        It's basically MS run but need a bit more concentrating.
        No much idea on this.
    ]],
    ['MS DH AS'] = STRING.trimIndent [[
        The Escape Artist, a combo ported from QP2, and it's not very...Oh I modified this one, because QP2 did
        QP2 made the target "garbage lines dig with spin", so I changed it to "quests with wound triggered".
        Hmm it's not that matching? But anyway it plays not bad lol
    ]],
    ['GV IN'] = STRING.trimIndent [[
        The Grandmaster, a combo ported from QP2, and it's not very worth talking about.
        IN gameplay but need a bit more concentrating.
        This one has a bit potential, so you will see rGV rIN later.
    ]],
    ['EX NH DH'] = STRING.trimIndent [[
        Emperor's Decadence, a combo ported from QP2, and it's not very worth talking about.
        EX gameplay but need a bit more concentrating.
    ]],
    ['EX MS VL DH'] = STRING.trimIndent [[
        Divine Mastery, a combo ported from QP2, and it's not very worth talking about.
        EX gameplay but need a bit more concentrating and endurance.
    ]],
    ['NH AS'] = STRING.trimIndent [[
        The Starving Artist, a combo ported from QP2.
        This one is a bit interesting, since you just cannot easily cancel when you made mistakes.
        Later we have a harder version: NH rAS, which force you learning how to solve rAS wounds, or just play perfectly if you can.
    ]],
    ['EX VL AS'] = STRING.trimIndent [[
        The Con Artist, a combo ported from QP2, and it's not very worth talking about.
        AS gameplay but need a bit more concentrating.
    ]],
    ['EX DP'] = STRING.trimIndent [[
        Trained Professionals, a combo ported from QP2, and it's not very worth talking about.
        EX gameplay but a tiny bit harder because DP increases the difficulty of quests a bit.
    ]],
    ['EX MS'] = STRING.trimIndent [[
        Block Rationing, a combo ported from QP2, modified to "height in limited quests".
        I'll admit this one is a bit rng, but you can improve consistency with some tricks,
        like stalling at start to get some free height, and make good use of the XP protection on last few quests.
    ]],
    ['EX NH MS GV VL DH IN AS'] = STRING.trimIndent [[
        Swamp Water, a combo ported from QP2, it was hardest but not hard any more since ZC makes everything easier.
        If you are already familiar enough with ZC, it's a good mid-term challenge for you before reversed swamp water series.
    ]],
    ['EX NH MS GV VL DH IN AS DP'] = STRING.trimIndent [[
        Yeah along with DP, it's still Swamp Water, cuz I think it doesn't really increase much difficulty.
    ]],

    ['rGV rIN'] = STRING.trimIndent [[
        The Grandmaster+, reversed version of The Grandmaster, which is closer to its original meaning.
        Well, you can see that ZC's upright mods are kinda too easy, and the reversed mods have similar difficulty with QP2's normal mods.
        This is intended, to let everyone be able to enjoy playing with mods.
    ]],
    ['rMS AS'] = STRING.trimIndent [[
        Naga Eyes, a combo ported from tetrio.
        Kinda exactly same gameplay! Make sure you've read the commentary of rMS and know how it works.
        And don't forget that going up floor scales up the difficulty a bit.
    ]],
    ['EX NH rAS'] = STRING.trimIndent [[
        Magic School, a harder version of The Starving Artist.
        This combo forces you to learn how to deal with AS wounds after each mistake, kinda interesting, isn't it?
    ]],
    ['rNH rDH IN rAS'] = STRING.trimIndent [[
        The Spellcaster, an original combo from ZC community.
        rNH increases rDH difficulty a bit so this combo needs you to learn more community combos, and rAS balances the difficulty.
        It replaces Storage Overload and it's also a reference of some old combos like Brain Capacity and Fleeting Memory
    ]],
    ['EX rGV DH'] = STRING.trimIndent [[
        Demonic Speed, an original combo made very early from ZC community.
        Honestly it's not very fun in mechanics, basically just harder rGV requiring more accuracy.
    ]],
    ['EX NH rMS GV'] = STRING.trimIndent [[
        Bnuuy, an original combo from ZC community.
        This one is not very fun in mechanics, basically just rMS gameplay but mistakes are punished more with EX+NH+GV.
        Feels like catching bunnies? I guess that's how it got the name lol
    ]],
    ['rNH rMS GV AS DP'] = STRING.trimIndent [[
        Grand-Master! Rounds, an original combo I made, featured with TGM4 meme.
        rNH for pikii (freezing cells), rMS for messy field if you are not pro enough, GV for high gravity,
        AS for all pieces rotated on spawn, and DP for arcade allowing two players.
    ]],
    ['rEX rVL DH'] = STRING.trimIndent [[
        Sweat and Ruin, an original combo from ZC community.
        rEX gameplay but limit your speed with rVL+DH, which fits the title well.
    ]],
    ['rMS GV AS rDP'] = STRING.trimIndent [[
        Cupid's Gamble, an original combo from ZC community.
        This one has a mixed gameplay of rMS+AS mixed with rDP.
    ]],
    ['NH rGV VL rDP'] = STRING.trimIndent [[
        Despairful Longing, an original combo from ZC community.
        A stricter rDP requiring fast reaction and accuracy.
    ]],
    ['rEX VL rIN'] = STRING.trimIndent [[
        Authoritarian Delusion, an original combo from ZC community.
        Just rEX+rIN gameplay and it fits the title well.
    ]],
    ['rEX rDP'] = STRING.trimIndent [[
        Tyrannical Dyarchy, an original combo I made.
        rEX+rDP, though rEX fatigue overrides rDP's one, weakening actual effects of rDP,
        rDP still forces you not to surge, which is the normal way to skip F9-stage of a rEX run.
    ]],
    ['rEX MS rDH IN'] = STRING.trimIndent [[
        Sisyphean Monarchy, an original combo from ZC community.
        rEX but you have to be familiar with most rDH combos and finding cards quickly, or you will be like tragic Sisyphus.
    ]],
    ['MS rDH rIN AS'] = STRING.trimIndent [[
        Kitsune Trickery, an original combo from ZC community.
        This achievement replaced "Brain Capacity" (rDH rIN) with a bit more difficulty for rDH pros.
        Another TGM4 meme achievement lol
    ]],
    ['VL DH rIN'] = STRING.trimIndent [[
        Empurple, an original combo from ZC community.
        Main difficulty should come from "hard mode" of reverse mod, reducing XP you could get.
    ]],
    ['EX NH MS VL rAS'] = STRING.trimIndent [[
        Faltered, an original combo from ZC community.
        This is actually a multitask challenge. No surge forces imperfect passes, which send 0 with rAS.
        So you just count to 4 while finding cards in shuffled deck.
    ]],
    ['DH AS DP'] = STRING.trimIndent [[
        A Mutual Agreement, an original combo from ZC community.
        This was changed from "Honeymoon" with a better title, it had same target but without mods limit.
        DH really makes this a lot more easier, a good example for next achievement as "invisible tutorial"!
    ]],
    ['VL AS DP'] = STRING.trimIndent [[
        The Cheaters, an original combo from ZC community.
        This was changed from "Break up" with a better title, it had same target but without mods limit.
        AS makes these pair of achievements easier, since commiting right cards is already hard enough.
    ]],
    ['NH rGV'] = STRING.trimIndent [[
        Clutch Main, an original combo from ZC community.
        Introduces "clutch" into actual gameplay, which is kinda interesting.
    ]],
    ['EX VL'] = STRING.trimIndent [[
        Wax Wings, an original... achievement I made? If I remember correctly...
        Playing "without losing a rank" with EX VL fits so well with the community combo "Icarus"'s myth story.
        It's so unbelievable that it successfully combines mod combo & rank system & texts and plays interesting.
    ]],
    ['rMS rGV rIN'] = STRING.trimIndent [[
        The Masterful Juggler, an original combo from ZC community.
        Combined with the target "Highest B2B chain reached", this makes more sense.
    ]],
    ['DH rIN AS'] = STRING.trimIndent [[
        The Oblivious Artist, an original combo from ZC community.
        This one was "doing the inverse first", but I felt it sounds too forcing, so it got changed to this.
    ]],
    ['NH rVL AS'] = STRING.trimIndent [[
        Zero-to-sixty, an original combo from ZC community.
        Though this combo includes AS, it's actually easier to play with mouse lol
    ]],
    ['rNH MS DP'] = STRING.trimIndent [[
        Scarcity Mindset, an original combo from ZC community.
        This is more complex and interesting than psychokinesis, the only regret is that we cannot play this with 3 nexts...
    ]],
    ['rGV VL'] = STRING.trimIndent [[
        Fickle Fuel, an original combo from ZC community.
        This achievement actually plays similar to "Highest Floor Discovered" achievement, but still worth to have a try.
    ]],

    ['rEX rNH rVL'] = STRING.trimIndent [[
        Hardcore Beginning, F1 speedrunning combo.
        The last combo getting added in this category! Now all 9 floors have their own speedrunning combo.
    ]],
    ['EX VL rIN rDP'] = STRING.trimIndent [[
        Love Hotel, F2 speedrunning combo.
        I think I shouldn't explain why these mods...
    ]],
    ['EX MS AS'] = STRING.trimIndent [[
        Financially Responsible, F3 speedrunning combo.
        This achievement series is basically all supercharged tier,
        but at least we could use mods and flavor texts to make them plays kinda different.
    ]],
    ['EX rVL rDP'] = STRING.trimIndent [[
        Unfair Battle, F4 speedrunning combo.
        Since F4 is still not high, using some hard mods is acceptable.
    ]],
    ['DH DP'] = STRING.trimIndent [[
        Museum Heist, F5 speedrunning combo.
        This is the start of floor speedrunning achievements!
        Though it was assigned supercharged tier by Garbo, cute achievements which has a clear upper bound like this are fine here.
    ]],
    ['EX rGV VL'] = STRING.trimIndent [[
        Workaholic, F6 speedrunning combo.
        Another supercharged achievement... If you won't be slowed down a lot by EX VL.
    ]],
    ['MS VL AS'] = STRING.trimIndent [[
        Human Experiment, F7 speedrunning combo.
        Supercharged with AS! Oh wait there's also MS...
    ]],
    ['EX GV DH'] = STRING.trimIndent [[
        Thermal Anomaly, F8 speedrunning combo.
        Finally we have an almost pure supercharged floor speedrun, except there's EX.
        Why most floor speedrunning achievements has EX, but I forgot why...
    ]],
    ['MS GV AS'] = STRING.trimIndent [[
        Dazed, an original combo from ZC community.
        Another supercharged achievement...? Maybe it's more like a combination of supercharged and MS mastery.
    ]],
    ['EX NH MS GV VL DH IN AS rDP'] = STRING.trimIndent [[
        Ambrosia Moonshine, the last achievement of swamp water+ series.
        Since DP count as 0 MP in swamp water+ series at some point, this is the only possible combo fitting "1 reverse mod + 8 mods",
        which doesn't fit the theme of this series (multiple choices to pick from).
    ]],
    ['rEX rNH rMS rGV rVL rDH rIN rAS rDP'] = STRING.trimIndent [[
        Welcome to the summit, $1!
        You achieved the impossible with your unbreakable spirit, against all logic.
        This kind of crazy challenge shouldn't exist from the start.
        Congratulations.
    ]],
    -- Trevor Smithy
    --programming smithy
    ['eEX eVL eAS'] = STRING.trimIndent [[
        The Pro G(r)am(m)ing Smithy, because, well, I'm Trevor Smithy and I'm both a
        programmer and a (questionably) pro gamer. In any case, this has been fun to develop and playtest.
        eEX is very strong, making getting high climb speed ranks significantly easier, especially if combined with eL. 
        eVL is just a +1 buff to all XP and eAS adding +1 to attacks with no downsides allows for some crazy fast runs.
        Thanks for playing my mod! WAH-BAAM! - Trevor Smithy
    ]],
    ['ueEX eVL eAS'] = STRING.trimIndent [[
        The Uneasy Pro G(r)am(m)ing Smithy, because, well, I'm Trevor Smithy and I'm a -- wait, what have you done?
        Why? Why is it so hard to climb? Why are my attacks so weak? Oh no. I can hear the voices now.
        You're going too fast.... They're coming for me. Run, climb while you still can! 
        Whatever you do, DON'T STOP CLIMBIN' AND CLIMBIN' AND CLIMBIN' AND CLI—   
    ]],
    --one of mine
    ['eEX uGV eDH eAS'] = STRING.trimIndent [[
        But It Isn't One Of Mine, the Easy Mode counterpart to Patience Is A Virtue.
        While this message will display even if Nightcore+ is not enabled,
        in order to get the achievement with the same name it is required.
    ]],
    --ggbw
    ['eEX eNH eGV eVL eDH eIN AS eDP'] = STRING.trimIndent [[
        One of 3 variants of Gamer Girl Bath Water, this is the one that I believe is 
        optimal for "The Biggest Fan" because Friend doesn't punish you for having your ally dead.
        Combine with Uneasy for a bigger challenge.
    ]],
    ['eEX eNH eGV eVL eDH eIN eAS DP'] = STRING.trimIndent [[
        One of 3 variants of Gamer Girl Bath Water, this is the one that I believe is the best 
        alternative for "The Biggest Fan", especially if you are prone to burns with AS. 
        However, DP does hurt your ability to climb when your ally is dead.
        Combine with Uneasy for a bigger challenge.
    ]],
    ['eEX eNH eGV eVL eDH eIN AS DP'] = STRING.trimIndent [[
        One of 3 variants of Gamer Girl Bath Water, this is the one that I believe is the most 
        challenging for "The Biggest Fan", since you are prone to burns with AS 
        and DP hurts your ability to climb when your ally is dead.
        Combine with Uneasy for a bigger challenge.
    ]],
    --uEX
    ['uEX eNH eMS eGV eVL eDH eIN eAS'] = STRING.trimIndent [[
        "Sir! The peasants have broken through the castle gate! They're rapidly advancing in!"
        "Quiet, fool. Such simple people do not understand the rules that guide a ruler. They will never stand a cha-"
        At that moment, the 'Psychotic Sovereign' collapsed to the ground, a spear lodged deep through his cold heart.
    ]],
    --uNH
    ['eEX uNH eGV eDH'] = STRING.trimIndent [[
        "GEEZ - GOD! How'd you get here so fast??" You begin to clip through the fabric of reality. "Wait WAIT WAIT!! Y-You have to save all the mortals!
        "My servants have them! You're supposed to go to their temples first." You flip over a table before sliding backwards out of the room,
        destroying the door as you leave. After a few short minutes, you return. "Okay okay! You can have it, I'm sorry!" God says, tossing you your prize.
        However, you will not stand to be rewarded so flippantly, so you leap after God, who screams "NOOOOOOOO!!!" as he tries to escape 
        and you cave his face in with a powerful backhand slap before grabbing him and tossing him into the distance where he explodes.
    ]],
    --uMS
    ['eEX uMS eIN eDP'] = STRING.trimIndent [[
        "Hey man, I know that life can be quite the mess. Especially since you're going through a rough path. But I'm here for you, alright?
        And look, you, no, WE made it. Together. You did great. Don't ever let anyone tell you otherwise, got it? Take care man. See ya."
    ]],
    --uGV
    ['eEX uGV eAS eDP'] = STRING.trimIndent [[
        "It...it stopped. We did it! It stopped! Good... We made it in time. We stabilized the collapse... Hey! Do you realize what you've been doing to
        everything?" "Wait...Don't be so hard on him. He was lonely." "He was trying to destroy everything around him! That's not the same as a lonely
        man! We can't allow that!" "The power of the mask made him do it, it was too much for him to handle." "It's cause he doesn't know his place! He has
        a weak will, and he's a fool!" "CERTAINLY, HE HAD FAR TOO MANY WEAKNESSES TO USE MY POWER." "Yeah, that's right, admit your stupidity!
        Huh?" "A PUPPET THAT CAN NO LONGER BE USED IS MERE GARBAGE. THIS PUPPET'S ROLE HAS JUST ENDED" "It can't be! Then the galaxy?!"
    ]],
    --uVL
    ['eEX eGV uVL eDH'] = STRING.trimIndent [[
        "You cannot tell from appearances how things will go. Sometimes imagination makes things out far worse than they are; yet without imagination
        not much can be done. Those people who are imaginative see many more dangers than perhaps exist; certainly many more than will happen;
        but then they must also pray to be given that extra courage to carry this far-reaching imagination. ... This is the lesson: never give in,
        never give in, never, never, never, never-in nothing, great or small, large or petty - never give in except to convictions of honour
        and good sense. Never yield to force; never yield to the apparently overwhelming might of the enemy." - Winston Churchill, 1941
    ]],
    --uDH
    ['eEX eMS uDH eIN'] = STRING.trimIndent [[
        "See? What did I tell you. All you had to do was give up on trying to understand the hellish mess that we just went through
        and just follow my instructions. Turns out, life can be a lot easier if you don't have to solve every problem by yourself.
        Now, that being said, I wouldn't become TOO reliant on my help, because I won't always be there, but when I am, just trust me, okay?"
    ]],
    --uIN
    ['eEX eNH uIN eAS'] = STRING.trimIndent [[
        "Huh. Okay, so, maybe that was a bit more tricky of a paradox to decipher than I thought. I apologize for being so dismissive of
        your thoughts earlier. But hey, how was I supposed to know that every solution would quickly vanish if we didn't keep up?
        Like, are you kidding me? Who designed this? All our progress kept getting deleted just because I was missing a single 'e'..."
        "This took way too long to fix." "Facts. But hey, made it work in the end."
    ]],
    --uAS
    ['eEX eNH eVL uAS'] = STRING.trimIndent [[
        You knock on the door before entering the dimly lit room. "Oh, hello! Welcome back. You're just in time for today's meeting of AA,
        or All-Spinners Anonymous. Please, tell us about your latest progress." You sit up, looking around the room, clearing your throat.
        "Well, I may have had a lapse. I'm sorry, I'm such a degenerate magician, I know. I just couldn't help myself. It's all so addicting...
        The high speed climb, the flashing lights, the growing numbers, all atop the adrenaline of the threat of death at the smallest slip-up."
        The therapist looks at you, shaking her head, "I'm sorry, but I think it's for the best if you leave. You're clearly beyond saving."
    ]],
    --uDP
    ['eEX eMS eVL uDP'] = STRING.trimIndent [[
        "Dear, can we talk for a moment? I know that lately, we've been going through a bit of a rough patch, and I haven't been helping."
        "Uh huh." "I just wanted to apologize for making you feel uncomfortable at home here. I know you're busy with work and whatnot."
        "Yea." "Also, I realize that me making you do a bunch of random tasks hasn't exactly been productive either."
        "Yup." "But now I know that I need to be better, for you, me, us as a couple. Going forward, I'll try to communicate more, okay?"
        "Okay." "Good. Now, I'm making homemade spaghetti for dinner. Would you mind setting the table?" "Sure, dear."
    ]],

    --misc
    ['eEX eNH rMS eGV VL eDH eIN eAS'] = STRING.trimIndent [[
        Mikamiyu: "if only goth mommy bathwater :("                  
        Trevor Smithy: "hmm, what would that even be?"               
        Mikamiyu: "rMS VL bath water. need. be subtle about it iykyk"
        Trevor Smithy: "i'll consider it"                            
        Mikamiyu: "wait fr ong crazy"                                
    ]],
    ['eEX eNH eMS eGV rVL rDH eAS rDP'] = STRING.trimIndent [[
        "Ha ha, here's the problem: too many toasters! You know what they say: all toasters toast toast."
        He unplugs the extension cord abomination powering the room full of toasters, launching toast into the ceiling.
    ]],
    ['eEX eNH eMS eGV uVL uDH eAS uDP'] = STRING.trimIndent [[
        "Okay chat, run a prediction: Will this hurt me? I am wearing a helmet, so I don't get brain damage."
        "Death wish!" *splash* *ZZZZAAAAAPPPP* 
        "FUUUUUUUUUUUUU!— FUUUUUUUUUUU!— UUUUUUUUUGGGGGH!—"
        *silence* 
        - Looking for a game to capture -
    ]],
    ['eAS'] = STRING.trimIndent [[
        SPEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEN
        When you're in Spain without the A
        aka: Gamer, Degenerate
    ]],
    -- Future achievement update
    -- Profligacy ueEX, eNH+J, fastest time to floor 10
    -- Diogenes Syndrome ueEX, eMS+eJ, fastest time to floor 10
    -- Dysania ueEX, eGV+S, fastest time to floor 10
    ['ueEX eGV'] = STRING.trimIndent [[
        (Achievement requires Sloooooow-mo) "You're up early." "HEY, BUDDY. HOW'S IT GOING?" "Woah! Yo what?" 
        "WHAT?" "Why is your voice so deep?" "OH IT'S JUST A LITTLE DEEPER IN THE MORNING. YOURS DOESN'T DO THAT?"
        "You sound like you're narrating a Ford commercial." "YEAH, I GET THAT SOMETIMES." "Is that like a condition or-"
        "I DON'T KNOW WHY IT DOES THAT. IT'S EARLY. WILL YOU LET ME ENJOY MY MORNING IN PEACE?" 
        "Yeah. Okay." "I'M GONNA MAKE SOME TEA. YOU WANT ONE TOO?" "Uh, no sir- No... No thank you."
    ]],
    -- Subluxation ueEX, eVL+I, fastest time to floor 10
    -- Limbo ueEX, eDH+Z, fastest time to floor 10
    -- Presbyopia ueEX, eIN+O, fastest time to floor 10
    -- Carpal Tunnel ueEX, eAS+L, fastest time to floor 10
    -- Prosopagnosia ueEX, eDP+T, fastest time to floor 10
    -- Rolled Smithy
    ['eNH eMS eGV eDH eIN eDP'] = STRING.trimIndent [[
        Thou hast deciphered thee code, thine roll was thee key, as thou shan't forgo moderation,
        thine lift did not let thee down, thine friend didn't desert thee. 
        Thine tidiness made thou not cry, thine visibility meant thee shan't have to say goodbye, 
        and thine salvation was achieved because thou didn't lie or hurt thee.
    ]],

}
