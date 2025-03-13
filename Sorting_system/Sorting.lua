

--local deposite = peripheral.wrap("minecraft:chest_20")
--local extraction = peripheral.wrap("minecraft:chest_19")
local peripherals = peripheral.getNames()
local vaults = {}
local items = {}


local vault = peripheral.wrap("create:item_vault_1")
Test = vault.items(false)
for k,v in pairs(Test) do
    print(k,v)
end
--print(Test[3]["displayName"])
--local vault = peripheral.wrap("create:item_vault_1")

-- cool way to format table data in strings print(("%d x %s in slot %d"):format(item.count, item.name, slot))



-- takes create item vaults and wraps them 
-- the wrapping makes the vaults into tables
-- then the wraped vaults are places into the vaults table

function FindVault()

    for k,v in pairs(peripherals) do
    
         if string.find(v,"create:item_vault") then
            local name = v
            v = peripheral.wrap(v)
            vaults[name]= v    
         end
    end
end



-- takes the vaults from the vault table and uses the items function to get a table of content
-- the table is opened and the displayName index is used to copy the names of the items into the item table

function Finditems()

    for key, vault in pairs(vaults) do   
        local t = vault.items(false)
        for k, table in pairs(t) do
            items[table["displayName"]] = table["name"]
        end
    end
end

function FindChests()

    local a = nil
    local b = nil
    local temp_1 = ""
    local temp_2 = ""

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
end


function Pull()
    
    for k,v in pairs(vaults) do
        
        if v.pullItem(peripheral.getName(deposite)) ~= 0 then
            
            for i = 1,Tablelength(deposite.list()) do

                v.pullItem(peripheral.getName(deposite))
            end
        end
    end
end


function Push(item,numb)
    local success = true
    local count = 0

    for key, value in pairs(items) do

        if string.find(string.lower(key),string.lower(item)) then
            
            if numb > 0 then

                for k,v in pairs(vaults) do 
                    local sent = v.pushItem(peripheral.getName(extraction),value["name"],numb)
                    print(sent)
                    count = count + sent
                    if count >= numb then
                        return success 
                    end
                end
            else
                for k,v in pairs(vaults) do 
                    print(v.pushItem(peripheral.getName(extraction),value["name"]))
                end
            end
        end  
    end 
end


function Tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


function SorageLevel(vault_size)

    local table = {}
    local max_stacks = 1620
    local amount = 0

    for k,v in pairs(vaults) do
        
    end
    
end





--FindChests()
--FindVault()
--Finditems()

--Push("Planks",64)

