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
    
    IRListingRefineViewControllerPhone *viewController = [[IRListingRefineViewControllerPhone alloc] initWithNibName:@"ICListingRefineViewControllerPhone" bundle:[NSBundle coreResourcesBundle] searchController:self.searchController];
    viewController.delegate = self;
    self.isFilterViewVisible = YES;
    
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void) initLayersMenuTable {
    self.layersMenuTable = [[IRLayersMenuViewControllerPhone alloc] initWithNibName:@"ICLayersMenuViewControllerPhone" bundle:[NSBundle coreResourcesBundle] withSearchController:self.searchController];
}

- (void)showLayersAndNearbyButton {
    self.btnLayers.hidden = NO;
    self.btnNearby.hidden = NO;
}

- (void)hideLayersAndNearbyButton {
    self.btnLayers.hidden = YES;
    self.btnNearby.hidden = YES;
}

-(AnimationBlock)animationBlockForSave{
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
