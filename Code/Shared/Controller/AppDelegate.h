//
//  AppDelegate.h
//  Trulia
//
//  Created by Daniel Lowrie on 1/24/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICAppDelegate.h"
#import "AppDelegate_Shared.h"
#import "ICApplicationConfigurationRequest.h"
#import "ICListingParameters.h"
#import "ICNavigationController.h"
#import "SplashScreenViewController.h"
#import "ICStartupViewControllerPhone.h"

@class ICMainViewControllerPad,ICSwipeNavigationController, ICLeftMenuViewController;


@interface AppDelegate : AppDelegate_Shared <ICApplicationConfigurationRequestDelegate, SplashViewDelegate, ICStartupViewControllerDelegate>{
    // only being used by the iPad

    ICSwipeNavigationController* deckController;
}
@property(nonatomic, strong) ICLeftMenuViewController *viewController;
@property (nonatomic, strong) ICApplicationConfigurationRequest    *applicationConfigRequest;

@property (nonatomic, strong) UIWindow *window;

// navController is only being used by the iphone
@property (nonatomic, strong) ICNavigationController *navController;

@property (nonatomic,assign) BOOL isShowingGalleryView;

- (void)showUpgradeAppPopup;
- (void)processUpgradeAppPopup:(NSString *)bundleAPI;


// ipad additions
- (void)log:(NSString *)msg;
- (void)saveUserLocations;
- (void)getUserLocations;


@end
