function Hades2Randomizer.randomizeWeapon()
    local rng = Hades2Randomizer.Data.Rng
    local randomWeaponIndex = RandomInt(1, #Hades2Randomizer.Data.Weapons, rng)
    local randomWeapon = Hades2Randomizer.Data.Weapons[randomWeaponIndex]
    local aspects = Hades2Randomizer.Data.Aspects[randomWeapon]
    local randomAspectIndex = RandomInt(1, #aspects, rng)
    local randomAspect = aspects[randomAspectIndex]

    DebugPrint({ Text = "Randomizing weapon: " .. randomWeapon })
    DebugPrint({ Text = "Randomizing aspect: " .. randomAspect })

    GameState.LastWeaponUpgradeName[randomWeapon] = randomAspect

    EquipPlayerWeapon(WeaponData[randomWeapon])
    EquipWeaponUpgrade(CurrentRun.Hero)
end
