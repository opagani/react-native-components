//
//  IRSRPViewControllerPhone.m
//  Trulia Rent
//
//  Created by Christopher Echanique on 7/31/15.
//  Copyright (c) 2015 Trulia Inc. All rights reserved.
//

#import "IRSRPViewControllerPhone.h"
#import "IRListingRefineViewControllerPhone.h"

@implementation IRSRPViewControllerPhone

- (IBAction)actionShowRefine:(id)sender {
    
    [[ICAnalyticsController sharedInstance] trackToolbarClick:[ICAnalyticsController VAR_ACTION_REFINE]];
    
    IRListingRefineViewControllerPhone *viewController = [[IRListingRefineViewControllerPhone alloc] initWithSearchController:self.searchController];
    [viewController setDelegate:self];
    self.isFilterViewVisible = YES;
    
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
