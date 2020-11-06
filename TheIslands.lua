function new_game()
	Vars.Save8 = 0
	request_event(doActionsAfterMinutes, Events.FIVE_TICKS)
	request_event(initGame,Events.FIRST_TICK_OF_NEW_OR_LOADED_GAME)
	testfunction()
	 
end

function register_functions()
	reg_func(doActionsAfterMinutes)
	reg_func(initGame)
end

function initGame()
	Tutorial.RWM(1)
end

function testfunction()
	dbg.stm("geht")

end

function doActionsAfterMinutes()
	--wird jede Minute ausgefuehrt
	if newMinute() == 1 then

	end


	if minuteReached(1) == 1 then
		
		dbg.stm("Minute rum")
		--AI.AttackNow(3,2,20)
		Settlers.AddSettlers(68, 135, 3, Settlers.SQUADLEADER, 10)
		Settlers.AddSettlers(66, 135, 3, Settlers.SWORDSMAN_03, 10)
		Settlers.AddSettlers(66, 135, 3, Settlers.BOWMAN_03, 10)
		Settlers.AddSettlers(66, 135, 3, Settlers.MEDIC_03, 10)
		Settlers.AddSettlers(66, 135, 3, Settlers.PRIEST, 10)
		AI.NewSquad(3, AI.CMD_SUICIDE_MISSION )
		
		Settlers.AddSettlers(150, 132, 3, Settlers.SQUADLEADER, 10)
		Settlers.AddSettlers(150, 132, 3, Settlers.SWORDSMAN_03, 10)
		Settlers.AddSettlers(150, 132, 3, Settlers.BOWMAN_03, 10)
		Settlers.AddSettlers(150, 132, 3, Settlers.MEDIC_03, 10)
		Settlers.AddSettlers(150, 132, 3, Settlers.PRIEST, 10)
		AI.NewSquad(3, AI.CMD_SUICIDE_MISSION )

		--Settlers.AddSettlers(167, 129, 4, Settlers.SWORDSMAN_03, 100)
		
		--Settlers.AddSettlers(310, 65, 4, Settlers.BOWMAN_03, 10)
		--Settlers.AddSettlers(310, 65, 4, Settlers.SQUADLEADER, 10)
		--Settlers.AddSettlers(310, 65, 4, Settlers.SWORDSMAN_03, 10)
		--Settlers.AddSettlers(310, 65, 4, Settlers.BOWMAN_03, 10)
		--Settlers.AddSettlers(310, 65, 4, Settlers.MEDIC_03, 10)
		--Settlers.AddSettlers(310, 65, 4, Settlers.PRIEST, 10)


		
	end
	
		if minuteReached(2) == 1 then
		dbg.stm("3 Minuten rum")
		--AI.AttackNow(3,2,20)
		
		
		--AI.NewSquad(4, AI.CMD_SUICIDE_MISSION )
	end

end


----------------------
-- generalUtility  ---
----------------------

function floorNumber(floatNumber)
	local stringmyValue =  tostring(floatNumber)
	if strfind (stringmyValue, "(%.+)") ~= nil then 
		local valuestring = strsub (stringmyValue, 1, strfind (stringmyValue, "(%.+)"))
		return tonumber(valuestring)
	else
		return floatNumber
	end

end


-- gibt wenn die Minute erreicht ist einmal 1 zurueck
function minuteReached(value)
	if Game.Time() == value then
		if Vars.Save9 ~= value then
			Vars.Save9 = value
			return 1
		else
			return 0
		end
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





function getAmountOfPlayerUnits(playerId)
	local AmoutOfMilitary = 0
 	--Soldaten zaehlen	
	AmoutOfMilitary =  AmoutOfMilitary + Settlers.Amount(playerId, Settlers.SWORDSMAN_01) +  Settlers.Amount(playerId, Settlers.SWORDSMAN_02) + Settlers.Amount(playerId, Settlers.SWORDSMAN_03)
  -- Bogenschuetzen
  AmoutOfMilitary =  AmoutOfMilitary + Settlers.Amount(playerId, Settlers.BOWMAN_01) +  Settlers.Amount(playerId, Settlers.BOWMAN_02) + Settlers.Amount(playerId, Settlers.BOWMAN_03)
  -- Spezial Wiki
  AmoutOfMilitary = AmoutOfMilitary + Settlers.Amount(playerId, Settlers.AXEWARRIOR_01) + Settlers.Amount(playerId, Settlers.AXEWARRIOR_02) + Settlers.Amount(playerId, Settlers.AXEWARRIOR_03)
	-- Spezial Maya
	AmoutOfMilitary = AmoutOfMilitary + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_01) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_02) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_03)
	-- Spezial Trojaner
	AmoutOfMilitary = AmoutOfMilitary + Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_01)	+ Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_02) + Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_03)
	-- Spezial Römer
	AmoutOfMilitary = AmoutOfMilitary + Settlers.Amount(playerId, Settlers.MEDIC_01) + Settlers.Amount(playerId, Settlers.MEDIC_02) + Settlers.Amount(playerId, Settlers.MEDIC_03)	
	-- Hauptmaenner
	AmoutOfMilitary = AmoutOfMilitary + Settlers.Amount(playerId, Settlers.SQUADLEADER) 	
	
	
	return AmoutOfMilitary 
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