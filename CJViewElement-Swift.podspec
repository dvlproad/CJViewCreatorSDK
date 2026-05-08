Pod::Spec.new do |s|
  #验证方法1：pod lib lint CJViewElement-Swift.podspec --sources='https://github.com/CocoaPods/Specs.git' --allow-warnings --use-libraries --verbose
  #提交方法(github公有库)： pod trunk push CJViewElement-Swift.podspec --allow-warnings --use-libraries --verbose
  
  # pod的本地索引文件：~/Library/Caches/CocoaPods/search_index.json
  # pod的owner操作：https://www.jianshu.com/p/a9b8c2a1f3cf
  s.name         = "CJViewElement-Swift"
  s.version      = "0.0.1"
  s.summary      = "Swift/OC帮助类"
  s.homepage     = "https://github.com/dvlproad/CJUIKit.git"
  s.license      = "MIT"
  s.author       = "dvlproad"

  s.description  = <<-DESC
                   A longer description of CJViewElement-Swift in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "17.0"
  s.swift_version = '5.0'

  s.source       = { :git => "https://github.com/dvlproad/CJViewCreatorSDK.git", :tag => "CJViewElement-Swift_0.1.0" }
  # s.source_files  = "CJBaseUtil/*.{h,m}"
  # s.resources = "CJBaseUtil/**/*.{png}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  # 布局调整的设置视图
  s.subspec 'LayoutInputView' do |ss|
    ss.source_files = "CJViewElement-Swift/LayoutInputView/**/*.{swift}"
  end
  
  # 基础的帮助类
  s.subspec 'Extension' do |ss|
    ss.source_files = "CJViewElement-Swift/Extension/**/*.{swift}"
  end
  
  s.subspec 'Model' do |ss|
    ss.source_files = "CJViewElement-Swift/ElementModel/**/*.{swift}"
    
    ss.dependency "CJViewElement-Swift/Extension" # 需要使用 CJColorExtension.swift
  end
  
  s.subspec 'ComponentConfigModel' do |ss|
    ss.source_files = "CJViewElement-Swift/ComponentConfigModel/**/*.{swift}"

    ss.dependency "CJViewElement-Swift/Model"
#    ss.dependency "CJDataVientianeSDK_Swift"#,   :path => '../../../../CJDataVientianeSDK'
  end
  
#  s.subspec 'View' do |ss|
#    ss.source_files = "CJViewElement-Swift/ElementView/**/*.{swift}"
#  end

  s.subspec 'CommonSettingRow' do |ss|
    ss.source_files = "CJViewElement-Swift/CommonSettingRow/**/*.{swift}"
    
    ss.dependency "CJViewElement-Swift/ComponentConfigModel"
    ss.dependency "CJViewElement-Swift/LayoutInputView"
  end
  
  s.subspec 'SquareResultView' do |ss|
    ss.source_files = "CJViewElement-Swift/SquareResultView/**/*.{swift}"
    
    ss.dependency "CJViewElement-Swift/ComponentConfigModel"
  end

end
