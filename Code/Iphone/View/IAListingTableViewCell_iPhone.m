//
//  IAListingTableViewCell_iPhone.m
//  Trulia
//
//  Created by Daniel Lowrie on 1/24/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "IAListingTableViewCell_iPhone.h"
#import "ICListingSearchController.h"
#import "ICListingFormatter.h"
#import "ICUtility.h"
#import "IA+UIColor.h"
#import "ICSubListingFormatter.h"
#import "ICImageBundleUtil.h"
#import "IC+UIColor.h"
#import "ICFont.h"
#import "ICImageView.h"
#import "UIControl+BlocksKit.h"


static NSNumberFormatter *numberFormatter = nil;
static NSDateFormatter *shortDateFormatter = nil;

#define PSLISTVIEWCELL_TOP_GUTTER   5.0
#define PSLISTVIEWCELL_LEFT_GUTTER  5.0
#define PSLISTVIEWCELL_ROW_HEIGHT   18.0
#define PSLISTVIEWCELL_IMAGE_WIDTH  120.0
#define PSLISTVIEWCELL_IMAGE_HEIGHT 120
#define PSLISTVIEWCELL_PADDING      10.0
#define LABEL_MAX_WIDTH             200.0
#define PSLISTVIEWCELL_LABEL_WIDTH     170.0
#define PSLISTDATECHANGE_LABEL_WIDTH   105.0

#define PSLISTVIEWCELL_PRICE_LABEL_MAX_WIDTH 180.0
#define PSLISTVIEWCELL_PRICECHANGE_LABEL_MAX_WIDTH 95.0
#define PSLISTVIEWCELL_OPENHOME_LABEL_SIZE_WIDTH  90.0f
#define PSLISTVIEWCELL_OPENHOME_LABEL_SIZE_HEIGHT 20.0f

@interface IAListingTableViewCell_iPhone (Private)
- (void)reset;
- (BOOL)hasDistance;

@end

@implementation IAListingTableViewCell_iPhone
@synthesize index, indexType, listing,addressLabel, priceLabel, infoLabel, typeLabel, priceChangeLabel, priceChangeDateLabel, priceChangeIcon;
@synthesize distanceLabel, openHomeLabel, openHomeTimeLabel, monthLabel, estimatesLabel;
@synthesize floorplansLabel, communityNameLabel, squareFootLabel, mayShowFavoriteIcon, favoriteIcon;
@synthesize loadingView = _loadingView;
@synthesize dateFormatter,propertyNewLabel;

#pragma mark -
#pragma mark Utility methods

- (BOOL)hasDistance; {
    if([distance intValue] >= 0)
        return YES;
    
    return NO;
}

- (void)setIndex:(NSInteger)pIndex withIndexType:(NSString *)pIndexType withDistance:(NSNumber *)_distance {
    
    distance = _distance;
    
    self.index = pIndex;
    self.indexType = pIndexType;
    self.listing = [[ICListingSearchController sharedInstance] getListingAtIndex:index withIndexType:indexType callPaging:YES];
    
    [self reset];
    [self setupDisplay];
}

- (void)setIndex:(NSInteger)pIndex withIndexType:(NSString *)pIndexType; {
    [self setIndex:pIndex withIndexType:pIndexType withDistance:[NSNumber numberWithInt:-1]];
}

- (void)setWithListing:(ICListing *)pListing withDistance:(NSNumber *)_distance {
    distance = _distance;
    self.listing = pListing;
    
    [self reset];
    [self setupDisplay];
}

- (void)setWithListing:(ICListing *)pListing; {
    [self setWithListing:pListing withDistance:[NSNumber numberWithInt:-1]];
}


#define SAVE_OFFSET_X 20
#define SAVE_OFFSET_Y 15
#define SAVE_WTDH 20
#define SAVE_HEIGHT 21

- (void)setupDisplay; {
    
    CGRect contentRect = [self bounds];
	CGFloat currentHeight = contentRect.origin.y + PSLISTVIEWCELL_TOP_GUTTER * 2 + 2.0f;
    CGRect currentFrame;
    CGFloat xOffsetForText = contentRect.origin.x + PSLISTVIEWCELL_LEFT_GUTTER * 2.5 + PSLISTVIEWCELL_IMAGE_WIDTH;
    CGFloat yOffsetFromOrigin = (PSLISTVIEWCELL_TOP_GUTTER * 2) + 2.0f;
    
    if (!numberFormatter) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [numberFormatter setLocale:usLocale];
        [numberFormatter setAlwaysShowsDecimalSeparator:NO];
        [numberFormatter setUsesGroupingSeparator:YES];
        [numberFormatter setMaximumFractionDigits:0];
    }
    
    if(!dateFormatter){
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"MM/dd/yyyy"];
    }
    
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    numberFormatter.negativeFormat = numberFormatter.positiveFormat;
    numberFormatter.negativePrefix = numberFormatter.positivePrefix;
    
    NSInteger daysOnTrulia = [[self.listing getListingData:ListingDataDaysOnTrulia] intValue];
    
    CGFloat priceXOffset = xOffsetForText;
    
    if( daysOnTrulia && daysOnTrulia <= 1){
        [self.contentView addSubview:propertyNewLabel];
         self.propertyNewLabel.text = @"New ";
        CGSize newLblSize = [propertyNewLabel.text sizeWithFont:propertyNewLabel.font];
        currentFrame = CGRectMake(xOffsetForText, currentHeight, newLblSize.width, PSLISTVIEWCELL_ROW_HEIGHT);
        propertyNewLabel.frame = currentFrame;
        
        priceXOffset += newLblSize.width;
    }
    
    priceLabel.text = [ICListingFormatter condensedPriceWithListing:listing];
    
    if ([[listing getListingData:ListingDataIndexType] isEqualToString:IC_INDEXTYPE_SOLD]) {
        priceLabel.textColor = [UIColor IARedPriceColor];
    }

    CGSize priceTextSize = [priceLabel.text sizeWithFont:priceLabel.font constrainedToSize:CGSizeMake(PSLISTVIEWCELL_PRICE_LABEL_MAX_WIDTH, PSLISTVIEWCELL_ROW_HEIGHT)];
    
    currentFrame = CGRectMake(priceXOffset, currentHeight, priceTextSize.width, PSLISTVIEWCELL_ROW_HEIGHT);
	priceLabel.frame = currentFrame;
    
    CGFloat priceChangeIconOriginX = currentFrame.origin.x + currentFrame.size.width + PSLISTVIEWCELL_PADDING;
    
    self.monthLabel.hidden = !([[listing getListingData:ListingDataIndexType] isEqualToString:IC_INDEXTYPE_FORRENT] && ([listing getListingData:ListingDataPrice] || [listing getListingData:ListingDataPriceMax] || [listing getListingData:ListingDataPriceMin]));
    
    CGSize monthLabelSize = CGSizeZero;
    
    if (!self.monthLabel.hidden) {
        monthLabelSize = [monthLabel.text sizeWithFont:monthLabel.font];
        monthLabel.frame = CGRectMake(priceLabel.frame.origin.x + priceLabel.frame.size.width, currentHeight, monthLabelSize.width, PSLISTVIEWCELL_ROW_HEIGHT);
    }
    
    currentHeight += PSLISTVIEWCELL_ROW_HEIGHT;
    
    NSString *addressText = [listing getListingData:ListingDataStreetDisplay];
    self.addressLabel.text = [addressText length] > 0 ? addressText : [listing getListingData:ListingDataNeighborhood];
    
    CGSize addressTextSize = [self.addressLabel.text sizeWithFont:self.addressLabel.font constrainedToSize:CGSizeMake(LABEL_MAX_WIDTH, PSLISTVIEWCELL_ROW_HEIGHT)];
    
    if([self hasDistance]) {
        CGFloat distanceWidth = 50.0f;
        //CGFloat distance = [ICListingFormatter calculateDistanceFromCentroid:epiCenter forListing:listing];
        distanceLabel.text = [NSString stringWithFormat:@"%.1f mi", [distance floatValue]];
        
        distanceLabel.frame = CGRectMake((contentRect.size.width - distanceWidth), PSLISTVIEWCELL_ROW_HEIGHT + PSLISTVIEWCELL_TOP_GUTTER *1.5, (distanceWidth - PSLISTVIEWCELL_LEFT_GUTTER), PSLISTVIEWCELL_ROW_HEIGHT);
        
        if([self.addressLabel.text length] > 0){
            addressLabel.frame = CGRectMake(xOffsetForText, currentHeight, addressTextSize.width, PSLISTVIEWCELL_ROW_HEIGHT);
            currentHeight += PSLISTVIEWCELL_ROW_HEIGHT;
        }
        
	} else {
        distanceLabel.text = @"";
        
        if([self.addressLabel.text length] > 0){
            addressLabel.frame = CGRectMake(xOffsetForText,currentHeight, addressTextSize.width, PSLISTVIEWCELL_ROW_HEIGHT);
            currentHeight += PSLISTVIEWCELL_ROW_HEIGHT;
        }
	}
    
#define PADDINGBETWEENADDRESS_AND_COMMUNITY 20
    if ([[listing getListingData:ListingDataIndexType] isEqualToString:IC_INDEXTYPE_FORRENT]) {
        
        // Community label
        currentHeight += PADDINGBETWEENADDRESS_AND_COMMUNITY;
        if ([listing getListingData:ListingDataComplexName] != nil) {
            currentFrame = CGRectMake(xOffsetForText, currentHeight, PSLISTVIEWCELL_LABEL_WIDTH, PSLISTVIEWCELL_ROW_HEIGHT);
            communityNameLabel.frame = currentFrame;
            communityNameLabel.text = [listing getListingData:ListingDataComplexName];
            currentHeight += PSLISTVIEWCELL_ROW_HEIGHT;
        }        
        
        
    } else if ([[listing getListingData:ListingDataIndexType] isEqualToString:IC_INDEXTYPE_SOLD]) {
        
        // Reuse the price change label for the "Sold on" text
        if ([listing getListingData:ListingDataDateSold]) {
            
            currentHeight -= PSLISTVIEWCELL_ROW_HEIGHT;
            
            if([listing getListingData:ListingDataEstimatedPrice]){
                
                self.estimatesLabel.frame = CGRectMake(xOffsetForText, currentHeight, PSLISTVIEWCELL_LABEL_WIDTH, PSLISTVIEWCELL_ROW_HEIGHT);
                self.estimatesLabel.hidden = NO;
                self.estimatesLabel.text = [NSString stringWithFormat:@"%@ Estimate", [ICListingFormatter formatPrice:[listing getListingData:ListingDataEstimatedPrice]]];
                self.estimatesLabel.textColor = [UIColor blackColor];
                currentHeight += PSLISTVIEWCELL_ROW_HEIGHT;
            }else{
                self.estimatesLabel.text = @"";
                self.estimatesLabel.hidden = YES;
            }
            
            NSDate *soldDate = [self.dateFormatter dateFromString:[listing getListingData:ListingDataDateSold]];
            NSInteger numberOfDays = [ICListingFormatter daysFromDate:soldDate toDate:[NSDate date]];
            NSString *changeDateLabelText = numberOfDays > 0 ? [NSString stringWithFormat:@"Sold %d days ago", numberOfDays] : @""; 
            priceChangeDateLabel.text = changeDateLabelText;
            priceChangeDateLabel.textColor = [UIColor IARedPriceColor];
            priceChangeDateLabel.frame =  CGRectMake(priceChangeIconOriginX, yOffsetFromOrigin, PSLISTDATECHANGE_LABEL_WIDTH, PSLISTVIEWCELL_ROW_HEIGHT);
        }
        
        addressLabel.frame = CGRectMake(xOffsetForText,currentHeight, addressTextSize.width, PSLISTVIEWCELL_ROW_HEIGHT);
        currentHeight += PSLISTVIEWCELL_ROW_HEIGHT;
        
    }else if([[listing getListingData:ListingDataIndexType] isEqualToString:IC_INDEXTYPE_ASSESSOR]){
        
        if([listing getListingData:ListingDataEstimatedPrice]){
            self.priceLabel.text = [NSString stringWithFormat:@"%@ Estimate", [ICSubListingFormatter condensedPriceWithListing:listing]];
            CGSize priceTextSize = [priceLabel.text sizeWithFont:priceLabel.font constrainedToSize:CGSizeMake(PSLISTVIEWCELL_PRICE_LABEL_MAX_WIDTH, PSLISTVIEWCELL_ROW_HEIGHT)];
            CGRect priceLabelFrame = self.priceLabel.frame;
            priceLabelFrame.size.width = priceTextSize.width;
            self.priceLabel.frame = priceLabelFrame;
        }else{
            self.priceLabel.text = @"";
            currentHeight -= PSLISTVIEWCELL_ROW_HEIGHT * 2;
            addressLabel.frame = CGRectMake(xOffsetForText,currentHeight, addressTextSize.width, PSLISTVIEWCELL_ROW_HEIGHT);
            currentHeight += PSLISTVIEWCELL_ROW_HEIGHT;
        }
    }else {
        
        if([listing getListingData:ListingDataPriceChange] && [listing getListingData:ListingDataPriceChangeDate] && ![[listing getListingData:ListingDataPriceChange] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            
            NSString *changeLabelText = [numberFormatter stringFromNumber:[listing getListingData:ListingDataPriceChange]];
            GRLog5(@"PriceChange is: %@",changeLabelText);
            priceChangeLabel.text = changeLabelText;
            
            CGSize priceChangeLabelSize = [changeLabelText sizeWithFont:self.priceChangeLabel.font constrainedToSize:CGSizeMake(PSLISTVIEWCELL_PRICECHANGE_LABEL_MAX_WIDTH, PSLISTVIEWCELL_ROW_HEIGHT)];
            
            CGFloat iconWidth = 12.0f;
            priceChangeIcon.frame = CGRectMake(priceChangeIconOriginX, yOffsetFromOrigin + 4.0f , iconWidth, 12.0f);
            priceChangeLabel.frame =  CGRectMake((priceChangeIconOriginX + iconWidth + 2.0f), yOffsetFromOrigin, priceChangeLabelSize.width, PSLISTVIEWCELL_ROW_HEIGHT);
            
            if (!shortDateFormatter) {
                shortDateFormatter = [[NSDateFormatter alloc] init];
                [shortDateFormatter setDateFormat:@"MM/dd/yyyy"];
            }        
            
            if ([[listing getListingData:ListingDataPriceChange] intValue] < 0) {
                CGRect frame = self.priceChangeIcon.frame;
                frame.origin.y -= 2.0f;
                self.priceChangeIcon.frame = frame;
                priceChangeIcon.image = [ICImageBundleUtil imageNamed:@"IconPriceUp"];
                priceChangeLabel.textColor = [UIColor IARedPriceColor];
            }
            
            priceChangeIcon.hidden = NO;
        }
    }
	
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setUsesGroupingSeparator:YES];
    
    
    NSString *bedBathString = [ICSubListingFormatter condensedBedBathSqftWithListing:listing];
    if(bedBathString != nil && [bedBathString length] > 0){
        infoLabel.text = bedBathString;
		currentFrame = CGRectMake(xOffsetForText, currentHeight, PSLISTVIEWCELL_LABEL_WIDTH, PSLISTVIEWCELL_ROW_HEIGHT);
		infoLabel.frame = currentFrame;
        currentHeight += PSLISTVIEWCELL_ROW_HEIGHT;
    }
    currentHeight += 5.0f;

	if ([listing getListingData:ListingDataPropertyType] != nil && [listing getListingData:ListingDataComplexName] == nil) {
		currentFrame = CGRectMake(xOffsetForText, currentHeight, PSLISTVIEWCELL_LABEL_WIDTH, PSLISTVIEWCELL_ROW_HEIGHT);
		typeLabel.frame = currentFrame;
		typeLabel.text = [listing getListingData:ListingDataPropertyType];
        currentHeight += PSLISTVIEWCELL_ROW_HEIGHT;
	}
    
    if ([listing getListingData:ListingDataOpenHouse] != nil) {
        self.openHomeLabel.hidden = NO;
        currentFrame = CGRectMake(xOffsetForText, currentHeight + 3.0, PSLISTVIEWCELL_OPENHOME_LABEL_SIZE_WIDTH, PSLISTVIEWCELL_OPENHOME_LABEL_SIZE_HEIGHT);
		openHomeLabel.frame = currentFrame;
		openHomeLabel.text = @"Open House";
        currentHeight += PSLISTVIEWCELL_OPENHOME_LABEL_SIZE_HEIGHT;
    }else{
        self.openHomeLabel.hidden = YES;
    }

    self.favoriteIcon.hidden = YES;
    self.propertyImage.frame = CGRectMake(0, 0 , (PSLISTVIEWCELL_IMAGE_WIDTH ), (self.contentView.bounds.size.height));
    if(listing.isBranded)
    {
        [self.brandingImageView setImageWithUrl:[listing brandImageUrlStringForMarker] placeHolderImage:nil];
        self.brandingImageView.hidden = NO;
    }
    else
        self.brandingImageView.hidden = YES;
}

#define NO_LISTING_IMAGE_NAME @"NoPhotoListing.png"

- (void)showImageThumbnailIfExists {
    if ([listing getListingData:ListingDataPicThumb] != nil)
        [self.propertyImage setImageWithUrl:[listing getListingData:ListingDataPicLarge] placeHolderImage:[UIImage imageNamed:NO_LISTING_IMAGE_NAME] scaleAndCropToSize:CGSizeMake(PSLISTVIEWCELL_IMAGE_WIDTH, self.contentView.bounds.size.height) fadeEnabled:NO];
}

#pragma mark -
#pragma mark Object management

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier; {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if(!self)
        return self;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *theBackgroundPatternView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BgCellSelectionPattern.png"]];
    self.selectedBackgroundView = theBackgroundPatternView;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.editingAccessoryView = nil;
    
    @autoreleasepool {
        UIColor *secondaryLabelColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.opaque = NO;
        addressLabel.textColor = [UIColor blackColor];
        addressLabel.highlightedTextColor = [UIColor truliaGreyColor];
        addressLabel.font = [ICFont extraSmallFont];
        addressLabel.textAlignment = UITextAlignmentLeft;
        [self.contentView addSubview:addressLabel];
        
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.opaque = NO;
        distanceLabel.textColor = secondaryLabelColor;
        distanceLabel.highlightedTextColor = [UIColor truliaGreyColor];
        distanceLabel.font = [UIFont systemFontOfSize:12];
        distanceLabel.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:distanceLabel];
        
        self.openHomeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        openHomeLabel.backgroundColor = [UIColor truliaOpenHouseLabelBackgroundColor]; 
        openHomeLabel.opaque = NO;
        openHomeLabel.textColor = [UIColor whiteColor];
       // openHomeLabel.highlightedTextColor = [UIColor whiteColor];
        openHomeLabel.font = [UIFont boldSystemFontOfSize:11];
        openHomeLabel.textAlignment = UITextAlignmentCenter;
        openHomeLabel.layer.cornerRadius = 4.0f;
        [self.contentView addSubview:openHomeLabel];
        
        
        self.propertyNewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        propertyNewLabel.backgroundColor = [UIColor clearColor];
        propertyNewLabel.opaque = NO;
        propertyNewLabel.textColor = [UIColor truliaGreenColor];
       // propertyNewLabel.highlightedTextColor = [UIColor whiteColor];
        propertyNewLabel.font = [UIFont boldSystemFontOfSize:14];
        
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.opaque = NO;
        priceLabel.textColor = [UIColor blackColor];
        priceLabel.highlightedTextColor = [UIColor whiteColor];
        priceLabel.font = [ICFont smallBoldFont];
        [self.contentView addSubview:priceLabel];
        
        self.monthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        monthLabel.backgroundColor = [UIColor clearColor];
        monthLabel.opaque = NO;
        monthLabel.textColor = [UIColor blackColor];
        monthLabel.highlightedTextColor = [UIColor truliaGreyColor];
        monthLabel.font = [ICFont smallBoldFont];
        monthLabel.hidden = YES;
        monthLabel.text = @"/mo";
        [self.contentView addSubview:monthLabel];
        
        self.priceChangeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        priceChangeLabel.backgroundColor = [UIColor clearColor];
        priceChangeLabel.opaque = NO;
        priceChangeLabel.font = [ICFont smallBoldFont];
        priceChangeLabel.textColor = [UIColor blackColor];
        priceChangeLabel.highlightedTextColor = [UIColor whiteColor];
        [self.contentView addSubview:priceChangeLabel];
        
        self.priceChangeDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        priceChangeDateLabel.backgroundColor = [UIColor clearColor];
        priceChangeDateLabel.opaque = NO;
        priceChangeDateLabel.font = [UIFont systemFontOfSize:14];
        priceChangeDateLabel.highlightedTextColor = [UIColor whiteColor];
        priceChangeDateLabel.textColor = secondaryLabelColor;
        [self.contentView addSubview:priceChangeDateLabel];
        
        self.estimatesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        estimatesLabel.backgroundColor = [UIColor clearColor];
        estimatesLabel.opaque = NO;
        estimatesLabel.font = [UIFont systemFontOfSize:14];
        estimatesLabel.highlightedTextColor = [UIColor truliaGreyColor];

      //  estimatesLabel.textColor = secondaryLabelColor;
        [self.contentView addSubview:estimatesLabel];
        
        self.priceChangeIcon = [[UIImageView alloc] init]; 
        [self.contentView addSubview:priceChangeIcon];
        
        self.squareFootLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        squareFootLabel.backgroundColor = [UIColor clearColor];
        squareFootLabel.opaque = NO;
        squareFootLabel.textColor = secondaryLabelColor;
            squareFootLabel.highlightedTextColor = [UIColor truliaGreyColor];
        squareFootLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:squareFootLabel];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.opaque = NO;
        infoLabel.textColor = secondaryLabelColor;
        infoLabel.highlightedTextColor = [UIColor truliaGreyColor];
        infoLabel.font = [ICFont extraSmallFont];
        infoLabel.numberOfLines = 0;
        [self.contentView addSubview:infoLabel];
        
        self.communityNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        communityNameLabel.backgroundColor = [UIColor clearColor];
        communityNameLabel.opaque = NO;
        communityNameLabel.textColor = secondaryLabelColor;
        communityNameLabel.highlightedTextColor = [UIColor truliaGreyColor];
        communityNameLabel.font = [ICFont extraSmallFont];
        [self.contentView addSubview:communityNameLabel];
        
        self.floorplansLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        floorplansLabel.backgroundColor = [UIColor clearColor];
        floorplansLabel.opaque = NO;
        floorplansLabel.textColor = secondaryLabelColor;
        floorplansLabel.font = [UIFont systemFontOfSize:14];
        floorplansLabel.highlightedTextColor = [UIColor truliaGreyColor];
        [self.contentView addSubview:floorplansLabel];
        
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        typeLabel.backgroundColor = [UIColor clearColor];
        typeLabel.opaque = NO;
        typeLabel.textColor = secondaryLabelColor;
        typeLabel.font = [ICFont extraSmallFont];
        typeLabel.highlightedTextColor = [UIColor truliaGreyColor];
        [self.contentView addSubview:typeLabel];
    
        CGFloat borderWidth = 2.0f;
        CGRect imageFrame = CGRectMake(0, 0 , (PSLISTVIEWCELL_IMAGE_WIDTH ), (self.bounds.size.height));

        self.propertyImage = [[ICImageView alloc] initWithFrame:imageFrame];
        self.propertyImage.contentMode = UIViewContentModeScaleAspectFit;
        self.propertyImage.clipsToBounds = YES;
        self.propertyImage.backgroundColor = [UIColor clearColor];
        self.propertyImage.opaque = YES;
        
        [self.contentView addSubview:self.propertyImage];
        CGRect brandingImageFrame = CGRectMake(imageFrame.origin.x + ((imageFrame.size.width - BRANDING_SRP_LOGO_WIDTH) / 2), imageFrame.origin.y + imageFrame.size.height + (borderWidth * 3), BRANDING_SRP_LOGO_WIDTH, BRANDING_SRP_LOGO_HEIGHT);
            
        self.brandingImageView = [[ICImageView alloc] initWithFrame:brandingImageFrame];
        self.brandingImageView.hidden = YES;
        [self.contentView addSubview:self.brandingImageView];

        self.favoriteIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"markerFavoriteGreen.png"]];
        CGRect favoriteFrame = self.favoriteIcon.frame;
        
        NSInteger heartTransparencyHeight = 14;
        NSInteger heartOverflowTop = 4;
        
        NSInteger heartTransparencyWidth = 6;
        NSInteger heartOverflowLeft = 3;
        
        favoriteFrame.origin.x = imageFrame.origin.x - (heartTransparencyWidth + heartOverflowLeft + (borderWidth * 2));
        favoriteFrame.origin.y = imageFrame.origin.y - (heartTransparencyHeight + heartOverflowTop + (borderWidth * 2));
        
        self.favoriteIcon.frame = favoriteFrame;
        [self.contentView addSubview:self.favoriteIcon];
        
        self.mayShowFavoriteIcon = YES;
        
        self.hackyBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.hackyBackgroundView.backgroundColor = [UIColor clearColor];
        self.hackyBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:self.hackyBackgroundView];
        [self.contentView sendSubviewToBack:self.hackyBackgroundView];
        
        // set selection color
        /*UIView *myBackView = [[UIView alloc] initWithFrame:self.bounds];
        myBackView.backgroundColor = [UIColor truliaDarkGrey];
        self.selectedBackgroundView = myBackView;*/

        return self;
	}
}

- (void)selectMe:(BOOL)selected {
    self.hackyBackgroundView.backgroundColor = selected ? [UIColor lightGrayColor] : [UIColor clearColor];
    [self setNeedsDisplay];
}

- (void)reset {
    
    //GRLog(@"- - resetting cell with index: %i", self.index);
    
    if([propertyNewLabel isDescendantOfView:self])
        [propertyNewLabel removeFromSuperview];
    
    [propertyNewLabel removeFromSuperview];
    priceChangeDateLabel.textColor = [UIColor truliaGreyListTextColor];
    priceLabel.textColor = [UIColor blackColor];
	addressLabel.text = @"";
	distanceLabel.text = @"";
	priceLabel.text = @"";
	infoLabel.text = @"";
	typeLabel.text = @"";
    floorplansLabel.text = @"";
    communityNameLabel.text = @"";
	openHomeLabel.text = @"";
	openHomeTimeLabel.text = @"";
	priceChangeLabel.text = @"";
    priceChangeDateLabel.text = @"";
    squareFootLabel.text = @"";
    estimatesLabel.text = @"";
	priceChangeLabel.textColor = [UIColor IAGreenPriceColor];
	priceChangeIcon.image = [ICImageBundleUtil imageNamed:@"IconPriceDown"];
    priceChangeIcon.hidden = YES;
    favoriteIcon.hidden = YES;
    monthLabel.hidden = YES;
    
    self.hackyBackgroundView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{

    [super setSelected:selected animated:animated];
    self.openHomeLabel.backgroundColor = [UIColor truliaOpenHouseLabelBackgroundColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{

    [super setSelected:highlighted animated:animated];
    self.openHomeLabel.backgroundColor = [UIColor truliaOpenHouseLabelBackgroundColor];
}

@end
