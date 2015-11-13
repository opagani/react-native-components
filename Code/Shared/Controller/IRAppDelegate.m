//
//  IRAppDelegate.m
//  Trulia
//
//  Created by Daniel Lowrie on 1/24/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import "IRAppDelegate.h"

//utility
#import "ICPreference.h"
#import "ICConfiguration.h"
#import "ICCoreDataController.h"
#import "ICSyncController.h"
#import "ICAccountController.h"
#import "IRMainMenu.h"
#import "IRURLCache.h"
#import "IAConstants.h"
#import "ICManagedNotification.h"
#import "ICAppearance.h"
#import "ICLog.h"
#import "ICUtility.h"
#import "ICAnalyticsController.h"

//view controllers
#import "ICDiscoveryViewController.h"
#import "IRMainMenuViewController.h"

//frameworks
#import <Crashlytics/Crashlytics.h>

@implementation IRAppDelegate

@synthesize window = _window;
@synthesize navController = _navController;

void uncaughtExceptionHandler(NSException *exception) {
    GRLogCError(@"CRASH: %@", exception);
    GRLogCError(@"Stack Trace: %@", [exception callStackSymbols]);
}

#pragma mark - Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    CLSLog(@"%s ** memory warning **", __func__);
    
    [[ICAdSearchController sharedInstance] flush];
}

- (void)dealloc {
    
    [[ICAdSearchController sharedInstance] flush];
    
    if ([[NSURLCache sharedURLCache] isKindOfClass:[IRURLCache class]]) {
        [(IRURLCache *)[NSURLCache sharedURLCache] flush];
    }
}

#pragma mark - Overridden Methods

-(void)setupCollaboration{
    //updates the current sessions collab enabled flag to the collab flag in ICState
    //these values may be different at various times during the apps life cycle
    //eg. app/v1/query returns collab enabled flag after didFinishLaunching finishes
    ICState * state                 = [ICState sharedInstance];
    [ICPreference updateCollabEnabledPreferenceFromState:state];
}

#pragma mark - Configuration Methods

- (void)configureWindow {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([self.window respondsToSelector:@selector(tintColor)]) {
        [self.window setTintColor:[UIColor truliaGreen]];
    }
    // the color background is white so that it natches with the background when status bar hides in the photoviewcontroller
    self.window.backgroundColor = [UIColor whiteColor];
    
    [ICAppearance applyDefaultStyle];
}

- (void)setupRentalConfigurations {
    ICListingParameters *currentParameters = [[ICListingSearchController sharedInstance] currentParameters];
    currentParameters.indexType = [[NSMutableArray alloc] initWithObjects:IC_INDEXTYPE_FORRENT, nil];
    [[ICListingSearchController sharedInstance] setCurrentParameters:currentParameters];
    
    [ICManagedSearch setDefaultIndexType:IC_INDEXTYPE_FORRENT];
}

- (void)initializeRootViewController
{
    IRMainMenuViewController *menuController = [[IRMainMenuViewController alloc] initWithMenu:[IRMainMenu new]];
    
    UIViewController *rootViewController = [self navigationRootViewController];
    ICNavigationController *navCtr = [[ICNavigationController alloc] initWithRootViewController:rootViewController];
    self.menuAndSrpContainerController = [[ICMenuContainerViewController alloc] initWithLeftViewController:menuController rightViewController:navCtr];
    self.navController = navCtr;
}

- (UIViewController *)navigationRootViewController {
    if ([UIDevice isPad]) {
        return [ICSRPViewControllerDefault sharedInstance];
    }
    return [ICDiscoveryViewController new];
}

- (void)setRootViewController
{
    [_window setRootViewController:self.menuAndSrpContainerController];
    [_window makeKeyAndVisible];
}

- (void)launchApp {
    [self initializeRootViewController];
    
    if ([self shouldShowOnboardingScreens]) {
        [self showOnboardingScreens];
    }
    else {
        [self setRootViewController];
    }
}

- (BOOL) shouldShowOnboardingScreens {
    return [ICUtility freshInstall];
}

- (void)showOnboardingScreens
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ICOnboardingBaseViewController" bundle:[NSBundle coreResourcesBundle]];
    
    self.onboardingController = [storyboard instantiateInitialViewController];
    self.onboardingController.delegate = self;
    
    [_window setRootViewController:self.onboardingController];
    [_window makeKeyAndVisible];
}


#pragma mark - onboarding delegate

-(void)onBoardingScreensDimissed:(UIViewController *)onboardingVC {
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self setRootViewController];
}

- (void)requestNotificationsPermission {
    [self registerNotification];
}

#pragma mark - Splash Screen Delegate for iPhone

-(void)dismissStartupScreen:(UIViewController*)viewController{
    [self setRootViewController];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (![super application:application didFinishLaunchingWithOptions:launchOptions]){
        return NO;
    };
    
    [self configureWindow];
    [self setupRentalConfigurations];
    [self launchApp];
    
    [ICListingRefineViewController setSegmentControlModes:@[@(ICListingRefineModeForRent)]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [super applicationWillResignActive:application];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    if ([UIDevice isPhone]){
        
        NSInteger unreadCount = MAX([ICManagedNotification numberofUnreadNotifications], 0);
        [UIApplication sharedApplication].applicationIconBadgeNumber = unreadCount;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [super applicationDidEnterBackground:application];
    
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    ICListingSearchController *controller = [ICListingSearchController sharedInstance];
    if (![[controller currentSearch] isDeleted]) {
        [[controller currentSearch] markAsViewed];
    }
    
    [[ICCoreDataController sharedInstance] saveWithNotification:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
    if (![UIDevice isPhone]){
        
        [[ICCurrentLocationController sharedInstance].locationManager stopUpdatingLocation];
        //[[GRCurrentLocationController sharedInstance] resetLocationStatusFlags];
        [[ICPreference sharedInstance] resetSes];
        
        //	[self.viewController processRateUsAppPopup];
        [[ICPreference sharedInstance] synchronize];
    }
    
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
    [[ICPreference sharedInstance] synchronize];
}

//same for rate us app and upgrade app alert
- (void)alertView:(UIAlertView *)appAlert clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //  **********************************************************************
    //  **********************************************************************
    //  be careful when adding here, make sure alertview underneath
    //  (ICAppDelegate) gets its alertView:clickedButtonAtIndex: called
    //  **********************************************************************
    //  **********************************************************************
    
    NSInteger tag = appAlert.tag;
    if (tag == TruliaAlertTypeUpdate || tag == TruliaPromoAlertTypeRateAppUniversal )
    {
        NSMutableString *trackingString = [NSMutableString stringWithString:@"promo"];
        
        if (appAlert.tag == TruliaPromoAlertTypeRateAppUniversal)
        {
            [trackingString appendString:@"|rate app"];
        }
        else
        {
            [trackingString appendString:@"|unknown alert"];
        }
        
        // This could be prettier but since -[UIApplication openURL:] will bounce us out of the app, let's make sure all the tracking is taken care of cleanly first.
        BOOL userConfirmed = buttonIndex == appAlert.firstOtherButtonIndex;
        
        if (userConfirmed)
        {
            [trackingString appendString:@"|yes"];
        }
        else if (buttonIndex == appAlert.cancelButtonIndex)
        {
            [trackingString appendString:@"|cancel"];
        }
        
        [[ICAnalyticsController sharedInstance] trackActionClick:trackingString withPage:[[ICAnalyticsController sharedInstance] lastPageTrack]];
        
        
        if (userConfirmed)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[ICConfiguration appStoreLink]]];
        }
    }
    else
    {
        if([super respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        {
            [super alertView:appAlert clickedButtonAtIndex:buttonIndex];
        }
    }
}

- (void)loadMyAccountWithId:(NSString *)notificationId andType:(NSInteger)notificationType {
    
    [[ICSyncController sharedInstance] syncService:ICSYncServiceTypeNotification complete:nil];

}


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

- (NSString *)appIdentifier{
    
    return [[ICConfiguration sharedInstance] metricItem:@"Source"];
}

#pragma mark Handle Push Notifications

- (void)handlePushNotification:(NSDictionary *)pushNotificationDictionary {
    
    [super handlePushNotification:pushNotificationDictionary];
    NSString *pushNotificationType = [pushNotificationDictionary objectForKey:@"type"];
    
    if([pushNotificationType intValue] != 0) {
        switch ([pushNotificationType intValue]) {
            case AGENT_LEAD_PUSH_NOTIFICATION:
                break;
            case SAVEDSEARCHNEWLISTING_PUSH_NOTIFICATION:
            {
                if ([[ICAccountController sharedInstance] isLoggedIn] && [UIDevice isPhone]){
                    
                    if ([self.menuAndSrpContainerController.left isKindOfClass:[IRMainMenuViewController class]]){
                        IRMainMenuViewController* menuController = (IRMainMenuViewController*)self.menuAndSrpContainerController.left;
                        [menuController actionNotificationsClicked:nil];
                    }
                }
                break;
            }
            case SAVEDSEARCHOPENHOUSE_PUSH_NOTIFICATION:
                break;
            case SAVEDHOMESTATUS_PUSH_NOTIFICATION:
                break;
            case SAVEDHOMEREDUCED_PUSH_NOTIFICATION:
                break;
            case SAVEDHOMEOPENHOUSE_PUSH_NOTIFICATION:
                break;
            case MESSAGE_PUSH_NOTIFICATION:
                break;
            case URL_PUSH_NOTIFICATION:
                break;
            default:
                break;
        }
    }
}

@end

