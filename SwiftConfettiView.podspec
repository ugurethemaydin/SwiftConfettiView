Pod::Spec.new do |s|
  s.name             = 'SwiftConfettiView'
  s.version          = '2.0.0'
  s.summary          = 'Celebrate every moment in your app'

  s.description      = <<-DESC
  Add beautiful confetti animations to your iOS app in just a few lines of code. Built on CAEmitterLayer for smooth, high-performance particle rendering. Supports UIKit and SwiftUI with ready-to-use presets, burst and rain modes, haptic feedback, sound effects, and full customization of colors, shapes, and physics.
                       DESC

  s.homepage         = 'https://github.com/ugurethemaydin/SwiftConfettiView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Uğur Ethem AYDIN' => 'ugur@metromedya.com' }
  s.source           = { :git => 'https://github.com/ugurethemaydin/SwiftConfettiView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ugaborek'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'SwiftConfettiView/Classes/**/*'

  s.resource_bundles = {
    'SwiftConfettiView' => ['SwiftConfettiView/Assets/*.png', 'SwiftConfettiView/Assets/*.mp3']
  }

  s.frameworks = 'UIKit', 'QuartzCore', 'AVFoundation'
end
