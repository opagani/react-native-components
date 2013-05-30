//
//  IRMoreViewController.m
//  ForRent
//
//  Created by Akshay Shah on 5/30/13.
//  Copyright (c) 2013 Trulia Inc. All rights reserved.
//

#import "IRMoreViewController.h"
#import "IRStartupViewControllerPhone.h"

@interface IRMoreViewController ()

@end

@implementation IRMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (ICStartupViewControllerPhone *)startupViewControllerForPhone {
    
    IRStartupViewControllerPhone *startupView = [[IRStartupViewControllerPhone alloc] initWithNibName:@"IRStartupViewController_iPhone" bundle:[NSBundle coreResourcesBundle]];
    [startupView setDelegate:self];
    return startupView;
}

@end
