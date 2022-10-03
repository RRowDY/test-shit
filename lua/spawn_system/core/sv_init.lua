dynamicSpawning.spawnTable = {}
local color = dynamicSpawning.colorTable

function dynamicSpawning.storeSpawnPosition(ply)
    local pos = ply:GetPos()

    dynamicSpawning.addSpawnPosition(pos)
end

function dynamicSpawning.addSpawnPosition(pos)
    if (table.IsEmpty(dynamicSpawning.spawnTable)) then 
        dynamicSpawning.coloredPrint(color.red, "[SERVER] ", color_white, "Spawn table was empty, ", color.red, tostring(pos), color_white, " was added to the spawn table\n")
        dynamicSpawning.spawnTable = {pos}
    else
        table.insert(dynamicSpawning.spawnTable, pos)
    end
end

function dynamicSpawning.getRandomSpawnPosition(spawnPos)
    spawnPosition = dynamicSpawning.spawnTable[math.random(#dynamicSpawning.spawnTable)]
    
    return spawnPosition
end

function dynamicSpawning.handlePlayerSpawn(ply, spawnPos)
    if (table.IsEmpty(dynamicSpawning.spawnTable)) then 
        dynamicSpawning.coloredPrint(color.red, "[SERVER] ", color_white, "Spawn table is empty, falling back to default map spawns\n")
        return
    end

    spawnPos = dynamicSpawning.getRandomSpawnPosition()

    ply:SetPos(spawnPos)
    dynamicSpawning.coloredPrint(color.red, "[SERVER] ", color.green, ply:Nick(), color_white, " has spawned at ", color.red, tostring(spawnPos) .. "\n")
end

function dynamicSpawning.handleSpawnStore(ply, txt)
    if (string.lower(txt) == "/addspawn") then 
        dynamicSpawning.storeSpawnPosition(ply)
        dynamicSpawning.coloredPrint(color.red, "[SERVER] ", color.green, ply:Nick(), color_white, " added ", color.red, tostring(ply:GetPos()), color_white, " to the spawn table\n")
        return ""
    end
end

hook.Add("PlayerSay", "addSpawn", dynamicSpawning.handleSpawnStore)
hook.Add("PlayerSpawn", "spawnPlayer", dynamicSpawning.handlePlayerSpawn)