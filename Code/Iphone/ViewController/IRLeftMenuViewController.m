//
//  IRLeftMenuViewController.m
//  ForRent
//
//  Created by Neha Shevade on 1/13/14.
//  Copyright (c) 2014 Trulia Inc. All rights reserved.
//

#import "IRLeftMenuViewController.h"

@interface IRLeftMenuViewController ()

@end

@implementation IRLeftMenuViewController

- (id)initWithLeftViewController:(UIViewController *) left_ rightViewController:(UIViewController *) right_
{
    self = [super initWithLeftViewController:left_ rightViewController:right_];
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

- (void)animateStarToSavesMenuFromView:(UIView *)fromView completionBlock:(void (^) (void))completionBlock{
    [self animateStarToMenuFromView:fromView forMenuItem:0 completionBlock:completionBlock];
}


@end
