

local deposite = peripheral.wrap("minecraft:chest_20")
local extraction = peripheral.wrap("minecraft:chest_19")
local peripherals = peripheral.getNames()
local vaults = {}
local items = {}


--local vault = peripheral.wrap("create:item_vault_1")
--Test = vault.items(false)
--for k,v in pairs(Test) do
    --print(k,v)
--end
--print(Test[3]["displayName"])


--local vault = peripheral.wrap("create:item_vault_1")


-- takes create item vaults and wraps them 
-- the wrapping makes the vaults into tables
-- then the wraped vaults are places into the vaults table

function FindVault()

    for k,v in pairs(peripherals) do
    
         if string.find(v,"create:item_vault") then
            print(v)
            v = peripheral.wrap(v)
            vaults[k]= v    
         end
    end
end


-- takes the vaults from the vault table and uses the items function to get a table of content
-- the table is opened and the displayName index is used to copy the names of the items into the item table

function Finditems()

    for key, vault in pairs(vaults) do   
        t = vault.items(false)

        for k, table in pairs(t) do
            items[k] = table["displayName"]
        end
    end
end

FindVault()
Finditems()



function Pull(item)

    
    
end

function Push()
    
end


