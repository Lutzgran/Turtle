
require(".Turtle.Sorting_system.Sorting")

local peripherals = peripheral.getNames()
local monitor = FindMonitor(peripherals)
local vaults = FindVault(peripherals)
local items = Finditems(vaults)
local deposite, extraction = FindChests(peripherals)


monitor.setBackgroundColour(colors.black)
monitor.clear()




function Draw(text,posW,posH,color)
    
    monitor.setTextColour(colors.black)
    monitor.setCursorPos(posW,posH)
    if color == "red" then
        monitor.setBackgroundColour(colors.red)
    else
        monitor.setBackgroundColour(colors.green)
    end
    monitor.write(text)
    monitor.setCursorPos(posW,posH+1)
    monitor.write("      ")
    monitor.setCursorPos(posW,posH-1)
    monitor.write("      ")

end

function Buttons()

    monitor.setTextColour(colors.black)

    Draw(" Pull ",5,10)
    Draw(" Push ",20,10)

end

function LoadingBar()

    local percent = SorageLevel(vaults)
    local maxLength = 11

    monitor.setCursorPos(10, 3)
    monitor.setBackgroundColor(colors.gray)
    monitor.write(string.rep(' ', maxLength))

    monitor.setCursorPos(10, 3)
    monitor.setBackgroundColor(colors.green)
    monitor.write(string.rep(' ', maxLength * percent))

    monitor.setCursorPos(15,2)
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColour(colors.white)
    monitor.write("%")
    
end

function ClickButton(table)

    local value

    if table[3] <= 10 and table[3] >= 5 then
        if table[4] >= 9 and table[4] <= 11 then
            value = "Pull"
            Draw(" Pull ",5,10,"red")
            sleep(1)
            Draw(" Pull ",5,10)
            return value

        end
    end
    if table[3] >= 20 and table[3] <= 25 then
        if table[4] >= 9 and table[4] <= 11 then
            value = "Push"
            Draw(" Push ",20,10,"red")
            sleep(1)
            Draw(" Push ",20,10)
            return value
        end
    end
    return false
end

Buttons()
LoadingBar()

local id = multishell.launch({}, ":/Turtle/Sorting_system/RednetAuto.lua")
multishell.setTitle(id, "RednetAuto")


if not fs.exists("/startup.lua") then
    fs.move("/Turtle/Sorting_system/startup.lua","/startup.lua")
end



while true do

    local eventData = {os.pullEvent()}
    local event = eventData[1]
    
    if event == "monitor_touch" then
    
        local value = ClickButton(eventData)
        local str = ""

        if value == "Pull" then
            write("> ")
            local msg = read()
            if msg == "repurpose" then
                fs.move("/startup.lua","/Turtle/Sorting_system/startup.lua")
                return print("Computer repurpose finished")
            end
            local numb = string.match(msg,"%d[%d.,]*")
            if numb ~= nil then
                str = string.gsub(msg,numb,"")
                print(str,numb)
                numb = tonumber(numb)
                print(Push(str,numb,items,vaults,extraction))
                LoadingBar()
            else
                print(Push(msg,numb,items,vaults,extraction))
                LoadingBar()
            end
        elseif value == "Push" then
            print(Pull(vaults,deposite))
            LoadingBar()
        end
        items = Finditems(vaults)


    elseif event == "delivery" then
        Pull(vaults,deposite)
        LoadingBar()


    elseif event == "extraction" then
        local msg = eventData[2]
        local numb = string.match(msg,"%d[%d.,]*")
        local str = ""
        if numb ~= nil then
            str = string.gsub(msg,numb,"")
            print(str,numb)
            numb = tonumber(numb)
            print(Push(str,numb,items,vaults,extraction))
            LoadingBar()
        else
            print(Push(msg,numb,items,vaults,extraction))
            LoadingBar()
        end
    end
end
