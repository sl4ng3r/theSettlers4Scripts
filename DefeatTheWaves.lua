function new_game()

	--wird fuer minute events benoetigt.
	Vars.Save8 = 0

	--Anzahl an Spielern
	Vars.Save1 = 0

	--WAVE Number
	Vars.Save2 = 0

	-- Miute of last Wave
	Vars.Save3 = 0

	-- Difficulty
	Vars.Save4 = 0

	-- GotTempleBoni
	Vars.Save5 = 0

	-- Priests to sac
	Vars.Save6 = 0

	testfunction()

	MinuteEvents.new_game()
	request_event(doActionsAfterMinutes, Events.FIVE_TICKS)
	request_event(doChecks, Events.FIVE_TICKS)
	request_event(cheatProtection, Events.FIVE_TICKS)
	request_event(initGame,Events.FIRST_TICK_OF_NEW_OR_LOADED_GAME)
	request_event(Siegbedingung, Events.VICTORY_CONDITION_CHECK)

	dbg.stm("Willkommen bei Defeat the Waves! Aus 6 Ecken werden euch Gegner Wellen angreifen, die mit der Zeit immer stärker werden. Ihr könnt die Wellen der entsprechenden Einheiten stoppen, indem ihr deren Lager in den einzelnen Ecken besiegt. (Zwei Lager befinden sich auf Inseln ;-)). Nach 15 Minuten gehts los, also gebt Gas!! Viel Spaß :-D")



end



function register_functions()
	reg_func(Siegbedingung)
	reg_func(doActionsAfterMinutes)
	reg_func(initGame)
	reg_func(doChecks)
	reg_func(cheatProtection)
	MinuteEvents.register_functions()
end



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
		Settlers.AddSettlers(395, 480, 1, Settlers.BOWMAN_03, 1000)
        Settlers.AddSettlers(420, 470, 1, Settlers.PRIEST, 20)

		--player3
		Settlers.AddSettlers(471, 386, 3, Settlers.BOWMAN_03, 1000)


		Game.SetFightingStrength(1, 120)

	end


	if isDebug() == 1 then
		dbg.stm("debug an")



		dbg.stm("aktuelles Mana7:" .. Magic.CurrentManaAmount(7) .. " fightStr:" .. Game.GetOffenceFightingStrength(6) .. "/" .. Game.GetOffenceFightingStrength(7) .. "/" .. Game.GetOffenceFightingStrength(8) )
		Buildings.AddBuilding(386, 397, 1, Buildings.STORAGEAREA)
		Buildings.AddBuilding(475, 410, 3, Buildings.STORAGEAREA)
	end
end

function startFinalWave()
	Vars.Save2 = 11
	--Vars.Save1 = 1
	--Vars.Save4 = difficultyChooser.extreme.difficulty
	finalWave()

end

function Siegbedingung()
  Game.DefaultPlayersLostCheck()
  if Game.HasPlayerLost(1) == 1 then
	Game.PlayerLost(2)
	Game.PlayerLost(3)
	Game.PlayerLost(4)
	Game.PlayerLost(5)
	dbg.stm("Spieler 1 wurde besiegt! Ihr habt verloren.")
	dbg.stm("Ihr habt bis Minute " .. Game.Time() .. " durchgehalten!")
  end
  Game.DefaultGameEndCheck()
end

islands= {
	lu={
		x=120,
		y=254,
		radius=20
	},
	ld={
		x=305,
		y=705,
		radius=55
	},
	ru={
		x=730,
		y=664,
		radius=20
	},
	rd={
		x=500,
		y=127,
		radius=55
	}
}


players= {
	p1={
		x=411,
		y=482,
		ai=0,
		id=1,
		amountOfStartBuildings=17
	},
	p2={
		x=479,
		y=494,
		ai=0,
		id=2,
		amountOfStartBuildings=16
	},
	p3={
		x=471,
		y=393,
		ai=0,
		id=3,
		amountOfStartBuildings=15
	},
	p4={
		x=351,
		y=293,
		ai=0,
		id=4,
		amountOfStartBuildings=15
	},
	p5={
		x=309,
		y=355,
		ai=0,
		id=5,
		amountOfStartBuildings=16
	}
}


spawnpoints={
		--left
		sp1={
			settlerType1=Settlers.MEDIC_01,
			settlerType2=Settlers.SWORDSMAN_02,
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



difficultyChooser= {
	normal={
		x=52,
		y=863,
		difficulty=1
	},
	hard={
		x=74,
		y=873,
		difficulty=3
	},
	extreme={
		x=89,
		y=866,
		difficulty=6
	}
}

function initGame()

	if isDebug() == 1 then
		Tutorial.RWM(1)
	end


	--Alle CPU deaktivieren
	dbg.aioff(1)
	dbg.aioff(2)
	dbg.aioff(3)
	dbg.aioff(4)
	dbg.aioff(5)
	AI.SetPlayerVar(6, "AttackMode", 3,3,3)
	AI.SetPlayerVar(7, "AttackMode", 1,1,1)
	AI.SetPlayerVar(8, "AttackMode", 3,3,3)


	startWaveAt(15)
	startWaveAt(22)
	startWaveAt(29)
	startWaveAt(35)
	startWaveAt(40)
	startWaveAt(45)
	startWaveAt(50)
	startWaveAt(54)
	startWaveAt(58)
	startWaveAt(62)
	startWaveAt(66)
    startWaveAt(70)

	--requestMinuteEvent(startWave,71)

	-- Die welle kommt frueher, je mehr Mitspieler
	if Game.Time() > 7 then
		setFinalWave()
	end

	local attackTime = getWinTime() + 2
	while attackTime <= 200 do
		requestMinuteEvent(startWave,attackTime)
		attackTime = attackTime + 5
	end

	--Entferne die BigTowers
    if Game.Time() <= 1 then
        removeBigTowerAtPossitionForPlayer(63,850,1)
        removeBigTowerAtPossitionForPlayer(647,607,2)
        removeBigTowerAtPossitionForPlayer(180,211,5)
    end
	--Message zum waehlen der Schwirigkeit
	requestMinuteEvent(msgDifficulty,1)

	--Die Schwierigkeit wird nach 4 minuten abgeprüft.
	requestMinuteEvent(checkDifficulty,4)

	--Hier wir ueberprueft, wer alles CPU Spieler ist
	requestMinuteEvent(checkAIs,getTimeToCheckAIs())

	--requestMinuteEvent(checkAIs,5)
	requestMinuteEvent(gameWon,getWinTime())

    checkSpawnPointDefeted()
end

function getTimeToCheckAIs()
	return 7
end

function startWaveAt(startTime)
	requestMinuteEvent(startWave,startTime)
end

function msgDifficulty()
	dbg.stm("Spieler 1, wähle bitte auf der Karte unten links die gewünschte Schwierigkeit für diese Runde, indem du deinen Hauptmann in den entsprechenden Kreis schickst.")
end

function gameWon()
	if Game.HasPlayerLost(1) == 0 then
		Tutorial.Won()
		dbg.stm("Herzlichen Glückwunsch!!! Das Spiel ist gewonnen. Ihr könnt dennoch weiterspielen und schauen, wie lange ihr durchhaltet.. :D")
	end
end




function checkDifficulty()

	local amountOfSoldiers = Settlers.AmountInArea(1, Settlers.SWORDSMAN_03, 906,1003, 8)
	if amountOfSoldiers > 0 then
		Settlers.KillSelectableSettlers(1, Settlers.SWORDSMAN_03, 906,1003, 5, 0)
		Vars.Save4 = amountOfSoldiers
	end
	dbg.stm("Ihr habt euch für eine Partie der Stufe " .. Vars.Save4 .. " entschieden!")


	--checkChooser(difficultyChooser.normal)
	--checkChooser(difficultyChooser.hard)
	--checkChooser(difficultyChooser.extreme)

	if Vars.Save4 < difficultyChooser.hard.difficulty then
		dbg.stm("Es sollte eine leichte Partie werden.")
		Buildings.AddBuilding(61, 845, 1, Buildings.EYECATCHER03)
		players.p1.amountOfStartBuildings = players.p1.amountOfStartBuildings + 1
	elseif Vars.Save4 < difficultyChooser.extreme.difficulty then
		dbg.stm("Ihr werdet euch schon anstrengen müssen!")
		Buildings.AddBuilding(61, 845, 1, Buildings.EYECATCHER03)
		Buildings.AddBuilding(61, 851, 1, Buildings.EYECATCHER03)
		players.p1.amountOfStartBuildings = players.p1.amountOfStartBuildings + 2
	else
		dbg.stm("Ihr spielt eine extrem harte Partie! Dann mal viel Glück!")
		Buildings.AddBuilding(61, 845, 1, Buildings.EYECATCHER03)
		Buildings.AddBuilding(61, 851, 1, Buildings.EYECATCHER03)
		Buildings.AddBuilding(67, 852, 1, Buildings.EYECATCHER03)
		players.p1.amountOfStartBuildings = players.p1.amountOfStartBuildings + 3
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
		Settlers.KillSelectableSettlers(1,Settlers.SQUADLEADER, chooser.x, chooser.y, 5, 0)
		Vars.Save4 = chooser.difficulty;
	end

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

	--Amount of Sac Points setzen
	Vars.Save6 = counterOfPlayer * getAmountForOnePlayerForBonus()

	dbg.stm("Ihr spielt eine Partie für " .. counterOfPlayer .. " Spieler")
	setFinalWave()


  --requestMinuteEvent(finalWave,getWinTime() - (5 + Vars.Save1))
end

function getAmountForOnePlayerForBonus()
	return 3
end

function setFinalWave()
    local waveTime = 0
    if Vars.Save1 == 1 or Vars.Save1 == 2 then
        waveTime = getWinTime() - 9
    elseif Vars.Save1 == 3 or Vars.Save1 == 4 then
        waveTime = getWinTime() - 10
    else
        waveTime = getWinTime() - 11
    end

	if isDebug() == 1 then
		dbg.stm("Final wave time:" .. waveTime)
	end
	requestMinuteEvent(finalWave,waveTime)

end

function checkIfDestroyParty(theplayer)
	if getAmoutOfBuildings(theplayer.id)  == theplayer.amountOfStartBuildings then
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

	local radius
	if Vars.Save4 <= difficultyChooser.normal.difficulty then
		radius = 17 -  (( amountPlayers -1 ) * 3)
	end

	if Vars.Save4 <= difficultyChooser.extreme.difficulty then
		radius = 15 - (( amountPlayers -1 ) * 3)
	end

	if amountPlayers == 5 then
		radius = 0
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
	spawnSpawnPoint(spawnpoints.sp2,spawnpoints.sp2)
	spawnSpawnPoint(spawnpoints.sp3,spawnpoints.sp3)
	spawnSpawnPoint(spawnpoints.sp4,spawnpoints.sp4)
	spawnSpawnPoint(spawnpoints.sp4,spawnpoints.sp4)
	spawnSpawnPoint(spawnpoints.sp5,spawnpoints.sp5)
	spawnSpawnPoint(spawnpoints.sp6,spawnpoints.sp6)

	--Extra Schwert und Axt
	if Vars.Save4 >= difficultyChooser.hard.difficulty then
		spawnSpawnPointSpecific(spawnpoints.sp3,spawnpoints.sp3, spawnpoints.sp3.settlerType3, 3 * Vars.Save1)
		spawnSpawnPointSpecific(spawnpoints.sp6,spawnpoints.sp6, spawnpoints.sp6.settlerType3, 3 * Vars.Save1)
	end

	doRandomSpawnOnEachSpawnpoint()
	doRandomSpawnOnEachSpawnpoint()



	AI.NewSquad(6, AI.CMD_SUICIDE_MISSION )
	AI.NewSquad(7, AI.CMD_SUICIDE_MISSION )
	AI.NewSquad(8, AI.CMD_SUICIDE_MISSION )
end

---Eine welle startet
function startWave()

  Vars.Save2 = Vars.Save2 + 1
  Vars.Save3 = Game.Time()



	if Vars.Save4 < difficultyChooser.hard.difficulty then
		addFightingStrength(4)
	elseif Vars.Save4 < difficultyChooser.extreme.difficulty then
		addFightingStrength(6)
	else
		addFightingStrength(8)
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
	spawnAmbush()

  AI.NewSquad(6, AI.CMD_SUICIDE_MISSION )
  AI.NewSquad(7, AI.CMD_SUICIDE_MISSION )
  AI.NewSquad(8, AI.CMD_SUICIDE_MISSION )

  if isDebug() == 1 then
      dbg.stm("ChaosRound:" .. chaosRound .. " AttMin:" .. Game.Time() .. " wave:" .. Vars.Save2 .. " ---amLvl1:" .. getAmountLvl1() .. " amLvl2:" .. getAmountLvl2() .. " amLvl3:" .. getAmountLvl3() ..  " rndAm:" .. getAmountRandomUnits() .. " addRndmHard:" .. getAdditionalRandomUnitsHard().. " addRndmExt:" .. getAdditionalRandomUnitsExtreme() .. "--- aktueller Abzug:" .. getAmountRemoveForPlayers() .. " aktuelles Mana7:" .. Magic.CurrentManaAmount(7) .. " fightStr:" .. Game.GetOffenceFightingStrength(6) .. "/" .. Game.GetOffenceFightingStrength(7) .. "/" .. Game.GetOffenceFightingStrength(8) )
  end


end

function spawnAmbush()
	-- todo random spawn point
	local randomValue = randomBetween(1,100)
	if Vars.Save4 >= difficultyChooser.extreme.difficulty and randomValue <= 35 and Vars.Save2 > 1 then

		local randomUnits = {Settlers.SWORDSMAN_02, Settlers.SWORDSMAN_03,Settlers.BOWMAN_02}
		local unitIndex = randomBetween(1,getn(randomUnits))

		dbg.stm("Ein Hinterhalt!!! Es wurden Truppen in euren Lagern gesichtet!")
		Settlers.AddSettlers(388, 397, 7, randomUnits[unitIndex],getAmountRandomUnits() + Vars.Save2)
		unitIndex = randomBetween(1,getn(randomUnits))
		Settlers.AddSettlers(388, 397, 7, randomUnits[unitIndex], getAdditionalRandomUnitsHard())
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

function spawnSpawnPointSpecific(spawnpointCheck, spawnpoint, settlerType,  amoutOfUnits)
	if spawnpointCheck.defeated == 0 then
		Settlers.AddSettlers(spawnpoint.x,spawnpoint.y, spawnpointCheck.player, settlerType, amoutOfUnits)
	end
end

function spawnSpawnPoint(spawnpointCheck, spawnpoint)

  if spawnpointCheck.defeated == 0 then
	  Settlers.AddSettlers(spawnpoint.x,spawnpoint.y, spawnpointCheck.player, spawnpointCheck.settlerType1, getAmountLvl1())
	  Settlers.AddSettlers(spawnpoint.x,spawnpoint.y, spawnpointCheck.player, spawnpointCheck.settlerType2, getAmountLvl2())
	  Settlers.AddSettlers(spawnpoint.x,spawnpoint.y, spawnpointCheck.player, spawnpointCheck.settlerType3, getAmountLvl3())
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

		local randomUnits = {Settlers.SWORDSMAN_02, Settlers.SWORDSMAN_03,Settlers.BOWMAN_01,Settlers.BOWMAN_02,Settlers.BOWMAN_03}
		if Vars.Save4 >= difficultyChooser.hard.difficulty then
			randomUnits = {Settlers.SWORDSMAN_03,Settlers.BOWMAN_02,Settlers.BOWMAN_03}
		end
		if Vars.Save4 >= difficultyChooser.extreme.difficulty then
			randomUnits = {Settlers.SWORDSMAN_03,Settlers.BOWMAN_03}
		end

		local amountOfSpawns = 1 + floorNumber(Vars.Save4 / 3)

		while amountOfSpawns > 0  do
			local unitIndex = randomBetween(1,getn(randomUnits))
			Settlers.AddSettlers(spawnPoint.x, spawnPoint.y, spawnpointCheck.player, randomUnits[unitIndex],getAmountRandomUnits())
			amountOfSpawns = amountOfSpawns -  1
		end
		unitIndex = randomBetween(1,getn(randomUnits))
		Settlers.AddSettlers(spawnPoint.x, spawnPoint.y, spawnpointCheck.player, randomUnits[unitIndex],getAmountRandomUnitsDiff())
	end
end



function getAmountRandomUnits()
    return floorNumber(0.02 * Vars.Save2 * Vars.Save2 + 0.02 * Vars.Save2 ) * Vars.Save1
end

function getAmountRandomUnitsDiff()
	return floorNumber(0.4 * Vars.Save2 * getDifficultyMultiplier() ) * Vars.Save1
end


function getDifficultyMultiplier()
	return (0.1 * Vars.Save4 + 0.9)
end

function getAmountLvl1()
	return max(0,(3 - Vars.Save2)) * getDifficultyMultiplier() * Vars.Save1
end

function getAmountLvl2()
	return floorNumber((0.5 * Vars.Save2 + 0.0004 * Vars.Save2 * Vars.Save2* Vars.Save2 * Vars.Save2 + 0.4 * Vars.Save4 + 0.2)* getDifficultyMultiplier() * Vars.Save1 - getAmountRemoveForPlayers())
end

function getAmountLvl3()
	return floorNumber((0.0095 * Vars.Save2 * Vars.Save2 * Vars.Save2 + 0.4 * Vars.Save2 + 0.3 * Vars.Save4) * getDifficultyMultiplier()) * Vars.Save1 - getAmountRemoveForPlayers()
	--return max(0,floorNumber((0.014 * Vars.Save2 * Vars.Save2 * Vars.Save2 + 0.4 * Vars.Save2) *(0.08*Vars.Save4 + 0.5)) * Vars.Save1 - getAmountRemoveForPlayers())
end

function getAmountRemoveForPlayers()
	return floorNumber(0.09 * Vars.Save2 * Vars.Save2 * 0.3 * (Vars.Save1 - 1) * (Vars.Save1 - 1) + max(0, 0.6 * Vars.Save1 -1) + 0.2 * Vars.Save2 * minNumber(1,  Vars.Save1-1))
			---(Vars.Save1 - 1)) + 0.2 * Vars.Save2 * minNumber(1, Vars.Save1 - 1) )
end
tickCounter = 1
function cheatProtection()
	tickCounter = tickCounter + 5
	if tickCounter >= 100 then

		removeGoodsOnIslands()
		removeSpecialists()
		tickCounter = 1
	end



end


function removeGoodsOnIslands()
	removeGoodsOnIsland(islands.lu)
	removeGoodsOnIsland(islands.ld)
	removeGoodsOnIsland(islands.ru)
	removeGoodsOnIsland(islands.rd)
end

function removeGoodsOnIsland(island)
	Goods.Delete(island.x,island.y,island.radius,Goods.BOARD)
	Goods.Delete(island.x,island.y,island.radius,Goods.STONE)
	Goods.Delete(island.x,island.y,island.radius,Goods.HAMMER)
end

function removeSpecialists()
		local player = 1

		--IDs der Gebaeude gehen von 1 - 83
		while player <= Vars.Save1 do
			removeSpecialistNearSpawnpoint(spawnpoints.sp1,player)
			removeSpecialistNearSpawnpoint(spawnpoints.sp2,player)
			removeSpecialistNearSpawnpoint(spawnpoints.sp3,player)
			removeSpecialistNearSpawnpoint(spawnpoints.sp4,player)
			removeSpecialistNearSpawnpoint(spawnpoints.sp5,player)
			removeSpecialistNearSpawnpoint(spawnpoints.sp6,player)
			index = index +  1
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


tickCounter2 = 1

function doChecks()
	tickCounter2 = tickCounter2 + 5
	if tickCounter2 >= 250 then
		checkSpawnPointDefeted()
		checkBonus()
		checkSacs()
		tickCounter2 = 1
	end

end

function checkSacs()
	if Game.Time() > getTimeToCheckAIs() then
		local sacPoints
		local amountOfPriestOnSacPoints = getPointsFromSacPoint(394,233) + getPointsFromSacPoint(462,623)

		if amountOfPriestOnSacPoints > 0 then

			sacPoints = amountOfPriestOnSacPoints

			while amountOfPriestOnSacPoints >= Vars.Save6 do
				amountOfPriestOnSacPoints = amountOfPriestOnSacPoints - Vars.Save6
				Vars.Save6 = getAmountForOnePlayerForBonus() * getAmountOfLivingPlayers()
				dbg.stm("Ihr hört eine durchdringende Stimme.... Euer Opfer soll belohnt werden. Diese Truppen sollen euch im Kampf unterstützen.. ")
				spawnBonusForLivingPlayers(3 + Vars.Save1)
			end

			Vars.Save6 = Vars.Save6 - amountOfPriestOnSacPoints
			dbg.stm("Eure " .. sacPoints .. " Priester wurden geopfert. Ihr benötigt noch weitere  " .. Vars.Save6 .. " Priester für weitere Verstärkung")
		end
	end

end

function getAmountOfLivingPlayers()
	local counter = 1
	local amountOfPlayers = 0
	while counter <= 5  do
		if Game.HasPlayerLost(counter) == 0 then
			amountOfPlayers = amountOfPlayers + 1
		end
		counter = counter + 1
	end
	return amountOfPlayers
end

function getPointsFromSacPoint(x, y)
	local counter = 1
	local amountOfUnits
	local finalAmount = 0
	while counter <= 5  do
		if Game.HasPlayerLost(counter) == 0 then
			amountOfUnits = Settlers.AmountInArea(counter, Settlers.PRIEST,x, y, 15)
			if amountOfUnits > 0 then
				Settlers.KillSelectableSettlers(counter, Settlers.PRIEST,x, y, 15, 0)
				finalAmount = finalAmount + amountOfUnits
			end
		end
		counter = counter + 1
	end
	return finalAmount
end



function checkBonus()
	local counter = 1
	local allReady = 1

	if Vars.Save5 == 0  and  Game.Time() > getTimeToCheckAIs() then
		while (counter <= 5  and allReady == 1) do
			if Game.HasPlayerLost(counter) == 0 then
				if  Buildings.Amount(counter, Buildings.BIGTEMPLE, Buildings.READY) == 0 then
					allReady = 0
				end
			end
			counter = counter + 1
		end
		if allReady == 1 and getAmountOfLivingPlayers() > 0 then
			spawnBonusForLivingPlayers(6)
			dbg.stm("Ihr hört eine durchdringende Stimme.... Eure Tempel sind ein Beweiß eures Glaubens.. Dies soll belohnt werden. Diese Truppen sollen euch im Kampf unterstützen.. Opfert weitere Priester und ihr sollt entlohnt werden..  ")
			Vars.Save5 = 1
		end
	end

end

function spawnBonusForLivingPlayers(amountUnits)
	local counter = 1
	while counter <= 5  do
		if Game.HasPlayerLost(counter) == 0 then
			Settlers.AddSettlers(396,390, counter, Settlers.BOWMAN_03, amountUnits)

		end
		counter = counter + 1
	end
end

function checkSpawnPointDefeted()
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
end

function isSpawnPointDefeted(spawnPoint)
    if spawnPoint.defeated == 0 then
        if Settlers.AmountInArea(spawnPoint.player, spawnPoint.settlerType1, spawnPoint.settlersX, spawnPoint.settlersY, 50) == 0  and Settlers.AmountInArea(spawnPoint.player, spawnPoint.settlerType2, spawnPoint.settlersX, spawnPoint.settlersY, 50) == 0 and Settlers.AmountInArea(spawnPoint.player, spawnPoint.settlerType3, spawnPoint.settlersX, spawnPoint.settlersY, 50) == 0 then
            dbg.stm(spawnPoint.defeatMessage)
            spawnPoint.defeated = 1
        end
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

function minNumber(number1, number2)
	if number1 < number2 then
		return number1
	else
		return number2
	end
end

function maxNumber(number1, number2)
	if number1 > number2 then
		return number1
	else
		return number2
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
----
---function randomBetween(fromNumber, toNumber)
---	local divNumber = toNumber - fromNumber
---	local randomNumber = fromNumber + Game.Random(divNumber + 1)
---	return randomNumber
---end
----


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

function requestEveryMinuteEvent(eventfunc,minutes)
  if MinuteEvents._minuteEventTable[minute] == nil then
    MinuteEvents._minuteEventTable[minute] = {}
  end
  tinsert(MinuteEvents._minuteEventTable[minute],eventfunc)
end

