//
//  IRMainMenuAppsSection.m
//  Trulia Rent
//
//  Created by Christopher Echanique on 7/9/15.
//  Copyright (c) 2015 Trulia Inc. All rights reserved.
//

#import "IRMainMenuAppsSection.h"
#import "ICMenuHeaders.h"

@implementation IRMainMenuAppsSection
- (instancetype)init
{
    NSArray * appItems = @[[ICConsumerAppLinkMenuItem menuItem],
                           [ICAgentAppLinkMenuItem menuItem],
                           [ICLuxeBlogMenuItem menuItem]];
    
    NSString * title = ICLocalizedString(@"TRULIA APPS");
    return [super initWithTitle:title items:appItems];
}
@end
