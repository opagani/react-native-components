
//
//  AppDelegate.m
//  Trulia
//
//  Created by Daniel Lowrie on 1/24/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import "AppDelegate.h"

#import "ICPreference.h"
#import "ICMetricsController.h"
#import "ICConfiguration.h"
#import "UINavigationBar+TruliaNavBackground.h"
#import "ICStartupViewControllerPhone.h"
#import "TruliaDataMigrationUtility.h"
#import "ICCoreDataController.h"
#import "ICMyAccountViewControllerPhone.h"
#import "ICSyncController.h"
#import "ICSyncServiceNotification.h"
#import "ICMainMenuViewControllerPhone.h"
#import "ICSwipeNavigationController.h"
#import "ICLeftMenuViewController.h"

#if RUN_STRESS_TEST
#import "ICStressTestController.h"
#endif

#import "SplashScreenViewController.h"
#import "ICPasteBoard.h"
#import "IAURLCache.h"
#import "ICRouterInput.h"
#import "ICApiRequest.h"

#if TARGET_IPHONE_SIMULATOR
#import "DCIntrospect.h"
//#import "PonyDebugger.h"
#endif

#import <NewRelicAgent/NewRelicAgent.h>
#import <Crashlytics/Crashlytics.h>
#import "ICListingDetailViewControllerPhone.h"
#import "IAConstants.h"
#import "ICFindAgentViewController.h"
#import "ICMoreViewController.h"
#import "ICMainMenuViewControllerPhone.h"
#import "ICMyAccountViewControllerPhone.h"
#import "IRMainViewControllerPad.h"
#import "IRListingSearchViewControllerPhone.h"

#define MENU_FIND_AN_AGENT_STRING @"Find an Agent"
#define MENU_OPEN_HOUSES_STRING   @"Open Houses"
#define MENU_RENT_STRING          @"Homes For Rent"
#define MENU_SALE_STRING          @"Homes For Sale"
#define MENU_MY_SAVES_STRING      @"My Saves"
#define MENU_SETTINGS_STRING      @"Settings & More"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;
@synthesize isShowingGalleryView;

- (void)log:(NSString *)msg {
	//[consoleTextView setText:[consoleTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@\r\r", msg]]];
}


- (void)saveUserLocations; {
	NSString *docFolder = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [docFolder stringByAppendingPathComponent:@"locations.plist"];
	NSArray *userLocations = [[ICListingSearchController sharedInstance] getUserLocationsForSave];
	if(userLocations != nil && [userLocations count] > 0) {
		[userLocations writeToFile: path atomically:YES];
	}
}
- (void)getUserLocations; {
	NSString *docFolder = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [docFolder stringByAppendingPathComponent:
					  @"locations.plist"];
	NSArray *locations = [NSArray arrayWithContentsOfFile:path];
	if(locations != nil) {
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        
        if([locations count] > 0)
            [tmp addObjectsFromArray:locations];
        
        [ICListingSearchController sharedInstance].previouslySearchedLocations = tmp;
	}
}

- (void)setRootViewControllerForIpad
{
    [_window setRootViewController:self.viewController];
    [_window makeKeyAndVisible];
}

- (NSArray*)getMainMenuForIdiom:(UIUserInterfaceIdiom)idiom{
    return [[NSArray alloc] initWithObjects:
            [NSDictionary dictionaryWithObjectsAndKeys:MENU_MY_SAVES_STRING, @"title", [NSNumber numberWithInt:My_Saves], @"search",[[ICMyAccountViewControllerPhone alloc] initWithNibName:@"ICMyAccountViewControllerPhone" bundle:[NSBundle coreResourcesBundle]], @"target", @"IconMenuMySaves", @"image",@"my-saves", @"track", nil],
            [NSDictionary dictionaryWithObjectsAndKeys:MENU_RENT_STRING, @"title",[NSNumber numberWithInt:For_Rent], @"search" , @"IconMenuForRent", @"image",@"search-for-rent", @"track", nil],
            [NSDictionary dictionaryWithObjectsAndKeys:MENU_SETTINGS_STRING, @"title",[[ICMoreViewController alloc] initWithStyle:UITableViewStylePlain],@"target", @"IconMenuSettings", @"image",@"more", @"track", nil],
            nil];
}

- (void)initializeRootViewControllerForIpad
{
    ICMainMenuViewControllerPhone *menu = [[ICMainMenuViewControllerPhone alloc] initWithNibName:@"ICMainMenuViewControllerPhone" bundle:[NSBundle coreResourcesBundle] menuItems:[self getMainMenuForIdiom:UI_USER_INTERFACE_IDIOM()]];
    self.viewController = [[ICLeftMenuViewController alloc] initWithLeftViewController: menu rightViewController: [IRMainViewControllerPad sharedInstance]];
    
    [IRMainViewControllerPad sharedInstance].toggleMenuBlock = ^(BOOL show){
        [self.viewController toggleMenu:show];
    };
    
    [IRMainViewControllerPad sharedInstance].leftMenuViewController = self.viewController;
}

- (void)setupAppConfigurationForIpad
{
    ICApplicationConfigurationRequest *configRequest = [[ICApplicationConfigurationRequest alloc] init];
    self.applicationConfigRequest = configRequest;
    [_applicationConfigRequest setDelegate:self];
    [_applicationConfigRequest startRequest];
    [AnalyticsManager startTracker];
}

- (void)launchIpadApp
{
    [self setupAppConfigurationForIpad];
    [self getUserLocations];
    
    if([SplashScreenViewController shouldShowMe]) {
        [self initializeRootViewControllerForIpad]; //Cache rootview, so its ready when splash is dismissed
        [self showSplashScreenForIpad];
    }else{
        [self initializeRootViewControllerForIpad];
        [self setRootViewControllerForIpad];
    }
}

- (void)setRootViewControllerForIphone {
    [_window setRootViewController:deckController];
    [_window makeKeyAndVisible];
}

- (void)showUpgradePopup {
    if([super isNewAppVersionAvailable]){
        [self showUpgradeAppPopup];
    }
}

- (void)setupListingParameters {
    ICListingParameters *currentParameters = [[ICListingSearchController sharedInstance] currentParameters];
    currentParameters.indexType = [[NSMutableArray alloc] initWithObjects:IC_INDEXTYPE_FORRENT, nil];
    [[ICListingSearchController sharedInstance] setCurrentParameters:currentParameters];
}

- (void)initializeRootViewControllerForIphone{
    
    self.isShowingGalleryView = NO;
    ICMainMenuViewControllerPhone *leftController = [[ICMainMenuViewControllerPhone alloc] initWithNibName:@"ICMainMenuViewControllerPhone" bundle:[NSBundle coreResourcesBundle] menuItems:[self getMainMenuForIdiom:UI_USER_INTERFACE_IDIOM()]];
    
    IRListingSearchViewControllerPhone *searchController = (IRListingSearchViewControllerPhone *)[IRListingSearchViewControllerPhone sharedInstance];
    
    ICNavigationController *navCtr = [[ICNavigationController alloc] initWithRootViewController:searchController];
    
    deckController =  [[ICSwipeNavigationController alloc] initWithCenterViewController:navCtr leftViewController:leftController rightViewController:nil];
    deckController.leftLedge = 60;
    [deckController setWantsFullScreenLayout:YES];
    [navCtr setToolbarHidden:YES];
}

- (BOOL)shouldShowSplashScreenForIphone{

    if (![[[ICPreference sharedInstance] getAppForKey:SESSION_KEY_INTRO_SHOWN] boolValue]
        || [[ICPreference sharedInstance] getAppForKey:SESSION_KEY_INTRO_SHOWN] == nil) {
        return YES;
    }
    
    return NO;
}

- (void)showSplashScreenForIphone
{
    ICStartupViewControllerPhone *startupView = [[ICStartupViewControllerPhone alloc] initWithNibName:@"IRStartupViewController_iPhone" bundle:[NSBundle coreResourcesBundle]];
    startupView.delegate = self;
    [_window setRootViewController:startupView];
    [_window makeKeyAndVisible];
}

- (void)launchIphoneApp
{
    if ([self shouldShowSplashScreenForIphone]){
        [self showSplashScreenForIphone];
        [self initializeRootViewControllerForIphone]; //Cache rootview, so its ready when splash is dismissed
    }else{
        [self initializeRootViewControllerForIphone];
        [self setRootViewControllerForIphone];
        [self showUpgradePopup];
    }
}

#pragma mark-
#pragma mark Splash Screen Delegate for iPhone

-(void)dismissStartupScreen:(UIViewController*)viewController{

    [self setRootViewControllerForIphone];
}

- (void)showSplashScreenForIpad
{
    SplashScreenViewController *splashViewController = [[SplashScreenViewController alloc] init];
    splashViewController.delegate = self;
    [_window setRootViewController:splashViewController];
    [_window makeKeyAndVisible];
}

#if TARGET_IPHONE_SIMULATOR

- (void)setupDebugUtilities
{
//    [[DCIntrospect sharedIntrospector] start];
    
//    PDDebugger *debugger = [PDDebugger defaultInstance];
//    [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
//    [debugger enableNetworkTrafficDebugging];
//    [debugger forwardAllNetworkTraffic];
//    [debugger enableViewHierarchyDebugging];
}

#endif

- (void)setupCrashReporting
{
    [Crashlytics startWithAPIKey:@"69c46441eff2d4c6f8a043fd66d16ff159cd9812"];
}

- (void)setupTracking
{
    [NewRelicAgent startWithApplicationToken:TRULIA_NEW_RELIC_API_KEY];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupListingParameters];
    
    if (![[ICCoreDataController sharedInstance] persistentStoreExists]) {
        TruliaDataMigrationUtility *migrationUtility = [[TruliaDataMigrationUtility alloc] init];
        [migrationUtility migrateTruliaDataStoreToIosCore];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.isShowingGalleryView = NO;
        [self launchIphoneApp];
    }
    else{
        [self launchIpadApp];
    }

#if TARGET_IPHONE_SIMULATOR
    [self setupDebugUtilities];
#endif

    [self setupTracking];
    [self setupCrashReporting];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

#pragma mark-
#pragma mark Splash Screen Delegate for iPad

-(void)goingOutOfView:(UIViewController*)viewController{

    [self setRootViewControllerForIpad];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [super applicationWillResignActive:application];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    
        [self.navController dismissModalViewControllerAnimated:NO];
        
        NSInteger unreadCount = [ICManagedNotification numberofUnreadNotifications];
        if(unreadCount > 0) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadCount;
        }
        else {
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
    }
    else{
    	[self saveUserLocations];
        [ICSyncController sharedInstance].shouldBeAutoSyncing = NO;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
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
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if([super isNewAppVersionAvailable]){
            [self showUpgradeAppPopup];
        }
    }
    else{
        [_applicationConfigRequest startRequest];
        
        [[ICCurrentLocationController sharedInstance].locationManager stopUpdatingLocation];
        //[[GRCurrentLocationController sharedInstance] resetLocationStatusFlags];
        [[ICPreference sharedInstance] resetSes];
        
        //	[self.viewController processRateUsAppPopup];
        [[ICPreference sharedInstance] synchronize];
        [self getUserLocations];
    }
    
    [super applicationWillEnterForeground:(UIApplication *)application];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [super applicationDidBecomeActive:application];
    [[ICMetricsController sharedInstance] trackTapSenseEvent:@"" forEventData:@""];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}





- (void) processUpgradeAppPopup:(NSString *)bundleAPI; {
	NSString *bundleShortVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
	
	if([bundleAPI compare:bundleShortVersion] != NSOrderedSame && [bundleAPI compare:@"off"] != NSOrderedSame && [[ICPreference sharedInstance] getVisForKey:@"shown_upgradeapp_prompt"] == nil) {
		[self showUpgradeAppPopup];
	}
	
}

- (void)showUpgradeAppPopup {
	UIAlertView *upgradeAppAlert = [[UIAlertView alloc] initWithTitle: @"Get the new app" message: @"An updated version of the Trulia App is now available via iTunes." delegate: self cancelButtonTitle: @"Not Now" otherButtonTitles: @"Update", nil];
    upgradeAppAlert.tag = TruliaPromoAlertTypeUpdate;
	
    [[ICMetricsController sharedInstance] trackPageView:@"promo|update app|view"];
      
    
	[upgradeAppAlert show];
	[[ICPreference sharedInstance] setVisForKey:@"shown_upgradeapp_prompt" withAttribute:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]];
}

//same for rate us app and upgrade app alert
- (void)alertView:(UIAlertView *)appAlert clickedButtonAtIndex:(NSInteger)buttonIndex {

    //  **********************************************************************
    //  **********************************************************************
    //  be careful when adding here, make sure alertview underneath
    //  (ICAppDelegate) gets its alertView:clickedButtonAtIndex: called
    //  **********************************************************************
    //  **********************************************************************

    int tag = appAlert.tag;
    if (tag == TruliaPromoAlertTypeUpdate || tag == TruliaPromoAlertTypeRateAppUniversal )
    {
        NSMutableString *trackingString = [NSMutableString stringWithString:@"promo"];

        if (appAlert.tag == TruliaPromoAlertTypeUpdate)
        {
            [trackingString appendString:@"|update app"];
        }
        else if (appAlert.tag == TruliaPromoAlertTypeRateAppUniversal)
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
        [[ICMetricsController sharedInstance] trackClick:trackingString];


        if (userConfirmed)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[ICConfiguration sharedInstance] generalItem:@"AppStoreLink"]]];
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

- (void)loadMyAccountWithId:(NSString *)notificationId andType:(NSInteger)notificationType; {
    [[ICSyncController sharedInstance] forceSyncForSyncServiceClass:[ICSyncServiceNotification class]];
    
    ICMyAccountViewControllerPhone *myAccountViewController = [[ICMyAccountViewControllerPhone alloc] initWithNibName:@"ICMyAccountViewControllerPhone" bundle:[NSBundle coreResourcesBundle]];
    
    UINavigationController *navController = (UINavigationController *)deckController.centerController;
    UIViewController *topViewController = [navController topViewController];
    
    if(![topViewController isKindOfClass:[ICMyAccountViewControllerPhone class]]){
        
         [navController setViewControllers:[NSArray arrayWithObject:myAccountViewController] animated:NO];
    }
    
}


#pragma mark-
#pragma mark Deep Linking

-(void)routeInput:(ICRouterInput *)route
{
 
    UINavigationController *centerNavController = nil;
    
    if(deckController)
        centerNavController = (UINavigationController*)deckController.centerController;
    
    [[ICPreference sharedInstance] setAppForKey:@"TmaPrefetch" withAttribute:@"NO"];

    if (route.action == ROUTINGACTION_PROPERTY)
    {

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            ICListingParameters *searchParams = [ICListingParameters new];

            [searchParams populateSearchWithPropertyListing:route.parsedParam];

            [[ICListingSearchController sharedInstance] searchWithParameters:searchParams];

            [[IRMainViewControllerPad sharedInstance] navigateDirectlyToPdp:route.parsedParam];
        }
        else
        {
            //[self.navController popToRootViewControllerAnimated:NO];

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

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            if (route.parsedParam)
                [[ICListingSearchController sharedInstance] searchWithParameters:route.parsedParam];
        }
        else
        {
            if (centerNavController)
                [centerNavController popToRootViewControllerAnimated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC), dispatch_get_current_queue(), ^
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
}


- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation 
{

    if ([super application:application handleOpenURL:url])
        return YES;

    return [FBSession.activeSession handleOpenURL:url];

}

@end
