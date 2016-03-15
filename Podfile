#!/usr/bin/env ruby -wKU

source 'https://github.com/CocoaPods/Specs.git'

target 'Trulia Rent' do
    pod 'ARAnalytics', :git => 'https://github.com/arifken/ARAnalytics.git', :branch => 'andy-fixes'
    pod 'TUIKit', :path => '../mob-tuikit'
    if ENV['IOS_CORE_BRANCH'] != nil # set this to build the app against a specific branch of the library
        pod 'IosCoreLibrary', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ioscore-lib.git', :branch => "#{ENV['IOS_CORE_BRANCH']}"
    else
        pod 'IosCoreLibrary', :path => '../mob-ioscore-lib/'
    end
    
end

#TODO: We can remove this after https://github.com/CocoaPods/Xcodeproj/pull/351 is merged and that version of
# Xcodeproj is integrated into CocoaPods
post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.product_type == 'com.apple.product-type.bundle'
      target.build_configurations.each do |config|
        config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2'
      end
    end
  end

  installer.pods_project.build_configurations.each do |config|
    config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= []
    if config.name == 'Appstore'   
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'APPSTORE=1'
    elsif config.name == 'Debug'
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'DEBUG=1'
    elsif config.name == 'Stage'
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'STAGE=1'
    end
  end
end