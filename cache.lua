
-----------------------------------------------
-----------------------------------------------
----Script fuer die Siedler 4 WM 2021----------
-----------------HAVE FUN ---------------------
-----------------~sl4ng3r~---------------------
-----------------------------------------------

spectator = { 3,4 }

function new_game()
    request_event(doActionsAfterMinutes, Events.FIVE_TICKS)
    request_event(initGame, Events.FIRST_TICK_OF_NEW_OR_LOADED_GAME)
    request_event(winCondition, Events.VICTORY_CONDITION_CHECK)
    request_event(killUnits, Events.FIVE_TICKS)
    MinuteEvents.new_game()
    preparePlayers()
    addGoods()
end

function register_functions()
    reg_func(doActionsAfterMinutes)
    reg_func(initGame)
    reg_func(winCondition)
    reg_func(killUnits)

    MinuteEvents.register_functions()
end

function preparePlayers()
    Buildings.AddBuilding(190, 288, 1, Buildings.GUARDTOWERSMALL)
    Buildings.AddBuilding(160, 288, 1, Buildings.GUARDTOWERSMALL)
    Buildings.AddBuilding(440, 288, 2, Buildings.GUARDTOWERSMALL)
    Buildings.AddBuilding(470, 288, 2, Buildings.GUARDTOWERSMALL)
end

function winCondition()
    ---killSpecators
    Game.DefaultPlayersLostCheck()
    if Game.HasPlayerLost(1) == 1 then
        Game.PlayerLost(3)
        Game.PlayerLost(4)
    end
    if Game.HasPlayerLost(2) == 1 then
        Game.PlayerLost(3)
        Game.PlayerLost(4)
    end
    Game.DefaultGameEndCheck()
end


function addGoods()
    local xP1 = 200
    local yP1 = 345

    local xP2 = 487
    local yP2 = 345

    ---roemer
    if Game.PlayerRace(1) == 0 then
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 4)
        Goods.AddPileEx(xP1, yP1, Goods.LOG, 8)
        Goods.AddPileEx(xP1, yP1, Goods.LOG, 2)
    end
    ---Wikinger
    if Game.PlayerRace(1) == 1 then
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 4)
        Goods.AddPileEx(xP1, yP1, Goods.AXE, 6)
        Goods.AddPileEx(xP1, yP1, Goods.SAW, 3)
    end
    ---trojaner
    if Game.PlayerRace(1) == 4 then
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)

        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)

        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
		Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
		Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)
        Goods.AddPileEx(xP1, yP1, Goods.BOARD, 8)

        Goods.AddPileEx(xP1, yP1, Goods.STONE, 8)
        Goods.AddPileEx(xP1, yP1, Goods.STONE, 8)
        Goods.AddPileEx(xP1, yP1, Goods.STONE, 8)
        Goods.AddPileEx(xP1, yP1, Goods.STONE, 8)
        Goods.AddPileEx(xP1, yP1, Goods.STONE, 8)

        Goods.AddPileEx(xP1, yP1, Goods.STONE, 8)
        Goods.AddPileEx(xP1, yP1, Goods.STONE, 8)
        Goods.AddPileEx(xP1, yP1, Goods.STONE, 8)
        Goods.AddPileEx(xP1, yP1, Goods.STONE, 8)
        Goods.AddPileEx(xP1, yP1, Goods.STONE, 8)

        Goods.AddPileEx(xP1, yP1, Goods.STONE, 8)
        Goods.AddPileEx(xP1, yP1, Goods.STONE, 8)
        Goods.AddPileEx(xP1, yP1, Goods.STONE, 8)
        Goods.AddPileEx(xP1, yP1, Goods.STONE, 8)
        Goods.AddPileEx(xP1, yP1, Goods.STONE, 8)

        Goods.AddPileEx(xP1, yP1, Goods.AXE, 7)
        Goods.AddPileEx(xP1, yP1, Goods.SAW, 3)
        Goods.AddPileEx(xP1, yP1, Goods.SCYTHE, 3)
        Goods.AddPileEx(xP1, yP1, Goods.ROD, 2)
		Goods.AddPileEx(xP1, yP1, Goods.HAMMER,  8)
		Goods.AddPileEx(xP1, yP1, Goods.HAMMER,  8)
		Goods.AddPileEx(xP1, yP1, Goods.SHOVEL,  8)
		Goods.AddPileEx(xP1, yP1, Goods.BREAD,  8)
	Goods.AddPileEx(xP1, yP1, Goods.BREAD,  8)
	Goods.AddPileEx(xP1, yP1, Goods.MEAT,  8)
	Goods.AddPileEx(xP1, yP1, Goods.MEAT,  8)
	Settlers.AddSettlers(xP1, yP1, 1, Settlers.CARRIER, 10)

    end

    ----Player 2

    ---roemer
    if Game.PlayerRace(2) == 0 then
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 4)
        Goods.AddPileEx(xP2, yP2, Goods.LOG, 8)
        Goods.AddPileEx(xP2, yP2, Goods.LOG, 2)
    end
    ---Wikinger
    if Game.PlayerRace(2) == 1 then
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 4)
        Goods.AddPileEx(xP2, yP2, Goods.AXE, 6)
        Goods.AddPileEx(xP2, yP2, Goods.SAW, 3)
    end
    ---trojaner
    if Game.PlayerRace(2) == 4 then
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)

        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)

        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
		Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
		Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)
        Goods.AddPileEx(xP2, yP2, Goods.BOARD, 8)

        Goods.AddPileEx(xP2, yP2, Goods.STONE, 8)
        Goods.AddPileEx(xP2, yP2, Goods.STONE, 8)
        Goods.AddPileEx(xP2, yP2, Goods.STONE, 8)
        Goods.AddPileEx(xP2, yP2, Goods.STONE, 8)
        Goods.AddPileEx(xP2, yP2, Goods.STONE, 8)

        Goods.AddPileEx(xP2, yP2, Goods.STONE, 8)
        Goods.AddPileEx(xP2, yP2, Goods.STONE, 8)
        Goods.AddPileEx(xP2, yP2, Goods.STONE, 8)
        Goods.AddPileEx(xP2, yP2, Goods.STONE, 8)
        Goods.AddPileEx(xP2, yP2, Goods.STONE, 8)

        Goods.AddPileEx(xP2, yP2, Goods.STONE, 8)
        Goods.AddPileEx(xP2, yP2, Goods.STONE, 8)
        Goods.AddPileEx(xP2, yP2, Goods.STONE, 8)
        Goods.AddPileEx(xP2, yP2, Goods.STONE, 8)
        Goods.AddPileEx(xP2, yP2, Goods.STONE, 8)

        Goods.AddPileEx(xP2, yP2, Goods.AXE, 7)
        Goods.AddPileEx(xP2, yP2, Goods.SAW, 3)
        Goods.AddPileEx(xP2, yP2, Goods.SCYTHE, 3)
        Goods.AddPileEx(xP2, yP2, Goods.ROD, 2)
		Goods.AddPileEx(xP2, yP2, Goods.HAMMER,  8)
		Goods.AddPileEx(xP2, yP2, Goods.HAMMER,  8)
		Goods.AddPileEx(xP2, yP2, Goods.SHOVEL,  8)
		Goods.AddPileEx(xP2, yP2, Goods.BREAD,  8)
		Goods.AddPileEx(xP2, yP2, Goods.BREAD,  8)
		Goods.AddPileEx(xP2, yP2, Goods.MEAT,  8)
		Goods.AddPileEx(xP2, yP2, Goods.MEAT,  8)
		Settlers.AddSettlers(xP2, yP2, 2, Settlers.CARRIER, 10)

    end



end


--- Ein Debug schalter. Habe damit bei der Entwicklung gute Erfahrungen gemacht.
function isDebug()
    return TRUE;
end



--- Hier kommen Initialisierungen hin, die bei start oder laden ausgefuehrt werden sollen
function initGame()

    local i,v = next(spectator,nil)
    local localPlayer = Game.LocalPlayer();
    while i do
        if localPlayer == v then
            Tutorial.RWM(1);
        end
        i,v = next(spectator,i);
    end

    dbg.stm("The Settlers IV WM 2021")
    dbg.stm("PeaceTime: 40 Min. Thieves are allowed and may steal and Sabotours are allowed from 40 minutes")
    dbg.stm("Have fun und good luck!  ~sl4ng3r~ ")

    --Buildings.Delete(Buildings.GetFirstBuilding(3, 46),2)
    --Buildings.Delete(Buildings.GetFirstBuilding(4, 46),2)

    if isDebug() == TRUE then
        ---Deckt die Karte auf
        Tutorial.RWM(1)
        requestMinuteEvent(peaceTimeOver, getPeaceTime())
        Settlers.AddSettlers(496, 342, 2, Settlers.SWORDSMAN_03, 70)
        Settlers.AddSettlers(203, 342, 1, Settlers.SWORDSMAN_03, 70)
    end

end

function getPeaceTime()
    return 40
end

function doActionsAfterMinutes()
    --wird jede Minute ausgefuehrt
    if newMinute() == 1 then
        if Game.LocalPlayer() >= 3 then
            dbg.stm("Statistik für Minute "..Game.Time())
        end
        printMsgForPlayer(1)
        printMsgForPlayer(2)
    end

end

function printMsgForPlayer(playerId)
   -- local AmountOfMilitary =  Settlers.Amount(playerId, Settlers.SWORDSMAN_01) +  Settlers.Amount(playerId, Settlers.SWORDSMAN_02) + Settlers.Amount(playerId, Settlers.SWORDSMAN_03) + Settlers.Amount(playerId, Settlers.BOWMAN_01) +  Settlers.Amount(playerId, Settlers.BOWMAN_02) + Settlers.Amount(playerId, Settlers.BOWMAN_03)+ Settlers.Amount(playerId, Settlers.AXEWARRIOR_01) + Settlers.Amount(playerId, Settlers.AXEWARRIOR_02) + Settlers.Amount(playerId, Settlers.AXEWARRIOR_03) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_01) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_02) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_03) +Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_01)	+ Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_02) + Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_03)  + Settlers.Amount(playerId, Settlers.MEDIC_01) + Settlers.Amount(playerId, Settlers.MEDIC_02) + Settlers.Amount(playerId, Settlers.MEDIC_03) + Settlers.Amount(playerId, Settlers.SQUADLEADER)
    local AmountOfMilitary3 =  Settlers.Amount(playerId, Settlers.SWORDSMAN_03) +  Settlers.Amount(playerId, Settlers.BOWMAN_03) +Settlers.Amount(playerId, Settlers.AXEWARRIOR_03) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_03)  + Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_03)  + Settlers.Amount(playerId, Settlers.MEDIC_03) + Settlers.Amount(playerId, Settlers.SQUADLEADER)
    local playerKills= Statistic.UnitsDestroyed(playerId)
    local playerSettlers = Settlers.Amount(playerId, Settlers.CARRIER)

    if Game.LocalPlayer() >= 3 then
        dbg.stm("Player " .. playerId .. ": " .. " Soldiers: " .. getAmountOfPlayerUnits(playerId).. " L3(" .. AmountOfMilitary3 ..  ")" .. " Kills: " .. playerKills .. " Settlers: " .. playerSettlers)
    end
end

tickCounter = 0
function killUnits()
    if Game.Time() < getPeaceTime() then
        tickCounter = tickCounter + 5
        if tickCounter >= 200 then
            removeUnitsNearPoint(330,661,1,40)
            removeUnitsNearPoint(42,180,1,40)

            removeUnitsNearPoint(622,668,2,40)
            removeUnitsNearPoint(322,174,2,40)
            ---mitte
           ---removeUnitsNearPoint(363,543,1,40)
            ---removeUnitsNearPoint(462,545,2,40)

            tickCounter = 1
        end
    end
end


function removeUnitsNearPoint(x, y, playerId, radius)
    local specialists = {Settlers.PIONEER,Settlers.SABOTEUR,Settlers.GEOLOGIST,Settlers.GARDENER, Settlers.SWORDSMAN_01, Settlers.SWORDSMAN_02, Settlers.SWORDSMAN_03, Settlers.BOWMAN_01, Settlers.BOWMAN_02, Settlers.BOWMAN_03, Settlers.AXEWARRIOR_01, Settlers.AXEWARRIOR_02, Settlers.AXEWARRIOR_03, Settlers.BLOWGUNWARRIOR_01, Settlers.BLOWGUNWARRIOR_02, Settlers.BLOWGUNWARRIOR_03, Settlers.BACKPACKCATAPULIST_01, Settlers.BACKPACKCATAPULIST_02, Settlers.BACKPACKCATAPULIST_03, Settlers.MEDIC_01, Settlers.MEDIC_02, Settlers.MEDIC_03, Settlers.SQUADLEADER}
    local index = 1

    --IDs der Gebaeude gehen von 1 - 83
    while index <= getn(specialists) do
        if Settlers.AmountInArea(playerId, specialists[index], x, y, radius) > 0 then
            Settlers.KillSelectableSettlers(playerId, specialists[index], x, y, radius, 0)
            dbg.stm("Ein greller Blitz, zzzzzschhhhh. Deine Einheiten sterben... Du hörst eine Stimme... Du kannst diese Passage erst ab Minute " .. getPeaceTime() .. " durchqueren")
        end
        index = index +  1
    end
end

function peaceTimeOver()
    dbg.stm("--------------------")
    dbg.stm("Möge die Schlacht beginnen! Die PeaceTime (PT) ist vorbei!")
    dbg.stm("--------------------")
end

-------------------------------------------------------------
-------------------------------------------------------------
------ generalUtility  --------------------------------------
-------Diese könnt ihr für eure Scripts nutzen---------------
-------------------------------------------------------------

TRUE = 1
FALSE = 0


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