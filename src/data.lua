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

Hades2Randomizer.Data = {
    RoomCounter = 0,
    Rng = RandomInit(64),

    EncounterData = nil,
    EnemySets = nil,
    EnemyData = nil,
    LootData = nil,
    SwapMap = nil,

    PriorityUpgrades = {},
    WeaponUpgrades = {},
    Traits = {},
    Consumables = {},
    ElementalTraits = {},
    Keepsakes = {},
    Weapons = {},
    Aspects = {},
    WeaponOptions = {},

    Enemies = {"LightRanged"},
    EliteEnemies = {},
    -- Most of the minibosses will be filled dynamically, but they don't all have the word "miniboss" in their name or are defined in EnemySets
    MiniBosses = {"Treant", "FogEmitter_Elite", "Vampire", "WaterUnitMiniboss",
                  "SatyrRatCatcher_Miniboss", "GoldElemental_MiniBoss"},

    IgnoredSets = {"TestEnemies", "AllEliteAttributes", "RangedOnlyEliteAttributes", "ShadeOnlyEliteAttributes",
                   "EliteAttributesRunBanOptions", "BiomeP", "ManaUpgrade", "NPC_Artemis_Field_01"},
    IgnoredEnemies = {"CrawlerMiniboss", "BattleStandardChronos"},
    IgnoredWeaponOptions = {"HecateSplit1", "HecateSplit2", "HecateSplit3", "WaterUnitDive", "SirenDrummerBeatCoralFar"},
    UpgradePackages = {},
}

local function isWeaponOptionBlacklisted(weaponName)
    return Hades2Randomizer.tableContains(Hades2Randomizer.Data.WeaponOptions, weaponName)
            or Hades2Randomizer.tableContains(Hades2Randomizer.Data.IgnoredWeaponOptions, weaponName)
            or string.match(weaponName, "Sheep") or string.match(weaponName, "Passive")
            or string.match(weaponName, "Base") or string.match(weaponName, "Trap")
            or string.match(weaponName, "Test") or string.match(weaponName, "OilPuddle")
end

local function addEnemyToData(enemy)
    if EnemyData[enemy] == nil then
        return
    end

    if EnemyData[enemy].IsBoss ~= nil and EnemyData[enemy].IsBoss == false then
        return
    end

    if Hades2Randomizer.tableContains(Hades2Randomizer.Data.IgnoredEnemies, enemy) then
        return
    end

    if string.find(string.lower(enemy), "sheep") then
        return
    end

    if Hades2Randomizer.tableContains(Hades2Randomizer.Data.MiniBosses, enemy)
            or Hades2Randomizer.tableContains(Hades2Randomizer.Data.EliteEnemies, enemy)
            or Hades2Randomizer.tableContains(Hades2Randomizer.Data.Enemies, enemy) then
        return
    end

    if string.find(string.lower(enemy), "miniboss") then
        table.insert(Hades2Randomizer.Data.MiniBosses, enemy)
    elseif string.find(string.lower(enemy), "elite") or (EnemyData[enemy].InheritFrom ~= nil
            and Hades2Randomizer.tableContains(EnemyData[enemy].InheritFrom, "Elite"))
            or EnemyData[enemy].HealthBuffer ~= nil then
        -- Elite enemies generally have armor, hence the HealthBuffer check
        table.insert(Hades2Randomizer.Data.EliteEnemies, enemy)
    else
        table.insert(Hades2Randomizer.Data.Enemies, enemy)
    end
end

ModUtil.LoadOnce(function()
    Hades2Randomizer.Data.EncounterData = DeepCopyTable(EncounterData)
    Hades2Randomizer.Data.EnemySets = DeepCopyTable(EnemySets)
    Hades2Randomizer.Data.EnemyData = DeepCopyTable(EnemyData)
    Hades2Randomizer.Data.LootData = DeepCopyTable(LootData)
    Hades2Randomizer.Data.SwapMap = DeepCopyTable(MetaUpgradeData.NextBiomeEnemyShrineUpgrade.SwapMap)

    -- Load enemy data
    for biome, enemies in pairs(EnemySets) do
        if Hades2Randomizer.tableContains(Hades2Randomizer.Data.IgnoredSets, biome) then
            goto continue
        end

        for _, enemy in ipairs(enemies) do
            addEnemyToData(enemy)
        end

        ::continue::
    end

    -- Load WeaponOptions
    -- TODO: See if traps can be randomized without breaking everything. Maybe only randomize traps weapons with trap weapons
    for enemyName, data in pairs(EnemyData) do
        if Hades2Randomizer.tableContains(Hades2Randomizer.Data.IgnoredEnemies, enemyName) or Hades2Randomizer.tableContains(Hades2Randomizer.Data.IgnoredSets, enemyName) then
            goto continue
        end

        if data.InheritFrom ~= nil and (Hades2Randomizer.tableContains(data.InheritFrom, "NPC_Neutral")
                or Hades2Randomizer.tableContains(data.InheritFrom, "NPC_Giftable")
                or Hades2Randomizer.tableContains(data.InheritFrom, "BaseTrap")) then
            goto continue
        end

        if string.match(string.lower(enemyName), "base") then
            goto continue
        end

        if data.WeaponOptions ~= nil then
            for _, weaponName in ipairs(data.WeaponOptions) do
                if not isWeaponOptionBlacklisted(weaponName) then
                    table.insert(Hades2Randomizer.Data.WeaponOptions, weaponName)
                end
            end
        end

        if data.AIStages ~= nil then
            for _, stage in ipairs(data.AIStages) do
                if stage.MidPhaseWeapons ~= nil then
                    for _, weaponName in ipairs(stage.MidPhaseWeapons) do
                        if not isWeaponOptionBlacklisted(weaponName) then
                            table.insert(Hades2Randomizer.Data.WeaponOptions, weaponName)
                        end
                    end
                end

                if stage.EquipWeapons ~= nil then
                    for _, weaponName in ipairs(stage.EquipWeapons) do
                        if not isWeaponOptionBlacklisted(weaponName) then
                            table.insert(Hades2Randomizer.Data.WeaponOptions, weaponName)
                        end
                    end
                end
            end
        end

        ::continue::
    end

    -- Load enemies/minions from WeaponData
    for _, data in pairs(WeaponData) do
        if data.AIData ~= nil and data.AIData.SpawnerOptions ~= nil then
            for _, enemy in ipairs(data.AIData.SpawnerOptions) do
                addEnemyToData(enemy)
            end
        end
    end

    -- Load LootTable/Boon data
    for key, data in pairs(LootData) do
        if Hades2Randomizer.tableContains(Hades2Randomizer.Data.IgnoredSets, key) then
            goto continue
        end

        local keySplit = Hades2Randomizer.splitOnCapitalLetters(key)
        local packageName = keySplit[1] .. "Upgrade"

        if data.PriorityUpgrades ~= nil then
            for _, upgrade in ipairs(data.PriorityUpgrades) do
                if not Hades2Randomizer.tableContains(Hades2Randomizer.Data.PriorityUpgrades, upgrade) then
                    table.insert(Hades2Randomizer.Data.PriorityUpgrades, upgrade)
                    Hades2Randomizer.Data.UpgradePackages[upgrade] = packageName
                end
            end
        end

        if data.WeaponUpgrades ~= nil then
            for _, upgrade in ipairs(data.WeaponUpgrades) do
                if not Hades2Randomizer.tableContains(Hades2Randomizer.Data.WeaponUpgrades, upgrade) then
                    table.insert(Hades2Randomizer.Data.WeaponUpgrades, upgrade)
                    Hades2Randomizer.Data.UpgradePackages[upgrade] = packageName
                end
            end
        end

        if data.Traits ~= nil then
            for _, trait in ipairs(data.Traits) do
                if not Hades2Randomizer.tableContains(Hades2Randomizer.Data.Traits, trait) then
                    table.insert(Hades2Randomizer.Data.Traits, trait)
                    Hades2Randomizer.Data.UpgradePackages[trait] = packageName
                end
            end
        end

        if data.Consumables ~= nil then
            for _, consumable in ipairs(data.Consumables) do
                if not Hades2Randomizer.tableContains(Hades2Randomizer.Data.Consumables, consumable) then
                    table.insert(Hades2Randomizer.Data.Consumables, consumable)
                    Hades2Randomizer.Data.UpgradePackages[consumable] = packageName
                end
            end
        end

        if data.OffersElementalTrait ~= nil then
            for _, trait in ipairs(data.OffersElementalTrait) do
                if not Hades2Randomizer.tableContains(Hades2Randomizer.Data.ElementalTraits, trait) then
                    table.insert(Hades2Randomizer.Data.ElementalTraits, trait)
                    Hades2Randomizer.Data.UpgradePackages[trait] = packageName
                end
            end
        end

        ::continue::
    end

    for keepsake, _ in pairs(TraitSetData.Keepsakes) do
        if not string.match(keepsake, "Base") and not Hades2Randomizer.tableContains(Hades2Randomizer.Data.Keepsakes, keepsake) then
            table.insert(Hades2Randomizer.Data.Keepsakes, keepsake)
        end
    end

    for _, weapon in pairs(WeaponSets.HeroPrimaryWeapons) do
        if not Hades2Randomizer.tableContains(Hades2Randomizer.Data.Weapons, weapon) then
            table.insert(Hades2Randomizer.Data.Weapons, weapon)
        end
    end

    for aspectName, data in pairs(TraitSetData.Aspects) do
        local requiredWeapon = data.RequiredWeapon

        if requiredWeapon ~= nil then
            if Hades2Randomizer.Data.Aspects[requiredWeapon] == nil then
                Hades2Randomizer.Data.Aspects[requiredWeapon] = {}
            end

            table.insert(Hades2Randomizer.Data.Aspects[requiredWeapon], aspectName)
        end
    end
end)

function Hades2Randomizer.isElite(enemy)
    return Hades2Randomizer.tableContains(Hades2Randomizer.Data.EliteEnemies, enemy)
end

function Hades2Randomizer.isMiniBoss(enemy)
    return Hades2Randomizer.tableContains(Hades2Randomizer.Data.MiniBosses, enemy)
end

function Hades2Randomizer.isEnemy(enemy)
    return Hades2Randomizer.tableContains(Hades2Randomizer.Data.Enemies, enemy)
end
