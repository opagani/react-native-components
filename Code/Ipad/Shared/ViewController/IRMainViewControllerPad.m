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
#import "UIApplication+ICAdditions.h"
#import "IRListingSearchViewControllerPhone.h"


#define TABLE_WIDTH_TOOLBAR 320

@interface IRMainViewControllerPad ()

@end

@implementation IRMainViewControllerPad

- (void)initializeFilterView{

    if(!self.filterViewController)
		self.filterViewController = [[IRFilterViewControllerPad alloc] initWithSearchController:self.searchViewController.searchController];
}

/*- (ICListingSearchToolBarPad *)searchToolBarPad{
    
    return [[IRListingSearchToolBarPad alloc] initWithFrame:CGRectMake(self.controlBarView.frame.size.width - TABLE_WIDTH_TOOLBAR, 0, TABLE_WIDTH_TOOLBAR, self.controlBarView.bounds.size.height) delegate:self];
}*/

- (ICHeatmapType)supportedHeatMapTypesForApp{
    
    return (ICHeatmapTypeCrime | ICHeatmapTypeFlood | ICHeatmapTypeSeismic | ICHeatmapTypeRentalPrice);
}

- (NSString *)getIndexTypeForTopBar {
    return @"";
}

-(void)loadMapAndTable{
    
    if (!self.searchViewController) {
        
        self.searchViewController = [IRListingSearchViewControllerPhone sharedInstance];
        self.searchViewController.delegate = self;
        [self.view insertSubview:self.searchViewController.view belowSubview:self.searchBarBackground];
        
        // for the black line between map and table
        self.searchViewController.view.backgroundColor = [UIColor blackColor];
        [super updateChildViewsWithFrameSize:[UIApplication currentSize]];
        
        
#ifdef DEBUG
        UILabel *labelVersion = [[UILabel alloc] init];
        labelVersion.font = [UIFont systemFontOfSize:12.0];
        labelVersion.textColor = [UIColor whiteColor];
        labelVersion.backgroundColor = [UIColor blackColor];
        [labelVersion setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        
        NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
        labelVersion.text = [NSString stringWithFormat:@"build %@-%@", [infoDictionary valueForKey:@"CFBundleShortVersionString"], [infoDictionary valueForKey:@"CFBundleVersion"]];
        CGSize labelSize = [labelVersion.text sizeWithAttributes:@{NSFontAttributeName:labelVersion.font}];
        [labelVersion setFrame:CGRectMake(0, 109.0, labelSize.width, labelSize.height)];
        
        [self.searchViewController.mapViewController.mapView addSubview:labelVersion];
#endif
	}
}

- (void)updateChildViewsWithFrameSize:(CGSize)frameSize{
    
    [super updateChildViewsWithFrameSize:frameSize];
}

@end
