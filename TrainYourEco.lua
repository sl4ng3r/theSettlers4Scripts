---- Dieses Template kannst du in deine neue map einfach kopieren. Es stellt dir viele "Standard" Funktionen bereits zur Verfügung.
---- Das eigentliche Script geht ab der Zeile 169 los --> "Ab hier beginnt das eigentliche Script".
---- Have fun -- sl4ng3r --

-------------------------------------------------------------
----SCRIPT zum erhöhen der Speichermöglichkeiten ------------
----(Da sonst begrenzt auf die 9 Vars.Save Variablen)--------
----Es muss vor dem eigentlichen Script ausgeführt werden----
----Danke an MuffinMario für dieses göttliche Script!!-------
-------------------------------------------------------------

VarsExt = {
    MAXSPACE = 9
}
VarsExt["Vars"] = {
    VarsExt.MAXSPACE, VarsExt.MAXSPACE, VarsExt.MAXSPACE,

    VarsExt.MAXSPACE, VarsExt.MAXSPACE, VarsExt.MAXSPACE,

    VarsExt.MAXSPACE, VarsExt.MAXSPACE, VarsExt.MAXSPACE
}

-- if str is not at least minSize characters, fill char from the left until size is reached
-- e.g. str_fill_left("123","0",9) becomes "000000123"
function str_fill_left(str, char, minSize)
    local its = (minSize - strlen(str)) / strlen(char)
    local endStr = ""
    while its > 0 do
        endStr = endStr .. char
        its = its - 1
    end
    endStr = endStr .. str
    return endStr;
end

VarsExt.saveVar = function(save, offset, size, value)
    local currentSaveVal = Vars["Save" .. save];
    local saveValStr = str_fill_left(format("%.0f", currentSaveVal), "0", VarsExt.MAXSPACE)
    --print(saveValStr .. " = saveVar(): current value ");
    local leftsize = offset
    local leftStr = strsub(saveValStr, 1, leftsize);
    local rightStr = strsub(saveValStr, offset + 1 + size)
    local newstr = leftStr .. str_fill_left(tostring(value), "0", size) .. rightStr;
    --print(newstr .. " = saveVar(): after safe value ");
    Vars["Save" .. save] = tonumber(newstr);
end
VarsExt.getVar = function(save, offset, size)

    local currentSaveVal = Vars["Save" .. save];

    local saveValStr = str_fill_left(format("%.0f", currentSaveVal), "0", VarsExt.MAXSPACE)

    local myVal = tonumber(strsub(saveValStr, offset + 1, offset + size))

    return myVal;
end
VarsExt.save = function(this, value)
    if value > this.maxnum or value < 0 then
        return ;
    end
    VarsExt.saveVar(this.i, this.off, this.size, value);
end
VarsExt.get = function(this)
    return VarsExt.getVar(this.i, this.off, this.size);
end

-- util foreach
function foreach_ext (t, f, ...)
    local i, v = next(t, nil)
    while i do
        -- we could maybe optimise this, but its really not a big deal
        local args = arg
        tinsert(args, 1, v)
        tinsert(args, 1, i)
        local res = call(f, args)

        tremove(args, 1); -- it is the same object hence remove it again
        tremove(args, 1);

        if res then
            return res
        end
        i, v = next(t, i)
    end
end

--
-- find index with size on any vars, returns first save with enough size
--
VarsExt.findIndexWithSize = function(size)
    if size < 1 then
        return nil;
    end

    return foreach_ext(VarsExt.Vars, function(i, var, s)
        if var >= s then
            return i
        end
    end, size);
end
--
-- reserve size on save.expects size to be fitting
-- returns offset from 0 on SaveX
VarsExt.reserve = function(save, size)
    local currentSize = VarsExt.Vars[save]
    VarsExt.Vars[save] = currentSize - size
    return VarsExt.MAXSPACE - currentSize;
end

-- main function to occupy part of a save variable, starting from 1 up to 9, ignores occupied save variables.
--
-- return: save "class"-object with save(x) and get() member function, if space is left
--				 nil, if no space is left
VarsExt.create = function(size)
    local index = VarsExt.findIndexWithSize(size);

    if index == nil then
        dbg.stm("VarsExt: SPEICHERVARIABLE NICHT ANGELEGT, VARIABLE UEBERTRAGT MOEGLICHERWEISE DIE GROESSE 9, ODER ES SIND ZU VIELE ANGELEGT")
        return nil
    end
    if size < 1 then
        return nil;
    end
    -- init
    if Vars["Save" .. index] == nil then
        Vars["Save" .. index] = 0
    end
    local offset = VarsExt.reserve(index, size);


    -- highest number of 10^size -1
    local maxnum = 1;
    do
        local i = size;
        while i > 0 do
            maxnum = maxnum * 10;
            i = i - 1
        end
        maxnum = maxnum - 1;
    end

    -- create "class" object
    local myVar = {
        i = index,
        off = offset,
        size = size,
        maxnum = maxnum
    };
    myVar.save = VarsExt.save;
    myVar.get = VarsExt.get;
    return myVar;
end

-- in case you are using a Vars.Save on your own, you can state here that it will not be used. THIS ACTION CANNOT BE REVERSED (since scripts are hard coded.);
VarsExt.occupy = function(save)
    if VarsExt.Vars[save] > 0 then
        -- 0 or -1 or -0 ?
        VarsExt.Vars[save] = -1;
    end
end

-----------------------------------------------
-----------------------------------------------
-----------------------------------------------
----Ab hier beginnt das eigentliche Script ----
-----------------------------------------------
-----------------------------------------------
-----------------------------------------------
---
---

--- Vars.Save8 und Vars.Save9 werden reserviert, da sie in Funktionen genutzt werden. Möchtet ihr die Vars Variablen verwenden und nicht das VarsExt Framework, müsst ihr diese hier
--- reservieren.
VarsExt.occupy(8)
VarsExt.occupy(9)

--- So solltet ihr Variablen setzten, die ihr nach dem Laden noch braucht. Das VarsExt hat die Limitierung auf nur 9 Variablen um ein vielfaches erhöht.
pointsPlayer1 = VarsExt.create(5);
pointsPlayer2 = VarsExt.create(5);
pointsPlayer3 = VarsExt.create(5);
pointsPlayer4 = VarsExt.create(5);
pointsPlayer5 = VarsExt.create(5);
pointsPlayer6 = VarsExt.create(5);

amountPlayers = VarsExt.create(1);


function new_game()
    request_event(doActionsAfterMinutes, Events.FIVE_TICKS)
    request_event(initGame, Events.FIRST_TICK_OF_NEW_OR_LOADED_GAME)
    MinuteEvents.new_game()
    request_event(checkFinish, Events.VICTORY_CONDITION_CHECK)
    dbg.stm("Herzlich willkommen zu TrainYourEco. Ziel der Karte ist es, möglichst viele Punkte innerhalb von ".. getEndTime() .." Minuten zu bekommen. Diese könnt ihr durch Opfergaben bekommen. Geopfert werden können entweder Soldaten an der Opferstelle oder Gegenstände im Lager unterhalb eures Startturms. Viel Spaß und happy building :-)")
    pointsPlayer1:save(0)
    pointsPlayer2:save(0)
    pointsPlayer3:save(0)
    pointsPlayer4:save(0)
    pointsPlayer5:save(0)
    pointsPlayer6:save(0)
    amountPlayers:save(0)
end

function register_functions()
    reg_func(doActionsAfterMinutes)
    reg_func(initGame)
    reg_func(checkFinish)
    MinuteEvents.register_functions()
end

players = {
    p1 = {
        storeX = 311,
        storeY = 941,
        searchX = 313,
        searchY = 944,
        sacX = 237,
        sacY = 803,
        id = 1
    },
    p2 = {
        storeX = 570,
        storeY = 935,
        searchX = 571,
        searchY = 937,
        sacX = 501,
        sacY = 802,
        id = 2
    },
    p3 = {
        storeX = 816,
        storeY = 936,
        searchX = 818,
        searchY = 938,
        sacX = 748,
        sacY = 802,
        id = 3
    },
    p4 = {
        storeX = 321,
        storeY = 459,
        searchX = 323,
        searchY = 462,
        sacX = 253,
        sacY = 327,
        id = 4
    },
    p5 = {
        storeX = 577,
        storeY = 464,
        searchX = 579,
        searchY = 466,
        sacX = 507,
        sacY = 332,
        id = 5
    },
    p6 = {
        storeX = 820,
        storeY = 465,
        searchX = 822,
        searchY = 467,
        sacX = 751,
        sacY = 335,
        id = 6
    }
}

--- Ein Debug schalter. Habe damit bei der Entwicklung gute Erfahrungen gemacht.
function isDebug()
    return TRUE;
end


--- Hier kommen Initialisierungen hin, die bei start oder laden ausgefuehrt werden sollen
function initGame()
    if isDebug() == TRUE then
        Tutorial.RWM(1)
        dbgTestFunction()
    else
        dbg.aioff(1)
        dbg.aioff(2)
        dbg.aioff(3)
        dbg.aioff(4)
        dbg.aioff(5)
        dbg.aioff(6)
    end

    addStorageAreForPlayer(players.p1)
    addStorageAreForPlayer(players.p2)
    addStorageAreForPlayer(players.p3)
    addStorageAreForPlayer(players.p4)
    addStorageAreForPlayer(players.p5)
    addStorageAreForPlayer(players.p6)

    local calculates = 6
    while calculates <= (getEndTime() -2) do
        requestMinuteEvent(calculateGoodsForPlayers, calculates)
        calculates = calculates + 2
    end

    local statisticTime = 10
    while statisticTime <= (getEndTime() -5) do
        requestMinuteEvent(printStatistic, statisticTime)
        statisticTime = statisticTime + 5
    end

    requestMinuteEvent(speedUpMsg, getEndTime() - 10)
end

function speedUpMsg()
    dbg.stm("Die letzten 10 Minuten sind angebrochen. Gebt nochmal Gas!")
end

function getEndTime()
    return 70
end

function checkFinish()
    Game.DefaultPlayersLostCheck()
    if Game.Time() >= getEndTime() then
        Game.EnemyPlayersLost(leadPlayer.id)
        finishGame()
    end
    Game.DefaultGameEndCheck()
end

function addStorageAreForPlayer(player)
    Buildings.AddBuilding(player.storeX, player.storeY, player.id, Buildings.STORAGEAREA)
end

function dbgTestFunction()
    -- Hier könnt ihr code zum Testen hinschreiben.
    dbg.stm("dbug Script geht ")
end

function doActionsAfterMinutes()
    --wird jede Minute ausgefuehrt
    if newMinute() == 1 then
        --dbg.stm("wieder eine Minute rum")
    end
end

function calculateGoodsForPlayers()

    setNewPointsAmount(pointsPlayer1, players.p1)
    setNewPointsAmount(pointsPlayer2, players.p2)
    setNewPointsAmount(pointsPlayer3, players.p3)
    setNewPointsAmount(pointsPlayer4, players.p4)
    setNewPointsAmount(pointsPlayer5, players.p5)
    setNewPointsAmount(pointsPlayer6, players.p6)


    --Anzahl Spieler ermitteln
    updateAmountPlayers()
    --fuehrenden Spieler updaten
    updateLead()

    if isDebug() == TRUE then
        --dbg.stm("Partie mit " .. amountPlayers:get() .. " Spielern" )
    end

end

function setNewPointsAmount(pointsVar, player)
    local pointsForCalculation = 0
    pointsForCalculation = calculatePointsForStorageArea(player) + calcPointsForSacPlace(player)
    pointsVar:save(pointsVar:get() + pointsForCalculation)
    if Game.LocalPlayer() == player.id and pointsForCalculation > 0 then
        dbg.stm("Du hast durch dein Opfer " .. pointsForCalculation .. " Punkte erhalten!")
    end
end

function updateAmountPlayers()
    local calcAmountOfPlayers = 0
    if pointsPlayer1:get() > 0 then
        calcAmountOfPlayers = calcAmountOfPlayers + 1
    end
    if pointsPlayer2:get() > 0 then
        calcAmountOfPlayers = calcAmountOfPlayers + 1
    end
    if pointsPlayer3:get() > 0 then
        calcAmountOfPlayers = calcAmountOfPlayers + 1
    end
    if pointsPlayer4:get() > 0 then
        calcAmountOfPlayers = calcAmountOfPlayers + 1
    end
    if pointsPlayer5:get() > 0 then
        calcAmountOfPlayers = calcAmountOfPlayers + 1
    end
    if pointsPlayer6:get() > 0 then
        calcAmountOfPlayers = calcAmountOfPlayers + 1
    end
    amountPlayers:save(calcAmountOfPlayers)

end

function printStatistic()
    if amountPlayers:get() > 0 then
        dbg.stm("Aktueller Punktestand:")
        local msg = msgPointsOnePlayer(1,pointsPlayer1:get(), "", " / ")
        msg = msg .. msgPointsOnePlayer(2,pointsPlayer2:get(), "", " / ")
        msg = msg .. msgPointsOnePlayer(3,pointsPlayer3:get(), "", " / ")
        msg = msg .. msgPointsOnePlayer(4,pointsPlayer4:get(), "", " / ")
        msg = msg .. msgPointsOnePlayer(5,pointsPlayer5:get(), "", " / ")
        msg = msg .. msgPointsOnePlayer(6,pointsPlayer6:get(), "", " / ")
        msg = strsub(msg, 1 ,-3)

        --local msg = "Spieler 1(" .. getTextForPlayerRace(1) .. "): " .. pointsPlayer1:get()
        --if amountPlayers:get() > 1 then
        --    msg = msg  .. " / " .. "Spieler 2(" .. getTextForPlayerRace(2) .. "): " .. pointsPlayer2:get() .. " / "
        --    msg = msg .. "Spieler 3(" .. getTextForPlayerRace(3) .. "): " .. pointsPlayer3:get() .. " / "
        --    msg = msg .. "Spieler 4(" .. getTextForPlayerRace(4) .. "): " .. pointsPlayer4:get() .. " / "
        --    msg = msg .. "Spieler 5(" .. getTextForPlayerRace(5) .. "): " .. pointsPlayer5:get() .. " / "
        --    msg = msg .. "Spieler 6(" .. getTextForPlayerRace(6) .. "): " .. pointsPlayer6:get()
        --end

        dbg.stm(msg)

    end

    if amountPlayers:get() > 1 and Game.Time() <= (getEndTime() -5) then
        printActualLead()
    end

end

function msgPointsOnePlayer(playerId, points, addInfront, addEnd)
    if points > 0 then
        return addInfront .. "Spieler " .. playerId .. "(" .. getTextForPlayerRace(playerId) .. "): " .. points .. addEnd
    else
        return ""
    end
end

leadPlayer = {
    id = 0,
    points = 0
}

function printActualLead()

    dbg.stm("Aktueller führend: Spieler " .. leadPlayer.id .. "(".. getTextForPlayerRace(leadPlayer.id) .. ") mit " .. leadPlayer.points .. " Punkten" )

end

function updateLead()

    local leadId = 1;
    local leadPoints =  pointsPlayer1:get()

    if pointsPlayer2:get() > leadPoints then
        leadId = 2
        leadPoints =  pointsPlayer2:get()
    end

    if pointsPlayer3:get() > leadPoints then
        leadId = 3
        leadPoints =  pointsPlayer3:get()
    end
    if pointsPlayer4:get() > leadPoints then
        leadId = 4
        leadPoints =  pointsPlayer4:get()
    end

    if pointsPlayer5:get() > leadPoints then
        leadId = 5
        leadPoints =  pointsPlayer5:get()
    end

    if pointsPlayer6:get() > leadPoints then
        leadId = 6
		leadPoints =  pointsPlayer6:get()
    end

    leadPlayer.id = leadId
    leadPlayer.points = leadPoints

end

function finishGame()
    calculateGoodsForPlayers()
    updateLead()
    printStatistic()
    dbg.stm("### Das Spiel ist zu Ende ###")
    if amountPlayers:get() > 1 then
        dbg.stm("### Spieler ".. leadPlayer.id .. " hat gewonnen. Er hat als ".. getTextForPlayerRace(leadPlayer.id) .. " " .. leadPlayer.points .. " Punkte erreicht! ###")
    else
        dbg.stm("### Du hast als ".. getTextForPlayerRace(leadPlayer.id) .. " " .. leadPlayer.points .. " Punkte erreicht! ###")
    end

end

items10Points = { Goods.BOW, Goods.SWORD,  Goods.BATTLEAXE, Goods.BACKPACKCATAPULT,   Goods.ARMOR ,  Goods.BLOWGUN}
items7Points = { Goods.IRONBAR,  Goods.GOLDBAR}
items3Points = { Goods.WINE, Goods.TEQUILA, Goods.SUNFLOWEROIL, Goods.MEAD, Goods.GOLDORE, Goods.IRONORE ,Goods.COAL }

function calculatePointsForStorageArea(player)
    local searchRadius = 5
    local points = 0
    local goodId = 1
    --IDs der Gebaeude gehen von 1 - 83
    while goodId <= 43 do
        local amountOfGoods = Goods.GetAmountInArea(player.id, goodId,player.searchX, player.searchY, searchRadius )
        if amountOfGoods > 0 then
            if isValueInArray(items10Points, goodId)  == TRUE then
                if isDebug() == TRUE then
                    dbg.stm(amountOfGoods .. " mal 10 Punkte")
                end
                points = points + amountOfGoods * 10
            elseif isValueInArray(items7Points, goodId)  == TRUE then
                if isDebug() == TRUE then
                    dbg.stm(amountOfGoods .. " mal 7 Punkte")
                end
                points = points + amountOfGoods * 7
            elseif isValueInArray(items3Points, goodId)  == TRUE then
                if isDebug() == TRUE then
                    dbg.stm(amountOfGoods .. " mal 3 Punkte")
                end
                points = points + amountOfGoods * 3
            else
                if isDebug() == TRUE then
                    dbg.stm(amountOfGoods .. " mal 2 Punkte")
                end
                points = points + amountOfGoods * 2
            end
            Goods.Delete(player.searchX, player.searchY ,searchRadius , goodId)
        end
        goodId = goodId + 1
    end
    return points
end


units30Points = { Settlers.SWORDSMAN_03, Settlers.BOWMAN_03, Settlers.AXEWARRIOR_03, Settlers.BLOWGUNWARRIOR_03, Settlers.BACKPACKCATAPULIST_03, Settlers.MEDIC_03 }
units20Points = { Settlers.SWORDSMAN_02, Settlers.BOWMAN_02, Settlers.AXEWARRIOR_02, Settlers.BLOWGUNWARRIOR_02, Settlers.BACKPACKCATAPULIST_02, Settlers.MEDIC_02 }
units12Points = { Settlers.SWORDSMAN_01,Settlers.BOWMAN_01,Settlers.AXEWARRIOR_01,Settlers.BLOWGUNWARRIOR_01,Settlers.BACKPACKCATAPULIST_01, Settlers.MEDIC_01  }


function calcPointsForSacPlace(player)

    local points = 0


    points = points + getPointsForUnits(player, units30Points, 30)
    points = points + getPointsForUnits(player, units20Points, 20)
    points = points + getPointsForUnits(player, units12Points, 12)
    points = points + getPointsForUnits(player, { Settlers.SQUADLEADER }, 46)

    return points



end

function getPointsForUnits(player, unitArray, unitPoints)

    local points = 0
    local counter = 1
    local unitAmount = 0
    while counter <= getn(unitArray) do
        unitAmount = Settlers.AmountInArea(player.id, unitArray[counter], player.sacX, player.sacY, 15)
        if unitAmount > 0 then
            points = points + unitAmount * unitPoints
            if isDebug() == TRUE then
                dbg.stm("Player ".. player.id .. " saced " .. unitAmount .. " Units with " .. unitPoints .. " points. Added " ..  (unitAmount * unitPoints ))
            end
            Settlers.KillSelectableSettlers(player.id, unitArray[counter], player.sacX, player.sacY, 15, 0)
        end
         counter = counter + 1
    end
    return points
end


-------------------------------------------------------------
-------------------------------------------------------------
------ generalUtility  --------------------------------------
-------Diese könnt ihr für eure Scripts nutzen---------------
-------------------------------------------------------------

--- gibt aus einem array von Spielern ("playersTable" mit den IDs der Spielern) die Spieler ID zurück, der am  "enemyPosition" meisten Einheiten hat
---BSP: enemyPosition == 1 --> gibt den Spieler mit den meisten Units zurück
---BSP: enemyPosition == 2 --> gibt den Spieler mit den zweitmeisten Units zurück..
---

TRUE = 1
FALSE = 0

function getPlayerIDWithMostUnitsForPosition(playersTable, enemyPosition)

    local playercache = { 0, 0, 0, 0, 0, 0, 0, 0 }

    local i = 1
    -- setzt an die einzelnen stellen innerhalb des playerchache arrays die Einheitenanzahl etsprechend der spielerId
    -- Bpsp {0,0,0,34,12,43,34,34) --> jetzt waeren die letzten fuenf spieler opponents mit der entsprechenden Anzahl Einheiten
    while i <= getn(playersTable) do
        playercache[playersTable[i]] = getAmountOfPlayerUnitsWithoutBuildings(playersTable[i])
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


function getTextForPlayerRace(playerId)
    local raceId = Game.PlayerRace(playerId)

    if raceId == 0 then
        return "Römer"
    elseif raceId == 1 then
        return "Wikinger"
    elseif raceId == 2 then
        return "Maya"
    elseif raceId == 3 then
        return "Dunkles Volk"
    elseif raceId == 4 then
        return "Trojaner"
    end

end

function isValueInArray(theArray, value)
    local counter = 1
    while counter <= getn(theArray) do
        if theArray[counter] == value then
            return TRUE
        end
        counter = counter + 1
    end
    return FALSE
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

militaryUnits = { Settlers.SWORDSMAN_01, Settlers.SWORDSMAN_02, Settlers.SWORDSMAN_03, Settlers.BOWMAN_01, Settlers.BOWMAN_02, Settlers.BOWMAN_03, Settlers.AXEWARRIOR_01, Settlers.AXEWARRIOR_02, Settlers.AXEWARRIOR_03, Settlers.BLOWGUNWARRIOR_01, Settlers.BLOWGUNWARRIOR_02, Settlers.BLOWGUNWARRIOR_03, Settlers.BACKPACKCATAPULIST_01, Settlers.BACKPACKCATAPULIST_02, Settlers.BACKPACKCATAPULIST_03, Settlers.MEDIC_01, Settlers.MEDIC_02, Settlers.MEDIC_03, Settlers.SQUADLEADER }

function getAmountOfPlayerUnits(playerId)
    local amoutOfMilitary = 0
    local counter = 1
    while counter <= getn(militaryUnits) do
        amoutOfMilitary = amoutOfMilitary + Settlers.Amount(playerId, militaryUnits[counter])
        counter = counter + 1
    end
    return amoutOfMilitary
end

function getUnitsInBuildings(playerId)
    local allUnits = 0
    allUnits = allUnits + Buildings.Amount(playerId, Buildings.GUARDTOWERSMALL, Buildings.READY)
    allUnits = allUnits + Buildings.Amount(playerId, Buildings.GUARDTOWERBIG, Buildings.READY) * 6
    allUnits = allUnits + Buildings.Amount(playerId, Buildings.CASTLE, Buildings.READY) * 8
    return allUnits
end

function getAmountOfPlayerUnitsWithoutBuildings(playerId)
    local allUnitsWithoutBuilding = getAmountOfPlayerUnits(playerId)
    allUnitsWithoutBuilding = allUnitsWithoutBuilding - getUnitsInBuildings(playerId)
    return allUnitsWithoutBuilding
end

function randomBetweenSimple(fromNumber, toNumber)
    local divNumber = toNumber - fromNumber
    local randomNumber = fromNumber + Game.Random(divNumber + 1)
    return randomNumber
end

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

function minNumber(number1, number2)
    if number1 > number2 then
        return number2
    else
        return number1
    end
end

function maxNumber(number1, number2)
    if number1 > number2 then
        return number1
    else
        return number2
    end
end

function floorNumber(floatNumber)
    local stringmyValue = tostring(floatNumber)
    if strfind(stringmyValue, "(%.+)") ~= nil then
        local valuestring = strsub(stringmyValue, 1, strfind(stringmyValue, "(%.+)"))
        return tonumber(valuestring)
    else
        return floatNumber
    end
end


-----------------------------------------------------
--Modul Funktion. Danke an Hippo für dieses Script---
-----------------------------------------------------
-- returns a mod(b). Or a%b in many languages. The remainder of the division a/b--
function mod(a, b)
    if b < 1 or a < 0
    then
        return -1 -- remainder isn’t going to be calculated
    end
    local c = a / b
    local d = strfind("" .. c, "(%.+)")
    if d == nil
    then
        return 0 -- remainder is 0
    end
    c = tonumber(strsub("" .. c, d)) + 0.0000000000005 -- drop everything before . and add a tiny amount
    d = strfind("" .. c * b, "(%.+)")
    if d == nil
    then
        return c * b
    end
    return tonumber(strsub("" .. c * b, 1, d)) -- multiply c with b and drop everything after .
end

----
--LIB fuer Minute Events---
-----

MinuteEvents = {
    -- table of all events at all minutes in format _minuteEventTable[minute][funcid (from 1 - n; no specific meaning)]
    _minuteEventTable = {}
}

-- calls all function types in table
function MinuteEvents._subroutine_foreachFunction(i, v)
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
            foreach(MinuteEvents._minuteEventTable[Vars.Save9], MinuteEvents._subroutine_foreachFunction)
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

