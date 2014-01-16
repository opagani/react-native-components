//
//  IRListingDetailViewControllerPad.m
//  ForRent
//
//  Created by Neha Shevade on 1/15/14.
//  Copyright (c) 2014 Trulia Inc. All rights reserved.
//

#import "IRListingDetailViewControllerPad.h"
#import "ICListing.h"
#import "UIButton+UIButton_SaveUnSaveListing.h"
#import "UIApplication+ICAdditions.h"
#import "ICMainMenuViewControllerPhone.h"
#import "ICLeftMenuViewController.h"
#import "ICMessageView.h"


@interface IRListingDetailViewControllerPad ()

@end

@implementation IRListingDetailViewControllerPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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


- (IBAction)actionSaveUnsave:(id)sender
{
   // [super actionSaveUnsave:sender];
    
    [(UIButton *) sender setListing:self.listing];
    
    self.icMessagenavigationbarBottomOfViewController = [NSNumber numberWithFloat:50.0];
    
    [(UIButton *) sender actionSaveUnsaveInViewController:(id<ICButtonSaveProtocol>)self viewControllerForLoginModalDisplay:[UIApplication applicationRootViewController] animationBlock:^(UIView *view)
     {
         UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
         
         if ([vc isKindOfClass:[ICLeftMenuViewController class]])
         {
             ICMainMenuViewControllerPhone *menu = (ICMainMenuViewControllerPhone *) ((ICLeftMenuViewController *) vc).left;
             
             [menu animateStarToMenuFromView:view forMenuItem:0 completionBlock:^
              {
                  [((ICLeftMenuViewController *) vc) toggleMenu:NO];
              }];
             [((ICLeftMenuViewController *) vc) toggleMenu:YES];
         }
         else
             GRLog(@"ERROR ** root view controller has changed, animation will no longer work");
     }];
    
}

@end
