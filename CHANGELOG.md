# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.6.0] - 2026-06-12

### Changed

* Added support for Rails ~> 8.1

## [0.5.0] - 2026-05-13

### Fixed
* Fix double rendering of the Turnstile widget when used with Turbo (#28)
* Allow more than one Turnstile widget to be rendered on the same page (#30)

## [0.4.0] - 2024-06-10

### Changed
* Support for Ruby 2.7, 3.0, and 3.1 has been dropped. The minimum supported Ruby version is now 3.2. (#15)

### Fixed
* Update GitHub Actions workflows to use latest upload/download artifact actions (#15)
* Removed unnecessary `require` statements which break Rails 7.1+ (#14)

## [0.3.1] - 2023-11-13

### Added

* Add importmap-rails as a gem dependency (#12)

## [0.3.0] - 2023-07-18

### Added

* Allow the component to be more customisable (#6, #8)
* Add documentation around testing (#7)

## [0.2.0] - 2023-07-17

### Changed

* Relax Ruby requirements down to version 2.7 (#4)

## [0.1.1] - 2023-07-10

### Fixed

* Updated CI to build gem on tag (#3)

## [0.1.0] - 2023-07-10

* Initial release

[unreleased]: https://github.com/RaspberryPiFoundation/rpi-turnstile/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/RaspberryPiFoundation/rpi-turnstile/releases/tag/v0.5.0
[0.4.0]: https://github.com/RaspberryPiFoundation/rpi-turnstile/releases/tag/v0.4.0
[0.3.1]: https://github.com/RaspberryPiFoundation/rpi-turnstile/releases/tag/v0.3.1
[0.3.0]: https://github.com/RaspberryPiFoundation/rpi-turnstile/releases/tag/v0.3.0
[0.2.0]: https://github.com/RaspberryPiFoundation/rpi-turnstile/releases/tag/v0.2.0
[0.1.1]: https://github.com/RaspberryPiFoundation/rpi-turnstile/releases/tag/v0.1.0
[0.1.0]: https://github.com/RaspberryPiFoundation/rpi-turnstile/releases/tag/v0.1.0
