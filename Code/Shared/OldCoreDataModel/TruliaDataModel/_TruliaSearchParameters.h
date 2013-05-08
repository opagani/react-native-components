// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TruliaSearchParameters.h instead.

#import <CoreData/CoreData.h>
#import "TruliaBaseProperty.h"


@interface TruliaSearchParametersID : NSManagedObjectID {}
@end

@interface _TruliaSearchParameters : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TruliaSearchParametersID*)objectID;


@property (nonatomic, strong) NSDecimalNumber *centroidLatitude;
@property (nonatomic, strong) NSDecimalNumber *centroidLongitude;

@property (nonatomic, strong) NSSet* currentProperties;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *freeSearchText;
@property (nonatomic, strong) NSString *truliaURI;
@property (nonatomic, strong) NSString *mlsId;

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *neighborhood;
@property (nonatomic, strong) NSString *county;

@property (nonatomic, strong) NSData *propertyTypesData;

@property (nonatomic, strong) NSNumber *openHomeTime;

@property int openHomeTimeValue;
- (int)openHomeTimeValue;
- (void)setOpenHomeTimeValue:(int)value_;

//- (BOOL)validateOpenHomeTime:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDecimalNumber *minLongitude;

//- (BOOL)validateMinLongitude:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDecimalNumber *minLatitude;

//- (BOOL)validateMinLatitude:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *nearbyCity;

//- (BOOL)validateNearbyCity:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *state;

//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *toBeUnfavorited;

@property BOOL toBeUnfavoritedValue;
- (BOOL)toBeUnfavoritedValue;
- (void)setToBeUnfavoritedValue:(BOOL)value_;

//- (BOOL)validateToBeUnfavorited:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *lookUpLocation;

@property BOOL lookUpLocationValue;
- (BOOL)lookUpLocationValue;
- (void)setLookUpLocationValue:(BOOL)value_;

//- (BOOL)validateLookUpLocation:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *bathroomsMinimum;

@property int bathroomsMinimumValue;
- (int)bathroomsMinimumValue;
- (void)setBathroomsMinimumValue:(int)value_;

//- (BOOL)validateBathroomsMinimum:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *searchFromCurrentLocation;

@property BOOL searchFromCurrentLocationValue;
- (BOOL)searchFromCurrentLocationValue;
- (void)setSearchFromCurrentLocationValue:(BOOL)value_;

//- (BOOL)validateSearchFromCurrentLocation:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *sqrftIndex;

@property int sqrftIndexValue;
- (int)sqrftIndexValue;
- (void)setSqrftIndexValue:(int)value_;

//- (BOOL)validateSqrftIndex:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDecimalNumber *soldWithinMonths;

//- (BOOL)validateSoldWithinMonths:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *bedroomsMinimum;

@property int bedroomsMinimumValue;
- (int)bedroomsMinimumValue;
- (void)setBedroomsMinimumValue:(int)value_;

//- (BOOL)validateBedroomsMinimum:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDate *searchDate;

//- (BOOL)validateSearchDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *nearbyState;

//- (BOOL)validateNearbyState:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDecimalNumber *maxLongitude;

//- (BOOL)validateMaxLongitude:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *rentMinimum;

@property int rentMinimumValue;
- (int)rentMinimumValue;
- (void)setRentMinimumValue:(int)value_;

//- (BOOL)validateRentMinimum:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDecimalNumber *maxLatitude;

//- (BOOL)validateMaxLatitude:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDate *savedToFavoritesDate;

//- (BOOL)validateSavedToFavoritesDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *criteriaString;

@property (nonatomic, strong) NSString *searchHash;

//- (BOOL)validateSearchHash:(id*)value_ error:(NSError**)error_;


@property (nonatomic, strong) NSNumber *daysSincePriceReduction;

@property int daysSincePriceReductionValue;
- (int)daysSincePriceReductionValue;
- (void)setDaysSincePriceReductionValue:(int)value_;

//- (BOOL)validateDaysSincePriceReduction:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *petsAllowed;

//- (BOOL)validatePetsAllowed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *priceMaximum;

@property int priceMaximumValue;
- (int)priceMaximumValue;
- (void)setPriceMaximumValue:(int)value_;

//- (BOOL)validatePriceMaximum:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *nearbyZip;

//- (BOOL)validateNearbyZip:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *unsupportedParameters;

//- (BOOL)validateUnsupportedParameters:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *zip;

//- (BOOL)validateZip:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDate *loggedToHistoryDate;

//- (BOOL)validateLoggedToHistoryDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDate *syncDate;

//- (BOOL)validateSyncDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *sortMethodIndex;

@property int sortMethodIndexValue;
- (int)sortMethodIndexValue;
- (void)setSortMethodIndexValue:(int)value_;

//- (BOOL)validateSortMethodIndex:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *city;

//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *searchId;

@property int searchIdValue;
- (int)searchIdValue;
- (void)setSearchIdValue:(int)value_;

//- (BOOL)validateSearchId:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *isHistory;

@property BOOL isHistoryValue;
- (BOOL)isHistoryValue;
- (void)setIsHistoryValue:(BOOL)value_;

//- (BOOL)validateIsHistory:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *rentMaximum;

@property int rentMaximumValue;
- (int)rentMaximumValue;
- (void)setRentMaximumValue:(int)value_;

//- (BOOL)validateRentMaximum:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *shallBeMassDeleted;

@property BOOL shallBeMassDeletedValue;
- (BOOL)shallBeMassDeletedValue;
- (void)setShallBeMassDeletedValue:(BOOL)value_;

//- (BOOL)validateShallBeMassDeleted:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *priceMinimum;

@property int priceMinimumValue;
- (int)priceMinimumValue;
- (void)setPriceMinimumValue:(int)value_;

//- (BOOL)validatePriceMinimum:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *isFavorite;

@property BOOL isFavoriteValue;
- (BOOL)isFavoriteValue;
- (void)setIsFavoriteValue:(BOOL)value_;

//- (BOOL)validateIsFavorite:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *indexType;

//- (BOOL)validateIndexType:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *listingType;

//- (BOOL)validateListingType:(id*)value_ error:(NSError**)error_;




@end

@interface _TruliaSearchParameters (CoreDataGeneratedAccessors)
- (void)addCurrentPropertiesObject:(TruliaBaseProperty *)value;
- (void)removeCurrentPropertiesObject:(TruliaBaseProperty *)value;
- (void)addCurrentProperties:(NSSet *)value;
- (void)removeCurrentProperties:(NSSet *)value;
@end
