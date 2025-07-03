--[[
Copyright 2024 Danny Jelsma

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
]]

if not Hades2Randomizer.Config.Enabled then
    return
end

-- TODO: This function needs some cleanup...
function Hades2Randomizer.randomizeEnemies()
    local rng = Hades2Randomizer.Data.Rng
    local availableEnemies = ShallowCopyTable(Hades2Randomizer.Data.Enemies)
    local availableEliteEnemies = ShallowCopyTable(Hades2Randomizer.Data.EliteEnemies)
    local availableMiniBosses = ShallowCopyTable(Hades2Randomizer.Data.MiniBosses)
    local enemiesMapping = {}

    DebugPrint({ Text = "Randomizing Enemies..." })

    for _, values in pairs(EnemyData) do
        -- To fix the spawn locations of certain enemies after randomizing them to a location other than their vanilla location, remove the RequiredSpawnPoint and make it preferred instead.
        if values.RequiredSpawnPoint ~= nil then
            Hades2Randomizer.trackAndChange(values, "PreferredSpawnPoint", values.RequiredSpawnPoint)
            Hades2Randomizer.trackAndChange(values, "RequiredSpawnPoint", nil)
        end

        -- Disable intro encounters as they mess with the difficulty
        if values.IntroEncounterName ~= nil then
            Hades2Randomizer.trackAndChange(values, "IntroEncounterName", nil)
        end
    end

    -- Randomize enemies
    for _, enemy in ipairs(Hades2Randomizer.Data.Enemies) do
        local randomIndex

        if #availableEnemies == 1 then
            randomIndex = 1
        else
            randomIndex = RandomInt(1, #availableEnemies, rng)
        end

        enemiesMapping[enemy] = availableEnemies[randomIndex]
        table.remove(availableEnemies, randomIndex)

        if #availableEnemies <= 0 then
            availableEnemies = ShallowCopyTable(Hades2Randomizer.Data.Enemies)
        end
    end

    for _, eliteEnemy in ipairs(Hades2Randomizer.Data.EliteEnemies) do
        local randomIndex

        if #availableEliteEnemies == 1 then
            randomIndex = 1
        else
            randomIndex = RandomInt(1, #availableEliteEnemies, rng)
        end

        enemiesMapping[eliteEnemy] = availableEliteEnemies[randomIndex]
        table.remove(availableEliteEnemies, randomIndex)

        if #availableEliteEnemies <= 0 then
            availableEliteEnemies = ShallowCopyTable(Hades2Randomizer.Data.EliteEnemies)
        end
    end

    for _, miniBoss in ipairs(Hades2Randomizer.Data.MiniBosses) do
        local randomIndex

        if #availableMiniBosses == 1 then
            randomIndex = 1
        else
            randomIndex = RandomInt(1, #availableMiniBosses, rng)
        end

        enemiesMapping[miniBoss] = availableMiniBosses[randomIndex]
        table.remove(availableMiniBosses, randomIndex)

        if #availableMiniBosses <= 0 then
            availableMiniBosses = ShallowCopyTable(Hades2Randomizer.Data.MiniBosses)
        end
    end

    -- re-fill availableEnemies, availableEliteEnemies and availableMiniBosses. Remove any weapon that has spawner options.
    availableEnemies = ShallowCopyTable(Hades2Randomizer.Data.Enemies)
    availableEliteEnemies = ShallowCopyTable(Hades2Randomizer.Data.EliteEnemies)
    availableMiniBosses = ShallowCopyTable(Hades2Randomizer.Data.MiniBosses)

    for _, enemy in ipairs(Hades2Randomizer.Data.Enemies) do
        local enemyWeaponOptions = EnemyData[enemy].WeaponOptions

        if enemyWeaponOptions ~= nil then
            for _, weaponOption in ipairs(enemyWeaponOptions) do
                local weaponData = WeaponData[weaponOption]

                if weaponData ~= nil and weaponData.AIData ~= nil and weaponData.AIData.SpawnerOptions ~= nil then
                    table.remove(availableEnemies, Hades2Randomizer.indexOf(availableEnemies, enemy))
                end
            end
        end
    end

    for _, eliteEnemy in ipairs(Hades2Randomizer.Data.EliteEnemies) do
        local eliteEnemyWeaponOptions = EnemyData[eliteEnemy].WeaponOptions

        if eliteEnemyWeaponOptions ~= nil then
            for _, weaponOption in ipairs(eliteEnemyWeaponOptions) do
                local weaponData = WeaponData[weaponOption]

                if weaponData ~= nil and weaponData.AIData ~= nil and weaponData.AIData.SpawnerOptions ~= nil then
                    table.remove(availableEliteEnemies, Hades2Randomizer.indexOf(availableEliteEnemies, eliteEnemy))
                end
            end
        end
    end

    for _, miniBoss in ipairs(Hades2Randomizer.Data.MiniBosses) do
        local miniBossWeaponOptions = EnemyData[miniBoss].WeaponOptions

        if miniBossWeaponOptions ~= nil then
            for _, weaponOption in ipairs(miniBossWeaponOptions) do
                local weaponData = WeaponData[weaponOption]

                if weaponData ~= nil and weaponData.AIData ~= nil and weaponData.AIData.SpawnerOptions ~= nil then
                    table.remove(availableMiniBosses, Hades2Randomizer.indexOf(availableMiniBosses, miniBoss))
                end
            end
        end
    end

    -- An enemy that is spawned by a WeaponOption with SpawnerOptions can never map to another enemy that has a WeaponOption with SpawnerOptions (can be any, does not have to be the same), as this will cause unlimited spawns that increase exponentially. These need to be remapped to another random enemy/elite/miniBoss
    for enemyFrom, _ in pairs(enemiesMapping) do
        local enemyFromWeaponOptions = EnemyData[enemyFrom].WeaponOptions

        if enemyFromWeaponOptions ~= nil then
            for _, weaponOption in ipairs(enemyFromWeaponOptions) do
                local enemyFromWeaponData = WeaponData[weaponOption]
                
                if enemyFromWeaponData ~= nil and enemyFromWeaponData.AIData ~= nil and enemyFromWeaponData.AIData.SpawnerOptions ~= nil then
                    -- Enemies from enemyFromWeaponData.AIData.SpawnerOptions can not map to another enemy that has a WeaponOption with SpawnerOptions ~= nil
                    for _, spawnedEnemyName in ipairs(enemyFromWeaponData.AIData.SpawnerOptions) do
                        local mapping = enemiesMapping[spawnedEnemyName]

                        if mapping ~= nil then
                            local mappingWeaponOptions = EnemyData[mapping].WeaponOptions

                            if mappingWeaponOptions ~= nil then
                                for _, mappingWeaponOption in ipairs(mappingWeaponOptions) do
                                    local mappingWeaponData = WeaponData[mappingWeaponOption]

                                    if mappingWeaponData ~= nil and mappingWeaponData.AIData ~= nil and mappingWeaponData.AIData.SpawnerOptions ~= nil then
                                        DebugPrint({ Text = "Mapping " .. spawnedEnemyName .. " to " .. mapping .. " is not allowed, remapping..." })
                                        local randomIndex

                                        if Hades2Randomizer.isEnemy(mapping) then
                                            randomIndex = RandomInt(1, #availableEnemies, rng)
                                            enemiesMapping[spawnedEnemyName] = availableEnemies[randomIndex]
                                            table.remove(availableEnemies, randomIndex)
                                        elseif Hades2Randomizer.isElite(mapping) then
                                            randomIndex = RandomInt(1, #availableEliteEnemies, rng)
                                            enemiesMapping[spawnedEnemyName] = availableEliteEnemies[randomIndex]
                                            table.remove(availableEliteEnemies, randomIndex)
                                        elseif Hades2Randomizer.isMiniBoss(mapping) then
                                            randomIndex = RandomInt(1, #availableMiniBosses, rng)
                                            enemiesMapping[spawnedEnemyName] = availableMiniBosses[randomIndex]
                                            table.remove(availableMiniBosses, randomIndex)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    DebugPrint({ Text = "Enemies Mapping:" })
    DebugPrintTable(enemiesMapping, true, 0)

    -- Apply randomized enemies to the encounter data
    for biome, data in pairs(EncounterData) do
        if string.match(string.lower(biome), "story") or string.match(string.lower(biome), "shop") then
            goto continue
        end

        if data.EnemySet ~= nil and #data.EnemySet > 0 then
            local newEnemySet = {}
            for _, enemy in ipairs(data.EnemySet) do
                if enemiesMapping[enemy] ~= nil then
                    table.insert(newEnemySet, enemiesMapping[enemy])
                end
            end
            Hades2Randomizer.trackAndChange(data, "EnemySet", newEnemySet)
        end

        if data.ManualWaveTemplates ~= nil then
            for _, wave in pairs(data.ManualWaveTemplates) do
                if wave.Spawns ~= nil then
                    for _, spawn in ipairs(wave.Spawns) do
                        if spawn.Name ~= nil and enemiesMapping[spawn.Name] ~= nil then
                            Hades2Randomizer.trackAndChange(spawn, "Name", enemiesMapping[spawn.Name])
                        else
                            Hades2Randomizer.trackAndChange(wave.Spawns, spawn, nil)
                        end
                    end
                end
            end
        end

        if data.SpawnWaves ~= nil then
            for _, wave in pairs(data.SpawnWaves) do
                if wave.Spawns ~= nil then
                    for _, spawn in ipairs(wave.Spawns) do
                        if spawn.Name ~= nil and enemiesMapping[spawn.Name] ~= nil then
                            Hades2Randomizer.trackAndChange(spawn, "Name", enemiesMapping[spawn.Name])
                        else
                            Hades2Randomizer.trackAndChange(wave.Spawns, spawn, nil)
                        end
                    end
                end
            end
        end

        if data.WaveTemplates ~= nil then
            for _, wave in pairs(data.WaveTemplates) do
                if wave.Spawns ~= nil then
                    for _, spawn in ipairs(wave.Spawns) do
                        if spawn.Name ~= nil and enemiesMapping[spawn.Name] ~= nil then
                            Hades2Randomizer.trackAndChange(spawn, "Name", enemiesMapping[spawn.Name])
                        else
                            Hades2Randomizer.trackAndChange(wave.Spawns, spawn, nil)
                        end
                    end
                end
            end
        end

        -- Update WipeEnemiesOnKill so miniboss summons are wiped on kill
        if data.WipeEnemiesOnKill ~= nil then
            if enemiesMapping[data.WipeEnemiesOnKill] ~= nil then
                Hades2Randomizer.trackAndChange(data, "WipeEnemiesOnKill", enemiesMapping[data.WipeEnemiesOnKill])
            end
        end

        if data.WipeEnemiesOnKillAllTypes ~= nil then
            for i, enemy in ipairs(data.WipeEnemiesOnKillAllTypes) do
                if enemiesMapping[enemy] ~= nil then
                    Hades2Randomizer.trackAndChange(data.WipeEnemiesOnKillAllTypes, i, enemiesMapping[enemy])
                end
            end
        end

        ::continue::
    end

    for key, enemies in pairs(EnemySets) do
        if Hades2Randomizer.tableContains(Hades2Randomizer.Data.IgnoredSets, key) then
            goto continue
        end

        for i, enemy in ipairs(enemies) do
            if enemiesMapping[enemy] ~= nil then
                Hades2Randomizer.trackAndChange(enemies, i, enemiesMapping[enemy])
            end
        end

        ::continue::
    end

    -- Apply randomized enemies to Enemy Weapon Data
    for _, weaponData in pairs(WeaponData) do
        if weaponData.AIData ~= nil and weaponData.AIData.SpawnerOptions ~= nil then
            for i, enemyName in ipairs(weaponData.AIData.SpawnerOptions) do
                if enemiesMapping[enemyName] ~= nil then
                    Hades2Randomizer.trackAndChange(weaponData.AIData.SpawnerOptions, i, enemiesMapping[enemyName])
                end
            end
        end
    end

    -- Apply to Vow of Wandering SwapMap
    local newSwapMap = {}
    for key, value in pairs(MetaUpgradeData.NextBiomeEnemyShrineUpgrade.SwapMap) do
        local newKey = key
        local newValueName = value.Name

        if enemiesMapping[key] ~= nil then
            newKey = enemiesMapping[key]
        end

        if enemiesMapping[value.Name] ~= nil then
            newValueName = enemiesMapping[value.Name]
        end
        newSwapMap[newKey] = { Name = newValueName }
    end
    Hades2Randomizer.trackAndChange(MetaUpgradeData.NextBiomeEnemyShrineUpgrade, "SwapMap", newSwapMap)

    DebugPrintTable(MetaUpgradeData.NextBiomeEnemyShrineUpgrade.SwapMap, true, 0)
end
