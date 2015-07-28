//
//  IRMainViewControllerPad.m
//  IosRentalUniversal
//
//  Created by Akshay Shah on 5/9/13.
//  Copyright (c) 2013 Trulia Inc. All rights reserved.
//

#import "IRMainViewControllerPad.h"
#import "UIApplication+ICAdditions.h"
#import "IRListingRefineViewControllerPad.h"
#import "ICAnalyticsController.h"

@implementation IRMainViewControllerPad

- (ICHeatmapType)supportedHeatMapTypesForApp{
    
    return (ICHeatmapTypeCrime | ICHeatmapTypeFlood | ICHeatmapTypeSeismic | ICHeatmapTypeRentalPrice);
}

- (NSString *)getIndexTypeForTopBar {
    return @"";
}

- (IBAction)actionShowRefine:(id)sender; {
    [[ICAnalyticsController sharedInstance] trackToolbarClick:[ICAnalyticsController VAR_ACTION_REFINE]];
    IRListingRefineViewControllerPad *viewController = [[IRListingRefineViewControllerPad alloc] initWithSearchController:self.searchController];
    [viewController setDelegate:self];
    self.isFilterViewVisible = YES;
    
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    UIView* filterButton = nil;
    if ([sender isKindOfClass:[UIView class]]){
        filterButton = sender;
    }
    
    if (filterButton){
        CGRect rectToPopoverFrom = [self.view convertRect:filterButton.frame fromView:[filterButton superview]];
        
        if (![self.refinePopOverController isPopoverVisible]){
            self.refinePopOverController = [[UIPopoverController alloc] initWithContentViewController:navController];
            self.refinePopOverController.popoverContentSize = CGSizeMake(320.0f, 630.0f);
            [self.refinePopOverController.contentViewController.view setBackgroundColor:[UIColor whiteColor]];
            viewController.title = @"Search";
            [self.refinePopOverController presentPopoverFromRect:rectToPopoverFrom inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
    }
}

@end
