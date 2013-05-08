//
//  IAListingCalloutView_iPhone.m
//  Trulia
//
//  Created by Daniel Lowrie on 1/24/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import "IAListingPDPSneakView.h"
#import "ICListing.h"
#import "ICListingFormatter.h"
#import "ICSubListingFormatter.h"
#import "ICListingSearchController.h"
#import "IosCoreConstants.h"
#import "IA+UIColor.h"
#import "ICImageBundleUtil.h"
#import "ICImageView.h"
#import "ICFont.h"

#import <QuartzCore/QuartzCore.h>

#define HFPC_LEFT_COLUMN_OFFSET			94
#define HFPC_RIGHT_COLUMN_WIDTH			200

static CGFloat CALLOUT_TOP_GUTTER = 0.0f;
static CGFloat CALLOUT_PROPERTY_IMAGE_WIDTH = 40.0f;
static CGFloat CALLOUT_PROPERTY_IMAGE_HEIGHT = 40.0f;
static CGFloat CALLOUT_PROPERTY_IMAGE_OFFSET = 20.0f;
//static CGFloat CALLOUT_PADDING = 0.0f;
static CGFloat LABEL_MAX_WIDTH = 180.0f;

@interface IAListingPDPSneakView (Private)
- (void)reset;
@end

@implementation IAListingPDPSneakView
@synthesize index = _index;
@synthesize indexType = _indexType;

@synthesize delegate = _delegate;
@synthesize bgImage = _bgImage;

@synthesize propertyImageGrayBorder = _propertyImageGrayBorder;
@synthesize propertyImageWhiteBorder = _propertyImageWhiteBorder;

@synthesize addressLabel = _addressLabel;
@synthesize priceLabel = _priceLabel;
@synthesize defaultImageThumbnail = _defaultImageThumbnail;
@synthesize propertyImage = _propertyImage;

#pragma mark -
#pragma mark Utility methods

- (void)updatePriceColorForAnnotationState:(AnnotationState)currentAnnotationState; {
    self.priceLabel.textColor = [UIColor blackColor];
}

- (void)reset{
	_addressLabel.text = @"";
	_priceLabel.text = @"";
	_propertyImage.image = nil;
    
}

- (void)setIndex:(NSInteger)pIndex withIndexType:(NSString *)pIndexType {
    self.index = pIndex;
    self.indexType = pIndexType;
    
    [self reset];
    ICListing *listing = [[ICListingSearchController sharedInstance] getListingAtIndex:_index withIndexType:_indexType callPaging:NO];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[numberFormatter setLocale:usLocale];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setUsesGroupingSeparator:YES];
	[numberFormatter setAlwaysShowsDecimalSeparator:NO];
	[numberFormatter setMaximumFractionDigits:0];
    
    numberFormatter.negativeFormat = numberFormatter.positiveFormat;
    numberFormatter.negativePrefix = numberFormatter.positivePrefix;
        
    // Format the text
	self.priceLabel.text = [ICListingFormatter condensedPriceWithListing:listing];
	if (self.priceLabel.text == nil) {
		self.priceLabel.text = @"Contact";
		
        if ([[listing getListingData:ListingDataIndexType] isEqualToString:IC_INDEXTYPE_SOLD])
			self.priceLabel.text = @"N/A";
	}
    
    if ([[listing getListingData:ListingDataIndexType] isEqualToString:IC_INDEXTYPE_ASSESSOR]){
        
        if([listing getListingData:ListingDataEstimatedPrice]){
            self.priceLabel.text = [NSString stringWithFormat:@"%@ Estimate", [ICSubListingFormatter condensedPriceWithListing:listing]];
        }else{
            self.priceLabel.text = @"";
        }
    }
    
    self.priceLabel.textColor = ([[listing getListingData:ListingDataIndexType] isEqualToString:IC_INDEXTYPE_SOLD]) ? [UIColor IARedPriceColor]: [UIColor blackColor];
    
	// update value in subviews
	NSString *addressText = [listing getListingData:ListingDataStreetDisplay];
    [addressText length] > 0 ? addressText : [listing getListingData:ListingDataNeighborhood];
	self.addressLabel.text = addressText;
	NSMutableString *infoString = [NSMutableString string];
    
    BOOL showingCommunityName = ([[listing getListingData:ListingDataIndexType] isEqualToString: IC_INDEXTYPE_FORRENT] && [listing getListingData:ListingDataComplexName] != nil);
    
    if (showingCommunityName)
        [infoString appendFormat:@"%@\n", [listing getListingData:ListingDataComplexName]];
    
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	
    NSString *bedBathString = [ICSubListingFormatter condensedBedBathSqftWithListing:listing];
    if(bedBathString != nil && [bedBathString length] > 0)
        [infoString appendFormat:@"%@\n",bedBathString];
	
    if ([listing getListingData:ListingDataPropertyType] != nil)
        [infoString appendFormat:@"%@", [[listing getListingData:ListingDataPropertyType] capitalizedString]];
    
	if ([listing getListingData:ListingDataPicThumb] != nil)
        [self.propertyImage setImageWithUrl:[listing getListingData:ListingDataPicThumb] placeHolderImage:[UIImage imageNamed:@"NoPhotoListing.png"]  fadeEnabled:YES];
    else
        self.propertyImage.image = [UIImage imageNamed:@"NoPhotoListing.png"];
    
    if ([listing getListingData:ListingDataPriceChangeDate] != nil && [listing getListingData:ListingDataPriceChange] != nil && ![[listing getListingData:ListingDataPriceChange] isEqualToNumber:[NSNumber numberWithInt:0]]) {
		
		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    [self setNeedsLayout];
}
#pragma mark -

#define PRICE_LABEL_HEIGHT          18.0f
#define ADDRESS_LABEL_HEIGHT        18.0f
#define INFO_LABEL_HEIGHT           18.0f
#define BROKER_LABEL_HEIGHT         20.0f
#define BORDER_WIDTH                1.0f

-(ICListing*)getListing{
    return  [[ICListingSearchController sharedInstance] getListingAtIndex:_index withIndexType:_indexType callPaging:NO];
}
#pragma mark View lifecycle

- (void)layoutSubviews; {
	[super layoutSubviews];
    
    int xOffset = 0;

    CGRect contentRect = [self bounds];   
    CGFloat xOffsetForText = contentRect.origin.x + xOffset + CALLOUT_PROPERTY_IMAGE_WIDTH + 5;
    CGFloat currentHeight = 5;
    CGFloat priceLabelHeight = PRICE_LABEL_HEIGHT, priceLabelOffset = 0.0f;
    CGFloat addressLabelHeight = ADDRESS_LABEL_HEIGHT;
	CGRect currentFrame;
	CGSize priceLabelTextSize = [self.priceLabel.text sizeWithFont:self.priceLabel.font];
    
    currentFrame = CGRectMake(xOffsetForText, currentHeight, priceLabelTextSize.width, priceLabelHeight);
    self.priceLabel.frame = currentFrame;
    priceLabelOffset = currentFrame.origin.x + priceLabelTextSize.width;

    if([self.priceLabel.text length] > 0){
        currentHeight += currentFrame.size.height;
    }
    
    if([self.addressLabel.text length] > 0){
        CGSize addressTextSize = [self.addressLabel.text sizeWithFont:self.addressLabel.font constrainedToSize:CGSizeMake(LABEL_MAX_WIDTH, addressLabelHeight)];
        currentFrame = CGRectMake(xOffsetForText, currentHeight, addressTextSize.width, addressLabelHeight);
        self.addressLabel.frame = currentFrame;
        currentHeight += currentFrame.size.height + 5.0f;
    }
    
    // This is the frame for the image itself
	currentFrame = CGRectMake(contentRect.origin.x+xOffset, CALLOUT_TOP_GUTTER * 3, CALLOUT_PROPERTY_IMAGE_WIDTH, CALLOUT_PROPERTY_IMAGE_HEIGHT);
        
    _propertyImage.frame = currentFrame;
    [_propertyImage setClipsToBounds:YES];
    _propertyImage.backgroundColor = [UIColor whiteColor];
    _propertyImage.opaque = YES;
    _propertyImage.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0].CGColor;
    _propertyImage.layer.borderWidth = 1.0;
    
    GRLog5(@"CurrentHieght is: %f",currentHeight);
    CGRect frame = self.frame;
       
    frame.size.height = currentHeight > CALLOUT_PROPERTY_IMAGE_HEIGHT +  CALLOUT_PROPERTY_IMAGE_OFFSET ? currentHeight+(CALLOUT_TOP_GUTTER * 2): CALLOUT_PROPERTY_IMAGE_HEIGHT +  CALLOUT_PROPERTY_IMAGE_OFFSET + (CALLOUT_TOP_GUTTER * 2);
}

-(void)hide; {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];	
	self.alpha = 0.0f;
    [UIView commitAnimations];  
}

-(void)show; {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];	
	self.alpha = 0.85f;
    [UIView commitAnimations];    
}

#pragma mark -
#pragma mark Object management

- (id)initWithFrame:(CGRect)frame; {
	if (!(self = [super initWithFrame:frame]))
		return self;
	
	self.hidden = NO;
	self.opaque = NO;
	self.alpha = 1.0f;
	self.multipleTouchEnabled = YES;
	self.exclusiveTouch = YES;
	self.userInteractionEnabled = YES;
    
	self.bgImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"BgCalloutLtGray.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:0]];
    _bgImage.frame = frame;
    [_bgImage setAlpha:0.95];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.4f;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowRadius = 1.0f;
    
    
	//[self addSubview:_bgImage];
	
	_addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_addressLabel.backgroundColor = [UIColor clearColor];
	_addressLabel.opaque = NO;
	_addressLabel.textColor = [UIColor blackColor];
	_addressLabel.highlightedTextColor = [UIColor whiteColor];
	_addressLabel.font = [ICFont extraSmallFont];
    _addressLabel.textAlignment = UITextAlignmentLeft;
	[self addSubview:_addressLabel];
	
	_priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_priceLabel.backgroundColor = [UIColor clearColor];
	_priceLabel.opaque = NO;
	_priceLabel.textColor = [UIColor blackColor];
	_priceLabel.highlightedTextColor = [UIColor whiteColor];
	_priceLabel.font = [ICFont smallBoldFont];
	[self addSubview:_priceLabel];
    
    CGFloat borderWidth = 1.0f;
    CGRect imageFrame = CGRectMake(8.0f, 28.0f, 74.0f, 54.0f);    
    
    self.propertyImageGrayBorder = [[UIView alloc] initWithFrame:imageFrame];
    _propertyImageGrayBorder.backgroundColor = [UIColor truliaGreyThumbnailBorderColor];
    //[self addSubview:_propertyImageGrayBorder];
    
    imageFrame = CGRectInset(imageFrame, borderWidth, borderWidth);
    
    self.propertyImageWhiteBorder = [[UIView alloc] initWithFrame:imageFrame];
    _propertyImageWhiteBorder.backgroundColor = [UIColor whiteColor];
    //[self addSubview:_propertyImageWhiteBorder];
    
    imageFrame = CGRectInset(imageFrame, borderWidth, borderWidth);
    
    _propertyImage = [[ICImageView alloc] initWithFrame:imageFrame];
    [_propertyImage setImage:[UIImage imageNamed:@"NoPhotoListing.png"]];
    _propertyImage.contentMode = UIViewContentModeScaleAspectFit;
	[self addSubview:_propertyImage];
    
    
	return self;
}

- (void)dealloc{
    
    self.delegate = nil;
}


@end
