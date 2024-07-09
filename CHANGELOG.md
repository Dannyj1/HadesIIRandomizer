# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.0] - 2024-07-09

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

[unreleased]: https://github.com/Dannyj1/HadesIIRandomizer/compare/1.2.0...HEAD
[1.2.0]: https://github.com/Dannyj1/HadesIIRandomizer/compare/1.1.1...1.2.0
[1.1.1]: https://github.com/Dannyj1/HadesIIRandomizer/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/Dannyj1/HadesIIRandomizer/compare/1.0.2...1.1.0
[1.0.2]: https://github.com/Dannyj1/HadesIIRandomizer/compare/bcbdcf426c9c2ce564460613c12714bc6a9bb6cd...1.0.2
