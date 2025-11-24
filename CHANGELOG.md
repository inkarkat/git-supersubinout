# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning\](https://semver.org/spec/v2.0.0.html)].

## v3.0.1 - 24-Nov-2025
### Changed
- Bump actions/checkout from 4 to 6
- Bump frozen dependencies
- Move from consecutive to semantic versioning for these dependency bumps, to allow for smooth client updates.

## v3 - 16-May-2024
### Removed
- `fail-on-differences` flag; rely on `differences-found` flag instead, if necessary with a separate step that fails the build

## v2 - 15-May-2024
### Fixed
- message is not captured in `[markdown-]logs`

## v1 - 15-May-2024
- First implementation
