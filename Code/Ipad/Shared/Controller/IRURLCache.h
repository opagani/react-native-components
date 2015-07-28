//
//  IAURLCache.h
//  Trulia
//
//  Created by John Zorko on 11/7/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRURLCache : NSURLCache
{
    NSMutableDictionary *cachedResponses;
}

- (void)flush;

@end
