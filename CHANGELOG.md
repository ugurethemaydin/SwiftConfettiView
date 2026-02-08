# Changelog

## [Unreleased]

### Added
- Swift Package Manager support
- SwiftUI wrapper (`ConfettiView`)
- Unit tests
- GitHub Actions CI
- CHANGELOG.md
- **New confetti types:** `.text("🎉")` for emoji, `.sfSymbol("star.fill")` for SF Symbols
- **Emission origin:** `emitterOrigin` property for point-based emission (burst/firework)
- **Emission angle:** `emissionAngle` property to control particle direction (radians)
- **Spread control:** `spread` property to control emission cone width
- **Burst mode:** `burstCount` for single-shot particle bursts
- **Haptic feedback:** `hapticFeedback` property triggers impact on start
- **onStop callback:** `onStop` closure called when confetti stops
- **Multi-start safety:** calling `startConfetti()` multiple times no longer duplicates emitters
- **SwiftUI demo app:** 8 interactive demos (rain, point emission, firework, emoji, SF Symbol, custom colors, repeat burst, depth effect) plus legacy UIKit example
- **Dual-layer depth effect:** `addDepth` property creates background + foreground parallax layers (inspired by ConfettiKit)
- **Smooth fade-out:** `fadeOut` property (default: true) animates opacity on stop instead of abrupt cut
- **Confetti engine overhaul:** CAKeyframeAnimation burst tapering, initial burst animation (3x→1x), gravity ramp (yAcceleration 0→600 over 6s), beginTime synchronization, higher particle density, natural alpha fade

### Changed
- Minimum deployment target: iOS 8.0 → iOS 13.0
- Swift version: 4.2 → 5.0
- `isActive()` method replaced with `isActive` property
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
