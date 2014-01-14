//
//  IRListingRefineViewControllerPhone.m
//  IosRentalUniversal
//
//  Created by John Zorko on 5/13/13.
//  Copyright (c) 2013 Trulia Inc. All rights reserved.
//

#import "IRListingRefineViewControllerPhone.h"
#import "ICAppearance.h"

#define OFFSET              3
#define HEIGHT_ADJUSTMENT   40

@interface IRListingRefineViewControllerPhone ()

@end

@implementation IRListingRefineViewControllerPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil searchController:(ICListingSearchController*)searchController
{
    self = [super initWithNibName:@"ICListingRefineViewControllerPhone" bundle:[NSBundle coreResourcesBundle] searchController:searchController];
    if (self) {
        // Custom initialization
        
        //[self initWithNibName:@"ICListingRefineViewControllerPhone" bundle:[NSBundle coreResourcesBundle] searchController:self.searchController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!theTabView.hidden) {
        theTabView.hidden = YES;
        refineOptionsTableView.frame = CGRectMake(refineOptionsTableView.frame.origin.x, refineOptionsTableView.frame.origin.y - theTabView.frame.size.height + OFFSET, refineOptionsTableView.frame.size.width, refineOptionsTableView.frame.size.height + HEIGHT_ADJUSTMENT);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
