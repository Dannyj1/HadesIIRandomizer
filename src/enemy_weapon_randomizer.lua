function Hades2Randomizer.randomizeEnemyWeapons()
    local availableWeaponOptions = DeepCopyTable(Hades2Randomizer.Data.WeaponOptions)
    local weaponOptionsMapping = {}

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

        if #availableWeaponOptions <= 0 then
            availableWeaponOptions = DeepCopyTable(Hades2Randomizer.Data.WeaponOptions)
        end
    end

    if Hades2Randomizer.Config.Debug then
        DebugPrint({ Text = "Weapon Options Mapping:" })
        DebugPrintTable(weaponOptionsMapping, true, 0)
    end

    local originalWeaponData = DeepCopyTable(Hades2Randomizer.Data.WeaponData)

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
                local mapping = weaponOptionsMapping[weaponName]

                if mapping ~= nil then
                    if WeaponData[mapping].AIData == nil then
                        WeaponData[mapping].AIData = {}
                    end

                    if originalWeaponData[weaponName].AIData ~= nil then
                        WeaponData[mapping].AIData.PreAttackAnimation = originalWeaponData[weaponName].AIData.PreAttackAnimation
                        WeaponData[mapping].AIData.PostAttackAnimation = originalWeaponData[weaponName].AIData.PostAttackAnimation
                    else
                        WeaponData[mapping].AIData.PreAttackAnimation = nil
                        WeaponData[mapping].AIData.PostAttackAnimation = nil
                    end

                    if data.WeaponOptions[i] ~= mapping then
                        if WeaponData[mapping].Requirements ~= nil then
                            if WeaponData[mapping].Requirements.MinAttacksBetweenUse ~= nil then
                                WeaponData[mapping].Requirements.MinAttacksBetweenUse = nil
                            end

                            if WeaponData[mapping].Requirements.MaxConsecutiveUses ~= nil then
                                WeaponData[mapping].Requirements.MaxConsecutiveUses = nil
                            end

                            if WeaponData[mapping].Requirements.MaxUses ~= nil then
                                WeaponData[mapping].Requirements.MaxUses = nil
                            end

                            if WeaponData[mapping].Requirements.RequireTotalAttacks ~= nil then
                                WeaponData[mapping].Requirements.RequireTotalAttacks = nil
                            end

                            if WeaponData[mapping].Requirements.BlockAsFirstWeapon ~= nil then
                                WeaponData[mapping].Requirements.BlockAsFirstWeapon = nil
                            end
                        end

                        if WeaponData[mapping].AIData.SpawnFromMarker ~= nil then
                            WeaponData[mapping].AIData.SpawnFromMarker = nil
                        end

                        if WeaponData[mapping].AIData.RetreatBufferDistance ~= nil then
                            WeaponData[mapping].AIData.RetreatBufferDistance = nil
                        end

                        if WeaponData[mapping].AIData.RetreatAfterAttack ~= nil then
                            WeaponData[mapping].AIData.RetreatAfterAttack = nil
                        end

                        if WeaponData[mapping].GameStateRequirements ~= nil then
                            WeaponData[mapping].GameStateRequirements = nil
                        end
                    end

                    --WeaponData[mapping].AIData.FireAnimation = originalWeaponData[weaponName].AIData.FireAnimation
                    data.WeaponOptions[i] = mapping
                end
            end
        end

        ::continue::
    end

    -- Print new weapon options like this:
    -- EnemyName = { "weapon1", "weapon2" }
    local printData = {}

    for enemyName, data in pairs(EnemyData) do
        if Hades2Randomizer.tableContains(Hades2Randomizer.Data.IgnoredEnemies, enemyName) or Hades2Randomizer.tableContains(Hades2Randomizer.Data.IgnoredSets, enemyName) then
            goto continue
        end

        if data.WeaponOptions ~= nil then
            printData[enemyName] = data.WeaponOptions
        end

        ::continue::
    end

    if Hades2Randomizer.Config.Debug then
        DebugPrintTable(printData, true, 0)
    end
end

local oOrbitAI = OrbitAI
function OrbitAI(enemy, aiData)
    if aiData.DisableOrbitAI == nil or aiData.OrbitTickDegrees == nil then
        return
    end

    oOrbitAI(enemy, aiData)
end

local oLeap = Leap
function Leap(enemy, aiData, leapType)
    if aiData.LeapSpeed == nil then
        return
    end

    oLeap(enemy, aiData, leapType)
end

local oRetreat = Retreat
function Retreat(enemy, aiData, retreatFromId)
    if aiData.RetreatBufferDistance == nil then
        return
    end

    oRetreat(enemy, aiData, retreatFromId)
end
