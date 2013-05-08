//
//  ICApplicationConfiguration.m
//  TruliaMap
//
//  Created by Daniel Lowrie on 11/14/11.
//  Copyright (c) 2011 Trulia Inc. All rights reserved.
//

#import "ICApplicationConfiguration.h"

@implementation ICApplicationConfiguration
@synthesize version = _version;
@synthesize adCampaignDictionary = _adCampaignDictionary;
@synthesize adPositionDictionary = _adPositionDictionary;
@synthesize upgradeAvailable = _upgradeAvailable;
@synthesize kill = _kill;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self && dictionary) {
        //initialize
        
        if ([dictionary objectForKey:@"version"])
            self.version = [dictionary objectForKey:@"version"];

        if ([dictionary objectForKey:@"adCampaignList"])
            self.adCampaignDictionary = [dictionary objectForKey:@"adCampaignList"];
        
        if ([dictionary objectForKey:@"adPositionList"])
            self.adPositionDictionary = [dictionary objectForKey:@"adPositionList"];
        
        if ([dictionary objectForKey:@"upgradeAvailable"])
            self.upgradeAvailable = [(NSNumber *)[dictionary objectForKey:@"upgradeAvailable"] boolValue];
        
        if ([dictionary objectForKey:@"kill"])
            self.kill = [(NSNumber *)[dictionary objectForKey:@"kill"] boolValue];
        
        
    }
    
    return self;
}


@end
