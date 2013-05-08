// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TruliaBaseProperty.m instead.

#import "_TruliaBaseProperty.h"

@implementation TruliaBasePropertyID
@end

@implementation _TruliaBaseProperty

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TruliaBaseProperty" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TruliaBaseProperty";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TruliaBaseProperty" inManagedObjectContext:moc_];
}

- (TruliaBasePropertyID*)objectID {
	return (TruliaBasePropertyID*)[super objectID];
}


@dynamic currentSearchIndex;
@dynamic currentSearch;


@dynamic squareFeetMaximum;



- (int)squareFeetMaximumValue {
	NSNumber *result = [self squareFeetMaximum];
	return result ? [result intValue] : 0;
}

- (void)setSquareFeetMaximumValue:(int)value_ {
	[self setSquareFeetMaximum:[NSNumber numberWithInt:value_]];
}






@dynamic mlsId;







@dynamic city;






@dynamic toBeUnfavorited;



- (BOOL)toBeUnfavoritedValue {
	NSNumber *result = [self toBeUnfavorited];
	return result ? [result boolValue] : 0;
}

- (void)setToBeUnfavoritedValue:(BOOL)value_ {
	[self setToBeUnfavorited:[NSNumber numberWithBool:value_]];
}






@dynamic datePushed;






@dynamic priceMinimum;



- (int)priceMinimumValue {
	NSNumber *result = [self priceMinimum];
	return result ? [result intValue] : 0;
}

- (void)setPriceMinimumValue:(int)value_ {
	[self setPriceMinimum:[NSNumber numberWithInt:value_]];
}






@dynamic siteUrl;






@dynamic streetDisplay;






@dynamic priceHistoryData;






@dynamic neighborhood;






@dynamic streetNumber;






@dynamic listingType;






@dynamic contactData;






@dynamic yearBuilt;






@dynamic thumbnailUrl;
@dynamic thumbnailUrlLarge;






@dynamic priceChangeDate;






@dynamic cityDisplay;






@dynamic providedByName;






@dynamic brokerName;






@dynamic squareFeet;



- (int)squareFeetValue {
	NSNumber *result = [self squareFeet];
	return result ? [result intValue] : 0;
}

- (void)setSquareFeetValue:(int)value_ {
	[self setSquareFeet:[NSNumber numberWithInt:value_]];
}






@dynamic priceMaximum;



- (int)priceMaximumValue {
	NSNumber *result = [self priceMaximum];
	return result ? [result intValue] : 0;
}

- (void)setPriceMaximumValue:(int)value_ {
	[self setPriceMaximum:[NSNumber numberWithInt:value_]];
}






@dynamic status;






@dynamic longitude;






@dynamic zipCode;






@dynamic propertyId;



- (long long)propertyIdValue {
	NSNumber *result = [self propertyId];
	return result ? [result longLongValue] : 0;
}

- (void)setPropertyIdValue:(long long)value_ {
	[self setPropertyId:[NSNumber numberWithLongLong:value_]];
}






@dynamic longDescription;






@dynamic lotSize;






@dynamic indexType;


@dynamic bedrooms;



- (int)bedroomsValue {
	NSNumber *result = [self bedrooms];
	return result ? [result intValue] : 0;
}

- (void)setBedroomsValue:(int)value_ {
	[self setBedrooms:[NSNumber numberWithInt:value_]];
}



@dynamic bathroomsPartial;



- (int)bathroomsPartialValue {
	NSNumber *result = [self bathroomsPartial];
	return result ? [result intValue] : 0;
}

- (void)setBathroomsPartialValue:(int)value_ {
	[self setBathroomsPartial:[NSNumber numberWithInt:value_]];
}


@dynamic bathroomsFull;



- (int)bathroomsFullValue {
	NSNumber *result = [self bathroomsFull];
	return result ? [result intValue] : 0;
}

- (void)setBathroomsFullValue:(int)value_ {
	[self setBathroomsFull:[NSNumber numberWithInt:value_]];
}



@dynamic priceChangeAmount;






@dynamic state;






@dynamic price;






@dynamic floorPlanCount;



- (int)floorPlanCountValue {
	NSNumber *result = [self floorPlanCount];
	return result ? [result intValue] : 0;
}

- (void)setFloorPlanCountValue:(int)value_ {
	[self setFloorPlanCount:[NSNumber numberWithInt:value_]];
}






@dynamic bathrooms;






@dynamic latitude;






@dynamic address;






@dynamic savedToFavoritesDate;






@dynamic street;






@dynamic bedroomsMaximum;



- (int)bedroomsMaximumValue {
	NSNumber *result = [self bedroomsMaximum];
	return result ? [result intValue] : 0;
}

- (void)setBedroomsMaximumValue:(int)value_ {
	[self setBedroomsMaximum:[NSNumber numberWithInt:value_]];
}






@dynamic shallBeMassDeleted;



- (BOOL)shallBeMassDeletedValue {
	NSNumber *result = [self shallBeMassDeleted];
	return result ? [result boolValue] : 0;
}

- (void)setShallBeMassDeletedValue:(BOOL)value_ {
	[self setShallBeMassDeleted:[NSNumber numberWithBool:value_]];
}






@dynamic isFavorite;



- (BOOL)isFavoriteValue {
	NSNumber *result = [self isFavorite];
	return result ? [result boolValue] : 0;
}

- (void)setIsFavoriteValue:(BOOL)value_ {
	[self setIsFavorite:[NSNumber numberWithBool:value_]];
}






@dynamic bathroomsMaximum;






@dynamic bedroomsMinimum;



- (int)bedroomsMinimumValue {
	NSNumber *result = [self bedroomsMinimum];
	return result ? [result intValue] : 0;
}

- (void)setBedroomsMinimumValue:(int)value_ {
	[self setBedroomsMinimum:[NSNumber numberWithInt:value_]];
}






@dynamic county;






@dynamic bathroomsMinimum;






@dynamic propertyType;






@dynamic syncDate;






@dynamic floorPlanData;






@dynamic cityState;






@dynamic communityName;






@dynamic squareFeetMinimum;



- (int)squareFeetMinimumValue {
	NSNumber *result = [self squareFeetMinimum];
	return result ? [result intValue] : 0;
}

- (void)setSquareFeetMinimumValue:(int)value_ {
	[self setSquareFeetMinimum:[NSNumber numberWithInt:value_]];
}






@dynamic dateListed;






@dynamic apartmentNumber;






@dynamic dateSold;






@dynamic isHistory;



- (BOOL)isHistoryValue {
	NSNumber *result = [self isHistory];
	return result ? [result boolValue] : 0;
}

- (void)setIsHistoryValue:(BOOL)value_ {
	[self setIsHistory:[NSNumber numberWithBool:value_]];
}






@dynamic loggedToHistoryDate;








@end
