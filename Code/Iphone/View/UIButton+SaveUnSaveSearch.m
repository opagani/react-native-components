//
//  UIButton+SaveUnSaveSearch.m
//  Trulia
//
//  Created by Fawad Haider on 3/4/13.
//  Copyright (c) 2013 Trulia Inc. All rights reserved.
//

#import "UIButton+SaveUnSaveSearch.h"
#import "ICManagedSearch.h"
#import <objc/runtime.h>
#import "ICPostLoginProtocol.h"
#import "ICAccountController.h"
#import "ICLoginViewController_iPhone.h"
#import "ICLoginViewController_iPad.h"
#import "ICPreference.h"
#import "ICNavigationController.h"
#import "ICLoginViewControllerUtil.h"

@implementation UIButton (SaveUnSaveSearch)
-(void)actionSaveUnsaveSearchInViewController:(UIViewController*)viewController saveAnimationBlock:(void (^)(void))animationBlock unsaveAnimationBlock:(void (^)(void))unsaveBlock currentMode:(ICListingSearchViewController_iPhoneViewMode)currentMode{

    PostLoginActionType postLoginActionType;

    if ([[self getSearch] activeMembershipWithCategoryName:MANAGED_CATEGORY_FAVORITES] != nil)
        postLoginActionType = PostLoginActionTypeUnFavorite;
    else
        postLoginActionType = PostLoginActionTypeFavorite;

    __weak __typeof__ (self) weakself = self;
    //Force Login for saving properties
    [ICLoginViewControllerUtil presentLoginViewControllerIfNotAuthenticated:viewController postLoginActionType:postLoginActionType dismissBlock:^(BOOL animated)
    {
        [viewController dismissModalViewControllerAnimated:animated];

    } postAttemptActionBlock:^(PostLoginActionType actionType)
    {
       if ([[ICAccountController sharedInstance] isLoggedIn])
        {
            id search = [weakself getSearch];

            if ([search activeMembershipWithCategoryName:MANAGED_CATEGORY_FAVORITES] != nil)
            {
                [weakself unsaveSearch:search unSaveBlock:unsaveBlock currentMode:currentMode];
            }
            else
            {
                [weakself saveSearch:search animationBlock:animationBlock currentMode:currentMode];
            }
        }
    }];
}

-(void)toggleSearchSaveButtonState:(BOOL)isAlreadySaved{

}

- (id)getSearch {
    return objc_getAssociatedObject(self, @"UIButton+Search");
}

- (void)setSearch:(id)search {
    objc_setAssociatedObject(self, @"UIButton+Search", search, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if([search isFollowing])
       [self setSelected:YES];
    else
       [self setSelected:NO];
}

-(void)saveSearch:(ICManagedSearch*)theSearch animationBlock:(void (^)(void))animationBlock currentMode:(ICListingSearchViewController_iPhoneViewMode)currentMode{
    
    [[ICMetricsController sharedInstance] trackToolbarClick:[ICMetricsController VAR_ACTION_SAVE]];
    [[ICMetricsController sharedInstance] trackEvent:(currentMode == ICListingSearchViewController_iPhoneViewModeMap) ? @"MapSearchView" : @"ListingSearchView" moduleName:[ICMetricsController VAR_TOOLBAR] metaData:theSearch.indexType evenType:SEARCH_SAVED];
    [theSearch setIsFollowing:YES];
    if (animationBlock)
        animationBlock();
    //MOB-5381 tracking for save search success
    NSString *modeString = (currentMode == ICListingSearchViewController_iPhoneViewModeMap) ? @"map" : @"list";
    [[ICMetricsController sharedInstance] trackClick:[NSString stringWithFormat:@"%@:savesearch:success", modeString]];
    
}

-(void)unsaveSearch:(ICManagedSearch*)theSearch unSaveBlock:(void (^)(void))unSaveBlock currentMode:(ICListingSearchViewController_iPhoneViewMode)currentMode{
    
    [[ICMetricsController sharedInstance] trackToolbarClick:[ICMetricsController VAR_ACTION_UNSAVE]];
    NSString *modeString = (currentMode == ICListingSearchViewController_iPhoneViewModeMap) ? @"MapSearchView" : @"ListingSearchView";
    [[ICMetricsController sharedInstance] trackEvent:modeString moduleName:[ICMetricsController VAR_TOOLBAR] metaData:theSearch.indexType evenType:SEARCH_UNSAVED];
    
    [theSearch setIsFollowing:NO];
    if (unSaveBlock)
        unSaveBlock();
}

@end
