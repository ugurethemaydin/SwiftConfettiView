# SwiftConfettiView      [![Tweet](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=Who%20doesn%27t%20like%20confetti!%20🎉%20%20:&url=https://github.com/ugurethemaydin/SwiftConfettiView&hashtags=cocoapods,repo,swiftconfettiview,developers,swift,ios,confetti,github)

SwiftConfettiView — Celebrate every moment in your app

![language](https://img.shields.io/badge/Language-%20Swift%20-orange.svg)
![CI Status](https://img.shields.io/badge/build-passing-brightgreen.svg)
[![Version](https://img.shields.io/cocoapods/v/SwiftConfettiView.svg?style=flat)](https://cocoapods.org/pods/SwiftConfettiView)
[![License](https://img.shields.io/cocoapods/l/SwiftConfettiView.svg?style=flat)](https://cocoapods.org/pods/SwiftConfettiView)
[![Platform](https://img.shields.io/cocoapods/p/SwiftConfettiView.svg?style=flat)](https://cocoapods.org/pods/SwiftConfettiView)


<p align="center">
<img src="https://user-images.githubusercontent.com/3869305/56049372-fc693c00-5d51-11e9-81af-83ecd183b1ec.gif" alt="confetti" width="473.6" height="198">
</p>

It's raining confetti! SwiftConfettiView is the easiest way to add fun, multi-colored confetti to your application and make users feel rewarded. Written in Swift, SwiftConfettiView is a subclass of UIView and is highly customizable. From various types and colors of confetti to different levels of intensity, you can make the confetti as fancy as you want.


To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 13.0+ · Swift 5.0+

## Installation

### Swift Package Manager

Add SwiftConfettiView to your project via Xcode:

1. File → Add Package Dependencies
2. Enter the repository URL:

```
https://github.com/ugurethemaydin/SwiftConfettiView.git
```

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ugurethemaydin/SwiftConfettiView.git", from: "1.0.0")
]
```

### CocoaPods

SwiftConfettiView is also available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```swift
pod 'SwiftConfettiView'
```

And then run:

`$ pod install`

#### Manual Installation
To manually install SwiftConfettiView, simply add `SwiftConfettiView.swift` to your project.

## Usage

### UIKit

Creating a SwiftConfettiView is the same as creating a UIView:

```swift
let confettiView = SwiftConfettiView(frame: self.view.bounds)
```

Don't forget to add the subview!

```swift
self.view.addSubview(confettiView)
```

### SwiftUI

```swift
import SwiftConfettiView

struct ContentView: View {
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            ConfettiView(type: .confetti, isActive: $showConfetti)

            Button("Celebrate!") {
                showConfetti.toggle()
            }
        }
    }
}
```

### Types

Pick one of the preconfigured types of confetti with the `.type` property, or create your own by providing a custom image. This property defaults to the `.confetti` type.

| Type | Code |
|------|------|
| `.confetti` | `confettiView.type = .confetti` |
| `.triangle` | `confettiView.type = .triangle` |
| `.star` | `confettiView.type = .star` |
| `.diamond` | `confettiView.type = .diamond` |
| `.image` | `confettiView.type = .image(UIImage(named: "smiley"))` |
| `.text` | `confettiView.type = .text("🎉")` |
| `.sfSymbol` | `confettiView.type = .sfSymbol("star.fill")` |

### Colors

Set the colors of the confetti with the `.colors` property. This property has a default value of multiple colors.

``` swift
confettiView.colors = [.red, .green, .blue]
```

### Intensity

The intensity refers to how many particles are generated and how quickly they fall. Set the intensity of the confetti with the `.intensity` property by passing in a value between 0 and 1. The default intensity is 0.5.

``` swift
confettiView.intensity = 0.75
```

### Emission Origin

By default, confetti rains from the top edge. Set `emitterOrigin` to emit from a specific point:

```swift
confettiView.emitterOrigin = CGPoint(x: 200, y: 300)
```

### Emission Angle & Spread

Control the direction and cone width of particle emission (in radians):

```swift
confettiView.emissionAngle = 3 * .pi / 2  // upward
confettiView.spread = .pi / 4              // narrow cone
```

For a 360-degree firework effect:

```swift
confettiView.spread = 2 * .pi
```

### Burst Mode

For a one-shot burst instead of continuous rain, set `burstCount`:

```swift
confettiView.burstCount = 100
```

The confetti stops automatically after emitting the specified number of particles.

### Haptic Feedback

Trigger haptic feedback when confetti starts:

```swift
confettiView.hapticFeedback = true
```

### Depth Effect

Enable dual-layer parallax for a 3D depth illusion. A background layer (smaller, slower, dimmer particles) is added behind the main foreground layer:

```swift
confettiView.addDepth = true
```

### Fade Out

By default, stopping confetti fades out smoothly. Disable for an abrupt stop:

```swift
confettiView.fadeOut = false  // default is true
```

### Callback

Get notified when confetti stops:

```swift
confettiView.onStop = {
    print("Confetti finished!")
}
```

### Starting

To start the confetti, use

``` swift
confettiView.startConfetti()
```

### Stopping

To stop the confetti, use

``` swift
confettiView.stopConfetti()
```

### Status

To check if the confetti is active and currently being displayed, use

``` swift
confettiView.isActive
```

Returns `true` if it is being displayed, and `false` if it is not.

### SwiftUI — Advanced Examples

**Point emission (burst from a button):**

```swift
ConfettiView(
    isActive: $isActive,
    emitterOrigin: buttonCenter,
    emissionAngle: 3 * .pi / 2,
    burstCount: 80
)
```

**Firework effect (360-degree burst):**

```swift
ConfettiView(
    type: .star,
    isActive: $isActive,
    emitterOrigin: CGPoint(x: 200, y: 400),
    spread: 2 * .pi,
    burstCount: 100,
    hapticFeedback: true
)
```

**Emoji confetti:**

```swift
ConfettiView(
    type: .text("🎉"),
    isActive: $showConfetti
)
```

**Depth effect (parallax rain):**

```swift
ConfettiView(
    isActive: $showConfetti,
    addDepth: true
)
```

## Apps Using SwiftConfettiView

 * [Direct Message for Whatsapp](http://directmessage.xyz) - chat without adding a contact! <br>
 *Type a number, tap the direct message button, and start a WhatsApp chat without saving the contact. Fast, private, and clean.*

 * [Qwote](https://apps.apple.com/app/id1514390362) - Capture, Format & Share quotes <br>
 *Qwote is a quick way to share text snippets or quotes as beautifully formatted images.*

 * [Soapbox](https://apps.apple.com/app/id1529283270) - Chat with and Make New Friends <br>
 *Good conversations don't need good lighting.*

Want your app listed here? Open a pull request or email us.

## Other Libraries

### CheckDevice
Detect iOS device models and screen sizes at runtime.

[CheckDevice](https://github.com/ugurethemaydin/checkDevice)

## Author

Uğur Ethem AYDIN, ugur@metromedya.com

## License

SwiftConfettiView is available under the MIT license. See the [LICENSE](LICENSE) file for details.
