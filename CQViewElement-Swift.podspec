Pod::Spec.new do |s|
  #验证方法1：pod lib lint CQViewElement-Swift.podspec --sources='https://github.com/CocoaPods/Specs.git' --allow-warnings --use-libraries --verbose
  #提交方法(github公有库)： pod trunk push CQViewElement-Swift.podspec --allow-warnings --use-libraries --verbose
  
  # pod的本地索引文件：~/Library/Caches/CocoaPods/search_index.json
  # pod的owner操作：https://www.jianshu.com/p/a9b8c2a1f3cf
  s.name         = "CQViewElement-Swift"
  s.version      = "0.0.1"
  s.summary      = "视图绘制库（类似无边记，常用于组件APP里的组件详情页）"
  s.homepage     = "https://github.com/dvlproad/CJViewCreatorSDK.git"
  s.license      = "MIT"
  s.author       = "dvlproad"

  s.description  = <<-DESC
                 视图绘制库（类似无边记，常用于组件APP里的组件详情页），可按需独立引入：
                 • CQViewElement-Swift/LayoutInputView - 布局调整的设置视图
                 • CQViewElement-Swift/Extension - 需要用到的基础的扩展（Color等)
                 • CQViewElement-Swift/Model - 底层视图数据模型
                 • CQViewElement-Swift/ComponentConfigModel - 组件视图配置模型
                 • CQViewElement-Swift/CommonSettingRow - 视图设置图（类似组件APP里的组件详情页的底部设置图）
                 • CQViewElement-Swift/SquareResultView - 预览图（类似组件APP里的组件详情页的顶部预览图）

                 每个子库可独立引入，详见各子库描述。
                 DESC

  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "17.0"
  s.swift_version = '5.0'

  s.source       = { :git => "https://github.com/dvlproad/CJViewCreatorSDK.git", :tag => "CQViewElement-Swift_0.1.0" }
  # s.source_files  = "CJBaseUtil/*.{h,m}"
  s.frameworks = 'UIKit'

  s.requires_arc = true

  
  # 组件视图配置模型
  s.subspec 'ComponentConfigModel' do |ss|
    ss.source_files = "CQViewElement-Swift/ComponentConfigModel/**/*.{swift}"

    ss.dependency "CJViewElement-Swift/ComponentConfigModel"
    ss.dependency "CJDataVientianeSDK-Swift/Date"#,   :path => '../../../../CJDataVientianeSDK'
  end
  
  s.resource_bundles = {
      'CQViewElement-Swift' => [
          'CQViewElement-Swift/Resources/Font/*.ttf',
          'CQViewElement-Swift/Resources/Images/**/*.webp'
      ]
  }

  # 视图设置图（类似组件APP里的组件详情页的底部设置图）
  s.subspec 'SettingRow' do |ss|
    ss.source_files = "CQViewElement-Swift/SettingRow/**/*.{swift}"
    
    ss.dependency "CQViewElement-Swift/ComponentConfigModel"
    ss.dependency "CQDemoKit/BaseUtil"
  end
  
  # 预览图（类似组件APP里的组件详情页的顶部预览图）
  s.subspec 'SquareResultView' do |ss|
    ss.source_files = "CQViewElement-Swift/SquareResultView/**/*.{swift}"
    
    ss.dependency "CQViewElement-Swift/ComponentConfigModel"
    ss.dependency "CJViewGR-Swift"
  end

end
