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

castlePositions={
	p1={
		x=300,
		y=460,
	},
	p2={
		x=300,
		y=540,
	},
	p3={
		x=700,
		y=540,
	},
	p4={
		x=700,
		y=460,
	}
}

towerPositions={
	p1={
		t1={
			x=455,
			y=400,
			player=1,
		},
		t2={
			x=415,
			y=260,
			player=1,
		}
	},
	p2={
		t1={
			x=455,
			y=590,
			player=2,
		},
		t2={
			x=455,
			y=720,
			player=2,
		}
	},
	p3={
		t1={
			x=545,
			y=600,
			player=3,
		},
		t2={
			x=585,
			y=740,
			player=3,
		}
	},
	p4={
		t1={
			x=545,
			y=410,
			player=4,
		},
		t2={
			x=545,
			y=280,
			player=4,
		}
	}
}

spawnPositions={
	t1={
		s1={
			x=50,
			y=340,
			attacker=7,
			mainUnit=Settlers.SWORDSMAN_01,
			secondUnit=Settlers.BOWMAN_01,
			sideUnit=Settlers.MEDIC_01,
		},
		s2={
			x=50,
			y=340,
			attacker=8,
			mainUnit=Settlers.SWORDSMAN_01,
			secondUnit=Settlers.BOWMAN_01,
			sideUnit=Settlers.AXEWARRIOR_01,
		},
	},
	t2={
		s1={
			x=950,
			y=660,
			attacker=5,
			mainUnit=Settlers.SWORDSMAN_01,
			secondUnit=Settlers.BOWMAN_01,
			sideUnit=Settlers.MEDIC_01,
		},
		s2={
			x=950,
			y=660,
			attacker=6,
			mainUnit=Settlers.SWORDSMAN_01,
			secondUnit=Settlers.BOWMAN_01,
			sideUnit=Settlers.AXEWARRIOR_01,
		},
	},
	p1={
		s1={
			x=90,
			y=210,
			attacker=7,
			mainUnit=Settlers.SWORDSMAN_01,
			secondUnit=Settlers.BOWMAN_01,
			sideUnit=Settlers.MEDIC_01,
		},
		s2={
			x=150,
			y=150,
			attacker=8,
			mainUnit=Settlers.SWORDSMAN_01,
			secondUnit=Settlers.BOWMAN_01,
			sideUnit=Settlers.AXEWARRIOR_01,
		},
	},
	p2={
		s1={
			x=75,
			y=520,
			attacker=7,
			mainUnit=Settlers.SWORDSMAN_01,
			secondUnit=Settlers.BOWMAN_01,
			sideUnit=Settlers.MEDIC_01,
		},
		s2={
			x=125,
			y=660,
			attacker=8,
			mainUnit=Settlers.SWORDSMAN_01,
			secondUnit=Settlers.BOWMAN_01,
			sideUnit=Settlers.AXEWARRIOR_01,
		},
	},
	p3={
		s1={
			x=910,
			y=790,
			attacker=5,
			mainUnit=Settlers.SWORDSMAN_01,
			secondUnit=Settlers.BOWMAN_01,
			sideUnit=Settlers.MEDIC_01,
		},
		s2={
			x=850,
			y=850,
			attacker=6,
			mainUnit=Settlers.SWORDSMAN_01,
			secondUnit=Settlers.BOWMAN_01,
			sideUnit=Settlers.AXEWARRIOR_01,
		},
	},
	p4={
		s1={
			x=925,
			y=480,
			attacker=5,
			mainUnit=Settlers.SWORDSMAN_01,
			secondUnit=Settlers.BOWMAN_01,
			sideUnit=Settlers.MEDIC_01,
		},
		s2={
			x=875,
			y=340,
			attacker=6,
			mainUnit=Settlers.SWORDSMAN_01,
			secondUnit=Settlers.BOWMAN_01,
			sideUnit=Settlers.AXEWARRIOR_01,
		},
	},
}

lightningPositions={
	t1={
		x1=470,
		y1=480,
		x2=515,
		y2=520,
	},
	t2={
		x1=485,
		y1=480,
		x2=530,
		y2=520,
	},
}


function new_game()
    MinuteEvents.new_game()
	request_event(Siegbedingung, Events.VICTORY_CONDITION_CHECK)
    request_event(doActionsAfterMinutes, Events.FIVE_TICKS)
    request_event(initGame, Events.FIRST_TICK_OF_NEW_OR_LOADED_GAME)
	request_event(lightningBlockade, Events.FIVE_TICKS)

	greeting()
end

function greeting()
	dbg.stm("Willkommen bei dem Spielmodus Fuel The Waves! Ihr tretet 2vs2 gegeneinander an! Ab Minute 20 werden euch im 10 Minuten Takt die Verbündeten des Gegnerteams angreifen - fällt eine eurer Burgen, so habt ihr verloren! Wenn ihr die gegnerischen Außenposten versenkt, so werden eure eigenen Verbündeten deutlich mächtiger und die Mitte wird passierbarer! Viel Erfolg!")
end

function register_functions()
	reg_func(Siegbedingung)
    reg_func(doActionsAfterMinutes)
    reg_func(initGame)
	reg_func(lightningBlockade)
    MinuteEvents.register_functions()
end

--- Ein Debug schalter. Habe damit bei der Entwicklung gute Erfahrungen gemacht.
function isDebug()
    return FALSE;
end

--- Vars.Save8 und Vars.Save9 werden reserviert, da sie in Funktionen genutzt werden. Möchtet ihr die Vars Variablen verwenden und nicht das VarsExt Framework, müsst ihr diese hier
--- reservieren.
VarsExt.occupy(8)
VarsExt.occupy(9)

--- So solltet ihr Variablen setzten, die ihr nach dem Laden noch braucht. Das VarsExt hat die Limitierung auf nur 9 Variablen um ein vielfaches erhöht.
hauptwave = VarsExt.create(2)
sidewave1team1 = VarsExt.create(2)
sidewave2team1 = VarsExt.create(2)
sidewave3team1 = VarsExt.create(2)
sidewave4team1 = VarsExt.create(2)
sidewave1team2 = VarsExt.create(2)
sidewave2team2 = VarsExt.create(2)
sidewave3team2 = VarsExt.create(2)
sidewave4team2 = VarsExt.create(2)

lightningCount1 = VarsExt.create(2)
lightningCount2 = VarsExt.create(2)

--- Hier kommen Initialisierungen hin, die bei start oder laden ausgefuehrt werden sollen
function initGame()

    if isDebug() == TRUE then
        ---Deckt die Karte auf
        Tutorial.RWM(1)
        dbgTestFunction()
    end

	initAI()

	requestMinuteEvent(startWave,20)
	requestMinuteEvent(startWave,30)
	requestMinuteEvent(startWave,40)
	requestMinuteEvent(startWave,50)
	requestMinuteEvent(startWave,60)
	requestMinuteEvent(startWave,70)
	requestMinuteEvent(startWave,80)
	requestMinuteEvent(startWave,90)
	requestMinuteEvent(startWave,100)
	requestMinuteEvent(startWave,110)
	requestMinuteEvent(startWave,120)

end

function dbgTestFunction()
    -- Hier könnt ihr code zum Testen hinschreiben.
    dbg.stm("dbgTestFunction: debug mode an")

	Settlers.AddSettlers(castlePositions.p1.x, castlePositions.p1.y, 1, Settlers.BOWMAN_03, 200)
	Settlers.AddSettlers(castlePositions.p2.x, castlePositions.p2.y, 2, Settlers.BOWMAN_03, 200)
	Settlers.AddSettlers(castlePositions.p3.x, castlePositions.p3.y, 3, Settlers.BOWMAN_03, 200)
	Settlers.AddSettlers(castlePositions.p4.x, castlePositions.p4.y, 4, Settlers.BOWMAN_03, 200)

	Game.SetFightingStrength(1, 150)
	Game.SetFightingStrength(2, 150)
	Game.SetFightingStrength(3, 150)
	Game.SetFightingStrength(4, 150)

	requestMinuteEvent(startWave,1)
	requestMinuteEvent(startWave,2)
	requestMinuteEvent(startWave,3)
	requestMinuteEvent(startWave,4)
	requestMinuteEvent(startWave,5)
	requestMinuteEvent(startWave,6)
	requestMinuteEvent(startWave,7)
	requestMinuteEvent(startWave,8)
	requestMinuteEvent(startWave,9)
	requestMinuteEvent(startWave,10)

end

function doActionsAfterMinutes()
    --wird jede Minute ausgefuehrt
    if newMinute() == 1 then
        -- dbg.stm("1 min ist rum -> +20 Swordsmen.")
		-- Settlers.AddSettlers(650, 500, 1, Settlers.SWORDSMAN_03, 20)
    end
end

function initAI()
	--Alle CPU deaktivieren
	dbg.aioff(1)
	dbg.aioff(2)
	dbg.aioff(3)
	dbg.aioff(4)
	AI.SetPlayerVar(5, "AttackMode", 3,3,3)
	AI.SetPlayerVar(6, "AttackMode", 3,3,3)
	AI.SetPlayerVar(7, "AttackMode", 3,3,3)
	AI.SetPlayerVar(8, "AttackMode", 3,3,3)

	Game.SetFightingStrength(5, 90)
	Game.SetFightingStrength(6, 90)
	Game.SetFightingStrength(7, 90)
	Game.SetFightingStrength(8, 90)
end

function startWave()

	hauptwave:save(hauptwave:get() + 1)
	dbg.stm("Achtung, Wave #" .. hauptwave:get())


	spawnWaveOnMainSpawn(spawnPositions.t1.s1, (calculateMainAmount(hauptwave:get())))
	spawnWaveOnMainSpawn(spawnPositions.t1.s2, calculateMainAmount(hauptwave:get()))
	spawnWaveOnMainSpawn(spawnPositions.t2.s1, calculateMainAmount(hauptwave:get()))
	spawnWaveOnMainSpawn(spawnPositions.t2.s2, calculateMainAmount(hauptwave:get()))


	if (isTowerStanding(towerPositions.p1.t1) == FALSE) then
		sidewave1team1:save(sidewave1team1:get() + 1)
		spawnWaveOnSideSpawn(spawnPositions.p1.s1, calculateSideAmount(sidewave1team1:get()))
	end
	if (isTowerStanding(towerPositions.p1.t2) == FALSE) then
		sidewave2team1:save(sidewave2team1:get() + 1)
		spawnWaveOnSideSpawn(spawnPositions.p1.s2, calculateSideAmount(sidewave2team1:get()))
	end

	if (isTowerStanding(towerPositions.p2.t1) == FALSE) then
		sidewave3team1:save(sidewave3team1:get() + 1)
		spawnWaveOnSideSpawn(spawnPositions.p2.s1, calculateSideAmount(sidewave3team1:get()))
	end
	if (isTowerStanding(towerPositions.p2.t2) == FALSE) then
		sidewave4team1:save(sidewave4team1:get() + 1)
		spawnWaveOnSideSpawn(spawnPositions.p2.s2, calculateSideAmount(sidewave4team1:get()))
	end

	if (isTowerStanding(towerPositions.p3.t1) == FALSE) then
		sidewave1team2:save(sidewave1team2:get() + 1)
		spawnWaveOnSideSpawn(spawnPositions.p3.s1, calculateSideAmount(sidewave1team2:get()))
	end
	if (isTowerStanding(towerPositions.p3.t2) == FALSE) then
		sidewave2team2:save(sidewave2team2:get() + 1)
		spawnWaveOnSideSpawn(spawnPositions.p3.s2, calculateSideAmount(sidewave2team2:get()))
	end

	if (isTowerStanding(towerPositions.p4.t1) == FALSE) then
		sidewave3team2:save(sidewave3team2:get() + 1)
		spawnWaveOnSideSpawn(spawnPositions.p4.s1, calculateSideAmount(sidewave3team2:get()))
	end
	if (isTowerStanding(towerPositions.p4.t2) == FALSE) then
		sidewave4team2:save(sidewave4team2:get() + 1)
		spawnWaveOnSideSpawn(spawnPositions.p4.s2, calculateSideAmount(sidewave4team2:get()))
	end

	AI.NewSquad(5, AI.CMD_SUICIDE_MISSION)
	AI.NewSquad(6, AI.CMD_SUICIDE_MISSION)
	AI.NewSquad(7, AI.CMD_SUICIDE_MISSION)
	AI.NewSquad(8, AI.CMD_SUICIDE_MISSION)
end

function calculateMainAmount(wave)
	-- return 10*wave
	return floorNumber(10*(wave+1)+0.5*(wave+1)*(wave+1))
end

function calculateSideAmount(wave)
	-- return 10*wave
	return floorNumber(10*(wave+1)+0.1*(wave+1)*(wave+1)*(wave+1))
end

function spawnWaveOnMainSpawn(spawn, amount)
	spawnUnitsOnSpawn(spawn, spawn.mainUnit, floorNumber(0.2*0.5*amount))
	spawnUnitsOnSpawn(spawn, spawn.mainUnit+1, floorNumber(0.4*0.5*amount))
	spawnUnitsOnSpawn(spawn, spawn.mainUnit+2, floorNumber(0.4*0.5*amount))
	spawnUnitsOnSpawn(spawn, spawn.secondUnit, floorNumber(0.2*0.3*amount))
	spawnUnitsOnSpawn(spawn, spawn.secondUnit+1, floorNumber(0.4*0.3*amount))
	spawnUnitsOnSpawn(spawn, spawn.secondUnit+2, floorNumber(0.4*0.3*amount))
	spawnUnitsOnSpawn(spawn, spawn.sideUnit, floorNumber(0.2*0.2*amount))
	spawnUnitsOnSpawn(spawn, spawn.sideUnit+1, floorNumber(0.4*0.2*amount))
	spawnUnitsOnSpawn(spawn, spawn.sideUnit+2, floorNumber(0.4*0.2*amount))
end

function spawnWaveOnSideSpawn(spawn, amount)
	spawnUnitsOnSpawn(spawn, spawn.secondUnit, floorNumber(0.2*0.7*amount))
	spawnUnitsOnSpawn(spawn, spawn.secondUnit+1, floorNumber(0.4*0.7*amount))
	spawnUnitsOnSpawn(spawn, spawn.secondUnit+2, floorNumber(0.4*0.7*amount))
	spawnUnitsOnSpawn(spawn, spawn.sideUnit, floorNumber(0.2*0.3*amount))
	spawnUnitsOnSpawn(spawn, spawn.sideUnit+1, floorNumber(0.4*0.3*amount))
	spawnUnitsOnSpawn(spawn, spawn.sideUnit+2, floorNumber(0.4*0.3*amount))
end

function spawnUnitsOnSpawn(spawn, unit, amount)
	Settlers.AddSettlers(spawn.x,spawn.y, spawn.attacker, unit, amount)
end

function isTowerStanding(tower)
	local radius = 10
	if Buildings.ExistsBuildingInArea(tower.player, Buildings.GUARDTOWERSMALL, tower.x, tower.y, radius, Buildings.READY) == 0 then
		return FALSE
	end
	return TRUE
end

function lightningBlockade()

	-- local pauseBetweenLightning = 4

	-- local recovery1 = pauseBetweenLightning
	-- local recovery2 = pauseBetweenLightning

	-- if (isTowerStanding(towerPositions.p1.t1) == FALSE) then
		-- recovery2 = recovery2 + pauseBetweenLightning
	-- end
	-- if (isTowerStanding(towerPositions.p1.t2) == FALSE) then
		-- recovery2 = recovery2 + pauseBetweenLightning
	-- end
	-- if (isTowerStanding(towerPositions.p2.t1) == FALSE) then
		-- recovery2 = recovery2 + pauseBetweenLightning
	-- end
	-- if (isTowerStanding(towerPositions.p2.t2) == FALSE) then
		-- recovery2 = recovery2 + pauseBetweenLightning
	-- end

	-- if (isTowerStanding(towerPositions.p3.t1) == FALSE) then
		-- recovery1 = recovery1 + pauseBetweenLightning
	-- end
	-- if (isTowerStanding(towerPositions.p3.t2) == FALSE) then
		-- recovery1 = recovery1 + pauseBetweenLightning
	-- end

	-- if (isTowerStanding(towerPositions.p4.t1) == FALSE) then
		-- recovery1 = recovery1 + pauseBetweenLightning
	-- end
	-- if (isTowerStanding(towerPositions.p4.t2) == FALSE) then
		-- recovery1 = recovery1 + pauseBetweenLightning
	-- end

	-- lightningCount1:save(lightningCount1:get() + 1)

	-- if ((lightningCount1:get()) == (recovery1-pauseBetweenLightning+1)) then
		-- x1 = randomBetweenSimple(lightningPositions.t1.x1,lightningPositions.t1.x2)
		-- y1 = randomBetweenSimple(lightningPositions.t1.y1,lightningPositions.t1.y2)
		-- x2 = randomBetweenSimple(lightningPositions.t1.x1,lightningPositions.t1.x2)
		-- y2 = randomBetweenSimple(lightningPositions.t1.y1,lightningPositions.t1.y2)
		-- Effects.AddEffect(Effects.RMAGIC_JUPITERSLIGHTNING, Sounds.NO_SOUND, x1, y1, 0)
		-- Effects.AddEffect(Effects.RMAGIC_JUPITERSLIGHTNING, Sounds.NO_SOUND, x2, y2, 0)
	-- end
	-- if ((lightningCount1:get()) == recovery1) then
		-- lightningCount1:save(0)
		-- Magic.CastSpell(7,0,5, x1, y1)
		-- Magic.CastSpell(7,0,5, x2, y2)
	-- end

	-- lightningCount2:save(lightningCount2:get() + 1)

	-- if ((lightningCount2:get()) == (recovery2-pauseBetweenLightning+1)) then
		-- x3 = randomBetweenSimple(lightningPositions.t2.x1,lightningPositions.t2.x2)
		-- y3 = randomBetweenSimple(lightningPositions.t2.y1,lightningPositions.t2.y2)
		-- x4 = randomBetweenSimple(lightningPositions.t2.x1,lightningPositions.t2.x2)
		-- y4 = randomBetweenSimple(lightningPositions.t2.y1,lightningPositions.t2.y2)
		-- Effects.AddEffect(Effects.RMAGIC_JUPITERSLIGHTNING, Sounds.NO_SOUND, x3, y3, 0)
		-- Effects.AddEffect(Effects.RMAGIC_JUPITERSLIGHTNING, Sounds.NO_SOUND, x4, y4, 0)
	-- end
	-- if ((lightningCount2:get()) == recovery2) then
		-- lightningCount2:save(0)
		-- Magic.CastSpell(5,0,5, x3, y3)
		-- Magic.CastSpell(5,0,5, x4, y4)
	-- end

end


function Siegbedingung()
	-- Game.DefaultPlayersLostCheck()
	local radius = 10
	local team1 = FALSE
	local team2 = FALSE

	if Buildings.ExistsBuildingInArea(1,Buildings.CASTLE,castlePositions.p1.x,castlePositions.p1.y,radius,Buildings.READY) == 0 then
		destroyParty(1)
		team1 = TRUE
	end
	if Buildings.ExistsBuildingInArea(2,Buildings.CASTLE,castlePositions.p2.x,castlePositions.p2.y,radius,Buildings.READY) == 0 then
		destroyParty(2)
		team1 = TRUE
	end
	if Buildings.ExistsBuildingInArea(3,Buildings.CASTLE,castlePositions.p3.x,castlePositions.p3.y,radius,Buildings.READY) == 0 then
		destroyParty(3)
		team2 = TRUE
	end
	if Buildings.ExistsBuildingInArea(4,Buildings.CASTLE,castlePositions.p4.x,castlePositions.p4.y,radius,Buildings.READY) == 0 then
		destroyParty(4)
		team2 = TRUE
	end

	if team1 == TRUE then
		Game.PlayerLost(1)
		Game.PlayerLost(2)
		Game.PlayerLost(5)
		Game.PlayerLost(6)
	end
		if team2 == TRUE then
		Game.PlayerLost(3)
		Game.PlayerLost(4)
		Game.PlayerLost(7)
		Game.PlayerLost(8)
	end

	Game.DefaultGameEndCheck()
end

function destroyParty(theplayer)
	local counter = 1
	--IDs der Gebaeude gehen von 1 - 83
	while counter <= 83 do
		while Buildings.Amount(theplayer, counter, Buildings.READY) > 0 do
			Buildings.Delete(Buildings.GetFirstBuilding(theplayer, counter),2)
		end
		counter = counter +  1
	end

	counter = 1
	-- IDs der Sieder gehen von 1 - 80
	-- Swordsman, Bowman, Medics, Axewarriors, Blowgunwarriors, Backpackcatapulists: 29-43
	while counter <= 80 do
		if (counter == 29) then
			counter = 44
		end
		Settlers.KillSelectableSettlers(1, counter, 300, 450, 70, 0)
		counter = counter +  1
	end

end

-------------------------------------------------------------
-------------------------------------------------------------
------ generalUtility  --------------------------------------
-------Diese könnt ihr für eure Scripts nutzen---------------
-------------------------------------------------------------

TRUE = 1
FALSE = 0

--- gibt aus einem array von Spielern ("playersTable" mit den IDs der Spielern) die Spieler ID zurück, der am  "enemyPosition" meisten Einheiten hat
---BSP: enemyPosition == 1 --> gibt den Spieler mit den meisten Units zurück
---BSP: enemyPosition == 2 --> gibt den Spieler mit den zweitmeisten Units zurück..
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