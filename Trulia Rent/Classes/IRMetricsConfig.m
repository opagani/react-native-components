//
//  IRMetricsConfig.m
//  Trulia Rent
//
//  Created by David Pan on 12/28/16.
//  Copyright © 2016 Trulia Inc. All rights reserved.
//

#import "IRMetricsConfig.h"

@implementation IRMetricsConfig
-(NSString*)source{
    NSString * source = nil;
    
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPad:
            source = @"IpadRental";
            break;
        case UIUserInterfaceIdiomPhone:
            source = @"IosRental";
            break;
        default:
            break;
    }
    
    return source;
}

@end
