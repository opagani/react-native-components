//
//  IRFilterViewControllerPad.m
//  IosRentalUniversal
//
//  Created by Akshay Shah on 5/9/13.
//  Copyright (c) 2013 Trulia Inc. All rights reserved.
//

#if 0

#import "IRFilterViewControllerPad.h"
#import "ICListingSearchController.h"
#import "ICManagedSearch.h"

@interface IRFilterViewControllerPad ()

@end

@implementation IRFilterViewControllerPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (id)initWithSearchController:(ICListingSearchController*)searchController{
    
    return [super initWithSearchController:searchController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)valueForRentTab{
    return 0;
}

- (void)showTabForIndex:(NSUInteger)tabIndex{
    
    switch (tabIndex) {
            
		case 0:
			[self showTabForRent];
			break;
    
        case 1:
            [self showTabForMySearches];
            break;
            
		default:
			break;
	}
}

-(NSUInteger)numberOfTabsInSlidingTabView:(ICSlidingTabView *)slidingTabView {
	return 2;
}

-(ICSlidingTabViewCell *)slidingTabView:(ICSlidingTabView *)slidingTabView cellForTabAtIndex:(NSUInteger)tabIndex {
	
	ICSlidingTabViewCell *cell = [[ICSlidingTabViewCell alloc] init];
	
	switch (tabIndex) {

		case 0:
			cell.title = @"For Rent";
			break;
            
        case 1:
            cell.title = @"My Searches";
            //int searchCount = [[ICManagedSearch managedObjectsWithCategoryName:MANAGED_CATEGORY_FAVORITES] count];
            int searchCount = 0;
            cell.counter = [NSString stringWithFormat:@"%d", searchCount];
            break;
            
		default:
			break;
	}
	
	return cell;
}

- (void)setTabValueForIndexType:(NSString *)indexType{
	

    if ([indexType isEqualToString:@"for rent"]) {
        
        [self.slidingTabView.tabViewSlider setValue:0.0 animated:YES];
        [self.slidingTabView actionSliderChanged:self.slidingTabView.tabViewSlider];
        
    }
}

- (void)resetSearch{
    
    switch ((int)self.slidingTabView.tabViewSlider.value) {
		case 0:
			currentParameters.indexType = [NSMutableArray arrayWithObject:@"for rent"];
			break;
		default:
			break;
	}
}

@end

#endif

