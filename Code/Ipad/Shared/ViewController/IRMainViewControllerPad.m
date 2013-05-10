//
//  IRMainViewControllerPad.m
//  IosRentalUniversal
//
//  Created by Akshay Shah on 5/9/13.
//  Copyright (c) 2013 Trulia Inc. All rights reserved.
//

#import "IRMainViewControllerPad.h"
#import "IRFilterViewControllerPad.h"

@interface IRMainViewControllerPad ()

@end

@implementation IRMainViewControllerPad

- (void)initializeFilterView{

    if(!self.filterViewController)
		self.filterViewController = [[IRFilterViewControllerPad alloc] init];
}

@end
