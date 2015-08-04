//
//  IRListingRefineViewControllerPad.m
//  ForRent
//
//  Created by John Zorko on 8/27/14.
//  Copyright (c) 2014 Trulia Inc. All rights reserved.
//

#import "IRListingRefineViewControllerPad.h"

@implementation IRListingRefineViewControllerPad

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
