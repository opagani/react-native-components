//
//  IRListingSearchViewControllerPhone.m
//  IosRentalUniversal
//
//  Created by John Zorko on 5/10/13.
//  Copyright (c) 2013 Trulia Inc. All rights reserved.
//

#import "IRListingSearchViewControllerPhone.h"
#import "IRLayersMenuViewControllerPhone.h"
#import "ICLeftMenuViewController.h"
#import "ICMainMenuViewControllerPhone.h"
#import "IRListingDetailViewControllerPad.h"
#import "UIApplication+ICAdditions.h"
#import "IRMainViewControllerPad.h"

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
    
    IRListingRefineViewControllerPhone *viewController = [[IRListingRefineViewControllerPhone alloc] initWithSearchController:self.searchController];
    viewController.delegate = self;
    self.isFilterViewVisible = YES;
    
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navController animated:YES completion:nil];

}

- (void) initLayersMenuTable {
   // self.layersMenuTable = [[IRLayersMenuViewControllerPhone alloc] initWithNibName:@"ICLayersMenuViewControllerPhone" bundle:[NSBundle coreResourcesBundle] withSearchController:self.searchController];
}

- (void)showLayersAndNearbyButton {
    self.btnLayers.hidden = NO;
    self.btnNearby.hidden = NO;
}

- (void)hideLayersAndNearbyButton {
    self.btnLayers.hidden = YES;
    self.btnNearby.hidden = YES;
}


/*-(void)pushdDetailViewForListing:(ICListing*)currentListing {
    
    if ([UIDevice isPad])
    {
        
        if (self.listingDetailViewController)
        {
            [self.listingDetailViewController.view removeFromSuperview];
            
            self.listingDetailViewController = nil;
        }
        
        self.listingDetailViewController = [IRListingDetailViewControllerPad new];
        
        [((IRListingDetailViewControllerPad *) self.listingDetailViewController) setDelegate:self];
        
        [((IRListingDetailViewControllerPad *) self.listingDetailViewController) setListing:currentListing];
        
        UIView * parent = [IRMainViewControllerPad sharedInstance].view;
        CGFloat statusBarOffset = [UIDevice isOS7OrAbove] ? [UIApplication sharedApplication].statusBarHeight : 0;
        
        self.listingDetailViewController.view.frame = CGRectMake(0, statusBarOffset, parent.bounds.size.width, parent.bounds.size.height - statusBarOffset);
        
        [[ICMainViewControllerPad sharedInstance].view addSubview:self.listingDetailViewController.view];
        
        [((ICListingDetailViewControllerPad *) self.listingDetailViewController) animateSlideInOutAnimation:kCATransitionFromRight];
        
    }
    else
    {
        self.listingDetailViewController = [[ICListingDetailViewControllerPhone alloc] initWithNibName:@"ICListingDetailViewControllerPhone" bundle:[NSBundle coreResourcesBundle]];
        [((ICListingDetailViewControllerPhone *) self.listingDetailViewController) setDelegate:self];
        
        //we don't need to refresh since this will be the first time the view controller is appearing
        [(ICListingDetailViewControllerPhone *) self.listingDetailViewController setWithListing:currentListing andRefresh:NO];
        
        [self.navigationController pushViewController:self.listingDetailViewController animated:YES];
        
        
    }
}*/


/*-(AnimationBlock)animationBlockForSave{
    AnimationBlock block = ^(UIView* view){
        
        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        if ([vc isKindOfClass:[ICLeftMenuViewController class]])
        {
            ICMainMenuViewControllerPhone *menu = (ICMainMenuViewControllerPhone *) ((ICLeftMenuViewController *) vc).left;
            
            [self hideCurrentMessage:YES];
            
            [menu animateStarToMenuFromView:view forMenuItem:0 completionBlock:^
             {
                 [((ICLeftMenuViewController *) vc) toggleMenu:NO];
             }];
            [((ICLeftMenuViewController *) vc) toggleMenu:YES];
        }
        else
            GRLog(@"ERROR ** root view controller has changed, animation will no longer work");
        
        
    };
    return block;
}*/

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
