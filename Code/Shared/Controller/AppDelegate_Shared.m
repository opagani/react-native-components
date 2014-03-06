//
//  AppDelegate_Shared.m
//  TruliaMap
//
//  Created by Michael Coutinho on 8/27/10.
//  Copyright Trulia Inc. 2010. All rights reserved.
//

#import <Crashlytics/Crashlytics.h>
#import "AppDelegate_Shared.h"
#import "ICPreference.h"
#import "SplashScreenViewController.h"
#import "Appirater.h"
#import "ICAdSearchController.h"
#import "IAURLCache.h"

@implementation AppDelegate_Shared
@synthesize window;

#pragma mark -
#pragma mark UIApplicationDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([super application:application didFinishLaunchingWithOptions:launchOptions]) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        return YES;
    }
    else {
        
        return NO;
        
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [super applicationWillEnterForeground:application];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[ICPreference sharedInstance] synchronize];
	
    NSError *error = nil;
    if (managedObjectContext_ != nil) {
        if ([managedObjectContext_ hasChanges] && ![managedObjectContext_ save:&error]) {
            GRLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    [super applicationWillResignActive:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [super applicationDidBecomeActive:application];
    
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    CLSLog(@"%s ** memory warning **", __func__);
    
    [[ICAdSearchController sharedInstance] flush];
}

- (void)dealloc {
    
    [[ICAdSearchController sharedInstance] flush];
    
    if ([[NSURLCache sharedURLCache] isKindOfClass:[IAURLCache class]]) {
        [(IAURLCache *)[NSURLCache sharedURLCache] flush];
    }
}




@end
