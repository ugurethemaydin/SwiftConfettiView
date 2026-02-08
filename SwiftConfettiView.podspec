Pod::Spec.new do |s|
  s.name             = 'SwiftConfettiView'
  s.version          = '2.0.0'
  s.summary          = 'Celebrate every moment in your app'

  s.description      = <<-DESC
  SwiftConfettiView is the quickest way to add confetti to your application and make your users feel rewarded.
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
