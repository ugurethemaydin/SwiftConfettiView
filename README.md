# Swift Confetti View      [![Tweet](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=Who%20doesn%27t%20like%20confetti!%20🎉%20%20:&url=https://github.com/ugurethemaydin/SwiftConfettiView&hashtags=cocoapods,repo,swiftconfettiview,developers,swift,ios,confetti,github)

Swift Confetti View ! Who doesn't like confetti?

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

iOS 9.3 or later and Swift 4 

## Installation

SwiftConfettiView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:


```swift
pod 'SwiftConfettiView'
```

And then run:

`$ pod install`

#### Manual Installation
To manually install SwiftConfettiView, simply add `SwiftConfettiView.swift` to your project.

## Usage

Creating a SwiftConfettiView is the same as creating a UIView:

```swift
let confettiView = SwiftConfettiView(frame: self.view.bounds)
```

Don't forget to add the subview!

```swift
self.view.addSubview(confettiView)
```

### Types

Pick one of the preconfigured types of confetti with the `.type` property, or create your own by providing a custom image. This property defaults to the `.Confetti` type.

##### `.Confetti`

![confetti](https://cloud.githubusercontent.com/assets/11940172/11819440/c9db329e-a39a-11e5-9284-b0171bee0f24.gif)

```swift
confettiView.type = .Confetti
```

##### `.Triangle`

![triangle](https://cloud.githubusercontent.com/assets/11940172/11819211/9b8b758a-a399-11e5-8ed3-2eb92f633628.gif)

```swift
confettiView.type = .Triangle
```

##### `.Star`

![star](https://cloud.githubusercontent.com/assets/11940172/11819401/90a2188a-a39a-11e5-8a03-ddca3fb52e72.gif)

```swift
confettiView.type = .Star
```

##### `.Diamond`

![diamond](https://cloud.githubusercontent.com/assets/11940172/11819275/f1c83c08-a399-11e5-8d40-85e9a1879526.gif)

```swift
confettiView.type = .Diamond
```

##### `.Image`

![image](https://cloud.githubusercontent.com/assets/11940172/11819363/5f4f0dba-a39a-11e5-826b-d198113f50dd.gif)

```swift
confettiView.type = .Image(UIImage(named: "smiley"))
```

### Colors

Set the colors of the confetti with the `.colors` property. This property has a default value of multiple colors. 

``` swift
confettiView.colors = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor()]
```

### Intensity

The intensity refers to how many particles are generated and how quickly they fall. Set the intensity of the confetti with the `.intensity` property by passing in a value between 0 and 1. The default intensity is 0.5.

``` swift
confettiView.intensity = 0.75
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
confettiView.isActive()
```

Returns `true` if it is being displayed, and `false` if it is not.




## Who is using the repo?

 * [Direct Message for Whatsapp](http://directmessage.xyz) - chat without adding a contact! <br>
 *Type number, press the direct message button and start whatsapp chat without saving new contact .Keep it fast,secret and clean.*
 
 
 * [Qwote](https://apps.apple.com/app/id1514390362) - Capture, Format & Share quotes <br>
 *Qwote is a quick way to share text snippets or quotes as beautifully formatted images.*
 
 * [Soapbox](https://apps.apple.com/app/id1529283270) - Chat with and Make New Friends <br>
 *Soapbox is a different take Good conversations don’t need good lighting. *
 
 </br>


```if you want your app to be written in this section, please email us. ```

## OTHERs Repo

### CheckDevice
How to detect iOS device models and screen size?

CheckDevice is detected the current  device model and screen sizes.

[CheckDevice](https://github.com/ugurethemaydin/checkDevice)

## Related

This project enhance or use SAConfettiView:
Unfortunately, SAConfettiView has not been updated for a long time and doesn't work in swift4+. So I am created and developing this independent library and I use it in my projects.

## Author

Uğur Ethem AYDIN, ugur@metromedya.com

## License

Swift Confetti View is available under the MIT license. See the LICENSE file for more info.

Copyright (c) 2019 Uğur Ethem AYDIN

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

