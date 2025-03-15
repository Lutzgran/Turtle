--needed to make a mining script that didnt mess up just because the chunk got unloaded or the server restarted
--first make a folder for the settings

-- do be warned this is riddled with bugs and bad coding. it will not work right when the input is a whole number and the gotopos funvtion will not work when going over 0x or 0z


-- { 0 = "n", 1 = "e", 2 = "s", 3 = "w" }
-- { "xPos", "y", "zPos", "dir" }

local GoToPos = require(".Turtle.libraries.goToPos")

local args = {...}

local current_pos = {}
local saved_pos   = {}
local home_pos    = { -339, 83, 667, 3 }
local homeAmount = 4000
local size = tonumber( args[1] )




function excavateBetter(size)
    

    if args[1] ~= nil then  
        fs.move("/Turtle/mining/startup","/startup")
        updateCoords(current_pos)
        transferCoords(current_pos,home_pos)
        serialize(home_pos,"home_pos")
        serialize(size,"size")
        reFuel()
    else
        saved_pos = unserialize("saved_pos")
        home_pos = unserialize("home_pos")
        updateCoords(current_pos)
        if inventoryCheck() == true then
            if goOfLoad() == false then
                return print("Needs more storage space!!!")
            end
        end
        if fuelCheck(size) == true then
            if reFuel() == false then
                return print("Needs more fuel!!!")
            end
        end
        goTo(saved_pos)
    end

    while current_pos[2] ~= -60 do
        for i = 1,size do
            for j = 1,size - 1 do
                dig("f")
                go("f")
            end
            if i ~= size then
                if i % 2 == 0 then
                    turn("r")
                    dig("f")
                    go("f")
                    turn("r")
                else
                    turn("l")
                    dig("f")
                    go("f")
                    turn("l")
                end
            else   
                turn("r")
                turn("r")
            end
        end 
        updateCoords(current_pos)
        transferCoords(current_pos,saved_pos)
        serialize(saved_pos,"saved_pos")
        if inventoryCheck() == true  or fuelCheck(size) == true then
            if goOfLoad() == false then
                return print("Needs more storage space!!!")
            end
            if turtle.getFuelLevel() < 70000 then
                if reFuel() == false then
                    return print("Needs more fuel!!!")
                end
            end
            goTo(saved_pos)
        end
        dig("d")
        go("d")
    end

    goTo(home_pos)
    fs.move("/startup","/Turtle/mining/startup")
    fs.delete('Turtle/data')
    print("Finished mining")

end

    
function inventoryCheck()  
    local full = true
    local spaces = 0
    for n = 1,16 do
        local nCount = turtle.getItemCount(n)
        if nCount ~= 0 then
            spaces = spaces + 1
        end
    end
    if spaces < 8 then
        full = false
    end
    return full
end


function fuelCheck(size)  
    local notEnough = false
    local fuelAmount = homeAmount + ((size*size)*5)
        
    if turtle.getFuelLevel() < fuelAmount then
        notEnough = true
    end
    return notEnough
end


function goOfLoad()

    local succses

    -- ofloading of resourses

    goTo(home_pos)
    turn("r")
    turn("r")
    for i = 1,16,1 do
        turtle.select(i)
        turtle.drop()
    end
    turn("r")
    turn("r")

    -- check if ofloading was succsesfull

    if inventoryCheck() then
        succses = false
    end

    return succses
end


function reFuel()

    local success = false
    local amounnt = 0
    turn("r")
    turtle.select(1)
    amounnt = turtle.getItemCount()
    amount = amounnt - 64
    turtle.suck(math.abs(amounnt))
    turtle.refuel()
    turn("l")

    if fuelCheck == false then
        reFuel()
    else
        success = true
    end
    return success
end
  

function dig(str)
    local success = false
    if string.lower(str) == "forward" or string.lower(str)  == "f" then success = turtle.dig()
    elseif  string.lower(str) == "up" or string.lower(str)  == "u" then success = turtle.digUp()
    elseif string.lower(str) == "down" or string.lower(str) == "d" then success = turtle.digDown()
    end
    return success
end


function serialize(data, name)
    if not fs.exists('Turtle/data') then
        fs.makeDir('Turtle/data')
    end
    fs.delete('/Turtle/data/'..name)
    local file = fs.open('/Turtle/data/'..name, 'w')
    file.write(textutils.serialize(data))
    file.close()
end


function unserialize(name)
    if fs.exists('/Turtle/data/'..name) then
        local file = fs.open('/Turtle/data/'..name, 'r')
        data = file.readAll()
        file.close()
        data = textutils.unserialize(data)
    end
    return data
end


function go(str)
    local success = false
    if string.lower(str) == "down" or string.lower(str) == "d" then
        if turtle.down() then
            success = true
        else
            term.write("I'm stuck!")
            sleep(5)
            os.reboot()
        end
    end
    if string.lower(str) == "up" or string.lower(str) == "u" then
        if turtle.up() then
            success = true
        else
            term.write("I'm stuck!")
            sleep(5)
            os.reboot()
            
        end
    end
    if string.lower(str) == "forward" or string.lower(str) == "f" then
        if turtle.forward() then
            success = true
        else
            term.write("I'm stuck!")
            sleep(5)
            os.reboot()
        end
    end
    if string.lower(str) == "back" or string.lower(str) == "b" then
        if turtle.back() then
            success = true
        else
            term.write("I'm stuck!")
            sleep(5)
            os.reboot()
            
        end
    end
    return success
end


if args[1] == nil then
    size = unserialize("size")
else
    size = tonumber( args[1] )
end


excavateBetter(size)
