//
//  IRMainMenuViewControllerPhone.m
//  Trulia Rent
//
//  Created by Daud Kabiri on 9/15/14.
//  Copyright (c) 2014 Trulia Inc. All rights reserved.
//

#import "IRMainMenuViewControllerPhone.h"

@interface IRMainMenuViewControllerPhone ()

@end

@implementation IRMainMenuViewControllerPhone



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Overridden Menu Items IndexPaths
-(NSIndexPath*)savesIndexPath{
    return [NSIndexPath indexPathForRow:([UIDevice isPhone] ? My_Saves_Rental : My_Saves_iPad_Rental) inSection:1];
}

@end
