#
# Be sure to run `pod lib lint CoreTextView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CoreTextView"
  s.version          = "0.1.0"
  s.summary          = "A Vertical UILabel"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
This is a Vertical UILabel, and only for vertically. I have searched around for such a project and nothing I got. So I start this project for someone else sufferring from vertical text. Hope you enjoy.
If you want to contribut to this project,please email "1071932819@qq.com".     
                  DESC

  s.homepage         = "https://github.com/luwei2012/CoreTextView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'GNU'
  s.author           = { "1071932819@qq.com" => "luwei4685" }
  s.source           = { :git => "https://github.com/luwei2012/CoreTextView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/luwei2012'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/*'
  s.resource_bundles = {
    'CoreTextView' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
