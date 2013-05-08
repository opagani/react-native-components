//
//  TruliaDataMigrationUtility.m
//  Trulia
//
//  Created by Dan Lowrie on 3/29/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import "TruliaDataMigrationUtility.h"
#import "TruliaBaseProperty.h"
#import "TruliaSearchParameters.h"
#import "ICCoreDataController.h"
#import "TruliaDataController.h"
#import "ICUtility.h"
#import "ICManagedListing.h"
#import "ICManagedSearch.h"
#import "ICListingParameters.h"

@implementation TruliaDataMigrationUtility

-(NSString *)priceFormatter:(int)price{
    
    NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[priceFormatter setLocale:usLocale];
    
	[priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [priceFormatter setUsesGroupingSeparator:YES];
	[priceFormatter setAlwaysShowsDecimalSeparator:NO];
	[priceFormatter setMaximumFractionDigits:0];
    priceFormatter.negativeFormat = priceFormatter.positiveFormat;
    priceFormatter.negativePrefix = priceFormatter.positivePrefix;  
    
    NSString *returnString = [priceFormatter stringFromNumber:[NSNumber numberWithInt:price]];
    
    
    return returnString;
    
}


- (ICManagedListing *)managedListingFromTruliaBaseProperty:(TruliaBaseProperty *)truliaBaseProperty {
    
    ICManagedListing *managedListing = (ICManagedListing *)[NSEntityDescription insertNewObjectForEntityForName:@"ICManagedListing" inManagedObjectContext:[ICCoreDataController sharedInstance].mainObjectContext];
    
    
    managedListing.ba = [truliaBaseProperty.bathrooms stringValue];
    managedListing.baf = [truliaBaseProperty.bathroomsFull stringValue];
    managedListing.ban = [truliaBaseProperty.bathroomsMinimum stringValue];
    managedListing.bax = [truliaBaseProperty.bathroomsMaximum stringValue];
    
    managedListing.bd = [truliaBaseProperty.bedrooms stringValue];
    managedListing.bdn = [truliaBaseProperty.bedroomsMaximum stringValue];
    managedListing.bdx = [truliaBaseProperty.bedroomsMaximum stringValue];
    
    managedListing.cy = truliaBaseProperty.city;
    managedListing.cs = truliaBaseProperty.cityState;
    managedListing.cyd = truliaBaseProperty.cityDisplay;
    managedListing.cty = truliaBaseProperty.county;
    
    int dtpInt = (int)floor([[NSDate date] timeIntervalSinceDate:truliaBaseProperty.dateListed]);  
    managedListing.dtp = [NSNumber numberWithInt:dtpInt];
    
    managedListing.fpc = [truliaBaseProperty.floorPlanCount stringValue];
//    managedListing.ft = ???;
    
    managedListing.id = [truliaBaseProperty.propertyId stringValue];
    managedListing.idOriginal = [truliaBaseProperty.propertyId stringValue];
    
    managedListing.idt = truliaBaseProperty.indexType;
    managedListing.idtOriginal = truliaBaseProperty.indexType;
    
    managedListing.lt = truliaBaseProperty.listingType;
    managedListing.lat = [truliaBaseProperty.latitude stringValue];
    managedListing.lon = [truliaBaseProperty.longitude stringValue];
    
    managedListing.murl = truliaBaseProperty.siteUrl;
    managedListing.ml = truliaBaseProperty.mlsId;
    
    managedListing.nh = truliaBaseProperty.neighborhood;
    managedListing.nm = truliaBaseProperty.communityName;
    
    managedListing.prc = [truliaBaseProperty.price stringValue];
    managedListing.prn = [truliaBaseProperty.priceMinimum stringValue];
    managedListing.prx = [truliaBaseProperty.priceMaximum stringValue];
    managedListing.pl = truliaBaseProperty.thumbnailUrlLarge;
    managedListing.pb = truliaBaseProperty.thumbnailUrl;
//    managedListing.pcn = ???not persisted???;
    managedListing.pt = truliaBaseProperty.propertyType;
    
    managedListing.sq = [truliaBaseProperty.squareFeet stringValue];
    managedListing.sqn = [truliaBaseProperty.squareFeetMinimum stringValue];
    managedListing.sqx = [truliaBaseProperty.squareFeetMaximum stringValue];
    
    managedListing.st = truliaBaseProperty.state;
    managedListing.sta = truliaBaseProperty.status;
    
    managedListing.str = truliaBaseProperty.street;
    
    managedListing.std = truliaBaseProperty.streetDisplay;
    
    managedListing.stn = truliaBaseProperty.streetNumber;
    
    
    managedListing.url = truliaBaseProperty.siteUrl;
    managedListing.zip = truliaBaseProperty.zipCode;
    
    return managedListing;
    
    
}

- (ICManagedSearch *)managedSearchFromTruliaBaseProperty:(TruliaSearchParameters *)truliaSearchParameters {
    
    ICManagedSearch *managedSearch = (ICManagedSearch *)[NSEntityDescription insertNewObjectForEntityForName:@"ICManagedSearch" inManagedObjectContext:[ICCoreDataController sharedInstance].mainObjectContext];
    
    
    managedSearch.indexType = truliaSearchParameters.indexType;
    managedSearch.locationString = [truliaSearchParameters freeSearchTextOrCityStateWithStaticLocations:YES includeNearbyLocations:YES includeNearbyPrefix:YES];    
    managedSearch.serverHash = truliaSearchParameters.searchHash;
    managedSearch.url = [ICManagedSearch formattedUriWithUri:truliaSearchParameters.truliaURI];
    
    ICListingParameters *listingParameters = [ICListingParameters listingParametersWithManagedSearch:managedSearch];
    
    NSString *minPrice;
    NSString *maxPrice;
    NSString *priceString;
    NSMutableArray *titleComponents = [NSMutableArray array];
    if(!listingParameters.maxPrice){
        
        maxPrice = @"Max";
    }else{
        maxPrice = [self priceFormatter:[listingParameters.maxPrice intValue]];
    }
    
    if(!listingParameters.minPrice){
        
        minPrice = @"Min";
    }else{
        minPrice = [self priceFormatter:[listingParameters.minPrice intValue]];
    }
    priceString = [NSString stringWithFormat:@"%@ - %@",minPrice,maxPrice];
    if ([priceString isEqualToString:@"Min - Max"]) {
        priceString = @"All Prices";
    }
    
    if (![ICUtility isEmptyString:priceString]) {
        [titleComponents addObject:priceString];
    }
    
    
    NSString *propertyTypeString = @"";
    if (listingParameters.propertyType != nil && [listingParameters.propertyType count]) {
        NSString *tmpLabel = [listingParameters.propertyType componentsJoinedByString:@", "];
        propertyTypeString = [listingParameters.propertyType componentsJoinedByString:@", "];
        CGSize size = [tmpLabel sizeWithFont:[UIFont systemFontOfSize:14.0]];
        if(size.width > 150) {
            while (size.width > 150) {
                tmpLabel = [tmpLabel substringToIndex:[tmpLabel length]-1];
                size = [tmpLabel sizeWithFont:[UIFont systemFontOfSize:14.0]];
            }
            propertyTypeString = [tmpLabel stringByAppendingString:@"..."];
        }
    }
    
    if (![ICUtility isEmptyString:propertyTypeString]) {
        [titleComponents addObject:propertyTypeString];
    }
    
    
    NSString *bedString = @"";
    NSInteger bedsValue = listingParameters.minBedroom ? [listingParameters.minBedroom intValue] : 0;
    
    if (bedsValue > 0) {
        bedString = [NSString stringWithFormat:@"%i+ Beds",bedsValue];
        [titleComponents addObject:bedString];
    }
    
    NSString *bathString = @"";
    NSInteger bathValue = listingParameters.minBathroom ? [listingParameters.minBathroom intValue] : 0;
    
    if (bathValue > 0) {
        bathString = [NSString stringWithFormat:@"%i+ Baths",bathValue];
        [titleComponents addObject:bathString];
    }
    
    NSString *sqftString = @"";
    NSInteger sqftValue = listingParameters.minSqft ? [listingParameters.minSqft intValue] : 0;
    
    if (sqftValue > 0) {
        sqftString = [NSString stringWithFormat:@"%i+ sqft",sqftValue];
        [titleComponents addObject:sqftString];
    }
    
    managedSearch.title = [titleComponents componentsJoinedByString:@" | "];
    
    return managedSearch;
    
}


- (void)migrateTruliaDataStoreToIosCore {
    
    //migrate from pre-4.0 versions if necessary...
    if (![TruliaDataController persistentStoreExists]) {
        [[TruliaDataController sharedController] migrateLegacyDataIfNeeded];
        [[TruliaDataController sharedController] saveMainContext];
    }
    
        
    NSArray *favoriteProperties = [TruliaBaseProperty allFavoritePropertiesInContext:[[TruliaDataController sharedController] mainContext]];
    for (TruliaBaseProperty *truliaBaseProperty in favoriteProperties) {
        
        NSLog(@"truliaBaseProperty: %@", truliaBaseProperty);
        
        @try {
            ICManagedListing *managedListing = [self managedListingFromTruliaBaseProperty:truliaBaseProperty];
            [managedListing setIsFollowing:YES];
        }
        @catch (NSException *exception) {
            GRLog(@"exception: %@", exception);
        }
        
    }
    
    
    NSArray *favoriteSearches = [TruliaSearchParameters allFavoriteSearchesInContext:[[TruliaDataController sharedController] mainContext]];
    for (TruliaSearchParameters *favoriteSearch in favoriteSearches) {
        
        NSLog(@"favoriteSearch: %@", favoriteSearch);
        
        @try {
            ICManagedSearch *managedSearch = [self managedSearchFromTruliaBaseProperty:favoriteSearch];
            [managedSearch setIsFollowing:YES];
        }
        @catch (NSException *exception) {
            GRLog(@"exception: %@", exception);
        }
        
    }
    
    
    NSArray *recentSearches = [TruliaSearchParameters allRecentSearchesInContext:[[TruliaDataController sharedController] mainContext]];
    for (TruliaSearchParameters *recentSearch in recentSearches) {
        
        NSLog(@"favoriteSearch: %@", recentSearch);
        
        @try {
            ICManagedSearch *managedSearch = [self managedSearchFromTruliaBaseProperty:recentSearch];
            [managedSearch setIsHistory:YES];
        }
        @catch (NSException *exception) {
            GRLog(@"exception: %@", exception);
        }
        
        
        
    }
    
    [[ICCoreDataController sharedInstance] saveWithNotification:NO];
    
    
    [TruliaDataController cleanup];
    
        
}


@end
