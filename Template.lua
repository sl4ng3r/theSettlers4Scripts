function new_game()
  request_event(doActionsAfterMinutes, Events.FIVE_TICKS)
  MinuteEvents.new_game()
  testfunction()
  --testfunction nach 5 minuten
  requestMinuteEvent(testfunction, 5)
 
end

function register_functions()
  reg_func(doActionsAfterMinutes)
  MinuteEvents.register_functions()
end


function testfunction()
	-- Hier könnt ihr code zum Testen hinschreiben.
	dbg.stm("geht")

end

function doActionsAfterMinutes()
	--wird jede Minute ausgefuehrt
	if newMinute() == 1 then
		dbg.stm("wieder eine Minute rum")
	end


	if minuteReached(1) == 1 then
		dbg.stm("Minute rum")
	end
	
	if minuteReached(5) == 1 then
		dbg.stm("5 Minuten rum")
	end
	
	

end



----------------------
-- generalUtility  ---
----------------------
function getPlayerIDWithMostUnitsForPosition(playersTable, enemyPosition)

	local playercache = {0,0,0,0,0,0,0,0}
	
	local i = 1
	-- setzt an die einzelnen stellen innerhalb des playerchache arrays die Einheitenanzahl etsprechend der spielerId
	-- Bpsp {0,0,0,34,12,43,34,34) --> jetzt waeren die letzten fuenf spieler opponents mit der entsprechenden Anzahl Einheiten
	while i <= getn (playersTable) do
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
		while counter2 <= getn (playercache) do
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
	while counter2 <= getn (playercache) do
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
		if Vars.Save7 ~= value then
			Vars.Save7 = value
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

function max(value1, value2)
	if value1 > value2 then
		return value1
	end
	return value2
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

