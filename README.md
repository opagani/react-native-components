Trulia iOS Rentals App
===============================================================

## Installing dependencies

The applications using Core Library now use bundler to manage versions of gems that we need to install pods, run unit tests, and perform builds.

Make sure you have bundler installed: `gem install bundler`

1. cd `/path/to/mob-ios-rental-universal/fastlane`
2. `bundle install --binstubs --path ./vendor/bundle` # This installs the dependent gems (e.g. cocoapods, fastlane) into a local directory in this project so that you don't have to worry about it conflicting with your system gems
3. `bundle exec pod install --project-directory=../` # Run pod install using the version of cocoapods managed by bundler, and show cocoapods where to find the actual Xcodeproj. 

## Generating a build

1. cd `/path/to/mob-rental-universal/fastlane`
2. `bundle install --binstubs --path ./vendor/bundle` # This installs the dependent gems (e.g. cocoapods, fastlane) into a local directory in this project so that you don't have to worry about it conflicting with your system gems
3. `bundle exec fastlane txl core_library_path:'../mob-ioscore-lib/'` # Run the fastlane job and specify the path to core library