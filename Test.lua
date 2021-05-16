

-------------------------------------------------------------
-------------------------------------------------------------
------ generalUtility  --------------------------------------
-------Diese könnt ihr für eure Scripts nutzen---------------
-------------------------------------------------------------

TRUE = 1
FALSE = 0


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



function randomBetween(fromNumber, toNumber)
    randomseed(date("%S"))

    local divNumber = toNumber - fromNumber
    local randomNumber = fromNumber + floorNumber(random() * (divNumber + 1))
    return randomNumber
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


-------------------------------------------------------------
-------------------------------------------------------------
---------------------
-------------------------------------------------------------


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



function getRandomIsland()
    local amountOfIslands = 0
    if amountOfIslands == 0 then
        return finalIsland
    else
        local availableIslands = getAvailableIslands()
        return islands[getRandomNumberOfNumbers(availableIslands)]
    end
end

function getAvailableIslands()
    local allIslands = {1,0,1,1,0}
    local activeIslands = {}

    local counter = 1

    while counter <= getn(allIslands) do
        if allIslands[counter] == 1 then
            activeIslands[getn(activeIslands) + 1]  = counter
        end
        counter = counter + 1
    end
    return activeIslands
end


function getRandomNumberOfNumbers(numbers)
    local randomNumber = randomBetween(1, getn(numbers))
    ---print(randomNumber)
    return numbers[randomNumber]
end


---------------------------------------
-------------doTestHere---------------
----------------------------------------
local availableIslands = getAvailableIslands()
print(randomBetween(2,5))
print(getRandomNumberOfNumbers(availableIslands))


