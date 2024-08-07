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

function Hades2Randomizer.randomizeEquippedCards()
    local rng = Hades2Randomizer.Data.Rng

    for name, _ in pairs(MetaUpgradeCardData) do
        if GameState.MetaUpgradeState[name] and GameState.MetaUpgradeState[name].Unlocked then
            local roll = RandomInt(1, 100, rng)

            if roll <= Hades2Randomizer.Config.ArcanaCardEquipChance then
                DebugPrint({Text = "Equipping Card: " .. name})
                GameState.MetaUpgradeState[name].Equipped = true
            else
                DebugPrint({Text = "Unequipping Card: " .. name})
                GameState.MetaUpgradeState[name].Equipped = false
            end
        end
    end
end
