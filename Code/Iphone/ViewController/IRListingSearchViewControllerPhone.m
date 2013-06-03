//
//  IRListingSearchViewControllerPhone.m
//  IosRentalUniversal
//
//  Created by John Zorko on 5/10/13.
//  Copyright (c) 2013 Trulia Inc. All rights reserved.
//

#import "IRListingSearchViewControllerPhone.h"
#import "IRLayersMenuViewControllerPhone.h"

@interface IRListingSearchViewControllerPhone ()

@end

@implementation IRListingSearchViewControllerPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)actionShowRefine:(id)sender {
    [[ICMetricsController sharedInstance] trackToolbarClick:[ICMetricsController VAR_ACTION_REFINE]];
    
    IRListingRefineViewControllerPhone *viewController = [[IRListingRefineViewControllerPhone alloc] initWithNibName:@"ICListingRefineViewControllerPhone" bundle:[NSBundle coreResourcesBundle]];
    viewController.delegate = self;
    self.isFilterViewVisible = YES;
    
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentModalViewController:viewController animated:YES];
}

- (void) initLayersMenuTable {
    self.layersMenuTable = [[IRLayersMenuViewControllerPhone alloc] initWithNibName:@"ICLayersMenuViewControllerPhone" bundle:[NSBundle coreResourcesBundle]];
}

- (void)showLayersAndNearbyButton {
    self.btnLayers.hidden = NO;
    self.btnNearby.hidden = NO;
}

- (void)hideLayersAndNearbyButton {
    self.btnLayers.hidden = YES;
    self.btnNearby.hidden = YES;
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

@end
