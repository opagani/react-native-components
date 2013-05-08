//
//  ForeclosureVisitTargetController.m
//  TruliaMap
//
//  Created by Michael Coutinho on 3/10/11.
//  Copyright 2011 Trulia Inc. All rights reserved.
//

#import "ForeclosureVisitTargetController.h"

@implementation ForeclosureVisitTargetController
@synthesize _url;

#pragma mark -
#pragma mark Utility methods

- (void)handleAction:(NSString *)url withMessage:(NSString *)msg; {
	self._url = url;
	if(nil == url) return;
	
	if(nil != msg)
		msg = [msg stringByReplacingOccurrencesOfString:@"+" withString:@" "];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Do you want to leave the Trulia App?" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
	[alertView show];
}

#pragma mark -
#pragma mark UIAlertViewDelegate Management

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex; {
	if(buttonIndex>0)
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];	
}


#pragma mark -
#pragma mark Singleton Management

+ (ForeclosureVisitTargetController *)sharedInstance {
	static dispatch_once_t pred;
	static ForeclosureVisitTargetController *sharedInstance = nil;
    
    //now that we are on 4.0+ we can use grand central dispatch
	dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
	return sharedInstance;
}

@end
