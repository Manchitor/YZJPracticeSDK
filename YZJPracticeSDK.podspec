#
# Be sure to run `pod lib lint YZJPracticeSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YZJPracticeSDK'
  s.version          = '0.1.1'
  s.summary          = 'A short description of YZJPracticeSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Manchitor/YZJPracticeSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Manchitor' => '18721218206@163.com' }
  s.source           = { :git => 'https://github.com/Manchitor/YZJPracticeSDK.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '11.0'

  s.source_files = 'YZJPracticeSDK/Classes/**/*'
  
  s.vendored_frameworks = 'YZJPracticeSDK/Classes/SBAIFramework/SBSDK.framework'
  
  s.resource_bundles = {'YZJPractice' => ['YZJPracticeSDK/Assets/*']}
  
  s.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => ' ' }
    
  s.xcconfig = { "OTHER_LDFLAGS" => "-ObjC" }
  
  s.static_framework = true
  
  s.public_header_files = 'YZJPracticeSDK/Classes/**/*.h'

# s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking'
  s.dependency 'Masonry'
  s.dependency 'MJRefresh'
  s.dependency 'MJExtension'
  s.dependency 'MBProgressHUD'
  s.dependency 'SDWebImage'
end
