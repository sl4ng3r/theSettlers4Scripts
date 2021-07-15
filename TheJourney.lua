----SCRIPT zum erhöhen der Speichermöglichkeiten ------------
----(Da sonst begrenzt auf die 9 Vars.Save Variablen)--------
----Danke an MuffinMario für dieses göttliche Script!!-------

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

VarsExt.occupy = function(save)
    if VarsExt.Vars[save] > 0 then
        -- 0 or -1 or -0 ?
        VarsExt.Vars[save] = -1;
    end
end

-----------------------------------------------
----Ab hier beginnt das eigentliche Script ----
-----------------------------------------------

function new_game()
    request_event(initGame, Events.FIRST_TICK_OF_NEW_OR_LOADED_GAME)
    request_event(continuousCheck, Events.FIVE_TICKS)
    request_event(continuousCheckSlow, Events.FIVE_TICKS)
    MinuteEvents.new_game()
end

function register_functions()
    reg_func(initGame)
    reg_func(continuousCheck)
    reg_func(continuousCheckSlow)
    MinuteEvents.register_functions()
end

--- Ein Debug schalter. Habe damit bei der Entwicklung gute Erfahrungen gemacht.
function isDebug()
    return TRUE;
end

humans = { 1, 2, 3, 4, 5 }
activePlayers = {}



islands= {
    {
        startX=120,
        startY=254,
        functionToStartIsland=startIsland1
    },
    {
        startX=120,
        startY=254,
        functionToStartIsland=startIsland2
    }

}

islandCount = getn(islands)

finalIsland = {
    startX=806,
    startY=935,
    functionToStartIsland=startFinalIsland
}

--- reservieren.
VarsExt.occupy(8)
VarsExt.occupy(9)

---INITS----
gameStarted = VarsExt.create(1);
amountOfIslands = VarsExt.create(2);


player1Active = VarsExt.create(1);
player2Active = VarsExt.create(1);
player3Active = VarsExt.create(1);
player4Active = VarsExt.create(1);
player5Active = VarsExt.create(1);

binaryActiveIslands = VarsExt.create(9);


--- Hier kommen Initialisierungen hin, die bei start oder laden ausgefuehrt werden sollen
function initGame()

    Map.SetScreenPos(990, 982)



    updateActivePlayers()
    addAndRemoveSmallTower(954, 979, 1)
    addAndRemoveSmallTower(994, 982, 1)


    if Game.Time() < 2 then
        gameStarted:save(0)
        amountOfIslands:save(0)
        player1Active:save(0)
        player2Active:save(0)
        player3Active:save(0)
        player4Active:save(0)
        player5Active:save(0)
        binaryActiveIslands:save(0)
    end

    dbg.stm("Inseln " .. tostring(islandCount))

    local counter = 1
    while counter <= islandCount do
        local bitNumber = set_bit(binaryActiveIslands:get(),counter,1)
        binaryActiveIslands:save(bitNumber)
        counter = counter + 1
    end




    if isDebug() == TRUE then
        ---Deckt die Karte auf
        ---Tutorial.RWM(1)
        addPlayer(1)
        dbg.stm("Binarary Islands: " .. binaryActiveIslands:get())
        local availableIslands = getAvailableIslands()
        local numberOfIsland = getRandomNumberOfNumbers(availableIslands)
        dbg.print("selected island" .. numberOfIsland)



        requestMinuteEvent(funktionNach5Minuten, 5)
    end

end

function startGame()
    gameStarted:save(1)
    dbg.stm("Spiel wurde gestartet!!")
    chooseNewIsland()

    if isDebug() == TRUE then
        local players = ""
        local counter = 1
        while counter <= getn(activePlayers) do
            players = players .. activePlayers[counter] .. " "
            counter = counter + 1
        end
        dbg.stm("Aktive Spieler: " .. players .. " / Inseln: " ..  amountOfIslands:get() )

    end

end



function dbgTestFunction()
    -- Hier könnt ihr code zum Testen hinschreiben.
    dbg.stm("dbug Script geht ")
end



function funktionNach5Minuten()
    dbg.stm("nach 5 Minuten")
end


continuousTickCounter = 1;
function continuousCheck()
    continuousTickCounter = continuousTickCounter + 1
    if continuousTickCounter >= 30 then

        if newMinute() == 1 then
            if isDebug() == TRUE then
                local availableIslands = getAvailableIslands()
                dbg.stm("aktive Inseln " .. getn(availableIslands))
                local numberOfIsland = getRandomNumberOfNumbers(availableIslands)
                dbg.print("selected island" .. numberOfIsland)
            end
        end

        continuousTickCounter = 1
    end
end

continuousTickCounterSlow = 1;
function continuousCheckSlow()
    continuousTickCounterSlow = continuousTickCounterSlow + 1
    if continuousTickCounterSlow >= 60 then
        checkAddPlayer()
        checkAddIsland()
        continuousTickCounterSlow = 1
    end
end

function startIsland1()
    dbg.stm("Island 1 started")
end

function startIsland2()
    dbg.stm("Island 2 started")
end

function startFinalIsland()
    dbg.stm("Final Island started")
end

function chooseNewIsland()
   local island =  getRandomIsland()
    amountOfIslands:save(amountOfIslands:get() - 1)
    island.functionToStartIsland()
    Map.SetScreenPos(island.startX, island.startY)
end


function getRandomIsland()
    if amountOfIslands:get() == 0 then
        return finalIsland
    else
        local availableIslands = getAvailableIslands()
        local numberOfIsland = getRandomNumberOfNumbers(availableIslands)

        if isDebug() == TRUE then
            dbg.print("selected island" .. numberOfIsland)
        end

        return islands[numberOfIsland]
    end
end

function getAvailableIslands()
    local activeIslands = {}

    local counter = 1
    dbg.stm("vorChecAv")
    while counter <= islandCount do
        if is_bit_set(binaryActiveIslands:get(), counter) == 1 then
            activeIslands[getn(activeIslands) + 1]  = counter
        end
        counter = counter + 1
    end
    dbg.stm("nachChecAv")
    return activeIslands
end


function getRandomNumberOfNumbers(numbers)
    local randomIsland = randomBetweenSimple(1, getn(numbers))
    dbg.stm("ausgewählter Insel index" .. randomIsland)
    return numbers[randomIsland]
end

function addAndRemoveSmallTower(x, y, player)
    Buildings.AddBuilding(x, y, player, Buildings.GUARDTOWERSMALL)
    Buildings.CrushBuilding(Buildings.GetFirstBuilding(player, Buildings.GUARDTOWERSMALL))
    removeGoodsAndSettlersAfterTower(x,y,player)
end

function removeGoodsAndSettlersAfterTower(x, y, player)
    Settlers.KillSelectableSettlers(player, Settlers.SWORDSMAN_01, x, y, 10, 0)
    Goods.Delete(x, y, 5, Goods.STONE)
    Goods.Delete(x, y, 5, Goods.BOARD)
end

function removeSmallTowersForPlayer(playerId)
    while Buildings.Amount(playerId,  Buildings.GUARDTOWERSMALL, Buildings.READY) > 0  do
        Buildings.CrushBuilding(Buildings.GetFirstBuilding(playerId, Buildings.GUARDTOWERSMALL))
    end
end

function checkAddIsland()
    if gameStarted:get() == 0 then
        amountOfSoldiers = Settlers.AmountInArea(1, Settlers.SWORDSMAN_03, 906,1003, 5)
        if amountOfSoldiers > 0 then
            Settlers.KillSelectableSettlers(1, Settlers.SWORDSMAN_03, 906,1003, 5, 0)
            amountOfIslands:save(amountOfIslands:get() + amountOfSoldiers)
            dbg.stm("Ihr habt euch für " .. amountOfIslands:get() .. " Inseln entschieden. Schickt den Hauptmann in das Portal, um die Partie zu starten!")
        end

        if Settlers.AmountInArea(1, Settlers.SQUADLEADER, 906,1003, 5) > 0 then
            Settlers.KillSelectableSettlers(1, Settlers.SQUADLEADER, 906,1003, 5, 0)
            Settlers.KillSelectableSettlers(1, Settlers.SWORDSMAN_03, 875,971, 9, 0)
            startGame()
        end
    end
end

function checkAddPlayer()
    if gameStarted:get() == 0 then
        local counter = 1
        while counter <= getn(humans) do
            if Settlers.AmountInArea(counter, Settlers.SQUADLEADER, 967,980, 5) > 0 then
                Settlers.KillSelectableSettlers(counter, Settlers.SQUADLEADER, 967,980, 5, 0)
                addPlayer(counter)
            end
            counter = counter + 1
        end
    end

end

function prepareIslandChoose()
    Settlers.AddSettlers(875, 971, 1, Settlers.SWORDSMAN_03, getn(islands))
    Settlers.AddSettlers(902, 971, 1, Settlers.SQUADLEADER, 1)
    addAndRemoveSmallTower(890,980,1)
    dbg.stm("Wieviele Inseln auf dem Weg zur finalen Insel möchtet ihr spielen?")
end

function addPlayer(playerId)
    if playerId == 1 then
        player1Active:save(1)
        prepareIslandChoose()
        if Game.LocalPlayer() == 1 then
            Map.SetScreenPos(890, 972)
        end
    elseif playerId == 2 then
        player2Active:save(1)
    elseif playerId == 3 then
        player3Active:save(1)
    elseif playerId == 4 then
        player4Active:save(1)
    elseif playerId == 5 then
        player5Active:save(1)
    end
    dbg.stm("Spieler " .. playerId .. " ist mit von der Partie!")
    updateActivePlayers()
end

function updateActivePlayers()
    if player1Active:get() == 1 then
        activePlayers[getn(activePlayers)+1] = 1
    end
    if player2Active:get() == 1 then
        activePlayers[getn(activePlayers)+1] = 2
    end
    if player3Active:get() == 1 then
        activePlayers[getn(activePlayers)+1] = 3
    end
    if player4Active:get() == 1 then
        activePlayers[getn(activePlayers)+1] = 4
    end
    if player5Active:get() == 1 then
        activePlayers[getn(activePlayers)+1] = 5
    end

end

-------------------------------------------------------------
------ generalUtility  --------------------------------------
-------Diese könnt ihr für eure Scripts nutzen---------------

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
    end
    return number1
end

function maxNumber(number1, number2)
    if number1 > number2 then
        return number1
    end
    return number2
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

function pow(base, exponent)
    local expNr = 0
    local toReturn = 1
    while expNr < exponent
    do
        toReturn = toReturn * base
        expNr = expNr + 1
    end
    return toReturn
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



function get_bitset(num)
    local bitset = {}
    local tmpnum = floorNumber(num)
    local bit = 1
    local exp2 = 2
    while tmpnum ~= 0 do -- floor guarantees this not to be (0,1)... at least for numbers < 9b...something, i cant promise anything
        local bitval = mod(tmpnum,exp2)
        bitset[bit] = boolvalue(bitval)
        tmpnum = tmpnum - bitval
        exp2 = exp2 + exp2
        bit = bit + 1
    end
    return bitset
end
function is_bit_set(num,bit)
    if get_bitset(num)[bit] ~= 0 then -- this expression returns 1 on true, and nil on false, cannot use this as a return value smh
        return 1
    else
        return 0
    end
end
-- 1 if num != 0
-- 0 else
function boolvalue(num)
    if num ~= 0 and num ~= nil then return 1
    else return 0
    end
end
function bitset_to_int(bitset)
    -- bitset problem example:
    --given bitset value:
    -- bitset[0] = 1 -- 0 is IGNORED
    -- bitset[1] = 1 -- OK
    -- bitset[2] = 0 -- OK
    -- bitset[20] = 1 -- WHERE bitset[3-19] ? assume 0
    -- bitset["string"] = "value" -- ignore

    -- implement
    local result = 0;
    local i, v = next(bitset, nil)
    while i do
        local num = tonumber(i)
        if num then
            -- is number, check range [1,30]
            num = floorNumber(num)
            if num >= 1 and num <= 30 then -- integers > 1 billion are inconsistent in floating point value, only be able to set bits 2^0 - 2 ^30
                -- TODO TEST WHAT VALUE bitset [1,1...,1] with n = 30 is (is <1b ?)
                local boolval = boolvalue(v)
                if boolval ~= 0 then
                    result = result + pow(2,num-1) -- num-1 because 2 ^0 is first bit for example. lua starts indexing at 1 so we keep it that way
                end
            end
        end
        i, v = next(bitset, i)
    end
    return result
end

-- in: set_bit(5,2,1)
-- process: 101b with bit 2 to 1
-- out: 111b = 7
function set_bit(num,bit,set)
    local newbitset = get_bitset(num);
    -- dont set bit outside of [1,30]
    if bit < 1 or bit > 30 then
        return num -- unchanged
    end

    newbitset[bit] = boolvalue(set);
    return bitset_to_int(newbitset)
end

