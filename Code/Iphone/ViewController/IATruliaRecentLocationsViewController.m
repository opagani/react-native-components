//
//  IATruliaRecentLocationsViewController.m
//  Trulia
//
//  Created by John Michael Zorko on 8/29/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import "IATruliaRecentLocationsViewController.h"

@interface IATruliaRecentLocationsViewController ()

@end

@implementation IATruliaRecentLocationsViewController

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
