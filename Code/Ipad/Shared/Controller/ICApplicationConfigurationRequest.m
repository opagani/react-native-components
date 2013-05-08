//
//  ICApplicationConfigurationRequest.m
//  TruliaMap
//
//  Created by Daniel Lowrie on 11/14/11.
//  Copyright (c) 2011 Trulia Inc. All rights reserved.
//

#import "ICApplicationConfigurationRequest.h"
#import "ICAccountController.h"
#import "IC+UIDevice.h"
#import "AFNetworking.h"
#import "ICApiRequest.h"

@interface ICApplicationConfigurationRequest()

@property(nonatomic, strong) NSOperation *op;
@end
@implementation ICApplicationConfigurationRequest

@synthesize delegate = _delegate;

- (void) startRequest {
    
    NSString *url = [NSString stringWithFormat:@"%@source=TruliaMap&version=%@&deviceVersion=%@&deviceModel=%@&entityId=%@", IC_API_APPQUERY, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [UIDevice currentDevice].systemVersion, [UIDevice currentDevice].model, [[UIDevice currentDevice] secureDeviceId]];
    
//    NSString *url = [NSString stringWithFormat:@"%@source=TruliaMap&version=%@&devicePlatformId=%@&deviceVersion=%@&deviceModel=%@&entityId=%@", IC_API_APPQUERY, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[UIDevice currentDevice] uniqueIdentifier], [UIDevice currentDevice].systemVersion, [UIDevice currentDevice].model, [[UIDevice currentDevice] secureDeviceId]];

    if ([[ICAccountController sharedInstance] email]) {
        url = [url stringByAppendingFormat:@"&email=%@", [[ICAccountController sharedInstance] email]];
    }

    __weak ICApplicationConfigurationRequest *weakself = self;
    self.op = [ICApiRequest apiRequestWithUrl:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding] success:^(id JSON)
    {
        NSArray *resultList = nil;
            NSDictionary *metaInfo = nil;

            @try
            {


                resultList = (NSArray *)
                [JSON objectForKey:@"result"];
                metaInfo = (NSDictionary *)
                [JSON objectForKey:@"meta"];


                NSDictionary *statusCode = [metaInfo objectForKey:@"_status"];
                //check if status is okay
                if ([[statusCode objectForKey:@"code"] intValue] != 0)
                {

                    [_delegate applicationConfigurationRequest:weakself gotError:nil withMetaInfo:metaInfo];
                    return;
                }

            }
            @catch (NSException *e)
            {
                if([_delegate respondsToSelector:@selector(applicationConfigurationRequest:gotError:withMetaInfo:)]){
                    [_delegate applicationConfigurationRequest:weakself gotError:nil withMetaInfo:nil];
                }
                return;
            }
            @finally
            {

            }

            if ([_delegate respondsToSelector:@selector(applicationConfigurationRequest:gotResult:withMetaInfo:)])
            {
                [_delegate applicationConfigurationRequest:weakself gotResult:resultList withMetaInfo:metaInfo];
            }
    } failure:^(NSError *error)
    {
        if ([_delegate respondsToSelector:@selector(applicationConfigurationRequest:gotError:withMetaInfo:)])
                {
                    [_delegate applicationConfigurationRequest:weakself gotError:nil withMetaInfo:nil];
                }
    }];


    [self.op start];
    
}



- (void)dealloc{

    [self.op cancel];
    self.op = nil;
    self.delegate = nil;

}

@end
