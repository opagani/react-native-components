#!/usr/bin/env ruby -wKU
source 'https://github.com/CocoaPods/Specs'
source 'ssh://git@stash.sv2.trulia.com/mob/mob-podspecs.git'

raise "The bundle is not installed in this directory. please run `bundle install` and then run this command again" unless ENV['BUNDLE_GEMFILE'] != nil

platform :ios, '9.0'
use_frameworks!
install! 'cocoapods', :deterministic_uuids => false

abstract_target 'TruliaBase' do

    # Uncomment the following lines if you are actively developing a pod and would like to point to your local copy
    # pod 'TUIKit', :path => '../mob-tuikit'

    # If you are NOT actively developing a pod, these lines should be enabled instead
    # pod 'TUIKit', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-tuikit', :branch => 'master'

    # We need to use this forked version of CocoaLumberjack, because WatchKit 1.0 has a problem with CocoaLumberjack not specifying its modulemap
    # See https://github.com/CocoaLumberjack/CocoaLumberjack/issues/815
    pod 'CocoaLumberjack/Swift', :git => 'https://github.com/arifken/CocoaLumberjack.git', :branch => 'master'

    # The extensions use TRLImageCache directly, so it needs to be included here, either by tagged version (second option), or
    # by git url and branch (first option)
    # pod 'TRLImageCache/Base', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-image-cache.git', :branch => 'master'
    pod 'TRLImageCache/Base' 

    target 'Trulia Rent' do
        # Uncomment the following lines if you are actively developing a pod and would like to point to your local copy
        # pod 'TRLActivityFeed', :path => '../../mob-ios-activity-feed'
        # pod 'TRLMaps', :path => '../mob-ios-map-tools'
        # pod 'TRLLocalInfo', :path => '../mob-ios-local-info'
        # pod 'ZGMortgageCalculators', :path => '../mob-ios-mortgage-calculators'
        # pod 'TRLImageCache/Base', :path => '../mob-ios-image-cache'
        # pod 'TRLImageCache/iOS', :path => '../mob-ios-image-cache'
        # pod 'TRLCurrentLocation', :path => '../mob-ios-corelocation'
        # pod 'TRLDisplayFormatters', :path => '../mob-ios-display-formatters'

        # If you are NOT actively developing a pod, these lines should be enabled instead
        # pod 'ARAnalytics', :subspecs => ['DSL', 'Adobe'], :git => 'https://github.com/orta/ARAnalytics.git', :branch => 'master'
        # pod 'ZGMortgageCalculators', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-mortgage-calculators.git', :branch => 'master'
        # pod 'TRLMaps', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-map-tools', :branch => 'master'
        # pod 'TRLLocalInfo', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-local-info.git', :branch => 'master'
        # pod 'TRLActivityFeed', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-activity-feed.git', :branch => 'master'
        # pod 'TRLCurrentLocation', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-corelocation.git', :branch => 'master'
        # pod 'TRLDisplayFormatters', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-display-formatters.git', :branch => 'master'

        pod 'IosCoreLibrary', :path => '../mob-ioscore-lib/'
    end

    target 'MessagesExtension' do
        pod 'TRLMessageExtension'
        # pod 'TRLMessageExtension',:git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-imessage.git', :branch => 'master'
        # pod 'TRLMessageExtension', :path => '../mob-ios-imessage/'
    end

    # Originaly this pod should be inside advanced notification extensions. But when we run
    # pod install and diferent extensions has same pod we have got error
    # [!] The 'Pods-TruliaBase-Trulia' target has frameworks with conflicting names: trladvancednotifications.
    pod 'TRLAdvancedNotifications'
    # pod 'TRLAdvancedNotifications', :git => 'ssh://git@stash.sv2.trulia.com/mob/mob-ios-advanced-notifications.git', :branch => 'master' 
    # pod 'TRLAdvancedNotifications', :path => '../mob-ios-advanced-notifications'
    target 'TRLNotificationListingContentExtension' do
      # do not delete
    end
    target 'TRLNotificationGridContentExtension' do
      # do not delete
    end
    target 'TRLNotificationServiceExtension' do
     # do not delete
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

    if target.name == 'TRLAdvancedNotifications'
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      end
    end

    if target.name == 'TRLMessageExtension'
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      end
    end

    if target.name == 'IosCoreLibrary'
      target.build_configurations.each do |config|
        config.build_settings['OTHER_LDFLAGS'] = ['$(inherited)', '-ObjC']
      end
    end

    target.build_configurations.each do |config|
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf-with-dsym'
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
