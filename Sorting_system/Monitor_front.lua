
require(".Turtle.Sorting_system.Sorting")
local peripherals = peripheral.getNames()
local monitor = FindMonitor(peripherals)
--local monitor = peripheral.wrap("monitor_4")




--print(os.pullEvent("monitor_touch"))



monitor.clear()
monitor.setBackgroundColour(colors.white)
monitor.clear()
monitor.setCursorPos(2, 2)
monitor.setTextColour(colors.yellow)
monitor.blit("Hello world!","111111111111","000000000000")

local x , y = monitor.getSize()