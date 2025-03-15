
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

while true do

    local event, button, x, y = os.pullEvent("monitor_touch")
    local table = {event,button,x,y}
    local value = ClickButton(table)
    local str = ""

    if value == "Pull" then
        write("> ")
        local msg = read()
        local numb = string.match(msg,"%d[%d.,]*")
        if numb ~= nil then
            str = string.gsub(msg,numb,"")
            numb = tonumber(numb)
        end
        print(Push(str,numb,items,vaults,extraction))
        LoadingBar()
    elseif value == "Push" then
        print(Pull(vaults,deposite))
        LoadingBar()
    end
    items = Finditems(vaults)
end
