local spawnPos, spawnAng
local directory = "dynamicspawnpoints"

hook.Add("Initialize", "serverStart", function(spawnPos, spawnAng)
    local dataLoad = dynamicSpawning.loadData()

    if !(spawnPos or spawnAng) then 
        return
    else
        if not dataLoad then 
            dynamicSpawning.spawnPoints = {}
        else
            dynamicSpawning.spawnPoints = dataLoad
        end
    end
end)

if not file.Exists(directory, "DATA") then
    file.CreateDir(directory)
end

function dynamicSpawning.saveData()
    file.Write(directory .. "/spawnpoints" .. ".txt", util.TableToJSON(dynamicSpawning.spawnPoints))
end

function dynamicSpawning.loadData()
    local file = directory .. "/spawnpoints" .. ".txt"
    if not file.Exists(file, "DATA") then return end
    local fileData = file.Read(file)
    if not fileData then return end

    return util.JSONToTable(fileData)
end

local function spawnSet(ply, text)
    if (string.lower(text) == "/setspawn") then
        spawnPos = ply:GetPos()
        spawnAng = ply:GetAngles()
        coloredPrint(color_white, ply:Nick() .. " has set the new spawn point @ (", Color(255, 100, 100), tostring(spawnPos), color_white, ") (", Color(255, 100, 100), tostring(spawnAng), color_white, ")\n")
        dynamicSpawning.spawnPoints = {spawnPos, spawnAng}
        dynamicSpawning.saveData()
        return ""
    end

    if (string.lower(text) == "/wipespawn") then 
        spawnPos = nil
        spawnAng = nil
        coloredPrint(color_white, ply:Nick() .. " has wiped the spawn point\n")
        return ""
    end
end

local function playerSpawn(ply)
    if !(spawnPos or spawnAng) then 
        return 
    else
        ply:SetPos(spawnPos)
        ply:SetAngles(spawnAng)
        coloredPrint(color_white, ply:Nick() .. " has successfully spawned @ (", Color(255, 100, 100), tostring(spawnPos), color_white, ") (", Color(255, 100, 100), tostring(spawnAng), color_white, ")\n")
    end
end

hook.Add("PlayerSay", "setSpawn", spawnSet)
hook.Add("PlayerSpawn", "spawnPlayer", playerSpawn)