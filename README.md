# Hades II Randomizer
**Hades II Randomizer** is a randomizer mod for the game [Hades II](https://store.steampowered.com/app/1145350/Hades_II/). It randomizes certain parts of the game everytime you start a new run, requiring you to approach the game in a completely different way compared to the normal game. 

Please keep in mind that this mod is in it's early stages, so there might be issues or crashes. Hades II is also in Early Access, so any update may break the mod or cause issues.

### IMPORTANT: Please *disable* the *Transmit Data* setting in the Hades settings menu! Supergiant Games uses the data for balancing and fine tuning and the randomizer throws all balancing out of the window, making the data useless and noisy for the developers.

## What can be randomized?
- **Enemies**: Enemies, elite enemies and minibosses are randomized. This means that you can encounter an enemy from, for example, the Fields of Mourning in Erebus or even surface enemies in the underworld.
- **Boons**: Boons/Offerings from gods are randomized. This means that, for example, Poseidon can offer upgrades from Aphrodite or Demeter instead of the usual Poseidon boons. Boons are only randomized at the start of the run, so a god will keep offering the same boons for the whole run, until you start a new run.
- **Elemental Traits**: The elemental traits (water, fire, etc.) offered by the gods are randomized. This affects the way you should approach infusion boons.

## Prerequisites
Before installing the mod, make sure you have the following installed:
1. The latest version of [ModImporter](https://www.nexusmods.com/hades2/mods/1): https://www.nexusmods.com/hades2/mods/1
2. The latest version of [ModUtil](https://github.com/SGG-Modding/ModUtil/releases): https://github.com/SGG-Modding/ModUtil/releases

Earlier versions of ModImport and ModUtil might not support Hades II yet, so make sure you are using a recent version!

## Installation
1. Download the latest release from the [releases page](https://github.com/Dannyj1/HadesIIRandomizer/releases)
2. Extract the contents of the zip file.
3. In the `Content` folder of your Hades II installation folder (Usually `C:\Program Files (x86)\Steam\steamapps\common\Hades II\Content`), create a mods folder if it doesn't exist yet.
4. Copy the `HadesIIRandomizer` folder from the extracted zip file to the `mods` folder. You do not need the other files (README, LICENSE), only the `HadesIIRandomizer` folder.
5. Check the config.lua file in the `HadesIIRandomizer` folder to see if you want to change any settings.
6. Run ModImporter.
7. Enjoy!

## Configuration
The mod comes with a `config.lua` file that allows you to change certain settings. The following settings are available:
- `Enabled`: Set to `true` to enable the mod, set to `false` to disable the mod. Default: `true`.
- `RandomizeEnemies`: Randomizes the enemies as described above. Default: `true`.
- `RandomizeBoons`: Randomizes the boons as described above. Default: `true`.
- `RandomizeElementalTraits`: Randomizes the elemental traits as described above. Default: `true`.
- `ScaleStats`: Scales enemy and miniboss stats in the earlier areas, so you do not have to spent ages on a single enemy. Default: `true`.

## Known Issues
- Some enemies are blacked out or have strange textures when spawning in a different area than their normal area. I will try to fix this, but I am not sure if it is possible.
- Some encounters in later areas might be a bit too long and have a lot of enemies.
- Some ability graphics are glitched after being randomized. Not sure how to fix this yet or if it can be fixed at all.

## Roadmap
- See if randomizing enemies spawned by Chronos and Scylla is fun or not.
- Add a "minimum health" scaling for enemies in later areas to up the difficulty.
- Randomize rooms
- Randomize equipped weapon
- Randomize weapon aspect
- Randomize equipped keepsake
- Randomize Arcana cards
- Randomize music
- See what else can be randomized

## I found a bug or my game crashed, what do I do?
Please create an issue ([click here](https://github.com/Dannyj1/HadesIIRandomizer/issues/new/choose)) with the following details:
- A detailed and clear description of what you were doing and what exactly happened.
- Any steps to reproduce the bug/crash, if possible.
- (Optional, but very helpful) A video showing the bug, if possible.
- The `Hades II.log` file located at `C:\Users\<Your Username>\Saved Games\Hades II` (I am unsure of the location on other operating systems)

## License
Copyright 2024 Danny Jelsma

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.