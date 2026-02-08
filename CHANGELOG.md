# Changelog

## [Unreleased]

### Added
- Swift Package Manager support
- SwiftUI wrapper (`ConfettiView`)
- Unit tests
- GitHub Actions CI
- CHANGELOG.md, MIGRATION.md
- **New confetti types:** `.text("🎉")` for emoji, `.sfSymbol("star.fill")` for SF Symbols
- **Presets:** `.perfect`, `.firework`, `.rain` — pre-configured templates via `applyPreset()` (UIKit) or `ConfettiView(preset:isActive:)` (SwiftUI)
- **Particle density:** `density` multiplier property (default 1.0)
- **Sound:** `playSound` property with built-in celebratory sound; `customSoundURL` for custom audio
- **Emission origin:** `emitterOrigin` property for point-based emission (burst/firework)
- **Emission angle:** `emissionAngle` property to control particle direction (radians)
- **Spread control:** `spread` property to control emission cone width
- **Burst mode:** `burstCount` for single-shot particle bursts
- **Haptic feedback:** `hapticFeedback` property triggers impact on start
- **onStop callback:** `onStop` closure called when confetti stops
- **Multi-start safety:** calling `startConfetti()` multiple times no longer duplicates emitters
- **SwiftUI demo app:** 9 interactive demos (perfect, rain, point emission, firework, emoji, SF Symbol, custom colors, repeat burst, depth effect) plus legacy UIKit example
- **Dual-layer depth effect:** `addDepth` property creates background + foreground parallax layers (inspired by ConfettiKit)
- **Smooth fade-out:** `fadeOut` property (default: true) animates opacity on stop instead of abrupt cut
- **Live reload:** `reloadCells()` updates particle configuration without restarting
- **Confetti engine overhaul:** CAKeyframeAnimation burst tapering, initial burst animation (3x→1x), gravity ramp (yAcceleration 0→600 over 6s), beginTime synchronization, higher particle density, natural alpha fade
- **v1 migration shims:** `@available(*, unavailable, renamed:)` on old uppercase enum cases — Xcode Fix-it auto-renames `.Confetti` → `.confetti` etc.

### Changed
- Minimum deployment target: iOS 8.0 → iOS 13.0
- Swift version: 4.2 → 5.0
- Enum cases renamed to lowercase (`.Confetti` → `.confetti`, etc.) — Xcode Fix-it provided
- `isActive()` method replaced with `isActive` read-only property
- Removed all force-unwraps for safer code
- Properties now use default values instead of implicitly unwrapped optionals
- Installation section: SPM-first, CocoaPods still supported
- Example app now uses SwiftUI with NavigationView as the main interface

### Removed
- SAConfettiView references
- Duplicate license text from README

## [0.1.0] - 2019-04-11

### Added
- Initial release
- Confetti, triangle, star, diamond particle types
- Custom image support
- Adjustable colors and intensity
- CocoaPods support
