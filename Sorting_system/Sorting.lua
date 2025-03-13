
-- cool way to format table data in strings print(("%d x %s in slot %d"):format(item.count, item.name, slot))



-- takes create item vaults and wraps them 
-- the wrapping makes the vaults into tables
-- then the wraped vaults are places into the vaults table

function FindVault(peripherals)

    local vaults = {}

    for k,v in pairs(peripherals) do
    
         if string.find(v,"create:item_vault") then
            local name = v
            v = peripheral.wrap(v)
            vaults[name]= v    
         end
    end
    return vaults
end



-- takes the vaults from the vault table and uses the items function to get a table of content
-- the table is opened and the displayName index is used to copy the names of the items into the item table

function Finditems(vaults)

    local items = {}

    for key, vault in pairs(vaults) do   
        local t = vault.items(false)
        for k, table in pairs(t) do
            items[table["displayName"]] = table["name"]
        end
    end
    return items
end


function FindChests(peripherals)

    local a = nil
    local b = nil
    local temp_1 = ""
    local temp_2 = ""
    local deposite = {}
    local extraction  = {}

    for k, v in pairs(peripherals) do

        if string.find(v,"minecraft:chest") then
            if a == nil then
                a = tonumber(string.sub(v,17,100))
                temp_1 = v
            else
                b = tonumber(string.sub(v,17,100))
                temp_2 = v
            end
        end     
    end

    if a > b then
        deposite = peripheral.wrap(temp_1)
        extraction = peripheral.wrap(temp_2)
    else
        deposite = peripheral.wrap(temp_2)
        extraction = peripheral.wrap(temp_1)
    end
    return deposite, extraction
end

function FindMonitor(peripherals)

    local monitor = {}

    for key, value in pairs(peripherals) do

        if string.find(value,"monitor")then
            monitor = peripheral.wrap(value)          
            return monitor
        end
        
    end
    
end

function Pull(vaults,deposite)
    
    for k,v in pairs(vaults) do
        
        if v.pullItem(peripheral.getName(deposite)) ~= 0 then
            
            for i = 1,Tablelength(deposite.list()) do

                v.pullItem(peripheral.getName(deposite))
            end
        end
    end
end


function Push(item,numb,items,vaults,extraction)
    local success = false
    local count = 0

    for key, value in pairs(items) do

        if string.find(string.lower(key),string.lower(item)) then
            
            if numb > 0 then

                for k,v in pairs(vaults) do 
                    local sent = v.pushItem(peripheral.getName(extraction),value["name"],numb)
                    print(sent)
                    count = count + sent
                    if count >= numb then
                        success = true
                        return success 
                    end
                end
            else
                for k,v in pairs(vaults) do 
                    print(v.pushItem(peripheral.getName(extraction),value["name"]))
                    success = true
                    return success
                end
            end
        end  
    end 
    return success
end


function Tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


function SorageLevel(vaults)
    
    local max_stacks = 0
    local amount = 0

    for k,v in pairs(vaults) do
        max_stacks = max_stacks + 1620
        local items = v.items(false)
        for kk, vv in pairs(items) do
            amount = amount + vv["count"]  
        end
    end
    local numb = tostring(amount/max_stacks)
    local result = tonumber(string.sub(numb,1,4))
    return result
end




--local peripherals = peripheral.getNames()
--local deposite, extraction = FindChests(peripherals)
--local vaults = FindVault(peripherals)
--local items = Finditems(vaults)

--Push("Planks",64,items,vaults,extraction)

--Pull(vaults,deposite)
--SorageLevel(vaults)