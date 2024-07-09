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

-- TODO: Randomize Chronos spawns and maybe Scylla spawns if that doesn't become too difficult
function Hades2Randomizer.randomizeEnemies()
    local rng = Hades2Randomizer.Data.Rng
    local availableEnemies = DeepCopyTable(Hades2Randomizer.Data.Enemies)
    local availableEliteEnemies = DeepCopyTable(Hades2Randomizer.Data.EliteEnemies)
    local availableMiniBosses = DeepCopyTable(Hades2Randomizer.Data.MiniBosses)
    local availableWeaponOptions = DeepCopyTable(Hades2Randomizer.Data.WeaponOptions)
    local enemiesMapping = {}
    local weaponOptionsMapping = {}

    if Hades2Randomizer.Config.Debug then
        DebugPrint({ Text = "Randomizing Enemies..." })
    end

    for _, values in pairs(EnemyData) do
        -- To fix the spawn locations of certain enemies after randomizing them to a location other than their vanilla location, remove the RequiredSpawnPoint and make it preferred instead.
        if values.RequiredSpawnPoint ~= nil then
            values.PreferredSpawnPoint = values.RequiredSpawnPoint
            values.RequiredSpawnPoint = nil
        end

        -- Disable intro encounters as they mess with the difficulty
        if values.IntroEncounterName ~= nil then
            values.IntroEncounterName = nil
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
    end

    if Hades2Randomizer.Config.RandomizeEnemyWeapons then
        if Hades2Randomizer.Config.Debug then
            DebugPrint({ Text = "Randomizing Enemy Weapons..." })
        end

        -- Randomize enemy WeaponOptions
        for _, weaponOption in ipairs(Hades2Randomizer.Data.WeaponOptions) do
            local randomIndex

            if #availableWeaponOptions == 1 then
                randomIndex = 1
            else
                randomIndex = RandomInt(1, #availableWeaponOptions, rng)
            end

            weaponOptionsMapping[weaponOption] = availableWeaponOptions[randomIndex]
            table.remove(availableWeaponOptions, randomIndex)
        end

        if Hades2Randomizer.Config.Debug then
            DebugPrint({ Text = "Weapon Options Mapping:" })
            DebugPrintTable(weaponOptionsMapping, true, 0)
        end
    end

    if Hades2Randomizer.Config.Debug then
        DebugPrint({ Text = "Enemies Mapping:" })
        DebugPrintTable(enemiesMapping, true, 0)
    end

    -- Apply randomized enemies to the encounter data
    for biome, data in pairs(EncounterData) do
        if string.match(string.lower(biome), "story") or string.match(string.lower(biome), "shop") then
            goto continue
        end

        if data.EnemySet ~= nil and #data.EnemySet > 0 then
            local enemySetCopy = DeepCopyTable(data.EnemySet)

            data.EnemySet = {}
            for _, enemy in ipairs(enemySetCopy) do
                if enemiesMapping[enemy] ~= nil then
                    table.insert(data.EnemySet, enemiesMapping[enemy])
                end
            end
        end

        if data.ManualWaveTemplates ~= nil then
            for _, wave in pairs(data.ManualWaveTemplates) do
                if wave.Spawns ~= nil then
                    for _, spawn in ipairs(wave.Spawns) do
                        if spawn.Name ~= nil and enemiesMapping[spawn.Name] ~= nil then
                            spawn.Name = enemiesMapping[spawn.Name]
                        else
                            spawn = nil
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
                            spawn.Name = enemiesMapping[spawn.Name]
                        else
                            spawn = nil
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
                            spawn.Name = enemiesMapping[spawn.Name]
                        else
                            spawn = nil
                        end
                    end
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
                enemies[i] = enemiesMapping[enemy]
            end
        end

        ::continue::
    end

    -- TODO: LeapSpeed crashes games lol:
    --[[
    [20:16:4.4572000][INFO/log_write.hpp:64] [INFO] [Code\Engine.Native\Code\Script\ScriptAction.cpp:5316] Active Enemy Cap 3.35 = 3 (Base) + 0.35 (ActiveEnemyCapDepthRamp) * 1 (Depth)
[20:16:9.9225598][ERROR/log_write.hpp:64] [ERR] [Code\Engine.Native\Code\Helpers\LuaExt.cpp:326] Script error:
C:\Program Files (x86)\Steam\steamapps\common\Hades II\Content\Scripts\Main.lua:210:
C:\Program Files (x86)\Steam\steamapps\common\Hades II\Content\Scripts\EnemyAILogic.lua:3239: attempt to perform arithmetic on field 'LeapSpeed' (a nil value)

[20:16:9.9225697][INFO/log_write.hpp:64] [INFO] [Code\Engine.Native\Code\Audio\AudioManager.cpp:2396] PauseAllGameSound
[20:16:9.9225737][ERROR/log_write.hpp:64] [ERR] [Code\Engine.Native\Windows\Code\Program.cpp:893] Assert: File = EnemyAILogic.lua, Line = 3239, Condition = Script Error, Message =  attempt to perform arithmetic on field 'LeapSpeed' (a nil value)

Lua Stack Trace:
C:\Program Files (x86)\Steam\steamapps\common\Hades II\Content\Scripts\Main.lua:210:
C:\Program Files (x86)\Steam\steamapps\common\Hades II\Content\Scripts\EnemyAILogic.lua:3239: attempt to perform arithmetic on field 'LeapSpeed' (a nil value),
    ]]
    if Hades2Randomizer.Config.RandomizeEnemyWeapons then
        -- Apply randomized enemy weapons
        for enemyName, data in pairs(EnemyData) do
            if string.match(enemyName, "Base") then
                goto continue
            end

            if Hades2Randomizer.tableContains(Hades2Randomizer.Data.IgnoredEnemies, enemyName) or Hades2Randomizer.tableContains(Hades2Randomizer.Data.IgnoredSets, enemyName) then
                goto continue
            end

            if data.InheritFrom ~= nil and Hades2Randomizer.tableContains(data.InheritFrom, "NPC_Neutral") or Hades2Randomizer.tableContains(data.InheritFrom, "NPC_Giftable") then
                goto continue
            end

            if data.WeaponOptions ~= nil then
                for i, weaponName in ipairs(data.WeaponOptions) do
                    if weaponOptionsMapping[weaponName] ~= nil then
                        data.WeaponOptions[i] = weaponOptionsMapping[weaponName]

                        -- Set DisableOrbitAI to false if OrbitTickDegrees == nil, fixes crashed
                        if data.OrbitTickDegrees == nil then
                            data.DisableOrbitAI = false
                        end
                    end

                    ::continue2::
                end
            end

            ::continue::
        end
    end
end