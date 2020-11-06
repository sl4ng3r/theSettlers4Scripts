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
		VarsExt.MAXSPACE,VarsExt.MAXSPACE,VarsExt.MAXSPACE,

		VarsExt.MAXSPACE,VarsExt.MAXSPACE,VarsExt.MAXSPACE,

		VarsExt.MAXSPACE,VarsExt.MAXSPACE,VarsExt.MAXSPACE
}


-- fills a string if not long enough from the left
-- e.g. "123","0",9 becomes "000000123"
function str_fill_left(str,char,minSize)
	local its = (minSize - strlen(str)) / strlen(char)
	local endStr = ""
	while its > 0 do
		endStr = endStr .. char
		its = its - 1
  end
	endStr = endStr .. str
	return endStr;
end


VarsExt.saveVar = function(save,offset,size,value)
	local currentSaveVal = Vars["Save"..save];
	local saveValStr = str_fill_left(format("%.0f",currentSaveVal),"0",VarsExt.MAXSPACE)
	local leftsize = offset
	local leftStr = strsub(saveValStr,1,leftsize);
	local rightStr = strsub(saveValStr,offset+1+size)
	local newstr = leftStr .. str_fill_left(tostring(value),"0",size) .. rightStr;
	Vars["Save"..save] = tonumber(newstr);
end

VarsExt.getVar = function(save,offset,size)

		local currentSaveVal = Vars["Save"..save];

		local saveValStr = str_fill_left(format("%.0f",currentSaveVal),"0",VarsExt.MAXSPACE)

		local myVal = tonumber(strsub(saveValStr,offset+1,offset+size))

		return myVal;
end
VarsExt.save = function(this,value)
	if value > this.maxnum or value < 0 then
		return;
	end
	VarsExt.saveVar(this.i,this.off,this.size,value);
end
VarsExt.get = function(this)
	return VarsExt.getVar(this.i,this.off,this.size);
end

-- util foreach
function foreach_ext (t, f, ...)
	local i, v = next(t, nil)
	while i do
	  -- we could maybe optimise this, but its really not a big deal
	  local args = arg
	  tinsert(args,1,v)
	  tinsert(args,1,i)
	  local res = call(f,args)

	  tremove(args,1); -- it is the same object hence remove it again
	  tremove(args,1);

	  if res then return res end
	  i, v = next(t, i)
	end
end

--
-- find index with size on any vars, returns first save with enough size
--
VarsExt.findIndexWithSize = function(size)
		if size < 1 then return nil; end

		return foreach_ext(VarsExt.Vars,function(i,var,s)
											if var >= s then
												return i
											end
										end,size);
end
--
-- reserve size on save.expects size to be fitting
-- returns offset from 0 on SaveX
VarsExt.reserve = function(save,size)
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
	if index == nil or size < 1 then return nil; end

	-- init
	if Vars["Save" .. index] == nil then
		Vars["Save" .. index] = 0
	end
	local offset = VarsExt.reserve(index,size);


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
	--print("myVar","i="..index,"off="..offset,"size="..size,"maxnum="..maxnum);
	return myVar;
end

-- in case you are using a Vars.Save on your own, you can state here that it will not be used. THIS ACTION CANNOT BE REVERSED (since scripts are hard coded.);
VarsExt.occupy = function(save)
	if VarsExt.Vars[save] > 0 then -- 0 or -1 or -0 ?
		VarsExt.Vars[save] = -1;
	end
end


-----------------------------------------------
-----------------------------------------------
----Ab hier beginnt das eigentliche Script ----
-----------------------------------------------
-----------------------------------------------

function new_game()
	dbg.stm("Die feindlichen Truppen formieren sich!! Der grausame Herrscher König Erdur wird versuchen, uns zu überrennen. Ihr müsst euer Königreich verteidigen und diesen grausamen Herrscher ein für alle mal erledigen. Eure beiden Fürsten werden euch treu zur Seite stehen, und euch bei eurem Kampf unterstützen.")
	
	Vars.Save8 = 0


	request_event(Siegbedingung, Events.VICTORY_CONDITION_CHECK)
	request_event(doActionsAfterMinutes, Events.FIVE_TICKS)
	request_event(aiOperations, Events.FIVE_TICKS)
	request_event(initGame,Events.FIRST_TICK_OF_NEW_OR_LOADED_GAME)
	request_event(removeBoats, Events.FIVE_TICKS)
	request_event(checkIfUnitInPortal, Events.FIVE_TICKS)
	request_event(checkIfUnitInSacrificePlace, Events.FIVE_TICKS)


	preparePlayer1()

	if Game.GetDifficulty() == 1 then
		dbg.stm("Ihr habt euch für eine schwere Partie entschieden!")
	prepareDifficultMatch()
	else
		dbg.stm("Ihr habt euch für eine leichtere Partie entschieden!")
	end 

	testfunction()

	if isDebug() == 0 then 
		Game.DisableLastNPlayersInStatistic(5)
	end

	AI.SetPlayerVar(2, "AttackMode", 3,3,3)
	AI.SetPlayerVar(3, "AttackMode", 3,3,3)
	AI.SetPlayerVar(4, "AttackMode", 1,1,1)
	AI.SetPlayerVar(5, "AttackMode", 1,1,1)
	AI.SetPlayerVar(6, "AttackMode", 1,1,1)
	AI.SetPlayerVar(7, "AttackMode", 1,1,1)
	AI.SetPlayerVar(8, "AttackMode", 1,1,1)
	
	AI.SetPlayerVar(2, "SoldierLimitAbsolute", 1000,1000,1000)
	AI.SetPlayerVar(3, "SoldierLimitAbsolute", 1000,1000,1000)
	AI.SetPlayerVar(2, "SoldierLimitRelative", 1000,1000,1000)
	AI.SetPlayerVar(3, "SoldierLimitRelative", 1000,1000,1000)
	--AI.SetPlayerVar(2, "AttackThresholdPartial", 1000,1000,1000)
	--AI.SetPlayerVar(3, "AttackThresholdPartial", 1000,1000,1000)
	--AI.SetPlayerVar(2, "AttackThresholdTotal", 1000,1000,1000)
	--AI.SetPlayerVar(3, "AttackThresholdTotal", 1000,1000,1000)
	
end



function register_functions()
  reg_func(Siegbedingung)
  reg_func(aiOperations)
  reg_func(doActionsAfterMinutes)
  reg_func(initGame)
  reg_func(removeBoats)
  reg_func(checkIfUnitInPortal)
  reg_func(checkIfUnitInSacrificePlace)
end

function isDebug()
	return 1
end

-------------------------------------------------------------
----------------------INIT FUNCTIONS-------------------------
-------------------------------------------------------------



function initGame()
	  if Game.Time() >= getEndgameTime() then
		endGame = 1
	  else
		endGame = 0
	  end
	  setNewAttackAmount()
	  setNewPauseUntilAttack()
end



function testfunction()
	

	
	if isAIDebug() == 1 then 
		spawnmilitary()
	end

	if isDebug() == 1 then 
		Magic.IncreaseMana(1,500)
	end
	
	
end
	
function spawnmilitary()
  --if Game.Time() == 1 then

  --Settlers.AddSettlers(799, 75, 8, Settlers.CARRIER, 3)
  
  -- Verstaerkung fuer Endgabe Test
	--Settlers.AddSettlers(183, 681, 1, Settlers.SWORDSMAN_03, 200)
	--Settlers.AddSettlers(191, 679, 2, Settlers.BOWMAN_03, 600)

	
	--Settlers.AddSettlers(485, 717, 2, Settlers.SWORDSMAN_03, 200)
	Settlers.AddSettlers(465, 685, 1, Settlers.BOWMAN_03, 600)
	

	--Settlers.AddSettlers(666, 663, 3, Settlers.BOWMAN_03, 600)
	Game.SetFightingStrength(1, 150)
	Game.SetFightingStrength(2, 150)
	Game.SetFightingStrength(3, 150)


  --end
end
	


function prepareDifficultMatch()
	--Buildings.AddBuilding(96, 147, 4, Buildings.BARRACKS)
	Goods.AddPileEx(96, 147, Goods.STONE, 8)
	Goods.AddPileEx(96, 147, Goods.BOARD, 8)
	Goods.AddPileEx(96, 147, Goods.STONE, 8)
	Goods.AddPileEx(96, 147, Goods.BOARD, 8)
	
	--Buildings.AddBuilding(277, 355, 5, Buildings.BARRACKS)
	Goods.AddPileEx(277, 355, Goods.STONE, 8)
	Goods.AddPileEx(277, 355, Goods.BOARD, 8)
	Goods.AddPileEx(277, 355, Goods.STONE, 8)
	Goods.AddPileEx(277, 355, Goods.BOARD, 8)
	
	--Buildings.AddBuilding(473, 307, 6, Buildings.BARRACKS)
	Goods.AddPileEx(473, 307, Goods.STONE, 8)
	Goods.AddPileEx(473, 307, Goods.BOARD, 8)
	Goods.AddPileEx(473, 307, Goods.STONE, 8)
	Goods.AddPileEx(473, 307, Goods.BOARD, 8)
	
	--Buildings.AddBuilding(722, 296, 7, Buildings.BARRACKS)
	Goods.AddPileEx(722, 296, Goods.STONE, 8)
	Goods.AddPileEx(722, 296, Goods.BOARD, 8)
	Goods.AddPileEx(722, 296, Goods.STONE, 8)
	Goods.AddPileEx(722, 296, Goods.BOARD, 8)
	
	--Buildings.AddBuilding(753, 78, 8, Buildings.BARRACKS)
	Goods.AddPileEx(753, 78, Goods.STONE, 8)
	Goods.AddPileEx(753, 78, Goods.BOARD, 8)
	Goods.AddPileEx(753, 78, Goods.STONE, 8)
	Goods.AddPileEx(753, 78, Goods.BOARD, 8)
end


function preparePlayer1()

	
	while Buildings.Amount(1,  Buildings.GUARDTOWERSMALL, Buildings.READY) > 0 do
		Buildings.CrushBuilding(Buildings.GetFirstBuilding(1, Buildings.GUARDTOWERSMALL))
	end
	
	removeTowerAndGoods(497,843,10)
	removeTowerAndGoods(560,847,10)
	removeTowerAndGoods(523,839,30)

	Settlers.AddSettlers(514,829, 1, Settlers.SWORDSMAN_01, 1)
	Settlers.AddSettlers(522,829, 1, Settlers.BOWMAN_01, 1)
	
end

function removeTowerAndGoods(x,y,radius)
	Settlers.KillSelectableSettlers(1, Settlers.SWORDSMAN_01, x, y, radius, 0)
	Goods.Delete(x,y,radius,Goods.STONE)
	Goods.Delete(x,y,radius,Goods.BOARD)
end

function Siegbedingung()
  Game.DefaultPlayersLostCheck()
  if Buildings.ExistsBuildingInArea(1,Buildings.CASTLE,475,711,10,Buildings.READY) == 0 then
	Game.PlayerLost(1)
    Game.PlayerLost(2)
    Game.PlayerLost(3)
  end
   if Buildings.ExistsBuildingInArea(8,Buildings.CASTLE,799,65,10,Buildings.READY) == 0 then
	Game.PlayerLost(4)
    Game.PlayerLost(5)
    Game.PlayerLost(6)
	Game.PlayerLost(7)
	Game.PlayerLost(8)
  end
  Game.DefaultGameEndCheck()
end


-------------------------------------------------------------
-----------------ZUSAETZLICHE MAP FUNCTIONS------------------
-------------------------------------------------------------

tickCounter = 1

--überprüft ob Boote dem Gegner König zu nahe kommen--
function removeBoats()
	
	tickCounter = tickCounter + 5
	
	if tickCounter >= 350 then 
		

		local index = 1
		
		--IDs der Gebaeude gehen von 1 - 83
		while index <= getn(humans) do

			if Vehicles.AmountInArea(humans[index],Vehicles.WARSHIP,732, 24, 23) > 0 or Vehicles.AmountInArea(humans[index],Vehicles.WARSHIP,824, 24, 23)  > 0 then
				dbg.stm("war in Area")
				Vehicles.KillVehicles(humans[index],Vehicles.WARSHIP,732, 24, 23)
				Vehicles.KillVehicles(humans[index],Vehicles.WARSHIP,824, 24, 23)
				dbg.stm("Ein greller Blitz, zzzzzschhhhh. Eure Krigsschiffe wurden von Thor zerstört")
			end
			if Vehicles.AmountInArea(humans[index],Vehicles.FERRY,732, 24, 23) > 0 or Vehicles.AmountInArea(humans[index],Vehicles.FERRY,824, 24, 23)  > 0 then
				dbg.stm("war in Area")
				Vehicles.KillVehicles(humans[index],Vehicles.FERRY,732, 24, 23)
				Vehicles.KillVehicles(humans[index],Vehicles.FERRY,824, 24, 23)
				dbg.stm("Ein greller Blitz, zzzzzschhhhh. Eure Krigsschiffe wurden von Thor zerstört")
			end
			index = index +  1
		end
		
		tickCounter = 1
	end
	
end

--spawnt bei allen Computer Gegnern zusätzliche Gegenstände--
function spawnEnemySupportPackage(settlersAmount, swords, bows, goldBars, axes)
	if Game.HasPlayerLost(4) == 0 then 
		 Settlers.AddSettlers(117, 145, 4, Settlers.CARRIER, settlersAmount)
		 Goods.AddPileEx(117,  145, Goods.SWORD, swords)
		 Goods.AddPileEx(117,  145, Goods.BOW, bows)
		 Goods.AddPileEx(117, 145, Goods.GOLDBAR, goldBars)
	end
	 
	 if Game.HasPlayerLost(5) == 0 then 
		 Settlers.AddSettlers(273, 350, 5, Settlers.CARRIER, settlersAmount)
		 Goods.AddPileEx(273,  350, Goods.SWORD, swords)
		 Goods.AddPileEx(273,  350, Goods.BOW, bows)
		 Goods.AddPileEx(273, 350, Goods.GOLDBAR, goldBars)
	end

	if Game.HasPlayerLost(6) == 0 then 
		 Settlers.AddSettlers(447, 295, 6, Settlers.CARRIER, settlersAmount)
		 Goods.AddPileEx(447,  295, Goods.SWORD, swords)
		 Goods.AddPileEx(447,  295, Goods.BOW, bows)
		 Goods.AddPileEx(447, 295, Goods.GOLDBAR, goldBars)
	end
	if Game.HasPlayerLost(7) == 0 then 
		 Settlers.AddSettlers(726, 301, 7, Settlers.CARRIER, settlersAmount)
		 Goods.AddPileEx(726,  301, Goods.SWORD, swords)
		 Goods.AddPileEx(726,  301, Goods.BOW, bows)
		 Goods.AddPileEx(726, 301, Goods.GOLDBAR, goldBars)
	end
	if Game.HasPlayerLost(8) == 0 then 
		 Settlers.AddSettlers(782, 117, 8, Settlers.CARRIER, settlersAmount)
		 Goods.AddPileEx(782,  117, Goods.SWORD, swords)
		 Goods.AddPileEx(782,  117, Goods.BATTLEAXE, axes)
		 Goods.AddPileEx(782,  117, Goods.BOW, bows)
		 Goods.AddPileEx(782, 117, Goods.GOLDBAR, goldBars)
	 end
end 


-------------------------------------------------------------
-----HIER BEGINNT DIE LOGIK FÜR DAS GESAMTE OPFER THEMA------
-------------------------------------------------------------

sacrificePlaces={
	sp1={
		x=470,
		y=854,
		playerToSupport=2,
		playerToSupportRace="Wikinger"
	},
	sp2={
		x=600,
		y=863,
		playerToSupport=3,
		playerToSupportRace="Mayas"
	}
}


tickCounterSacPoints = 1
function checkIfUnitInSacrificePlace()
	tickCounterSacPoints = tickCounterSacPoints + 1
	if tickCounterSacPoints > 150 then 
		checkSacrificePlaces()
		tickCounterSacPoints=1
	end
end



p2SwordSacPoints = VarsExt.create(2);
p2BowSacPoints = VarsExt.create(2);
p2MedicSacPoints = VarsExt.create(2);
p2PriestSacPoints = VarsExt.create(2);
p2SpecialistSacPoints = VarsExt.create(2);

p2SwordSpawns = VarsExt.create(3);
p2BowSpawns = VarsExt.create(3);
p2SpecialSpawns = VarsExt.create(3);
p2GoldSpawns = VarsExt.create(3);
p2CarrierSpawns = VarsExt.create(3);


p3SwordSacPoints = VarsExt.create(2);
p3BowSacPoints = VarsExt.create(2);
p3MedicSacPoints = VarsExt.create(2);
p3PriestSacPoints = VarsExt.create(2);
p3SpecialistSacPoints = VarsExt.create(2);

p3SwordSpawns = VarsExt.create(3);
p3BowSpawns = VarsExt.create(3);
p3SpecialSpawns = VarsExt.create(3);
p3GoldSpawns = VarsExt.create(3);
p3CarrierSpawns = VarsExt.create(3);

amountOfSacPointsForOneSpawn = 8

function addUnitsForType(sacPlace, sacUnit, sacUnitValue, actualSacPointsVars, spawnAmountVars)
	local unitAmount = Settlers.AmountInArea(1, sacUnit, sacPlace.x, sacPlace.y, 15)
	if unitAmount > 0 then
		Settlers.KillSelectableSettlers(1, sacUnit, sacPlace.x, sacPlace.y, 15, 0)
		
		
		if sacUnit == Settlers.THIEF then 
			if sacPlace.playerToSupport == 2 then 
				while Buildings.Amount(2,  Buildings.GUARDTOWERSMALL, Buildings.READY) > 0 do
					Buildings.CrushBuilding(Buildings.GetFirstBuilding(2, Buildings.GUARDTOWERSMALL))
				end
			else
				while Buildings.Amount(3,  Buildings.GUARDTOWERSMALL, Buildings.READY) > 0 do
					Buildings.CrushBuilding(Buildings.GetFirstBuilding(3, Buildings.GUARDTOWERSMALL))
				end
			end
		else
			
			local newSacPointValue = actualSacPointsVars:get() + unitAmount * sacUnitValue
			
			while newSacPointValue >= (amountOfSacPointsForOneSpawn + spawnAmountVars:get()) do
				newSacPointValue = newSacPointValue - (amountOfSacPointsForOneSpawn + spawnAmountVars:get())
				spawnAmountVars:save(spawnAmountVars:get() + 1)
			end
			actualSacPointsVars:save(newSacPointValue)
			printSacMessage(sacPlace, unitAmount, sacUnit, sacUnitValue, spawnAmountVars:get(),(amountOfSacPointsForOneSpawn + spawnAmountVars:get() - newSacPointValue) )
		end
	end
end


function printSacMessage(sacPlace,unitAmount, sacUnit, sacUnitValue, amountOfspawns,leftSacPoints)
	if sacUnit == Settlers.SWORDSMAN_01 or sacUnit == Settlers.SWORDSMAN_02 or sacUnit == Settlers.SWORDSMAN_03 then 
	
		if amountOfspawns == 1 then 
			dbg.stm("Du hast " .. unitAmount .. " Schwertkämpfer Lvl " .. sacUnitValue .. " geopfert. " .. "Eure Götter gewähren nun den " .. sacPlace.playerToSupportRace .. " " .. amountOfspawns .. " zusätzliches Schwerte in jeder zweiten Minute.  Es fehlen noch " .. leftSacPoints .. " weitere Opfer Punkte für ein weiteres Schwert")
		else
			dbg.stm("Du hast " .. unitAmount .. " Schwertkämpfer Lvl " .. sacUnitValue .. " geopfert. " .. "Eure Götter gewähren nun den " .. sacPlace.playerToSupportRace .. " " .. amountOfspawns .. " zusätzliche Schwerter in jeder zweiten Minute.  Es fehlen noch " .. leftSacPoints .. " weitere Opfer Punkte für ein weiteres Schwert")
		end
	
	else if sacUnit == Settlers.BOWMAN_01 or sacUnit == Settlers.BOWMAN_02 or sacUnit == Settlers.BOWMAN_03 then 
		if amountOfspawns == 1 then 
			dbg.stm("Du hast " .. unitAmount .. " Bogenschützen Lvl " .. sacUnitValue .. " geopfert. " .. "Eure Götter gewähren nun den " .. sacPlace.playerToSupportRace .. " " .. amountOfspawns .. " zusätzlichen Bogen in jeder zweiten Minute.  Es fehlen noch " .. leftSacPoints .. " weitere Opfer Punkte für einen weiteren Bogen")
		else
			dbg.stm("Du hast " .. unitAmount .. " Bogenschützen Lvl " .. sacUnitValue .. " geopfert. " .. "Eure Götter gewähren nun den " .. sacPlace.playerToSupportRace .. " " .. amountOfspawns .. " zusätzliche Bögen in jeder zweiten Minute.  Es fehlen noch " .. leftSacPoints .. " weitere Opfer Punkte für einen weiteren Bogen")
		end	
	else if sacUnit == Settlers.MEDIC_01 or sacUnit == Settlers.MEDIC_02 or sacUnit == Settlers.MEDIC_03 then 
		if sacPlace.playerToSupport == 2 then 
			if amountOfspawns == 1 then 
				dbg.stm("Du hast " .. unitAmount .. " Sanitäter Lvl " .. sacUnitValue .. " geopfert. " .. "Eure Götter gewähren nun den " .. sacPlace.playerToSupportRace .. " " .. amountOfspawns .. " zusätzliche Axt in jeder zweiten Minute.  Es fehlen noch " .. leftSacPoints .. " weitere Opfer Punkte für eine weitere Axt")
			else
				dbg.stm("Du hast " .. unitAmount .. " Sanitäter Lvl " .. sacUnitValue .. " geopfert. " .. "Eure Götter gewähren nun den " .. sacPlace.playerToSupportRace .. " " .. amountOfspawns .. " zusätzliche Äxte in jeder zweiten Minute.  Es fehlen noch " .. leftSacPoints .. " weitere Opfer Punkte für eine weitere Axt")
			end	
		else
			if amountOfspawns == 1 then 
				dbg.stm("Du hast " .. unitAmount .. " Sanitäter Lvl " .. sacUnitValue .. " geopfert. " .. "Eure Götter gewähren nun den " .. sacPlace.playerToSupportRace .. " " .. amountOfspawns .. " zusätzliches Blasrohr in jeder zweiten Minute.  Es fehlen noch " .. leftSacPoints .. " weitere Opfer Punkte für ein weiteres Blasrohr")
			else
				dbg.stm("Du hast " .. unitAmount .. " Sanitäter Lvl " .. sacUnitValue .. " geopfert. " .. "Eure Götter gewähren nun den " .. sacPlace.playerToSupportRace .. " " .. amountOfspawns .. " zusätzliche Blasrohre in jeder zweiten Minute.  Es fehlen noch " .. leftSacPoints .. " weitere Opfer Punkte für ein weiteres Blasrohr")
			end	
		end
	else if sacUnit == Settlers.PRIEST then 
		if amountOfspawns == 1 then 
			dbg.stm("Du hast " .. unitAmount .. " Priester geopfert. " .. "Eure Götter gewähren nun den " .. sacPlace.playerToSupportRace .. " " .. amountOfspawns .. " zusätzlichen Goldbarren in jeder zweiten Minute.  Es fehlen noch " .. leftSacPoints .. " weitere Opfer Punkte für einen weiteren Goldbarren")
		else
			dbg.stm("Du hast " .. unitAmount .. " Priester geopfert. " .. "Eure Götter gewähren nun den " .. sacPlace.playerToSupportRace .. " " .. amountOfspawns .. " zusätzliche Goldbarren in jeder zweiten Minute.  Es fehlen noch " .. leftSacPoints .. " weitere Opfer Punkte für einen weiteren Goldbarren")
		end	
	else if sacUnit == Settlers.PIONEER or sacUnit == Settlers.SABOTEUR or sacUnit == Settlers.GEOLOGIST or sacUnit == Settlers.GARDENER then 
		if amountOfspawns == 1 then 
			dbg.stm("Du hast " .. unitAmount .. " Spezialisten geopfert. " .. "Eure Götter gewähren nun den " .. sacPlace.playerToSupportRace .. " " .. amountOfspawns .. " zusätzlichen Träger in jeder zweiten Minute.  Es fehlen noch " .. leftSacPoints .. " weitere Opfer Punkte für einen weiteren Träger")
		else
			dbg.stm("Du hast " .. unitAmount .. " Spezialisten geopfert. " .. "Eure Götter gewähren nun den " .. sacPlace.playerToSupportRace .. " " .. amountOfspawns .. " zusätzliche Träger in jeder zweiten Minute.  Es fehlen noch " .. leftSacPoints .. " weitere Opfer Punkte für einen weiteren Träger")
		end	
	end end end end end
end


function checkSacrificePlaces()


	addUnitsForType(sacrificePlaces.sp1,Settlers.SWORDSMAN_01,1, p2SwordSacPoints, p2SwordSpawns)
	addUnitsForType(sacrificePlaces.sp1,Settlers.SWORDSMAN_02,2, p2SwordSacPoints, p2SwordSpawns)
	addUnitsForType(sacrificePlaces.sp1,Settlers.SWORDSMAN_03,3, p2SwordSacPoints, p2SwordSpawns)
	addUnitsForType(sacrificePlaces.sp1,Settlers.BOWMAN_01,1, p2BowSacPoints,p2BowSpawns)
	addUnitsForType(sacrificePlaces.sp1,Settlers.BOWMAN_02,2, p2BowSacPoints,p2BowSpawns)
	addUnitsForType(sacrificePlaces.sp1,Settlers.BOWMAN_03,3, p2BowSacPoints,p2BowSpawns)
	addUnitsForType(sacrificePlaces.sp1,Settlers.MEDIC_01,1, p2MedicSacPoints,p2SpecialSpawns)
	addUnitsForType(sacrificePlaces.sp1,Settlers.MEDIC_02,2, p2MedicSacPoints,p2SpecialSpawns)
	addUnitsForType(sacrificePlaces.sp1,Settlers.MEDIC_03,3, p2MedicSacPoints,p2SpecialSpawns)
	addUnitsForType(sacrificePlaces.sp1,Settlers.PRIEST,2, p2PriestSacPoints,p2GoldSpawns)
	addUnitsForType(sacrificePlaces.sp1,Settlers.THIEF,1,nil,nil)
	
	
	addUnitsForType(sacrificePlaces.sp2,Settlers.SWORDSMAN_01,1, p3SwordSacPoints,p3SwordSpawns)
	addUnitsForType(sacrificePlaces.sp2,Settlers.SWORDSMAN_02,2, p3SwordSacPoints,p3SwordSpawns)
	addUnitsForType(sacrificePlaces.sp2,Settlers.SWORDSMAN_03,3, p3SwordSacPoints,p3SwordSpawns)
	addUnitsForType(sacrificePlaces.sp2,Settlers.BOWMAN_01,1, p3BowSacPoints,p3BowSpawns)
	addUnitsForType(sacrificePlaces.sp2,Settlers.BOWMAN_02,2, p3BowSacPoints,p3BowSpawns)
	addUnitsForType(sacrificePlaces.sp2,Settlers.BOWMAN_03,3, p3BowSacPoints,p3BowSpawns)
	addUnitsForType(sacrificePlaces.sp2,Settlers.MEDIC_01,1, p3MedicSacPoints,p3SpecialSpawns)
	addUnitsForType(sacrificePlaces.sp2,Settlers.MEDIC_02,2, p3MedicSacPoints,p3SpecialSpawns)
	addUnitsForType(sacrificePlaces.sp2,Settlers.MEDIC_03,3, p3MedicSacPoints,p3SpecialSpawns)
	addUnitsForType(sacrificePlaces.sp2,Settlers.PRIEST,2, p3PriestSacPoints,p3GoldSpawns)
	addUnitsForType(sacrificePlaces.sp2,Settlers.THIEF,1,nil,nil)

	
	local specialists = {Settlers.PIONEER,Settlers.SABOTEUR,Settlers.GEOLOGIST,Settlers.GARDENER}
	local index = 1
	
	--IDs der Gebaeude gehen von 1 - 83
	while index <= getn(specialists) do
		addUnitsForType(sacrificePlaces.sp1,specialists[index],3, p2SpecialistSacPoints,p2CarrierSpawns)
		addUnitsForType(sacrificePlaces.sp2,specialists[index],3, p3SpecialistSacPoints,p3CarrierSpawns)
		index = index +  1
	end
	Effects.AddEffect(Effects.MMAGIC_RAISERANK, Sounds.AMB_FIRE,sacrificePlaces.sp1.x, sacrificePlaces.sp1.y, 0)
	Effects.AddEffect(Effects.MMAGIC_RAISERANK, Sounds.AMB_FIRE,sacrificePlaces.sp2.x, sacrificePlaces.sp2.y, 0)


end



function addBoostsToAllies()
	if Game.HasPlayerLost(2) == 0 then 
		spawnGoods(160, 682,Goods.SWORD,p2SwordSpawns)
		spawnGoods(160, 682,Goods.BOW,p2BowSpawns)
		spawnGoods(160, 682,Goods.BATTLEAXE,p2SpecialSpawns)
		spawnGoods(160, 682,Goods.GOLDBAR,p2GoldSpawns)

		Settlers.AddSettlers(160, 682, 2, Settlers.CARRIER, p2CarrierSpawns:get())
		Effects.AddEffect(Effects.RMAGIC_GIFTOFGOD, Sounds.AMB_FIRE,160, 682, 0)
	end
	
	if Game.HasPlayerLost(3) == 0 then 
		spawnGoods(642, 727,Goods.SWORD,p3SwordSpawns)
		spawnGoods(642, 727,Goods.BOW,p3BowSpawns)
		spawnGoods(642, 727,Goods.BATTLEAXE,p3SpecialSpawns)
		spawnGoods(642, 727,Goods.GOLDBAR,p3GoldSpawns)
		
		Settlers.AddSettlers(642, 727, 3, Settlers.CARRIER, p3CarrierSpawns:get())
		Effects.AddEffect(Effects.RMAGIC_GIFTOFGOD, Sounds.AMB_FIRE,642, 727, 0)
	end
end

function spawnGoods(x,y,goodType,varsVariable)
	local amountOfGoods = varsVariable:get() 
	
	while amountOfGoods > 8 do 
		Goods.AddPileEx(x,  y, goodType, 8)
		amountOfGoods = amountOfGoods - 8
	end
	Goods.AddPileEx(x,  y, goodType, floorNumber(amountOfGoods))
end

-------------------------------------------------------------
-----HIER BEGINNT DIE LOGIk FÜR DIE PORTALE------------------
-------------------------------------------------------------

portals =
{
    p1={-- portal 1
		x=499,
		y=862,
		playerToAttack=4
    },
    p2={ -- portal 2
		x=519,
		y=866,
		playerToAttack=5
    },
    p3={ -- portal 3
        x=538,
		y=867,
		playerToAttack=6
    },
    p4={ -- portal 4
		x=557,
		y=868,
		playerToAttack=7
    },
    p5={ -- portal 5
		x=575,
		y=865,
		playerToAttack=8
    }
}

tickCounterPortals = 1
function checkIfUnitInPortal()
	tickCounterPortals = tickCounterPortals + 1
	if tickCounterPortals > 30 then 
		checkPortal(portals.p1)
		checkPortal(portals.p2)
		checkPortal(portals.p3)
		checkPortal(portals.p4)
		checkPortal(portals.p5)
		tickCounterPortals = 1
	end
end

function checkPortal(portal)
	if Settlers.AmountInArea(1, Settlers.SWORDSMAN_01, portal.x, portal.y, 5) > 0 then
		Settlers.KillSelectableSettlers(1, Settlers.SWORDSMAN_01, portal.x, portal.y, 5, 0)
		local amountOfAttackingUnits=getPercentAmountOfPlayerUnits(2,95)
		if isDebug() == 1 then 
			dbg.stm("Spieler 2 greift Spieler " .. portal.playerToAttack .. " mit " .. amountOfAttackingUnits  .. " Einheiten an")
		end
		AI.AttackNow(2,portal.playerToAttack,amountOfAttackingUnits)
		dbg.stm("Die Wikinger schreien dir zu... Wir stehen dir bei deinem Angriff auf Spieler ".. portal.playerToAttack .." zur Seite!")
		Settlers.AddSettlers(514,829, 1, Settlers.SWORDSMAN_01, 1)
		
	end
	
	if Settlers.AmountInArea(1, Settlers.BOWMAN_01, portal.x, portal.y, 5) > 0 then
		Settlers.KillSelectableSettlers(1, Settlers.BOWMAN_01, portal.x, portal.y, 5, 0)
		local amountOfAttackingUnits=getPercentAmountOfPlayerUnits(3,95)
		if isDebug() == 1 then 
			dbg.stm("Spieler 3 greift Spieler " .. portal.playerToAttack .. " mit " .. amountOfAttackingUnits  .. " Einheiten an")
		end
		AI.AttackNow(3,portal.playerToAttack,amountOfAttackingUnits)
		dbg.stm("Die Mayas schreien dir zu... Wir stehen dir bei deinem Angriff auf Spieler ".. portal.playerToAttack .." zur Seite!")
		
		Settlers.AddSettlers(522,829, 1, Settlers.BOWMAN_01, 1)
	end
	

end


-------------------------------------------------------------
-----Ab hier kommen zeitliche Events-------------------------
-------------------------------------------------------------



function doActionsAfterMinutes()
	--wird jede Minute ausgefuehrt
	if newMinute() == 1 then
		doEveryMinute()
	end


	if minuteReached(1) == 1 then
		if isDebug()== 1 then 
			Tutorial.RWM(1)
		else
			Map.SetScreenPos(803,61)
		end
		dbg.stm("König Erdur: Du wagst es mich herauszufordern? Du hast keine Ahnung mit wem du es zu tun hast, hahahaha... ")
		
		if Game.GetDifficulty() == 1 then
			Game.SetFightingStrength(4, 81)
			Game.SetFightingStrength(5, 81)
			Game.SetFightingStrength(6, 81)
			Game.SetFightingStrength(7, 81)
			Game.SetFightingStrength(8, 111)
		end
	end

	if minuteReached(2) == 1 then
		dbg.stm("Ihr erhaltet eine geheime Nachricht!!! Finde die legendäre Insel. Geht dir Stein aus, suche in der Mitte. Die Ecken sind dein Freund.")
	end

	

	if minuteReached(5) == 1 then
		--Wir nochmal neu gesetzt, da die Randomzahl nun zufaellig ist. 
		setNewAttackAmount()
	end
	
	
	if minuteReached(30) == 1 then
		spawnEnemySupportPackage(4,1,1,4,2)
	end
	
	if minuteReached(45) == 1 then
		spawnEnemySupportPackage(5,2,1,6,2)
		setNewAttackAmount()
		if Game.GetDifficulty() == 1 then
			Game.SetFightingStrength(4, 100)
			Game.SetFightingStrength(5, 100)
			Game.SetFightingStrength(6, 100)
			Game.SetFightingStrength(7, 100)
			Game.SetFightingStrength(8, 125)
		end
		
	end
	
	---ENDGAME TIME----
	if minuteReached(getEndgameTime()) == 1 then
		endGame = 1
		spawnEnemySupportPackage(5,2,2,2,2)
        setNewAttackAmount()
		setNewPauseUntilAttack()
		if Game.GetDifficulty() == 1 then
			Game.SetFightingStrength(4, 110)
			Game.SetFightingStrength(5, 110)
			Game.SetFightingStrength(6, 110)
			Game.SetFightingStrength(7, 110)
			Game.SetFightingStrength(8, 130)
		end
		dbg.stm("König Erdur: Du hast lange genug meinen Truppen stand gehalten! Ich werde meine Truppen sammeln, ein jeder wird kämpfen und dir die wahre Stärke meines Königreichs zeigen. Dein lächerlicher Widerstand wird bald ein Ende haben, hahahaha..")
	end
	
	if minuteReached(100) == 1 then
		spawnEnemySupportPackage(6,2,2,3,2)
   	end
	
	if minuteReached(120) == 1 then
		if Game.GetDifficulty() == 1 then
			Game.SetFightingStrength(4, 125)
			Game.SetFightingStrength(5, 125)
			Game.SetFightingStrength(6, 125)
			Game.SetFightingStrength(7, 125)
			Game.SetFightingStrength(8, 140)
		end
   	end
	
	if minuteReached(125) == 1 then
		spawnEnemySupportPackage(7,2,2,3,2)
   	end

end





function doEveryMinute()


	if isAIDebug() == 1 then 
		dbg.stm("Min:" .. Game.Time() .. " OppUn:" .. getAmountOfEnemysUnits() .. " MinOfLaAtt:" .. Vars.Save8 .. " MinAttAmo:" .. getMinAttackAmount() .. " LivHuman:" .. getn(humans) .. " LivOpp:" .. getn(opponents) .. " Pause:" .. getMinTimeBetweenAttacks() .." Endgame:" .. endGame .. " Kampfkraft:" .. Game.GetOffenceFightingStrength(4) .. "/".. Game.GetOffenceFightingStrength(5) .. "/".. Game.GetOffenceFightingStrength(6) .. "/".. Game.GetOffenceFightingStrength(7) .. "/".. Game.GetOffenceFightingStrength(8) )
	end 
	
	--Hier werden die Schwerter, Bögen, Träger ... bei den Verbündeten gespawnt---
	if mod(Game.Time(),2) == 0 then 
		addBoostsToAllies()
	end
	

	--Genereller Spawn
	if Game.Time() >= 20 then 
		if Game.Time() > getEndgameTime() + 10 then
			if Game.Time()  > 130 then 
				spawnEnemySupportPackage(4,2,1,3,1)
			else
				spawnEnemySupportPackage(3,1,1,2,1)
			end
		else
			spawnEnemySupportPackage(2,1,1,2,0)
		end
	end
	
	--Extra Spawn für Schwer
	if Game.Time() >= 35 and Game.GetDifficulty() == 1 then 
		spawnEnemySupportPackage(3,1,1,6,1)
	end
	

	--Extra spawn für Endgame beim König
	if endGame == 1 then 
		Settlers.AddSettlers(782, 117, 8, Settlers.CARRIER, 3)
		Goods.AddPileEx(782,  117, Goods.BATTLEAXE, 1)
		Goods.AddPileEx(782,  117, Goods.BOW, 1)
		Goods.AddPileEx(782, 117, Goods.GOLDBAR, 2)
		if Game.Time()  > 135 then 
			Settlers.AddSettlers(782, 117, 8, Settlers.CARRIER, 1)
			Goods.AddPileEx(782,  117, Goods.SWORD, 1)
		end
	end 
end

-------------------------------------
----MAP SPEZIFISCHE EINSTELLUNGEN----
-------------------------------------


--Ab wievielen Units wird angegriffen--
function setNewAttackAmount()
	if Game.Time() < 50 then
		if Game.GetDifficulty() == 1 then
			attackAmount = randomBetween(450,530)
		else
			attackAmount = randomBetween(430,470)
		end
	else 
		if Game.Time() < getEndgameTime() then
			if Game.GetDifficulty() == 1 then
				attackAmount = randomBetween(600,750)
			else
				attackAmount = randomBetween(550,650)
			end
		else
			if Game.GetDifficulty() == 1 then
				attackAmount = floorNumber(randomBetween(1100,1600) * getn(opponents) / 5)
			else
				attackAmount = floorNumber(randomBetween(1000,1400) * getn(opponents) / 5)
			end
			--anzahl wird reduziert, wenn gegner bereits besiegt wurden. 
			
		end
	end		
end

--Was ist die minimaltste Pause bevor angegriffen wird--
function setNewPauseUntilAttack()
	if endGame == 1 then 
		pauseUntilAttack = randomBetween(16,19)
	else
		pauseUntilAttack = randomBetween(14,18)
	end
end


--Ab wann ist Endgame Time--
function getEndgameTime()

	if Game.GetDifficulty() == 1 then
		return 70
	else
		--warum 71? einfach so
		return 80
	end
end


-------------------------------------------------------------------------------
-- AI Funktionen über die sich das Verhalten der AI konfigurieren lässt--------
-------------------------------------------------------------------------------


function isAIDebug()
	return 0
end

function customCheckIfAttack()
    return 0
end

function getMainPlayerToAttack()
	return 1
end

function getAmoutOfAttackingEnemies()
	if endGame == 1 or Game.GetDifficulty() == 1 then 
		return  getn(opponents)
	else
		--mindestens 4 greifen immer an
		return getn(opponents) - 1
	end
end


function getPercentageAttackingUnits(amountOfAttackingEnemies)
	if endGame == 1 then 
		if Game.GetDifficulty() == 1 then 
			return randomBetween(85,95)
		else
			return randomBetween(80,90)
		end
	else
		if Game.GetDifficulty() == 1 then 
			if Game.Time() < 55 then
                return randomBetween(70,80)
            else
                return randomBetween(80,85)
            end
		else
	        if Game.Time() < 55 then
			    return randomBetween(75,85)
            else
			    return randomBetween(80,90)
            end
		end
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

opponents = {4,5,6,7,8}
humans = {1,2,3}


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
		while counter <= getn (humans) do
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
		while counter <= getn (opponents) do
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
	while counter <= getn (humans) do
		if Game.HasPlayerLost(humans[counter]) ~= 0 then 
			return 1
		end
		counter = counter + 1
	end
	return 0
end 

function isAnyOpponentDefeeted()
	local counter = 1
	while counter <= getn (opponents) do
		if Game.HasPlayerLost(opponents[counter])  ~= 0 then 
			return 1
		end
		counter = counter + 1
	end
	return 0
end


function checkAttack()

    if Vars.Save8 + getMinTimeBetweenAttacks() <= Game.Time() then 
		local amoutOfEnemyUnits = getAmountOfEnemysUnits()
        
        if customCheckIfAttack() ~= 0 then
            startAttack(getMainPlayerToAttack(), "customAttack")
            Vars.Save8 = Game.Time()
        else
            if amoutOfEnemyUnits >= getMinAttackAmount() then
            startAttack(getMainPlayerToAttack(), "minAttackAmount")
            Vars.Save8 = Game.Time()
            else 
                if Vars.Save8 + getMaxTimeBetweenAttacks() <= Game.Time() and Game.Time() >= 40 then
                    startAttack(getMainPlayerToAttack(), "maxTime")
                    Vars.Save8 = Game.Time()
                else
                    local castleBuildingHuman = getIdOfCastleBuildingHuman()
                    if castleBuildingHuman ~= 0 then
                        startAttack(castleBuildingHuman, "castleBuildimg")
                        Vars.Save8 = Game.Time()
                    end
                end
            end
        end
	end
		-- Nach getMinTimeBetweenAttacks() Minuten darf der naechste Angriff erfolgen. 
		--if Vars.Save8 + getMinTimeBetweenAttacks() <= Game.Time() then 
			--Vars.Save8 = 0
		--end
	--end
end



function getIdOfCastleBuildingHuman()
  local counter = 1
  while counter <= getn (humans) do
		if Buildings.ExistsBuildingInArea(humans[counter],Buildings.CASTLE,461,700,1000,Buildings.UNDERCONSTRUCTION)  == 1 then
			return humans[counter]
		end
		counter = counter + 1 
	end
	return 0
end




--Hier wird per zufall die Angriffsstrategie ausgewählt
--Generell gilt die Logik, es kann über die methode getAmoutOfAttackingEnemies definiert werden, wieviele Gegner gleichzeitig angreifen. Es greifen dabei immer die stärksten Gegner an entsprechend der Anzahl ihrer Einheiten. 
--Dabei gibt es verschiedene Angriffsszenarien, die per zufall ausgewählt werden.
function startAttack(mainAttackPlayer,attackCondition)
	
	
	
	local amountOfAttackingEnemies = getAmoutOfAttackingEnemies()
    local getPercentageAttackingUnits = getPercentageAttackingUnits(amountOfAttackingEnemies)
	local randomAttack = randomBetween(1,100)

	local mainPlayer = mainAttackPlayer
	local attackType = ""

	
	if randomAttack <= 0 then
		-- greife alle den main player an
		attackType = "allMain"
		doAttackMainPlayer(amountOfAttackingEnemies, getPercentageAttackingUnits, mainAttackPlayer)
	else
		if randomAttack <= 10 then
			-- 50% der gegner greifen den main spieler an rest ist zufaellig
			attackType = "mostMain"
			doAttackMainPlayerMostEnemies(amountOfAttackingEnemies, getPercentageAttackingUnits, mainAttackPlayer,50)
		else
			if randomAttack <= 55 then
				-- greife gleichmaesig verteilt an
				--dbg.stm("divided")
				attackType = "divided equal"
				doDividedAttack(amountOfAttackingEnemies, getPercentageAttackingUnits)
			else
				if randomAttack <= 65 then
					-- greife einen zufaelligen Spieler als main an
					attackType = "randomMainPlayer"
					mainPlayer = getRandomHuman()
					doAttackMainPlayerMostEnemies(amountOfAttackingEnemies, getPercentageAttackingUnits, mainPlayer,40)
				else			
					-- greife zufallig an --> Default
					attackType = "completeRandom"
					doRandomAttack(amountOfAttackingEnemies, getPercentageAttackingUnits)
				end
			end 
		end
		
	end
	if isAIDebug() == 1 then 
		dbg.stm("Angriff Prozent:" .. getPercentageAttackingUnits .. " Anzahl:" .. amountOfAttackingEnemies.. " AttackType:" .. attackType .. " MainPlayer:" .. mainPlayer .. " Condition:".. attackCondition )
	end
	attackStarted()

end

function doAttackMainPlayer(amountOfAttackingEnemies, getPercentageAttackingUnits, mainAttackPlayer) 
	local position = 1
	while position <= amountOfAttackingEnemies do
		local humanIdToAttack=mainAttackPlayer
		local attackingEnemy=getEnemeyIDWithMostUnitsForPosition(position)
		local amountOfAttackingUnits=getPercentAmountOfPlayerUnits(attackingEnemy,getPercentageAttackingUnits)
		if isAIDebug() == 1 then 
			dbg.stm("Enemy " .. attackingEnemy .. " Human " .. humanIdToAttack .. " Units " .. amountOfAttackingUnits)
		end
		AI.AttackNow(attackingEnemy,humanIdToAttack,amountOfAttackingUnits)
		position = position + 1
	end
end

function doAttackMainPlayerMostEnemies(amountOfAttackingEnemies, getPercentageAttackingUnits, mainAttackPlayer, percentOfEnemiesAttackingMainPlayer) 
	local position = 1
	while position <= amountOfAttackingEnemies do
		local attackrnd = Game.Random100()
		local humanIdToAttack=mainAttackPlayer
		if attackrnd >= percentOfEnemiesAttackingMainPlayer then
			humanIdToAttack = getRandomHuman()
		end
		
		local attackingEnemy=getEnemeyIDWithMostUnitsForPosition(position)
		local amountOfAttackingUnits=getPercentAmountOfPlayerUnits(attackingEnemy,getPercentageAttackingUnits)
		--Das hier wieder rauskommentieren, wenn ihr sehen wollt, welcher Gegner wen angreift
		if isAIDebug() == 1 then 
			dbg.stm("Enemy " .. attackingEnemy .. " Human " .. humanIdToAttack .. " Units " .. amountOfAttackingUnits)
		end
		AI.AttackNow(attackingEnemy,humanIdToAttack,amountOfAttackingUnits)
		position = position + 1
	end
end


function doRandomAttack(amountOfAttackingEnemies, getPercentageAttackingUnits)
	local position = 1
	while position <= amountOfAttackingEnemies do
		local humanIdToAttack=getRandomHuman()
		local attackingEnemy = getEnemeyIDWithMostUnitsForPosition(position)
		local amountOfAttackingUnits=getPercentAmountOfPlayerUnits(attackingEnemy,getPercentageAttackingUnits)
		--Das hier wieder rauskommentieren, wenn ihr sehen wollt, welcher Gegner wen angreift
		if isAIDebug() == 1 then 
			dbg.stm("Enemy " .. attackingEnemy .. " Human " .. humanIdToAttack .. " Units " .. amountOfAttackingUnits)
		end
		AI.AttackNow(attackingEnemy,humanIdToAttack,amountOfAttackingUnits)
		position = position + 1
	end
end

function doDividedAttack(amountOfAttackingEnemies, getPercentageAttackingUnits)
	local position = 1
	local playerIdCounter = randomBetween(1, getn (humans))
	while position <=  amountOfAttackingEnemies do
		local humanIdToAttack=humans[playerIdCounter]
		local attackingEnemy = getEnemeyIDWithMostUnitsForPosition(position)
		local amountOfAttackingUnits=getPercentAmountOfPlayerUnits(attackingEnemy,getPercentageAttackingUnits)
		--Das hier wieder rauskommentieren, wenn ihr sehen wollt, welcher Gegner wen angreift
		if isAIDebug() == 1 then 
			dbg.stm("Enemy " .. attackingEnemy .. " Human " .. humanIdToAttack .. " Units " .. amountOfAttackingUnits)
		end
		AI.AttackNow(attackingEnemy,humanIdToAttack, amountOfAttackingUnits)
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

	local playercache = {0,0,0,0,0,0,0,0}
	
	local i = 1
	-- setzt an die einzelnen stellen innerhalb des playerchache arrays die Einheitenanzahl etsprechend der spielerId
	-- Bpsp {0,0,0,34,12,43,34,34) --> jetzt waeren die letzten fuenf spieler opponents mit der entsprechenden Anzahl Einheiten
	while i <= getn (opponents) do
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



function getPercentAmountOfPlayerUnits(playerId, percent)
    local amountOfPlayerUnits = getAmountOfPlayerUnitsWithoutBuildings(playerId)  / 100 * percent
    return floorNumber(amountOfPlayerUnits)
end


function getRandomHuman()
    local amountOfhumans = getn (humans)
    local playerId = humans[Game.Random(amountOfhumans) +1]
    return playerId
end

function getAmountOfEnemysUnits() 

	local AmoutOfCompleteEnemyMilitary = 0
	local counter = 1
	
	while counter <= getn (opponents) do
		AmoutOfCompleteEnemyMilitary = AmoutOfCompleteEnemyMilitary  + getAmountOfPlayerUnitsWithoutBuildings(opponents[counter])
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
		counter = counter +  1
	end
	return amountOfBuildings
end 


----------------------------------
-- GENERELLE UTILITY METHODEN  ---
----------------------------------





-- gibt wenn die entsprechende Minute erreicht ist einmalig 1 zurueck
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
	if Vars.Save7 ~= Game.Time() then
		Vars.Save7 = Game.Time()
		return 1
	else 
		return 0
	end
end

-- Schneidet Nachkommastellen ab. 
function floorNumber(floatNumber)
	local stringmyValue =  tostring(floatNumber)
	if strfind (stringmyValue, "(%.+)") ~= nil then 
		local valuestring = strsub (stringmyValue, 1, strfind (stringmyValue, "(%.+)"))
		return tonumber(valuestring)
	else
		return floatNumber
	end

end


militaryUnits={Settlers.SWORDSMAN_01,Settlers.SWORDSMAN_02,Settlers.SWORDSMAN_03,Settlers.BOWMAN_01,Settlers.BOWMAN_02,Settlers.BOWMAN_03,Settlers.AXEWARRIOR_01,Settlers.AXEWARRIOR_02,Settlers.AXEWARRIOR_03,Settlers.BLOWGUNWARRIOR_01,Settlers.BLOWGUNWARRIOR_02,Settlers.BLOWGUNWARRIOR_03,Settlers.BACKPACKCATAPULIST_01,Settlers.BACKPACKCATAPULIST_02,Settlers.BACKPACKCATAPULIST_03,Settlers.MEDIC_01,Settlers.MEDIC_02,Settlers.MEDIC_03,Settlers.SQUADLEADER}
-- Anzahl der Soldaten eines Spielers
function getAmountOfPlayerUnits(playerId)
	local amoutOfMilitary = 0
	local counter = 1
	while counter <= getn(militaryUnits) do 
		amoutOfMilitary =  amoutOfMilitary + Settlers.Amount(playerId, militaryUnits[counter])
		counter = counter + 1
	end
	return amoutOfMilitary 
end 

-- Anzahl der Soldaten eines Spielers innerhalb seiner Gebäude
function getUnitsInBuildings(playerId)
	local allUnits = 0
	allUnits = allUnits + Buildings.Amount(playerId, Buildings.GUARDTOWERSMALL, Buildings.READY)
	allUnits = allUnits + Buildings.Amount(playerId, Buildings.GUARDTOWERBIG, Buildings.READY) * 6
	allUnits = allUnits + Buildings.Amount(playerId,Buildings.CASTLE, Buildings.READY) * 8
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

	if seed == 0 or lastSeed < Game.Time()  then 
		seed = getSeed()
		seed = seed - floorNumber(seed)
		lastSeed = Game.Time() 
	end

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
		counter = counter +  1
	end
	return amountOfBuildings
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
    local c = a/b
    local d = strfind("" .. c, "(%.+)")
    if d == nil
    then
        return 0 -- remainder is 0
    end
    c = tonumber(strsub("" .. c, d)) + 0.0000000000005 -- drop everything before . and add a tiny amount
    d = strfind("" .. c*b, "(%.+)")
    if d == nil
    then
        return c*b
    end
    return tonumber(strsub("" .. c*b, 1, d)) -- multiply c with b and drop everything after .
end

