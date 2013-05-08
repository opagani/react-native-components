//
//  ForeclosureVisitTargetController.h
//  TruliaMap
//
//  Created by Michael Coutinho on 3/10/11.
//  Copyright 2011 Trulia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ForeclosureVisitTargetController : NSObject <UIAlertViewDelegate> {
	NSString *_url;
}

@property(nonatomic,copy) NSString *_url;

+ (ForeclosureVisitTargetController *)sharedInstance;
- (void)handleAction:(NSString *)url withMessage:(NSString *)msg; 

@end
