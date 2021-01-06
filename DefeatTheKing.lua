function new_game()
    dbg.stm("Die feindlichen Truppen formieren sich!! Beschützt den Herrscher. Ihr seid beide Fürsten und zur Treue verpflichtet. Ihr habt geschworen, den feindlichen König zu besiegen. Aber vegesst nicht, verteidigt auch die Burg eures Königs. Fällt diese, seid auch ihr besiegt. ")

    --last attack
    Vars.Save1 = 0

    --IsPlayer3Human
    Vars.Save5 = 0

    --difficulty
    Vars.Save4 = 0

    MinuteEvents.new_game()
    request_event(Siegbedingung, Events.VICTORY_CONDITION_CHECK)
    request_event(doActionsAfterMinutes, Events.FIVE_TICKS)
    request_event(aiOperations, Events.FIVE_TICKS)
    request_event(initGame, Events.FIRST_TICK_OF_NEW_OR_LOADED_GAME)
    request_event(removeBoats, Events.FIVE_TICKS)
	testfunction()

    preparePlayerTwo()



    if isAIDebug() == 0 then
        Game.DisableLastNPlayersInStatistic(5)
    end

    AI.SetPlayerVar(4, "AttackMode", 1, 1, 1)
    AI.SetPlayerVar(5, "AttackMode", 1, 1, 1)
    AI.SetPlayerVar(6, "AttackMode", 1, 1, 1)
    AI.SetPlayerVar(7, "AttackMode", 1, 1, 1)
    AI.SetPlayerVar(8, "AttackMode", 1, 1, 1)
end

function register_functions()
    reg_func(Siegbedingung)
    reg_func(aiOperations)
    reg_func(doActionsAfterMinutes)
    reg_func(initGame)
    reg_func(removeBoats)
	MinuteEvents.register_functions()
end

function isDebug()
	return 0
end

difficultyChooser = {
    normal = {
        x = 374,
        y = 867,
        difficulty = 0
    },
    hard = {
        x = 395,
        y = 871,
        difficulty = 1
    },
    extreme = {
        x = 414,
        y = 871,
        difficulty = 2
    }
}

function checkDifficulty()

    checkChooser(difficultyChooser.normal)
    checkChooser(difficultyChooser.hard)
    checkChooser(difficultyChooser.extreme)

    if Vars.Save4 == 0 then
        dbg.stm("Ihr habt euch für eine leichtere Partie entschieden!")
        Buildings.AddBuilding(384, 850, 2, Buildings.EYECATCHER03)
    elseif Vars.Save4 == 1 then
        dbg.stm("Ihr habt euch für eine schwere Partie entschieden!")
        Buildings.AddBuilding(384, 850, 2, Buildings.EYECATCHER03)
        Buildings.AddBuilding(384, 854, 2, Buildings.EYECATCHER03)
        prepareDifficultMatch()
    else
        dbg.stm("Ihr spielt eine extrem harte Partie! Dann mal viel Glück!")
        Buildings.AddBuilding(384, 850, 2, Buildings.EYECATCHER03)
        Buildings.AddBuilding(384, 854, 2, Buildings.EYECATCHER03)
        Buildings.AddBuilding(389, 856, 2, Buildings.EYECATCHER03)
        prepareDifficultMatch()
    end

end

function removeBigTowerAtPossitionForPlayer(x, y, player)
    Buildings.CrushBuilding(Buildings.GetFirstBuilding(player,Buildings.GUARDTOWERBIG))
    Settlers.KillSelectableSettlers(player,Settlers.SWORDSMAN_01, x,y, 10 , 0)
    local counter = 1
    while counter <= 43 do
        Goods.Delete(x,y,5,counter)
        counter = counter +  1
    end

end

function checkChooser(chooser)

    if Settlers.AmountInArea(1, Settlers.SQUADLEADER, chooser.x, chooser.y, 5) > 0 then
        Settlers.KillSelectableSettlers(1, Settlers.SQUADLEADER, chooser.x, chooser.y, 5, 0)
        Vars.Save4 = chooser.difficulty;
    end

end

function msgDifficulty()
	dbg.stm("Spieler 1, wähle bitte auf der Karte unten die gewünschte Schwierigkeit für diese Runde, indem du deinen Hauptmann in den entsprechenden Kreis schickst. (Die Karte sollte mit auf schwer gestellten Gegnern gespielt werden)")
end



function prepareDifficultMatch()


    Game.SetFightingStrength(4, 81)
    Game.SetFightingStrength(5, 81)
    Game.SetFightingStrength(6, 81)
    Game.SetFightingStrength(7, 81)
    Game.SetFightingStrength(8, 111)



    Buildings.AddBuilding(96, 147, 4, Buildings.BARRACKS)
    Goods.AddPileEx(96, 147, Goods.STONE, 8)
    Goods.AddPileEx(96, 147, Goods.BOARD, 8)
    Goods.AddPileEx(96, 147, Goods.STONE, 8)
    Goods.AddPileEx(96, 147, Goods.BOARD, 8)

    Buildings.AddBuilding(277, 355, 5, Buildings.BARRACKS)
    Goods.AddPileEx(277, 355, Goods.STONE, 8)
    Goods.AddPileEx(277, 355, Goods.BOARD, 8)
    Goods.AddPileEx(277, 355, Goods.STONE, 8)
    Goods.AddPileEx(277, 355, Goods.BOARD, 8)

    Buildings.AddBuilding(473, 307, 6, Buildings.BARRACKS)
    Goods.AddPileEx(473, 307, Goods.STONE, 8)
    Goods.AddPileEx(473, 307, Goods.BOARD, 8)
    Goods.AddPileEx(473, 307, Goods.STONE, 8)
    Goods.AddPileEx(473, 307, Goods.BOARD, 8)

    Buildings.AddBuilding(722, 296, 7, Buildings.BARRACKS)
    Goods.AddPileEx(722, 296, Goods.STONE, 8)
    Goods.AddPileEx(722, 296, Goods.BOARD, 8)
    Goods.AddPileEx(722, 296, Goods.STONE, 8)
    Goods.AddPileEx(722, 296, Goods.BOARD, 8)

    Buildings.AddBuilding(753, 78, 8, Buildings.BARRACKS)
    Goods.AddPileEx(753, 78, Goods.STONE, 8)
    Goods.AddPileEx(753, 78, Goods.BOARD, 8)
    Goods.AddPileEx(753, 78, Goods.STONE, 8)
    Goods.AddPileEx(753, 78, Goods.BOARD, 8)
end


function checkIfPlayer3IsHuman()
    if getAmoutOfBuildings(2) > 78 then
        dbg.stm("Der dritter Mitspieler wurde erkannt!")
        Vars.Save5 = 1
    else
        dbg.stm("Ihr spielt eine Partie mit zwei Spielern!")
        Vars.Save5 = 0
    end
end

function initGame()

    if isDebug() == 1 then
        Tutorial.RWM(1)
    end

    if Game.Time() <= 1 then
        removeBigTowerAtPossitionForPlayer(387,854,1)
    end

    if Game.Time() >= getEndgameTime() then
        endGame = 1
    else
        endGame = 0
    end
    setNewAttackAmount()
    setNewPauseUntilAttack()

	--Message zum waehlen der Schwirigkeit
	requestMinuteEvent(msgDifficulty,1)

	--Die Schwierigkeit wird nach 4 minuten abgeprüft.
	requestMinuteEvent(checkDifficulty,5)

end

function spawnmilitary()
    --if Game.Time() == 1 then

    --Settlers.AddSettlers(799, 75, 8, Settlers.CARRIER, 3)

    -- Verstaerkung fuer Endgabe Test
    --Settlers.AddSettlers(183, 681, 1, Settlers.SWORDSMAN_03, 200)
    Settlers.AddSettlers(191, 679, 1, Settlers.BOWMAN_03, 800)


    --Settlers.AddSettlers(485, 717, 2, Settlers.SWORDSMAN_03, 200)
    Settlers.AddSettlers(467, 706, 2, Settlers.BOWMAN_03, 800)

    Settlers.AddSettlers(666, 663, 3, Settlers.BOWMAN_03, 800)
    Game.SetFightingStrength(1, 150)
    Game.SetFightingStrength(2, 150)
    Game.SetFightingStrength(3, 150)


    --end
end

function testfunction()
	if isDebug() == 1 then
        spawnmilitary()
        dbg.aioff(3)

        Magic.IncreaseMana(1, 500)
        dbg.stm("Anzahl Gebäude" .. getAmoutOfBuildings(2))
    end


end

function spawnEnemySupportPackage(settlersAmount, swords, bows, goldBars, axes)
    if Game.HasPlayerLost(4) == 0 then
        Settlers.AddSettlers(117, 145, 4, Settlers.CARRIER, settlersAmount)
        Goods.AddPileEx(117, 145, Goods.SWORD, swords)
        Goods.AddPileEx(117, 145, Goods.BOW, bows)
        Goods.AddPileEx(117, 145, Goods.GOLDBAR, goldBars)
    end

    if Game.HasPlayerLost(5) == 0 then
        Settlers.AddSettlers(273, 350, 5, Settlers.CARRIER, settlersAmount)
        Goods.AddPileEx(273, 350, Goods.SWORD, swords)
        Goods.AddPileEx(273, 350, Goods.BOW, bows)
        Goods.AddPileEx(273, 350, Goods.GOLDBAR, goldBars)
    end

    if Game.HasPlayerLost(6) == 0 then
        Settlers.AddSettlers(447, 295, 6, Settlers.CARRIER, settlersAmount)
        Goods.AddPileEx(447, 295, Goods.SWORD, swords)
        Goods.AddPileEx(447, 295, Goods.BOW, bows)
        Goods.AddPileEx(447, 295, Goods.GOLDBAR, goldBars)
    end
    if Game.HasPlayerLost(7) == 0 then
        Settlers.AddSettlers(726, 301, 7, Settlers.CARRIER, settlersAmount)
        Goods.AddPileEx(726, 301, Goods.SWORD, swords)
        Goods.AddPileEx(726, 301, Goods.BOW, bows)
        Goods.AddPileEx(726, 301, Goods.GOLDBAR, goldBars)
    end
    if Game.HasPlayerLost(8) == 0 then
        Settlers.AddSettlers(782, 117, 8, Settlers.CARRIER, settlersAmount)
        Goods.AddPileEx(782, 117, Goods.SWORD, swords)
        Goods.AddPileEx(782, 117, Goods.BATTLEAXE, axes)
        Goods.AddPileEx(782, 117, Goods.BOW, bows)
        Goods.AddPileEx(782, 117, Goods.GOLDBAR, goldBars)
    end
end

function preparePlayerTwo()

    local mycounter = 1
    while mycounter <= 17 do
        Buildings.CrushBuilding(Buildings.GetFirstBuilding(2, Buildings.GUARDTOWERSMALL))
        mycounter = mycounter + 1
    end

    Buildings.AddBuilding(527, 795, 2, Buildings.STORAGEAREA)
    Buildings.AddBuilding(535, 743, 2, Buildings.STORAGEAREA)

end

function Siegbedingung()
    Game.DefaultPlayersLostCheck()
    if Buildings.ExistsBuildingInArea(2, Buildings.CASTLE, 461, 700, 10, Buildings.READY) == 0 then
        Game.PlayerLost(1)
        Game.PlayerLost(2)
        Game.PlayerLost(3)
    end
    if Buildings.ExistsBuildingInArea(8, Buildings.CASTLE, 799, 65, 10, Buildings.READY) == 0 then
        Game.PlayerLost(4)
        Game.PlayerLost(5)
        Game.PlayerLost(6)
        Game.PlayerLost(7)
        Game.PlayerLost(8)
    end
    Game.DefaultGameEndCheck()
end


function doEveryMinuteSpawn()
    if isAIDebug() == 1 then
        dbg.stm("Min:" .. Game.Time() .. " OppUn:" .. getAmountOfEnemysUnits() .. " MinOfLaAtt:" .. Vars.Save1 .. " MinAttAmo:" .. getMinAttackAmount() .. " LivHuman:" .. getn(humans) .. " LivOpp:" .. getn(opponents) .. " Pause:" .. getMinTimeBetweenAttacks() .. " Endgame:" .. endGame .. " Kampfkraft:" .. Game.GetOffenceFightingStrength(4) .. "/" .. Game.GetOffenceFightingStrength(5) .. "/" .. Game.GetOffenceFightingStrength(6) .. "/" .. Game.GetOffenceFightingStrength(7) .. "/" .. Game.GetOffenceFightingStrength(8))
    end

    --Genereller Spawn
    if Game.Time() >= 17 then
        if Game.Time() > getEndgameTime() + 10 then
            if Game.Time() > 130 then
                spawnEnemySupportPackage(5, 2, 1, 2, 1)
            else
                spawnEnemySupportPackage(4, 1, 0, 2, 1)
            end
        else
            spawnEnemySupportPackage(2, 1, 0, 1, 0)
        end
    end

    --Extra Spawn für Schwer
    if Game.Time() >= 35 and Vars.Save4 >= difficultyChooser.hard.difficulty then
        spawnEnemySupportPackage(4, 2, 1, 6, 1)
    end

    --Extra Spawn für extrem
    if Game.Time() >= 30 and Vars.Save4 == difficultyChooser.extreme.difficulty then
        spawnEnemySupportPackage(4, 2, 0, 2, 1)
    end

    --Extra Spawn falls dritter Spieler
    if Vars.Save5 == 1 and Game.Time() >= 40 then
        if isAIDebug() == 1 then
            dbg.stm("Da human extra spawn")
        end

        if Vars.Save4 >= difficultyChooser.hard.difficulty then
            spawnEnemySupportPackage(5, 2, 1, 2, 1)
        else
            spawnEnemySupportPackage(3, 2, 0, 1, 0)
        end


    end

    --Extra spawn für Endgame beim König
    if endGame == 1 then

        if Game.HasPlayerLost(7) == 0 then
            Settlers.AddSettlers(726, 301, 7, Settlers.CARRIER, 2)
            Goods.AddPileEx(726, 301, Goods.SWORD, 1)
            Goods.AddPileEx(726, 301, Goods.BOW, 1)
        end

        Settlers.AddSettlers(782, 117, 8, Settlers.CARRIER, 4)
        Goods.AddPileEx(782, 117, Goods.BATTLEAXE, 1)
        Goods.AddPileEx(782, 117, Goods.SWORD, 1)
        Goods.AddPileEx(782, 117, Goods.BOW, 1)
    end
    --extra spawn beim könig und player 7
    if Game.Time() > 135 then
        if Game.HasPlayerLost(7) == 0 then
            Settlers.AddSettlers(726, 301, 7, Settlers.CARRIER, 2)
            Goods.AddPileEx(726, 301, Goods.SWORD, 1)
            Goods.AddPileEx(726, 301, Goods.BOW, 1)
            Goods.AddPileEx(726, 301, Goods.GOLDBAR, 1)
        end

        Settlers.AddSettlers(782, 117, 8, Settlers.CARRIER, 5)
        Goods.AddPileEx(782, 117, Goods.BATTLEAXE, 1)
        Goods.AddPileEx(782, 117, Goods.BOW, 1)
        Goods.AddPileEx(782, 117, Goods.SWORD, 2)
        Goods.AddPileEx(782, 117, Goods.GOLDBAR, 1)
    end

end

function doActionsAfterMinutes()
    --wird jede Minute ausgefuehrt
    if newMinute() == 1 then

        doEveryMinuteSpawn()

        local xw = 584 -- X Koordinate von Goldschmelze
        local yw = 795  -- Y Koordinate von Goldschmelze
        local goldBars = Goods.GetAmountInArea(2, Goods.GOLDBAR, xw, yw, 10)
        if goldBars >= 8 then
            Effects.AddEffect(Effects.RMAGIC_GIFTOFGOD, Sounds.AMB_FIRE, 543, 839, 0)
            Effects.AddEffect(Effects.RMAGIC_GIFTOFGOD, Sounds.AMB_FIRE, 584, 795, 0)
            Goods.Delete(xw, yw, 10, Goods.GOLDBAR)
            Goods.AddPileEx(543, 839, Goods.GOLDBAR, goldBars)

        end

    end
    ------------------------------------
    ------------ab hier die Minutes-----
    ------------------------------------

    if minuteReached(3) == 1 then
        Map.SetScreenPos(803, 61)
        dbg.stm("König Erdur: Du wagst es mich herauszufordern? Du hast keine Ahnung mit wem du es zu tun hast, hahahaha... ")
    end

    if minuteReached(8) == 1 then
        dbg.stm("Ihr erhaltet eine geheime Nachricht!!! Finde die drei legendären Inseln. Geht dir Stein aus, suche in der Mitte. Die Ecken sind dein Freund.")
    end

    if minuteReached(9) == 1 then
        --Wir nochmal neu gesetzt, da die Randomzahl nun zufaellig ist.
        setNewAttackAmount()
    end

    if minuteReached(30) == 1 then
        checkIfPlayer3IsHuman()
        spawnEnemySupportPackage(5, 2, 1, 5, 2)
    end

    if minuteReached(50) == 1 then
        spawnEnemySupportPackage(5, 2, 1, 6, 2)
        setNewAttackAmount()

        if Vars.Save4 == difficultyChooser.hard.difficulty then
            Game.SetFightingStrength(4, 111)
            Game.SetFightingStrength(5, 111)
            Game.SetFightingStrength(6, 111)
            Game.SetFightingStrength(7, 111)
            Game.SetFightingStrength(8, 131)
        elseif Vars.Save4 == difficultyChooser.extreme.difficulty then
            Game.SetFightingStrength(4, 116)
            Game.SetFightingStrength(5, 116)
            Game.SetFightingStrength(6, 116)
            Game.SetFightingStrength(7, 121)
            Game.SetFightingStrength(8, 136)
        end

    end

    if minuteReached(getEndgameTime()) == 1 then
        endGame = 1
        spawnEnemySupportPackage(5, 2, 2, 2, 2)
        setNewAttackAmount()
        setNewPauseUntilAttack()
        if Vars.Save4 == difficultyChooser.hard.difficulty then
            Game.SetFightingStrength(4, 116)
            Game.SetFightingStrength(5, 116)
            Game.SetFightingStrength(6, 116)
            Game.SetFightingStrength(7, 121)
            Game.SetFightingStrength(8, 136)
        elseif Vars.Save4 == difficultyChooser.extreme.difficulty then
            Game.SetFightingStrength(4, 126)
            Game.SetFightingStrength(5, 126)
            Game.SetFightingStrength(6, 126)
            Game.SetFightingStrength(7, 131)
            Game.SetFightingStrength(8, 141)
        end

        dbg.stm("König Erdur: Du hast lange genug meinen Truppen stand gehalten! Ich werde meine Truppen sammeln, ein jeder wird kämpfen und dir die wahre Stärke meines Königreichs zeigen. Dein lächerlicher Widerstand wird bald ein Ende haben, hahahaha..")
    end

    if minuteReached(100) == 1 then
        spawnEnemySupportPackage(6, 2, 1, 3, 2)
    end

    if minuteReached(120) == 1 then
        if isDebug() == 1 then
            dbg.stm("real endgame reached")
        end
        if Vars.Save4 == difficultyChooser.hard.difficulty then
            Game.SetFightingStrength(4, 121)
            Game.SetFightingStrength(5, 121)
            Game.SetFightingStrength(6, 121)
            Game.SetFightingStrength(7, 126)
            Game.SetFightingStrength(8, 141)
        elseif Vars.Save4 == difficultyChooser.extreme.difficulty then
            Game.SetFightingStrength(4, 141)
            Game.SetFightingStrength(5, 141)
            Game.SetFightingStrength(6, 141)
            Game.SetFightingStrength(7, 146)
            Game.SetFightingStrength(8, 151)
        end
    end

    if minuteReached(125) == 1 then
        spawnEnemySupportPackage(7, 2, 2, 3, 2)
    end

end

function setNewAttackAmount()
    if Game.Time() < 50 then
        if Vars.Save4 >= difficultyChooser.hard.difficulty then
            attackAmount = randomBetween(450, 500)
        else
            attackAmount = randomBetween(320, 360)
        end
    else
        if Game.Time() < getEndgameTime() then
            if Vars.Save4 >= difficultyChooser.hard.difficulty then
                attackAmount = randomBetween(550, 800)
            else
                attackAmount = randomBetween(400, 650)
            end
        else
            if Vars.Save4 >= difficultyChooser.hard.difficulty then
                attackAmount = floorNumber(randomBetween(1100, 1600) * (getn(opponents) / 5))
            else
                attackAmount = floorNumber(randomBetween(900, 1400) * (getn(opponents) / 5))
            end
            --anzahl wird reduziert, wenn gegner bereits besiegt wurden.

        end
    end
end

function setNewPauseUntilAttack()
    if Vars.Save4 == difficultyChooser.extreme.difficulty then
        if endGame == 1 then
            pauseUntilAttack = randomBetween(14, 17)
        else
            pauseUntilAttack = randomBetween(12, 16)
        end
    else
        if endGame == 1 then
            pauseUntilAttack = randomBetween(15, 18)
        else
            pauseUntilAttack = randomBetween(13, 17)
        end
    end
end

function getEndgameTime()

    if Vars.Save4 >= difficultyChooser.hard.difficulty then
        return 82
    else
        return 85
    end
end


----------------------
---------------------
-- AI Funktionen die gesetzt werden muessen
---------------------
----------------------

function isAIDebug()
    return 0
end

function customCheckIfAttack()
    return 0
end

function getMainPlayerToAttack()
    return 2
end

function getAmoutOfAttackingEnemies()
    if endGame == 1 or Vars.Save4 >= difficultyChooser.hard.difficulty then
        return getn(opponents)
    else
        --mindestens 4 greifen immer an
        return getn(opponents) - 1
    end
end

function getPercentageAttackingUnits(amountOfAttackingEnemies)
    if endGame == 1 then
        if Vars.Save4 >= difficultyChooser.hard.difficulty then
            return randomBetween(85, 95)
        else
            return randomBetween(80, 90)
        end
    else
        if Vars.Save4 >= difficultyChooser.hard.difficulty then
            if Game.Time() < 55 then
                return randomBetween(70, 80)
            else
                return randomBetween(80, 85)
            end
        else
            if Game.Time() < 55 then
                return randomBetween(75, 85)
            else
                return randomBetween(80, 90)
            end
        end
    end
end

tickCounter = 1

function removeBoats()

    tickCounter = tickCounter + 5

    if tickCounter >= 350 then


        local index = 1

        --IDs der Gebaeude gehen von 1 - 83
        while index <= getn(humans) do

            if Vehicles.AmountInArea(humans[index], Vehicles.WARSHIP, 732, 24, 23) > 0 or Vehicles.AmountInArea(humans[index], Vehicles.WARSHIP, 824, 24, 23) > 0 then
                dbg.stm("war in Area")
                Vehicles.KillVehicles(humans[index], Vehicles.WARSHIP, 732, 24, 23)
                Vehicles.KillVehicles(humans[index], Vehicles.WARSHIP, 824, 24, 23)
                dbg.stm("Ein greller Blitz, zzzzzschhhhh. Eure Krigsschiffe wurden von Thor zerstört")
            end
            if Vehicles.AmountInArea(humans[index], Vehicles.FERRY, 732, 24, 23) > 0 or Vehicles.AmountInArea(humans[index], Vehicles.FERRY, 824, 24, 23) > 0 then
                dbg.stm("war in Area")
                Vehicles.KillVehicles(humans[index], Vehicles.FERRY, 732, 24, 23)
                Vehicles.KillVehicles(humans[index], Vehicles.FERRY, 824, 24, 23)
                dbg.stm("Ein greller Blitz, zzzzzschhhhh. Eure Krigsschiffe wurden von Thor zerstört")
            end
            --if Vehicles.AmountInArea(humans[index],Vehicles.FERRY,800, 65, 60) > 0  then
            --	dbg.stm("ferry in Area")
            --	Vehicles.KillVehicles(humans[index], Vehicles.FERRY, 800, 65, 60)
            --	dbg.stm("Ein greller Blitz, zzzzzschhhhh. Eure Krigsschiffe wurden von Thor zerstört")
            --end
            index = index + 1
        end

        tickCounter = 1
    end


end

function getMinAttackAmount()
    return attackAmount
end

function getMinTimeBetweenAttacks()
    return pauseUntilAttack
end

function getMaxTimeBetweenAttacks()
    if endGame == 1 then
        return 21
    else
        return 19
    end

end

function attackStarted()
    --Ein neues min Level an Soldaten, macht es lustiger ;D
    setNewAttackAmount()
    setNewPauseUntilAttack()
end


--------------------------
----- Utility variables---
--------------------------

opponents = { 4, 5, 6, 7, 8 }
humans = { 1, 2, 3 }


-----------------------
----- AI utility ------
-----------------------

tickConterAI = 1
function aiOperations()
    tickConterAI = tickConterAI + 1
    if tickConterAI > 60 then
        refreshIfSomeoneDied()
        checkAttack()
        tickConterAI = 1
    end
end

function refreshIfSomeoneDied()

    if isAnyHumanDefeeted() == 1 then
        local temp = {}
        local counter = 1
        while counter <= getn(humans) do
            if Game.HasPlayerLost(humans[counter]) == 0 then
                temp[getn(temp) + 1] = humans[counter]
            end
            counter = counter + 1
        end
        humans = temp
    end

    if isAnyOpponentDefeeted() == 1 then
        local temp = {}
        local counter = 1
        while counter <= getn(opponents) do
            if Game.HasPlayerLost(opponents[counter]) == 0 then
                temp[getn(temp) + 1] = opponents[counter]
            end
            counter = counter + 1
        end
        opponents = temp
    end

end

function isAnyHumanDefeeted()
    local counter = 1
    while counter <= getn(humans) do
        if Game.HasPlayerLost(humans[counter]) ~= 0 then
            return 1
        end
        counter = counter + 1
    end
    return 0
end

function isAnyOpponentDefeeted()
    local counter = 1
    while counter <= getn(opponents) do
        if Game.HasPlayerLost(opponents[counter]) ~= 0 then
            return 1
        end
        counter = counter + 1
    end
    return 0
end

function checkAttack()

    if Game.Time() >= (getEndgameTime() -10)  and Game.Time() <= (getEndgameTime() + 6) then
        if isDebug() == 1 then
            dbg.stm("no attack, waiting for endgame Attack")
        end
    else
        if Vars.Save1 + getMinTimeBetweenAttacks() <= Game.Time() then
            local amoutOfEnemyUnits = getAmountOfEnemysUnits()

            if customCheckIfAttack() ~= 0 then
                startAttack(getMainPlayerToAttack(), "customAttack")
                Vars.Save1 = Game.Time()
            else
                if amoutOfEnemyUnits >= getMinAttackAmount() then
                    startAttack(getMainPlayerToAttack(), "minAttackAmount")
                    Vars.Save1 = Game.Time()
                else
                    if Vars.Save1 + getMaxTimeBetweenAttacks() <= Game.Time() and Game.Time() >= 40 then
                        startAttack(getMainPlayerToAttack(), "maxTime")
                        Vars.Save1 = Game.Time()
                    else
                        local castleBuildingHuman = getIdOfCastleBuildingHuman()
                        if castleBuildingHuman ~= 0 then
                            startAttack(castleBuildingHuman, "castleBuildimg")
                            Vars.Save1 = Game.Time()
                        end
                    end
                end
            end
        end
    end
    -- Nach getMinTimeBetweenAttacks() Minuten darf der naechste Angriff erfolgen.
    --if Vars.Save1 + getMinTimeBetweenAttacks() <= Game.Time() then
    --Vars.Save1 = 0
    --end
    --end
end

function getIdOfCastleBuildingHuman()
    local counter = 1
    while counter <= getn(humans) do
        if Buildings.ExistsBuildingInArea(humans[counter], Buildings.CASTLE, 461, 700, 1000, Buildings.UNDERCONSTRUCTION) == 1 then
            return humans[counter]
        end
        counter = counter + 1
    end
    return 0
end




--Hier wird per zufall die Angriffsstrategie ausgewählt
--Generell gilt die Logik, es kann über die methode getAmoutOfAttackingEnemies definiert werden, wieviele Gegner gleichzeitig angreifen. Es greifen dabei immer die stärksten Gegner an entsprechend der Anzahl ihrer Einheiten. 
--Dabei gibt es verschiedene Angriffsszenarien, die per zufall ausgewählt werden.
function startAttack(mainAttackPlayer, attackCondition)


    local amountOfAttackingEnemies = getAmoutOfAttackingEnemies()
    local getPercentageAttackingUnits = getPercentageAttackingUnits(amountOfAttackingEnemies)
    local randomAttack = randomBetween(1, 100)

    local mainPlayer = mainAttackPlayer
    local attackType = ""

    if randomAttack <= 15 then
        -- greife alle den main player an
        attackType = "allMain"
        doAttackMainPlayer(amountOfAttackingEnemies, getPercentageAttackingUnits, mainAttackPlayer)
    else
        if randomAttack <= 40 then
            -- 50% der gegner greifen den main spieler an rest ist zufaellig
            attackType = "mostMain"
            doAttackMainPlayerMostEnemies(amountOfAttackingEnemies, getPercentageAttackingUnits, mainAttackPlayer, 50)
        else
            if randomAttack <= 55 then
                -- greife gleichmaesig verteilt an
                --dbg.stm("divided")
                attackType = "divided equal"
                doDividedAttack(amountOfAttackingEnemies, getPercentageAttackingUnits)
            else
                if randomAttack <= 75 then
                    -- greife einen zufaelligen Spieler als main an
                    attackType = "randomMainPlayer"
                    mainPlayer = getRandomHuman()
                    doAttackMainPlayerMostEnemies(amountOfAttackingEnemies, getPercentageAttackingUnits, mainPlayer, 50)
                else
                    -- greife zufallig an --> Default
                    attackType = "completeRandom"
                    doRandomAttack(amountOfAttackingEnemies, getPercentageAttackingUnits)
                end
            end
        end

    end
    if isAIDebug() == 1 then
        dbg.stm("Angriff Prozent:" .. getPercentageAttackingUnits .. " Anzahl:" .. amountOfAttackingEnemies .. " AttackType:" .. attackType .. " MainPlayer:" .. mainPlayer .. " Condition:" .. attackCondition)
    end
    attackStarted()

end

function doAttackMainPlayer(amountOfAttackingEnemies, getPercentageAttackingUnits, mainAttackPlayer)
    local position = 1
    while position <= amountOfAttackingEnemies do
        local humanIdToAttack = mainAttackPlayer
        local attackingEnemy = getEnemeyIDWithMostUnitsForPosition(position)
        local amountOfAttackingUnits = getPercentAmountOfPlayerUnits(attackingEnemy, getPercentageAttackingUnits)
        if isAIDebug() == 1 then
            dbg.stm("Enemy " .. attackingEnemy .. " Human " .. humanIdToAttack .. " Units " .. amountOfAttackingUnits)
        end
        AI.AttackNow(attackingEnemy, humanIdToAttack, amountOfAttackingUnits)
        position = position + 1
    end
end

function doAttackMainPlayerMostEnemies(amountOfAttackingEnemies, getPercentageAttackingUnits, mainAttackPlayer, percentOfEnemiesAttackingMainPlayer)
    local position = 1
    while position <= amountOfAttackingEnemies do
        local attackrnd = Game.Random100()
        local humanIdToAttack = mainAttackPlayer
        if attackrnd >= percentOfEnemiesAttackingMainPlayer then
            humanIdToAttack = getRandomHuman()
        end

        local attackingEnemy = getEnemeyIDWithMostUnitsForPosition(position)
        local amountOfAttackingUnits = getPercentAmountOfPlayerUnits(attackingEnemy, getPercentageAttackingUnits)
        --Das hier wieder rauskommentieren, wenn ihr sehen wollt, welcher Gegner wen angreift
        if isAIDebug() == 1 then
            dbg.stm("Enemy " .. attackingEnemy .. " Human " .. humanIdToAttack .. " Units " .. amountOfAttackingUnits)
        end
        AI.AttackNow(attackingEnemy, humanIdToAttack, amountOfAttackingUnits)
        position = position + 1
    end
end

function doRandomAttack(amountOfAttackingEnemies, getPercentageAttackingUnits)
    local position = 1
    while position <= amountOfAttackingEnemies do
        local humanIdToAttack = getRandomHuman()
        local attackingEnemy = getEnemeyIDWithMostUnitsForPosition(position)
        local amountOfAttackingUnits = getPercentAmountOfPlayerUnits(attackingEnemy, getPercentageAttackingUnits)
        --Das hier wieder rauskommentieren, wenn ihr sehen wollt, welcher Gegner wen angreift
        if isAIDebug() == 1 then
            dbg.stm("Enemy " .. attackingEnemy .. " Human " .. humanIdToAttack .. " Units " .. amountOfAttackingUnits)
        end
        AI.AttackNow(attackingEnemy, humanIdToAttack, amountOfAttackingUnits)
        position = position + 1
    end
end

function doDividedAttack(amountOfAttackingEnemies, getPercentageAttackingUnits)
    local position = 1
    local playerIdCounter = randomBetween(1, getn(humans))
    while position <= amountOfAttackingEnemies do
        local humanIdToAttack = humans[playerIdCounter]
        local attackingEnemy = getEnemeyIDWithMostUnitsForPosition(position)
        local amountOfAttackingUnits = getPercentAmountOfPlayerUnits(attackingEnemy, getPercentageAttackingUnits)
        --Das hier wieder rauskommentieren, wenn ihr sehen wollt, welcher Gegner wen angreift
        if isAIDebug() == 1 then
            dbg.stm("Enemy " .. attackingEnemy .. " Human " .. humanIdToAttack .. " Units " .. amountOfAttackingUnits)
        end
        AI.AttackNow(attackingEnemy, humanIdToAttack, amountOfAttackingUnits)
        position = position + 1

        playerIdCounter = playerIdCounter + 1
        if playerIdCounter > getn(humans) then
            playerIdCounter = 1
        end
    end
end





----------------------
-- playersUtiliy  ---
----------------------


-- gibt esprechend der reihenfolge der gegner mit den meisten Einheiten die id des gegners an der Stelle -position- zurueck. 
-- Bsp. postition=2 --> Gibt den gegner (ID) mit den zweitmeisten Einheiten zurueck
function getEnemeyIDWithMostUnitsForPosition(enemyPosition)

    local playercache = { 0, 0, 0, 0, 0, 0, 0, 0 }

    local i = 1
    -- setzt an die einzelnen stellen innerhalb des playerchache arrays die Einheitenanzahl etsprechend der spielerId
    -- Bpsp {0,0,0,34,12,43,34,34) --> jetzt waeren die letzten fuenf spieler opponents mit der entsprechenden Anzahl Einheiten
    while i <= getn(opponents) do
        playercache[opponents[i]] = getAmountOfPlayerUnitsWithoutBuildings(opponents[i])
        i = i + 1
    end

    --dbg.stm(playercache[1] .. " " .. playercache[2] .. " " .. playercache[3] .. " " .. playercache[4] .. " " .. playercache[5] .. " " .. playercache[6] .. " " .. playercache[7] .. " " .. playercache[8])

    -- delete biggest until empty
    local counter = 1
    local counter2 = 1
    local biggestValue = 0
    local biggestId = 1


    --loescht nach und nach den hoechsten aus dem cache
    while counter < enemyPosition do
        counter2 = 1
        biggestValue = 0
        while counter2 <= getn(playercache) do
            if playercache[counter2] > 0 then
                actualOpponentsId = counter2
                actualOpponentsAmount = playercache[counter2]
                if actualOpponentsAmount > biggestValue then
                    biggestId = actualOpponentsId
                    biggestValue = actualOpponentsAmount
                end
            end
            counter2 = counter2 + 1
        end
        playercache[biggestId] = 0
        counter = counter + 1
    end

    biggestValue = 0
    counter2 = 1
    biggestId = 1

    --jetzt is der hoechste der gesuchte. Alle hoeheren wurden geloescht
    while counter2 <= getn(playercache) do
        actualOpponentsId = counter2
        actualOpponentsAmount = playercache[counter2]
        if actualOpponentsAmount > biggestValue then
            biggestId = actualOpponentsId
            biggestValue = actualOpponentsAmount
        end
        counter2 = counter2 + 1
    end

    return biggestId
end

function getPercentAmountOfPlayerUnits(playerId, percent)
    local amountOfPlayerUnits = getAmountOfPlayerUnitsWithoutBuildings(playerId) / 100 * percent
    return floorNumber(amountOfPlayerUnits)
end

function getRandomHuman()
    local amountOfhumans = getn(humans)
    local playerId = humans[Game.Random(amountOfhumans) + 1]
    return playerId
end

function getAmountOfEnemysUnits()

    local AmoutOfCompleteEnemyMilitary = 0
    local counter = 1

    while counter <= getn(opponents) do
        AmoutOfCompleteEnemyMilitary = AmoutOfCompleteEnemyMilitary + getAmountOfPlayerUnitsWithoutBuildings(opponents[counter])
        counter = counter + 1
    end
    return AmoutOfCompleteEnemyMilitary
end

function getAmoutOfBuildings(playerId)


    local counter = 1
    local amountOfBuildings = 0

    --local buildingIds = getTableOfObjectIds(Buildings)
    --IDs der Gebaeude gehen von 1 - 83
    while counter <= 83 do
        amountOfBuildings = amountOfBuildings + Buildings.Amount(playerId, counter, Buildings.READY)
        counter = counter + 1
    end
    return amountOfBuildings
end


----------------------
-- generalUtility  ---
----------------------





-- gibt wenn die entsprechende Minute erreicht ist einmalig 1 zurueck
function minuteReached(value)
    if Game.Time() == value then
        if Vars.Save6 ~= value then
            Vars.Save6 = value
            return 1
        else
            return 0
        end
    end
end

-- gibt jede Minute einmal 1 zurueck
function newMinute()
    if Vars.Save7 ~= Game.Time() then
        Vars.Save7 = Game.Time()
        return 1
    else
        return 0
    end
end

-- Schneidet Nachkommastellen ab. 
function floorNumber(floatNumber)
    local stringmyValue = tostring(floatNumber)
    if strfind(stringmyValue, "(%.+)") ~= nil then
        local valuestring = strsub(stringmyValue, 1, strfind(stringmyValue, "(%.+)"))
        return tonumber(valuestring)
    else
        return floatNumber
    end

end

militaryUnits = { Settlers.SWORDSMAN_01, Settlers.SWORDSMAN_02, Settlers.SWORDSMAN_03, Settlers.BOWMAN_01, Settlers.BOWMAN_02, Settlers.BOWMAN_03, Settlers.AXEWARRIOR_01, Settlers.AXEWARRIOR_02, Settlers.AXEWARRIOR_03, Settlers.BLOWGUNWARRIOR_01, Settlers.BLOWGUNWARRIOR_02, Settlers.BLOWGUNWARRIOR_03, Settlers.BACKPACKCATAPULIST_01, Settlers.BACKPACKCATAPULIST_02, Settlers.BACKPACKCATAPULIST_03, Settlers.MEDIC_01, Settlers.MEDIC_02, Settlers.MEDIC_03, Settlers.SQUADLEADER }
-- Anzahl der Soldaten eines Spielers
function getAmountOfPlayerUnits(playerId)
    local amoutOfMilitary = 0
    local counter = 1
    while counter <= getn(militaryUnits) do
        amoutOfMilitary = amoutOfMilitary + Settlers.Amount(playerId, militaryUnits[counter])
        counter = counter + 1
    end
    return amoutOfMilitary
end

-- Anzahl der Soldaten eines Spielers innerhalb seiner Gebäude
function getUnitsInBuildings(playerId)
    local allUnits = 0
    allUnits = allUnits + Buildings.Amount(playerId, Buildings.GUARDTOWERSMALL, Buildings.READY)
    allUnits = allUnits + Buildings.Amount(playerId, Buildings.GUARDTOWERBIG, Buildings.READY) * 6
    allUnits = allUnits + Buildings.Amount(playerId, Buildings.CASTLE, Buildings.READY) * 8
    return allUnits
end

-- Anzahl an Soldaten eines Spieler ohne die Soldaten innerhalb der Gebäude
function getAmountOfPlayerUnitsWithoutBuildings(playerId)
    local allUnitsWithoutBuilding = getAmountOfPlayerUnits(playerId)
    allUnitsWithoutBuilding = allUnitsWithoutBuilding - getUnitsInBuildings(playerId)
    return allUnitsWithoutBuilding
end

-- Zufallszahl innerhalb eines bereichs. Beide Zahlen sind inklusive. 
--function randomBetween(fromNumber, toNumber)
--	local divNumber = toNumber - fromNumber
--	local randomNumber = fromNumber + Game.Random(divNumber + 1) 
--	return randomNumber
--end


seed = 0
lastSeed = 0

function randomBetween(fromNumber, toNumber)
    if seed == 0 or Game.Time() >= (lastSeed + 5) then
        seed = getSeed()
        lastSeed = Game.Time()
    else
        seed = seed * Settlers.Amount(1, Settlers.CARRIER)
    end
    seed = seed - floorNumber(seed)
    local divNumber = toNumber - fromNumber
    local randomNumber = fromNumber + floorNumber(seed * (divNumber + 1))
    return randomNumber
end

function getSeed()
    local width = Map.Width() - 1;
    local height = Map.Height() - 1;
    local x
    local y
    local p = Game.NumberOfPlayers()
    local seed = 0

    while p > 0
    do
        x = width
        while x >= 0
        do
            y = height
            while y >= 0
            do
                seed = seed + (Settlers.AmountInArea(p, Settlers.ANY_SETTLER, x, y, 1) * p * x * y) / 1000000
                y = y - 10
            end
            x = x - 10
        end
        p = p - 1
    end
    return seed
end

function getAmoutOfBuildings(playerId)
    local counter = 1
    local amountOfBuildings = 0

    --IDs der Gebaeude gehen von 1 - 83
    while counter <= 83 do
        amountOfBuildings = amountOfBuildings + Buildings.Amount(playerId, counter, Buildings.READY)
        counter = counter + 1
    end
    return amountOfBuildings
end

----
--LIB fuer Minute Events---
-----

MinuteEvents =  {
	-- table of all events at all minutes in format _minuteEventTable[minute][funcid (from 1 - n; no specific meaning)]
	_minuteEventTable = {}
}

-- calls all function types in table
function MinuteEvents._subroutine_foreachFunction(i,v)
	if type(v) == "function" then
		v();
	end
end
function MinuteEvents.runMinuteEventTick()
	-- true on first tick of new minute
	local currentMinute = Game.Time()
	if Vars.Save9 ~= currentMinute then
		Vars.Save9 = currentMinute  -- minute
		-- calls all functions in table
		if MinuteEvents._minuteEventTable[Vars.Save9] ~= nil then
			foreach(MinuteEvents._minuteEventTable[Vars.Save9],MinuteEvents._subroutine_foreachFunction)
		end
	end

end

-- sets Save9 to 0 on start
function MinuteEvents.initVars()
    Vars.Save9 = 0
end
function MinuteEvents.new_game()
    request_event(MinuteEvents.runMinuteEventTick, Events.TICK)
    request_event(register_minute_events, Events.FIRST_TICK_OF_NEW_OR_LOADED_GAME)
    request_event(MinuteEvents.initVars, Events.FIRST_TICK_OF_NEW_GAME)
end
function MinuteEvents.register_functions()
    reg_func(MinuteEvents.runMinuteEventTick)
    reg_func(MinuteEvents.initVars)
    reg_func(register_minute_events)
end

-- util function to use
function requestMinuteEvent(eventfunc, minute)
    if MinuteEvents._minuteEventTable[minute] == nil then
        MinuteEvents._minuteEventTable[minute] = {}
    end
    tinsert(MinuteEvents._minuteEventTable[minute], eventfunc)
end

function requestEveryMinuteEvent(eventfunc, minutes)
    if MinuteEvents._minuteEventTable[minute] == nil then
        MinuteEvents._minuteEventTable[minute] = {}
    end
    tinsert(MinuteEvents._minuteEventTable[minute], eventfunc)
end

