//
//  IRAppDelegate.m
//  Trulia
//
//  Created by Daniel Lowrie on 1/24/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import "IRAppDelegate.h"

//utility
#import "ICConfiguration.h"
#import "ICCoreDataController.h"
#import "ICAccountController.h"
#import "ICAppearance.h"
#import "ICLog.h"
#import "ICMarketingAnalyticsController.h"
#import "ICManagedSearch.h"
#import "ICDiscoveryParameterSet.h"
#import "IRAdUnitConfiguration.h"
#import "IRProductInfo.h"
#import "ICListingSearchController.h"
#import "IRComscoreConfiguration.h"
#import "IRAdjustSDKConfig.h"
//view controllers
#import "ICDiscoveryViewController.h"

//frameworks
#import "ICSearchFiltersViewController.h"
#import "HockeySDK.h"

@implementation IRAppDelegate
@synthesize adConfig = _adConfig, product = _product, comscoreConfig = _comscoreConfig, adjustConfig = _adjustConfig;

void uncaughtExceptionHandler(NSException *exception) {
    DDLogError(@"CRASH: %@", exception);
    DDLogError(@"Stack Trace: %@", [exception callStackSymbols]);
}


#pragma mark - Overridden Methods

#pragma mark - Configuration Methods

- (void)configureWindow {
    [ICAppearance applyDefaultStyle];
}

- (void)setupRentalConfigurations {

    [ICDiscoveryParameterSet setDefaultIndexType:IC_INDEXTYPE_FORRENT];
    [ICSearchFiltersViewController setSegmentControlModes:@[@(ICSearchFiltersFormTypeForRent)]];
    [[ICListingSearchController sharedInstance] setInitialIndexTypes:@[IC_INDEXTYPE_FORRENT]];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (![super application:application didFinishLaunchingWithOptions:launchOptions]){
        return NO;
    };
    
    [self configureWindow];
    [self setupRentalConfigurations];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [super applicationWillResignActive:application];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [super applicationDidEnterBackground:application];
    
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
    [super applicationWillEnterForeground:(UIApplication *)application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [super applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

-(id<ICAdUnitConfiguration>)adConfig{
    if(!_adConfig){
        _adConfig = [IRAdUnitConfiguration new];
    }
    return _adConfig;
}

-(id<ICAppProduct>)product{
    if(!_product){
        _product = [IRProductInfo new];
    }
    return _product;
}

-(id<ICComScoreConfiguration>)comscoreConfig{
    if(!_comscoreConfig){
        _comscoreConfig = [IRComscoreConfiguration new];
    }
    return _comscoreConfig;
}

-(id<ICAdjustSDKConfiguration>)adjustConfig{
    if(!_adjustConfig){
        _adjustConfig = [IRAdjustSDKConfig new];
    }
    return _adjustConfig;
}

// FIXME: alert view has been deprecated
//same for rate us app and upgrade app alert
//- (void)alertView:(UIAlertView *)appAlert clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//    //  **********************************************************************
//    //  **********************************************************************
//    //  be careful when adding here, make sure alertview underneath
//    //  (ICAppDelegate) gets its alertView:clickedButtonAtIndex: called
//    //  **********************************************************************
//    //  **********************************************************************
//    
//    NSInteger tag = appAlert.tag;
//    if (tag == TruliaAlertTypeUpdate || tag == TruliaPromoAlertTypeRateAppUniversal )
//    {
//        NSMutableString *trackingString = [NSMutableString stringWithString:@"promo"];
//        
//        if (appAlert.tag == TruliaPromoAlertTypeRateAppUniversal)
//        {
//            [trackingString appendString:@"|rate app"];
//        }
//        else
//        {
//            [trackingString appendString:@"|unknown alert"];
//        }
//        
//        // This could be prettier but since -[UIApplication openURL:] will bounce us out of the app, let's make sure all the tracking is taken care of cleanly first.
//        BOOL userConfirmed = buttonIndex == appAlert.firstOtherButtonIndex;
//        
//        if (userConfirmed)
//        {
//            [trackingString appendString:@"|yes"];
//        }
//        else if (buttonIndex == appAlert.cancelButtonIndex)
//        {
//            [trackingString appendString:@"|cancel"];
//        }
//        
//        [[ICAnalyticsController sharedInstance] trackActionClick:trackingString withPage:[[ICAnalyticsController sharedInstance] lastPageTrack]];
//        
//        
//        if (userConfirmed)
//        {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[ICConfiguration appStoreLink]]];
//        }
//    }
//    else
//    {
//        if([super respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
//        {
//            [super alertView:appAlert clickedButtonAtIndex:buttonIndex];
//        }
//    }
//}


#pragma mark - Deep Linking


/*-(void)routeInput:(ICRouterInput *)route
{
    
    [[ICPreference sharedInstance] setAppForKey:@"TmaPrefetch" withAttribute:@"NO"];
    
    if (route.action == ROUTINGACTION_PROPERTY)
    {
        
        if ([UIDevice isPad])
        {
            ICListingParameters *searchParams = [ICListingParameters new];
            
            [searchParams populateSearchWithPropertyListing:route.parsedParam];
            
            [[ICListingSearchController sharedInstance] searchWithParameters:searchParams];
            
            [[ICMainViewControllerPad sharedInstance] navigateDirectlyToPdp:route.parsedParam];
        }
        else
        {
            [self.navController popToRootViewControllerAnimated:NO];
            
            ICListing *currParams = (ICListing *) route.parsedParam;
            
            ICListingParameters *srchParams = [[ICListingParameters alloc] init];
            
            [srchParams populateSearchWithPropertyListing:currParams];
            
            srchParams.indexType = [NSMutableArray arrayWithObject:[ICRouterInput getSearchTypeString:route.searchType]];
            
            ICListingSearchViewControllerDefault *searchController = [ICListingSearchViewControllerDefault sharedInstance];
            [searchController searchWithParameters:srchParams];
            
            ICListingDetailViewControllerPhone *detailViewController = [[ICListingDetailViewControllerPhone alloc] initWithNibName:@"ICListingDetailViewControllerPhone" bundle:[NSBundle coreResourcesBundle]];
            [detailViewController setWithListing:(ICListing *) route.parsedParam andRefresh:NO];
            [searchController.navigationController pushViewController:detailViewController animated:NO];
        }
        
    }
    else if (route.action == ROUTINGACTION_SEARCH)
    {
        
        if ([UIDevice isPad])
        {
            if (route.parsedParam)
                [[ICListingSearchController sharedInstance] searchWithParameters:route.parsedParam];
        }
        else
        {
            [self.navController popToRootViewControllerAnimated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC), dispatch_get_main_queue (), ^
                           {
                               if (route.parsedParam){
                                   ICListingSearchViewControllerDefault *searchController = [ICListingSearchViewControllerDefault sharedInstance];
                                   [searchController searchWithParameters:route.parsedParam];
                               }
                           });
        }
        
    }else if(route.action == ROUTINGACTION_HOME){
        
        [self.navController popToRootViewControllerAnimated:YES];
    }
}*/

/*-(void)routeInput:(ICRouterInput *)route
{
    
    [[ICPreference sharedInstance] setAppForKey:@"TmaPrefetch" withAttribute:@"NO"];
    
    if (route.action == ROUTINGACTION_PROPERTY)
    {
        
        if ([UIDevice isPad])
        {
            ICListingParameters *searchParams = [ICListingParameters new];
            
            [searchParams populateSearchWithPropertyListing:route.parsedParam];
            
            [[ICListingSearchController sharedInstance] searchWithParameters:searchParams];
            
            [[ICMainViewControllerPad sharedInstance] navigateDirectlyToPdp:route.parsedParam];
        }
        else
        {
            [self.navController popToRootViewControllerAnimated:NO];
            
            ICListing *currParams = (ICListing *) route.parsedParam;
            
            ICListingParameters *srchParams = [[ICListingParameters alloc] init];
            
            [srchParams populateSearchWithPropertyListing:currParams];
            
            srchParams.indexType = [NSMutableArray arrayWithObject:[ICRouterInput getSearchTypeString:route.searchType]];
            
            ICListingSearchViewControllerDefault *searchController = [ICListingSearchViewControllerDefault sharedInstance];
            [searchController searchWithParameters:srchParams];
            
            ICListingDetailViewControllerPhone *detailViewController = [[ICListingDetailViewControllerPhone alloc] initWithNibName:@"ICListingDetailViewControllerPhone" bundle:[NSBundle coreResourcesBundle]];
            [detailViewController setWithListing:(ICListing *) route.parsedParam andRefresh:NO];
            [searchController.navigationController pushViewController:detailViewController animated:NO];
        }
        
    }
    else if (route.action == ROUTINGACTION_SEARCH)
    {
        
        if ([UIDevice isPad])
        {
            if (route.parsedParam)
                [[ICListingSearchController sharedInstance] searchWithParameters:route.parsedParam];
        }
        else
        {
            [self.navController popToRootViewControllerAnimated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC), dispatch_get_main_queue (), ^
                           {
                               if (route.parsedParam){
                                   ICListingSearchViewControllerDefault *searchController = [ICListingSearchViewControllerDefault sharedInstance];
                                   [searchController searchWithParameters:route.parsedParam];
                               }
                           });
        }
        
    }else if(route.action == ROUTINGACTION_HOME){
        
        [self.navController popToRootViewControllerAnimated:YES];
    }
}*/

#pragma mark Handle Push Notifications

//- (void)handlePushNotification:(NSDictionary *)pushNotificationDictionary {
//    
//    [super handlePushNotification:pushNotificationDictionary];
//    NSString *pushNotificationType = [pushNotificationDictionary objectForKey:@"type"];
//    
//    if([pushNotificationType intValue] != 0) {
//        switch ([pushNotificationType intValue]) {
//            case AGENT_LEAD_PUSH_NOTIFICATION:
//                break;
//            case SAVEDSEARCHNEWLISTING_PUSH_NOTIFICATION:
//            {
//                if ([[ICAccountController sharedInstance] isLoggedIn] && [UIDevice isPhone]){
//                    //FIXME: main menui view controller has been removed
////                    if ([self.menuAndSrpContainerController.left isKindOfClass:[IRMainMenuViewController class]]){
////                        IRMainMenuViewController* menuController = (IRMainMenuViewController*)self.menuAndSrpContainerController.left;
////                        [menuController actionNotificationsClicked:nil];
////                    }
//                }
//                break;
//            }
//            case SAVEDSEARCHOPENHOUSE_PUSH_NOTIFICATION:
//                break;
//            case SAVEDHOMESTATUS_PUSH_NOTIFICATION:
//                break;
//            case SAVEDHOMEREDUCED_PUSH_NOTIFICATION:
//                break;
//            case SAVEDHOMEOPENHOUSE_PUSH_NOTIFICATION:
//                break;
//            case MESSAGE_PUSH_NOTIFICATION:
//                break;
//            case URL_PUSH_NOTIFICATION:
//                break;
//            default:
//                break;
//        }
//    }
//}

@end

