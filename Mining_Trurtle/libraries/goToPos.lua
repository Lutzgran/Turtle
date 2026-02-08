-- go to position program

-- local homepos = { -339, 83, 667, 3 }

--print(homepos[1])

function turn(str)
    if string.lower(str) == "right" or string.lower(str) == "r" then
        turtle.turnRight()
    end
    if string.lower(str) == "left" or string.lower(str) == "l" then
        turtle.turnLeft()
    end
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

function findDir()
    local coords = {}
    local currentPos = {}
    local b = false
    local dir = 0
    updateCoordsLocal(currentPos)

    local function probe()
        if go("f") then
            updateCoordsLocal(coords)
            go("b")
        elseif go("b") then
            updateCoordsLocal(coords)
            b = true
            go("forward")
        else
            print("Please remove block in fornt or back of me!!!")
            sleep(5)
            os.reboot()
        end
    end

    probe()

    if coords[1] ~= currentPos[1] then
        if coords[1] > currentPos[1] then
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

function updateCoordsLocal(pos)
    local x, y, z = gps.locate()

    pos[1] = x
    pos[2] = y
    pos[3] = z

    return pos
end

function updateCoords(pos)
    local x, y, z = gps.locate()

    pos[1] = x
    pos[2] = y
    pos[3] = z
    pos[4] = findDir()

    return pos
end

function checkCoords(pos, pos2)
    if pos[1] == pos2[1] and pos[2] == pos2[2] and pos[3] == pos[3] then
        return true
    else
        return false
    end
end

function transferCoords(from, to)
    for i = 1, 4 do
        to[i] = from[i]
    end
end

function rotate(s, e)
    local diff = s - e
    local dir = {}
    if (math.abs(diff) > 0) then
        if diff == -3 or diff == 1 then
            dir = { 1, "l" }
        elseif diff == 3 or diff == -1 then
            dir = { 1, "r" }
        else
            dir = { 2, "r" }
        end
        for i = 1, dir[1] do
            turn(dir[2])
        end
    end
end

function findDiff(axis)
    if cPos[axis] <= 0 then
        if Pos[axis] <= 0 then
            diff = math.abs(cPos[axis] - Pos[axis])
        else
            diff = math.abs(cPos[axis] + Pos[axis])
        end
    else
        if Pos[axis] >= 0 then
            diff = math.abs(cPos[axis] - Pos[axis])
        else
            diff = math.abs(cPos[axis] + Pos[axis])
        end
    end

    return diff
end

function goTo(tPos)
    Pos = tPos
    cPos = {}

    updateCoords(cPos)

    local s_dir = cPos[4]
    local e_dir = tPos[4]
    local dir = 0
    local diff

    if cPos[2] < tPos[2] then
        diff = findDiff(2)

        for i = 1, diff, 1 do
            go("u")
        end

        if cPos[1] < tPos[1] then
            rotate(s_dir, 1)
            dir = 1
        else
            rotate(s_dir, 3)
            dir = 3
        end

        diff = findDiff(1)
        for i = 1, diff, 1 do
            go("f")
        end

        if cPos[3] < tPos[3] then
            rotate(dir, 2)
            dir = 2
        else
            rotate(dir, 0)
            dir = 0
        end

        diff = findDiff(3)
        for i = 1, diff, 1 do
            go("f")
        end
        rotate(dir, e_dir)
    else
        if cPos[1] < tPos[1] then
            rotate(s_dir, 1)
            dir = 1
        else
            rotate(s_dir, 3)
            dir = 3
        end

        diff = findDiff(1)
        for i = 1, diff, 1 do
            go("f")
        end

        if cPos[3] < tPos[3] then
            rotate(dir, 2)
            dir = 2
        else
            rotate(dir, 0)
            dir = 0
        end

        diff = findDiff(3)
        for i = 1, diff, 1 do
            go("f")
        end

        diff = findDiff(2)

        for i = 1, diff, 1 do
            go("d")
        end

        rotate(dir, e_dir)
    end
end

--goTo(homepos)
