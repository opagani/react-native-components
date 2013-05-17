//
//  IRMainViewControllerPad.m
//  IosRentalUniversal
//
//  Created by Akshay Shah on 5/9/13.
//  Copyright (c) 2013 Trulia Inc. All rights reserved.
//

#import "IRMainViewControllerPad.h"
#import "IRFilterViewControllerPad.h"
#import "IRListingSearchToolBarPad.h"

#define TABLE_WIDTH_TOOLBAR 320

@interface IRMainViewControllerPad ()

@end

@implementation IRMainViewControllerPad

- (void)initializeFilterView{

    if(!self.filterViewController)
		self.filterViewController = [[IRFilterViewControllerPad alloc] init];
}

- (ICListingSearchToolBarPad *)searchToolBarPad{
    
    return [[IRListingSearchToolBarPad alloc] initWithFrame:CGRectMake(self.controlBarView.frame.size.width - TABLE_WIDTH_TOOLBAR, 0, TABLE_WIDTH_TOOLBAR, self.controlBarView.bounds.size.height) delegate:self];
}

- (ICHeatmapType)supportedHeatMapTypesForApp{
    
    return (ICHeatmapTypeCrime | ICHeatmapTypeFlood | ICHeatmapTypeSeismic | ICHeatmapTypeRentalPrice);
}

- (NSString *)getIndexTypeForTopBar {
    return @"";
}

@end
