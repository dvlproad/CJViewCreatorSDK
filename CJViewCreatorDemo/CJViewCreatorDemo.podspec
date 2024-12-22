Pod::Spec.new do |s|
  # 旧方法（本库不依赖swift库的时候）
	#验证方法1：pod lib lint CQOverlayKit.podspec --sources='https://github.com/CocoaPods/Specs.git,https://gitee.com/dvlproad/dvlproadSpecs' --allow-warnings --use-libraries --verbose
  #验证方法2：pod lib lint CQOverlayKit.podspec --sources=master,dvlproad --allow-warnings --use-libraries --verbose
  #提交方法： pod repo push dvlproad CQOverlayKit.podspec --sources=master,dvlproad --allow-warnings --use-libraries --verbose

  # 新方法（本类要依赖swift库的时候）将--use-libraries去掉，或者改成--use-modular-headers
  # 验证方法2：pod lib lint CQOverlayKit.podspec --sources=master,dvlproad --allow-warnings --use-modular-headers --verbose
  # pod repo push dvlproad CQOverlayKit.podspec --sources=master,dvlproad --allow-warnings --use-modular-headers --verbose

  s.name         = "CQOverlayKit"
  s.version      = "0.7.2"
  s.summary      = "基础必备的浮层弹窗(Toast、Alert、ActionSheet、HUD)"
  s.homepage     = "https://gitee.com/dvlproad/UIKit-Overlay-iOS.git"

  #s.license      = "MIT"
  s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
              © 2008-2020 dvlproad. All rights reserved.
    LICENSE
  }

  s.author   = { "dvlproad" => "" }
  

  s.description  = <<-DESC
 				          -、Toast:
                  -、Alert:
                  -、ActionSheet:
                  -、HUD:

                   A longer description of CQOverlayKit in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC
  

  s.platform     = :ios, "9.0"
  s.swift_version = '5.0'
 
  s.source       = { :git => "https://gitee.com/dvlproad/UIKit-Overlay-iOS.git", :tag => "CQOverlayKit_0.7.2" }
  #s.source_files  = "CJDemoCommon/*.{h,m}"
  #s.source_files = "CJChat/TestOSChinaPod.{h,m}"

  s.frameworks = "UIKit"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  # Theme 主题的各种设置
  s.subspec 'ThemeSetting' do |ss|
    ss.source_files = "CQOverlayKit/ThemeSetting/**/*.{h,m}"

    #多个依赖就写多行
    ss.dependency "CQOverlayKit/Theme"
    ss.dependency "CJOverlayView/CJActionSheet"	# CQOverlayThemeSetting 中设置 sheet的dangerCellConfigBlock时候需要使用 CJActionSheetTableViewCell
  end

  # Theme 主题
  s.subspec 'Theme' do |ss|
    ss.source_files = "CQOverlayKit/Theme/**/*.{h,m}"

    #多个依赖就写多行
    ss.dependency "CJOverlayView/CJBaseOverlayTheme"
  end

  # Base
  s.subspec 'Base' do |ss|
    ss.source_files = "CQOverlayKit/Base/**/*.{h,m}"
    #多个依赖就写多行
    ss.dependency "CQOverlayKit/Theme"
    ss.dependency "CQPopupCreater_Base/BaseCenter"  # 弹窗BlankView及其弹出
    ss.dependency "CQPopupCreater_Base/BaseBottom"  # 弹窗BlankView及其弹出
    ss.dependency "CJPopupCreater"
  end


  # Toast
  s.subspec 'CQToast' do |ss|
    ss.source_files = "CQOverlayKit/CQToast/**/*.{h,m}"
    ss.resources = "CQOverlayKit/CQToast/**/*.{png,xib}"
    #多个依赖就写多行
    ss.dependency "CJOverlayView/CJToast"
    ss.dependency "CQOverlayKit/Theme"
    ss.dependency "CJPopupAnimation/Toast"
  end
  
  # Alert
  s.subspec 'CQAlert' do |ss|
    ss.source_files = "CQOverlayKit/CQAlert/**/*.{h,m}"
    ss.resource_bundle = {
      'CQAlert' => ['CQOverlayKit/CQAlert/**/*.{xcassets,json}', 'CQOverlayKit/CQAlert/**/*.{png,jpg}'] # CQAlert 为生成boudle的名称，可以随便起，但要记住，库里要用
    }
    #多个依赖就写多行
    ss.dependency 'CJOverlayView/AlertView_Normal'
    ss.dependency 'CJBaseHelper/AuthorizationCJHelper'
    ss.dependency 'CQOverlayKit/Base'
    ss.dependency "CQOverlayKit/Theme"
    
    
    ss.dependency 'CJOverlayView/AlertView_Horizontal'
    ss.dependency 'CJOverlayView/AlertView_Image'
    
#    ss.dependency "CQPopupCreater_Base/BaseCenter"  # 弹窗BlankView及其弹出
  end

  # ActionSheet
  s.subspec 'CQActionSheet' do |ss|
    ss.source_files = "CQOverlayKit/CQActionSheet/**/*.{h,m}"
    ss.resource_bundle = {
      'CQActionSheet' => ['CQOverlayKit/CQActionSheet/**/*.{xcassets,json}', 'CQOverlayKit/CQActionSheet/**/*.{png,jpg}'] # CQActionSheet 为生成boudle的名称，可以随便起，但要记住，库里要用
    }
    #多个依赖就写多行
    ss.dependency 'CJOverlayView/CJActionSheet'
    ss.dependency 'CQOverlayKit/Base'
    ss.dependency "CQOverlayKit/Theme"
#    ss.dependency "CQPopupCreater_Base/BaseBottom"  # 弹窗BlankView及其弹出
  end

  # HUD
  s.subspec 'CQHUD' do |ss|
    ss.source_files = "CQOverlayKit/CQHUD/**/*.{h,m}"
    ss.resource_bundle = {
    	'CQHUD' => ['CQOverlayKit/CQHUD/**/*.{xcassets,json}', 'CQOverlayKit/CQHUD/**/*.{png,jpg}'] # CQHUD 为生成boudle的名称，可以随便起，但要记住，库里要用
  	}
    #多个依赖就写多行
    ss.dependency 'CJOverlayView/CJProgressHUD'
    ss.dependency "CJOverlayView/CJToast"
    ss.dependency "CQOverlayKit/Theme"
    ss.dependency "SVProgressHUD"
    ss.dependency "CJPopupAnimation/Toast"
  end

  
end
