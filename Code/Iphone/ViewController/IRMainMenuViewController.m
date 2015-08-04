//
//  IRMainMenuViewControllerPhone.m
//  Trulia Rent
//
//  Created by Daud Kabiri on 9/15/14.
//  Copyright (c) 2014 Trulia Inc. All rights reserved.
//

#import "IRMainMenuViewController.h"
#import "IRSRPViewControllerPhone.h"
#import "IRMainViewControllerPad.h"
#import "IC+UIViewController.h"

@implementation IRMainMenuViewController

- (void)setSearchViewControllerForIndexType:(NSString *)idt
{
    ICListingParameters *currentParameters = [[ICListingSearchController sharedInstance] getParametersForIndexType:idt];
    
    if ( [UIDevice isPhone] )
    {
        IRSRPViewControllerPhone *searchViewController = [IRSRPViewControllerPhone sharedInstance];
        [searchViewController searchWithParameters:currentParameters];
        [self closeMenuAndShowViewController:searchViewController];
    }
    else
    {
        [self toggleMenu:NO];
        [[IRMainViewControllerPad sharedInstance] searchWithParameters:currentParameters];
    }
}

@end
