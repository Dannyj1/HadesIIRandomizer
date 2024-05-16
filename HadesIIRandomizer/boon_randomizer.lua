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
function randomizeBoons()
    LootData = DeepCopyTable(Hades2Randomizer.Data.LootData)

    local rng = Hades2Randomizer.Data.Rng
    local availableWeaponUpgrades = DeepCopyTable(Hades2Randomizer.Data.WeaponUpgrades)
    local availableTraits = DeepCopyTable(Hades2Randomizer.Data.Traits)
    local availableConsumables = DeepCopyTable(Hades2Randomizer.Data.Consumables)
    local mapping = {}

    DebugPrint({Text = "Randomizing Boons..."})

    -- Randomize boon upgrades
    for _, data in pairs(Hades2Randomizer.Data.WeaponUpgrades) do
        local randomIndex

        if #availableWeaponUpgrades == 1 then
            randomIndex = 1
        else
            randomIndex = RandomInt(1, #availableWeaponUpgrades, rng)
        end

        mapping[data] = availableWeaponUpgrades[randomIndex]
        table.remove(availableWeaponUpgrades, randomIndex)
    end

    for _, data in pairs(Hades2Randomizer.Data.Traits) do
        local randomIndex

        if #availableTraits == 1 then
            randomIndex = 1
        else
            randomIndex = RandomInt(1, #availableTraits, rng)
        end

        mapping[data] = availableTraits[randomIndex]
        table.remove(availableTraits, randomIndex)
    end

    for _, data in pairs(Hades2Randomizer.Data.Consumables) do
        local randomIndex

        if #availableConsumables == 1 then
            randomIndex = 1
        else
            randomIndex = RandomInt(1, #availableConsumables, rng)
        end

        mapping[data] = availableConsumables[randomIndex]
        table.remove(availableConsumables, randomIndex)
    end

    DebugPrint({Text = "Boon Mapping:"})
    DebugPrintTable(mapping, true, 0)

    -- Apply randomized boons to the LootData
    for key, data in pairs(LootData) do
        if data.PriorityUpgrades ~= nil then
            for i, upgrade in ipairs(data.PriorityUpgrades) do
                data.PriorityUpgrades[i] = mapping[upgrade]
            end
        end

        if data.WeaponUpgrades ~= nil then
            for i, upgrade in ipairs(data.WeaponUpgrades) do
                data.WeaponUpgrades[i] = mapping[upgrade]
            end
        end

        if data.Traits ~= nil then
            for i, trait in ipairs(data.Traits) do
                data.Traits[i] = mapping[trait]
            end
        end

        if data.Consumables ~= nil then
            for i, consumable in ipairs(data.Consumables) do
                data.Consumables[i] = mapping[consumable]
            end
        end

        if Hades2Randomizer.Config.RandomizeElementalTraits then
            -- Randomize elemental traits
            -- If a god offers traits and weaponupgrades, they are able to have elemental traits
            if data.Traits ~= nil and data.WeaponUpgrades ~= nil then
                local traitAmount = RandomInt(0, #Hades2Randomizer.Data.ElementalTraits, rng)

                if traitAmount > 0 then
                    if data.OffersElementalTrait == nil then
                        data.OffersElementalTrait = {}
                        DebugPrint({Text = "Elemental Trait: " .. key .. " -> No Elemental Traits"})
                    end

                    local availableElementalTraits = DeepCopyTable(Hades2Randomizer.Data.ElementalTraits)

                    for i = 1, traitAmount do
                        local randomIndex

                        if #availableElementalTraits == 1 then
                            randomIndex = 1
                        else
                            randomIndex = RandomInt(1, #availableElementalTraits, rng)
                        end

                        DebugPrint({Text = "Elemental Trait: " .. key .. " -> " .. availableElementalTraits[randomIndex]})

                        table.insert(data.OffersElementalTrait, availableElementalTraits[randomIndex])
                        table.remove(availableElementalTraits, randomIndex)
                    end
                else
                    data.OffersElementalTrait = nil
                end
            end
        end
    end
end
