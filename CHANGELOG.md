# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

* **Breaking:** The gem now wraps [cloudflare-turnstile-rails](https://github.com/vkononov/cloudflare-turnstile-rails) instead of shipping its own client-side integration.
  * The bundled Stimulus controller (`controllers/rpi_turnstile/turnstile_controller.js`), the engine's importmap pin and its Sprockets manifest have been removed, along with the `importmap-rails` and `stimulus-rails` dependencies. Apps that pinned or imported the controller directly should drop those references.
  * The widget container's markup has changed. It no longer carries `data-controller` / `data-rpi-turnstile--turnstile-*` attributes; Turnstile options are now plain `data-*` attributes and the container carries the `cf-turnstile` class alongside `rpi-turnstile`. Tests or CSS that select on the old attributes will need updating.
  * Widget options may now be given with underscores as well as the dashed form used in the Cloudflare docs.
  * Tokens are verified through `cloudflare-turnstile-rails` rather than Faraday, so `faraday` is no longer a dependency.
* **The client's IP is now sent to Cloudflare.** `rpi_turnstile_verified?` includes `request.remote_ip` in the verification request, and Cloudflare checks it against the IP the token was issued to. If your app is behind a proxy or CDN that isn't configured as a trusted proxy, `request.remote_ip` will be the proxy's address and verification will start failing — pass `remoteip: nil` to leave it out.
* **`RpiTurnstile::Api.siteverify` is deprecated** in favour of `RpiTurnstile::Api.verify`, which returns the full `Cloudflare::Turnstile::Rails::VerificationResponse` rather than a boolean. `siteverify` still returns a boolean and will be removed in 0.9.
* `RpiTurnstile::Verifiable` gained `rpi_turnstile_verified` (no `?`), which returns that full response — useful if you need the error codes or hostname. Both it and `rpi_turnstile_verified?` accept keyword arguments, which are passed through to Cloudflare, i.e. `remoteip` and `idempotency_key`.

### Fixed

* A `language` passed to `RpiTurnstile::TurnstileComponent` is no longer overwritten by `I18n.locale`.

### Migrating

`RpiTurnstile::TurnstileComponent`, `rpi_turnstile_verified?`, the `CLOUDFLARE_TURNSTILE_SITEKEY` /
`CLOUDFLARE_TURNSTILE_SECRET` environment variables and `stub_const('RpiTurnstile::Api::SITEKEY', …)`
all behave as before. Three things need attention:

1. **Test stubs of `siteverify`.** Because `rpi_turnstile_verified?` now calls `verify` and reads
   `success?` off the result, a stub returning a bare boolean raises `NoMethodError`:

   | Before | After |
   | --- | --- |
   | `allow(RpiTurnstile::Api).to receive(:siteverify).and_return(true)` | `allow(RpiTurnstile::Api).to receive(:verify).and_return(instance_double(Cloudflare::Turnstile::Rails::VerificationResponse, success?: true))` |

2. **Anything coupled to the old client-side integration** — importmap pins or JavaScript imports of
   the Stimulus controller, and any test or CSS selector matching the widget's previous
   `data-controller` / `data-rpi-turnstile--turnstile-*` attributes.

3. **Proxied apps**, per the `remoteip` note above.

## [0.7.0] - 2026-07-08

### Changed

* Added support for view_component ~> 4.0

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
[0.7.0]: https://github.com/RaspberryPiFoundation/rpi-turnstile/releases/tag/v0.7.0
[0.6.0]: https://github.com/RaspberryPiFoundation/rpi-turnstile/releases/tag/v0.6.0
[0.5.0]: https://github.com/RaspberryPiFoundation/rpi-turnstile/releases/tag/v0.5.0
[0.4.0]: https://github.com/RaspberryPiFoundation/rpi-turnstile/releases/tag/v0.4.0
[0.3.1]: https://github.com/RaspberryPiFoundation/rpi-turnstile/releases/tag/v0.3.1
[0.3.0]: https://github.com/RaspberryPiFoundation/rpi-turnstile/releases/tag/v0.3.0
[0.2.0]: https://github.com/RaspberryPiFoundation/rpi-turnstile/releases/tag/v0.2.0
[0.1.1]: https://github.com/RaspberryPiFoundation/rpi-turnstile/releases/tag/v0.1.0
[0.1.0]: https://github.com/RaspberryPiFoundation/rpi-turnstile/releases/tag/v0.1.0
