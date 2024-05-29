function Hades2Randomizer.randomizeKeepsakes()
    local randomIndex = RandomInt(1, #Hades2Randomizer.Data.Keepsakes)
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