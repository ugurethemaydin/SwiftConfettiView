# Migration Guide

## v0.1 → v2.0

### Requirements

| | v0.1 | v2.0 |
|---|---|---|
| iOS | 9.3+ | 13.0+ |
| Swift | 4 | 5.0+ |
| Install | CocoaPods only | SPM (recommended) + CocoaPods |

### Breaking Changes

#### 1. Enum cases are now lowercase

v0.1 used uppercase enum cases. v2.0 follows Swift naming conventions.

Xcode provides automatic **Fix-it** for all five cases — click "Fix" to rename instantly.

| v0.1 | v2.0 | Xcode Fix-it |
|------|------|:---:|
| `.Confetti` | `.confetti` | Yes |
| `.Triangle` | `.triangle` | Yes |
| `.Star` | `.star` | Yes |
| `.Diamond` | `.diamond` | Yes |
| `.Image(img)` | `.image(img)` | Yes |

```swift
// Before
confettiView.type = .Confetti
confettiView.type = .Image(UIImage(named: "smiley"))

// After
confettiView.type = .confetti
confettiView.type = .image(UIImage(named: "smiley"))
```

#### 2. `isActive()` is now a property

The method was replaced with a read-only property. Remove the parentheses.

```swift
// Before
if confettiView.isActive() { ... }

// After
if confettiView.isActive { ... }
```

No automatic Fix-it for this change — the compiler error ("Cannot call value of non-function type 'Bool'") makes the fix clear.

#### 3. UIColor syntax (Swift language change)

This is a Swift 3+ language change, not a library change. If your project already uses Swift 5, no action needed.

```swift
// Before (Swift 2)
confettiView.colors = [UIColor.redColor(), UIColor.greenColor()]

// After (Swift 5)
confettiView.colors = [.red, .green]
```

### New in v2.0

These are additive — no action required for existing code.

| Feature | API |
|---------|-----|
| SwiftUI support | `ConfettiView(type:isActive:)` |
| Emoji confetti | `.text("🎉")` |
| SF Symbols | `.sfSymbol("star.fill")` |
| Presets | `.applyPreset(.perfect)` / `ConfettiView(preset:isActive:)` |
| Point emission | `emitterOrigin = CGPoint(x:y:)` |
| Emission direction | `emissionAngle`, `spread` |
| Burst mode | `burstCount = 100` |
| Particle density | `density = 2.0` |
| Haptic feedback | `hapticFeedback = true` |
| Sound | `playSound = true`, `customSoundURL` |
| Depth effect | `addDepth = true` |
| Fade-out | `fadeOut = true` (default) |
| Stop callback | `onStop = { ... }` |

### Minimal Migration Example

```swift
// v0.1
let confettiView = SwiftConfettiView(frame: view.bounds)
confettiView.type = .Star           // ← Fix-it: replace with .star
confettiView.colors = [.red, .blue]
confettiView.intensity = 0.75
view.addSubview(confettiView)
confettiView.startConfetti()

if confettiView.isActive() { }      // ← remove parentheses

// v2.0
let confettiView = SwiftConfettiView(frame: view.bounds)
confettiView.type = .star
confettiView.colors = [.red, .blue]
confettiView.intensity = 0.75
view.addSubview(confettiView)
confettiView.startConfetti()

if confettiView.isActive { }
```

Or skip all configuration with a preset:

```swift
// v2.0 — one-liner
let confettiView = SwiftConfettiView(frame: view.bounds)
view.addSubview(confettiView)
confettiView.applyPreset(.perfect)
confettiView.startConfetti()
```
