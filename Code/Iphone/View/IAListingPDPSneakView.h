//
//  IAListingCalloutView_iPhone.h
//  Trulia
//
//  Created by Daniel Lowrie on 1/24/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICImageView.h"

@class IAListingPDPSneakView;
@protocol IAListingPDPSneakView_iPhoneDelegate <NSObject>
@required
//- (void)listingCalloutView_iPhone:(IAListingPDPSneakView *)IAListingCalloutView_iPhone tappedWithIndex:(NSInteger)pIndex andIndexType:(NSString *)pIndexType;
@end

@interface IAListingPDPSneakView : UIView

@property(nonatomic,strong) NSString *indexType;
@property(nonatomic,assign) NSInteger index;

@property(nonatomic,weak) id <IAListingPDPSneakView_iPhoneDelegate> delegate;
@property(nonatomic,strong) UIImageView *bgImage;

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImage *defaultImageThumbnail;
@property (nonatomic, strong) ICImageView *propertyImage;

@property(nonatomic,strong) UIView *propertyImageGrayBorder;
@property(nonatomic,strong) UIView *propertyImageWhiteBorder;

- (void)hide;
- (void)show;
- (void)setIndex:(NSInteger)pIndex withIndexType:(NSString *)pIndexType;
- (void)updatePriceColorForAnnotationState:(AnnotationState)currentAnnotationState;


@end
