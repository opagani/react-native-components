#!/usr/bin/env ruby -wKU
source 'https://github.com/CocoaPods/Specs'
source 'ssh://git@stash.sv2.trulia.com/mob/mob-podspecs.git'

raise "The bundle is not installed in this directory. please run `bundle install` and then run this command again" unless ENV['BUNDLE_GEMFILE'] != nil

platform :ios, '9.0'
use_frameworks!
install! 'cocoapods', :deterministic_uuids => false

target 'Trulia Rent' do
    pod 'ARAnalytics', :subspecs => ['DSL', 'Adobe'], :git => 'https://github.com/orta/ARAnalytics.git', :branch => 'master'
    
    # Uncomment the following line to use a local version of TUIKit
    # pod 'TUIKit', :path => '../mob-tuikit'

    #------------
    # Uncomment the following line if you are actively developing the Mortgage Calculators pod. This will point to
    # the branch on your local machine
    # pod 'ZGMortgageCalculators', :path => '../../mob-ios-mortgage-calculators'
    #------------
    
    # If you are NOT actively developing the Mortgage Calculators pod, this line should be enabled instead
    pod 'ZGMortgageCalculators', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-mortgage-calculators.git', :branch => 'master'

    pod 'IosCoreLibrary', :path => '../mob-ioscore-lib/'
    
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
    config.build_settings['ENABLE_BITCODE'] = 'NO'  
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
