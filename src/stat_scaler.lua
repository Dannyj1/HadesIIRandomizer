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

local originalMaxHealth = {}
local originalMaxArmor = {}
local originalMaxMinibossHealth = {}
local originalMaxMinibossArmor = {}
local originalDifficulty = {}

if not Hades2Randomizer.Config.Enabled then
    return
end

local function restoreOriginalStats()
    for enemyName, health in pairs(originalMaxHealth) do
        EnemyData[enemyName].MaxHealth = health
    end

    for enemyName, armor in pairs(originalMaxArmor) do
        EnemyData[enemyName].HealthBuffer = armor
    end

    for enemyName, health in pairs(originalMaxMinibossHealth) do
        EnemyData[enemyName].MaxHealth = health
    end

    for enemyName, armor in pairs(originalMaxMinibossArmor) do
        EnemyData[enemyName].HealthBuffer = armor
    end

    for enemyName, difficulty in pairs(originalDifficulty) do
        EnemyData[enemyName].GeneratorData.DifficultyRating = difficulty
    end

    originalMaxHealth = {}
    originalMaxArmor = {}
    originalMaxMinibossHealth = {}
    originalMaxMinibossArmor = {}
    originalDifficulty = {}
end

function Hades2Randomizer.scaleStats()
    restoreOriginalStats()
    Hades2Randomizer.scaleEarlyGameStats()
    Hades2Randomizer.scaleLateGameStats()
end

function Hades2Randomizer.scaleEarlyGameStats()
    if Hades2Randomizer.Data.RoomCounter >= 24 then
        return
    end

    local maxHealth = 999999999
    local maxArmor = 999999999
    local maxMinibossHealth = 999999999
    local maxMinibossArmor = 999999999
    local maxDifficulty = 999999999

    if Hades2Randomizer.Data.RoomCounter <= 13 then
        -- Erebus
        maxHealth = 400
        maxArmor = 350
        maxMinibossHealth = 750
        maxMinibossArmor = 1750
        maxDifficulty = 55
    elseif Hades2Randomizer.Data.RoomCounter <= 23 then
        -- Oceanus
        maxHealth = 750
        maxArmor = 550
        maxMinibossHealth = 1400
        maxMinibossArmor = 2750
        maxDifficulty = 110
    else
        return
    end

    for enemyName, values in pairs(EnemyData) do
        if not Hades2Randomizer.isEnemy(enemyName) and not Hades2Randomizer.isElite(enemyName) and not Hades2Randomizer.isMiniBoss(enemyName) then
            goto continue
        end

        if string.lower(enemyName) == "crawlerminiboss" then
            goto continue
        end

        if Hades2Randomizer.isMiniBoss(enemyName) then
            if values.MaxHealth ~= nil then
                values.MaxHealth = math.min(values.MaxHealth, maxMinibossHealth)
                originalMaxMinibossHealth[enemyName] = values.MaxHealth
            end

            if values.HealthBuffer ~= nil then
                values.HealthBuffer = math.min(values.HealthBuffer, maxMinibossArmor)
                originalMaxMinibossArmor[enemyName] = values.HealthBuffer
            end

            if values.GeneratorData.DifficultyRating ~= nil then
                values.GeneratorData.DifficultyRating = math.min(values.GeneratorData.DifficultyRating, maxDifficulty)
                originalDifficulty[enemyName] = values.GeneratorData.DifficultyRating
            end
        else
            if values.MaxHealth ~= nil then
                values.MaxHealth = math.min(values.MaxHealth, maxHealth)
                originalMaxHealth[enemyName] = values.MaxHealth
            end

            if values.HealthBuffer ~= nil then
                values.HealthBuffer = math.min(values.HealthBuffer, maxArmor)
                originalMaxArmor[enemyName] = values.HealthBuffer
            end

            if values.GeneratorData.DifficultyRating ~= nil then
                values.GeneratorData.DifficultyRating = math.min(values.GeneratorData.DifficultyRating, maxDifficulty)
                originalDifficulty[enemyName] = values.GeneratorData.DifficultyRating
            end
        end

        ::continue::
    end
end

function Hades2Randomizer.scaleLateGameStats()
    if Hades2Randomizer.Data.RoomCounter <= 23 then
        return
    end

    local minDifficulty = 0
    local minHealth = 0
    local minArmor = 0

    if Hades2Randomizer.Data.RoomCounter <= 29 then
        -- Mourning Fields
        minDifficulty = 10
        minHealth = 100
        minArmor = 100
    else
        -- Tartarus/Chronos
        minDifficulty = 25
        minHealth = 200
        minArmor = 200
    end

    -- Apply and store old values, minibosses should be treated the same as enemies in this case
    for enemyName, values in pairs(EnemyData) do
        if not Hades2Randomizer.isEnemy(enemyName) and not Hades2Randomizer.isElite(enemyName) and not Hades2Randomizer.isMiniBoss(enemyName) then
            goto continue
        end

        if values.MaxHealth ~= nil and values.MaxHealth >= 10 then
            values.MaxHealth = math.max(values.MaxHealth, minHealth)
            originalMaxHealth[enemyName] = values.MaxHealth
        end

        if values.HealthBuffer ~= nil and values.MaxHealth >= 10 then
            values.HealthBuffer = math.max(values.HealthBuffer, minArmor)
            originalMaxArmor[enemyName] = values.HealthBuffer
        end

        if values.GeneratorData.DifficultyRating ~= nil then
            values.GeneratorData.DifficultyRating = math.max(values.GeneratorData.DifficultyRating, minDifficulty)
            originalDifficulty[enemyName] = values.GeneratorData.DifficultyRating
        end

        ::continue::
    end
end
