//
//  IRAppDelegate.h
//  Trulia
//
//  Created by Daniel Lowrie on 1/24/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICAppDelegate.h"
#import "ICListingParameters.h"
#import "ICNavigationController.h"
#import "ICOnboardingBaseViewController.h"
#import "ICStartupViewControllerPhone.h"


@class ICMainViewControllerPad, ICMenuContainerViewController;

@interface IRAppDelegate : ICAppDelegate <ICOnboardingDelegate, ICStartupViewControllerDelegate>
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) ICOnboardingBaseViewController *onboardingController;
@property (nonatomic, strong) ICNavigationController *navController;

void uncaughtExceptionHandler(NSException *exception);

@end
