# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/) and the [Home Assistant Add-on Changelog Specification](https://developers.home-assistant.io/docs/add-ons/repository#changelog).

## [1.1.0] - 2025-08-20
### Added
- Unified healthcheck and CI: use nc for port checks, robust and consistent for CUPS/AirSane
- Update README.md

### Changed
- Add GitHub Actions smoke test workflow for container on push to master
- Use SANE hp backend and AirSane for eSCL

### Fixed
- Wrap into community format

## [1.0.0] - 2025-08-17
### Added
- Initial unified release combining CUPS AirPrint and SANE AirScan
- Full sane-airscan support from Debian repositories or built from source
- Comprehensive backend support for major printer and scanner brands
- Unified Avahi service discovery for both printing and scanning
- Zero-configuration setup with sensible defaults
