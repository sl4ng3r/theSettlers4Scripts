function new_game()

    --wird fuer minute events benoetigt.
    Vars.Save8 = 0

    --Anzahl an Spielern
    Vars.Save1 = 0

    --WAVE Number
    Vars.Save2 = 0

    -- Miute of last Wave
    Vars.Save3 = 0

    testfunction()

    MinuteEvents.new_game()
    request_event(doActionsAfterMinutes, Events.FIVE_TICKS)
    request_event(checkSpawnPointDefeted, Events.FIVE_TICKS)
    request_event(removeSpecialistNearSpawnpoints, Events.FIVE_TICKS)
    request_event(initGame,Events.FIRST_TICK_OF_NEW_OR_LOADED_GAME)
    request_event(Siegbedingung, Events.VICTORY_CONDITION_CHECK)

    dbg.stm("Willkommen bei Defeat the Waves! Aus 6 Ecken werden euch Gegner Wellen angreifen, die mit der Zeit immer stärker werden. Ihr könnt die Wellen der entsprechenden Einheiten stoppen, indem ihr deren Lager in den einzelnen Ecken besiegt. (Zwei Lager befinden sich auf Inseln ;-)). Nach 15 Minuten gehts los, also gebt Gas!! Viel Spaß :-D")


end

function register_functions()
    reg_func(Siegbedingung)
    reg_func(doActionsAfterMinutes)
    reg_func(initGame)
    reg_func(checkSpawnPointDefeted)
    reg_func(removeSpecialistNearSpawnpoints)
    MinuteEvents.register_functions()
end

tickCounter = 1
tickCounter2 = 1
gameDone = 0


function isDebug()
    return 0
end

function spawnDegubUnits()
    return 0
end

function getStartTime()
    return 15
end

function getWinTime()
    return 85
end

function testfunction()

    if spawnDegubUnits() == 1 then
        --player1
        Settlers.AddSettlers(395, 480, 1, Settlers.BOWMAN_03, 400)
        Settlers.AddSettlers(395, 480, 1, Settlers.SWORDSMAN_03, 200)

        --player3
        Settlers.AddSettlers(530, 395, 3, Settlers.BOWMAN_03, 400)
        Settlers.AddSettlers(530, 395, 3, Settlers.SWORDSMAN_03, 200)

        Game.SetFightingStrength(1, 120)

    end


    if isDebug() == 1 then
        dbg.stm("debug an")
        dbg.stm("aktuelles Mana7:" .. Magic.CurrentManaAmount(7) .. " fightStr:" .. Game.GetOffenceFightingStrength(6) .. "/" .. Game.GetOffenceFightingStrength(7) .. "/" .. Game.GetOffenceFightingStrength(8) )
        Buildings.AddBuilding(386, 397, 1, Buildings.STORAGEAREA)
    end
end


function Siegbedingung()
    Game.DefaultPlayersLostCheck()
    if Game.HasPlayerLost(1) == 1 then
        Game.PlayerLost(2)
        Game.PlayerLost(3)
        Game.PlayerLost(4)
        Game.PlayerLost(5)
        dbg.stm("Ihr habt bis Minute " .. Game.Time() .. " durchgehalten!")
    end
    Game.DefaultGameEndCheck()
end


players= {
    p1={
        x=411,
        y=482,
        ai=0,
        id=1
    },
    p2={
        x=479,
        y=494,
        ai=0,
        id=2
    },
    p3={
        x=471,
        y=393,
        ai=0,
        id=3
    },
    p4={
        x=351,
        y=293,
        ai=0,
        id=4
    },
    p5={
        x=309,
        y=355,
        ai=0,
        id=5
    }
}


spawnpoints={
    --left
    sp1={
        settlerType1=Settlers.MEDIC_01,
        settlerType2=Settlers.SWORDSMAN_01,
        settlerType3=Settlers.MEDIC_03,
        x=212,
        y=470,
        player=7,
        defeated=0,
        settlersX=150,
        settlersY=460,
        defeatMessage="Ihr habt die Sanitäter der Römer besiegt!"
    },
    --leftTop
    sp2={
        settlerType1=Settlers.BOWMAN_01,
        settlerType2=Settlers.BOWMAN_02,
        settlerType3=Settlers.BOWMAN_03,
        x=181,
        y=143,
        player=6,
        defeated=0,
        settlersX=97,
        settlersY=89,
        defeatMessage="Ihr habt die Bogenschützen der Mayas besiegt!"
    },
    --rigthTop
    sp3={
        settlerType1=Settlers.SWORDSMAN_01,
        settlerType2=Settlers.SWORDSMAN_02,
        settlerType3=Settlers.SWORDSMAN_03,
        x=424,
        y=171,
        player=6,
        defeated=0,
        settlersX=501,
        settlersY=129,
        defeatMessage="Ihr habt die Schwertkämpfer der Mayas besiegt!"
    },
    --right
    sp4={
        settlerType1=Settlers.BLOWGUNWARRIOR_01,
        settlerType2=Settlers.BLOWGUNWARRIOR_02,
        settlerType3=Settlers.BLOWGUNWARRIOR_03,
        x=646,
        y=445,
        player=6,
        defeated=0,
        settlersX=702,
        settlersY=447,
        defeatMessage="Ihr habt die Blasrohr Kämpfer der Mayas besiegt!"
    },
    --rightbottom
    sp5={
        settlerType1=Settlers.BOWMAN_01,
        settlerType2=Settlers.BOWMAN_02,
        settlerType3=Settlers.BOWMAN_03,
        x=600,
        y=742,
        player=8,
        defeated=0,
        settlersX=687,
        settlersY=774,
        defeatMessage="Ihr habt die Bogenschützen der Wikinger besiegt!"
    },
    --leftbottom
    sp6={
        settlerType1=Settlers.AXEWARRIOR_01,
        settlerType2=Settlers.AXEWARRIOR_02,
        settlerType3=Settlers.AXEWARRIOR_03,
        x=384,
        y=659,
        player=8,
        defeated=0,
        settlersX=304,
        settlersY=706,
        defeatMessage="Ihr habt die Axtkämpfer der Wikinger besiegt!"
    }
}



amountOfStartBuildings=15


function initGame()

    if isDebug() == 1 then
        Tutorial.RWM(1)
    end

    if Game.GetDifficulty() == 1 then
        dbg.stm("Ihr habt euch für eine schwere Partie entschieden!")
    else
        dbg.stm("Ihr habt euch für eine leichtere Partie entschieden!")
    end

    dbg.aioff(1)
    dbg.aioff(2)
    dbg.aioff(3)
    dbg.aioff(4)
    dbg.aioff(5)
    AI.SetPlayerVar(6, "AttackMode", 3,3,3)
    AI.SetPlayerVar(7, "AttackMode", 1,1,1)
    AI.SetPlayerVar(8, "AttackMode", 3,3,3)


    local attackTime = getStartTime()

    --First Wave
    requestMinuteEvent(spawnUnits,attackTime)

    -- Andere startzeit falls geladen wird
    if Vars.Save3 > getStartTime() then
        attackTime = Vars.Save3
    end;

    local wavecounter = 1

    while attackTime <= 70 do
        wavecounter = wavecounter + 1

        if attackTime <= 25 then
            attackTime = attackTime + 7
        else
            if attackTime <= 34 then
                attackTime = attackTime + 6
            else
                if attackTime <= 59 then
                    attackTime = attackTime + 5
                else
                    attackTime = attackTime + 4
                end
            end
        end
        if isDebug() == 1 then
            dbg.stm("Game Load: Last Wave " .. Vars.Save3 .. " / next Wave " ..  attackTime .. " AmountDoneWaves:" .. Vars.Save2 .. " WaveNr:" .. wavecounter)
        end
        requestMinuteEvent(spawnUnits,attackTime)

    end
    -- Die welle kommt frueher, je mehr Mitspieler

    if Game.Time() > 7 then
        requestMinuteEvent(finalWave,getWinTime() - (6 + Vars.Save1))
    end

    attackTime = getWinTime() + 2
    while attackTime <= 200 do
        requestMinuteEvent(spawnUnits,attackTime)
        attackTime = attackTime + 5
    end


    --Hier wir ueberprueft, wer alles CPU Spieler ist
    requestMinuteEvent(checkAIs,7)

    --requestMinuteEvent(checkAIs,5)
    requestMinuteEvent(gameWon,getWinTime())
end



function gameWon()
    Tutorial.Won()
    dbg.stm("Herzlichen Glückwunsch!!! Das Spiel ist gewonnen. Ihr könnt dennoch weiterspielen und schauen, wie lange ihr durchhaltet.. :D")
end

counterOfPlayer = 0

function checkAIs()



    checkIfDestroyParty(players.p1)
    checkIfDestroyParty(players.p2)
    checkIfDestroyParty(players.p3)
    checkIfDestroyParty(players.p4)
    checkIfDestroyParty(players.p5)

    reduceSpawnChamps(counterOfPlayer)

    Vars.Save1 = counterOfPlayer
    dbg.stm("Ihr spielt eine Partie für " .. counterOfPlayer .. " Spieler")

    requestMinuteEvent(finalWave,getWinTime() - (5 + Vars.Save1))

    --muss wieder raus
    startFinalWave()

end

function checkIfDestroyParty(theplayer)
    if getAmoutOfBuildings(theplayer.id)  == amountOfStartBuildings then
        theplayer.ai = 1
        destroyParty(theplayer);
    else
        counterOfPlayer = counterOfPlayer + 1
    end
end

function destroyParty(theplayer)
    local counter = 1
    --IDs der Gebaeude gehen von 1 - 83
    while counter <= 83 do
        while Buildings.Amount(theplayer.id, counter, Buildings.READY) > 0 do
            Buildings.Delete(Buildings.GetFirstBuilding(theplayer.id, counter),2)
        end
        counter = counter +  1
    end

    counter = 1
    --IDs der Gebaeude gehen von 1 - 83
    while counter <= 80 do
        Settlers.KillSelectableSettlers(theplayer.id, counter, theplayer.x, theplayer.y, 70, 0)
        counter = counter +  1
    end

    counter = 1
    --IDs der Gebaeude gehen von 1 - 83
    while counter <= 43 do
        Goods.Delete(theplayer.x,theplayer.y,35,counter)
        counter = counter +  1
    end
end




function reduceSpawnChamps(amountPlayers)

    reduceCreepsInSpawnPoint(spawnpoints.sp1,amountPlayers)
    reduceCreepsInSpawnPoint(spawnpoints.sp2,amountPlayers)
    reduceCreepsInSpawnPoint(spawnpoints.sp3,amountPlayers)
    reduceCreepsInSpawnPoint(spawnpoints.sp4,amountPlayers)
    reduceCreepsInSpawnPoint(spawnpoints.sp5,amountPlayers)
    reduceCreepsInSpawnPoint(spawnpoints.sp6,amountPlayers)


end

function reduceCreepsInSpawnPoint(spawnpoint,amountPlayers)
    local radius = 20 - amountPlayers * 4 + 1
    if Game.GetDifficulty() == 1 then
        radius = 20 - amountPlayers * 4
    end

    Settlers.KillSelectableSettlers(spawnpoint.player, spawnpoint.settlerType1, spawnpoint.settlersX, spawnpoint.settlersY, radius , 0)
    Settlers.KillSelectableSettlers(spawnpoint.player, spawnpoint.settlerType2, spawnpoint.settlersX, spawnpoint.settlersY, radius , 0)
    Settlers.KillSelectableSettlers(spawnpoint.player, spawnpoint.settlerType3, spawnpoint.settlersX, spawnpoint.settlersY, radius , 0)
    Settlers.KillSelectableSettlers(spawnpoint.player, Settlers.BOWMAN_03, spawnpoint.settlersX, spawnpoint.settlersY, radius , 0)
end



function finalWave()
    Vars.Save2 = Vars.Save2 + 1
    dbg.stm("########--Final wave is coming....--########")
    spawnSpawnPoint(spawnpoints.sp1,spawnpoints.sp1)
    spawnSpawnPoint(spawnpoints.sp1,spawnpoints.sp1)
    spawnSpawnPoint(spawnpoints.sp1,spawnpoints.sp1)
    spawnSpawnPoint(spawnpoints.sp2,spawnpoints.sp2)
    spawnSpawnPoint(spawnpoints.sp3,spawnpoints.sp3)
    spawnSpawnPoint(spawnpoints.sp4,spawnpoints.sp4)
    spawnSpawnPoint(spawnpoints.sp4,spawnpoints.sp4)
    spawnSpawnPoint(spawnpoints.sp5,spawnpoints.sp5)
    spawnSpawnPoint(spawnpoints.sp6,spawnpoints.sp6)
    doRandomSpawnOnEachSpawnpoint()
    doRandomSpawnOnEachSpawnpoint()


    AI.NewSquad(6, AI.CMD_SUICIDE_MISSION )
    AI.NewSquad(7, AI.CMD_SUICIDE_MISSION )
    AI.NewSquad(8, AI.CMD_SUICIDE_MISSION )
end

---Eine welle startet
function spawnUnits()

    Vars.Save2 = Vars.Save2 + 1
    Vars.Save3 = Game.Time()


    if Game.GetDifficulty() == 1 then
        addFightingStrength(6)
    else
        addFightingStrength(4)
    end


    if Game.Time() > getWinTime() then
        dbg.stm("Welle " .. Vars.Save2 .. " ist unterwegs!!!!")
    end

    local randomValue = randomBetween(1,100)
    local chaosRound = 0
    if randomValue >= 15 then
        chaosRound = 1
    else
        chaosRound = 0
    end


    if chaosRound == 1 then
        spawnChaosRound()
    else
        spawnNormalRound()
    end

    AI.NewSquad(6, AI.CMD_SUICIDE_MISSION )
    AI.NewSquad(7, AI.CMD_SUICIDE_MISSION )
    AI.NewSquad(8, AI.CMD_SUICIDE_MISSION )

    if isDebug() == 1 then
        dbg.stm("ChaosRound:" .. chaosRound .. " AttMin:" .. Game.Time() .. " wave:" .. Vars.Save2 .. " amLvl1:" .. getAmountLvl1() .. " amLvl2:" .. getAmountLvl2() .. " amLvl3:" .. getAmountLvl3() ..  " rndAm:" .. getAmountRandomUnits() .. " addRnUnits:" .. getAdditionalRandomUnitsHard().. " aktuelles Mana7:" .. Magic.CurrentManaAmount(7) .. " fightStr:" .. Game.GetOffenceFightingStrength(6) .. "/" .. Game.GetOffenceFightingStrength(7) .. "/" .. Game.GetOffenceFightingStrength(8) )
    end


end

function addFightingStrength(strength)
    Game.SetFightingStrength(6, Game.GetOffenceFightingStrength(6) + strength)
    Game.SetFightingStrength(7, Game.GetOffenceFightingStrength(7) + strength)
    Game.SetFightingStrength(8, Game.GetOffenceFightingStrength(8) + strength)
end

function spawnChaosRound()

    local cachetable = {}
    local randomNumber = 1
    tinsert(cachetable,spawnpoints.sp1)
    randomNumber = randomBetween(1,getn(cachetable)+1)
    tinsert(cachetable,randomNumber,spawnpoints.sp2)
    randomNumber = randomBetween(1,getn(cachetable)+1)
    tinsert(cachetable,randomNumber,spawnpoints.sp3)
    randomNumber = randomBetween(1,getn(cachetable)+1)
    tinsert(cachetable,randomNumber,spawnpoints.sp4)
    randomNumber = randomBetween(1,getn(cachetable)+1)
    tinsert(cachetable,randomNumber,spawnpoints.sp5)
    randomNumber = randomBetween(1,getn(cachetable)+1)
    tinsert(cachetable,randomNumber,spawnpoints.sp6)



    spawnSpawnPoint(spawnpoints.sp1,cachetable[1])
    spawnSpawnPoint(spawnpoints.sp2,cachetable[2])
    spawnSpawnPoint(spawnpoints.sp3,cachetable[3])
    spawnSpawnPoint(spawnpoints.sp4,cachetable[4])
    spawnSpawnPoint(spawnpoints.sp5,cachetable[5])
    spawnSpawnPoint(spawnpoints.sp6,cachetable[6])

    spawnRandomUnitsOnSpawnPoint(spawnpoints.sp1, cachetable[1])
    spawnRandomUnitsOnSpawnPoint(spawnpoints.sp2, cachetable[2])
    spawnRandomUnitsOnSpawnPoint(spawnpoints.sp3, cachetable[3])
    spawnRandomUnitsOnSpawnPoint(spawnpoints.sp4, cachetable[4])
    spawnRandomUnitsOnSpawnPoint(spawnpoints.sp5, cachetable[5])
    spawnRandomUnitsOnSpawnPoint(spawnpoints.sp6, cachetable[6])

end

function spawnNormalRound()
    spawnSpawnPoint(spawnpoints.sp1,spawnpoints.sp1)
    spawnSpawnPoint(spawnpoints.sp2,spawnpoints.sp2)
    spawnSpawnPoint(spawnpoints.sp3,spawnpoints.sp3)
    spawnSpawnPoint(spawnpoints.sp4,spawnpoints.sp4)
    spawnSpawnPoint(spawnpoints.sp5,spawnpoints.sp5)
    spawnSpawnPoint(spawnpoints.sp6,spawnpoints.sp6)
    doRandomSpawnOnEachSpawnpoint()
end


function spawnSpawnPoint(spawnpointCheck, spawnpoint)

    if spawnpointCheck.defeated == 0 then
        Settlers.AddSettlers(spawnpoint.x,spawnpoint.y, spawnpointCheck.player, spawnpointCheck.settlerType1, getAmountLvl1())
        Settlers.AddSettlers(spawnpoint.x,spawnpoint.y, spawnpointCheck.player, spawnpointCheck.settlerType2, getAmountLvl2())
        Settlers.AddSettlers(spawnpoint.x,spawnpoint.y, spawnpointCheck.player, spawnpointCheck.settlerType3, getAmountLvl3())

        --if Game.GetDifficulty() == 1 then
        --Settlers.AddSettlers(spawnpoint.x,spawnpoint.y, spawnpointCheck.player, spawnpointCheck.settlerType2, floorNumber(Vars.Save2 * Vars.Save1 * 0.9) + 1)
        --Settlers.AddSettlers(spawnpoint.x,spawnpoint.y, spawnpointCheck.player, spawnpointCheck.settlerType3, floorNumber(Vars.Save2 * Vars.Save1 * 0.9) + 1)
        --end
    end
end


function doRandomSpawnOnEachSpawnpoint()
    spawnRandomUnitsOnSpawnPoint(spawnpoints.sp1, spawnpoints.sp1)
    spawnRandomUnitsOnSpawnPoint(spawnpoints.sp2, spawnpoints.sp2)
    spawnRandomUnitsOnSpawnPoint(spawnpoints.sp3, spawnpoints.sp3)
    spawnRandomUnitsOnSpawnPoint(spawnpoints.sp4, spawnpoints.sp4)
    spawnRandomUnitsOnSpawnPoint(spawnpoints.sp5, spawnpoints.sp5)
    spawnRandomUnitsOnSpawnPoint(spawnpoints.sp6, spawnpoints.sp6)
end

function spawnRandomUnitsOnSpawnPoint(spawnpointCheck, spawnPoint)
    if spawnpointCheck.defeated == 0 then
        local randomUnits = {Settlers.SWORDSMAN_03,Settlers.BOWMAN_01,Settlers.BOWMAN_02,Settlers.BOWMAN_03}
        if Game.GetDifficulty() == 1 then
            randomUnits = {Settlers.SWORDSMAN_03,Settlers.BOWMAN_02,Settlers.BOWMAN_03}
        end

        local unitIndex = randomBetween(1,getn(randomUnits))
        Settlers.AddSettlers(spawnPoint.x, spawnPoint.y, spawnpointCheck.player, randomUnits[unitIndex],getAmountRandomUnits())
        if Game.GetDifficulty() == 1 then
            unitIndex = randomBetween(1,getn(randomUnits))
            Settlers.AddSettlers(spawnPoint.x, spawnPoint.y, spawnpointCheck.player, randomUnits[unitIndex], getAdditionalRandomUnitsHard())
        end
    end
end



function getAmountRandomUnits()
    return floorNumber(0.5 * Vars.Save2 + 1) * Vars.Save1
end

function getAdditionalRandomUnitsHard()
    if Game.GetDifficulty() == 1 then
        return floorNumber((0.0014 * Vars.Save2 * Vars.Save2 *Vars.Save2 + 0.56 * Vars.Save2 + 1)) * Vars.Save1
        --return floorNumber((Vars.Save2 / 1.5 + 1)) * Vars.Save1
    else
        return 0
    end
end

function getAmountLvl1()
    return max(0,(5 - Vars.Save2) * Vars.Save1)
end

function getAmountLvl2()
    if Game.GetDifficulty() == 1 then
        return floorNumber(0.5 * Vars.Save2 + 0.0006 * Vars.Save2 * Vars.Save2* Vars.Save2 * Vars.Save2 +1.5) * Vars.Save1 - getAmountRemoveForPlayers()
    else
        return  (Vars.Save2 +floorNumber( 0.048 * Vars.Save2 * Vars.Save2 ) + 1) * Vars.Save1 - getAmountRemoveForPlayers()
    end
end

function getAmountLvl3()
    --return   ((Vars.Save2 - 4) * (Vars.Save2 - 4)) * (Vars.Save1) - (Vars.Save1 * (Vars.Save2 - 5))
    return floorNumber(0.0111 * Vars.Save2 * Vars.Save2 * Vars.Save2 + 0.7) * Vars.Save1 - getAmountRemoveForPlayers()
    --return ((Vars.Save2 - 4) * 2 ) * (Vars.Save1)
end

function getAmountRemoveForPlayers()
    return floorNumber((Vars.Save1 - 1) * 0.08 * Vars.Save2 + 0.12 * Vars.Save1 + 0.6)
end

function removeSpecialistNearSpawnpoints()

    tickCounter = tickCounter + 5

    if tickCounter >= 257 then

        local index = 1

        --IDs der Gebaeude gehen von 1 - 83
        while index <= 5 do
            removeSpecialistNearSpawnpoint(spawnpoints.sp1,index)
            removeSpecialistNearSpawnpoint(spawnpoints.sp2,index)
            removeSpecialistNearSpawnpoint(spawnpoints.sp3,index)
            removeSpecialistNearSpawnpoint(spawnpoints.sp4,index)
            removeSpecialistNearSpawnpoint(spawnpoints.sp5,index)
            removeSpecialistNearSpawnpoint(spawnpoints.sp6,index)
            index = index +  1
        end
        tickCounter = 1
    end



end

function removeSpecialistNearSpawnpoint(spawnPoint, playerId)
    local specialists = {Settlers.PIONEER,Settlers.SABOTEUR,Settlers.GEOLOGIST,Settlers.THIEF,Settlers.GARDENER}
    local index = 1

    --IDs der Gebaeude gehen von 1 - 83
    while index <= getn(specialists) do
        if Settlers.AmountInArea(playerId, specialists[index], spawnPoint.x, spawnPoint.y, 65) > 0 then
            Settlers.KillSelectableSettlers(playerId, specialists[index], spawnPoint.x, spawnPoint.y, 65, 0)
            dbg.stm("Ein greller Blitz, zzzzzschhhhh. Deine Einheiten sterben... Du hörst eine Stimme... Nur Soldaten können sich den Portalen nähern. ")
        end
        index = index +  1
    end
end



function checkSpawnPointDefeted()
    tickCounter2 = tickCounter2 + 5
    if tickCounter >= 100 then
        isSpawnPointDefeted(spawnpoints.sp1)
        isSpawnPointDefeted(spawnpoints.sp2)
        isSpawnPointDefeted(spawnpoints.sp3)
        isSpawnPointDefeted(spawnpoints.sp4)
        isSpawnPointDefeted(spawnpoints.sp5)
        isSpawnPointDefeted(spawnpoints.sp6)

        if (spawnpoints.sp1.defeated + spawnpoints.sp2.defeated + spawnpoints.sp3.defeated  + spawnpoints.sp4.defeated + spawnpoints.sp5.defeated + spawnpoints.sp6.defeated) == 6 and gameDone == 0 then
            dbg.stm("Ihr habt alle Lager besiegt!! Ihr habt es in " .. Game.Time() .. " Minuten geschafft!!")
            gameDone = 1
        end
        tickCounter2 = 1
    end
end

function isSpawnPointDefeted(spawnPoint)

    if Settlers.AmountInArea(spawnPoint.player, spawnPoint.settlerType1, spawnPoint.settlersX, spawnPoint.settlersY, 50) == 0  and Settlers.AmountInArea(spawnPoint.player, spawnPoint.settlerType2, spawnPoint.settlersX, spawnPoint.settlersY, 50) == 0 and Settlers.AmountInArea(spawnPoint.player, spawnPoint.settlerType3, spawnPoint.settlersX, spawnPoint.settlersY, 50) == 0 then
        if spawnPoint.defeated == 0 then
            dbg.stm(spawnPoint.defeatMessage)
        end
        spawnPoint.defeated = 1
    end

end







function blaTest(index,spawnpoint)
    Settlers.AddSettlers(spawnpoint.x, spawnpoint.y, 6, spawnpoint.settlerType1, 20)
    dbg.stm("added")
end

function doActionsAfterMinutes()
    --wird jede Minute ausgefuehrt
    if newMinute() == 1 then
        Magic.IncreaseMana(7,3)
    end

    if minuteReached(1) == 1 then

    end

end










----------------------
-- generalUtility  ---
----------------------


mytable={
    buildings={
        otype=1,
        s4table=Buildings
    },
    settlers={
        otype=2,
        s4table=Settlers
    }
}


function max(value1, value2)
    if value1 > value2 then
        return value1
    end
    return value2
end

function getAmountOfObects(playerId, objectTable)
    local counter = 1
    local amountOfObjects = 0

    local objectIds = getTableOfObjectIds(objectTable.s4table)
    --IDs der Gebaeude gehen von 1 - 83
    while counter <= getn(objectIds) do
        if objectTable.otype== 1 then
            amountOfObjects = amountOfObjects + Buildings.Amount(playerId, objectIds[counter], Buildings.READY)
        end
        if objectTable.otype== 2 then
            amountOfObjects = amountOfObjects + Settlers.Amount(playerId, objectIds[counter])
        end
        counter = counter +  1
    end
    return amountOfObjects
end

function getTableOfObjectIds(s4table)
    local i,v = next(s4table,nil);
    local cachetable={}
    while i ~= nil do
        if type(v) == "number" then
            tinsert(cachetable, v)
        end
        i,v = next(s4table,i);
    end
    return cachetable
end


function getAmountOfObects(playerId, objectTable)

    local counter = 1
    local amountOfObjects = 0

    local buildingIds = getTableOfObjectIds(Buildings)
    --IDs der Gebaeude gehen von 1 - 83
    while counter <= getn(buildingIds) do
        amountOfBuildings = amountOfBuildings + Buildings.Amount(playerId, counter, Buildings.READY)
        counter = counter +  1
    end
    return amountOfBuildings

end

function getAmoutOfBuildings(playerId)


    local counter = 1
    local amountOfBuildings = 0

    --local buildingIds = getTableOfObjectIds(Buildings)
    --IDs der Gebaeude gehen von 1 - 83
    while counter <= 83 do
        amountOfBuildings = amountOfBuildings + Buildings.Amount(playerId, counter, Buildings.READY)
        counter = counter +  1
    end
    return amountOfBuildings
end

function getTableOfObjectIds(thetable)
    local i,v = next(thetable,nil);
    local cachetable={}
    while i ~= nil do
        if type(v) == "number" then
            tinsert(cachetable, v)
        end
        i,v = next(thetable,i);
    end
    return cachetable
end


function floorNumber(floatNumber)
    local stringmyValue =  tostring(floatNumber)
    if strfind (stringmyValue, "(%.+)") ~= nil then
        local valuestring = strsub (stringmyValue, 1, strfind (stringmyValue, "(%.+)"))
        return tonumber(valuestring)
    else
        return floatNumber
    end
end

-- gibt jede Minute einmal 1 zurueck
function newMinute()
    if Vars.Save8 ~= Game.Time() then
        Vars.Save8 = Game.Time()
        return 1
    else
        return 0
    end
end


-- gibt wenn die entsprechende Minute erreicht ist einmalig 1 zurueck
function minuteReached(value)
    if Game.Time() == value then
        if Vars.Save5 ~= value then
            Vars.Save5 = value
            return 1
        else
            return 0
        end
    end
end


militaryUnits={Settlers.SWORDSMAN_01,Settlers.SWORDSMAN_02,Settlers.SWORDSMAN_03,Settlers.BOWMAN_01,Settlers.BOWMAN_02,Settlers.BOWMAN_03,Settlers.AXEWARRIOR_01,Settlers.AXEWARRIOR_02,Settlers.AXEWARRIOR_03,Settlers.BLOWGUNWARRIOR_01,Settlers.BLOWGUNWARRIOR_02,Settlers.BLOWGUNWARRIOR_03,Settlers.BACKPACKCATAPULIST_01,Settlers.BACKPACKCATAPULIST_02,Settlers.BACKPACKCATAPULIST_03,Settlers.MEDIC_01,Settlers.MEDIC_02,Settlers.MEDIC_03,Settlers.SQUADLEADER}

function getAmountOfPlayerUnits(playerId)
    local amoutOfMilitary = 0
    local counter = 1
    while counter <= getn(militaryUnits) do
        amoutOfMilitary =  amoutOfMilitary + Settlers.Amount(playerId, militaryUnits[counter])
        counter = counter + 1
    end
    return amoutOfMilitary
end

function getUnitsInBuildings(playerId)
    local allUnits = 0
    allUnits = allUnits + Buildings.Amount(playerId, Buildings.GUARDTOWERSMALL, Buildings.READY)
    allUnits = allUnits + Buildings.Amount(playerId, Buildings.GUARDTOWERBIG, Buildings.READY) * 6
    allUnits = allUnits + Buildings.Amount(playerId,Buildings.CASTLE, Buildings.READY) * 8
    return allUnits
end

function getAmountOfPlayerUnitsWithoutBuildings(playerId)
    local allUnitsWithoutBuilding = getAmountOfPlayerUnits(playerId)
    allUnitsWithoutBuilding = allUnitsWithoutBuilding - getUnitsInBuildings(playerId)
    return allUnitsWithoutBuilding
end

function randomBetween(fromNumber, toNumber)
    local divNumber = toNumber - fromNumber
    local randomNumber = fromNumber + Game.Random(divNumber + 1)
    return randomNumber
end


function shuffleTable(theTable)

    cachetable = {}



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
    request_event(MinuteEvents.runMinuteEventTick,Events.TICK)
    request_event(register_minute_events,Events.FIRST_TICK_OF_NEW_OR_LOADED_GAME)
    request_event(MinuteEvents.initVars,Events.FIRST_TICK_OF_NEW_GAME)
end
function MinuteEvents.register_functions()
    reg_func(MinuteEvents.runMinuteEventTick)
    reg_func(MinuteEvents.initVars)
    reg_func(register_minute_events)
end

-- util function to use
function requestMinuteEvent(eventfunc,minute)
    if MinuteEvents._minuteEventTable[minute] == nil then
        MinuteEvents._minuteEventTable[minute] = {}
    end
    tinsert(MinuteEvents._minuteEventTable[minute],eventfunc)
end
