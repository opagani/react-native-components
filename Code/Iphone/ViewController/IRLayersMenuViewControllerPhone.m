//
//  IRLayersMenuViewControllerPhone.m
//  IosRentalUniversal
//
//  Created by Jack Kwok on 5/14/13.
//  Copyright (c) 2013 Trulia Inc. All rights reserved.
//

#import "IRLayersMenuViewControllerPhone.h"

@interface IRLayersMenuViewControllerPhone ()

@end

@implementation IRLayersMenuViewControllerPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSearchController:(ICListingSearchController*)searchController
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil withSearchController:searchController];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) isHeatmapSupported : (HEATMAP_TYPE) type {
    switch (type) {
        case HEATMAP_CRIME:
            return YES;
        case HEATMAP_FLOOD:
            return YES;
        case HEATMAP_SEISMIC:
            return YES;
        case HEATMAP_RENTAL_PRICES:
            return YES;
        default:
            return NO;
    }
}

@end
