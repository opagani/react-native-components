//
//  IRMainMenuSearchSection.m
//  Trulia Rent
//
//  Created by Christopher Echanique on 7/9/15.
//  Copyright (c) 2015 Trulia Inc. All rights reserved.
//

#import "IRMainMenuSearchSection.h"
#import "ICMenuHeaders.h"

@implementation IRMainMenuSearchSection
-(instancetype)init{
    return [self initForIdiom:UI_USER_INTERFACE_IDIOM()];
}

-(instancetype)initForIdiom:(UIUserInterfaceIdiom)idiom{
    NSArray * items = [[self class] menuItemsForIdiom:idiom];
    NSString * title = ICLocalizedString(@"SEARCH");
    return [super initWithTitle:title items:items];
}

+(NSArray*)menuItemsForIdiom:(UIUserInterfaceIdiom)idiom{
    NSArray * items = nil;
    
    if(idiom == UIUserInterfaceIdiomPhone){
        items = @[[ICDiscoveryMenuItem menuItem],
                  [ICHomesForRentMenuItem menuItem],
                  [ICMyBoardsMenuItem menuItem],
                  [ICSavedSearchesMenuItem menuItem]
                  ];
    }
    else if(idiom == UIUserInterfaceIdiomPad){
        
        items = @[[ICHomesForRentMenuItem menuItem],
                  [[ICSavedHomesMenuItem alloc] initWithShowBadge:NO],
                  [[ICSavedSearchesMenuItemPad alloc] initWithShowBadge:NO]
                  ];
    }
    
    return items;
}
@end
