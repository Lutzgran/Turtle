
local modem = peripheral.wrap("bottom")

print("Launched_RednetAuto")

rednet.open("bottom")


while true do

    local id , msg = rednet.receive()
    local protocol = msg[1]
    local msg = msg[2]
    if protocol == "delivery" then
        os.queueEvent("delivery")
        print("Delivery queued")
    elseif protocol == "extraction" then
        os.queueEvent("extraction",msg)
        print("Extraction queued")
    end
end