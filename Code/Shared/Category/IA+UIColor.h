//
//  IA+UIColor.h
//  Trulia
//
//  Created by Daniel Lowrie on 1/26/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import "IC+UIColor.h"

@interface UIColor(TruliaColors)

+ (id)IAGreenColor;
+ (id)IADarkGrayColor;
+ (id)IARedErrorColor;
+ (id)IARedPriceColor;
+ (id)IAGreenPriceColor;
+ (id)IABlueLinkColor;

+ (id)truliaGrayButtonColor; 
+ (id)IAGrayBackgroundColor;
+ (id)IAGrayBackgroundColorWithAlpha:(CGFloat)alpha;
+ (id)truliaGreyThumbnailBorderColor;
+ (id)truliaGreyListTextColor;
+ (id)truliaGreyPriceHistoryColor;
+ (id)truliaOpenHouseLabelBackgroundColor;
+ (id)truliaGrayTextColor;

@end
