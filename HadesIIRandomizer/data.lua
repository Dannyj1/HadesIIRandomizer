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

Hades2Randomizer.Data = {
    RoomCounter = 0,
    Rng = RandomInit(64),

    EncounterData = nil,
    EnemySets = nil,
    EnemyData = nil,
    LootData = nil,

    PriorityUpgrades = {},
    WeaponUpgrades = {},
    Traits = {},
    Consumables = {},
    ElementalTraits = {},

    Enemies = {"LightRanged", "SatyrCultist"},
    EliteEnemies = {},
    -- Most of the minibosses will be filled dynamically, but they don't all have the word "miniboss" in their name or are defined in EnemySets
    MiniBosses = {"Treant", "FogEmitter_Elite", "Vampire", "WaterUnitMiniboss", "CrawlerMiniboss",
                  "SatyrRatCatcher_Miniboss", "GoldElemental_MiniBoss"},

    IgnoredSets = {"TestEnemies", "AllEliteAttributes", "RangedOnlyEliteAttributes", "ShadeOnlyEliteAttributes",
                   "EliteAttributesRunBanOptions", "BiomeP"}
}

ModUtil.LoadOnce(function()
    Hades2Randomizer.Data.EncounterData = DeepCopyTable(EncounterData)
    Hades2Randomizer.Data.EnemySets = DeepCopyTable(EnemySets)
    Hades2Randomizer.Data.EnemyData = DeepCopyTable(EnemyData)
    Hades2Randomizer.Data.LootData = DeepCopyTable(LootData)

    -- Load enemy data
    for biome, enemies in pairs(EnemySets) do
        if tableContains(Hades2Randomizer.Data.IgnoredSets, biome) then
            goto continue
        end

        for _, enemy in ipairs(enemies) do
            if EnemyData[enemy] ~= nil then
                if string.find(string.lower(enemy), "miniboss") or tableContains(Hades2Randomizer.Data.MiniBosses, enemy) then
                    if not tableContains(Hades2Randomizer.Data.MiniBosses, enemy) then
                        table.insert(Hades2Randomizer.Data.MiniBosses, enemy)
                    end
                elseif string.find(string.lower(enemy), "elite") or (EnemyData[enemy].InheritFrom ~= nil
                        and tableContains(EnemyData[enemy].InheritFrom, "Elite")) or EnemyData[enemy].HealthBuffer ~= nil then
                    -- Elite enemies generally have armor
                    if not tableContains(Hades2Randomizer.Data.EliteEnemies, enemy) then
                        table.insert(Hades2Randomizer.Data.EliteEnemies, enemy)
                    end
                else
                    if not tableContains(Hades2Randomizer.Data.Enemies, enemy) then
                        table.insert(Hades2Randomizer.Data.Enemies, enemy)
                    end
                end
            end
        end

        ::continue::
    end

    -- Load LootTable/Boon data
    for _, data in pairs(LootData) do
        if data.PriorityUpgrades ~= nil then
            for _, upgrade in ipairs(data.PriorityUpgrades) do
                if not tableContains(Hades2Randomizer.Data.PriorityUpgrades, upgrade) then
                    table.insert(Hades2Randomizer.Data.PriorityUpgrades, upgrade)
                end
            end
        end

        if data.WeaponUpgrades ~= nil then
            for _, upgrade in ipairs(data.WeaponUpgrades) do
                if not tableContains(Hades2Randomizer.Data.WeaponUpgrades, upgrade) then
                    table.insert(Hades2Randomizer.Data.WeaponUpgrades, upgrade)
                end
            end
        end

        if data.Traits ~= nil then
            for _, trait in ipairs(data.Traits) do
                if not tableContains(Hades2Randomizer.Data.Traits, trait) then
                    table.insert(Hades2Randomizer.Data.Traits, trait)
                end
            end
        end

        if data.Consumables ~= nil then
            for _, consumable in ipairs(data.Consumables) do
                if not tableContains(Hades2Randomizer.Data.Consumables, consumable) then
                    table.insert(Hades2Randomizer.Data.Consumables, consumable)
                end
            end
        end

        if data.OffersElementalTrait ~= nil then
            for _, trait in ipairs(data.OffersElementalTrait) do
                if not tableContains(Hades2Randomizer.Data.ElementalTraits, trait) then
                    table.insert(Hades2Randomizer.Data.ElementalTraits, trait)
                end
            end
        end
    end
end)

function isElite(enemy)
    return tableContains(Hades2Randomizer.Data.EliteEnemies, enemy)
end

function isMiniBoss(enemy)
    return tableContains(Hades2Randomizer.Data.MiniBosses, enemy)
end

function isEnemy(enemy)
    return tableContains(Hades2Randomizer.Data.Enemies, enemy)
end
