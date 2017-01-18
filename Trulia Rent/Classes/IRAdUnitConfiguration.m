//
//  IRAdUnitConfiguration.m
//  Trulia Rent
//
//  Created by David Pan on 12/21/16.
//  Copyright © 2016 Trulia Inc. All rights reserved.
//

#import "IRAdUnitConfiguration.h"

@implementation IRAdUnitConfiguration

-(NSString *)adUnitIdForProperty{
    NSString * idForProperty = nil;
    
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPhone:
            idForProperty = @"/7449/iPhone_Main_App/iPhone_App_Property_Results";
            break;
        default:
            break;
    }
    
    return idForProperty;
}

-(NSString *)adUnitIDPrefix{
    NSString * prefix = nil;
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPad:
            prefix = @"/7449/Trulia_iPad_Rentals_App";
            break;
        case UIUserInterfaceIdiomPhone:
            prefix = @"/7449/Trulia_iPhone_Rentals_App";
            break;
        default:
            break;
    }
    return prefix;
    
}

-(NSDictionary *)adUnitIDs{
    NSDictionary * unitIDs = nil;
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPad:
            unitIDs = @{
                        @"srch_Rent_General" : @"/7449/Trulia_iPad_Rentals_App/Search_Results/Rent_General/b_main_p1",
                        };
            break;
        case UIUserInterfaceIdiomPhone:
            break;
        default:
            break;
    }
    return unitIDs;
}

@end
