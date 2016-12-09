#!/usr/bin/env ruby -wKU
source 'https://github.com/CocoaPods/Specs'
source 'ssh://git@stash.sv2.trulia.com/mob/mob-podspecs.git'

raise "The bundle is not installed in this directory. please run `bundle install` and then run this command again" unless ENV['BUNDLE_GEMFILE'] != nil

platform :ios, '10.0'
use_frameworks!
install! 'cocoapods', :deterministic_uuids => false

target 'Trulia Rent' do
    # Uncomment the following lines if you are actively developing a pod and would like to point to your local copy
    # pod 'TRLActivityFeed', :path => '../../mob-ios-activity-feed'
    # pod 'TUIKit', :path => '../mob-tuikit'
    # pod 'TRLMaps', :path => '../mob-ios-map-tools'
    # pod 'TRLLocalInfo', :path => '../mob-ios-local-info'
    # pod 'ZGMortgageCalculators', :path => '../mob-ios-mortgage-calculators'
    # pod 'TRLImageCache/Base', :path => '../mob-ios-image-cache'
    # pod 'TRLImageCache/iOS', :path => '../mob-ios-image-cache'
    # pod 'TRLCurrentLocation', :path => '../mob-ios-corelocation'

    # If you are NOT actively developing a pod, these lines should be enabled instead
    pod 'ARAnalytics', :subspecs => ['DSL', 'Adobe'], :git => 'https://github.com/orta/ARAnalytics.git', :branch => 'master'  
    pod 'ZGMortgageCalculators', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-mortgage-calculators.git', :branch => 'master'
    pod 'TUIKit', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-tuikit', :branch => 'master'
    pod 'TRLMaps', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-map-tools', :branch => 'master'
    pod 'TRLLocalInfo', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-local-info.git', :branch => 'master'
    pod 'TRLActivityFeed', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-activity-feed.git', :branch => 'master'
    # pod 'TRLCurrentLocation', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-corelocation.git', :branch => 'master'
    pod 'TRLImageCache/Base', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-image-cache.git', :branch => 'master'
    pod 'TRLImageCache/iOS', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-image-cache.git', :branch => 'master'

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
    if target.name == 'IosCoreLibrary'
      target.build_configurations.each do |config|
        config.build_settings['OTHER_LDFLAGS'] = ['$(inherited)', '-ObjC']
      end
    end
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf-with-dsym'
      config.build_settings['ENABLE_BITCODE'] = 'YES'
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

    #
    # This next bit of configuration is necessary to allow IBDesignables to render correctly inside
    # Interface Builder. It however cannot be included in Stage/AppStore builds because it causes
    # the app on one device (QA's iPad Air 2, running iOS 9.3.x) to crash on startup.
    #
    if config.name == 'Debug'
      config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = [
        '$(FRAMEWORK_SEARCH_PATHS)'
      ]
    end  
  end
end
