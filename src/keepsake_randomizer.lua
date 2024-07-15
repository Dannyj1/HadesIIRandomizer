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

function Hades2Randomizer.randomizeKeepsakes()
    local rng = Hades2Randomizer.Data.Rng
    local randomIndex = RandomInt(1, #Hades2Randomizer.Data.Keepsakes, rng)
    local randomKeepsake = Hades2Randomizer.Data.Keepsakes[randomIndex]

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
