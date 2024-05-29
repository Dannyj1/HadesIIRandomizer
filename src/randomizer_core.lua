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

local oStartOver = StartOver
function StartOver(args)
    Hades2Randomizer.Data.RoomCounter = 0
    EncounterData = DeepCopyTable(Hades2Randomizer.Data.EncounterData)
    EnemySets = DeepCopyTable(Hades2Randomizer.Data.EnemySets)
    EnemyData = DeepCopyTable(Hades2Randomizer.Data.EnemyData)

    if Hades2Randomizer.Config.RandomizeEnemies then
        Hades2Randomizer.randomizeEnemies()
    end

    if Hades2Randomizer.Config.ScaleStats then
        Hades2Randomizer.scaleStats()
    end

    if Hades2Randomizer.Config.RandomizeBoonOfferings then
        Hades2Randomizer.randomizeBoonOfferings()
    end

    if Hades2Randomizer.Config.RandomizeKeepsake then
        Hades2Randomizer.randomizeKeepsakes()
    end

    oStartOver(args)
end

local oLoadMap = LoadMap
function LoadMap(argTable)
    oLoadMap(argTable)

    -- Deal with missing textures by loading the packages for all area and loading packages for equipped boons and keeping them loaded
    LoadPackages({ Name = "Erebus" })
    LoadPackages({ Name = "Oceanus" })
    LoadPackages({ Name = "Fields" })
    LoadPackages({ Name = "Tartarus" })
    LoadPackages({ Name = "Ephyra" })
    LoadPackages({ Name = "Thessaly" })
    LoadPackages({ Name = "Asphodel" })

    for _, trait in pairs(CurrentRun.Hero.Traits) do
        if Hades2Randomizer.Data.UpgradePackages[trait.Name] ~= nil then
            LoadPackages({ Name = Hades2Randomizer.Data.UpgradePackages[trait.Name] })
        end
    end
end

local oDoUnlockRoomExits = DoUnlockRoomExits
function DoUnlockRoomExits(run, room)
    Hades2Randomizer.Data.RoomCounter = Hades2Randomizer.Data.RoomCounter + 1

    if Hades2Randomizer.Config.ScaleStats then
        Hades2Randomizer.scaleStats()
    end

    oDoUnlockRoomExits(run, room)
end

