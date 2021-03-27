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
    Buildings.AddBuilding(193, 288, 1, Buildings.GUARDTOWERSMALL)
    Buildings.AddBuilding(162, 288, 1, Buildings.GUARDTOWERSMALL)
    Buildings.AddBuilding(447, 288, 2, Buildings.GUARDTOWERSMALL)
    Buildings.AddBuilding(476, 288, 2, Buildings.GUARDTOWERSMALL)
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

    addGoodsForPlayerRace(1,xP1,yP1)
    addGoodsForPlayerRace(2,xP2,yP2)

end

function addGoodsForPlayerRace(playerId, spawnX, spawnY)

    ---Roemer
    if Game.PlayerRace(playerId) == 0 then
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 4)

        Goods.AddPileEx(spawnX, spawnY, Goods.STONE, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.STONE, 2)

        Goods.AddPileEx(spawnX, spawnY, Goods.LOG, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.LOG, 2)
    end
    ---Wikinger
    if Game.PlayerRace(playerId) == 1 then
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 4)

        Goods.AddPileEx(spawnX, spawnY, Goods.AXE, 6)
        Goods.AddPileEx(spawnX, spawnY, Goods.SAW, 3)

        Goods.AddPileEx(spawnX, spawnY, Goods.LOG, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.LOG, 2)

        Settlers.AddSettlers(spawnX, spawnX,playerId, Settlers.CARRIER, 10)
    end


     ---trojaner
    if Game.PlayerRace(playerId) == 4 then
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)

        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.BOARD, 8)


        Goods.AddPileEx(spawnX, spawnY, Goods.STONE, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.STONE, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.STONE, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.STONE, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.STONE, 8)

        Goods.AddPileEx(spawnX, spawnY, Goods.STONE, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.STONE, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.STONE, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.STONE, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.STONE, 8)


        Goods.AddPileEx(spawnX, spawnY, Goods.LOG, 8)
        Goods.AddPileEx(spawnX, spawnY, Goods.LOG, 2)

        Goods.AddPileEx(spawnX, spawnY, Goods.AXE, 7)
        Goods.AddPileEx(spawnX, spawnY, Goods.SAW, 3)

        Settlers.AddSettlers(spawnX, spawnY, playerId, Settlers.CARRIER, 10)

    end
end


--- Ein Debug schalter.
function isDebug()
    return FALSE;
end


function initGame()


    local i,v = next(spectator,nil)
    local localPlayer = Game.LocalPlayer();
    while i do
        if localPlayer == v then
            Tutorial.RWM(1);
        end
        i,v = next(spectator,i);
    end

    dbg.stm("~~~Welcome to the Settlers IV WM 2021~~~")
    dbg.stm("PeaceTime: " .. getPeaceTime() .. " Min. Thieves are allowed and may steal. Sabotours after peacetime. ")
    dbg.stm("The northern path opens at min " .. getPeaceTime() - 1 .. " and the southern path at min " .. getPeaceTime() - 2 .. ".")
    dbg.stm("Have fun und good luck!")



    requestMinuteEvent(topOpen, getPeaceTime() -1)
    requestMinuteEvent(bottomOpen, getPeaceTime() -2)
    requestMinuteEvent(peaceTimeOver, getPeaceTime())

end





function bottomOpen()
    dbg.stm("The southern path is now passable...")
end

function topOpen()
    dbg.stm("The northern path is now passable...")
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
    local playerOffenceFightingStrength = Game.GetOffenceFightingStrength(playerId)
    local playerMagic = Magic.CurrentManaAmount(playerId)
    local playerSABOTEUR = Settlers.Amount(playerId,Settlers.SABOTEUR)
    local playerTHIEF = Settlers.Amount(playerId,Settlers.THIEF)

    if Game.LocalPlayer() >= 3 then
        dbg.stm("Player " .. playerId .. "(" .. getTextForPlayerRace(playerId) .. "): " .. " Soldiers: " .. getAmountOfPlayerUnits(playerId).. " L3(" .. AmountOfMilitary3 ..  ")" .. " Kills: " .. playerKills .. " Settlers: " .. playerSettlers .. " FightStr: " .. playerOffenceFightingStrength .. " Magic: " .. playerMagic .. " Sabos: " .. playerSABOTEUR .. " Tiefs: " .. playerTHIEF)
    end
end

tickCounter = 0
function killUnits()
    tickCounter = tickCounter + 5
    if tickCounter >= 130 then

        --oben
        if Game.Time() < (getPeaceTime() - 1)  then
            removeUnitsNearPoint(45,185,1,40)
            removeUnitsNearPoint(323,180,2,40)
            removeBoatsNearPoint(127,67,25)
        end

        --unten
        if Game.Time() < (getPeaceTime() - 2)  then
            removeUnitsNearPoint(334,667,1,40)
            removeUnitsNearPoint(624,672,2,40)
            removeBoatsNearPoint(534,770,25)
        end


        --mitte
        if Game.Time() < getPeaceTime() then
            removeUnitsNearPoint(438,617,1,30)
            removeUnitsNearPoint(418,579,1,30)
            removeUnitsNearPoint(390,527,1,30)
            removeUnitsNearPoint(378,501,1,30)

            removeUnitsNearPoint(467,617,2,30)
            removeUnitsNearPoint(449,581,2,30)
            removeUnitsNearPoint(424,528,2,30)
            removeUnitsNearPoint(412,503,2,30)

        end
        tickCounter = 1
    end
end


function removeBoatsNearPoint(x, y, radius)

    local ships = { Vehicles.WARSHIP, Vehicles.FERRY}
    local index = 1

    --IDs der Gebaeude gehen von 1 - 83
    while index <= getn(ships) do
        if Vehicles.AmountInArea(1, ships[index], x, y, radius) > 0 then
            Vehicles.KillVehicles(1, ships[index], x, y, radius)
            dbg.stm("A flash of lightning at Player 1, zzzzzschhhhh. Your ships are dying and you hear a penetrating voice... YOU SHALL NOT PASS!!")
        end
        if Vehicles.AmountInArea(2, ships[index], x, y, radius) > 0 then
            Vehicles.KillVehicles(2, ships[index], x, y, radius)
            dbg.stm("A flash of lightning at Player 2, zzzzzschhhhh. Your ships are dying and you hear a penetrating voice... YOU SHALL NOT PASS!!")
        end
        index = index +  1
    end
end

function removeUnitsNearPoint(x, y, playerId, radius)
    local specialists = {Settlers.PIONEER,Settlers.SABOTEUR,Settlers.GEOLOGIST,Settlers.GARDENER, Settlers.SWORDSMAN_01, Settlers.SWORDSMAN_02, Settlers.SWORDSMAN_03, Settlers.BOWMAN_01, Settlers.BOWMAN_02, Settlers.BOWMAN_03, Settlers.AXEWARRIOR_01, Settlers.AXEWARRIOR_02, Settlers.AXEWARRIOR_03, Settlers.BLOWGUNWARRIOR_01, Settlers.BLOWGUNWARRIOR_02, Settlers.BLOWGUNWARRIOR_03, Settlers.BACKPACKCATAPULIST_01, Settlers.BACKPACKCATAPULIST_02, Settlers.BACKPACKCATAPULIST_03, Settlers.MEDIC_01, Settlers.MEDIC_02, Settlers.MEDIC_03, Settlers.SQUADLEADER}
    local index = 1

    --IDs der Gebaeude gehen von 1 - 83
    while index <= getn(specialists) do
        if Settlers.AmountInArea(playerId, specialists[index], x, y, radius) > 0 then
            Settlers.KillSelectableSettlers(playerId, specialists[index], x, y, radius, 0)
            dbg.stm("A flash of lightning at Player " .. playerId .. ", zzzzzschhhhh. Your units are dying and you hear a penetrating voice... YOU SHALL NOT PASS!!")
        end
        index = index +  1
    end
end

function peaceTimeOver()
    dbg.stm("--------------------")
    dbg.stm("Let the battle begin! The peace time in the mid is now over!!")
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
