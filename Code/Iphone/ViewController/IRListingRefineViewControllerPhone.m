//
//  IRListingRefineViewControllerPhone.m
//  Trulia Rent
//
//  Created by Christopher Echanique on 7/31/15.
//  Copyright (c) 2015 Trulia Inc. All rights reserved.
//

#import "IRListingRefineViewControllerPhone.h"

@implementation IRListingRefineViewControllerPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.refineModeSegmentedControl removeSegmentAtIndex:0 animated:NO];
    [self.refineModeSegmentedControl removeSegmentAtIndex:1 animated:NO];
    
    self.refineModeSegmentedControl.selectedSegmentIndex = 0;
}

- (ICListingRefineMode)currentMode {
    return ICListingRefineModeForRent;
    
}



@end
