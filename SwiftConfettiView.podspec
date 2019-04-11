#
# Be sure to run `pod lib lint SwiftConfettiView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftConfettiView'
  s.version          = '0.1.0'
  s.summary          = "Confetti! Who doesn't like confetti?'"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  SAConfettiView is the quickest way to add confetti to your application and make your users feel rewarded.
                       DESC

  s.homepage         = 'https://github.com/ugurethemaydin/SwiftConfettiView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Uğur Ethem AYDIN' => 'ugur@metromedya.com' }
  s.source           = { :git => 'https://github.com/ugurethemaydin/SwiftConfettiView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  
  s.source_files = 'SwiftConfettiView/Classes/**/*'

  s.resource_bundles = {
    'SwiftConfettiView' => ['SwiftConfettiView/Assets/*.png']
  }
 s.resources = 'SwiftConfettiView/**/*.{png,json}'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'QuartzCore'
  # s.dependency 'AFNetworking', '~> 2.3'
end
