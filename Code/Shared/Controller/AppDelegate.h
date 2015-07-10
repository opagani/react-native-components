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
#import "ICListingParameters.h"
#import "ICNavigationController.h"
#import "ICStartupViewControllerPhone.h"
#import "ICOnboardingViewControllerPhone.h"
#import "ICOnboardingViewControllerPad.h"


@class ICMainViewControllerPad, ICMenuContainerViewController;


@interface AppDelegate : AppDelegate_Shared <ICOnboardingDelegate, ICStartupViewControllerDelegate>{
    // only being used by the iPad
}
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) ICOnboardingViewControllerPhone *onboardingControllerPhone;
@property (nonatomic, strong) ICOnboardingViewControllerPad *onboardingControllerPad;

// navController is only being used by the iphone
@property (nonatomic, strong) ICNavigationController *navController;

- (void)showUpgradeAppPopup;
- (void)processUpgradeAppPopup:(NSString *)bundleAPI;


// ipad additions
- (void)saveUserLocations;
- (void)getUserLocations;

void uncaughtExceptionHandler(NSException *exception);

@end
