//
//  ICApplicationConfigurationRequest.h
//  TruliaMap
//
//  Created by Daniel Lowrie on 11/14/11.
//  Copyright (c) 2011 Trulia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICApplicationConfigurationRequest;
@protocol ICApplicationConfigurationRequestDelegate <NSObject>
@optional
- (void)applicationConfigurationRequest:(ICApplicationConfigurationRequest *)icApplicationConfigurationRequest gotResult:(NSArray *)resultList withMetaInfo:(NSDictionary *)metaInfo;
- (void)applicationConfigurationRequest:(ICApplicationConfigurationRequest *)icApplicationConfigurationRequest gotError:(NSError *)error withMetaInfo:(NSDictionary *)metaInfo;

@end

@interface ICApplicationConfigurationRequest : NSObject 


@property(nonatomic,unsafe_unretained) id delegate;

- (void) startRequest;

@end
