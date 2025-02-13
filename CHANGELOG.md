# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)

## [0.3.0] - 2025-02-13

### Added

- Added new Get-IDNWOrg function ([#23](https://github.com/EUCTechTopics/PSIdentityNow/pull/23))

[0.3.0]: https://github.com/EUCTechTopics/PSIdentityNow/releases/tag/v0.3.0

## [0.2.0] - 2025-02-06

### Changed

- Added support for "entitlements" object type ([#21](https://github.com/EUCTechTopics/PSIdentityNow/pull/21))

### Fixed

- Added 'Depth' parameter to ConvertTo-JSON to support JSON data exceeding a depth of 2 ([#22](https://github.com/EUCTechTopics/PSIdentityNow/pull/22))

[0.2.0]: https://github.com/EUCTechTopics/PSIdentityNow/releases/tag/v0.2.0

## [0.1.1] - 2024-12-14

### Changes

- Created separate private Get-IDNWFilterString function

### Fixed

- Fixed Test-IDNWId function to pass both UUID and compressed UUID formats

[0.1.1]: https://github.com/EUCTechTopics/PSIdentityNow/releases/tag/v0.1.1

## 0.1.0 - 2024-12-12

### Added

- Added functionality to use Microsoft.PowerShell.SecretManagement to retrieve IDNW variables.

### Changed

- Updated string variables that contain secrets to be SecureStrings.
- Better error message handling.

## 0.0.1 - 2024-04-12

### Added

- Initial Version