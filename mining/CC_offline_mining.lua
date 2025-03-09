--needed to make a mining script that didnt mess up just because the chunk got unloaded or the server restarted
--first make a folder for the settings

-- do be warned this is riddled with bugs and bad coding. it will not work right when the input is a whole number and the gotopos funvtion will not work when going over 0x or 0z


-- { 0 = "n", 1 = "e", 2 = "s", 3 = "w" }
-- { "xPos", "y", "zPos", "dir" }

local args = {...}

local current_pos = {}
local saved_pos   = {}
local home_pos    = { -49, 72, -34, 3}
local homeAmount = 4000
local size = tonumber( args[1] )




function excavateBetter(size)
    

    if args[1] ~= nil then
        serialize('shell.run ("/Turtle/mining/CC_offline_mining.lua")',"startup")
        fs.move("/Turtle/data/startup","/startup")
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
        goToPos(saved_pos)
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
            goToPos(saved_pos)
        end
        dig("d")
        go("d")
    end

    goToPos(home_pos)
    fs.delete("/startup")
    print("Finished mining")

end


function transferCoords(from,to)

    for i = 1,4 do
        to[i] = from[i]
    end
    
end



function updateCoords(pos)

    local x , y , z = gps.locate()

    pos[1]=x
    pos[2]=y
    pos[3]=z
    pos[4]= findDir()

    return pos
    
end 


function updateCoordsLocal(pos)

    local x , y , z = gps.locate()

    pos = {}

    pos[1]=x
    pos[2]=y
    pos[3]=z

    return pos
    
end 

    function findDir()

        local coords = {1,1,1}
        local currentPos = {1,1,1}
        local dir = 0
        local b = 0
        updateCoordsLocal(currentPos)

        local function probe()
            
            if go("f") then
                updateCoordsLocal(coords)
                go("b")
            elseif go("b") then
                updateCoordsLocal(coords)
                go("f")
            else
                print("Please remove block in front or back of turtle")
            end
        end

        probe()

        if coords[1] ~= currentPos[1] then 
            
            if coords[1] < currentPos[1] then
                if b then 
                    dir = 3
                else 
                    dir = 1
                end
            else
                if b then
                    dir = 1
                else
                    dir = 3
                end
            end
        else
            if coords[3] > currentPos[3] then
                if b then
                    dir = 0
                else
                    dir = 2
                end
            else
                if b then
                    dir = 2
                else 
                    dir = 0
                end
            end
        end
        return dir
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

    goToPos(home_pos)
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
    turn("r")
    turtle.select(1)
    turtle.suck(32)
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


function go(str)
    local success = false
    if string.lower(str) == "down" or string.lower(str) == "d" then
        if turtle.down() then
            success = true
        else
            term.write("I'm stuck!")       
        end
    end
    if string.lower(str) == "up" or string.lower(str) == "u" then
        if turtle.up() then
            success = true
        else
            term.write("I'm stuck!")
            
        end
    end
    if string.lower(str) == "forward" or string.lower(str) == "f" then
        if turtle.forward() then
            success = true
        else
            term.write("I'm stuck!")
            
        end
    end
    if string.lower(str) == "back" or string.lower(str) == "b" then
        if turtle.back() then
            success = true
        else
            term.write("I'm stuck!")
            
        end
    end
    return success
end


function turn(str)

    if string.lower(str) == "right" or string.lower(str) == "r" then
        turtle.turnRight()
        current_pos[4] = (current_pos[4] + 1) % 4    
    end
    if string.lower(str) == "left" or string.lower(str) == "l" then
        turtle.turnLeft()
        current_pos[4] = (current_pos[4] - 1) % 4    
    end
end


function rotate(s,e)
    local diff = s - e
    local dir = {}
    if (math.abs(diff) > 0) then
        if     diff == -3 or diff ==  1 then dir = {1, "l"}
        elseif diff ==  3 or diff == -1 then dir = {1, "r"}
        else dir = {2, "r"} end
        for i = 1,dir[1] do
            turn(dir[2])
        end
    end
end

-- this dose not use the first direction to go forward so not fully optimised
-- this has no dig function in it so it cant go through blocks
function checkCoords(pos,pos2)

    if pos[1] == pos2[1] and pos[2] == pos2[2] and pos[3] == pos[3] then
        return true
    else
        return false    
    end
end


function goToPos(pos)
    
    updateCoords(current_pos)
    local s_dir = current_pos[4]
    local e_dir = pos[4]
    local diff = 0
    local x_dir = 0
    local z_dir = 0
    local success = false


    local function findDiff(axis)

        if current_pos[axis] <= 0 then
            if pos[axis] <= 0 then
                diff = math.abs(current_pos[axis] - pos[axis])
            else
                diff = math.abs(current_pos[axis] + pos[axis])
            end
        else
            if pos[axis] >= 0 then
                diff = math.abs(current_pos[axis] - pos[axis])
            else
                diff = math.abs(current_pos[axis] + pos[axis])
            end
        end

        return diff
    end

    if current_pos[2] <= pos[2] then
        for i = 1,findDiff(2) do
            go("u")
        end
        if current_pos[1] <= pos[1] then
            rotate(s_dir,1)
            x_dir = 1
        else
            rotate(s_dir,3)
            x_dir = 3
        end
        for i = 1,findDiff(1) do
            go("f")
        end
        if current_pos[3] <= pos[3] then
            rotate(x_dir,2)
            z_dir = 2
        else
            rotate(x_dir,0)
            z_dir = 0
        end
        for i = 1,findDiff(3) do
            go("f")
        end
        rotate(z_dir,e_dir)
    else
        if current_pos[1] <= pos[1] then
            rotate(s_dir,1)
            x_dir = 1
        else
            rotate(s_dir,3)
            x_dir = 3
        end
        for i = 1,findDiff(1) do
            go("f")
        end
        if current_pos[3] <= pos[3] then
            rotate(x_dir,2)
            z_dir = 2
        else
            rotate(x_dir,0)
            z_dir = 0
        end
        for i = 1,findDiff(3) do
            go("f")
        end
        for i = 1,findDiff(2) do
            go("d")
        end
        rotate(z_dir,e_dir)
    end
    local x , y , z = gps.locate()
    updateCoords(current_pos)
    if current_pos[1] == x and current_pos[2] == y and current_pos[3] == z then
        success = true
        print("gotopos succsesfull")
    else
        print("gotopos unsuccsesfull")
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


if args[1] == nil then
    size = unserialize("size")
else
    size = tonumber( args[1] )
end


excavateBetter(size)
