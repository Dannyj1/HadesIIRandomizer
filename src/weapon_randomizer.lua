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

function Hades2Randomizer.randomizeWeapon()
    local rng = Hades2Randomizer.Data.Rng
    local randomWeaponIndex = RandomInt(1, #Hades2Randomizer.Data.Weapons, rng)
    local randomWeapon = Hades2Randomizer.Data.Weapons[randomWeaponIndex]
    local aspects = Hades2Randomizer.Data.Aspects[randomWeapon]
    local randomAspectIndex = RandomInt(1, #aspects, rng)
    local randomAspect = aspects[randomAspectIndex]

    if Hades2Randomizer.Config.Debug then
        DebugPrint({ Text = "Randomizing weapon: " .. randomWeapon })
        DebugPrint({ Text = "Randomizing aspect: " .. randomAspect })
    end

    GameState.LastWeaponUpgradeName[randomWeapon] = randomAspect

    EquipPlayerWeapon(WeaponData[randomWeapon])
    EquipWeaponUpgrade(CurrentRun.Hero)
end
