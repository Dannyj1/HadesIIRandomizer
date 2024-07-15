# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.4.0] - 2024-07-15

### Added

- Added late game health scaling. Enemies from earlier biomes in the later biomes will now have more health and armor.
- Added late game difficulty scaling. There will now be less enemies in the later biomes if they are from earlier biomes. This should fix the very long rooms with many spawns, especially in Tartarus.

### Changed

- Enemies spawned by Vow of Wandering are now properly randomized, instead of using the vanilla mapping they use the randomized mapping.
- When RandomizeKeepsakes is enabled, your equipped keepsake will now be randomized after every boss fight. The keepsake display case in biome transition rooms will be locked.

### Fixed

- Killing a MiniBoss should now kill all summons/minions like it does in unmodded Hades 2. 
- Fixed some elite enemies potentially being classified as a non-elite enemy, causing normal enemies to sometimes be replaced by elites.

## [1.3.0] - 2024-07-14

### Changed

- Minions spawned by bosses, minibosses and certain enemies are now randomized. This mainly affects the Scylla, Cerberus and Chronos fights. As a result of this, a few more enemies are added to the enemy randomization pool.

### Fixed

- Fixed a crash when you had a rarify keepsake equipped and then hovered over a randomized hammer upgrade.

## [1.2.0] - 2024-07-09

### Added

- Added randomization of equipped Arcana Cards. Disabled by default, so this must be enabled in the config.

## [1.1.1] - 2024-06-03

### Changed

- Updated ModUtil dependency required version to 4.0.0

### Fixed

- Fixed "base" keepsakes being randomized, causing the game to crash

## [1.1.0] - 2024-05-29

### Added

- Added keepsake randomization at the start of a new run (disabled by default, can be enabled in the config file).
- Added weapon and aspect randomization at the start of a new run (disabled by default, can be enabled in the config file).

### Changed

- Renamed `RandomizeBoons` to `RandomizeBoonOfferings` in the config for clarity.
- DemonDaemon dependency version requirement updated to 1.1.0, coming with a new config system.

## [1.0.2] - 2024-05-18

### Fixed

- Fixed some enemies being blacked out or having missing textures after being randomized outside of their usual area (mainly happened to surface enemies).
- Fixed an issue where some ability graphics were glitched after being randomized.
- No longer randomize the CrawlerMiniboss (uh-oh) as it does not work outside of it's normal room.

[unreleased]: https://github.com/Dannyj1/HadesIIRandomizer/compare/1.4.0...HEAD
[1.4.0]: https://github.com/Dannyj1/HadesIIRandomizer/compare/1.3.0...1.4.0
[1.3.0]: https://github.com/Dannyj1/HadesIIRandomizer/compare/1.2.0...1.3.0
[1.2.0]: https://github.com/Dannyj1/HadesIIRandomizer/compare/1.1.1...1.2.0
[1.1.1]: https://github.com/Dannyj1/HadesIIRandomizer/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/Dannyj1/HadesIIRandomizer/compare/1.0.2...1.1.0
[1.0.2]: https://github.com/Dannyj1/HadesIIRandomizer/compare/bcbdcf426c9c2ce564460613c12714bc6a9bb6cd...1.0.2
