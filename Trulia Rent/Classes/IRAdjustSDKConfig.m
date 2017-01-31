//
//  IRAdjustSDKConfig.m
//  Trulia Rent
//
//  Created by David Pan on 1/12/17.
//  Copyright © 2017 Trulia Inc. All rights reserved.
//

#import "IRAdjustSDKConfig.h"


@implementation IRAdjustSDKConfig
-(NSString *)appToken{
    return @"qh2bicxj3ojk";
}
-(NSDictionary *)eventTokenMapping{
    return @{
             @"ForSalePDPView": @"377y35",
             @"ForRentSingleUnitPDPView" : @"sji8bf",
             @"ForRentComunityPDPView": @"yieh3f",
             @"ForRentSingleUnitLeadEmail": @"4lib2b",
             @"ForRentSingleUnitLeadPhone" : @"oonen4",
             @"ForRentCommunityLeadEmail" : @"86phfr",
             @"ForRentCommunityLeadPhone":@"j8avro",
             @"Registration": @"q1quz5",
             @"SaveListing": @"k5vzpb",
             @"SaveSearch": @"x3vg9d"
             };
}
@end
