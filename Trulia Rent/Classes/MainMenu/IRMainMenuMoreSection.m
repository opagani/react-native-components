//
//  IRMainMenuMoreSection.m
//  Trulia Rent
//
//  Created by Christopher Echanique on 7/9/15.
//  Copyright (c) 2015 Trulia Inc. All rights reserved.
//

#import "IRMainMenuMoreSection.h"
#import "ICMenuHeaders.h"

@implementation IRMainMenuMoreSection

-(instancetype)init{
    NSArray * moreItems = @[[ICFeedbackMenuItem menuItem],
                            [ICRateAppLinkMenuItem menuItem],
                            [ICShareAppMenuItem menuItem],
                            [ICSettingsMenuItem menuItem]];
    
    NSString * title = ICLocalizedString(@"MORE");
    return [self initWithTitle:title items:moreItems];
}

@end
