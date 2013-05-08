//
//  IAListingPhotoLandscapeViewController_iPhone.h
//  Trulia
//
//  Created by Dan Lowrie on 2/29/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import "IAListingPhotoViewController_iPhone.h"
static const NSTimeInterval TRULIA_PROPERTY_LANDSCAPE_PHOTO_VIEW_ANIMATION_DURATION = 0.5f;

@interface IAListingPhotoLandscapeViewController_iPhone : IAListingPhotoViewController_iPhone {
    
}

@property (nonatomic, assign) IAListingPhotoViewController_iPhone *parentPhotoViewController;
@property (nonatomic, assign) NSInteger startingCenterPhotoIndex;

@end
