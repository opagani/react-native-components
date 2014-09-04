//
//  IRListingRefineViewControllerPad.m
//  ForRent
//
//  Created by John Zorko on 8/27/14.
//  Copyright (c) 2014 Trulia Inc. All rights reserved.
//

#import "IRListingRefineViewControllerPad.h"
#import "ICListingRefinePriceRangeDataSource.h"
#import "ICListingRefineSquareFootageDatsSource.h"
#import "ICListingRefineLotSizeDataSource.h"
#import "ICListingRefineBathsDataSource.h"
#import "ICListingRefineBedsDataSource.h"
#import "ICListingRefineYearBuiltDataSource.h"
#import "ICListingRefineDaysOnTruliaDataSource.h"
#import "ICListingRefineSoldWithinDataSource.h"

@interface IRListingRefineViewControllerPad ()

@end

@implementation IRListingRefineViewControllerPad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.refineModeSegmentedControl removeSegmentAtIndex:0 animated:NO];
    [self.refineModeSegmentedControl removeSegmentAtIndex:1 animated:NO];
    
    self.refineModeSegmentedControl.selectedSegmentIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
