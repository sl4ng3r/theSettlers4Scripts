tick1 = 0 --
tick2 = 0 --
tick3 = 0 --
tick4 = 0
tick5 = 0
tick6 = 0
tick7 = 0
tick8 = 0
fire = 0
water = 0
boom = 0

function InitVar()
	Vars.Save1 = 0	-- aufgabe 1
	Vars.Save2 = 0	-- aufgabe 2
	Vars.Save3 = 0 	-- aufgabe 3
	Vars.Save4 = 0    	-- aufgabe 4
	Vars.Save5 = 0    	--
	Vars.Save6 = 0    	--
	Vars.Save7 = 0	--
	Vars.Save8 = 0	--
	Vars.Save9 = 0	--test
end

function addreefs()
	Map.AddReef(613,599,107)
	Map.AddReef(617,602,107)
	Map.AddReef(622,606,107)
	Map.AddReef(627,610,107)
	Map.AddReef(632,614,107)
	Map.AddReef(638,618,107)  --barriere 1

	Map.AddReef(466,552,107)
	Map.AddReef(469,557,107)
	Map.AddReef(473,564,107)
	Map.AddReef(477,570,107)
	Map.AddReef(481,576,107)
	Map.AddReef(485,581,107) --barriere 2
end

function addShips()
	ferryId1=Vehicles.AddVehicle(976,476,1,Vehicles.FERRY,0,0,0)
		Settlers.AddSettlersToFerry(ferryId1,Settlers.BOWMAN_03,10)
		Vehicles.AddWheelerToFerry(ferryId1,Vehicles.FOUNDATION_CART)
	ferryId2=Vehicles.AddVehicle(956,476,1,Vehicles.FERRY,0,0,0)
		Settlers.AddSettlersToFerry(ferryId2,Settlers.BOWMAN_03,10)
		Vehicles.AddWheelerToFerry(ferryId2,Vehicles.FOUNDATION_CART)
	ferryId3=Vehicles.AddVehicle(936,476,1,Vehicles.FERRY,0,0,0)
		Vehicles.AddWheelerToFerry(ferryId3,Vehicles.FOUNDATION_CART)
		Settlers.AddSettlersToFerry(ferryId3,Settlers.PRIEST,3)
		Settlers.AddSettlersToFerry(ferryId3,Settlers.THIEF,5)
	ferryId4=Vehicles.AddVehicle(930,458,1,Vehicles.FERRY,0,0,0)
		Vehicles.AddWheelerToFerry(ferryId4,Vehicles.FOUNDATION_CART)
		Settlers.AddSettlersToFerry(ferryId4,Settlers.SWORDSMAN_03,5)
		Settlers.AddSettlersToFerry(ferryId4,Settlers.THIEF,5)
	ferryId5=Vehicles.AddVehicle(950,458,1,Vehicles.FERRY,0,0,0)
		Vehicles.AddWheelerToFerry(ferryId5,Vehicles.FOUNDATION_CART)
		Settlers.AddSettlersToFerry(ferryId5,Settlers.BOWMAN_03,10)

	Magic.IncreaseMana(1,120)


end

function defense()
		Settlers.SetHealthInArea(8,Settlers.BOWMAN_03,731,947,25,125)
end

function teleport()
	if Settlers.AmountInArea(1, Settlers.PRIEST, 753, 982, 3) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.PRIEST, 753, 982, 3, 0)
		Settlers.AddSettlers(59, 669, 1, Settlers.PRIEST, 1)
	end
end

function GenerateEnemies()
  	tick4 = tick4 +1
	if tick4 == 2100 and Vars.Save5 == 0 then
		Settlers.AddSettlers(177, 355, 4, Settlers.SWORDSMAN_03, 35)
		Settlers.AddSettlers(177, 355, 4, Settlers.BOWMAN_03, 40)
		Settlers.AddSettlers(177, 355, 4, Settlers.AXEWARRIOR_03, 8)
		AI.NewSquad(4, AI.CMD_SUICIDE_MISSION )
		tick4 = 0
	end
	if Vars.Save2 == 2 and Buildings.ExistsBuildingInArea(5,Buildings.CASTLE,157,153,30, Buildings.ALL) == 0 then
		unrequest_event(GenerateEnemies, Events.FIVE_TICKS)
	elseif Game.HasPlayerLost(4) == 1 then
		unrequest_event(GenerateEnemies, Events.FIVE_TICKS)
	end
end
function GenerateSettlers()
  	tick5 = tick5 +1
	if tick5 == 1400 and Vars.Save6 == 0 then
		Settlers.AddSettlers(912, 123, 7, Settlers.CARRIER, 25)
		Goods.AddPileEx(861,153, Goods.SUNFLOWEROIL, 8)
		Goods.AddPileEx(861,153, Goods.SUNFLOWEROIL, 8)
		Goods.AddPileEx(861,153, Goods.SUNFLOWEROIL, 8)
		Goods.AddPileEx(861,153, Goods.SUNFLOWEROIL, 8)
		Goods.AddPileEx(861,153, Goods.SUNFLOWEROIL, 8)
		tick5 = 0
	end
end

function firstmessage()
	if Vars.Save1 == 0 then
		tick1 = tick1 +1
	end
	if tick1 == 1 and Vars.Save9 == 0 then
	dbg.stm("Eine große Insel befindet sich in Sichtweite. Ob dort das legendäre Schloss steht? Finden wir es heraus!")
	--Tutorial.RWM(1)
	Vars.Save9 = 1
	end
	if tick1 == 55 and Vars.Save9 == 1 then 	Settlers.AddSettlers(813, 862, 1, Settlers.THIEF, 1) end
	if tick1 == 60 and Vars.Save9 == 1 then
	dbg.stm("Ein Schloss konnte dieser Kundschafter auf dieser Insel nicht finden, jedoch entdeckte er diesen Hafen bei den Mayas.")
	Map.SetScreenPos(818,863)
	Vars.Save9 = 2
	end
	if tick1 == 120 and Vars.Save9 == 2 then
	dbg.stm("Da uns die Mayas nicht wohlgesonnen sind, müssen wir wohl den Hafen erobern, um unsere Fahrt fortsetzen zu können!")
	Map.SetScreenPos(818,863)
	Vars.Save9 = 3
	end
	if Game.IsAreaOwned(1,807,817,5) == 1 and Game.IsAreaOwned(1,871,917,5) == 1 and Game.IsAreaOwned(1,851,865,5) == 1 and Vars.Save9 == 3 then
	dbg.stm("Sehr gut, hier können wir eine Werft bauen und unsere Fahrt fortsetzen. Wir sollten eine Fähre Richtung Norden entsenden!")
	Map.SetScreenPos(862,860)
	Vars.Save9 = 4
	Vars.Save1 = 1
	end
end

function secondmessage()
	if Vehicles.AmountInArea(1,Vehicles.FERRY,722, 767, 16) >= 1 and Vars.Save2 == 0 then
	dbg.stm("Uns erreichte soeben ein Hilferuf von Verbündeten im Norden! Sicherheitshalber sollten wir ein paar unserer Männer dorthin mitnehmen!")
	Map.SetScreenPos(467,498)
	Settlers.AddSettlers(429, 230, 3, Settlers.CARRIER, 150)
	Settlers.AddSettlers(173, 236, 4, Settlers.CARRIER, 200)
	Magic.CastSpell(1,4,7,467,498)
	Vars.Save2 = 1
	end
	if Vehicles.AmountInArea(1,Vehicles.FERRY,465, 491, 16) >= 1 and Vars.Save2 == 1 then
	dbg.stm("Seid gegrüßt, Verbündeter! Wir werden schon seit langer Zeit von Barbaren belagert. Helft uns, sie zu vertreiben; Vernichtet die drei Burgen des Häuptlings! Im Gegenzug helfen wir euch dafür bei eurer weiteren Reise! Unsere Siedlung darf nicht fallen!")
	Map.SetScreenPos(393,224)
	Settlers.AddSettlers(391, 223, 1, Settlers.DONKEY, 1)
	Settlers.AddSettlers(372, 203, 1, Settlers.DONKEY, 1)
	Settlers.AddSettlers(398, 252, 1, Settlers.DONKEY, 1)
	Settlers.AddSettlers(309, 204, 1, Settlers.DONKEY, 1)
	Magic.CastSpell(1,4,7,395,223)
	Magic.CastSpell(1,4,7,310,206)
	Magic.CastSpell(1,4,7,156,152)
	request_event(GenerateEnemies, Events.FIVE_TICKS)
	Vars.Save2 = 2
	end
	if Vars.Save2 == 2 and Buildings.ExistsBuildingInArea(5,Buildings.CASTLE,157,153,30, Buildings.ALL) == 0 then
		tick2 = tick2 +1
		end
	if tick2 == 1 and Vars.Save2 == 2 then
	dbg.stm("Ihr habt es geschafft! Endlich können wir hier wieder in Frieden leben! Als Dank helfen wir euch, die Barriere zur nächsten Insel aus dem Weg zu räumen!")
	Map.SetScreenPos(156,152)
	Map.DeleteReef(613,599,107)
	Map.DeleteReef(617,602,107)
	Map.DeleteReef(622,606,107)
	Map.DeleteReef(627,610,107)
	Map.DeleteReef(632,614,107)
	Map.DeleteReef(638,618,107)
	Magic.CastSpell(1,4,7,624,597)
	unrequest_event(barbar, Events.FIVE_TICKS)
	end
	if tick2 == 14 and Vars.Save2 == 2 then
	dbg.stm("Seht her, die Riffe sind entfernt! Viel Erfolg für Eure Reise!")
	Map.SetScreenPos(631,617)
	Vars.Save2 = 3
	end

end

function thirdmessage()
	if Vehicles.AmountInArea(1,Vehicles.FERRY,639, 309, 16) >= 1 and Vars.Save3 == 0 then
	tick3 = tick3 +1
	end
	if tick3 == 1 and Vars.Save3 == 0 then Magic.CastSpell(1,4,7,643,240) end
	if tick3 == 6 and Vars.Save3 == 0 then
	dbg.stm("Diese armen Bauern werden von ihrem Herrscher Hector gnadenlos unterdrückt und zu allem Überfluss ist auch noch die Pest über sie hergefallen!")
	Map.SetScreenPos(643,240)
	Settlers.AddSettlers(690, 229, 1, Settlers.DONKEY, 1)
	Settlers.AddSettlers(739, 198, 1, Settlers.DONKEY, 1)
	Settlers.AddSettlers(671, 148, 1, Settlers.DONKEY, 1)
	Settlers.AddSettlers(608, 180, 1, Settlers.DONKEY, 1)
	Settlers.AddSettlers(786, 287, 1, Settlers.DONKEY, 2)
	request_event(drawCircle1,Events.TICK)
	request_event(GenerateSettlers, Events.FIVE_TICKS)
	end
	if tick3 == 30 and Vars.Save3 == 0 then Magic.CastSpell(1,4,7,789,292) end
	if tick3 == 35 and Vars.Save3 == 0 then
	Map.SetScreenPos(789,292)
	dbg.stm("Befreie die Bauern von der Pest und unterstütze sie im Aufbau, damit sie sich von Hector dem Unterdrücker befreien können!")
	end
	if tick3 == 60 and Vars.Save3 == 0 then Magic.CastSpell(1,4,7,898,156) end
	if tick3 == 65 and Vars.Save3 == 0 then
	Map.SetScreenPos(902,165)
	dbg.stm("Hectors Burg muss von den Bauern erobert werden! Wird sie zerstört, ist das Spiel verloren!")
	end
	if tick3 == 90 and Vars.Save3 == 0 then Magic.CastSpell(1,4,7,818,192) end
	if tick3 == 95 and Vars.Save3 == 0 then
	Map.SetScreenPos(828,199)
	dbg.stm("Eure Soldaten und Priester können leider nicht durch Feuer gehen!")
	tick3 = 0
	Vars.Save3 = 1
	end

	if Vars.Save3 == 1 and Buildings.ExistsBuildingInArea(6,Buildings.CASTLE,895,149,20, Buildings.ALL) == 1 then
		unrequest_event(GenerateSettlers, Events.FIVE_TICKS)
		tick3 = tick3 +1
	end
	if tick3 == 1 and Vars.Save3 == 1 then Magic.CastSpell(1,4,7,898,156) end
	if tick3 == 6 and Vars.Save3 == 1 then
	dbg.stm("Endlich frei! Dank eurer Unterstützung konnten wir uns aus der Herrschaft von Hector befreien! Im Gegenzug möchten wir euch gerne bei eurer weiteren Reise behilflich sein!")
	Map.SetScreenPos(907,162)
	Map.DeleteReef(466,552,107)
	Map.DeleteReef(469,557,107)
	Map.DeleteReef(473,564,107)
	Map.DeleteReef(477,570,107)
	Map.DeleteReef(481,576,107)
	Map.DeleteReef(485,581,107)
	unrequest_event(drawCircle1,Events.TICK)
	end
	if tick3 == 30 and Vars.Save3 == 1 then Magic.CastSpell(1,4,7,476,568) end
	if tick3 == 35 and Vars.Save3 == 1 then
	dbg.stm("Unsere Spezialisten haben für euch diese Riffe entfernt. Möge euch Zeus bei eurer Reise wohlgesonnen sein!")
	Map.SetScreenPos(489,581)
	Vars.Save3 = 2
	end
end

function fourthmessage()
	if Vehicles.AmountInArea(1,Vehicles.FERRY,451, 581, 16) >= 1 and Vars.Save4 == 0 then
	dbg.stm("Auf dieser Insel, so sagt man, gibt es ein magisches Portal, das uns zum Schloss führen soll...")
	Map.SetScreenPos(454,591)
	Vars.Save4 = 1
	end
	if Vehicles.AmountInArea(1,Vehicles.FERRY,415, 600, 12) >= 1 and Vars.Save4 == 1 then
	dbg.stm("Offenbar wird diese Insel stark bewacht! Wir müssen uns den Weg zum Portal wohl freikämpfen!")
	Map.SetScreenPos(417,610)
	Vars.Save4 = 2
	end
	if Game.FindAnyUnit(1,707,919,8) >= 1 and Vars.Save4 == 2 then
	dbg.stm("Dort vorne ist das Portal! Aber wie kommen wir an den unverwundbaren Bogenschützen vorbei??")
	Magic.CastSpell(1,4,7,753,981)
	Map.SetScreenPos(724,939)
	Vars.Save4 = 3
	end
	if Game.FindAnyUnit(1,745,969,5) >= 1 and Vars.Save4 == 3 then
	dbg.stm("Sehr gut, wir sind kurz vor dem Ziel! Das Portal kann allerdings nur von einem Priester betreten werden!")
	Map.SetScreenPos(757,988)
	Vars.Save4 = 4
	end
end
function Solikill()
	if Settlers.AmountInArea(1, Settlers.SWORDSMAN_01, 815, 185, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.SWORDSMAN_01, 815, 185, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.SWORDSMAN_02, 815, 185, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.SWORDSMAN_02, 815, 185, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.SWORDSMAN_03, 815, 185, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.SWORDSMAN_03, 815, 185, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.BOWMAN_01, 815, 185, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.BOWMAN_01, 815, 185, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.BOWMAN_02, 815, 185, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.BOWMAN_02, 815, 185, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.BOWMAN_03, 815, 185, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.BOWMAN_03, 815, 185, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.MEDIC_01, 815, 185, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.MEDIC_01, 815, 185, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.MEDIC_02, 815, 185, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.MEDIC_02, 815, 185, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.MEDIC_03, 815, 185, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.MEDIC_03, 815, 185, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.PRIEST, 815, 185, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.PRIEST, 815, 185, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.SQUADLEADER, 815, 185, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.SQUADLEADER, 815, 185, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.SWORDSMAN_01, 823, 195, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.SWORDSMAN_01, 823, 195, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.SWORDSMAN_02, 823, 195, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.SWORDSMAN_02, 823, 195, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.SWORDSMAN_03, 823, 195, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.SWORDSMAN_03, 823, 195, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.BOWMAN_01, 823, 195, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.BOWMAN_01, 823, 195, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.BOWMAN_02, 823, 195, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.BOWMAN_02, 823, 195, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.BOWMAN_03, 823, 195, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.BOWMAN_03, 823, 195, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.MEDIC_01, 823, 195, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.MEDIC_01, 823, 195, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.MEDIC_02, 823, 195, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.MEDIC_02, 823, 195, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.MEDIC_03, 823, 195, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.MEDIC_03, 823, 195, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.PRIEST, 823, 195, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.PRIEST, 823, 195, 6, 1)
	elseif Settlers.AmountInArea(1, Settlers.SQUADLEADER, 823, 195, 6) >= 1 then
		Settlers.KillSelectableSettlers(1, Settlers.SQUADLEADER, 823, 195, 6, 1)
	end
end

function barbar()
boom = boom + 1
	if boom > 6 then

	Effects.AddEffect(46 ,2 ,154,171,0)
	Effects.AddEffect(46 ,2 ,157,154,0)
	Effects.AddEffect(46 ,2 ,160,138,0)
	boom = 0
	end
end

function flames()
fire = fire + 1
	if fire > 2 then

	Effects.AddEffect(78 ,48 ,811,183,0)
	Effects.AddEffect(78 ,48 ,814,187,0)
	Effects.AddEffect(78 ,48 ,817,191,0)
	Effects.AddEffect(78 ,48 ,820,195,0)
	Effects.AddEffect(78 ,48 ,823,199,0)
	fire = 0
	end
end

function waterfall()
water = water + 1
	if water > 1 then

	Effects.AddEffect(44 ,92 ,536,661,0)
	Effects.AddEffect(44 ,92 ,600,702,0)
	water = 0
	end
end
function new_game()
  	request_event(VictoryConditionCheck, Events.VICTORY_CONDITION_CHECK)
  	request_event(InitVar,Events.FIRST_TICK_OF_NEW_GAME)
  	request_event(firstmessage, Events.FIVE_TICKS)
  	request_event(secondmessage, Events.FIVE_TICKS)
  	request_event(thirdmessage, Events.FIVE_TICKS)
  	request_event(fourthmessage, Events.FIVE_TICKS)
	request_event(defense, Events.FIVE_TICKS)
	request_event(Solikill, Events.FIVE_TICKS)
	request_event(flames, Events.FIVE_TICKS)
	request_event(barbar, Events.FIVE_TICKS)
	request_event(waterfall, Events.FIVE_TICKS)
	request_event(calculateCircles,Events.FIRST_TICK_OF_NEW_OR_LOADED_GAME)
	request_event(teleport,Events.FIVE_TICKS)

  	AI.SetPlayerVar(2, "AttackMode", 1, 2, 2)
	AI.SetPlayerVar(3, "AttackMode", 0, 0, 0)
	AI.SetPlayerVar(4, "AttackMode", 0, 0, 0)
	AI.SetPlayerVar(5, "AttackMode", 0, 0, 0)
	AI.SetPlayerVar(6, "AttackMode", 2, 2, 2)
	AI.SetPlayerVar(7, "AttackMode", 0, 0, 0)
	AI.SetPlayerVar(8, "AttackMode", 2, 2, 2)

	addShips()
	addreefs()

  Game.SetFightingStrength(4, 150)
  Game.SetFightingStrength(5, 100)
  Game.SetFightingStrength(8, 120)

  Game.SetAlliesDontRevealFog(1)
  Game.ResetFogging()
end

function register_functions()
	reg_func(VictoryConditionCheck)
	reg_func(InitVar)
 	reg_func(firstmessage)
	reg_func(secondmessage)
	reg_func(thirdmessage)
	reg_func(fourthmessage)
	reg_func(defense)
	reg_func(Solikill)
	reg_func(flames)
	reg_func(barbar)
	reg_func(waterfall)
	reg_func(calculateCircles)
	reg_func(drawCircle1)
  	reg_func(GenerateEnemies)
  	reg_func(GenerateSettlers)
	reg_func(teleport)

end

function VictoryConditionCheck()
  Game.DefaultPlayersLostCheck()
  Game.DefaultPlayerLostCheck(1)

	if Settlers.AmountInArea(1, Settlers.PRIEST, 140, 699, 8) >= 1 and Game.HasPlayerLost(1) == 0 then
	Game.EnemyPlayersLost(1)
  end
	if Game.HasPlayerLost(3) == 1 then
	Game.PlayerLost(1)
	end
	if Buildings.ExistsBuildingInArea(6,Buildings.CASTLE,895,149,20, Buildings.ALL) == 0
	and Buildings.ExistsBuildingInArea(7,Buildings.CASTLE,895,149,20, Buildings.ALL) == 0 then
	Game.PlayerLost(1)
	end
  Game.DefaultGameEndCheck()
end


circles={
	circle1={
		center={
			x=895,
			y=148
		},
		radius=17,
		effect=Effects.RMAGIC_GIFTOFGOD,
		sound=Sounds.NO_SOUND,
		density=3,
		delay=0,
		effectsPerTick=8,
		split=4,
		coordinates={
			x={},
			y={}
		},
		effectsAmount=1,
		_i=1,
		_j=1
	}
}

function sqrt(_number)
	lower=0
	upper=_number
	while upper-lower>0.001 do
		result=(upper+lower)/2
		if (result*result)<_number then
			lower=result
		else
			upper=result
		end
	end
	return result
end

function sort(_table)
	i=1
	sectorAmount=getn(_table.x)
	sa=sectorAmount
	while i<=(sectorAmount) do
		j=1
		while j<sa-1 do
			if _table.x[j]>_table.x[sa] then
				temp=_table.x[sa]
				_table.x[sa]=_table.x[j]
				_table.x[j]=temp
				temp=_table.y[sa]
				_table.y[sa]=_table.y[j]
				_table.y[j]=temp
			end
			j=j+1
		end
		sa=sa-1
		i=i+1
	end
	i=1
	while i<=getn(_table.x) do
		if _table.x[i]==_table.x[(i+1)] or _table.y[i]==_table.y[(i+1)] then
			tremove(_table.x,i)
			tremove(_table.y,i)
		else
			i=i+1
		end
	end
	sectorAmount=getn(_table.x)
end

function circles.calculateFirstSector(_circle)
	sector={x={},y={}}
	sectorAmount=1
	_y=_circle.radius-1
	while _y>=0 do
		_z=(_circle.radius*_circle.radius)-(_y*_y)
		if _z==0 then
			dx=0
		else
			dx=sqrt(_z)
		end
		sector.x[sectorAmount]=_circle.center.x+dx
		sector.y[sectorAmount]=_circle.center.y-_y
		_y=_y-_circle.density
		sectorAmount=sectorAmount+1
	end
	_x=_circle.radius-1
	while _x>=0 do
		_z=(_circle.radius*_circle.radius)-(_x*_x)
		if _z==0 then
			dy=0
		else
			dy=sqrt(_z)
		end
		sector.x[sectorAmount]=_circle.center.x+_x
		sector.y[sectorAmount]=_circle.center.y-dy
		_x=_x-_circle.density
		sectorAmount=sectorAmount+1
	end
	sort(sector)
end

function circles.calculateSecondSector(_circle)
	sector={x={},y={}}
	sectorAmount=1
	_y=_circle.radius-1
	while _y>=0 do
		_z=(_circle.radius*_circle.radius)-(_y*_y)
		if _z==0 then
			dx=0
		else
			dx=sqrt(_z)
		end
		sector.x[sectorAmount]=_circle.center.x+dx
		sector.y[sectorAmount]=_circle.center.y+_y
		_y=_y-_circle.density
		sectorAmount=sectorAmount+1
	end
	_x=_circle.radius-1
	while _x>=0 do
		_z=(_circle.radius*_circle.radius)-(_x*_x)
		if _z==0 then
			dy=0
		else
			dy=sqrt(_z)
		end
		sector.x[sectorAmount]=_circle.center.x+_x
		sector.y[sectorAmount]=_circle.center.y+dy
		_x=_x-_circle.density
		sectorAmount=sectorAmount+1
	end
	sort(sector)
end

function circles.calculateThirdSector(_circle)
	sector={x={},y={}}
	sectorAmount=1
	_y=_circle.radius-1
	while _y>=0 do
		_z=(_circle.radius*_circle.radius)-(_y*_y)
		if _z==0 then
			dx=0
		else
			dx=sqrt(_z)
		end
		sector.x[sectorAmount]=_circle.center.x-dx
		sector.y[sectorAmount]=_circle.center.y+_y
		_y=_y-_circle.density
		sectorAmount=sectorAmount+1
	end
	_x=_circle.radius-1
	while _x>=0 do
		_z=(_circle.radius*_circle.radius)-(_x*_x)
		if _z==0 then
			dy=0
		else
			dy=sqrt(_z)
		end
		sector.x[sectorAmount]=_circle.center.x-_x
		sector.y[sectorAmount]=_circle.center.y+dy
		_x=_x-_circle.density
		sectorAmount=sectorAmount+1
	end
	sort(sector)
end

function circles.calculateFourthSector(_circle)
	sector={x={},y={}}
	sectorAmount=1
	_y=_circle.radius-1
	while _y>=0 do
		_z=(_circle.radius*_circle.radius)-(_y*_y)
		if _z==0 then
			dx=0
		else
			dx=sqrt(_z)
		end
		sector.x[sectorAmount]=_circle.center.x-dx
		sector.y[sectorAmount]=_circle.center.y-_y
		_y=_y-_circle.density
		sectorAmount=sectorAmount+1
	end
	_x=_circle.radius-1
	while _x>=0 do
		_z=(_circle.radius*_circle.radius)-(_x*_x)
		if _z==0 then
			dy=0
		else
			dy=sqrt(_z)
		end
		sector.x[sectorAmount]=_circle.center.x-_x
		sector.y[sectorAmount]=_circle.center.y-dy
		_x=_x-_circle.density
		sectorAmount=sectorAmount+1
	end
	sort(sector)
end

function circles.calculate(_circle)
	circles.calculateFirstSector(_circle)
	i=1
	while i<=sectorAmount do
		_circle.coordinates.x[_circle.effectsAmount]=sector.x[i]
		_circle.coordinates.y[_circle.effectsAmount]=sector.y[i]
		_circle.effectsAmount=_circle.effectsAmount+1
		i=i+1
	end
	circles.calculateSecondSector(_circle)
	i=sectorAmount
	while i>0 do
		_circle.coordinates.x[_circle.effectsAmount]=sector.x[i]
		_circle.coordinates.y[_circle.effectsAmount]=sector.y[i]
		_circle.effectsAmount=_circle.effectsAmount+1
		i=i-1
	end
	circles.calculateThirdSector(_circle)
	i=sectorAmount
	while i>0 do
		_circle.coordinates.x[_circle.effectsAmount]=sector.x[i]
		_circle.coordinates.y[_circle.effectsAmount]=sector.y[i]
		_circle.effectsAmount=_circle.effectsAmount+1
		i=i-1
	end
	circles.calculateFourthSector(_circle)
	i=1
	while i<=sectorAmount do
		_circle.coordinates.x[_circle.effectsAmount]=sector.x[i]
		_circle.coordinates.y[_circle.effectsAmount]=sector.y[i]
		_circle.effectsAmount=_circle.effectsAmount+1
		i=i+1
	end
	i=1
	while i<_circle.effectsAmount do
		_y=_circle.coordinates.y[i]
		_circle.coordinates.x[i]=_circle.coordinates.x[i]+(_y/2)-(_circle.center.y/2)
		i=i+1
	end
	effectsAmount=getn(_circle.coordinates.x)
end

function circles.draw(_circle)
	drawnEffects=0
	while drawnEffects<_circle.effectsPerTick do
		if _circle._j<_circle.split then
			if _circle._i<=_circle.effectsAmount then
				_x=_circle.coordinates.x[_circle._i]
				_y=_circle.coordinates.y[_circle._i]
				Effects.AddEffect(_circle.effect, _circle.sound, _x, _y, _circle.delay)
				_circle._i=_circle._i+_circle.split
			else
				_circle._j=_circle._j+1
				_circle._i=_circle._j
			end
		else
			_circle._j=0
		end
		drawnEffects=drawnEffects+1
	end
end

function calculateCircles()
	circles.calculate(circles.circle1)

end

function drawCircle1()
		circles.draw(circles.circle1)
end