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
