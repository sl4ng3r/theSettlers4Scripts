spectator = { 5,6,7,8 }

function newOrLoadedGame()
    Vars.Save1 = 0
    Vars.Save2 = 0

    local i,v = next(spectator,nil)
    local localPlayer = Game.LocalPlayer();
    while i do
        if localPlayer == v then
            Tutorial.RWM(1);
        end
        i,v = next(spectator,i);
    end

    dbg.stm("The Settlers IV Tournament Summer 2020 Hotspot Map")
    dbg.stm("PeaceTime: 45 Min. Thieves are allowed and may steal and Sabotours are allowed from 45 minutes")

    if Game.LocalPlayer() >= 5 then
                dbg.stm("Scriptversion 1.0")
    end
    Buildings.Delete(Buildings.GetFirstBuilding(5, 46),2)
    Buildings.Delete(Buildings.GetFirstBuilding(6, 46),2)
    Buildings.Delete(Buildings.GetFirstBuilding(7, 46),2)
    Buildings.Delete(Buildings.GetFirstBuilding(8, 46),2)
end

function new_game()
    request_event(Info, Events.FIVE_TICKS);
    request_event(newOrLoadedGame,Events.FIRST_TICK_OF_NEW_OR_LOADED_GAME);
end

function register_functions()
    reg_func(newMinute);
    reg_func(minuteReached);
    reg_func(Info);
    reg_func(newOrLoadedGame);
    MinuteEvents.register_functions();
end


function minuteReached(value)
    if Game.Time() == value then
        if Vars.Save2 ~= value then
            Vars.Save2 = value
            return 1
        else
            return 0
        end
    end
end

function newMinute()
    if Vars.Save1 ~= Game.Time() then
        Vars.Save1 = Game.Time()
        return 1
    else
        return 0
    end
end

function Info()
    if newMinute() == 1 then
        playerId = 1
        Player1AmountOfMilitary =  Settlers.Amount(playerId, Settlers.SWORDSMAN_01) +  Settlers.Amount(playerId, Settlers.SWORDSMAN_02) + Settlers.Amount(playerId, Settlers.SWORDSMAN_03) + Settlers.Amount(playerId, Settlers.BOWMAN_01) +  Settlers.Amount(playerId, Settlers.BOWMAN_02) + Settlers.Amount(playerId, Settlers.BOWMAN_03)+ Settlers.Amount(playerId, Settlers.AXEWARRIOR_01) + Settlers.Amount(playerId, Settlers.AXEWARRIOR_02) + Settlers.Amount(playerId, Settlers.AXEWARRIOR_03) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_01) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_02) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_03) +Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_01)	+ Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_02) + Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_03)  + Settlers.Amount(playerId, Settlers.MEDIC_01) + Settlers.Amount(playerId, Settlers.MEDIC_02) + Settlers.Amount(playerId, Settlers.MEDIC_03) + Settlers.Amount(playerId, Settlers.SQUADLEADER)
        Player1AmountOfMilitary3 =  Settlers.Amount(playerId, Settlers.SWORDSMAN_03) +  Settlers.Amount(playerId, Settlers.BOWMAN_03) +Settlers.Amount(playerId, Settlers.AXEWARRIOR_03) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_03)  + Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_03)  + Settlers.Amount(playerId, Settlers.MEDIC_03) + Settlers.Amount(playerId, Settlers.SQUADLEADER)
        Player1Kills= Statistic.UnitsDestroyed(playerId)
        Player1Settlers = Settlers.Amount(playerId, Settlers.CARRIER)

        playerId = 2
        Player2AmountOfMilitary =  Settlers.Amount(playerId, Settlers.SWORDSMAN_01) +  Settlers.Amount(playerId, Settlers.SWORDSMAN_02) + Settlers.Amount(playerId, Settlers.SWORDSMAN_03) + Settlers.Amount(playerId, Settlers.BOWMAN_01) +  Settlers.Amount(playerId, Settlers.BOWMAN_02) + Settlers.Amount(playerId, Settlers.BOWMAN_03)+ Settlers.Amount(playerId, Settlers.AXEWARRIOR_01) + Settlers.Amount(playerId, Settlers.AXEWARRIOR_02) + Settlers.Amount(playerId, Settlers.AXEWARRIOR_03) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_01) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_02) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_03) +Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_01)	+ Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_02) + Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_03)  + Settlers.Amount(playerId, Settlers.MEDIC_01) + Settlers.Amount(playerId, Settlers.MEDIC_02) + Settlers.Amount(playerId, Settlers.MEDIC_03) + Settlers.Amount(playerId, Settlers.SQUADLEADER)
        Player2AmountOfMilitary3 =  Settlers.Amount(playerId, Settlers.SWORDSMAN_03) +  Settlers.Amount(playerId, Settlers.BOWMAN_03) +Settlers.Amount(playerId, Settlers.AXEWARRIOR_03) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_03)  + Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_03)  + Settlers.Amount(playerId, Settlers.MEDIC_03) + Settlers.Amount(playerId, Settlers.SQUADLEADER)
        Player2Kills= Statistic.UnitsDestroyed(playerId)
        Player2Settlers = Settlers.Amount(playerId, Settlers.CARRIER)

        playerId = 3
        Player3AmountOfMilitary =  Settlers.Amount(playerId, Settlers.SWORDSMAN_01) +  Settlers.Amount(playerId, Settlers.SWORDSMAN_02) + Settlers.Amount(playerId, Settlers.SWORDSMAN_03) + Settlers.Amount(playerId, Settlers.BOWMAN_01) +  Settlers.Amount(playerId, Settlers.BOWMAN_02) + Settlers.Amount(playerId, Settlers.BOWMAN_03)+ Settlers.Amount(playerId, Settlers.AXEWARRIOR_01) + Settlers.Amount(playerId, Settlers.AXEWARRIOR_02) + Settlers.Amount(playerId, Settlers.AXEWARRIOR_03) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_01) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_02) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_03) +Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_01)	+ Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_02) + Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_03)  + Settlers.Amount(playerId, Settlers.MEDIC_01) + Settlers.Amount(playerId, Settlers.MEDIC_02) + Settlers.Amount(playerId, Settlers.MEDIC_03) + Settlers.Amount(playerId, Settlers.SQUADLEADER)
        Player3AmountOfMilitary3 =  Settlers.Amount(playerId, Settlers.SWORDSMAN_03) +  Settlers.Amount(playerId, Settlers.BOWMAN_03) +Settlers.Amount(playerId, Settlers.AXEWARRIOR_03) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_03)  + Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_03)  + Settlers.Amount(playerId, Settlers.MEDIC_03) + Settlers.Amount(playerId, Settlers.SQUADLEADER)
        Player3Kills= Statistic.UnitsDestroyed(playerId)
        Player3Settlers = Settlers.Amount(playerId, Settlers.CARRIER)

        playerId = 4
        Player4AmountOfMilitary =  Settlers.Amount(playerId, Settlers.SWORDSMAN_01) +  Settlers.Amount(playerId, Settlers.SWORDSMAN_02) + Settlers.Amount(playerId, Settlers.SWORDSMAN_03) + Settlers.Amount(playerId, Settlers.BOWMAN_01) +  Settlers.Amount(playerId, Settlers.BOWMAN_02) + Settlers.Amount(playerId, Settlers.BOWMAN_03)+ Settlers.Amount(playerId, Settlers.AXEWARRIOR_01) + Settlers.Amount(playerId, Settlers.AXEWARRIOR_02) + Settlers.Amount(playerId, Settlers.AXEWARRIOR_03) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_01) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_02) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_03) +Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_01)	+ Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_02) + Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_03)  + Settlers.Amount(playerId, Settlers.MEDIC_01) + Settlers.Amount(playerId, Settlers.MEDIC_02) + Settlers.Amount(playerId, Settlers.MEDIC_03) + Settlers.Amount(playerId, Settlers.SQUADLEADER)
        Player4AmountOfMilitary3 =  Settlers.Amount(playerId, Settlers.SWORDSMAN_03) +  Settlers.Amount(playerId, Settlers.BOWMAN_03) +Settlers.Amount(playerId, Settlers.AXEWARRIOR_03) + Settlers.Amount(playerId, Settlers.BLOWGUNWARRIORS_03)  + Settlers.Amount(playerId, Settlers.BACKPACKCATAPULIST_03)  + Settlers.Amount(playerId, Settlers.MEDIC_03) + Settlers.Amount(playerId, Settlers.SQUADLEADER)
        Player4Kills= Statistic.UnitsDestroyed(playerId)
        Player4Settlers = Settlers.Amount(playerId, Settlers.CARRIER)
        if Game.LocalPlayer() >= 5 then
	     dbg.stm("Statistik für Minute "..Game.Time())
	     dbg.stm("Team I : " .. " Soldiers: " .. Player1AmountOfMilitary+Player2AmountOfMilitary.. " L3(" .. Player1AmountOfMilitary3+Player2AmountOfMilitary3 ..  ")" .. " Kills: " .. Player1Kills+Player2Kills .. " Settlers: " .. Player1Settlers+Player2Settlers)
	     dbg.stm("Team II: " .. " Soldiers: " .. Player3AmountOfMilitary+Player4AmountOfMilitary.. " L3(" .. Player3AmountOfMilitary3+Player4AmountOfMilitary3 ..  ")" .. " Kills: " .. Player3Kills+Player4Kills .. " Settlers: " .. Player3Settlers+Player4Settlers)

	     dbg.stm("Player 1: " .. " Soldiers: " .. Player1AmountOfMilitary.. " L3(" .. Player1AmountOfMilitary3 ..  ")" .. " Kills: " .. Player1Kills .. " Settlers: " .. Player1Settlers)
 	     dbg.stm("Player 2: " .. " Soldiers: " .. Player2AmountOfMilitary.. " L3(" .. Player2AmountOfMilitary3 ..  ")" .. " Kills: " .. Player2Kills .. " Settlers: " .. Player2Settlers)
	     dbg.stm("Player 3: " .. " Soldiers: " .. Player3AmountOfMilitary.. " L3(" .. Player3AmountOfMilitary3 ..  ")" .. " Kills: " .. Player3Kills .. " Settlers: " .. Player3Settlers)
	     dbg.stm("Player 4: " .. " Soldiers: " .. Player4AmountOfMilitary.. " L3(" .. Player4AmountOfMilitary3 ..  ")" .. " Kills: " .. Player4Kills .. " Settlers: " .. Player4Settlers)
        end

    end
    if minuteReached(45) == 1 then
        dbg.stm("--------------------")
        dbg.stm("Möge die Schlacht beginnen! Die PeaceTime (PT) ist vorbei!")
        dbg.stm("--------------------")
    end
end
