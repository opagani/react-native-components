//
//  IAListingSearchViewController_iPhone.m
//  Trulia
//
//  Created by Daniel Lowrie on 1/24/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import "IAListingSearchViewController_iPhone_Old.h"
#import "ICListingSearchController.h"
#import "ICListingParameters.h"
#import "ICConfiguration.h"
#import "ICListingAnnotation.h"
#import "ICListing.h"
#import "ICManagedSearch.h"
#import "IAListingRefineViewController_iPhone.h"
#import "ICListingAnnotationView.h"
#import "IAListingTableViewCell_iPhone.h"
#import "IAMyAccountViewController_iPhone.h"
#import "IC+UIColor.h"
#import "UIViewController+TruliaCustomBackButtons.h"
#import "UINavigationBar+TruliaNavBackground.h"
#import "ICPreference.h"
#import "IALoginViewController_iPhone.h"
#import "ICManagedMembership.h"
#import "ICManagedCategory.h"
#import "ICManagedNotification.h"
#import "IATMAdViewController_iPhone.h"
#import "ICState.h"
#import "IAListTMAdTableViewCell_iPhone.h"
#import "ICNavigationController.h"


static const CGFloat GR_MAP_VIEW_BUTTON_WIDTH = 60.0f;
static const CGFloat GR_MAP_VIEW_BUTTON_HEIGHT = 31.0f;
static const CGFloat GR_MAP_VIEW_BUTTON_GUTTER_SIDE = 45.0f;
static const CGFloat GR_MAP_VIEW_BUTTON_GUTTER_BOTTOM = 10.0f;

static NSString *TRULIA_GLASS_OVERLAY_ANIMATION_NAME = @"TRULIA_NOTIFICATION_VIEW_ANIMATION_NAME";
static const NSTimeInterval TRULIA_GLASS_OVERLAY_ANIMATION_DURATION = 0.3f;

static NSString *CellIdentifierProperty = @"IAListingSearchViewController_iPhoneCell";
static NSString *CellIdentifierLoading = @"IALoading_iPhoneCell";
static NSString *CellIdentifierTMA = @"IAListTMAdTableViewCell_iPhoneCell";

#define ROW_HEIGHT 110
#define APP_PREFERENCE_MAP_TYPE_KEY @"APP_PREFERENCE_MAP_TYPE_HOME"

@interface IAListingSearchViewController_iPhone_Old (Gallery)
- (void)deviceOrientationChanged:(NSNotification *)notification;
- (void)showGalleryView:(id)sender;
- (void)hideGalleryView:(id)sender;
- (NSInteger)numberOfListingsForIndexType:(NSString *)indexType;
- (NSInteger)pagesize;
- (NSInteger)totalListingsForIndexType:(NSString *)indexType;
- (NSInteger)resultsCount:(NSString *)indexType;
- (NSString *)currentIndexType;
@end

@implementation IAListingSearchViewController_iPhone_Old

@synthesize btnRefine = _btnRefine;
@synthesize btnFlexPosition = _btnFlexPosition;
@synthesize btnMapListToggle = _btnMapListToggle;
@synthesize listingDetailViewController = _listingDetailViewController;
@synthesize listingCalloutView = _listingCalloutView;
@synthesize oldMapRegion = _oldMapRegion;
@synthesize btnSaveUnsaveToggle = _btnSaveUnsaveToggle;
@synthesize toolbarSourceItems = _toolbarSourceItems;
@synthesize galleryViewController = _galleryViewController;
@synthesize showingGalleryView = _showingGalleryView;
@synthesize animatedView = _animatedView;
@synthesize mapTypeToggleButton = _mapTypeToggleButton;
@synthesize isFrozen;
@synthesize notificationBadge = _notificationBadge;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize mapTmaAdController,listTmaAdController,isTMAListViewReady;
@synthesize isFilterViewVisible;

#pragma mark -
#pragma mark Utility methods

- (void)addNewAnnotations:(BOOL)regionWasUpdated;{
    
    [super addNewAnnotations:regionWasUpdated];
    
    if(self.mapTmaAdController){
        [mapTmaAdController hideAdIfRequired:self.zipcodeList];
    }
}

-(void)clearLoading{
    
    [self.activityIndicatorView stopAnimating];
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
}

-(void)clearListings{
    
    [super clearListings];
    
    
}

-(void)reloadMap{
    
    [super reloadMap];
    
    NSDictionary *tmaAttributes = [[ICState sharedInstance] attributesNamed:@"TmaAttributes"];
    NSString *prefetchStatus = [tmaAttributes objectForKey:@"prefetch"];
    
    if(tmaAttributes){
        
        if([[ICListingSearchController sharedInstance].currentParameters.indexType containsObject:@"for sale"] && [prefetchStatus boolValue] && currentMode == ICListingSearchViewController_iPhoneViewModeMap){
            
            
            if([[[ICPreference sharedInstance] getAppForKey:@"TmaPrefetch"] isEqualToString:@"YES"] || ![[ICPreference sharedInstance] getAppForKey:@"TmaPrefetch"]){
                
                if(!self.mapTmaAdController){
                    self.mapTmaAdController = [[IATMAdViewController_iPhone alloc] init];
                    self.mapTmaAdController.navController = super.navigationController;
                    self.mapTmaAdController.isListView = NO;

                }
                
                self.mapTmaAdController.canShowNewAd = YES;
                
                ICListing *currListing = [self getPopularZipForTmaPrefetch];
                
                if(currListing)
                    [self.mapTmaAdController toggleAdForListing:currListing];
                
            }
            
            
        }else 
        {
            [[ICPreference sharedInstance] setAppForKey:@"TmaPrefetch" withAttribute:@"NO"];   
        }
        
    }else {
        
        if([[ICListingSearchController sharedInstance].currentParameters.indexType containsObject:@"for sale"] && currentMode == ICListingSearchViewController_iPhoneViewModeMap){
            
            
            if([[[ICPreference sharedInstance] getAppForKey:@"TmaPrefetch"] isEqualToString:@"YES"] || ![[ICPreference sharedInstance] getAppForKey:@"TmaPrefetch"]){
                
                if(!self.mapTmaAdController){
                    self.mapTmaAdController = [[IATMAdViewController_iPhone alloc] init];
                    self.mapTmaAdController.navController = super.navigationController;
                    self.mapTmaAdController.isListView = NO;

                }
                
                self.mapTmaAdController.canShowNewAd = YES;
                
                ICListing *currListing = [self getPopularZipForTmaPrefetch];
                
                if(currListing)
                    [self.mapTmaAdController toggleAdForListing:currListing];
            }
            
            
        }else 
        {
            [[ICPreference sharedInstance] setAppForKey:@"TmaPrefetch" withAttribute:@"NO"];   
        }
        
    }   
    
    
    if(currentMode == ICListingSearchViewController_iPhoneViewModeList){
     
        if(!self.listTmaAdController){
            self.listTmaAdController = [[IATMAdViewController_iPhone alloc] init];
            self.listTmaAdController.navController = super.navigationController;
            self.listTmaAdController.isListView = YES;
        }
        
        self.listTmaAdController.canShowNewAd = YES;
        self.isTMAListViewReady = NO;
        
        if([[ICListingSearchController sharedInstance].currentParameters.indexType containsObject:@"for sale"]){
            
            NSString *indexType = @"for sale";
            
            self.listTmaAdController.currentListing = [[ICListingSearchController sharedInstance] getListingAtIndex:0 withIndexType:indexType callPaging:NO];
            self.isTMAListViewReady = NO;
            [self.listTmaAdController getNewAd];

        }
        
    }

    [self clearLoading];

}

-(void)animateTableViewWithTmaPresent:(BOOL)hasTma{
    
    if(hasTma){
        
        CGRect frame = tableViewList.frame;
        
        frame.origin.y = listTmaAdController.view.frame.size.height - 2;
        
        if([UIView respondsToSelector:@selector(transitionWithView:duration:options:animations:completion:)]){
            
            [UIView transitionWithView:tableViewList duration:0.75f options:UIViewAnimationCurveEaseIn animations:^{  tableViewList.frame = frame; } completion:nil];
            
        }else{
            
            [UIView beginAnimations:@"TableListViewAnimation" context:NULL];
            tableViewList.frame = frame;
            [UIView setAnimationDuration:0.75f];
            [UIView commitAnimations];
        }
        
    }else {
        
        CGRect frame = tableViewList.frame;
        
        frame.origin.y = 0;
        
        tableViewList.frame = frame;
        
        /*if([UIView respondsToSelector:@selector(transitionWithView:duration:options:animations:completion:)]){
         
         [UIView transitionWithView:tableViewList duration:0.75f options:UIViewAnimationCurveEaseIn animations:^{  tableViewList.frame = frame; } completion:nil];
         
         }else{
         
         [UIView beginAnimations:@"TableListViewAnimation" context:NULL];
         tableViewList.frame = frame;
         [UIView setAnimationDuration:0.75f];
         [UIView commitAnimations];
         }*/
        
    }
    
}

-(ICListing *)getPopularZipForTmaPrefetch{
    
    NSMutableDictionary *zipCount = [[NSMutableDictionary alloc] init];
    NSString *indexType = IC_INDEXTYPE_FORSALE;
    ICListing *zipListing = nil;
    
    
    
    for(int i = 0 ; i < [(NSNumber *)[[ICConfiguration sharedInstance] generalItem:@"ListingSearchPageSize"] intValue]; i++){
        
        ICListing *currListing = [[ICListingSearchController sharedInstance] getListingAtIndex:i withIndexType:indexType callPaging:NO];
        
        NSString *currZip = [currListing getListingData:ListingDataZip];
        
        if(![zipCount objectForKey:currZip]){
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            if(currListing){
                [dict setObject:currListing forKey:@"listing"];
            }
            
            [dict setObject:[NSNumber numberWithInt:1] forKey:@"count"];
            
            if(currZip != nil)
                [zipCount setObject:dict forKey:currZip];
            
            
        }else {
            
            NSInteger count = [[[zipCount objectForKey:currZip] objectForKey:@"count"] intValue];
            count = count + 1;
            [[zipCount objectForKey:currZip] setObject:[NSNumber numberWithInt:count] forKey:@"count"];
            
            if(![[zipCount objectForKey:currZip] objectForKey:@"listing"]){
                
                if(currListing)
                    [[zipCount objectForKey:currZip] setObject:currListing forKey:@"listing"];
            }
            
        }
        
    }
    
    NSInteger maxCount = 0;
    NSArray *allKeys = [zipCount allKeys];
    
    for(int j = 0 ; j < [allKeys count]; j++){
        
        if([[[zipCount objectForKey:[allKeys objectAtIndex:j]] objectForKey:@"count"] intValue] > maxCount){
            maxCount = [[[zipCount objectForKey:[allKeys objectAtIndex:j]] objectForKey:@"count"] intValue];
            zipListing = [[zipCount objectForKey:[allKeys objectAtIndex:j]] objectForKey:@"listing"]; 
        }
        
    }
    
    
    return zipListing;
    
}


- (void)trackPageView; {
    // format: page:data:behavior
    NSMutableString *tmpPage = [NSMutableString string];
    if(currentMode == ICListingSearchViewController_iPhoneViewModeMap)
        [tmpPage appendString:[ICMetricsController PAGE_SRP_MAP]];
    else if(currentMode == ICListingSearchViewController_iPhoneViewModeList)
        [tmpPage appendString:[ICMetricsController PAGE_SRP_LIST]];
    
    ICListingParameters *listingParams = [ICListingSearchController sharedInstance].currentParameters;
    if([listingParams.indexType containsObject:IC_INDEXTYPE_FORSALE])
        [tmpPage appendFormat:@":%@",[ICMetricsController VAR_FOR_SALE]];
    else if([listingParams.indexType containsObject:IC_INDEXTYPE_FORRENT])
        [tmpPage appendFormat:@":%@",[ICMetricsController VAR_FOR_RENT]];
    else if([listingParams.indexType containsObject:IC_INDEXTYPE_SOLD])
        [tmpPage appendFormat:@":%@",[ICMetricsController VAR_SOLD]];
    
    if([listingParams.srch isEqualToString:@"Nearby"])
        [tmpPage appendFormat:@":%@",[ICMetricsController VAR_NEARBY]];
    else if([listingParams.srch isEqualToString:[[ICConfiguration sharedInstance] generalItem:@"MapAreaText"]])
        [tmpPage appendFormat:@":%@",[ICMetricsController VAR_BBOX]];
    else
        [tmpPage appendFormat:@":%@",[ICMetricsController VAR_CSZ]];
    
    [[ICMetricsController sharedInstance] trackPageView:(NSString *)tmpPage];
}

- (void)setMapType:(MKMapType)theType; {
    
    NSString *newButtonText = (theType == MKMapTypeStandard) ? NSLocalizedString(@"SatelliteView", nil) : NSLocalizedString(@"RoadView", nil);
    [self.mapTypeToggleButton setTitle:newButtonText forState:UIControlStateNormal];
    
	mapViewMap.mapType = theType;
    
    [[ICPreference sharedInstance] setAppForKey:APP_PREFERENCE_MAP_TYPE_KEY withAttribute:[NSNumber numberWithInt:theType] andSaveToDisk:YES];
    
}

- (void)mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated; {
    
    
   // [self setHeaderTitle:[ICListingSearchController sharedInstance].currentParameters.srch andSubtitle:YES];
    
    if (isFrozen) {

        return;
    }
    
    
    [super mapView:aMapView regionDidChangeAnimated:animated];
    
    

}

- (void)refreshData:(NSNotification *)notification; {
   
    ICManagedSearch *theSearch = [[ICListingSearchController sharedInstance] currentSearch];
    
    if ([theSearch activeMembershipWithCategoryName:MANAGED_CATEGORY_FAVORITES] != nil)
        [_btnSaveUnsaveToggle setImage:[UIImage imageNamed:@"ActionUnStar.png"] forState:UIControlStateNormal];
    else       
        [_btnSaveUnsaveToggle setImage:[UIImage imageNamed:@"ActionStar.png"] forState:UIControlStateNormal];
    
    [self clearLoading];
    if([[ICListingSearchController sharedInstance].currentParameters.srch isEqualToString:@"Nearby"] || [theSearch.locationString isEqualToString:@"Near (null), (null)"])
        [self setHeaderTitle:[ICListingSearchController sharedInstance].currentParameters.srch andSubtitle:YES];
    else
        [self setHeaderTitle:theSearch.locationString andSubtitle:YES];
    
    [self reloadMap];

}


- (NSString *)getHeaderTitle; {
    UIView* headerTitleSubtitleView = self.navigationItem.titleView;
    UILabel* titleView = [headerTitleSubtitleView.subviews objectAtIndex:0];
    return titleView.text;
}

- (void)startLoading {
    
    UIActivityIndicatorView *theActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    CGRect aiFrame = theActivityIndicatorView.frame;
    aiFrame.origin = CGPointMake((self.view.bounds.size.width - aiFrame.size.width) / 2, (self.view.bounds.size.height - aiFrame.size.height) / 2);
    
    [self.view addSubview:theActivityIndicatorView];
    [theActivityIndicatorView startAnimating];
    
}


#pragma mark -
#pragma mark TMA Notification Handlers


- (void)receivedTMAdDidShowAdNotification:(NSNotification *) notification; {
    
    if(listTmaAdController.isAdVisible){
       // [self animateTableViewWithTmaPresent:YES];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ICTMAdDidShowAd" object:nil];
}



- (void)receivedTMAdShowAdNotification:(NSNotification *) notification; {
    
    
    NSDictionary *tmaAttributes = [[ICState sharedInstance] attributesNamed:@"TmaAttributes"];
    NSString *prefetchStatus = [tmaAttributes objectForKey:@"prefetch"];
    
    
    [[ICPreference sharedInstance] setAppForKey:@"TmaPrefetch" withAttribute:@"YES"];
    
    if(self.mapTmaAdController){
        [mapTmaAdController hideAdWithAnimation:NO];  
        mapTmaAdController.canShowNewAd = YES;
    }
    
    if(self.listTmaAdController){
        
        [listTmaAdController hideAdWithAnimation:NO];  
        listTmaAdController.canShowNewAd = YES;
        
       // [self animateTableViewWithTmaPresent:NO];
        
        
    }
    
    if(tmaAttributes && prefetchStatus){
        
        
        if([[ICListingSearchController sharedInstance].currentParameters.indexType containsObject:@"for sale"] && [prefetchStatus boolValue]){
            
            if([[[ICPreference sharedInstance] getAppForKey:@"TmaPrefetch"] isEqualToString:@"YES"] || ![[ICPreference sharedInstance] getAppForKey:@"TmaPrefetch"]){
                
                if(currentMode == ICListingSearchViewController_iPhoneViewModeMap){
                    
                    if(!self.mapTmaAdController){
                        self.mapTmaAdController = [[IATMAdViewController_iPhone alloc] init];
                        self.mapTmaAdController.navController = super.navigationController;
                        self.mapTmaAdController.isListView = NO;

                    }
                    
                    self.mapTmaAdController.canShowNewAd = YES;
                    
                    ICListing *currListing = [self getPopularZipForTmaPrefetch];
                    
                    if(currListing)
                        [self.mapTmaAdController toggleAdForListing:currListing];
                    
                }else if(currentMode == ICListingSearchViewController_iPhoneViewModeList){
                    
                    if(!self.listTmaAdController){
                        self.listTmaAdController = [[IATMAdViewController_iPhone alloc] init];
                        self.listTmaAdController.navController = super.navigationController;
                        self.listTmaAdController.isListView = YES;
                    }
                    
                    self.listTmaAdController.canShowNewAd = YES;
                    self.isTMAListViewReady = NO;
                    
                    if([[ICListingSearchController sharedInstance].currentParameters.indexType containsObject:@"for sale"]){
                        
                        NSString *indexType = @"for sale";
                        
                        self.listTmaAdController.currentListing = [[ICListingSearchController sharedInstance] getListingAtIndex:0 withIndexType:indexType callPaging:NO];
                        self.isTMAListViewReady = NO;
                        [self.listTmaAdController getNewAd];
                        
                    }                }
                
                
            }
            
            
        }else 
        {
            [[ICPreference sharedInstance] setAppForKey:@"TmaPrefetch" withAttribute:@"NO"];   
        }
        
    }else{
        
        if([[ICListingSearchController sharedInstance].currentParameters.indexType containsObject:@"for sale"]){
            
            if([[[ICPreference sharedInstance] getAppForKey:@"TmaPrefetch"] isEqualToString:@"YES"] || ![[ICPreference sharedInstance] getAppForKey:@"TmaPrefetch"]){
                
                if(currentMode == ICListingSearchViewController_iPhoneViewModeMap){
                    
                    if(!self.mapTmaAdController){
                        self.mapTmaAdController = [[IATMAdViewController_iPhone alloc] init];
                        self.mapTmaAdController.navController = super.navigationController;
                        self.mapTmaAdController.isListView = NO;
                    }
                    
                    self.mapTmaAdController.canShowNewAd = YES;
                    
                    ICListing *currListing = [self getPopularZipForTmaPrefetch];
                    
                    if(currListing)
                        [self.mapTmaAdController toggleAdForListing:currListing];
                    
                }else if(currentMode == ICListingSearchViewController_iPhoneViewModeList){
                    
                    if(!self.listTmaAdController){
                        self.listTmaAdController = [[IATMAdViewController_iPhone alloc] init];
                        self.listTmaAdController.navController = super.navigationController;
                        self.listTmaAdController.isListView = YES;
                    }
                    
                    self.listTmaAdController.canShowNewAd = YES;
                    self.isTMAListViewReady = NO;
                    
                    
                    if([[ICListingSearchController sharedInstance].currentParameters.indexType containsObject:@"for sale"]){
                        
                        NSString *indexType = @"for sale";
                        
                        self.listTmaAdController.currentListing = [[ICListingSearchController sharedInstance] getListingAtIndex:0 withIndexType:indexType callPaging:NO];
                        self.isTMAListViewReady = NO;
                        [self.listTmaAdController getNewAd];
                        
                    }
                }
                
                
            }
            
            
        }else 
        {
            [[ICPreference sharedInstance] setAppForKey:@"TmaPrefetch" withAttribute:@"NO"];   
        } 
    }
    
    
    
}


- (void)receivedTMAdHideAdNotification:(NSNotification *) notification; {
    
    [[ICPreference sharedInstance] setAppForKey:@"TmaPrefetch" withAttribute:@"YES"];
    
    if(self.mapTmaAdController){
        [mapTmaAdController hideAdWithAnimation:NO];  
        mapTmaAdController.canShowNewAd = YES;
    }
    
    if(self.listTmaAdController){
        
        [listTmaAdController hideAdWithAnimation:NO];
        listTmaAdController.canShowNewAd = YES;
       // [self animateTableViewWithTmaPresent:NO];
    }
    
    
}


- (void)receivedTMAdSuccessNotification:(NSNotification *) notification; {
    
    
    if(currentMode == ICListingSearchViewController_iPhoneViewModeMap)
    {
        if(self.mapTmaAdController){
            [mapTmaAdController showAdFromView:self.view withAnimation:YES withDelay:YES canMinimize:YES];  
        }
        
    }else if(currentMode == ICListingSearchViewController_iPhoneViewModeList){
        
        if(self.listTmaAdController){
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedTMAdDidShowAdNotification:) name:@"ICTMAdDidShowAd" object:nil];
            self.isTMAListViewReady = YES;
            self.listTmaAdController.canMinimizeAd = NO;
            [tableViewList reloadData];
            [self clearLoading];
           // [listTmaAdController showAdFromView:self.view withAnimation:YES withDelay:NO canMinimize:NO]; 
        }
    }
    
 
    [[ICPreference sharedInstance] setAppForKey:@"TmaPrefetch" withAttribute:@"NO"]; 
    
}

- (void)receivedTMAdLeadEmailSentNotification:(NSNotification *) notification; {
    
    [self showMessage:ICLocalizedString(@"SendToAFriendSuccessMessage") withSpinner:NO fromView:self.navigationController.toolbar automaticallyDismissed:YES animated:YES];    
    
    
}

#pragma mark -
#pragma mark User actions

- (void)actionRedoSearch:(id)sender; {
    
    [[ICListingSearchController sharedInstance] updateToRegion:mapViewMap.region];
    //[self showRefreshButton:NO animated:NO];
    
}

- (void)actionMapTypeToggle:(id)sender; {
    
    @try {
        [self setMapType:(mapViewMap.mapType == MKMapTypeStandard ? MKMapTypeHybrid : MKMapTypeStandard)];
    }
    @catch (NSException *exception) {
        NSLog(@"setMapType exception: %@", exception);
    }
    
	
}

- (IBAction)actionShowMyAccount:(id)sender {
    
#ifndef RUN_STRESS_TEST
    //if we the previous controller on the stack is my account, just navigate to that...
    if ([self.navigationController.viewControllers count] > 1) {
        UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] - 2)];
        if ([viewController isKindOfClass:[IAMyAccountViewController_iPhone class]]) {
            [self.navigationController popViewControllerAnimated:YES];
            
            return;
        }
    }
    
    
    IAMyAccountViewController_iPhone *myAccountViewController = [[IAMyAccountViewController_iPhone alloc] initWithNibName:@"IAMyAccountViewController_iPhone" bundle:nil];
    
    ICNavigationController *navController = [[ICNavigationController alloc] initWithRootViewController:myAccountViewController];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancelModal:)];
    [myAccountViewController.navigationItem setLeftBarButtonItem:cancelButton];
    
    [self presentModalViewController:navController animated:YES];
    
                                                
#endif
    
}

- (IBAction)actionCancelModal:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (IBAction)actionToggleSaveUnsave:(id)sender; {
    
    if ([[ICAccountController sharedInstance] shouldPromptLogin] && ![self isSavedSearch]) {
        
        IALoginViewController_iPhone *loginController = [[IALoginViewController_iPhone alloc] initWithDelegate:self withPostLoginAction:PostLoginActionTypeFavorite];
        [self.navigationController presentModalViewController:loginController animated:YES];
        
    }
    else {
        
        ICManagedSearch *theSearch = [[ICListingSearchController sharedInstance] currentSearch];
        
        if ([theSearch activeMembershipWithCategoryName:MANAGED_CATEGORY_FAVORITES] != nil) {
            [[ICMetricsController sharedInstance] trackToolbarClick:[ICMetricsController VAR_ACTION_UNSAVE]];
            
            [theSearch setIsFollowing:NO];
            [_btnSaveUnsaveToggle setImage:[UIImage imageNamed:@"ActionStar.png"] forState:UIControlStateNormal];
            
            
            //MOB-5381 tracking for save search success
            NSString *modeString = (currentMode == ICListingSearchViewController_iPhoneViewModeMap) ? @"map" : @"list";
            [[ICMetricsController sharedInstance] trackClick:[NSString stringWithFormat:@"%@:savesearch:success", modeString]];
            
            
            if ([[ICPreference sharedInstance] getSesForKey:@"APP_KEY_FOLLOW_SEARCH_MESSAGE_SHOWN"] == nil && [[ICAccountController sharedInstance] isLoggedIn]) {
                
                [self showMessage:ICLocalizedString(@"Ok. You'll no longer receive emails for this search.") withSpinner:NO fromView:self.navigationController.toolbar automaticallyDismissed:YES animated:YES];
                
                [[ICPreference sharedInstance] setSesForKey:@"APP_KEY_FOLLOW_SEARCH_MESSAGE_SHOWN" withAttribute:[NSNumber numberWithBool:YES]];
            }
            
        }
        else {        
            [[ICMetricsController sharedInstance] trackToolbarClick:[ICMetricsController VAR_ACTION_SAVE]];
            [[ICMetricsController sharedInstance] trackEvent:@"ListingSearchView" moduleName:[ICMetricsController VAR_TOOLBAR] metaData:theSearch.indexType evenType:SEARCH_SAVED];
            
            [theSearch setIsFollowing:YES];
            [_btnSaveUnsaveToggle setImage:[UIImage imageNamed:@"ActionUnStar.png"] forState:UIControlStateNormal];
            
            [self animateStarToMyAccountButton];
            
            if ([[ICPreference sharedInstance] getSesForKey:@"APP_KEY_UNFOLLOW_SEARCH_MESSAGE_SHOWN"] == nil && [[ICAccountController sharedInstance] isLoggedIn]) {
                
                [self showMessage:ICLocalizedString(@"Awesome! We'll email you when new listings match this search.") withSpinner:NO fromView:self.navigationController.toolbar automaticallyDismissed:YES animated:YES];
                
                [[ICPreference sharedInstance] setSesForKey:@"APP_KEY_UNFOLLOW_SEARCH_MESSAGE_SHOWN" withAttribute:[NSNumber numberWithBool:YES]];
            }
        }
        
    }
    
}

-(void)applytoCurrentMode:()

- (IBAction)actionToggleMapListView:(id)sender; {
    [super actionToggleMapListView:sender];
    
    if(currentMode == ICListingSearchViewController_iPhoneViewModeMap)
    {
        [self.mapTmaAdController.view setHidden:YES];
        self.isTMAListViewReady = NO;
        [self clearLoading];
        [tableViewList reloadData];
        
        if(self.mapTmaAdController){
            [mapTmaAdController hideAdWithAnimation:NO];  
            mapTmaAdController.canShowNewAd = YES;
        }
        
        [self.listTmaAdController.view setHidden:NO];
        
        
        if(self.listTmaAdController){
            
            NSString *indexType = [[ICListingSearchController sharedInstance].currentParameters.indexType objectAtIndex:0];
            
            if([indexType isEqualToString:IC_INDEXTYPE_FORSALE]){
                self.listTmaAdController.currentListing = [[ICListingSearchController sharedInstance] getListingAtIndex:0 withIndexType:indexType callPaging:NO];
                self.isTMAListViewReady = NO;
                [self.listTmaAdController getNewAd];
            }
            
        }
        
    }else if(currentMode == ICListingSearchViewController_iPhoneViewModeList){
        [self.mapTmaAdController.view setHidden:NO];
        [self.listTmaAdController.view setHidden:YES];
        
        if(listTmaAdController && listTmaAdController.isAdVisible){
            
            [listTmaAdController hideAdWithAnimation:NO];
            
        }
            
        
        //[self animateTableViewWithTmaPresent:NO];
    }

    
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
						   forView:[self view]
							 cache:YES];
    
    if(currentMode == ICListingSearchViewController_iPhoneViewModeList) {
        [self.mapTypeToggleButton setHidden:NO];
        [_btnFlexPosition setImage:[UIImage imageNamed:@"ActionNearby.png"] forState:UIControlStateNormal];
        [_btnMapListToggle setImage:[UIImage imageNamed:@"ActionList.png"] forState:UIControlStateNormal];
        currentMode = ICListingSearchViewController_iPhoneViewModeMap;
        [[ICPreference sharedInstance] setAppForKey:@"APP_PREFERENCE_SRP_TYPE" withAttribute:[NSNumber numberWithInt:ICListingSearchViewController_iPhoneViewModeMap]];
        
        if (sender) {
            [[ICMetricsController sharedInstance] trackToolbarClick:[ICMetricsController VAR_ACTION_MAP]];
        }
        
        
    } else {
        [self.mapTypeToggleButton setHidden:YES];
        [_btnFlexPosition setImage:[UIImage imageNamed:@"ActionSort.png"] forState:UIControlStateNormal];
        [_btnMapListToggle setImage:[UIImage imageNamed:@"ActionMap.png"] forState:UIControlStateNormal];
        currentMode = ICListingSearchViewController_iPhoneViewModeList;
        [[ICPreference sharedInstance] setAppForKey:@"APP_PREFERENCE_SRP_TYPE" withAttribute:[NSNumber numberWithInt:ICListingSearchViewController_iPhoneViewModeList]];
        NSString *indexType = [self currentIndexType];
        int currentKey = [[ICListingSearchController sharedInstance] getSmallestIndexWithIndexType:indexType]; 
        
        if ([tableViewList numberOfRowsInSection:0] > 0) {
            [tableViewList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentKey inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
        
        if (sender) {
            [[ICMetricsController sharedInstance] trackToolbarClick:[ICMetricsController VAR_ACTION_LIST]];
        }
        
    }
    
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
	[UIView commitAnimations]; 
    [self setSubtitle];
    [self trackPageView];
    
}

- (IBAction)actionShowRefine:(id)sender; {
    
    
    [[ICMetricsController sharedInstance] trackToolbarClick:[ICMetricsController VAR_ACTION_REFINE]];
    
    IAListingRefineViewController_iPhone *viewController = [[IAListingRefineViewController_iPhone alloc] initWithNibName:@"IAListingRefineViewController_iPhone" bundle:nil];
    [viewController setDelegate:self];
    self.isFilterViewVisible = YES;
    [self presentModalViewController:viewController animated:YES];
}

- (IBAction)actionFlexPosition:(id)sender; {
    return (self.currentMode == ICListingSearchViewController_iPhoneViewModeList) ? [self actionShowSort:sender] : [self actionSearchNearby:sender];
}

- (IBAction)actionShowSort:(id)sender; {
    [[ICMetricsController sharedInstance] trackToolbarClick:[ICMetricsController VAR_ACTION_SORT]];
    
    IAFilterViewController_iPhone *filterViewController = [[IAFilterViewController_iPhone alloc] initWithNibName:@"IAFilterViewController_iPhone" bundle:[NSBundle mainBundle]];

    filterViewController.activeFilterGroup = CONTROL_SORT;
    [filterViewController setDelegate:self];
    
    ICNavigationController *navController = [[ICNavigationController alloc] initWithRootViewController:filterViewController];
    
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)actionSearchNearby:(id)sender; {
    [[ICMetricsController sharedInstance] trackToolbarClick:[ICMetricsController VAR_ACTION_NEARBY]];
    [self updateToCurrentLocation];       
}

- (IBAction)actionChooseLayer:(id)sender; {
    UIActionSheet *theActionSheet = [[UIActionSheet alloc] initWithTitle:@"Change your Map View" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Aerial",@"Hybrid",@"Satellite", nil];
    
    [theActionSheet showFromToolbar:self.navigationController.toolbar];
}


#pragma mark -
#pragma mark ICFilterViewController_iPhoneDelegate Function

-(void) filterValueChanged:(BOOL)valueChanged{
    
    [tableViewList reloadData];
    [self clearLoading];
    if ([tableViewList numberOfRowsInSection:0] > 0) {
        [tableViewList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    
}


#pragma mark -
#pragma mark IAListingCalloutView_iPhone methods

- (void)listingCalloutView_iPhone:(IAListingCalloutView_iPhone *)IAListingCalloutView_iPhone tappedWithIndex:(NSInteger)pIndex andIndexType:(NSString *)pIndexType; {
    
    IAListingTabbedViewController_iPhone *listingTabbedViewController = [[IAListingTabbedViewController_iPhone alloc] initWithIndex:pIndex indexType:pIndexType];
    
    isFrozen = YES;
    
    [self.navigationController pushViewController:listingTabbedViewController animated:YES];
    
    
}

#pragma mark -
- (void)updateToRegionWithoutSearching:(MKCoordinateRegion)region{
    self.isRegionSet = YES;
    [mapViewMap setRegion:region];

}
#pragma mark Listing Results Error Handlers

- (void)receivedErrorNotification:(NSNotification *) notification; {
	NSDictionary *data = [notification userInfo];
    
    [self clearLoading];
    
    if ([[notification name] isEqual:@"APIErrorListingZoomedOutTooFar"]) {
        [self showMessage:[data objectForKey:@"message"]  withSpinner:NO fromView:self.navigationController.toolbar automaticallyDismissed:YES animated:YES];   
		[self unsetFlagOnDisplayedListings];
		[self clearListings];
		ICListingParameters *listingParams = [ICListingSearchController sharedInstance].currentParameters;
        [self setHeaderTitle:listingParams.srch andSubtitle:NO];
        [self.headerController setVisibility:NO animated:YES];
	} else if([[notification name] isEqual:@"APIErrorListingMessagingGeneral"]) {
        [self showMessage:[data objectForKey:@"message"]  withSpinner:NO fromView:self.navigationController.toolbar automaticallyDismissed:YES animated:YES];  
        [self unsetFlagOnDisplayedListings];
		[self clearListings];
        [self.headerController setVisibility:NO animated:YES];
        
	}
    else if([[notification name] isEqual:@"APIErrorListingNoResults"]) {
        
        [self showMessage:[data objectForKey:@"message"]  withSpinner:NO fromView:self.navigationController.toolbar automaticallyDismissed:YES animated:YES];  
        [self unsetFlagOnDisplayedListings];
        [self clearListings];
        ICListingParameters *listingParams = [ICListingSearchController sharedInstance].currentParameters;
        [self setHeaderTitle:listingParams.srch andSubtitle:NO];
        [self.headerController setVisibility:NO animated:YES];
        
        CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        bounceAnimation.values = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:1.1],
                                  [NSNumber numberWithFloat:1.4],
                                  [NSNumber numberWithFloat:1.1],
                                  [NSNumber numberWithFloat:1.4],
                                  [NSNumber numberWithFloat:1.1],
                                  [NSNumber numberWithFloat:1.4],
                                  [NSNumber numberWithFloat:1.1],
                                  [NSNumber numberWithFloat:1.4],
                                  [NSNumber numberWithFloat:1.1],
                                  [NSNumber numberWithFloat:1.4],
                                  [NSNumber numberWithFloat:1.1],
                                  [NSNumber numberWithFloat:1.4],
                                  [NSNumber numberWithFloat:1.0], nil];
        bounceAnimation.duration = 6.0;
        bounceAnimation.removedOnCompletion = YES;
        [self.btnRefine.layer addAnimation:bounceAnimation forKey:@"throb"];
        
        // we still want to update to searched location and then show the results
        [self updateToRegionWithoutSearching:[ICListingSearchController sharedInstance].currentParameters.region];

        
    }
    
}

- (void)receivedNearbySearchNotification:(NSNotification *) notification {
    
    [self actionSearchNearby:nil];
    
}


#pragma mark -
#pragma mark MKMapViewDelegate methods


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    if (![view isKindOfClass:[ICListingAnnotationView class]])
        return;
    
    [super mapView:mapView didSelectAnnotationView:view];
    
    ICListingAnnotation *selectedAnnotation = (ICListingAnnotation*)((ICListingAnnotationView *)view.annotation);
    ICListing *selectedListing = selectedAnnotation.listing;
    
    if(self.mapTmaAdController && [[selectedListing getListingData:ListingDataIndexType] isEqualToString:@"for sale"] && [[[ICPreference sharedInstance] getAppForKey:@"TmaPrefetch"] isEqualToString:@"NO"]){
        
        [mapTmaAdController toggleAdForListing:selectedListing];
    }
    

    NSUInteger theIndex = selectedAnnotation.index;
    NSString *indexType = selectedAnnotation.indexType;
    
    
    CGPoint mapPoint = [mapViewMap convertCoordinate:selectedAnnotation.coordinate toPointToView:self.view];
    
    if (self.listingCalloutView == nil) {
        _listingCalloutView = [[IAListingCalloutView_iPhone alloc] initWithFrame:CGRectMake(0,0,300,90)];
        _listingCalloutView.delegate = self;
        self.listingCalloutView.autoresizingMask = UIViewAutoresizingNone;
    }
    
    [_listingCalloutView setIndex:theIndex withIndexType:indexType];
    
    // update the height again because it is variable
    _listingCalloutView.frame = CGRectMake(_listingCalloutView.frame.origin.x, _listingCalloutView.frame.origin.y,
                                            _listingCalloutView.frame.size.width, [_listingCalloutView getCurrentHeight]);

    ICListingAnnotation *containerAnnotation = (ICListingAnnotation *)selectedAnnotation;
    ICManagedListing *managedListing = nil;    
    ICListing *theListing = [[ICListingSearchController sharedInstance] getListingAtIndex:containerAnnotation.index withIndexType:containerAnnotation.indexType callPaging:NO];
    if ([theListing.data isKindOfClass:[ICManagedListing class]]) {
        managedListing = (ICManagedListing *)theListing.data;
    }
    else {
        managedListing = [ICManagedListing managedListingWithListingData:(NSDictionary *)theListing.data shouldCreateIfDoesNotExist:YES];
    }    
    [managedListing setIsSeen:YES];
    
    
    CGRect frame = _listingCalloutView.frame;
    
    frame.origin = CGPointMake(round(mapPoint.x - (frame.size.width / 2)), round(mapPoint.y) - frame.size.height - 30);
    
    //Adjust the Y if we are off the top of the screen
    
    if (CGRectGetMinY(frame) < CGRectGetMinY(self.view.bounds) + 54) {
        frame.origin = CGPointMake(round(mapPoint.x) - round(frame.size.width / 2), /*(CGRectGetMinY(self.view.bounds) + 54 - round(mapPoint.y)) +*/ round(mapPoint.y) + 20);
    }
    
    //Adjust the X if we are off the left or the right of the screen
    if (CGRectGetMaxX(frame) > CGRectGetMaxX(self.view.bounds)) {
        float deltaX = CGRectGetMaxX(frame) - CGRectGetMaxX(self.view.bounds); 
        frame = CGRectOffset(frame, -deltaX, 0.0f);
    }
    else if (CGRectGetMinX(frame) < CGRectGetMinX(self.view.bounds)) {
        float deltaX = CGRectGetMinX(frame) - CGRectGetMinX(self.view.bounds); 
        frame = CGRectOffset(frame, -deltaX + 10, 0.0f);
    }
    
    //bounce the listing display into place
    _listingCalloutView.frame = frame;
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.9],
                              [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.duration = 0.3;
    bounceAnimation.removedOnCompletion = YES;
    [_listingCalloutView.layer addAnimation:bounceAnimation forKey:@"bounce"];
	
    if (![_listingCalloutView isDescendantOfView:self.view]) {
        [[self.view viewWithTag:1] addSubview:_listingCalloutView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
	if ([view isKindOfClass:[ICListingAnnotationView class]]) {
		ICListingAnnotation *la = (ICListingAnnotation*)((ICListingAnnotationView *)view.annotation);
		id<MKAnnotation> selectedAnnotation = [mapViewMap.selectedAnnotations objectAtIndex:0];
		if (![selectedAnnotation isKindOfClass:[ICListingAnnotation class]]) {
			[_listingCalloutView removeFromSuperview];
		}
		else if (la.index == ((ICListingAnnotation *)selectedAnnotation).index) {
			[_listingCalloutView removeFromSuperview];
		}
	}

	isFrozen = NO;
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)pagesize{
    
    NSInteger pageSize = [(NSNumber *)[[ICConfiguration sharedInstance] generalItem:LISTING_SEARCH_PAGE_SIZE] intValue];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs integerForKey:SETTINGS_SEARCH_RESULTS_NUMBER_OF_RESULTS] != 0) {
        pageSize = [prefs integerForKey:SETTINGS_SEARCH_RESULTS_NUMBER_OF_RESULTS];
    }
    
    return pageSize;
}

- (NSInteger)numberOfListingsForIndexType:(NSString *)indexType{
    
    NSInteger listingsFetched = [self totalListingsForIndexType:indexType];
    NSInteger resultsCount = [self resultsCount:indexType];
    int totalResultsCount = [[ICListingSearchController sharedInstance] getListingCountWithIndexType:indexType];
    
    if(listingsFetched < totalResultsCount || listingsFetched == 0){
        resultsCount += 1;
    }
    
    return resultsCount;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    /*NSInteger count = [self numberOfListingsForIndexType:[[[[ICListingSearchController sharedInstance] currentParameters] 
                                                           indexType] objectAtIndex:0]];
    if(self.isTMAListViewReady)
        return count + 1;
    else 
        return count;*/
    
    ICListingParameters *currentParams = [[ICListingSearchController sharedInstance] currentParameters];
    NSArray *indexArray = [currentParams indexType];
    
    if([indexArray count] >= 1)
        return [self numberOfListingsForIndexType:[indexArray objectAtIndex:0]];

    return 0;
}

- (NSInteger)totalListingsForIndexType:(NSString *)indexType{
    
    int currentKey = [[ICListingSearchController sharedInstance] getSmallestIndexWithIndexType:indexType];
    return [self pagesize] + currentKey;
}

- (NSInteger)resultsCount:(NSString *)indexType{
    return [[[[ICListingSearchController sharedInstance] listingResults] objectForKey:indexType] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {

    NSString *indexType = [self currentIndexType];

    NSInteger resultsCount = [self resultsCount:indexType];    
    
    if(self.isTMAListViewReady && indexPath.row == 0){
        
        NSString *CellIdentifier = CellIdentifierTMA;
        IAListTMAdTableViewCell_iPhone *cell = nil;
        if (cell == nil) {
            cell = [[IAListTMAdTableViewCell_iPhone alloc] initWithReuseIdentifier:CellIdentifier];
            self.listTmaAdController.view.frame = cell.frame;
            [cell setDisplayForAd:self.listTmaAdController.view];
        }
        return cell;
    }
    else if(indexPath.row == resultsCount) {
        NSString *CellIdentifier =CellIdentifierLoading;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityView.center = cell.contentView.center;
            [cell.contentView addSubview:activityView];
            [activityView startAnimating];
        }
        return cell;
    }
    else {
        NSString *CellIdentifier = CellIdentifierProperty;
        IAListingTableViewCell_iPhone *cell = (IAListingTableViewCell_iPhone *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];   
        if (cell == nil) {
            cell = [[IAListingTableViewCell_iPhone alloc] initWithReuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryView = nil;
        }
        if([[ICListingSearchController sharedInstance].currentParameters.indexType count] != 0) 
            indexType = [self currentIndexType];
        
      //  if(self.isTMAListViewReady)
         //   [cell setIndex:indexPath.row + 1 withIndexType:indexType];
       // else 
            [cell setIndex:indexPath.row withIndexType:indexType];
        
        return cell; 
    }
}


#pragma mark -
#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0 && self.isTMAListViewReady){
        
        return 75;
    }
    
   return [self calculateHeightForRowAtIndexPath:indexPath];
    
}

- (CGFloat)calculateHeightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat height = 90.0f;
    CGFloat rowHeight = 18.0f;
    
    NSString *indexType = [[[[ICListingSearchController sharedInstance] currentParameters] indexType] objectAtIndex:0];
    ICListing *currListing = [[ICListingSearchController sharedInstance] getListingAtIndex:indexPath.row withIndexType:indexType callPaging:NO];
    
    if(([currListing getListingData:ListingDataEstimatedPrice] && [currListing getListingData:ListingDataPrice])) {
        height += rowHeight;
    }
    
    if ([currListing getListingData:ListingDataOpenHouse]){
        height += rowHeight;
    }
    if([currListing getListingData:ListingDataFloorplanCount]){
        height += rowHeight;
        
    } 
    
    return height;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    NSString *indexType = @"";
    if([[ICListingSearchController sharedInstance].currentParameters.indexType count] != 0) {
        indexType = [self currentIndexType];
    }
    
    IAListingTabbedViewController_iPhone *listingTabbedViewController = [[IAListingTabbedViewController_iPhone alloc] initWithIndex:indexPath.row indexType:indexType];
    [self.navigationController pushViewController:listingTabbedViewController animated:YES];
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ICListing *currentListing = [[ICListingSearchController sharedInstance] getListingAtIndex:indexPath.row withIndexType:indexType callPaging:NO];
    ICManagedListing *managedListing = nil;
    
    if ([currentListing.data isKindOfClass:[ICManagedListing class]]) {
        managedListing = (ICManagedListing *)currentListing.data;
    }
    else {
        managedListing = [ICManagedListing managedListingWithListingData:(NSDictionary *)currentListing.data shouldCreateIfDoesNotExist:YES];
    }    
    if (![managedListing isSeen]) {
        [managedListing setIsSeen:YES];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath; {
    if (tableView == tableViewList && [cell isKindOfClass:[IAListingTableViewCell_iPhone class]]) {
        [(IAListingTableViewCell_iPhone *)cell showImageThumbnailIfExists];
        [(IAListingTableViewCell_iPhone *)cell setupDisplay];
    }
}

#pragma mark -
#pragma mark IAListingRefineViewController_iPhoneDelegate methods

- (void)searchWithParameters:(ICListingParameters *)currentParameters; {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ICListingSearchControllerSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"ICListingSearchControllerSuccess" object:nil];
    
    if ([currentParameters.srch isEqualToString:ICLocalizedString(@"Current Location")]){
            
        [[ICListingSearchController sharedInstance] setCurrentParameters:currentParameters];
        [self updateToCurrentLocation];
    }
    else {
        [[ICListingSearchController sharedInstance] searchWithParameters:currentParameters];
    }
    
}

- (void)currentLocationSelected; {
    [self updateToCurrentLocation]; 
}


#pragma mark -
#pragma mark NSNotification Handlers
- (void)receivedNotificationNotification:(NSNotification *)notification; {
    
    NSInteger unreadNotificationsCount = [ICManagedNotification numberofUnreadNotifications]; //4;
    
    
    GRLog5(@"Number of unread notification: %i",unreadNotificationsCount);
    
    if (unreadNotificationsCount > 0) {
        
        CGFloat frameX = 300.0f;
        NSString *notificationString = [NSString stringWithFormat:@"%d", unreadNotificationsCount];
        
        if (unreadNotificationsCount > 99) {
            frameX = 290.0f;
            notificationString = @"99+";
        }
        else if (unreadNotificationsCount > 9) {
            frameX = 295.0f;
        }
        
        
        if (!_notificationBadge) {
            self.notificationBadge = [CustomBadge customBadgeWithString:notificationString withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor whiteColor] withScale:0.8 withShining:YES];
        }
        else {
            [_notificationBadge autoBadgeSizeWithString:notificationString];
        }
        
        [_notificationBadge setFrame:CGRectMake(frameX, 0.0f, _notificationBadge.frame.size.width, _notificationBadge.frame.size.height)];
        
        [self.navigationController.navigationBar addSubview:_notificationBadge];
        [self.navigationController.navigationBar bringSubviewToFront:_notificationBadge];
        
        
        
    }
    else {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.notificationBadge setAlpha:0.0f];
            
        } completion:^(BOOL finished) {
            
            [self.notificationBadge removeFromSuperview];
            self.notificationBadge = nil;
            
        }];
        
        
    }
    
}


#pragma mark -
#pragma mark Gallery

- (void)deviceOrientationChanged:(NSNotification *)notification; {
    
    UIDeviceOrientation newOrientation = [[UIDevice currentDevice] orientation];
    
    if(!self.isFilterViewVisible){
        switch (newOrientation) {
            case UIDeviceOrientationLandscapeLeft:
            case UIDeviceOrientationLandscapeRight:
                [self showGalleryView:self];
                break;
            case UIDeviceOrientationPortrait:
            case UIDeviceOrientationPortraitUpsideDown:
                [self performSelector:@selector(hideGalleryView:) withObject:self afterDelay:0.3f];
            default:
                break;
        }
    }
}

- (void)showGalleryView:(id)sender; {
    
    if (self.navigationController.topViewController == self) {
        NSString *indexType = [self currentIndexType];
        
        NSDictionary *resultSet = (NSDictionary *)[[ICListingSearchController sharedInstance].listingResults objectForKey:indexType];
        
        if (self.showingGalleryView || [resultSet count] == 0) {
            return;
        }
        
        self.showingGalleryView = YES;
        
        self.darkGlassViewMaximumAlpha = 1.0f;
        self.darkGlassColor = [UIColor blackColor];
        // [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
        [self showGlass:YES];
    }
    
    
    
}

- (void)showGlassAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context; {
    
    [super showGlassAnimationDidStop:animationID finished:finished context:context];
    
    self.galleryViewController = [[IAListingSearchGalleryViewController_iPhone alloc] initWithNibName:nil bundle:nil];
    [_galleryViewController setDelegate:self];
    
    
//    self.galleryViewController.delegate = self;
    
//    [delegates addObject:self.galleryViewController];
    
//    [self.galleryViewController search:self.searchParams receivedResults:self.searchResults];
    
    UINavigationController *aNavController = [[UINavigationController alloc] initWithRootViewController:self.galleryViewController];
    aNavController.wantsFullScreenLayout = YES;
    
    [self.navigationController presentModalViewController:aNavController animated:YES];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
}

- (void)hideGalleryView:(id)sender; {
    
    if (!self.showingGalleryView || !self.galleryViewController) {
        return;
    }
    
//    self.galleryViewController.delegate = nil;
//    [delegates removeObject:self.galleryViewController];
    self.galleryViewController = nil;
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    self.showingGalleryView = NO;
    
    [self hideGlass:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];  
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];  
}

- (void)hideGlassAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context; {
    
    [super hideGlassAnimationDidStop:animationID finished:finished context:context];
    
}



#pragma mark -
#pragma mark Dark glass overlay

// Currently only used by the SRP's photo gallery view. Would be nice to enhance with callbacks, etc., when it expands from there.

- (void)showGlass:(BOOL)animated; {
    
    CGRect notificationFrame = [[UIScreen mainScreen] applicationFrame];
    
    if (self.darkGlassView) {
        return;
    }
    
    self.darkGlassView = [[UIView alloc] initWithFrame:notificationFrame];    
    
    if (!self.darkGlassColor) {
        self.darkGlassColor = [UIColor blackColor];
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.originalWindowColor = window.backgroundColor;
    window.backgroundColor = self.darkGlassColor;
    
    self.darkGlassView.backgroundColor = self.darkGlassColor;
    
    if ([self.darkGlassView superview]) {
        [self.darkGlassView removeFromSuperview];
    }
    
    self.darkGlassView.alpha = 0.0f;   
    
    UIView *viewForGlass = [self.view superview];
    
    if (self.navigationController) {
        viewForGlass = self.navigationController.view; // [self.navigationController.view superview];
    }
    
    [viewForGlass addSubview:self.darkGlassView];
    [viewForGlass bringSubviewToFront:self.darkGlassView];
    
    if (animated) {
        [UIView beginAnimations:TRULIA_GLASS_OVERLAY_ANIMATION_NAME context:nil];
        [UIView setAnimationDuration:TRULIA_GLASS_OVERLAY_ANIMATION_DURATION];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(showGlassAnimationDidStop:finished:context:)];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    
    self.darkGlassView.alpha = self.darkGlassViewMaximumAlpha;
    
    if (animated) {
        [UIView commitAnimations];
    } else {
        [self showGlassAnimationDidStop:TRULIA_GLASS_OVERLAY_ANIMATION_NAME finished:[NSNumber numberWithBool:YES] context:nil];
    }    
    
}

- (void)hideGlass:(BOOL)animated; {
    
    if (!self.darkGlassView) {
        [self hideGlassAnimationDidStop:TRULIA_GLASS_OVERLAY_ANIMATION_NAME finished:[NSNumber numberWithBool:YES] context:nil];
        return;
    }
    
    if (animated) {
        [UIView beginAnimations:TRULIA_GLASS_OVERLAY_ANIMATION_NAME context:nil];
        [UIView setAnimationDuration:TRULIA_GLASS_OVERLAY_ANIMATION_DURATION];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(hideGlassAnimationDidStop:finished:context:)];
    }
    
    self.darkGlassView.alpha = 0.0f;
    
    if (animated) {
        [UIView commitAnimations];
    } else {
        [self hideGlassAnimationDidStop:TRULIA_GLASS_OVERLAY_ANIMATION_NAME finished:[NSNumber numberWithBool:YES] context:nil];
    }
    
}


#pragma mark -
#pragma mark IAListingSearchGalleryViewControllerDelegate methods

- (void)dismissSearchGalleryViewController:(IAListingSearchGalleryViewController_iPhone *)galleryViewController {
    
    [self hideGalleryView:galleryViewController];
    
    
}

- (void)pushDetailForIndex:(NSInteger)integer indexType:(NSString *)indexType {
    
    [self listingCalloutView_iPhone:nil tappedWithIndex:integer andIndexType:indexType];
    
}


#pragma mark - 
#pragma mark Save Search Animation methods


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //    NSLog(@"animationDidStop");
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:1.5],
                              [NSNumber numberWithFloat:0.9],
                              [NSNumber numberWithFloat:1.1], nil];
    bounceAnimation.duration = 0.4;
    bounceAnimation.removedOnCompletion = YES;
    [self.navigationItem.rightBarButtonItem.customView.layer addAnimation:bounceAnimation forKey:@"bounce"];
    [self.animatedView removeFromSuperview];
    
}

- (void)animateStarToMyAccountButton; {
    
    
    UIImageView *buttonImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ActionUnStar"]];
    
    CGPoint buttonPoint = [self.navigationController.toolbar  convertPoint:self.btnSaveUnsaveToggle.center toView:self.navigationItem.rightBarButtonItem.customView];
    
    buttonImage.center = buttonPoint;
    
    [self.navigationItem.rightBarButtonItem.customView addSubview:buttonImage];
    
    
    CAKeyframeAnimation *jumpAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    jumpAnimation.removedOnCompletion = YES;
    
    CAKeyframeAnimation *growAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    growAnimation.values = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:1.0],
                            [NSNumber numberWithFloat:1.3],
                            [NSNumber numberWithFloat:2.0],
                            [NSNumber numberWithFloat:1.5],
                            [NSNumber numberWithFloat:1.0], nil];
    
    CGFloat animationDuration = 0.5f;
    
    UIButton *myTruliaButton = nil;
    CGPoint myTruliaButtonPoint;
    
    myTruliaButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    myTruliaButtonPoint = [self.navigationController.navigationBar convertPoint:CGPointMake(myTruliaButton.frame.origin.x + myTruliaButton.frame.size.width/2, myTruliaButton.frame.origin.y + myTruliaButton.frame.size.height/2) toView:self.navigationItem.rightBarButtonItem.customView];
    
    // Create the path for the bounces
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath, NULL, buttonPoint.x, buttonPoint.y);
    CGPathAddCurveToPoint(thePath, NULL, buttonPoint.x + 20, buttonPoint.y - 20, myTruliaButtonPoint.x + 10, myTruliaButtonPoint.y - 10, myTruliaButtonPoint.x, myTruliaButtonPoint.y);
    
    jumpAnimation.path = thePath;
    CGPathRelease(thePath);
    jumpAnimation.duration = animationDuration;
    growAnimation.duration = animationDuration;
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
    
    // Set self as the delegate to allow for a callback to reenable user interaction
    theGroup.delegate = self;
    theGroup.duration = animationDuration;
    theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    theGroup.animations = [NSArray arrayWithObjects:jumpAnimation, growAnimation, nil];
    
    
    [buttonImage.layer addAnimation:theGroup forKey:@"jumpFollowingStar"];
    
    [_animatedView removeFromSuperview];
    self.animatedView = buttonImage;
    
    
}


#pragma mark - 
#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex; {
    if(buttonIndex == 0)
        [mapViewMap setMapType:MKMapTypeStandard];
    else if(buttonIndex == 1)
        [mapViewMap setMapType:MKMapTypeHybrid];
    else if(buttonIndex == 2)
        [mapViewMap setMapType:MKMapTypeSatellite];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad; {
    [super viewDidLoad];
    
    NSString *mapToggleButtonTitle = ICLocalizedString(@"SatelliteView");
    
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    newButton.frame = CGRectMake((mapViewMap.frame.size.width - 10.0 - GR_MAP_VIEW_BUTTON_WIDTH), (mapViewMap.frame.size.height - (GR_MAP_VIEW_BUTTON_HEIGHT + GR_MAP_VIEW_BUTTON_GUTTER_BOTTOM)), GR_MAP_VIEW_BUTTON_WIDTH, GR_MAP_VIEW_BUTTON_HEIGHT);
    
    newButton.titleLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    newButton.titleEdgeInsets = UIEdgeInsetsMake(1.0f, 1.0f, 0.0f, 0.0f);
    [newButton setBackgroundImage:[[UIImage imageNamed:@"BgBtnGreen.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newButton addTarget:self action:@selector(actionMapTypeToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    NSNumber *mapTypeNumber = [[ICPreference sharedInstance] getAppForKey:APP_PREFERENCE_MAP_TYPE_KEY];
    
    if (mapTypeNumber) {
        NSInteger mapType = [mapTypeNumber intValue];
        [self setMapType:mapType];
        mapToggleButtonTitle = ([mapTypeNumber intValue] == MKMapTypeStandard) ? NSLocalizedString(@"SatelliteView", nil) : NSLocalizedString(@"RoadView", nil);
    }
    
    [newButton setTitle:mapToggleButtonTitle forState:UIControlStateNormal];
    self.mapTypeToggleButton = newButton;
    [self.view addSubview:_mapTypeToggleButton];
    
    
    self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat buttonWidth = GR_MAP_VIEW_BUTTON_WIDTH * 2.0f;
    CGFloat refreshOriginX = (self.view.bounds.size.width / 2.0f) - (buttonWidth / 2.0f);
    self.refreshButton.frame = CGRectMake(refreshOriginX, self.mapTypeToggleButton.frame.origin.y, buttonWidth, self.mapTypeToggleButton.frame.size.height);
    
    if ((self.refreshButton.frame.origin.x + self.refreshButton.frame.size.width) >= (self.mapTypeToggleButton.frame.origin.x - 10.0f)) {
        CGRect newFrame = self.refreshButton.frame;
        newFrame.origin.x = (self.mapTypeToggleButton.frame.origin.x - buttonWidth - 10.0f);
        self.refreshButton.frame = newFrame;
    }
    
    self.refreshButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    self.refreshButton.alpha = 0.0f;
    self.refreshButton.titleLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    self.refreshButton.titleEdgeInsets = UIEdgeInsetsMake(1.0f, 1.0f, 0.0f, 0.0f);
    [self.refreshButton setBackgroundImage:[[UIImage imageNamed:@"BgBtnMap.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    [self.refreshButton setTitle:@"REFRESH RESULTS" forState:UIControlStateNormal];
    [self.refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.refreshButton addTarget:self action:@selector(actionRedoSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.refreshButton];
    
    self.captureScreenshotSupported = NO;
    self.view.backgroundColor = [UIColor truliaGrayBackgroundColor];
	tableViewList.backgroundColor = [UIColor whiteColor];
    tableViewList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    if(_toolbarSourceItems != nil) {
        
        if (![self.navigationController.toolbar viewWithTag:100]) {
            
            UIImage *image = [[UIImage imageNamed:@"BgBottomToolbar.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:14];
            UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:image];
            backgroundImage.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            
            CGFloat topShadowArea = 5.0f;
            backgroundImage.frame = CGRectMake(0, (0.0f - topShadowArea), self.toolbarSourceItems.bounds.size.width, (self.toolbarSourceItems.bounds.size.height + topShadowArea));
            backgroundImage.contentMode = UIViewContentModeScaleToFill;
            backgroundImage.tag = 100;
            [self.navigationController.toolbar addSubview:backgroundImage];
            
        }
        
        self.toolbarItems = _toolbarSourceItems.items;
    }
    
    UIButton *barButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    [barButton setBackgroundImage:[[UIImage imageNamed:@"BgBtnGreen"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
    [barButton setImage:[UIImage imageNamed:@"BtnNavFolder"] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(actionShowMyAccount:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *myAccountBarButton = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = myAccountBarButton;
    
    [self setupCustomBackButtons];
    
    [self addTitleView];
    
    
    if (currentMode == ICListingSearchViewController_iPhoneViewModeList) {
        [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
        [self.mapTypeToggleButton setHidden:YES];
        [_btnFlexPosition setImage:[UIImage imageNamed:@"ActionSort.png"] forState:UIControlStateNormal];
        [_btnMapListToggle setImage:[UIImage imageNamed:@"ActionMap.png"] forState:UIControlStateNormal];
    }
    else {
        [self.mapTypeToggleButton setHidden:NO];
        [_btnFlexPosition setImage:[UIImage imageNamed:@"ActionNearby.png"] forState:UIControlStateNormal];
        [_btnMapListToggle setImage:[UIImage imageNamed:@"ActionList.png"] forState:UIControlStateNormal];
    }
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedErrorNotification:) name:@"APIErrorListingZoomedOutTooFar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedErrorNotification:) name:@"APIErrorListingMessagingGeneral" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedErrorNotification:) name:@"APIErrorListingNoResults" object:nil];
}

- (void)viewWillAppear:(BOOL)animated; {
    [super viewWillAppear:animated];
    
    
    self.isFilterViewVisible = NO;
    //TMA
    
    NSDictionary *tmaAttributes = [[ICState sharedInstance] attributesNamed:@"TmaAttributes"];
    NSString *status = [tmaAttributes objectForKey:@"status"];
    
    if(tmaAttributes){
        
        if([status boolValue]){
            
            if(!self.mapTmaAdController){
                self.mapTmaAdController = [[IATMAdViewController_iPhone alloc] init];
                self.mapTmaAdController.navController = super.navigationController;
                self.mapTmaAdController.isListView = NO;
            }
            self.mapTmaAdController.canShowNewAd = YES;
            
            if(!self.listTmaAdController){
                self.listTmaAdController = [[IATMAdViewController_iPhone alloc] init];
                self.listTmaAdController.navController = super.navigationController;
                self.listTmaAdController.isListView = YES;
                
                
            }
            self.listTmaAdController.canShowNewAd = YES;
            self.isTMAListViewReady = NO;
            
            
            
        }
        
    }else
    {
        if(!self.mapTmaAdController){
            self.mapTmaAdController = [[IATMAdViewController_iPhone alloc] init];
            self.mapTmaAdController.navController = super.navigationController;
            self.mapTmaAdController.isListView = NO;
            self.mapTmaAdController.canShowNewAd = YES;
        }
        self.mapTmaAdController.canShowNewAd = YES;
        
        if(!self.listTmaAdController){
            self.listTmaAdController = [[IATMAdViewController_iPhone alloc] init];
            self.listTmaAdController.navController = super.navigationController;
            self.listTmaAdController.isListView = YES;
            self.listTmaAdController.canShowNewAd = YES;
        }
        self.listTmaAdController.canShowNewAd = YES;
        self.isTMAListViewReady = NO;
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedTMAdSuccessNotification:) name:@"ICTMAdReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedTMAdHideAdNotification:) name:@"ICTMAdHide" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedTMAdShowAdNotification:) name:@"ICTMAdShow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedTMAdLeadEmailSentNotification:) name:@"ICTMAdLeadEmailSent" object:nil];
    
    //[self animateTableViewWithTmaPresent:NO];
    
    if(self.listTmaAdController && currentMode == ICListingSearchViewController_iPhoneViewModeList && [[ICListingSearchController sharedInstance].currentParameters.indexType containsObject:@"for sale"]){
        
        
        
        if([[ICListingSearchController sharedInstance].currentParameters.indexType containsObject:@"for sale"]){
            
            NSString *indexType = @"for sale";
            
            self.listTmaAdController.currentListing = [[ICListingSearchController sharedInstance] getListingAtIndex:0 withIndexType:indexType callPaging:NO];
            self.isTMAListViewReady = NO;
            [self.listTmaAdController getNewAd];
            
        }        
    }

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ICListingSearchControllerSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"ICListingSearchControllerSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ICListingSearchControllerSearchBegan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoading:) name:@"ICListingSearchControllerSearchBegan" object:nil];
    
    
    mapViewMap.showsUserLocation = YES;
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setTintColor:[UIColor truliaGreenColor]];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground"] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    if (!self.showingGalleryView) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [self.navigationController setToolbarHidden:NO];
    }
    
    [self receivedNotificationNotification:nil];
    
    
}

- (void)viewDidAppear:(BOOL)animated; {
    [super viewDidAppear:animated];
    
    [[ICPreference sharedInstance] setAppForKey:@"CurrentAppScreen" withAttribute:[NSNumber numberWithInt:TruliaAppScreenSRPMap]];
    
    ICManagedSearch *theSearch = [[ICListingSearchController sharedInstance] currentSearch];
    if ([theSearch activeMembershipWithCategoryName:MANAGED_CATEGORY_FAVORITES] != nil)
        [_btnSaveUnsaveToggle setImage:[UIImage imageNamed:@"ActionUnStar.png"] forState:UIControlStateNormal];
    else       
        [_btnSaveUnsaveToggle setImage:[UIImage imageNamed:@"ActionStar.png"] forState:UIControlStateNormal];
    
    isFrozen = NO;
    
    [self trackPageView];
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    if(listTmaAdController && listTmaAdController.isAdVisible)
        [listTmaAdController hideAdWithAnimation:NO];
    
   // [self animateTableViewWithTmaPresent:NO];

}

- (void)viewWillDisappear:(BOOL)animated; {
    [super viewWillDisappear:animated];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ICListingSearchControllerSuccess" object:nil];
    
    mapViewMap.showsUserLocation = NO;
    
    
    if (!self.showingGalleryView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    }
    
    [self.notificationBadge removeFromSuperview];
}


- (void)viewDidUnload; {
    
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"APIErrorListingZoomedOutTooFar" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"APIErrorListingMessagingGeneral" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"APIErrorListingNoResults" object:nil];

}

#pragma mark -
#pragma mark ICPostLoginProtocol Methods


- (void)loginViewController:(UIViewController *)loginViewController dismissViewAnimated:(BOOL)animated{
    
    [self.navigationController dismissModalViewControllerAnimated:animated];
}


- (void)loginViewController:(UIViewController *)loginViewController performAction:(PostLoginActionType)postLoginAction{
    
    if(postLoginAction == PostLoginActionTypeFavorite){
        [self actionToggleSaveUnsave:nil];
    }
}

#pragma mark -
#pragma mark Object management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(!self)
        return self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"ICListingSearchControllerSuccess" object:nil];
    
    self.title = @""; //Covered by the search bar
    self.areaDesignation = @"Search";
    isRotating = NO;
    mapLoaded = NO;
    
    self.hideHeaderController = YES;
    
    return self;
}

- (void)didReceiveMemoryWarning; {
    [super didReceiveMemoryWarning];
}

- (BOOL)isSavedSearch{

    ICManagedSearch *theSearch = [[ICListingSearchController sharedInstance] currentSearch];
    return (nil!= theSearch && [theSearch activeMembershipWithCategoryName:MANAGED_CATEGORY_FAVORITES] != nil) ? YES : NO;
}

@end
