//
//  TruliaSearchParameters.h
//  Trulia
//
//  Created by Bill Kunz on 5/29/10.
//  Copyright 2010 Trulia, Inc. All rights reserved.
//
//  This class's superclass was generated and maintained by Wolf Rentzch's mogenerator + Xmo'd toolkit.
//  Said superclass could be regenerated from the .xcdatamodel file using Xcode if you choose to not reuse this toolkit.
//

#import "_TruliaSearchParameters.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

typedef enum {
	TruliaSearchParametersOpenHouseAny = 0,
	TruliaSearchParametersOpenHouseNone = 1,
	TruliaSearchParametersOpenHouseAll = 2,
	TruliaSearchParametersOpenHouseToday = 3,
	TruliaSearchParametersOpenHouseWeekend = 4,
} TruliaSearchParametersOpenHouse;

typedef enum {
	TruliaSearchParametersLocationTypeMyLocation = 0,
	TruliaSearchParametersLocationTypeMapLocation,
	TruliaSearchParametersLocationTypeInputLocation,
	TruliaSearchParametersLocationTypeUnknownLocation
} TruliaSearchParametersLocationType;


typedef enum {
    TruliaSearchPropertyTypeAll = 0,
    TruliaSearchPropertyTypeSingleFamilyHome,
    TruliaSearchPropertyTypeCondo,
    TruliaSearchPropertyTypeTownhouse,
    TruliaSearchPropertyTypeCoop,
    TruliaSearchPropertyTypeApartment,
    TruliaSearchPropertyTypeLoft,
    TruliaSearchPropertyTypeTIC,
    TruliaSearchPropertyTypeAptCondoTownhouse,
    TruliaSearchPropertyTypeMobile,
    TruliaSearchPropertyTypeFarm,
    TruliaSearchPropertyTypeLot,
    TruliaSearchPropertyTypeMultiFamilyHome,
    TruliaSearchPropertyTypeIncomeInvestment,
    TruliaSearchPropertyTypeHouseboat,
    TruliaSearchPropertyTypeUnknown,
    NUM_TRULIA_SEARCH_PROPERTY_TYPES
} TruliaSearchPropertyType;

typedef enum {
    TruliaSearchStatusCodeNone = -1,
    TruliaSearchStatusCodeSuccess = 0, 
    TruliaSearchStatusCodeNoLocationMatchFound = 2001,
    TruliaSearchStatusCodeLocationTooLarge = 2002
} TruliaSearchStatusCode;


@interface TruliaSearchParameters : _TruliaSearchParameters {

}


+ (void)deleteAllSearches:(BOOL)favoritesOnly inContext:(NSManagedObjectContext *)moc;

+ (NSArray *)allFavoriteSearchesInContext:(NSManagedObjectContext *)moc;
+ (NSArray *)allRecentSearchesInContext:(NSManagedObjectContext *)moc;

- (NSString *)locationStringWithStaticLocations:(BOOL)includeStaticLocations includeNearbyLocations:(BOOL)includeNearbyLocations includeNearbyPrefix:(BOOL)includeNearbyPrefix;
- (NSString *)freeSearchTextOrCityStateWithStaticLocations:(BOOL)includeStaticLocations includeNearbyLocations:(BOOL)includeNearbyLocations includeNearbyPrefix:(BOOL)includeNearbyPrefix;

@end
