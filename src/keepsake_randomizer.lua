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

local function isKeepsakeUnlocked(keepsakeName)
    local keepsakeData = GetKeepsakeData(keepsakeName)
    if keepsakeData ~= nil then
        return IsGameStateEligible(CurrentRun, keepsakeData.GiftLevelData, keepsakeData.GiftLevelData.GameStateRequirements)
    end

    return false
end

local function hasAnyKeepsakesUnlocked()
    for _, itemName in ipairs(ScreenData.KeepsakeRack.ItemOrder) do
        local keepsakeData = GetKeepsakeData( itemName )
        if keepsakeData ~= nil then
            if isKeepsakeUnlocked(itemName) then
                return true
            end
        end
    end

    return false
end

function Hades2Randomizer.randomizeKeepsakes()
    if not hasAnyKeepsakesUnlocked() then
        DebugPrint({Text = "No keepsakes unlocked, not randomizing keepsake"})
        return
    end

    local rng = Hades2Randomizer.Data.Rng
    local randomIndex = RandomInt(1, #Hades2Randomizer.Data.Keepsakes, rng)
    local randomKeepsake = Hades2Randomizer.Data.Keepsakes[randomIndex]

    while not isKeepsakeUnlocked(randomKeepsake) do
        randomIndex = RandomInt(1, #Hades2Randomizer.Data.Keepsakes, rng)
        randomKeepsake = Hades2Randomizer.Data.Keepsakes[randomIndex]
    end

    DebugPrint({Text = "Randomizing Keepsake: " .. randomKeepsake})

    if GameState.LastAwardTrait ~= nil and HeroHasTrait(GameState.LastAwardTrait) then
        UnequipKeepsake(CurrentRun.Hero, GameState.LastAwardTrait)
    end

    if HeroHasTrait(randomKeepsake) then
        UnequipKeepsake(CurrentRun.Hero, randomKeepsake)
    end

    GameState.LastAwardTrait = randomKeepsake
    EquipKeepsake(CurrentRun.Hero, randomKeepsake)
end

local oLeaveRoom = LeaveRoom
function LeaveRoom(currentRun, door)
    oLeaveRoom(currentRun, door)

    if Hades2Randomizer.Config.RandomizeKeepsake then
        if string.match(string.lower(door.Room.Name), "postboss") then
            Hades2Randomizer.randomizeKeepsakes()
            door.Room.BlockKeepsakeMenu = true
        end
    end
end
