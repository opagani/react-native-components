//
//  ICApplicationConfiguration.h
//  TruliaMap
//
//  Created by Daniel Lowrie on 11/14/11.
//  Copyright (c) 2011 Trulia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICApplicationConfiguration : NSObject

@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSDictionary *adCampaignDictionary;
@property (nonatomic, strong) NSDictionary *adPositionDictionary;
@property (nonatomic, assign) BOOL upgradeAvailable;
@property (nonatomic, assign) BOOL kill;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
