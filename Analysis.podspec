#
# Be sure to run `pod lib lint Analysis.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BHAnalysis'
  s.version          = '0.1.3'
  s.summary          = 'APP of Analysis.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.homepage         = 'https://github.com/jeremyzj/Analysis'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jackincitibank@gmail.com' => 'zhangjian@createcloud.com' }
  s.source           = { :git => 'https://github.com/jeremyzj/Analysis.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Analysis/Classes/*.{h,m}'
  s.public_header_files = 'Analysis/Classes/*.h'
  
  s.requires_arc = true
  s.libraries = 'z', 'c++'
  s.xcconfig = { 'GCC_ENABLE_CPP_EXCEPTIONS' => 'YES' }
  
  # s.resource_bundles = {
  #   'Analysis' => ['Analysis/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
