//
//  IRStartupViewControllerPhone.m
//  ForRent
//
//  Created by Akshay Shah on 5/24/13.
//  Copyright (c) 2013 Trulia Inc. All rights reserved.
//

#import "IRStartupViewControllerPhone.h"
#import "ICImageBundleUtil.h"

@interface IRStartupViewControllerPhone ()

@end

@implementation IRStartupViewControllerPhone

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

- (NSArray *)imagesArray{

    return [NSArray arrayWithObjects:[UIImage imageNamed:@"TutorialMapMarkers"],
            [UIImage imageNamed:@"TutorialHeatmaps"],
            [UIImage imageNamed:@"TutorialSave"],
            nil];
}

@end
