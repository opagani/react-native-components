//
//  IRMainMenu.m
//  Trulia Rent
//
//  Created by Christopher Echanique on 7/9/15.
//  Copyright (c) 2015 Trulia Inc. All rights reserved.
//

#import "IRMainMenu.h"
#import "ICMenuHeaders.h"
#import "IRMainMenuAppsSection.h"
#import "IRMainMenuMoreSection.h"
#import "IRMainMenuSearchSection.h"

@implementation IRMainMenu

@synthesize defaultIndexPath = _defaultIndexPath;

- (instancetype)init{
    return [self initWithIdiom:UI_USER_INTERFACE_IDIOM()];
}

- (instancetype)initWithIdiom:(UIUserInterfaceIdiom)idiom{
    
    if (self = [super initWithMenuSections:[IRMainMenu sections]]) {
        _defaultIndexPath = [self defaultIndexPathForIdiom:idiom];
    }
    
    return self;
}

- (NSIndexPath*)defaultIndexPathForIdiom:(UIUserInterfaceIdiom)idiom {
    NSIndexPath * indexPath = nil;
    
    if(idiom == UIUserInterfaceIdiomPhone){
        indexPath = [self indexPathForMenuItemClass:[ICDiscoveryMenuItem class]];
    }
    else{
        indexPath = [self indexPathForMenuItemClass:[ICHomesForSaleMenuItem class]];
    }
    
    return indexPath;
}

+ (NSArray *)sections {
    return @[[ICLoginMenuSection menuSection],
             [IRMainMenuSearchSection menuSection],
             [IRMainMenuAppsSection menuSection],
             [IRMainMenuMoreSection menuSection]
             ];
}

@end

