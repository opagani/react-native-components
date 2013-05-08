// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TruliaBaseProperty.h instead.

#import <CoreData/CoreData.h>


@class TruliaSearchParameters;
@interface TruliaBasePropertyID : NSManagedObjectID {}
@end

@interface _TruliaBaseProperty : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TruliaBasePropertyID*)objectID;


@property (nonatomic, strong) NSNumber * currentSearchIndex;
@property (nonatomic, strong) TruliaSearchParameters * currentSearch;

@property (nonatomic, strong) NSNumber *squareFeetMaximum;

@property int squareFeetMaximumValue;
- (int)squareFeetMaximumValue;
- (void)setSquareFeetMaximumValue:(int)value_;

//- (BOOL)validateSquareFeetMaximum:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *mlsId;

//- (BOOL)validateMlsId:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *city;

//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *toBeUnfavorited;

@property BOOL toBeUnfavoritedValue;
- (BOOL)toBeUnfavoritedValue;
- (void)setToBeUnfavoritedValue:(BOOL)value_;

//- (BOOL)validateToBeUnfavorited:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDate *datePushed;

//- (BOOL)validateDatePushed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *priceMinimum;

@property int priceMinimumValue;
- (int)priceMinimumValue;
- (void)setPriceMinimumValue:(int)value_;

//- (BOOL)validatePriceMinimum:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *siteUrl;

//- (BOOL)validateSiteUrl:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *streetDisplay;

//- (BOOL)validateStreetDisplay:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSData *priceHistoryData;

//- (BOOL)validatePriceHistoryData:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *neighborhood;

//- (BOOL)validateNeighborhood:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *streetNumber;

//- (BOOL)validateStreetNumber:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *listingType;

//- (BOOL)validateListingType:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSData *contactData;

//- (BOOL)validateContactData:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDecimalNumber *yearBuilt;

//- (BOOL)validateYearBuilt:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *thumbnailUrl;

//- (BOOL)validateThumbnailUrl:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *thumbnailUrlLarge;

//- (BOOL)validateThumbnailUrlLarge:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDate *priceChangeDate;

//- (BOOL)validatePriceChangeDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *cityDisplay;

//- (BOOL)validateCityDisplay:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *providedByName;

//- (BOOL)validateProvidedByName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *brokerName;

//- (BOOL)validateBrokerName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *squareFeet;

@property int squareFeetValue;
- (int)squareFeetValue;
- (void)setSquareFeetValue:(int)value_;

//- (BOOL)validateSquareFeet:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *priceMaximum;

@property int priceMaximumValue;
- (int)priceMaximumValue;
- (void)setPriceMaximumValue:(int)value_;

//- (BOOL)validatePriceMaximum:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *status;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDecimalNumber *longitude;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *zipCode;

//- (BOOL)validateZipCode:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *propertyId;

@property long long propertyIdValue;
- (long long)propertyIdValue;
- (void)setPropertyIdValue:(long long)value_;

//- (BOOL)validatePropertyId:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *longDescription;

//- (BOOL)validateLongDescription:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *lotSize;

//- (BOOL)validateLotSize:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *indexType;

//- (BOOL)validateIndexType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber *bathroomsFull;

@property int bathroomsFullValue;
- (int)bathroomsFullValue;
- (void)setBathroomsFullValue:(int)value_;

@property (nonatomic, strong) NSNumber *bathroomsPartial;

@property int bathroomsPartialValue;
- (int)bathroomsPartialValue;
- (void)setBathroomsPartialValue:(int)value_;


@property (nonatomic, strong) NSNumber *bedrooms;

@property int bedroomsValue;
- (int)bedroomsValue;
- (void)setBedroomsValue:(int)value_;

//- (BOOL)validateBedrooms:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDecimalNumber *priceChangeAmount;

//- (BOOL)validatePriceChangeAmount:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *state;

//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDecimalNumber *price;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *floorPlanCount;

@property int floorPlanCountValue;
- (int)floorPlanCountValue;
- (void)setFloorPlanCountValue:(int)value_;

//- (BOOL)validateFloorPlanCount:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDecimalNumber *bathrooms;

//- (BOOL)validateBathrooms:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDecimalNumber *latitude;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *address;

//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDate *savedToFavoritesDate;

//- (BOOL)validateSavedToFavoritesDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *street;

//- (BOOL)validateStreet:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *bedroomsMaximum;

@property int bedroomsMaximumValue;
- (int)bedroomsMaximumValue;
- (void)setBedroomsMaximumValue:(int)value_;

//- (BOOL)validateBedroomsMaximum:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *shallBeMassDeleted;

@property BOOL shallBeMassDeletedValue;
- (BOOL)shallBeMassDeletedValue;
- (void)setShallBeMassDeletedValue:(BOOL)value_;

//- (BOOL)validateShallBeMassDeleted:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *isFavorite;

@property BOOL isFavoriteValue;
- (BOOL)isFavoriteValue;
- (void)setIsFavoriteValue:(BOOL)value_;

//- (BOOL)validateIsFavorite:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDecimalNumber *bathroomsMaximum;

//- (BOOL)validateBathroomsMaximum:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *bedroomsMinimum;

@property int bedroomsMinimumValue;
- (int)bedroomsMinimumValue;
- (void)setBedroomsMinimumValue:(int)value_;

//- (BOOL)validateBedroomsMinimum:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *county;

//- (BOOL)validateCounty:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDecimalNumber *bathroomsMinimum;

//- (BOOL)validateBathroomsMinimum:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *propertyType;

//- (BOOL)validatePropertyType:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDate *syncDate;

//- (BOOL)validateSyncDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSData *floorPlanData;

//- (BOOL)validateFloorPlanData:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *cityState;

//- (BOOL)validateCityState:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *communityName;

//- (BOOL)validateCommunityName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *squareFeetMinimum;

@property int squareFeetMinimumValue;
- (int)squareFeetMinimumValue;
- (void)setSquareFeetMinimumValue:(int)value_;

//- (BOOL)validateSquareFeetMinimum:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDate *dateListed;

//- (BOOL)validateDateListed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString *apartmentNumber;

//- (BOOL)validateApartmentNumber:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDate *dateSold;

//- (BOOL)validateDateSold:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSNumber *isHistory;

@property BOOL isHistoryValue;
- (BOOL)isHistoryValue;
- (void)setIsHistoryValue:(BOOL)value_;

//- (BOOL)validateIsHistory:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDate *loggedToHistoryDate;

//- (BOOL)validateLoggedToHistoryDate:(id*)value_ error:(NSError**)error_;




@end

@interface _TruliaBaseProperty (CoreDataGeneratedAccessors)

@end
