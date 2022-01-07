#
# Be sure to run `pod lib lint YWKeyboardKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'YWKeyboardKit'
    s.version          = '0.1.9'
    s.summary          = '自定义键盘'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = '车牌输入的键盘(省份编号、字母、数字)，自定义身份证键盘，自定义有效数字键盘，自定义纯数字键盘'
    
    s.homepage         = 'https://github.com/flyOfYW/YWKeyboardKit'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'yw' => '1498627884@qq.com' }
    s.source           = { :git => 'https://github.com/flyOfYW/YWKeyboardKit.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '9.0'
    
    # s.source_files = 'YWKeyboardKit/Classes/**/*'
    
    #s.resource_bundles = {
    #   'YWKeyboardKit' => ['YWKeyboardKit/Assets/*.png']
    # }
    
    s.resource_bundles = {
      'YWKeyboardKit' => ['YWKeyboardKit/Assets/*.xcassets']
     }
    
    s.subspec 'TurtleBezierPath' do |ns|
        ns.source_files = 'YWKeyboardKit/Classes/TurtleBezierPath/*.{h,m}'
    end
    
    s.subspec 'KeyboardButton' do |ns|
        ns.source_files = 'YWKeyboardKit/Classes/KeyboardButton/*.{h,m}'
        ns.dependency 'YWKeyboardKit/TurtleBezierPath'
    end
    
    s.subspec 'LicensePlate' do |ns|
        ns.source_files = 'YWKeyboardKit/Classes/LicensePlate/*.{h,m}'
        ns.dependency 'YWKeyboardKit/KeyboardButton'
        ns.resource_bundles = {
            'YWKeyboardKit' => ['YWKeyboardKit/Assets/*.xcassets']
        }
    end
    
    s.subspec 'InputToolbar' do |ns|
        ns.source_files = 'YWKeyboardKit/Classes/InputToolbar/*.{h,m}'
    end
    
    s.subspec 'IdCard' do |ns|
        ns.source_files = 'YWKeyboardKit/Classes/IdCard/*.{h,m}'
        ns.dependency 'YWKeyboardKit/KeyboardButton'
        ns.resource_bundles = {
            'YWKeyboardKit' => ['YWKeyboardKit/Assets/*.xcassets']
        }
    end
    
    s.subspec 'NumPad' do |ns|
        ns.source_files = 'YWKeyboardKit/Classes/NumPad/*.{h,m}'
        ns.dependency 'YWKeyboardKit/KeyboardButton'
        ns.resource_bundles = {
            'YWKeyboardKit' => ['YWKeyboardKit/Assets/*.xcassets']
        }
    end
    
    s.subspec 'NumSpecChara' do |nc|
        nc.source_files = 'YWKeyboardKit/Classes/NumSpecChara/*'
        nc.dependency 'YWKeyboardKit/KeyboardButton'
        nc.resource_bundles = {
            'YWKeyboardKit' => ['YWKeyboardKit/Assets/*.xcassets']
        }
    end
    
    
    
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking', '~> 2.3'
end
