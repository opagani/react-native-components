//
//  IA+UIColor.m
//  Trulia
//
//  Created by Daniel Lowrie on 1/26/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import "IA+UIColor.h"

@implementation UIColor(TruliaColors)

+ (id)IAGreenColor; {
    return [UIColor colorWithRed:94/255.0 green:171.0/255.0 blue:31/255.0 alpha:1.0];
}

+ (id)IADarkGrayColor; {
    return [UIColor colorWithWhite:(70.0f / 255.0f) alpha:1.0f];
}

+ (id)truliaGreyThumbnailBorderColor; {
    return [UIColor colorWithWhite:(204.0f / 255.0f) alpha:1.0f];
}

+ (id)IARedPriceColor; {
    return [UIColor colorWithRed:204.0f/255.0f green:33.0/255.0f blue:20.0/255.0f alpha:1.0f];
}

+ (id)IAGreenPriceColor; {
    return [UIColor colorWithRed:94.0/255.0 green:171.0/255.0 blue:31.0/255.0 alpha:1.0];
}

+ (id)IABlueLinkColor; {
    return [UIColor colorWithRed:102.0/255.0 green:153/255.0 blue:0/255.0 alpha:1.0];
}

+ (id)IARedErrorColor; {
    return [UIColor colorWithRed:204.0f/255.0f green:51.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
}

+ (id)truliaGrayButtonColor; {
    return [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
}

+ (id)IAGrayBackgroundColor; {
    return [UIColor IAGrayBackgroundColorWithAlpha:1.0f];
}

+ (id)IAGrayBackgroundColorWithAlpha:(CGFloat)alpha; {
    return [UIColor colorWithWhite:0.94f alpha:alpha];
}

+ (id)truliaGreyListTextColor;{
    return [UIColor colorWithRed:34.0f/255.0f green:34.0f/255.0f blue:34.0f/255.0f alpha:1.0f];
}

+ (id)truliaGreyPriceHistoryColor; {
    return [UIColor colorWithWhite:0.4f alpha:1.0f];    
}

+ (id)truliaOpenHouseLabelBackgroundColor{
    
    return [self IAGreenColor];
}

+ (id)truliaGrayTextColor{
    
    return [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
}


@end